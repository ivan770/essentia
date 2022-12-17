{
  bison,
  fetchFromGitea,
  flex,
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
    rev = "06bf1273324be1625c020a9e6a9409554491cf42";
    hash = "sha256-81nW9LUn6dCs4LbbUZz+wa5dt5VHeBSbsJj5G98bxAc=";
  };

  mesonFlags =
    old.mesonFlags
    ++ [
      "-Dplugin-pipewire=disabled"
    ];

  buildInputs = old.buildInputs ++ [libpulseaudio];

  nativeBuildInputs = old.nativeBuildInputs ++ [bison flex];
})
