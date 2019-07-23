# The Haskell Phrasebook

https://typeclasses.com/phrasebook

## Outputs

In addition to the code examples themselves, the results from running the examples are also included in this repository. An example's output is typically given the same name as its source file, with the extension changed; for example, the output of `hello-world.hs` is given by the file `hello-world.txt`.

When any source code or dependency versions change, run `./generate-outputs`. This script runs all of the examples and updates the output files.

## Using Nix shell

1. [Install Nix][install]

2. Enter a Nix shell:

    ```
    $ nix-shell --pure
    ```

3. Within the Nix shell, you have all of the dependencies required by the examples in the Phrasebook. For example, you can run commands like `runhaskell` and `ghcid`:

    ```
    $ runhaskell hello-world.hs
    hello world
    ```
    
    ```
    $ ghcid --command 'ghci hello-world.hs'
    ``` 

## Nix dependency versions

Run `./update-versions` to update the dependency hashes in `versions.json` to their latest commits. The JSON data is then used by `versions.nix`. This system is described in Vaibhav Sagar's blog post, [*Quick and Easy Nixpkgs Pinning*][vaibhav].

  [install]:
    https://nixos.org/nix/manual/#chap-installation

  [vaibhav]:
    https://vaibhavsagar.com/blog/2018/05/27/quick-easy-nixpkgs-pinning/
