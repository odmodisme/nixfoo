# The entrypoint for our custom library set.
#
# Take note, this is modularly included as part of the environment so we cannot
# have any functions or references that could make the evaluation go in an
# infinite recursion such as a function that generates a valid nixpkgs module.
# If you have to add those functions, you'll have to add them in configUtils.
{ pkgs }:

let
  inherit (pkgs) lib;
in
pkgs.lib.makeExtensible
(self:
  let
    callLib = file: import file { inherit pkgs lib self; };
  in {
    builders = callLib ./builders.nix;
    trivial = callLib ./trivial.nix;
    data = callLib ./data.nix;

    inherit (self.builders) makeXDGMimeAssociationList makeXDGPortalConfiguration;
    inherit (self.trivial) countAttrs;
    inherit (self.data) importYAML renderTeraTemplate;
  } // lib.optionalAttrs (builtins ? fetchTree) {
    flake = callLib ./flake.nix;

    inherit (self.flake) importFlakeMetadata fetchTree fetchInput;
  })
