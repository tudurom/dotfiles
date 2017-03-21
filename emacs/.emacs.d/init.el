(package-initialize)

(setq custom-file "~/.emacs.d/custom.el")
(load custom-file 'noerror)

(load "~/.emacs.d/private.el")
(load "~/.emacs.d/util.el")
(load "~/.emacs.d/packages")
(load "~/.emacs.d/behavior")
(load "~/.emacs.d/aesthetics")
(load "~/.emacs.d/irc.el")

(server-start)

(defun eat-crunchy ()
  "Eat a freedom crunchy!"
  (interactive)
  (message "This gon' be good"))
