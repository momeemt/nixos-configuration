# Repository Guidelines

## Project Structure & Module Organization

System definitions live in `nix/hosts/<host>` with matching `nix/home/<host>`
manifests and shared modules in `nix/modules`. Reusable tooling is packaged in
`nix/packages`, infrastructure in `terraform/` and `k8s/`, scripts in
`assets/scripts`, and the docs site in `docs/`. Keep sensitive data in
`secrets/` only in encrypted form.

## Build, Test, and Development Commands

Use `nix develop` (or `direnv allow` after `just env`) to enter the pinned
toolchain. Primary commands:

- `nix fmt` – quick formatting check through treefmt.
- `nix run .#treefmt` – apply alejandra, shfmt, yamlfmt, ruff, etc.
- `nix flake check` – evaluate all hosts and run repo checks.
- `just apply` – build and switch the current host configuration.
- `terraform plan -chdir=terraform` – review infra changes.
- `npm run start --prefix docs` / `npm run build --prefix docs` – preview and
  ship docs.

## Coding Style & Naming Conventions

Nix code uses two-space indentation, lowerCamelCase attributes, and kebab-case
directories (e.g., `nix/modules/hosts/services/yabai`). Shell scripts should be
POSIX/Bash, executable, and start with `set -euo pipefail`. Documentation pages
belong in `docs/docs/<slug>.md(x)`. Always run `nix run .#treefmt` before
opening a PR; it bundles alejandra, deadnix, statix, shfmt, stylua, terraform
fmt, mdformat, and actionlint.

## Testing Guidelines

`nix flake check` is the baseline; when touching a machine, also run
`nix build .#darwinConfigurations.<host>.system` or
`nixos-rebuild dry-activate --flake .#<host>` to catch evaluation errors. Docs
changes must pass `npm run build --prefix docs`, and Terraform edits require a
clean `terraform plan`. Keep auxiliary tests next to the component they validate
(e.g., `nix/flakes/tmux-nix/tests`) and follow that placement for new fixtures.

## Commit & Pull Request Guidelines

Use `<type>: <imperative>` commit subjects (`add:`, `fix:`, `chore:`, `docs:`)
consistent with existing history and keep change sets tight. Each PR should
summarize the intent, list the commands you executed (`nix fmt`,
`nix flake check`, host builds, Terraform plan, docs build), and link related
issues. Include screenshots or snippets when altering docs/assets and flag
host-specific or secret-related impacts explicitly.

## Security & Secrets

All secrets are handled by SOPS. Re-encrypt updated files with
`nix run .#encrypt-secrets`, keep key definitions in `nix/lib/publicKeys.nix`,
and update `nix/lib/hm-users.nix` plus `nix run .#updatekeys-secrets` whenever
access changes. Never commit plaintext credentials; instead, reference the
encrypted artifacts from Nix modules, Terraform, or docs.

## Agent-Specific Instructions

Before any task, run `echo $LANG` to confirm the runtime locale and mirror that
language in conversation (e.g., use Japanese when it prints `ja_JP.UTF-8`).
Unless the user requests otherwise, keep source code, docs, and comments in
English.
