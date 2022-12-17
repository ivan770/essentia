inputs: self: super: {
  linuxPackages_latest = super.linuxPackages_latest.extend (lnew: lold: {
    rtl8821ce = lold.rtl8821ce.overrideAttrs (new: old: {
      src = super.fetchFromGitHub {
        owner = "tomaspinho";
        repo = "rtl8821ce";
        rev = "50c1b120b06a3b0805e23ca9a4dbd274d74bb305";
        sha256 = "sha256-/85ry2KLdfPmAbAsL9s9pqyONBEDvzgJXnfZm/WquiU=";
      };

      patches = [
        (super.fetchpatch {
          url = "https://github.com/tomaspinho/rtl8821ce/pull/308.patch";
          sha256 = "sha256-ZdDEXdlQ4cHSrTLeROeiWwF2iVECuhxZtaSQ2q8nGHQ=";
        })
      ];
    });
  });
}
