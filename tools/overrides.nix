self: super: {

aeson-optics = self.callPackage (
    { mkDerivation, aeson, attoparsec, base, base-compat, bytestring
    , optics-core, optics-extra, scientific, stdenv, text
    , unordered-containers, vector, Cabal, cabal-doctest
    }:
    mkDerivation {
      pname = "aeson-optics";
      version = "1.1";
      sha256 = "a8790affbdf061149ebf0d5cf41d86ff4892c0ec21e244dc8101ffa027a4d033";
      revision = "1";
      editedCabalFile = "1ql2zqjcwy744qzydj3gk4qgnj4nzba6j2d5fvi31i5va7vqad2d";
      setupHaskellDepends = [ base Cabal cabal-doctest ];
      libraryHaskellDepends = [
        aeson attoparsec base base-compat bytestring optics-core
        optics-extra scientific text unordered-containers vector
      ];
      homepage = "http://github.com/phadej/aeson-optics";
      description = "Law-abiding optics for aeson";
      license = stdenv.lib.licenses.mit;
    }
) {};

optics = self.callPackage (
    { mkDerivation, array, base, bytestring, containers, criterion
    , inspection-testing, lens, mtl, optics-core, optics-extra
    , optics-th, random, stdenv, tasty, tasty-hunit, template-haskell
    , transformers, unordered-containers, vector
    }:
    mkDerivation {
      pname = "optics";
      version = "0.1";
      sha256 = "930a8c4ddacb0c4c54755c509ff8732fa830096727eeb00f436e7d08b5676cf6";
      libraryHaskellDepends = [
        array base containers mtl optics-core optics-extra optics-th
        transformers
      ];
      testHaskellDepends = [
        base containers inspection-testing mtl optics-core random tasty
        tasty-hunit template-haskell
      ];
      benchmarkHaskellDepends = [
        base bytestring containers criterion lens transformers
        unordered-containers vector
      ];
      description = "Optics as an abstract interface";
      license = stdenv.lib.licenses.bsd3;
    }
) {};

optics-core = self.callPackage (
    { mkDerivation, array, base, containers, stdenv, transformers }:
    mkDerivation {
      pname = "optics-core";
      version = "0.1";
      sha256 = "011fc8fb4480ddcc1d367ed8a646718e52b9d31617dc9e07501ae88ba9dcdb6f";
      libraryHaskellDepends = [ array base containers transformers ];
      description = "Optics as an abstract interface: core definitions";
      license = stdenv.lib.licenses.bsd3;
    }
) {};

optics-extra = self.callPackage (
    { mkDerivation, array, base, bytestring, containers, hashable, mtl
    , optics-core, stdenv, text, transformers, unordered-containers
    , vector
    }:
    mkDerivation {
      pname = "optics-extra";
      version = "0.1";
      sha256 = "efecc1c4d01908e1086b1cc0a5907d5725b7259273a5ca7ac77ff5976aa70bfc";
      libraryHaskellDepends = [
        array base bytestring containers hashable mtl optics-core text
        transformers unordered-containers vector
      ];
      description = "Extra utilities and instances for optics-core";
      license = stdenv.lib.licenses.bsd3;
    }
) {};

optics-th = self.callPackage (
    { mkDerivation, base, containers, mtl, optics-core, stdenv
    , template-haskell, th-abstraction, transformers
    }:
    mkDerivation {
      pname = "optics-th";
      version = "0.1";
      sha256 = "66de28a58cedb9dfccd43a68dd4a4234254f29fb5edb5d8fe462eed8ceed0abb";
      revision = "1";
      editedCabalFile = "034563mm7rdck8xhwjpqig3kj9rzk91s292rwcargbgbpma5ailv";
      libraryHaskellDepends = [
        base containers mtl optics-core template-haskell th-abstraction
        transformers
      ];
      testHaskellDepends = [ base optics-core ];
      description = "Optics construction using TemplateHaskell";
      license = stdenv.lib.licenses.bsd3;
    }
) {};

}
