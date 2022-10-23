let
  mkLanguageKeybinding = key: command: lang: {
    inherit key command;
    when = "editorTextFocus && editorLangId == '${lang}'";
  };
in [
  (mkLanguageKeybinding "ctrl+alt+pageup" "rust-analyzer.moveItemUp" "rust")
  (mkLanguageKeybinding "ctrl+alt+pagedown" "rust-analyzer.moveItemDown" "rust")
  (mkLanguageKeybinding "ctrl+shift+j" "-rust-analyzer.joinLines" "rust")

  {
    key = "ctrl+j";
    command = "-workbench.action.togglePanel";
  }
  {
    key = "ctrl+j";
    command = "editor.action.joinLines";
    when = "editorTextFocus";
  }

  {
    key = "ctrl+,";
    command = "-workbench.action.openSettings";
  }

  {
    key = "ctrl+=";
    command = "-workbench.action.zoomIn";
  }
  {
    key = "ctrl+-";
    command = "-workbench.action.zoomOut";
  }
]
