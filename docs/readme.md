# The Haskell Phrasebook

*The Haskell Phrasebook* is a free quick-start Haskell guide comprised of a sequence of small annotated programs. It provides a cursory overview of selected Haskell features, jumping-off points for further reading, and recommendations to help get you writing programs as soon as possible.

This repository contains only the code files; you may find them useful if you want to follow along while reading the *Phrasebook*, which can be found at [typeclasses.com/phrasebook](https://typeclasses.com/phrasebook).

## Using Nix shell

You do not *have to* use Nix to run these Haskell programs, but you may find it convenient.

1. [Install Nix](https://nixos.org/nix/manual/#chap-installation)

2. Enter a Nix shell:

    ```
    $ nix-shell tools/shell.nix
    ```

3. Within the Nix shell, you have all of the dependencies required by the examples in the Phrasebook. For example, you can run commands like `runhaskell` and `ghcid`:

    ```
    $ runhaskell hello-world.hs
    hello world
    ```
    
    ```
    $ ghcid --command 'ghci hello-world.hs' --test ':main'
    ``` 

## Outputs

In addition to the code examples themselves, the results from running the examples are also included in this repository, in the `outputs` directory. An example's output is typically given the same name as its source file, with the extension changed; for example, the output of `hello-world.hs` is given by the file `outputs/hello-world.txt`.

When any source code or dependency versions change, run `./tools/generate-outputs`. This script runs all of the examples and updates the output files.

Any examples that include nondeterministic behavior (such as `threads.hs`) have the nondeterministic portion of their output redacted as "..." to avoid including non-repeatable results in the output files.

## Nix dependency versions

All of the Nix tools are configured to use a specific version of [the Nix package set](https://github.com/nixos/nixpkgs/) to ensure that the code works the same in all environments. This version is specified in `tools/versions.json`.

You can run `./tools/update-versions` to update the dependency hashes in `tools/versions.json` to their latest commits. The JSON data is then used by `tools/versions.nix`. This system is described in Vaibhav Sagar's blog post, [*Quick and Easy Nixpkgs Pinning*](https://vaibhavsagar.com/blog/2018/05/27/quick-easy-nixpkgs-pinning/).

## License

The code in this repository is offered under the Creative Commons [CC BY-NC 4.0](https://creativecommons.org/licenses/by-nc/4.0/) license, which you can read in the [license.txt](license.txt) file.

You are free to:

  * **Share** — copy and redistribute the material in any medium or format
  * **Adapt** — remix, transform, and build upon the material

Under the following terms:

  * **Attribution** — You must give appropriate credit, provide a link to the license, and indicate if changes were made. You may do so in any reasonable manner, but not in any way that suggests that we endorse you or your use.
  * **NonCommercial** — You may not use the material for commercial purposes.
