#!/usr/bin/env python3
"""Update the three API-impact Homebrew formulas from public GitHub releases."""

from __future__ import annotations

import argparse
import hashlib
import json
import math
import os
import re
import sys
import tempfile
from dataclasses import dataclass
from pathlib import Path
from typing import Any, Callable, Iterable
from urllib.parse import urlsplit
from urllib.request import Request, urlopen


REPO_OWNER = "ictechgy"
API_ROOT = "https://api.github.com"
MAX_DOWNLOAD_BYTES = 512 * 1024 * 1024
MAX_METADATA_BYTES = 2 * 1024 * 1024
DEFAULT_TIMEOUT = 30
SEMVER_RE = re.compile(r"^(0|[1-9][0-9]*)\.(0|[1-9][0-9]*)\.(0|[1-9][0-9]*)$")
SHA256_RE = re.compile(r"^[0-9a-f]{64}$")


class UpdateError(RuntimeError):
    """A release or formula failed a safety check."""


@dataclass(frozen=True)
class AssetSpec:
    name: str
    platform: str


@dataclass(frozen=True)
class FormulaSpec:
    name: str
    repository: str
    tag_prefix: str
    asset_specs: tuple[AssetSpec, ...]


@dataclass(frozen=True)
class AssetPlan:
    name: str
    platform: str
    url: str
    digest: str


@dataclass(frozen=True)
class FormulaPlan:
    spec: FormulaSpec
    current_version: str
    release_version: str
    tag: str
    assets: tuple[AssetPlan, ...]
    content: str
    updated_content: str

    @property
    def changed(self) -> bool:
        return self.current_version != self.release_version


FORMULA_SPECS = (
    FormulaSpec(
        "cartograph",
        "cartograph",
        "",
        (AssetSpec("cartograph-{version}-macos-universal.tar.gz", "macos-universal"),),
    ),
    FormulaSpec(
        "gartograph",
        "gartograph",
        "v",
        tuple(
            AssetSpec(f"gartograph-{{version}}-{platform}.tar.gz", platform)
            for platform in ("darwin-arm64", "darwin-amd64", "linux-arm64", "linux-amd64")
        ),
    ),
    FormulaSpec(
        "rustograph",
        "rustograph",
        "v",
        tuple(
            AssetSpec(f"rustograph-{{version}}-{platform}.tar.gz", platform)
            for platform in ("darwin-arm64", "darwin-amd64", "linux-arm64", "linux-amd64")
        ),
    ),
)


def _version_tuple(version: str) -> tuple[int, int, int]:
    match = SEMVER_RE.fullmatch(version)
    if not match:
        raise UpdateError(f"malformed release version: {version!r}")
    return tuple(int(part) for part in match.groups())  # type: ignore[return-value]


def _release_version(tag: Any, prefix: str) -> tuple[str, str]:
    if not isinstance(tag, str) or not tag.startswith(prefix):
        raise UpdateError(f"malformed release tag: {tag!r}")
    version = tag[len(prefix) :]
    if not SEMVER_RE.fullmatch(version):
        raise UpdateError(f"malformed release tag: {tag!r}")
    return version, tag


def _release_url(spec: FormulaSpec, tag: str, asset_name: str) -> str:
    return f"https://github.com/{REPO_OWNER}/{spec.repository}/releases/download/{tag}/{asset_name}"


def _validate_asset_url(url: Any, expected: str) -> str:
    if not isinstance(url, str) or url != expected:
        raise UpdateError(f"foreign or unexpected asset URL for {expected}")
    parsed = urlsplit(url)
    if parsed.scheme != "https" or parsed.netloc != "github.com" or parsed.query or parsed.fragment:
        raise UpdateError(f"foreign or unexpected asset URL for {expected}")
    return url


def _digest_from_asset(asset: dict[str, Any], asset_name: str) -> str:
    raw_digest = asset.get("digest")
    if not isinstance(raw_digest, str) or not raw_digest.startswith("sha256:"):
        raise UpdateError(f"missing SHA256 release digest for {asset_name}")
    digest = raw_digest.removeprefix("sha256:")
    if not SHA256_RE.fullmatch(digest):
        raise UpdateError(f"malformed SHA256 release digest for {asset_name}")
    return digest


def _get_json(
    url: str,
    timeout: float,
    opener: Callable[..., Any],
) -> dict[str, Any]:
    request = Request(url, headers={"Accept": "application/vnd.github+json", "User-Agent": "homebrew-tap-updater"})
    try:
        with opener(request, timeout=timeout) as response:
            payload = bytearray()
            while True:
                chunk = response.read(64 * 1024)
                if not chunk:
                    break
                if len(payload) + len(chunk) > MAX_METADATA_BYTES:
                    raise UpdateError(f"release metadata exceeds {MAX_METADATA_BYTES} bytes")
                payload.extend(chunk)
            data = json.loads(payload)
    except UpdateError:
        raise
    except Exception as exc:  # pragma: no cover - exact network errors vary by platform
        raise UpdateError(f"failed to fetch release metadata: {exc}") from exc
    if not isinstance(data, dict):
        raise UpdateError("release metadata is not an object")
    return data


def _download_and_verify(
    url: str,
    expected_digest: str,
    timeout: float,
    max_bytes: int,
    opener: Callable[..., Any],
) -> None:
    request = Request(url, headers={"Accept": "application/octet-stream", "User-Agent": "homebrew-tap-updater"})
    digest = hashlib.sha256()
    total = 0
    try:
        with opener(request, timeout=timeout) as response:
            while True:
                chunk = response.read(1024 * 1024)
                if not chunk:
                    break
                total += len(chunk)
                if total > max_bytes:
                    raise UpdateError(f"release asset exceeds {max_bytes} bytes: {url}")
                digest.update(chunk)
    except UpdateError:
        raise
    except Exception as exc:  # pragma: no cover - exact network errors vary by platform
        raise UpdateError(f"failed to download release asset {url}: {exc}") from exc
    actual = digest.hexdigest()
    if actual != expected_digest:
        raise UpdateError(f"SHA256 mismatch for {url}: expected {expected_digest}, got {actual}")


def _extract_formula_version(spec: FormulaSpec, content: str) -> str:
    if spec.name == "cartograph":
        urls = re.findall(r'^  url "([^"]+)"$', content, re.MULTILINE)
        hashes = re.findall(r'^  sha256 "([^"]+)"$', content, re.MULTILINE)
        if len(urls) != 1 or len(hashes) != 1:
            raise UpdateError(f"unexpected formula shape: Formula/{spec.name}.rb")
        match = re.fullmatch(
            rf"https://github\.com/{REPO_OWNER}/{spec.repository}/releases/download/([^/]+)/{spec.name}-(\d+\.\d+\.\d+)-macos-universal\.tar\.gz",
            urls[0],
        )
        if not match or match.group(1) != match.group(2) or not SHA256_RE.fullmatch(hashes[0]):
            raise UpdateError(f"unexpected formula shape: Formula/{spec.name}.rb")
        _version_tuple(match.group(2))
        return match.group(2)

    versions = re.findall(r'^  version "([^"]+)"$', content, re.MULTILINE)
    if len(versions) != 1:
        raise UpdateError(f"unexpected formula shape: Formula/{spec.name}.rb")
    current = versions[0]
    _version_tuple(current)
    expected_urls = {
        _release_url(spec, f"v{current}", asset.name.format(version=current)): asset
        for asset in spec.asset_specs
    }
    found: list[tuple[str, str]] = []
    for url, digest in re.findall(r'^      url "([^"]+)"$\n      sha256 "([^"]+)"$', content, re.MULTILINE):
        if not SHA256_RE.fullmatch(digest):
            raise UpdateError(f"unexpected formula shape: Formula/{spec.name}.rb")
        found.append((url, digest))
    if len(found) != len(spec.asset_specs) or set(url for url, _ in found) != set(expected_urls):
        raise UpdateError(f"unexpected formula shape: Formula/{spec.name}.rb")
    if any(digest == "" for _, digest in found):
        raise UpdateError(f"unexpected formula shape: Formula/{spec.name}.rb")
    return current


def _updated_formula(
    spec: FormulaSpec,
    content: str,
    current_version: str,
    release_version: str,
    assets: tuple[AssetPlan, ...],
) -> str:
    if spec.name == "cartograph":
        asset = assets[0]
        updated = re.sub(r'(?m)^  url "[^"]+"$', f'  url "{asset.url}"', content, count=1)
        return re.sub(r'(?m)^  sha256 "[^"]+"$', f'  sha256 "{asset.digest}"', updated, count=1)
    updated = re.sub(r'(?m)^  version "[^"]+"$', f'  version "{release_version}"', content, count=1)
    for asset in assets:
        replacement = f'      url "{asset.url}"\n      sha256 "{asset.digest}"'
        # Replace the old stanza by platform suffix, retaining surrounding formula text.
        platform = asset.platform
        old_name = f"{spec.name}-{current_version}-{platform}.tar.gz"
        old_pattern = rf'(?m)^      url "https://github\.com/{REPO_OWNER}/{spec.repository}/releases/download/[^/]+/{re.escape(old_name)}"$\n      sha256 "[^"]+"$'
        updated, count = re.subn(old_pattern, replacement, updated, count=1)
        if count != 1:
            raise UpdateError(f"unexpected formula shape while updating Formula/{spec.name}.rb ({platform})")
    return updated


def build_plan(
    repo_root: Path,
    *,
    timeout: float = DEFAULT_TIMEOUT,
    max_bytes: int = MAX_DOWNLOAD_BYTES,
    opener: Callable[..., Any] = urlopen,
) -> tuple[FormulaPlan, ...]:
    if not math.isfinite(timeout) or timeout <= 0:
        raise UpdateError("timeout must be finite and greater than zero")
    if max_bytes <= 0:
        raise UpdateError("max download size must be greater than zero")
    plans: list[FormulaPlan] = []
    for spec in FORMULA_SPECS:
        path = repo_root / "Formula" / f"{spec.name}.rb"
        try:
            content = path.read_text(encoding="utf-8")
        except OSError as exc:
            raise UpdateError(f"failed to read {path}: {exc}") from exc
        current_version = _extract_formula_version(spec, content)
        metadata = _get_json(f"{API_ROOT}/repos/{REPO_OWNER}/{spec.repository}/releases/latest", timeout, opener)
        if metadata.get("draft") is not False or metadata.get("prerelease") is not False:
            raise UpdateError(f"release for {spec.name} is draft or prerelease")
        release_version, tag = _release_version(metadata.get("tag_name"), spec.tag_prefix)
        release_assets = metadata.get("assets")
        if not isinstance(release_assets, list):
            raise UpdateError(f"release assets missing for {spec.name}")
        names: set[str] = set()
        by_name: dict[str, dict[str, Any]] = {}
        for raw_asset in release_assets:
            if not isinstance(raw_asset, dict) or not isinstance(raw_asset.get("name"), str):
                raise UpdateError(f"malformed release asset for {spec.name}")
            name = raw_asset["name"]
            if name in names:
                raise UpdateError(f"duplicate release asset: {name}")
            names.add(name)
            by_name[name] = raw_asset
        assets: list[AssetPlan] = []
        for asset_spec in spec.asset_specs:
            name = asset_spec.name.format(version=release_version)
            raw_asset = by_name.get(name)
            if raw_asset is None:
                raise UpdateError(f"missing release asset: {name}")
            expected_url = _release_url(spec, tag, name)
            url = _validate_asset_url(raw_asset.get("browser_download_url"), expected_url)
            digest = _digest_from_asset(raw_asset, name)
            _download_and_verify(url, digest, timeout, max_bytes, opener)
            assets.append(AssetPlan(name, asset_spec.platform, url, digest))
        if _version_tuple(release_version) < _version_tuple(current_version):
            raise UpdateError(f"release {release_version} would roll back Formula/{spec.name} from {current_version}")
        if release_version == current_version:
            expected = {
                _release_url(spec, tag, asset.name.format(version=release_version)): asset.digest
                for asset in assets
            }
            if spec.name == "cartograph":
                actual_urls = re.findall(r'^  url "([^"]+)"$', content, re.MULTILINE)
                actual_hashes = re.findall(r'^  sha256 "([^"]+)"$', content, re.MULTILINE)
            else:
                actual_urls = re.findall(r'^      url "([^"]+)"$', content, re.MULTILINE)
                actual_hashes = re.findall(r'^      sha256 "([^"]+)"$', content, re.MULTILINE)
            if any(url not in expected for url in actual_urls) or any(expected[url] != digest for url, digest in zip(actual_urls, actual_hashes)):
                raise UpdateError(f"same-version release digest differs from Formula/{spec.name}.rb")
        updated_content = _updated_formula(spec, content, current_version, release_version, tuple(assets))
        plans.append(FormulaPlan(spec, current_version, release_version, tag, tuple(assets), content, updated_content))
    return tuple(plans)


def _write_atomic(path: Path, content: str) -> None:
    fd, temporary = tempfile.mkstemp(prefix=f".{path.name}.", dir=path.parent)
    try:
        with os.fdopen(fd, "w", encoding="utf-8") as handle:
            handle.write(content)
            handle.flush()
            os.fsync(handle.fileno())
        os.replace(temporary, path)
    except Exception:
        try:
            os.unlink(temporary)
        except FileNotFoundError:
            pass
        raise


def _summary(plans: Iterable[FormulaPlan], write: bool) -> dict[str, Any]:
    return {
        "ok": True,
        "write": write,
        "changes": [
            {
                "formula": plan.spec.name,
                "from": plan.current_version,
                "to": plan.release_version,
                "tag": plan.tag,
                "assets": [{"name": asset.name, "url": asset.url, "sha256": asset.digest} for asset in plan.assets],
            }
            for plan in plans
            if plan.changed
        ],
        "unchanged": [plan.spec.name for plan in plans if not plan.changed],
    }


def main(argv: list[str] | None = None) -> int:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--repo-root", type=Path, default=Path(__file__).resolve().parents[1])
    parser.add_argument("--write", action="store_true", help="atomically update formulas after all checks pass")
    parser.add_argument("--timeout", type=float, default=DEFAULT_TIMEOUT)
    args = parser.parse_args(argv)
    try:
        plans = build_plan(args.repo_root, timeout=args.timeout)
        if args.write:
            for plan in plans:
                if plan.changed:
                    _write_atomic(args.repo_root / "Formula" / f"{plan.spec.name}.rb", plan.updated_content)
        print(json.dumps(_summary(plans, args.write), sort_keys=True))
        return 0
    except (OSError, UpdateError) as exc:
        print(json.dumps({"ok": False, "error": str(exc)}, sort_keys=True), file=sys.stderr)
        return 2


if __name__ == "__main__":
    raise SystemExit(main())
