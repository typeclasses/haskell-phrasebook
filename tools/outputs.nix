{ runCommand, linkFarm, haskell }:

let
  run = name: hsFile:
    {
      inherit name;
      path = runCommand "phrasebook-output-${name}.txt"
        {
          buildInputs = [ haskell ];
          inherit hsFile;
        }
        ''
          runhaskell "$hsFile" > $out
        '';
    };

in

  linkFarm "haskell-phrasebook-outputs" [
    (run "common-types.txt" ../common-types.hs)
    (run "hashing.txt" ../hashing.hs)
    (run "hello-world.txt" ../hello-world.hs)
    (run "for-loops.txt" ../for-loops.hs)
    (run "threads.txt" ../threads.hs)
    (run "variables.txt" ../variables.hs)
  ]
