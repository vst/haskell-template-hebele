# Haskell Project Template

This is an opinionated template for creating Haskell projects. It uses [Nix]
[Flakes], [hpack] and [cabal].

## Features

- Nix flake-based dev/CI shells with a pinned toolchain (nixpkgs + flake-parts).
- hpack-driven Cabal setup (`package.yaml` -> `*.cabal`).
- `cabal-verify` for a full verify pass: format, lint, build, tests, docs.
- Static executable builds for Nix (`justStaticExecutables`) plus a Docker
  image.
- `build-static.sh` for producing a musl-linked static binary via Stack.
- Preconfigured formatting and linting tools (fourmolu, hlint, weeder, stan,
  nixfmt, statix, shfmt, shellcheck, taplo, prettier).
- Template bootstrap script (`run-template.sh`) to rename and configure the
  project.

## Quickstart

Create your repository from this template, clone it on your computer and enter
its directory.

Then run the following to configure your project:

```sh
bash ./run-template.sh
```

It will prompt some questions and configure your project according to your
answers.

Once it is configured, provision `direnv`. You can copy the `.envrc.tmpl`:

```sh
cp .envrc.tmpl .envrc
```

Then, you can run the following command to allow `direnv` to activate the
development environment:

```sh
direnv allow
```

Alternatively, you can simply run the following command to activate the
development environment:

```sh
nix develop
```

Finally, you can remove the `run-template.sh` script:

```sh
rm run-template.sh
```

## Development

To run checks, linters, tests and build the codebase in the development
environment, run:

```sh
cabal-verify
```

You can pass `-c` (or `--clean`) to clean the build artifacts first:

```sh
cabal-verify -c
```

As of Cabal 3.12, you can now run the above as an external `cabal` command:

```sh
cabal verify [-c|--clean]
```

`cabal-verify` is the "all checks" entrypoint. It runs, in order:

- `hpack` to regenerate the `.cabal` file.
- Format/lint for Nix, shell, TOML, Markdown/JSON, and Haskell.
- `cabal build`, a basic `cabal run` (with `--version`), and `cabal test`.
- `weeder` for dead code, `stan` for static analysis, and `cabal haddock`.

The script stops on the first failure and prints the captured output to keep CI
logs readable.

## Static compilation

For a portable, fully static binary (musl-linked), run:

```sh
./build-static.sh
```

This script uses [Docker], [Stack], and [ghc-musl], then compresses the binary
with `upx` and copies it to `/tmp/<exe>-static-<os>-<arch>`.

We keep a `stack.yaml` because Stack is the most reliable way to build a static
musl binary without Nix. The resolver should match the nixpkgs baseline Haskell
package set (and thus the [Stackage LTS] used by nixpkgs) to avoid GHC or
dependency mismatches between Nix and the static build pipeline.

<!-- REFERENCES -->

[Nix]: https://nixos.org
[Flakes]: https://wiki.nixos.org/wiki/Flakes
[hpack]: https://github.com/sol/hpack
[cabal]: https://www.haskell.org/cabal
[Docker]: https://www.docker.com
[Stack]: https://docs.haskellstack.org/en/stable/
[ghc-musl]: https://github.com/benz0li/ghc-musl
[Stackage LTS]: https://www.stackage.org/lts
