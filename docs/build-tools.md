---
title: How to build and run the Phrasebook examples
---

# Build tools

## Haskell language server

If you are using Visual Studio Code, we recommend installing the [Haskell](https://marketplace.visualstudio.com/items?itemName=haskell.haskell) extension. Error messages and other helpful annotations will then appear in the editor.

## Using Nix shell

You do not *have to* use Nix to run these Haskell programs, but you may find it convenient.

1. [Install Nix](https://nixos.org/nix/manual/#chap-installation)

2. Install [Cachix](https://cachix.org/), and add the `typeclasses` cache. This step is optional, but will greatly reduce build time.

    ```sh
    $ nix-env -iA 'cachix' -f 'https://cachix.org/api/v1/install'
    $ cachix use 'typeclasses'
    ```

3. Enter a Nix shell:

    ```sh
    $ nix-shell 'tools/shell.nix'
    ```

4. Within the Nix shell, you have all of the dependencies required by the examples in the Phrasebook. For example, you can run commands like `runhaskell` and `ghcid`:

    ```sh
    [nix-shell]$ ghc --version
    The Glorious Glasgow Haskell Compilation System, version 9.0.1
    ```

    ```sh
    [nix-shell]$ runhaskell 'hello-world.hs'
    hello world
    ```

    ```sh
    [nix-shell]$ ghcid --command 'ghci hello-world.hs' --test ':main'
    ```

## Outputs

In addition to the code examples themselves, the results from running the examples are also included in this repository, in the `outputs` directory. An example's output is typically given the same name as its source file, with the extension changed; for example, the output of `hello-world.hs` is given by the file `outputs/hello-world.txt`.

When any source code or dependency versions change, run `./tools/generate-outputs.hs`. This script runs all of the examples and updates the output files.

Any examples that include nondeterministic behavior (such as `threads.hs`) have the nondeterministic portion of their output redacted as "..." to avoid including non-repeatable results in the output files.

## Nix dependency versions

All of the Nix tools are configured to use a specific version of [the Nix package set](https://github.com/nixos/nixpkgs/) to ensure that the code works the same in all environments. This version is specified in `tools/versions.json`.

You can run `./tools/update-versions` to update the dependency hashes in `tools/versions.json` to their latest commits. The JSON data is then used by `tools/versions.nix`. This system is described in Vaibhav Sagar's blog post, [*Quick and Easy Nixpkgs Pinning*](https://vaibhavsagar.com/blog/2018/05/27/quick-easy-nixpkgs-pinning/).
