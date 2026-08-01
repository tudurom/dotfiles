;;; init.el --- Tudor’s Emacs Config -*- lexical-binding: t; -*-
;;; Commentary:
;;; Code:

(require 'use-package)

;;;; Elementary initialisation
;; Load customised variables and initialise packages.
(setq custom-file (locate-user-emacs-file "custom.el"))
(load custom-file 'noerror)

(setq tudor/ui-text-font "Lucida Grande")
(setq tudor/mono-font "Lucida Sans Typewriter")
(setq tudor/serif-font "Source Serif 4")
(setq tudor/mono-serif-font "Lucida Typewriter Std")

(setopt straight-use-package-by-default t)

;;;; Straight bootstrap
; Copyright (c) 2017-2026 Radian LLC and contributors
; MIT Licensed
(defvar bootstrap-version)
(let ((bootstrap-file
       (expand-file-name
        "straight/repos/straight.el/bootstrap.el"
        (or (bound-and-true-p straight-base-dir)
            user-emacs-directory)))
      (bootstrap-version 7))
  (unless (file-exists-p bootstrap-file)
    (with-current-buffer
        (url-retrieve-synchronously
         "https://raw.githubusercontent.com/radian-software/straight.el/develop/install.el"
         'silent 'inhibit-cookies)
      (goto-char (point-max))
      (eval-print-last-sexp)))
  (load bootstrap-file nil 'nomessage))
; Copyright end

(use-package use-package
  :ensure nil
  :straight nil
  :custom
  (use-package-always-defer t))         ; speed boost

;;;; Settings for built-in Emacs features

(use-package emacs
  :bind (("M-/" . hippie-expand) ; http://www.emacswiki.org/emacs/HippieExpand
         ("C-x C-b" . switch-to-buffer)) 
  :hook (((text-mode prog-mode conf-mode) . hl-line-mode) ; Line numbers and line highlight only for programming-ish modes
         ((text-mode prog-mode conf-mode) . display-line-numbers-mode)
         ((prog-mode conf-mode) . electric-pair-mode)
         ((prog-mode conf-mode) . electric-quote-mode))
  :custom-face
  ;; (default ((t (:family "Luxi Sans" :height 120))) "Default UI font.")
  (default ((t (:family ,tudor/mono-font :height 120))) "Default UI font.")
  (fixed-pitch ((t (:family ,tudor/mono-font :height 120))))
  (fixed-pitch-serif ((t (:family ,tudor/mono-serif-font :height 120))))
  (variable-pitch ((t (:family ,tudor/serif-font :height 140))))
  :custom
  (apropos-do-all t)
  (auto-revert-avoid-polling t "Use filesystem notifications instead of polling")
  (auto-revert-check-vc-info t "Update VC info when changed from outside Emacs.")
  (auto-save-default nil)
  (backup-directory-alist (cons "." (locate-user-emacs-file "backups")))
  (blink-cursor-mode nil "It's annoying")
  (completions-detailed t)
  (create-lockfiles nil)
  (default-frame-alist `((vertical-scroll-bars . nil)
                         (horizontal-scroll-bars . nil)
                         (font . ,tudor/mono-font)
                         (inhibit-double-buffering . t)))
  (delete-selection-mode t)
  (dired-dwim-target t "Suggest path of other dired window for operations.")
  (enable-remote-dir-locals t)
  ;; (explicit-bash-args '("--noediting" "-i" "-l") "Run bash as login shell")

  (fido-vertical-mode t)
  (fringe-mode 20 "Give some room to breathe.")
  (mode-line-right-align-edge 'right-margin "Otherwise the right side of the modeline will go off-screen with a non-zero fringe.")
  (require-final-newline t)
  (global-auto-revert-mode t)
  (help-window-select t)
  (help-window-keep-selected t)
  (indent-tabs-mode nil)
  (tab-width 4)
  (tab-always-indent 'complete)
  (inhibit-startup-screen t)
  (menu-bar-mode t)
  (tool-bar-mode nil)
  ;; (tooltip-mode nil)
  (mouse-wheel-tilt-scroll t "Horizontal mouse / touchpad scroll")
  (mouse-yank-at-point t)
  (pixel-scroll-precision-mode t)
  (pixel-scroll-precision-interpolate-mice nil)
  (read-buffer-completion-ignore-case t)
  (read-extended-command-predicate 'command-completion-default-include-p)
  (read-file-name-completion-ignore-case t)
  (save-interprogram-paste-before-kill t "Save text copied from other programs in the kill ring")
  (save-place-mode t)
  (select-enable-clipboard t)
  (sentence-end-double-space nil)
  (show-paren-delay 0)
  (switch-to-buffer-obey-display-actions t)
  (treesit-font-lock-level 4))

(use-package info
  :ensure nil
  :straight nil
  :preface
  (define-minor-mode tudor/info-variable-pitch-mode
    "Set the font in Info mode to a serif font."
    :local t
    :init-value nil
    (if tudor/info-variable-pitch-mode
        (setq tudor/info-variable-pitch-cookie
              (face-remap-add-relative 'default :inherit 'variable-pitch))
      (face-remap-remove-relative tudor/info-variable-pitch-cookie)))
  :hook ((Info-mode . tudor/info-variable-pitch-mode)))

(use-package savehist
  :ensure nil
  :straight nil
  :custom
  (savehist-mode t))

;; (use-package which-key
;;   :ensure nil
;;   :custom
;;   (which-key-idle-delay 0.3)
;;   (which-key-mode t))

(use-package embark
  :bind (("C-." . embark-act)
         ("C-;" . embark-dwim)
         :map help-map
         ("B" . embark-bindings)
         :map icomplete-minibuffer-map
         ("C-." . embark-act))
  :init
  (setopt prefix-help-command #'embark-prefix-help-command))

(use-package consult)

(use-package embark-consult)

(use-package man
  :ensure nil
  :straight nil
  :custom
  (Man-notify-method 'aggressive))

(use-package nerd-icons-dired
  :custom
  (nerd-icons-dired-mode t))

(use-package marginalia
  :custom
  (marginalia-align 'right)
  (marginalia-mode t))

;;;; eyecandy
(use-package all-the-icons)
(use-package doom-modeline
  :custom-face
  (doom-modeline ((t (:family ,tudor/ui-text-font))))
  :custom
  (doom-modeline-height 30)
  (doom-modeline-mode t))

;;;; editor themes
(use-package doom-themes
  :demand t)
(use-package flexoki-themes
  :demand t
  :load-path "site-lisp/emacs-flexoki-theme"
  )
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
  :straight (:host github :repo "ArthurHeymans/emacs-tramp-rpc")
  :custom
  (tramp-rpc-deploy-git-build-policy 'release))

;;;; Version control

(use-package magit
  :bind ("C-M-;" . magit-status))

(use-package majutsu
  :straight (:host github :repo "0WD0/majutsu"))

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
  :preface
  (defun tudor/disable-tabs ()
    "Set indent-tabs-mode to nil"
    (setq-local indent-tabs-mode nil))
  :custom
  (c-ts-mode-indent-offset 4)
  (c-ts-mode-indent-style 'linux)
  :hook ((c-ts-mode c++-ts-mode) . tudor/disable-tabs))

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
  (eglot-events-buffer-config '(:size 0
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
  :bind ("C-<tab>" . eldoc-box-help-at-point))

(use-package corfu
  :custom
  (global-corfu-mode t)
  (corfu-popupinfo-mode t)
  :custom-face
  (corfu-default ((t (:inherit fixed-pitch)))))

;;;; Typst

(use-package typst-ts-mode
  :straight (:host codeberg :repo "meow_king/typst-ts-mode"))

;;;; Misc

(use-package nov
  :mode ("\\.epub\\'" . nov-mode))

(use-package eat
  :custom
  (eat-term-name "xterm" "For widespread compatibility."))

(use-package olivetti
  :hook ((org-mode markdown-mode) . olivetti-mode))

(use-package mixed-pitch
  :hook ((org-mode markdown-mode) . mixed-pitch-mode))

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
  :commands elfeed
  :preface
  (defun tudor/elfeed-olivetti (buff)
    "Turn on olivetti-mode in an elfeed-show buffer and refresh the buffer to get good text alignment."
    (switch-to-buffer buff)
    (olivetti-mode)
    (setq-local line-spacing 0.25)
    (elfeed-show-refresh))
  :custom
  (elfeed-search-separator-date-format "%a %x")
  (elfeed-search-date-format '("%X" 8 :left))
  (elfeed-show-entry-switch 'tudor/elfeed-olivetti))

(use-package markdown-mode
  :custom
  (markdown-fontify-code-block-natively t))

(use-package undo-tree
  :custom
  (undo-tree-auto-save-history nil)
  (global-undo-tree-mode t))

(use-package ghostel
  :custom
  (ghostel-shell "fish")
  (ghostel-tramp-shells '((t login-shell "/bin/sh")) "Try login shell for all methods, fall back to /bin/sh")
  :bind (("C-x g" . ghostel)
         :map project-prefix-map
         ("s" . ghostel-project)))

(use-package doc-view
  :ensure nil
  :straight nil
  :custom
  (doc-view-resolution 300))

(use-package notmuch
  :commands (notmuch notmuch-hello)
  :ensure nil
  :straight nil)

(use-package mu4e
  :ensure nil
  :straight nil
  :commands (mu4e)
  :custom
  (mu4e-get-mail-command "mbsync -C -a")
  (mu4e-update-interval (* 60 60)))

(use-package emacs
  :custom
  (message-send-mail-function 'message-send-mail-with-sendmail)
  (sendmail-program "msmtp")
  (message-sendmail-extra-arguments '("--read-envelope-from"))
  (message-sendmail-f-is-evil 't))

(use-package emms
  :ensure t
  :custom
  (emms-player-list '(emms-player-mpv))
  (emms-info-functions '(emms-info-native))
  :config
  (emms-all))

(use-package emms-mpris
  :straight nil
  :ensure nil
  :after emms
  :config
  (emms-mpris-enable))

(use-package nerd-icons
  :defer nil
  :preface
  (setq tudor/nerd-icons-font-name "Symbols Nerd Font Mono")
  (defun tudor/nerd-icons-fix (&optional frame)
    (set-fontset-font t '(#xE000 . #xF8FF)     (font-spec :family tudor/nerd-icons-font-name) frame nil)
    (set-fontset-font t '(#xF0000 . #xFFFFD)   (font-spec :family tudor/nerd-icons-font-name) frame nil)
    (set-fontset-font t '(#x100000 . #x10FFFD) (font-spec :family tudor/nerd-icons-font-name) frame nil))
  :hook (after-make-frame-functions . tudor/nerd-icons-fix)
  :init
  (tudor/nerd-icons-fix)
  :custom
  (nerd-icons-font-family tudor/nerd-icons-font-name))

(use-package ledger-mode
  :custom
  (ledger-binary-path "hledger.sh")
  (ledger-mode-should-check-version nil)
  (ledger-report-auto-width nil)
  (ledger-report-links-in-register nil)
  (ledger-report-native-highlighting-arguments '("--color=always"))
  (ledger-default-date-string "%Y-%m-%d")
  :mode ("\\.hledger\\'" "\\.ledger\\'" "\\.journal\\'"))

(use-package nix-ts-mode
  :mode "\\.nix\\'")

(use-package direnv
  :config
  (direnv-mode))

;; Make gc pauses faster by decreasing the threshold.
(setopt gc-cons-threshold (* 2 1000 1000))

(setq tudor/private-file "private.el")
(load tudor/private-file 'noerror)
