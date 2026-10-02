import hashlib
import json
import re
import shutil
import tempfile
import unittest
from pathlib import Path
from unittest import mock

import update_formulas as updater


class FakeResponse:
    def __init__(self, payload):
        self.payload = payload if isinstance(payload, bytes) else json.dumps(payload).encode()
        self.offset = 0

    def __enter__(self):
        return self

    def __exit__(self, *_args):
        return False

    def read(self, size=-1):
        if size < 0:
            size = len(self.payload) - self.offset
        result = self.payload[self.offset : self.offset + size]
        self.offset += len(result)
        return result


class FixtureOpener:
    def __init__(self, metadata, assets):
        self.metadata = metadata
        self.assets = assets

    def __call__(self, request, timeout):
        url = request.full_url
        if url.endswith("/releases/latest"):
            repo = url.split("/repos/")[1].split("/releases/latest")[0].split("/")[1]
            return FakeResponse(self.metadata[repo])
        return FakeResponse(self.assets[url])


class UpdateFormulasTest(unittest.TestCase):
    current_versions = {"cartograph": "1.2.3", "gartograph": "2.3.4", "rustograph": "3.4.5"}

    def setUp(self):
        self.tempdir = Path(tempfile.mkdtemp())
        (self.tempdir / "Formula").mkdir()
        for spec in updater.FORMULA_SPECS:
            (self.tempdir / "Formula" / f"{spec.name}.rb").write_text(self.synthetic_formula(spec, self.current_versions[spec.name]))

    def tearDown(self):
        shutil.rmtree(self.tempdir)

    @staticmethod
    def synthetic_formula(spec, version):
        tag = f"{spec.tag_prefix}{version}"
        if spec.name == "cartograph":
            asset = spec.asset_specs[0].name.format(version=version)
            return (
                "class Cartograph < Formula\n"
                f'  url "{updater._release_url(spec, tag, asset)}"\n'
                f'  sha256 "{"0" * 64}"\n'
                "  def install\n"
                '    bin.install "cartograph"\n'
                "  end\n"
                "end\n"
            )
        lines = [f"class {spec.name.title()} < Formula", f'  version "{version}"', "", "  on_macos do", "    if Hardware::CPU.arm?"]
        for platform in ("darwin-arm64", "darwin-amd64"):
            if platform == "darwin-amd64":
                lines.append("    else")
            asset = f"{spec.name}-{version}-{platform}.tar.gz"
            lines.extend([f'      url "{updater._release_url(spec, tag, asset)}"', f'      sha256 "{"0" * 64}"'])
        lines.extend(["    end", "  end", "", "  on_linux do", "    if Hardware::CPU.arm?"])
        for platform in ("linux-arm64", "linux-amd64"):
            if platform == "linux-amd64":
                lines.append("    else")
            asset = f"{spec.name}-{version}-{platform}.tar.gz"
            lines.extend([f'      url "{updater._release_url(spec, tag, asset)}"', f'      sha256 "{"0" * 64}"'])
        lines.extend(["    end", "  end", "", "  def install", f'    bin.install "{spec.name}"', "  end", "end", ""])
        return "\n".join(lines)

    def fixture(self, versions=None):
        if versions is None:
            versions = tuple(self.bump(self.current_versions[spec.name]) for spec in updater.FORMULA_SPECS)
        metadata = {}
        assets = {}
        for spec, version in zip(updater.FORMULA_SPECS, versions):
            tag = f"{spec.tag_prefix}{version}"
            rows = []
            for index, asset_spec in enumerate(spec.asset_specs):
                name = asset_spec.name.format(version=version)
                body = f"{spec.name}-{version}-{index}".encode()
                digest = hashlib.sha256(body).hexdigest()
                url = updater._release_url(spec, tag, name)
                rows.append({"name": name, "browser_download_url": url, "digest": f"sha256:{digest}"})
                assets[url] = body
            metadata[spec.repository] = {"tag_name": tag, "draft": False, "prerelease": False, "assets": rows}
        return FixtureOpener(metadata, assets), metadata, assets

    @staticmethod
    def bump(version):
        major, minor, patch = (int(part) for part in version.split("."))
        return f"{major}.{minor}.{patch + 1}"

    def set_hashes_from_metadata(self, metadata):
        for spec in updater.FORMULA_SPECS:
            formula = self.tempdir / "Formula" / f"{spec.name}.rb"
            content = formula.read_text()
            old_hashes = re.findall(r'(?m)^(?:  |      )sha256 "([0-9a-f]{64})"$', content)
            for old, asset in zip(old_hashes, metadata[spec.repository]["assets"]):
                content = content.replace(old, asset["digest"][7:], 1)
            formula.write_text(content)

    def test_new_releases_are_verified_and_planned(self):
        opener, _metadata, _assets = self.fixture()
        plans = updater.build_plan(self.tempdir, opener=opener)
        expected = [self.bump(self.current_versions[spec.name]) for spec in updater.FORMULA_SPECS]
        self.assertEqual([plan.release_version for plan in plans], expected)
        self.assertTrue(all(plan.changed for plan in plans))
        self.assertIn(f'version "{expected[1]}"', plans[1].updated_content)
        self.assertIn(f"gartograph-{expected[1]}-linux-amd64.tar.gz", plans[1].updated_content)

    def test_current_releases_are_a_no_op(self):
        versions = tuple(self.current_versions[spec.name] for spec in updater.FORMULA_SPECS)
        opener, metadata, _assets = self.fixture(versions)
        self.set_hashes_from_metadata(metadata)
        plans = updater.build_plan(self.tempdir, opener=opener)
        self.assertEqual([plan.changed for plan in plans], [False, False, False])

    def test_missing_duplicate_and_foreign_assets_fail(self):
        opener, metadata, _assets = self.fixture()
        metadata["gartograph"]["assets"].pop()
        with self.assertRaisesRegex(updater.UpdateError, "missing release asset"):
            updater.build_plan(self.tempdir, opener=opener)

        opener, metadata, _assets = self.fixture()
        metadata["cartograph"]["assets"].append(dict(metadata["cartograph"]["assets"][0]))
        with self.assertRaisesRegex(updater.UpdateError, "duplicate release asset"):
            updater.build_plan(self.tempdir, opener=opener)

        opener, metadata, _assets = self.fixture()
        metadata["cartograph"]["assets"][0]["browser_download_url"] = "https://example.com/cartograph.tar.gz"
        with self.assertRaisesRegex(updater.UpdateError, "foreign"):
            updater.build_plan(self.tempdir, opener=opener)

    def test_digest_tag_size_and_timeout_failures(self):
        opener, metadata, _assets = self.fixture()
        metadata["cartograph"]["assets"][0].pop("digest")
        with self.assertRaisesRegex(updater.UpdateError, "missing SHA256"):
            updater.build_plan(self.tempdir, opener=opener)

        opener, metadata, _assets = self.fixture()
        metadata["cartograph"]["prerelease"] = True
        with self.assertRaisesRegex(updater.UpdateError, "draft or prerelease"):
            updater.build_plan(self.tempdir, opener=opener)

        opener, metadata, _assets = self.fixture()
        metadata["cartograph"]["tag_name"] = "v9.9.9"
        with self.assertRaisesRegex(updater.UpdateError, "malformed release tag"):
            updater.build_plan(self.tempdir, opener=opener)

        opener, metadata, assets = self.fixture()
        url = metadata["rustograph"]["assets"][0]["browser_download_url"]
        assets[url] = b"different bytes"
        with self.assertRaisesRegex(updater.UpdateError, "SHA256 mismatch"):
            updater.build_plan(self.tempdir, opener=opener)

        opener, _metadata, _assets = self.fixture()
        with self.assertRaisesRegex(updater.UpdateError, "exceeds"):
            updater.build_plan(self.tempdir, opener=opener, max_bytes=1)
        with self.assertRaisesRegex(updater.UpdateError, "finite and greater"):
            updater.build_plan(self.tempdir, opener=opener, timeout=0)

        with self.assertRaisesRegex(updater.UpdateError, "metadata exceeds"):
            updater._get_json("https://api.github.com/test", 1, lambda *_args, **_kwargs: FakeResponse(b"x" * (updater.MAX_METADATA_BYTES + 1)))

    def test_rollback_and_same_version_digest_changes_fail(self):
        rollback = []
        for spec in updater.FORMULA_SPECS:
            major, minor, patch = (int(part) for part in self.current_versions[spec.name].split("."))
            rollback.append(f"{major}.{minor}.{patch - 1}")
        opener, _metadata, _assets = self.fixture(tuple(rollback))
        with self.assertRaisesRegex(updater.UpdateError, "roll back"):
            updater.build_plan(self.tempdir, opener=opener)

        versions = (self.current_versions["cartograph"], self.bump(self.current_versions["gartograph"]), self.bump(self.current_versions["rustograph"]))
        opener, metadata, assets = self.fixture(versions)
        body = b"same version but changed"
        asset = metadata["cartograph"]["assets"][0]
        assets[asset["browser_download_url"]] = body
        asset["digest"] = f"sha256:{hashlib.sha256(body).hexdigest()}"
        with self.assertRaisesRegex(updater.UpdateError, "same-version"):
            updater.build_plan(self.tempdir, opener=opener)

    def test_main_write_applies_verified_plans(self):
        opener, _metadata, _assets = self.fixture()
        plans = updater.build_plan(self.tempdir, opener=opener)
        with mock.patch.object(updater, "build_plan", return_value=plans):
            self.assertEqual(updater.main(["--repo-root", str(self.tempdir), "--write"]), 0)
        for plan in plans:
            self.assertEqual((self.tempdir / "Formula" / f"{plan.spec.name}.rb").read_text(), plan.updated_content)

    def test_main_write_late_failure_does_not_mutate_files(self):
        before = {path: path.read_text() for path in (self.tempdir / "Formula").glob("*.rb")}
        opener, metadata, _assets = self.fixture()
        metadata["rustograph"]["assets"].pop()
        real_build_plan = updater.build_plan
        with mock.patch.object(updater, "build_plan", side_effect=lambda root, **kwargs:
                               real_build_plan(root, opener=opener, **kwargs)):
            self.assertEqual(updater.main(["--repo-root", str(self.tempdir), "--write"]), 2)
        self.assertEqual(before, {path: path.read_text() for path in before})

    def test_unexpected_shape_makes_no_formula_changes(self):
        formula = self.tempdir / "Formula" / "gartograph.rb"
        current = self.current_versions["gartograph"]
        formula.write_text(formula.read_text().replace(f'version "{current}"', f'version "{current}"\n  version "{current}"'))
        before = {path: path.read_text() for path in (self.tempdir / "Formula").glob("*.rb")}
        opener, _metadata, _assets = self.fixture()
        with self.assertRaisesRegex(updater.UpdateError, "unexpected formula shape"):
            updater.build_plan(self.tempdir, opener=opener)
        self.assertEqual(before, {path: path.read_text() for path in before})


if __name__ == "__main__":
    unittest.main()
