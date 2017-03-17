(defun tudurom/split-horiz-and-focus ()
  "Split pane horizontally and focus it"
  (interactive)
  (split-window-horizontally)
  (other-window 1))

(defun tudurom/split-vert-and-focus ()
  "Split pane vertically and focus it"
  (interactive)
  (split-window-vertically)
  (other-window 1))

(defun tudurom/exec (command)
  "Execute COMMAND and return stdout without trailing whitespace."
  (replace-regexp-in-string "\n$" ""
                            (shell-command-to-string command)))
