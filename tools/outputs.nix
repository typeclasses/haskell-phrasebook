{ runCommand, linkFarm, ghc }:

let
  run = name: hsFile:
    {
      inherit name;
      path = runCommand "phrasebook-output-${name}.txt"
        {
          buildInputs = [ ghc ];
          inherit hsFile;
        }
        ''
          runhaskell "$hsFile" > $out
        '';
    };

in

  linkFarm "haskell-phrasebook-outputs" [
    (run "hello-world.txt" ../hello-world.hs)
    (run "common-types.txt" ../common-types.hs)
    (run "variables.txt" ../variables.hs)
  ]
