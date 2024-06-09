#!/usr/bin/env bash

## Purpose: This script is used to run all the necessary checks and
## tests for the project.

## Fail on any error:
set -e

## Set styles if we are on terminal:
if test -t 1; then
    ## Check if the terminal supports colors:
    ncolors=$(tput colors)

    ## Defines styles:
    if test -n "$ncolors" && test "${ncolors}" -ge 8; then
        _sty_bold="$(tput bold)"
        _sty_underline="$(tput smul)"
        _sty_standout="$(tput smso)"
        _sty_normal="$(tput sgr0)"
        _sty_black="$(tput setaf 0)"
        _sty_red="$(tput setaf 1)"
        _sty_green="$(tput setaf 2)"
        _sty_yellow="$(tput setaf 3)"
        _sty_blue="$(tput setaf 4)"
        _sty_magenta="$(tput setaf 5)"
        _sty_cyan="$(tput setaf 6)"
        _sty_white="$(tput setaf 7)"
    fi
fi

_get_now() {
    t=${EPOCHREALTIME} # remove the decimal separator (s → µs)
    t=${t%???}         # remove the last three digits (µs → ms)
    echo "${t}"
}

_get_diff() {
    printf "scale=3; %s - %s\n" "${2}" "${1}" | bc
}

_print_header() {
    printf "${_sty_bold}${_sty_blue}🔵 Running %s${_sty_normal}" "${1}"
}

_print_success() {
    _start="${1}"
    _until="${2}"
    _elapsed=$(_get_diff "${_start}" "${_until}")
    printf "${_sty_bold}${_sty_green} ✅ %ss${_sty_normal}\n" "${_elapsed}"
}

_hpack() {
    _print_header "hpack (v$(hpack --numeric-version))"
    _start=$(_get_now)
    chronic -- hpack
    _print_success "${_start}" "$(_get_now)"
}

_fourmolu() {
    _print_header "fourmolu (v$(fourmolu --version | head -n1 | cut -d' ' -f2))"
    _start=$(_get_now)
    chronic -- fourmolu --quiet --mode check app/ src/ test/
    _print_success "${_start}" "$(_get_now)"
}

_prettier() {
    _print_header "prettier (v$(prettier --version))"
    _start=$(_get_now)
    chronic -- prettier --check .
    _print_success "${_start}" "$(_get_now)"
}

_nixpkgs_fmt() {
    _print_header "nixpkgs-fmt (v$(nixpkgs-fmt --version 2>&1 | cut -d' ' -f2))"
    _start=$(_get_now)
    chronic -- find . -iname "*.nix" -not -path "*/nix/sources.nix" -exec nixpkgs-fmt --check {} \;
    _print_success "${_start}" "$(_get_now)"
}

_hlint() {
    _print_header "hlint (v$(hlint --numeric-version))"
    _start=$(_get_now)
    chronic -- hlint app/ src/ test/
    _print_success "${_start}" "$(_get_now)"
}

_cabal_build() {
    _print_header "cabal build (v$(cabal --numeric-version))"
    _start=$(_get_now)
    chronic -- cabal build -O0
    _print_success "${_start}" "$(_get_now)"
}

_cabal_run() {
    _print_header "cabal run (v$(cabal --numeric-version))"
    _start=$(_get_now)
    chronic -- cabal run -O0 haskell-template-hebele -- --version
    _print_success "${_start}" "$(_get_now)"
}

_cabal_test() {
    _print_header "cabal test (v$(cabal --numeric-version))"
    _start=$(_get_now)
    chronic -- cabal v1-test
    _print_success "${_start}" "$(_get_now)"
}

_cabal_haddock() {
    _print_header "cabal haddock (v$(cabal --numeric-version))"
    _start=$(_get_now)
    chronic -- cabal haddock -O0 \
        --haddock-quickjump \
        --haddock-hyperlink-source \
        --haddock-html-location="https://hackage.haskell.org/package/\$pkg-\$version/docs"
    _print_success "${_start}" "$(_get_now)"
}

_scr_start=$(_get_now)
_hpack
_fourmolu
_prettier
_nixpkgs_fmt
_hlint
_cabal_build
_cabal_run
_cabal_test
_cabal_haddock
printf "Finished all in %ss" "$(_get_diff "${_scr_start}" "$(_get_now)")"
