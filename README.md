# ictechgy Homebrew Tap

Install `lterm`:

```bash
brew install ictechgy/tap/lterm
```

Install `cartograph`:

```bash
brew install ictechgy/tap/cartograph
```

Or tap explicitly:

```bash
brew tap ictechgy/tap
brew install lterm
```

## Release formula automation

The `cartograph`, `gartograph`, and `rustograph` formulas can be checked and
updated by `.github/workflows/update-formulas.yml`. The scheduled run checks
the latest stable public GitHub release, requires the expected assets and
release SHA256 digests, downloads each asset with a size limit, verifies its
hash, validates the exact candidate formulas with Homebrew on suitable macOS
and Linux runners from a temporary tap, and opens a pull request only when a
newer release is available. Existing versions are never rolled back, and a
changed digest for the same version fails the run.

Run the workflow manually with `dry_run` enabled (the default) to print a JSON
plan without writing formulas or creating a branch. Set it to `false` only when
you want the workflow to create a reviewable pull request. A malformed tag,
missing or duplicate asset, foreign download URL, missing digest, download
hash mismatch, or unexpected formula shape fails before any formula is written.
The verified candidate is passed between jobs as an artifact so the files
tested on both operating systems are exactly the files published in the PR.

Repository Actions settings must allow workflows to create branches and pull
requests with the built-in `GITHUB_TOKEN`; the workflow does not use a PAT,
secrets, direct `main` commits, force pushes, or automatic merging. Token
created pull requests may require the repository's normal workflow approval
before their validation runs.
