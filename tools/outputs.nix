{ runCommand, linkFarm, haskell, lib }:

let
    run = name: hsFile: { sed ? [] }: {
        inherit name;
        path = runCommand "phrasebook-output-${name}.txt" { buildInputs = [ haskell ]; } ''
            runhaskell ${lib.escapeShellArgs (ghcOptions ++ ["${hsFile}"])} ${lib.concatMapStringsSep " " (x: "| sed -e ${lib.escapeShellArg x}") sed} > $out
        '';
    };

    ghcOptions = [
        "-Werror"
        "-Wall"
        "-fno-warn-missing-signatures"
        "-fno-warn-name-shadowing"
        "-fno-warn-type-defaults"
        "-fno-warn-unused-do-bind"
    ];

in
    linkFarm "haskell-phrasebook-outputs" [
        (run "branching.txt" ../branching.hs { sed = ["s!^It's .* noon$!It's ... noon!"]; })
        (run "common-types.txt" ../common-types.hs {})
        (run "crypto-hashing.txt" ../crypto-hashing.hs {})
        (run "dynamic.txt" ../dynamic.hs {})
        (run "for-loops.txt" ../for-loops.hs {})
        (run "hashing.txt" ../hashing.hs {})
        (run "hello-world.txt" ../hello-world.hs {})
        (run "mutable-references.txt" ../mutable-references.hs {})
        (run "representing-enums.txt" ../representing-enums.hs {})
        (run "threads.txt" ../threads.hs { sed = ["s!^fork.*$!...!"]; })
        (run "timeouts.txt" ../timeouts.hs {})
        (run "transactions.txt" ../transactions.hs { sed = ["s!\\[.*\\]!...!"]; })
        (run "variables.txt" ../variables.hs {})
    ]
