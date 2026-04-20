;;; init.el --- Tudor’s Emacs Config -*- lexical-binding: t; -*-
;;; Commentary:
;;; Code:

;;;; Elementary initialisation
;; Load customised variables and initialise packages.
(setq custom-file (concat user-emacs-directory "custom.el"))
(load custom-file 'noerror)

(require 'package)
(package-initialize)

;; show full path in title bar
;; (setq-default frame-title-format "%b (%f)")

;;;; eyecandy
(use-package all-the-icons)
(use-package doom-modeline
  :config
  (doom-modeline-mode t))

;;;; editor themes
(use-package doom-themes)
(use-package flexoki-themes)
(use-package auto-dark                  ; themes set as customisations
  :config
  (auto-dark-mode))

;;;; Git gutter

(use-package git-gutter
  :ensure t
  :hook (prog-mode . git-gutter-mode))

(use-package git-gutter-fringe
  :ensure t
  :config
  (define-fringe-bitmap 'git-gutter-fr:added [#b11100000] nil nil '(center repeated))
  (define-fringe-bitmap 'git-gutter-fr:modified [#b11100000] nil nil '(center repeated))
  (define-fringe-bitmap 'git-gutter-fr:deleted
    [#b10000000
     #b11000000
     #b11100000
     #b11110000] nil nil 'bottom))

;;;; Navigation

;; (use-package which-key)

;; Easily select window when switching
(use-package ace-window
  :bind ("M-o" . ace-window))

;;;; Mise

;; Load env vars from Mise
(use-package mise
  :hook (after-init . global-mise-mode))

;;;; Tramp

;; Distrobox support
(with-eval-after-load 'tramp
  (tramp-enable-method "distrobox"))

;; Make TRAMP go brr
(use-package tramp-rpc
  :after tramp
  :vc (:url "https://github.com/ArthurHeymans/emacs-tramp-rpc"
            :rev :newest
            :lisp-dir "lisp"))

;;;; Version control

(use-package magit
  :bind ("C-M-;" . magit-status))

(use-package majutsu
  :vc (:url "https://github.com/0WD0/majutsu"))

(use-package vc-jj)

;;;; Editing

;; Key binding to use "hippie expand" for text autocompletion
;; http://www.emacswiki.org/emacs/HippieExpand
(global-set-key (kbd "M-/") 'hippie-expand)

;; Don't display line numbers everywhere

(dolist (mode '(text-mode-hook prog-mode-hook))
  (add-hook mode (lambda () (display-line-numbers-mode t)))
  (add-hook mode (lambda () (hl-line-mode))))

;; Use Devil mode for more convenient modifiers
(use-package devil
  :config
  (global-devil-mode)
  (global-set-key (kbd "C-,") 'global-devil-mode))

;;;; Anaconda

(use-package conda
  :config
  (conda-env-initialize-interactive-shells)
  (conda-env-autoactivate-mode)
  (add-hook 'find-file-hook (lambda () (when (bound-and-true-p conda-project-env-path)
                                         (conda-env-activate-for-buffer)))))

;;;;; Lisp stuff

(use-package paredit
  :hook (emacs-lisp-mode
         ielm-mode
         lisp-mode
         lisp-interaction-mode))

(use-package rainbow-delimiters
  :hook prog-mode)

;;;; Elisp

(dolist (mode '(emacs-lisp-mode-hook
                lisp-interaction-mode-hook
                iel-mode-hook))
        (add-hook mode #'turn-on-eldoc-mode))

;;;; Clojure

(use-package clojure-mode
  :hook ((clojure-mode . subword-mode)
         (clojure-mode . paredit-mode)
         (clojure-mode . eglot-ensure)))

(use-package cider
  :hook (cide-repl-mode . paredit-mode))

;;;; Ansible and Yaml

(use-package poly-ansible
  :ensure t
  :mode ("/\\(ansible\\|group_vars\\|host_vars\\|roles\\)/.*\\.ya?ml\\'" . poly-ansible-mode)
  :mode ("/\\(tasks\\|handlers\\|vars\\|defaults\\|meta\\)/.*\\.ya?ml\\'" . poly-ansible-mode)
  :mode ("\\(site\\|hosts\\)\\.ya?ml\\'" . poly-ansible-mode)
  :mode ("playbook_.*\\.ya?ml\\'" . poly-ansible-mode)
  :hook (yaml-mode . eglot-ensure))

(use-package eglot
  :config
  (add-to-list 'eglot-server-programs
               '(yaml-mode . ("ansible-language-server" "--stdio")))
  (add-to-list 'eglot-server-programs
               '(typst-ts-mode . ("tinymist")))
  (add-to-list 'eglot-server-programs
               '((c-mode c++-mode cuda-mode) . ("clangd" "--fallback-style=webkit" "--enable-config"))))

(use-package eldoc-box
  :bind (:map prog-mode-map
              ("C-<tab>" . eldoc-box-help-at-point)))

;;;; Typst

(use-package typst-ts-mode
  :vc (:url "https://codeberg.org/meow_king/typst-ts-mode.git"))

;;;; Misc

(use-package nov
  :mode ("\\.epub\\'" . nov-mode))

(use-package eat)

;; Make gc pauses faster by decreasing the threshold.
(setq gc-cons-threshold (* 2 1000 1000))
