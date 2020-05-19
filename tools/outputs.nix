{ runCommand, linkFarm, haskell, lib }:

let
    run = name: hsFile: { args ? [], pipes ? [] }: {
        name = "${name}.txt";
        path = runCommand "phrasebook-output-${name}.txt" { buildInputs = [ haskell ]; } ''
            ln -s ${hsFile} ${name}.hs
            runhaskell ${lib.escapeShellArgs (["--"] ++ ghcOptions ++ ["--"] ++ ["${name}.hs"] ++ args)} ${lib.concatMapStringsSep " " (x: "| ${x}") pipes} > $out
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
        (run "bounded-queues" ../bounded-queues.hs { pipes = [(sed "s!^(finish:.*|start: (6|7|8|9|10))$!...!")]; })
        (run "branching" ../branching.hs { pipes = [(sed "s!^It's .* noon$!It's ... noon!")]; })
        (run "common-types" ../common-types.hs {})
        (run "crypto-hashing" ../crypto-hashing.hs {})
        (run "dynamic" ../dynamic.hs {})
        (run "enum-ranges" ../enum-ranges.hs {})
        (run "file-handles" ../file-handles.hs {})
        (run "folding-lists" ../folding-lists.hs {})
        (run "for-loops" ../for-loops.hs {})
        (run "functions" ../functions.hs {})
        (run "hashing" ../hashing.hs {})
        (run "hello-world" ../hello-world.hs {})
        (run "invert" ../invert.hs {})
        (run "mutable-references" ../mutable-references.hs {})
        (run "moments-in-time" ../moments-in-time.hs { pipes = [(sed "s!(Now .*: ).*$!\\1...!")]; })
        (run "monitoring" ../monitoring.hs { args = ["full-demonstration"]; })
        (run "records-with-optics" ../records-with-optics.hs {})
        (run "threads" ../threads.hs { pipes = [(sed "s!^fork.*$!...!")]; })
        (run "timeouts" ../timeouts.hs {})
        (run "transactions" ../transactions.hs { pipes = [(sed "s!\\[.*\\]!...!")]; })
        (run "variables" ../variables.hs {})
    ]
