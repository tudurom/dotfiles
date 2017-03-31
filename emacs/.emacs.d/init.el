(package-initialize)

(byte-recompile-directory user-emacs-directory 0)

(setq custom-file "~/.emacs.d/custom.el")
(load custom-file 'noerror)

(load "~/.emacs.d/private")
(load "~/.emacs.d/util")
(load "~/.emacs.d/irc")
(load "~/.emacs.d/packages")
(load "~/.emacs.d/behavior")
(load "~/.emacs.d/aesthetics")

(server-start)

(defun eat-crunchy ()
  "Eat a freedom crunchy!"
  (interactive)
  (message "This gon' be good"))
