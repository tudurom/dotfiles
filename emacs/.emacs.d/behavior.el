;;; behavior.el - settings regarding behavior not tied to packages

;; don't clutter the project dir with backups
(defvar backup-dir "~/.emacs.d/backups")
(setq backup-directory-alist (list (cons "." backup-dir)))

(setq-default show-trailing-whitespace t)

;; automatically insert parantheses/quotes etc. (like in most IDEs)
(electric-pair-mode 1)

;; shut up
(setq large-file-warning-threshold nil)

;; tab settings
(setq standard-indent 4)
(setq-default tab-width 4)
(setq-default c-basic-offset 4)

;; tabs instead of spaces.
(setq-default indent-tabs-mode t)

(setq c-default-style
      '((java-mode . "java")
        (awk-mode . "awk")
        (other . "bsd")))

;; cancel actions with escape
(define-key isearch-mode-map [escape] 'isearch-abort)
(global-set-key [escape] 'keyboard-escape-quit)

(add-hook 'emacs-lisp-mode-hook
          (lambda ()
            ;; Use spaces, not tabs.
            (setq indent-tabs-mode nil)
            (setq tab-stop-list (number-sequence 4 120 4))))
