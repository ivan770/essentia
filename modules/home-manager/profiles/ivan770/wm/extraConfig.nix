{wayland ? false, ...}: ''
  title_align center
  tiling_drag ${
    if wayland
    then "disable"
    else "off"
  }
''
