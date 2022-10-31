inputs: self: super: {
  i3 = super.i3.overrideAttrs (new: old: {
    version = "4.21.1";

    src = super.fetchurl {
      url = "https://i3wm.org/downloads/${old.pname}-${new.version}.tar.xz";
      sha256 = "sha256-7f14EoXGVKBdxtsnLOAwDEQo5vvYddmZZOV94ltBvB4=";
    };
  });
}
