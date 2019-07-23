{ runCommand, linkFarm, ghc }:

let
  run = name: hsFile:
    {
      name = "${name}.txt";
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
    (run "hello-world" ./hello-world.hs)
  ]
