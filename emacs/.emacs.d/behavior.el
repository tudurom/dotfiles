;;; -*- lexical-binding: t -*-

;;; behavior.el - settings regarding behavior not tied to packages

;; don't clutter the project dir with backups
(defconst tudurom/backup-dir "~/.emacs.d/backups")
(setq backup-directory-alist
      `((".*" . ,tudurom/backup-dir)))
(setq auto-save-file-name-transforms
      `((".*" ,tudurom/backup-dir t)))

(setq-default show-trailing-whitespace nil)
(add-hook 'prog-mode-hook (lambda ()
                            (setq show-trailing-whitespace t)))
(add-hook 'markdown-mode-hook (lambda ()
                                (setq show-trailing-whitespace t)))

;; automatically insert parantheses/quotes etc. (like in most IDEs)
(add-hook 'emacs-lisp-mode-hook (lambda () (electric-pair-mode -1)))
(add-hook 'clojure-mode-hook (lambda () (electric-pair-mode -1)))
(add-hook 'emacs-lisp-mode-hook (lambda () (electric-pair-mode -1)))
(add-hook 'common-lisp-mode-hook (lambda () (electric-pair-mode -1)))
(add-hook 'scheme-mode-hook (lambda () (electric-pair-mode -1)))
(add-hook 'lisp-mode-hook (lambda () (electric-pair-mode -1)))
(electric-pair-mode 1)

;; shut up
(setq large-file-warning-threshold nil)

;; tab settings
(setq standard-indent 4)
(setq-default tab-width 4)
(setq-default c-basic-offset 4)

;; tabs instead of spaces.
(setq-default indent-tabs-mode t)

;; no line wrap
(setq-default truncate-lines t)

;; follow symlinks when using version control
(setq vc-follow-symlinks t)

(setq c-default-style
      '((java-mode . "java")
        (awk-mode . "awk")
        (other . "k&r")))

;; line numbers
(defvar linum-format "%4d ")
(add-hook 'prog-mode-hook #'linum-mode)

;; cancel actions with escape
(define-key isearch-mode-map [escape] 'isearch-abort)
(global-set-key [escape] 'keyboard-escape-quit)

(add-hook 'emacs-lisp-mode-hook
          (lambda ()
            ;; Use spaces, not tabs.
            (setq indent-tabs-mode nil)
            (setq tab-stop-list (number-sequence 4 120 4))))

(add-hook 'c-mode-common-hook
          (lambda ()
            (c-set-offset 'inextern-lang 0)))
