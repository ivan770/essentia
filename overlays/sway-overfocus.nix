inputs: self: super: {
  sway-overfocus = super.rustPlatform.buildRustPackage rec {
    pname = "sway-overfocus";
    version = "0.2.3-fix";

    src = super.fetchFromGitHub {
      owner = "korreman";
      repo = pname;
      rev = "v${version}";
      sha256 = "sha256-KHbYlxgrrZdNKJ7R9iVflbbP1c6qohM/NHBSYuzxEt4=";
    };

    cargoSha256 = "sha256-zp6PSu8P+ZUhrqi5Vxpe+z9zBaSkdVQBMGNP0FVOviQ=";

    # There are no tests in this package.
    doCheck = false;

    meta = with super.lib; {
      description = "Better focus navigation for sway and i3 ";
      homepage = "https://github.com/korreman/sway-overfocus";
      license = licenses.mit;
    };
  };
}
