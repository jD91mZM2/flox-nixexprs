# flox version of stdenv.mkDerivation, enhanced to provide all the
# magic required to locate source, version and build number from
# metadata cached by the nixpkgs mechanism.

{ stdenv, meta }:

# Arguments provided to flox.mkDerivation()
{ project	# the name of the project, required
, ... } @ args:

# Actually create the derivation.
stdenv.mkDerivation ( args // {
  inherit (meta.getBuilderSource project args) version src name src_json;

  # This for one sets meta.position to where the project is defined
  pos = builtins.unsafeGetAttrPos "project" args;

  # Create .flox.json file in root of package dir to record
  # details of package inputs.
  postInstall = toString (args.postInstall or "") + ''
    mkdir -p $out
    echo $src_json > $out/.flox.json
  '';
} )
