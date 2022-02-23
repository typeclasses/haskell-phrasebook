---
title: How to build and run the Phrasebook examples
---

## Haskell language server

If you are using Visual Studio Code, we recommend installing the [Haskell](https://marketplace.visualstudio.com/items?itemName=haskell.haskell) extension. Error messages and other helpful annotations will then appear in the editor.

## ghcid

If you are not using an editor with integrated language support, [ghcid](https://typeclasses.com/ghci/ghcid) is a good alternative.

```sh
$ ghcid --command 'cabal repl hello-world'
```

## GHCi

To open a REPL, use the "cabal repl" command, giving as an argument the name of the program you want to load.

```sh
$ cabal repl hello-world

λ> main
hello world
```

## Using Nix shell

You do not have to use Nix to run these Haskell programs, but you may find it convenient.

[Install Nix](https://nixos.org/nix/manual/#chap-installation),

Optionally, install [Cachix](https://cachix.org/) and add the `typeclasses` cache. This step is optional, but will greatly reduce build time.

```sh
$ nix-env -iA 'cachix' -f 'https://cachix.org/api/v1/install'
$ cachix use 'typeclasses'
```

Within the Nix shell, you have all of the dependencies required by the examples in the Phrasebook. For example, you can run commands like `runhaskell` and `ghcid`.

```sh
$ nix-shell 'tools/shell.nix'

[nix-shell]$ ghc --version
The Glorious Glasgow Haskell Compilation System, version 9.0.1
```

## Outputs

In addition to the code examples themselves, the results from running the examples are also included in this repository, in the `outputs` directory. An example's output is typically given the same name as its source file, with the extension changed; for example, the output of `hello-world.hs` is given by the file `outputs/hello-world.txt`.

When any source code or dependency versions change, run `./tools/generate-outputs.hs`. This script runs all of the examples and updates the output files.

Any examples that include nondeterministic behavior (such as `threads.hs`) have the nondeterministic portion of their output redacted as "..." to avoid including non-repeatable results in the output files.

## Nix dependency versions

All of the Nix tools are configured to use a specific version of [the Nix package set](https://github.com/nixos/nixpkgs/) to ensure that the code works the same in all environments. This version is specified in `tools/versions.json`.

You can run `./tools/update-versions` to update the dependency hashes in `tools/versions.json` to their latest commits. The JSON data is then used by `tools/versions.nix`. This system is described in Vaibhav Sagar's blog post, [*Quick and Easy Nixpkgs Pinning*](https://vaibhavsagar.com/blog/2018/05/27/quick-easy-nixpkgs-pinning/).
