{
  fetchFromGitea,
  fetchpatch,
  libpulseaudio,
  yambar,
  ...
}:
yambar.overrideAttrs (new: old: {
  version = "1.9";

  src = fetchFromGitea {
    domain = "codeberg.org";
    owner = "dnkl";
    repo = "yambar";
    rev = "8deac539eff21841e17320a798ddef74a3205004";
    hash = "sha256-HhslseU6ta8CTkHiHrNdA127atJ4zNVrk8UDabxuzYc=";
  };

  buildInputs = old.buildInputs ++ [libpulseaudio];

  patches =
    (old.patches or [])
    ++ [
      (fetchpatch {
        url = "https://codeberg.org/dnkl/yambar/pulls/223.diff";
        sha256 = "sha256-Rmoy4KnQtSBts7NMdT1BECWkVOs68VDe7pO8QXikR/E=";
      })
    ];
})
