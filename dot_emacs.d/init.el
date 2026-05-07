;;; init.el --- Tudor’s Emacs Config -*- lexical-binding: t; -*-
;;; Commentary:
;;; Code:

(require 'use-package)

;;;; Elementary initialisation
;; Load customised variables and initialise packages.
(setq custom-file (locate-user-emacs-file "custom.el"))
(load custom-file 'noerror)

(use-package use-package
  :ensure nil
  :custom
  (use-package-always-defer t)          ; speed boost
  (use-package-always-ensure t))

(use-package emacs
  :bind (("M-/" . hippie-expand) ; http://www.emacswiki.org/emacs/HippieExpand
         ("C-x C-b" . switch-to-buffer)) 
  :hook (((text-mode prog-mode conf-mode) . hl-line-mode) ; Line numbers and line highlight only for programming-ish modes
         ((text-mode prog-mode conf-mode) . display-line-numbers-mode)
         ((prog-mode conf-mode) . electric-pair-mode)
         ((prog-mode conf-mode) . electric-quote-mode))
  :custom-face
  (default ((t (:family "Luxi Sans" :height 120))))
  (fixed-pitch ((t (:family "Berkeley Mono"))))
  (variable-pitch ((t (:family "Source Serif 4"))))
  :custom
  (apropos-do-all t)
  (auto-revert-avoid-polling t "Use filesystem notifications instead of polling")
  (auto-revert-check-vc-info t "Update VC info when changed from outside Emacs.")
  (auto-save-default nil)
  (backup-directory-alist (cons "." (locate-user-emacs-file "backups")))
  (blink-cursor-mode nil "It's annoying")
  (completions-detailed t)
  (create-lockfiles nil)
  (default-frame-alist '((vertical-scroll-bars . nil)
                         (horizontal-scroll-bars . nil)
                         (font . "Luxi Sans")))
  (enable-remote-dir-locals t)
  ;; (explicit-bash-args '("--noediting" "-i" "-l") "Run bash as login shell")

  (fido-vertical-mode t)
  (fringe-mode 20)
  (global-auto-revert-mode t)
  (help-window-select t)
  (indent-tabs-mode nil)
  (tab-width 4)
  (tab-always-indent 'complete)
  (inhibit-startup-screen t)
  (menu-bar-mode nil)
  (tool-bar-mode nil)
  ;; (tooltip-mode nil)
  (mouse-wheel-tilt-scroll t "Horizontal mouse / touchpad scroll")
  (mouse-yank-at-point t)
  (package-archives '(("melpa" . "https://melpa.org/packages/")
		      ("melpa-stable" . "https://stable.melpa.org/packages/")
		      ("elpa" . "https://elpa.gnu.org/packages/")
		      ("nongnu" . "https://elpa.nongnu.org/nongnu/")))
  (pixel-scroll-precision-mode t)
  (pixel-scroll-precision-interpolate-mice nil)
  (read-buffer-completion-ignore-case t)
  (read-extended-command-predicate 'command-completion-default-include-p)
  (read-file-name-completion-ignore-case t)
  (save-interprogram-paste-before-kill t "Save text copied from other programs in the kill ring")
  (save-place-mode t)
  (savehist-mode t)
  (select-enable-clipboard t)
  (sentence-end-double-space nil)
  (switch-to-buffer-obey-display-actions t))

(use-package which-key
  :ensure nil
  :custom
  (which-key-idle-delay 0.3)
  (which-key-mode t))

(use-package man
  :ensure nil
  :custom
  (Man-notify-method 'aggressive))


;;;; eyecandy
(use-package all-the-icons)
(use-package doom-modeline
  :custom
  (doom-modeline-height 30)
  (doom-modeline-mode t))

(use-package fixed-pitch
  :vc (:url "https://github.com/cstby/fixed-pitch-mode"
       :rev :newest)
  :demand t
  :custom
  (fixed-pitch-use-extended-default t)
  (fixed-pitch-whitelist-hooks '(prog-mode-hook
                                 text-mode-hook
                                 conf-mode-hook
                                 eat-mode-hook
                                 vterm-mode-hook
                                 ghostel-mode-hook
                                 elfeed-search-mode-hook)))

;;;; editor themes
(use-package doom-themes
  :demand t)
(use-package flexoki-themes
  :demand t)
(use-package auto-dark                  ; themes set as customisations
  :after (flexoki-themes doom-themes)
  :custom
  (auto-dark-themes '((flexoki-themes-dark) (flexoki-themes-light)))
  (auto-dark-mode t))

;;;; Git gutter

(use-package git-gutter
  :ensure t
  :commands git-gutter-mode
  :hook (prog-mode . git-gutter-mode)
  :hook (text-mode . git-gutter-mode))

(use-package git-gutter-fringe
  :ensure t
  :demand t
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
  :custom
  (global-mise-mode t))

;;;; Tramp

(use-package tramp
  :custom
  (tramp-copy-size-limit 1048576)
  (tramp-use-scp-direct-remote-copying t)
  (tramp-verbose 2)
  :config
  (add-to-list 'tramp-remote-path 'tramp-own-remote-path)
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

;; Tree-siter
(use-package treesit-auto
  :demand t
  :custom
  (treesit-auto-install 'prompt)
  (global-treesit-auto-mode t)
  :config
  ;; list of cool languages
  (setopt treesit-auto-langs (seq-difference treesit-auto-langs '(yaml clojure)))
  (treesit-auto-add-to-auto-mode-alist 'all))

;; Use Devil mode for more convenient modifiers
(use-package devil
  :custom
  (global-devil-mode t)
  :bind ("C-," . global-devil-mode))

;;;; Anaconda

(use-package conda
  :custom
  (conda-env-autoactivate-mode t)
  :config
  (conda-env-initialize-interactive-shells)
  (add-hook 'find-file-hook (lambda () (when (bound-and-true-p conda-project-env-path)
                                         (conda-env-activate-for-buffer)))))

;;;;; Lisp stuff

(use-package paredit
  :hook (emacs-lisp-mode
         ielm-mode
         lisp-mode
         lisp-interaction-mode))

(use-package rainbow-delimiters
  :hook (prog-mode conf-mode))

;;;; C

(use-package emacs
  :custom
  (c-ts-mode-indent-offset 4)
  (c-ts-mode-indent-style 'linux))

;;;; Clojure

(use-package clojure-mode
  :hook ((clojure-mode . subword-mode)
         (clojure-mode . paredit-mode)
         (clojure-mode . eglot-ensure)))

(use-package cider
  :hook (cide-repl-mode . paredit-mode)
  :custom
  (cider-repl-history-file (locate-user-emacs-file "cider-history"))
  (cider-repl-wrap-history t)
  (nrepl-use-ssh-fallback-for-remote-hosts t "Let nrepl work over SSH/TRAMP"))

;;;; Ansible and Yaml

(use-package poly-ansible
  :ensure t
  :mode ("/\\(ansible\\|group_vars\\|host_vars\\|roles\\)/.*\\.ya?ml\\'" . poly-ansible-mode)
  :mode ("/\\(tasks\\|handlers\\|vars\\|defaults\\|meta\\)/.*\\.ya?ml\\'" . poly-ansible-mode)
  :mode ("\\(site\\|hosts\\)\\.ya?ml\\'" . poly-ansible-mode)
  :mode ("playbook_.*\\.ya?ml\\'" . poly-ansible-mode)
  :hook (yaml-mode . eglot-ensure))

(use-package eglot
  :commands (eglot eglot-ensure)
  :custom
  (eglot-events-buffer-config '(:size 2000000
                        :format short))
  (eglot-extend-to-xref t)
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

(use-package eat
  :custom
  (eat-term-name "xterm" "For widespread compatibility."))

(use-package org
  :custom
  (org-use-fast-tag-selection t))

(use-package elfeed-org
  :after elfeed
  :demand t
  :config
  (elfeed-org)
  :custom
  (rmh-elfeed-org-files (list (locate-user-emacs-file "elfeed.org"))))

(use-package elfeed
  :commands elfeed)

(use-package undo-tree
  :custom
  (global-undo-tree-mode t))

(use-package ghostel
  :custom
  (ghostel-shell "fish"))

;; Make gc pauses faster by decreasing the threshold.
(setopt gc-cons-threshold (* 2 1000 1000))
