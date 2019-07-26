# The Haskell Phrasebook

*The Haskell Phrasebook* is a free quick-start Haskell guide comprised of a sequence of small annotated programs. It provides a cursory overview of selected Haskell features, jumping-off points for further reading, and recommendations to help get you writing programs as soon as possible.

This repository contains only the code files; you may find them useful if you want to follow along while reading the *Phrasebook*, which can be found at [typeclasses.com/phrasebook][phrasebook].

## Using Nix shell

1. [Install Nix][install]

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
    $ ghcid --command 'ghci hello-world.hs'
    ``` 

## Outputs

In addition to the code examples themselves, the results from running the examples are also included in this repository, in the `outputs` directory. An example's output is typically given the same name as its source file, with the extension changed; for example, the output of `hello-world.hs` is given by the file `outputs/hello-world.txt`.

When any source code or dependency versions change, run `./tools/generate-outputs`. This script runs all of the examples and updates the output files.

Only the standard output stream (`stdout`) is captured in the output files. Any examples that include nondeterministic behavior (such as `threads.hs`) print the nondeterministic portion of their output to the standard error stream (`stderr`) to avoid including non-repeatable results in the output files.

## Nix dependency versions

Run `./tools/update-versions` to update the dependency hashes in `tools/versions.json` to their latest commits. The JSON data is then used by `tools/versions.nix`. This system is described in Vaibhav Sagar's blog post, [*Quick and Easy Nixpkgs Pinning*][vaibhav].

  [phrasebook]:
    https://typeclasses.com/phrasebook

  [install]:
    https://nixos.org/nix/manual/#chap-installation

  [vaibhav]:
    https://vaibhavsagar.com/blog/2018/05/27/quick-easy-nixpkgs-pinning/
