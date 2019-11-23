{ runCommand, linkFarm, haskell, lib }:

let
    run = name: hsFile: { pipes ? [] }: {
        inherit name;
        path = runCommand "phrasebook-output-${name}.txt" { buildInputs = [ haskell ]; } ''
            ${runhaskell "${hsFile}"} ${lib.concatMapStringsSep " " (x: "| ${x}") pipes} > $out
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

    outputName = x: "phrasebook-output-${x}.txt";

    runhaskell = x: "runhaskell ${lib.escapeShellArgs (ghcOptions ++ [x])}";

in
    linkFarm "haskell-phrasebook-outputs" [
        (run "bounded-queues.txt" ../bounded-queues.hs { pipes = [(sed "s!^(finish:.*|start: (6|7|8|9|10))$!...!")]; })
        (run "branching.txt" ../branching.hs { pipes = [(sed "s!^It's .* noon$!It's ... noon!")]; })
        (run "common-types.txt" ../common-types.hs {})
        (run "crypto-hashing.txt" ../crypto-hashing.hs {})
        (run "dynamic.txt" ../dynamic.hs {})
        (run "enum-ranges.txt" ../enum-ranges.hs {})
        (run "file-handles.txt" ../file-handles.hs {})
        (run "for-loops.txt" ../for-loops.hs {})
        (run "functions.txt" ../functions.hs {})
        (run "hashing.txt" ../hashing.hs {})
        (run "hello-world.txt" ../hello-world.hs {})
        (run "invert.txt" ../invert.hs {})
        (run "mutable-references.txt" ../mutable-references.hs {})
        (run "records-with-optics.txt" ../records-with-optics.hs {})
        (run "threads.txt" ../threads.hs { pipes = [(sed "s!^fork.*$!...!")]; })
        (run "moments-in-time.txt" ../moments-in-time.hs { pipes = [(sed "s!(Now .*: ).*$!\\1...!")]; })
        (run "timeouts.txt" ../timeouts.hs {})
        (run "transactions.txt" ../transactions.hs { pipes = [(sed "s!\\[.*\\]!...!")]; })
        (run "variables.txt" ../variables.hs {})

        rec {
            name = "monitoring.txt";
            path = runCommand (outputName name) { buildInputs = [ haskell ]; }
              ''
                # Start the report aggregator in the background
                ${runhaskell "${../monitoring.hs}"} aggregate-reports > $out &

                # Brief delay to make sure the aggregator is started
                sleep 1

                # Send reports to the aggregator
                ${runhaskell "${../monitoring.hs}"} send-demo-reports

                # Stop the aggregator
                kill $!
              '';
        }
    ]
