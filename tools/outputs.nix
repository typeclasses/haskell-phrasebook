{ linkFarm, haskell, lib, system, writeShellScript, coreutils, gnused }:

let

# Each item in this list is an argument for the `phrasebookOutput` function below.
examples = [
    { name = "bounded-queues"; file = ../bounded-queues.hs; sed = "s!^(finish:.*|start: (6|7|8|9|10))$!...!"; }
    { name = "branching"; file = ../branching.hs; sed = "s!^It's .* noon$!It's ... noon!"; }
    { name = "common-types"; file = ../common-types.hs; }
    { name = "crypto-hashing"; file = ../crypto-hashing.hs; }
    { name = "dynamic"; file = ../dynamic.hs; }
    { name = "enum-ranges"; file = ../enum-ranges.hs; }
    { name = "file-handles"; file = ../file-handles.hs; }
    { name = "folding-lists"; file = ../folding-lists.hs; }
    { name = "for-loops"; file = ../for-loops.hs; }
    { name = "functions"; file = ../functions.hs; }
    { name = "hashing"; file = ../hashing.hs; }
    { name = "hello-world"; file = ../hello-world.hs; }
    { name = "invert"; file = ../invert.hs; }
    { name = "logging"; file = ../logging.hs; env.INFO = "info.txt"; env.ERROR = "error.txt"; before = ["touch info.txt" "touch error.txt"]; after = ["echo '\n--- info.txt ---' >> $out" "cat info.txt >> $out"]; }
    { name = "mutable-references"; file = ../mutable-references.hs; }
    { name = "moments-in-time"; file = ../moments-in-time.hs; sed = "s!(Now .*: ).*$!\\1...!"; }
    { name = "monitoring"; file = ../monitoring.hs; args = ["full-demonstration"]; }
    { name = "records-with-optics"; file = ../records-with-optics.hs; }
    { name = "threads"; file = ../threads.hs; sed = "s!^fork.*$!...!"; }
    { name = "timeouts"; file = ../timeouts.hs; }
    { name = "transactions"; file = ../transactions.hs; sed = "s!\\[.*\\]!...!"; }
    { name = "variables"; file = ../variables.hs; }
];

outputs = linkFarm "haskell-phrasebook-outputs" (builtins.map phrasebookOutput examples);

# The output file for a Phrasebook example program.
phrasebookOutput =
    { name # The name of the output file (with no file extension)
    , file # The Haskell source file to run to produce the output
    , args ? [] # List of arguments for the Haskell program
    , sed ? null # A sed script to run on the program output (we use this to filter non-deterministic output from programs that employ concurrency or randomness, so that the derivations contain only consistently reproducible results)
    , env ? {} # Any additional environment variables
    , before ? [] # Any additional shell commands to run after the program
    , after ? [] # Any additional shell commands to run after the program
    }:
    {
        name = "${name}.txt";
        path = runghc {
            inherit name env before after;
            hsFile = file;
            programArgs = args;
            pipes = if sed != null then ["${gnused}/bin/sed -re ${lib.escapeShellArg sed}"] else [];
            ghcArgs = [
                "-Werror"
                "-Wall"
                "-fno-warn-missing-signatures"
                "-fno-warn-name-shadowing"
                "-fno-warn-type-defaults"
                "-fno-warn-unused-do-bind"
                "-fno-warn-unused-imports"
                "-fno-warn-unused-top-binds"
            ];
        };
    };

# A derivation created by running a Haskell file and piping the output to a file
runghc =
    { name # A string that appears as part of the path under /nix/store to help identify what is being built
    , hsFile # The path of the Haskell file to run
    , programArgs ? [] # List of arguments for the Haskell program
    , runghcArgs ? [] # List of arguments for runghc
    , ghcArgs ? [] # List of arguments for GHC
    , pipes ? [] # List of additional shell commands to pipe the output through
    , env ? {} # Any additional environment variables
    , before ? [] # Any additional shell commands to run after the program
    , after ? [] # Any additional shell commands to run after the program
    }:
    derivation {
        name = "runghc-${name}";
        inherit env;
        path = ["${haskell}/bin" "${coreutils}/bin"];
        buildScript =
            let
                commands = before ++ [ linkSource run ] ++ after;
                linkSource = ''${coreutils}/bin/ln -s ${hsFile} ${name}.hs'';
                run = ''${haskell}/bin/runghc ${lib.escapeShellArgs (runghcArgs ++ ["--"] ++ ghcArgs ++ ["--"] ++ ["${name}.hs"] ++ programArgs)} ${lib.concatMapStringsSep " " (x: "| ${x}") pipes} > $out'';
            in
                writeShellScript "builder-for-runghc-${name}" (lib.concatStringsSep "\n" commands);
    };

# A small wrapper around the built-in `derivation` function
derivation =
    { name # A string that appears as part of the path under /nix/store to help identify what is being built
    , buildScript # The shell script used to build the derivation
    , path ? [] # A list of directories to include on the binary path for the build script
    , env ? {} # Any additional environment variables
    }:
    builtins.derivation ({
        inherit name system;
        PATH = lib.concatStringsSep ":" path;
        builder = writeShellScript "builder-for-${name}" buildScript;
    } // env);

in outputs
