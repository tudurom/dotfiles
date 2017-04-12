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

(defun tudurom/sudo-edit (&optional arg)
  "Edit file as root."
  (interactive "P")
  (if (or arg (not buffer-file-name))
      (find-file (concat "/sudo:root@localhost:"
                         (ido-read-file-name "Find file (as root):")))
    (find-alternate-file (concat "/sudo:root@localhost:" buffer-file-name))))

(defun tudurom/scaffold-solution (proj)
  "Scaffold solution project for CS problem."
  (interactive "sProblem name: ")
  (shell-command (concat "~/bin/scaffoldsolution " proj))
  (switch-to-buffer (find-file-noselect
                     (concat "~/usr/work/problems/" proj "/" proj ".c")))
  (multi-term-dedicated-open))

