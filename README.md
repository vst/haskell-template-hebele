# Haskell Project Template

This is an opinionated template for creating Haskell projects. It uses
[Nix] [Flakes], [hpack] and [cabal].

> **TODO** Provide minimum viable documentation.

## Quickstart

Create your repository from this template, clone it on your computer
and enter its directory.

Then, run following to configure your project:

```sh
bash ./run-template.sh
```

It will prompt some questions and configure your project according to
your answers.

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

And run the big, long build command as given in the next section.

Finally, you can remove the `run-template.sh` script:

```sh
rm run-template.sh
```

## Development

Big, long build command for the impatient:

```sh
hpack &&
    direnv reload &&
    fourmolu -i app/ src/ test/ &&
    prettier --write . &&
    find . -iname "*.nix" -print0 | xargs --null nixpkgs-fmt &&
    hlint app/ src/ test/ &&
    cabal build -O0 &&
    cabal run -O0 haskell-template-hebele -- --version &&
    cabal v1-test &&
    cabal haddock -O0
```

To run checks, linters, tests and build the codebase in the development environment, run:

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

<!-- REFERENCES -->

[Nix]: https://nixos.org
[Flakes]: https://wiki.nixos.org/wiki/Flakes
[hpack]: https://github.com/sol/hpack
[cabal]: https://www.haskell.org/cabal
