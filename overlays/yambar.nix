# Required to fix broken yambar on i3
# See "rev" commit details for more information.
inputs: self: super: {
  yambar = super.yambar.overrideAttrs (new: old: {
    src = super.fetchFromGitea {
      domain = "codeberg.org";
      owner = "dnkl";
      repo = "yambar";
      rev = "c44970717b52c1678b6a8dabdeda2ca75a42cdd5";
      hash = "sha256-57AQHkFQXfo4783VVr05oxqZBFhuPNOoBhqhoZsiJkY=";
    };
  });
}
