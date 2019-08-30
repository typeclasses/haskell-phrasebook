{ runCommand, linkFarm, haskell, lib }:

let
  inherit (lib) concatMapStringsSep escapeShellArg;

  run = name: hsFile: run' name hsFile {};

  run' = name: hsFile: { sed ? [] }:
    {
      inherit name;
      path = runCommand "phrasebook-output-${name}.txt"
        {
          buildInputs = [ haskell ];
          inherit hsFile;
        }
        ''
          runhaskell "$hsFile" ${concatMapStringsSep " " (x: "| sed -e ${escapeShellArg x}") sed} > $out
        '';
    };

in

  linkFarm "haskell-phrasebook-outputs" [
    (run' "branching.txt" ../branching.hs { sed = ["s!^It's .* noon$!It's ... noon!"]; })
    (run "common-types.txt" ../common-types.hs)
    (run "crypto-hashing.txt" ../crypto-hashing.hs)
    (run "for-loops.txt" ../for-loops.hs)
    (run "hashing.txt" ../hashing.hs)
    (run "hello-world.txt" ../hello-world.hs)
    (run "mutable-references.txt" ../mutable-references.hs)
    (run' "threads.txt" ../threads.hs { sed = ["s!^fork.*$!...!"]; })
    (run "timeouts.txt" ../timeouts.hs)
    (run' "transactions.txt" ../transactions.hs { sed = ["s!\\[.*\\]!...!"]; })
    (run "variables.txt" ../variables.hs)
  ]
