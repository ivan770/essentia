{ lib, ... }:

{
  fromJSONWithComments = input: builtins.fromJSON (lib.strings.concatStrings (lib.filter
    (line: !lib.hasPrefix "//" (
      lib.strings.concatStrings (lib.filter (line: line != " ") (lib.strings.stringToCharacters line))
    ))
    (lib.strings.splitString "\n" input)));
}
