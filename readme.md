# The Haskell Phrasebook

https://typeclasses.com/phrasebook

## Using Nix shell

1. [Install Nix][install]

2. Enter a Nix shell:

    ```
    $ nix-shell --pure
    ```

3. Within the Nix shell, you have all of the dependencies required by the examples in the Phrasebook. You can run commands such as:

    ```
    $ runhaskell hello-world.hs
    hello world
    ```
    
    ```
    $ ghcid --command 'ghci hello-world.hs'
    
    ``` 

## Nix dependency versions

The `update-versions` script updates the dependency hashes in `versions.json` to their latest commits. The JSON data is then used by `versions.nix`. This system is described in Vaibhav Sagar's blog post, [*Quick and Easy Nixpkgs Pinning*][vaibhav].

  [install]:
    https://nixos.org/nix/manual/#chap-installation

  [vaibhav]:
    https://vaibhavsagar.com/blog/2018/05/27/quick-easy-nixpkgs-pinning/
