{ ... }:

{
  imports = map (x: import (./configurations/${x})) (builtins.attrNames (builtins.readDir ./configurations));
}
