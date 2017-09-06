;;; -*- lexical-binding: t -*-

(require 'package)

(setq package-archives '(("gnu" . "https://elpa.gnu.org/packages/")
                         ("melpa" . "https://melpa.org/packages/")))

;; Install use-package if not installed
(unless (package-installed-p 'use-package)
  (package-refresh-contents)
  (package-install 'use-package))

;; Load it
(eval-when-compile
  (require 'use-package))

;; Don't vomit in my init file
(setq custom-file (expand-file-name "custom.el" user-emacs-directory))
(load custom-file 'noerror)

;;; LOAD AND CONFIGURE PACKAGES ;;;

;; evil - vim keybinds and modes
(use-package evil
  :ensure t
  :config
  (use-package evil-leader
    :ensure t
    :config
    (global-evil-leader-mode)

    (evil-leader/set-leader "<SPC>")
    (evil-leader/set-key
      "w" 'save-buffer
      "|" 'tudurom/split-horiz-and-focus
      "-" 'tudurom/split-vert-and-focus

      "h" 'windmove-left
      "j" 'windmove-down
      "k" 'windmove-up
      "l" 'windmove-right
      "=" 'balance-windows

      "<SPC>" (lambda () ; focus next window
                (interactive)
                (other-window 1))
      "s" 'delete-trailing-whitespace
      "g" 'magit-status
      "m" 'compile
      "d" 'dired
      "b" 'ibuffer
      "i" 'circe
      "n" 'neotree-toggle))
  (use-package evil-surround
    :ensure t
    :config
    (global-evil-surround-mode 1))
  (use-package evil-anzu
    :ensure t)
  (use-package evil-args
    :ensure t
    :defer
    :config
    ;; bind evil-args text objects
    (define-key evil-inner-text-objects-map "a" 'evil-inner-arg)
    (define-key evil-outer-text-objects-map "a" 'evil-outer-arg)

    ;; bind evil-forward/backward-args
    (define-key evil-normal-state-map "L" 'evil-forward-arg)
    (define-key evil-normal-state-map "H" 'evil-backward-arg)
    (define-key evil-motion-state-map "L" 'evil-forward-arg)
    (define-key evil-motion-state-map "H" 'evil-backward-arg)

    ;; bind evil-jump-out-args
    (define-key evil-normal-state-map "K" 'evil-jump-out-args))
  (evil-mode 1))

(use-package git-gutter-fringe
  :ensure t
  :config
  (global-git-gutter-mode +1)
  (custom-set-variables
   '(git-gutter-fr:modified-sign "~")))

;; not sure how to use it...
(use-package smart-tabs-mode
  :ensure t
  :config
  (smart-tabs-mode))

;; tab completion
(use-package company
  :ensure t
  :init
  (global-company-mode)
  :config
  ;; tab completion for C/C++
  (use-package company-irony
    :ensure t
    :config
    (eval-after-load 'company
      '(add-to-list 'company-backends 'company-irony)))
  (use-package company-go
    :ensure t
    :config
    (eval-after-load 'company
      '(add-to-list 'company-backends 'company-go)))
  (setq company-idle-delay 0.5)
  ;; that means that if cycles to the first option after the last one
  (setq company-selection-wrap-around t)
  (define-key company-active-map [tab] 'company-complete))

;; Completion engine for C/C++
(use-package irony
  :ensure t
  :config
  (add-hook 'c++-mode-hook 'irony-mode)
  (add-hook 'c-mode-hook 'irony-mode))

(use-package rainbow-delimiters
  :ensure t
  :init
  (add-hook 'prog-mode-hook #'rainbow-delimiters-mode))

(use-package xresources-theme
  :load-path "~/src/xresources-theme"
  :ensure t)

(use-package flycheck
  :ensure t
  :config
  (with-eval-after-load 'flycheck
    (setq-default flycheck-disabled-checkers '(emacs-lisp-checkdoc)))
  (use-package go-flycheck
    :ensure t)
  (global-flycheck-mode))

(use-package smooth-scrolling
  :ensure t
  :config
  (smooth-scrolling-mode 1))

(use-package markdown-mode
  :ensure t
  :commands (markdown-mode gfm-mode)
  :config
  (setq markdown-command "blackfriday-tool")
  (setq markdown-asymmetric-header t)
  :mode (("README\\.md\\'" . gfm-mode)
         ("\\.md\\'" . markdown-mode)
         ("\\.markdown\\'" . markdown-mode)))

(use-package magit
  :ensure t)

(use-package paredit
  :ensure t)


(use-package parinfer
  :ensure t
  :config
  (progn
    (setq parinfer-extensions
          '(defaults
             pretty-parens
             evil
             paredit
             smart-tab
             smart-yank))
    (add-hook 'clojure-mode-hook #'parinfer-mode)
    (add-hook 'emacs-lisp-mode-hook #'parinfer-mode)
    (add-hook 'common-lisp-mode-hook #'parinfer-mode)
    (add-hook 'scheme-mode-hook #'parinfer-mode)
    (add-hook 'lisp-mode-hook #'parinfer-mode)
    :config
    (evil-leader/set-key
      "," 'parinfer-toggle-mode)))

(use-package circe
  :ensure t
  :config

  ;; Initialize circe related functions.
  (defun tudurom/rainbow (text)
    "Type rainbow text in circe."
    (interactive "sText to type: ")
    (circe-command-SAY
     (shell-command-to-string
      (concat "toilet -f term --irc --gay -- " text)))
    (tudurom/load-circe)))

(use-package smartparens
  :ensure t
  :config
  (defun my-web-mode-smartparens-hook ()
    (sp-pair "<" ">" :wrap "C->"))

  (defun disable-smartparens ()
    (smartparens-mode -1))
  (smartparens-global-mode)
  (add-hook 'emacs-lisp-mode-hook #'disable-smartparens)
  (add-hook 'web-mode-hook #'my-web-mode-smartparens-hook))

(use-package ido
  :config
  (ido-mode t)
  (ido-everywhere t)
  (use-package ido-completing-read+
    :ensure t
    :config
    (ido-ubiquitous-mode t))
  (use-package flx-ido
    :ensure t
    :config
    (flx-ido-mode t)
    (setq ido-enable-flex-matching t)
    (setq ido-use-faces nil))
  (use-package smex
    :ensure t
    :config
    (smex-initialize)
    (global-set-key (kbd "M-x") 'smex)))

(use-package ag
  :ensure t)

(use-package go-mode
  :ensure t
  :config
  (setq gofmt-command "goimports")
  (add-hook 'go-mode-hook
            (lambda ()
              (add-hook 'before-save-hook 'gofmt-before-save)
              (setq-local compile-command
                          "go build -v && go test -v && go vet"))))

(use-package neotree
  :ensure t
  :config
  (use-package all-the-icons
    :ensure t)
  (setq neo-theme (if (display-graphic-p) 'icons 'arrow))

  (advice-add #'neo-global--select-window
              :after
              (lambda ()
                (eval-when-compile
                  (defvar neo-global--window))
                (set-window-fringes neo-global--window 1 0))))

(use-package solaire-mode
  :ensure t
  :config
  (add-hook 'after-change-major-mode-hook #'turn-on-solaire-mode))

(use-package protobuf-mode
  :ensure t)

(use-package multi-term
  :ensure t)

(use-package web-mode
  :ensure t
  :config
  (add-to-list 'auto-mode-alist '("\\.html?\\'" . web-mode))
  (setq web-mode-enable-auto-pairing nil))
