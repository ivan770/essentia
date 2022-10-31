{sway ? false, ...}: ''
  title_align center
  tiling_drag ${
    if sway
    then "disable"
    else "off"
  }
''
