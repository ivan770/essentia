{
  theme = "dark_plus";

  editor = {
    line-number = "absolute";
    mouse = false;
    true-color = true;
    cursorline = true;
    color-modes = true;

    lsp.display-messages = true;
  };

  keys = {
    normal = {
      # WASD instead of HJKL
      w = "move_line_up";
      a = "move_char_left";
      s = "move_line_down";
      d = "move_char_right";

      # More usable word cursors
      W = ["page_up" "align_view_center"];
      A = "move_prev_word_start";
      S = ["page_down" "align_view_center"];
      D = "move_next_word_start";

      # Same Ctrl+{Up, Left, Down, Right} arrows behaviour as in VS Code
      "C-up" = "move_line_up";
      "C-left" = "move_prev_word_start";
      "C-down" = "move_line_down";
      "C-right" = "move_next_word_start";

      # Multi-cursor with Ctrl
      # Cursor collapse on Esc
      "C-w" = "copy_selection_on_prev_line";
      "C-s" = "copy_selection_on_next_line";
      "esc" = "keep_primary_selection";

      # Jump to the beginning and the end of the current line using Ctrl+{A, D}
      "C-a" = "goto_line_start";
      "C-d" = "goto_line_end";

      # Enter insert mode on Q
      q = "insert_mode";

      # Delete on R and replace on Shift+R
      r = "delete_selection";
      R = "change_selection";

      # Search file on Ctrl+F
      "C-f" = "search";

      # Window movement with Alt+{W, A, S, D}
      "A-w" = "jump_view_up";
      "A-a" = "jump_view_left";
      "A-s" = "jump_view_down";
      "A-d" = "jump_view_right";

      # Close window with Alt+Q
      "A-q" = "wclose";

      # Split windows with Alt+{E, F}
      "A-e" = "vsplit";
      "A-f" = "hsplit";
    };

    insert = {
      # Allow Ctrl+{W, A, S, D} movement while being inside Insert mode
      "C-w" = "move_line_up";
      "C-a" = "move_char_left";
      "C-s" = "move_line_down";
      "C-d" = "move_char_right";

      # Ctrl+R to delete selection while being inside Insert mode
      "C-r" = "delete_selection";

      # Same Ctrl+{Up, Left, Down, Right} arrows behaviour as in VS Code
      "C-up" = "move_line_up";
      "C-left" = "move_prev_word_start";
      "C-down" = "move_line_down";
      "C-right" = "move_next_word_start";
    };
  };
}
