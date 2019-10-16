{ runCommand, linkFarm, haskell, lib }:

let
    run = name: hsFile: { pipes ? [] }: {
        inherit name;
        path = runCommand "phrasebook-output-${name}.txt" { buildInputs = [ haskell ]; } ''
            runhaskell ${lib.escapeShellArgs (ghcOptions ++ ["${hsFile}"])} ${lib.concatMapStringsSep " " (x: "| ${x}") pipes} > $out
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

    sed = x: "sed -re ${lib.escapeShellArg x}";

in
    linkFarm "haskell-phrasebook-outputs" [
        (run "bounded-queues.txt" ../bounded-queues.hs { pipes = [(sed "s!^(finish:.*|start: (6|7|8|9|10))$!...!")]; })
        (run "branching.txt" ../branching.hs { pipes = [(sed "s!^It's .* noon$!It's ... noon!")]; })
        (run "common-types.txt" ../common-types.hs {})
        (run "crypto-hashing.txt" ../crypto-hashing.hs {})
        (run "dynamic.txt" ../dynamic.hs {})
        (run "enum-ranges.txt" ../enum-ranges.hs {})
        (run "for-loops.txt" ../for-loops.hs {})
        (run "functions.txt" ../functions.hs {})
        (run "hashing.txt" ../hashing.hs {})
        (run "hello-world.txt" ../hello-world.hs {})
        (run "mutable-references.txt" ../mutable-references.hs {})
        (run "invert.txt" ../invert.hs {})
        (run "threads.txt" ../threads.hs { pipes = [(sed "s!^fork.*$!...!")]; })
        (run "time.txt" ../time.hs { pipes = [(sed "s!(Now .*: ).*$!\\1...!")]; })
        (run "timeouts.txt" ../timeouts.hs {})
        (run "transactions.txt" ../transactions.hs { pipes = [(sed "s!\\[.*\\]!...!")]; })
        (run "variables.txt" ../variables.hs {})
    ]
