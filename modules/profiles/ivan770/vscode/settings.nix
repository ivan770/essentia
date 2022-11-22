{
  lib,
  pkgs,
  ...
}:
with lib; let
  # General VS Code appearance configuration
  appearance = {
    # <3 Blackboard
    "workbench.colorTheme" = "Blackboard";
    "workbench.preferredDarkColorTheme" = "Blackboard";

    # Slightly tune general color theming
    "workbench.colorCustomizations" = {
      "[Blackboard]" = {
        # Tabs and tab container
        "tab.inactiveBackground" = "#000000";
        "editorGroupHeader.tabsBackground" = "#000000";

        # Side bar, its lists and activity bar
        # Side bar = activity bar selected item
        "sideBar.background" = "#000000";
        "sideBarSectionHeader.background" = "#000000";
        "activityBar.background" = "#000000";

        # Title bar
        "titleBar.activeBackground" = "#000000";

        # Status bar
        "statusBar.background" = "#000000";
        "statusBarItem.remoteBackground" = "#000000";

        # Buttons
        "button.secondaryBackground" = "#ffffff1f";

        # Generic menu (like the one that pops up when you click on a gear icon)
        "menu.background" = "#000000";

        # Generic dropdown list
        "dropdown.background" = "#000000";

        # Command palette, file picker and other similar menus
        "quickInput.background" = "#000000";

        # Cursor hover and various selection levels
        "list.hoverBackground" = "#ffffff1f";
        "list.inactiveSelectionBackground" = "#ffffff2f";
        "list.activeSelectionBackground" = "#ffffff3f";

        # Text editors
        "editor.background" = "#000000";

        # Generic text input
        "input.background" = "#000000";

        # Text editor's hover widget
        "editorWidget.background" = "#000000";
      };
    };

    # Move side bar to the right side of the main window
    "workbench.sideBar.location" = "right";

    # Hide menu bar since it looks awful on Sway
    "window.menuBarVisibility" = "hidden";

    # Explicitly specify the usage of native title bar to completely hide
    # window controls on Sway
    "window.titleBarStyle" = "native";

    # Disable layout control since it's useless on Sway
    "workbench.layoutControl.enabled" = false;

    # Use VS Code styled dialog windows
    "window.dialogStyle" = "custom";

    # Use VS Code styled dialog for file/folder picker
    "files.simpleDialog.enable" = true;

    # Make resize border smaller so that it's easier to
    # scroll without accidentally resizing panel
    "workbench.sash.size" = 1;
  };

  # Text editor configuration
  editor = {
    # Font settings
    "editor.fontFamily" = let
      mkFontList = fonts: concatStringsSep "," (map (font: "'${font}'") fonts);
    in
      mkFontList [
        "JetBrains Mono"
        "Consolas"
        "Droid Sans Mono"
        "monospace"
      ];
    "editor.fontLigatures" = true;

    # Mimic IDEA' line height
    "editor.lineHeight" = 20;

    # Disable useless minimap
    "editor.minimap.enabled" = false;

    # Remove independent space characters in code indentation
    "editor.stickyTabStops" = true;

    # Color all brackets without additional extensions
    "editor.bracketPairColorization.enabled" = true;

    # Show normal LSP suggestions first, moving snippets
    # to the end of a suggestion list
    "editor.snippetSuggestions" = "bottom";

    # Provide autocompletion in snippets
    #
    # For example, writing vec.pu<|> and pressing Enter
    # would result in vec.push(<|>) with autocompletion window
    "editor.suggest.snippetsPreventQuickSuggestions" = false;

    # Hide extended diagnostic suggestions
    "editor.suggest.showStatusBar" = false;

    # Show newlines at file ends in diff editor
    "diffEditor.ignoreTrimWhitespace" = false;

    # Disable menu bar shortcuts (example: Alt-F for file menu)
    "window.enableMenuBarMnemonics" = false;

    # Completely disable Alt menu
    "window.customMenuBarAltFocus" = false;

    # Start without any editor if there is nothing to restore
    "workbench.startupEditor" = "none";

    # Disable empty page tips
    "workbench.tips.enabled" = false;

    # Dispatch keybindings using keycodes
    # This behaviour significantly improves VS Code usage with multiple input languages
    "keyboard.dispatch" = "keyCode";
  };

  # File explorer configuration
  files = {
    # Slightly wider file explorer tree
    "workbench.tree.indent" = 18;

    # Disable file previews from a single mouse click
    "workbench.editor.enablePreview" = false;

    # Remove folder tree flattening
    "explorer.compactFolders" = false;

    # Enable file autosaving
    "files.autoSave" = "afterDelay";

    # Disable "soft removal" of files
    "files.enableTrash" = false;

    # Remove file action confirmations
    "explorer.confirmDelete" = false;
    "explorer.confirmDragAndDrop" = false;
  };

  # General terminal configuration
  terminal = {
    # Copy text on selection (mimics Google Cloud Shell behaviour)
    "terminal.integrated.copyOnSelection" = true;
  };

  # General telemetry and online-based features tuning
  # To disable extension telemetry use extension-specific configuration
  telemetry = {
    "extensions.ignoreRecommendations" = true;
    "workbench.enableExperiments" = false;
    "workbench.settings.enableNaturalLanguageSearch" = false;
    "telemetry.telemetryLevel" = "off";

    "extensions.autoUpdate" = false;
    "extensions.autoCheckUpdates" = false;
    "update.mode" = "none";
  };

  # General Git configuration
  git = {
    # Remove git fetch confirmation dialogs
    "git.confirmSync" = false;

    # Stage everything if stage list is empty
    "git.enableSmartCommit" = true;

    # Always sign commits via PGP
    "git.enableCommitSigning" = true;
  };

  # General security configuration
  security = {
    # Disable noisy "trust" feature
    "security.workspace.trust.enabled" = false;
  };

  # Hex editor extension configuration
  hexEditor = {
    # Show more bytes per row
    "hexeditor.columnWidth" = 24;

    # Show ASCII representation of bytes
    "hexeditor.showDecodedText" = true;

    # Default to little-endian endianness since
    # it's used more widely
    "hexeditor.defaultEndianness" = "little";

    # Show additional data information alongside the main editor
    "hexeditor.inspectorType" = "aside";
  };

  # GitLens extension configuration
  gitlens = {
    # Disable GitLens code annotations
    "gitlens.codeLens.enabled" = false;

    # Remove "Git blame" annotations
    "gitlens.currentLine.enabled" = false;

    # Show useful Git stuff when hovering over line
    "gitlens.hovers.currentLine.over" = "line";

    # Remove noisy tutorials
    "gitlens.showWelcomeOnInstall" = false;
  };

  # GitHub extension configuration
  github = {
    # Force SSH usage to clone stuff from GitHub
    "github.gitProtocol" = "ssh";
  };

  # Rust-related configuration
  rust = {
    # Enable proc-macro analysis
    "rust-analyzer.procMacro.enable" = true;

    # Always request up-to-date crates.io metadata
    #
    # Using local metadata leads to spurious Cargo.toml errors
    "crates.useLocalCargoIndex" = false;
  };

  # Go-related configuration
  go = {
    # Online-based features and telemetry removal
    "go.survey.prompt" = false;
    "go.toolsManagement.checkForUpdates" = "off";
  };

  # Julia-related configuration
  julia = {
    # These configuration entries are automatically added by the Julia extension
    "julia.symbolCacheDownload" = true;
    "terminal.integrated.commandsToSkipShell" = [
      "language-julia.interrupt"
    ];

    # Telemetry removal
    "julia.enableTelemetry" = false;
  };

  # Nix-related configuration
  nix = {
    # Activate the usage of nil
    "nix.enableLanguageServer" = true;
    "nix.serverPath" = "${pkgs.nil}/bin/nil";
  };

  # Markdown-related configuration
  markdown = {
    # Increase preview font size
    "markdown.preview.fontSize" = 18;
  };
in
  recursiveMerge [
    appearance
    editor
    files
    terminal
    telemetry
    git
    security

    hexEditor
    gitlens
    github

    rust
    go
    julia
    nix
    markdown
  ]
