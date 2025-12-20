#!/usr/bin/env sh

exec docker run -it -v "$PWD:/work" -w /work --rm nixos/nix
