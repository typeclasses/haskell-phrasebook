let
  inherit ((import <nixpkgs> { }).lib) mapAttrs;
  inherit (builtins) fetchTarball fromJSON readFile;

  fetchFromGitHub = { owner, repo, rev, sha256 }:
    builtins.fetchTarball {
      inherit sha256;
      url = "https://github.com/${owner}/${repo}/archive/${rev}.tar.gz";
    };
in
  mapAttrs (_: fetchFromGitHub) (fromJSON (readFile ./versions.json))
