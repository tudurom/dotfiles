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
                                        ; focus next window
      "<SPC>" (lambda ()
                (interactive)
                (other-window 1))
      "s" 'delete-trailing-whitespace
      "g" 'magit-status
      "m" 'compile
      "d" 'dired
      "b" 'ibuffer
      "i" 'circe))
  (evil-mode 1))

;; show line numbers
(use-package nlinum
  :ensure t
  :config
  (setq nlinum-redisplay-delay 0)
  (global-nlinum-mode))

(use-package git-gutter
  :ensure t
  :defer t
  :config
  (global-git-gutter-mode +1))

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
  (global-flycheck-mode))

(use-package smooth-scrolling
  :ensure t
  :config
  (smooth-scrolling-mode 1))

(use-package markdown-mode
  :ensure t
  :commands (markdown-mode gfm-mode)
  :config
  :mode (("README\\.md\\'" . gfm-mode)
         ("\\.md\\'" . markdown-mode)
         ("\\.markdown\\'" . markdown-mode))
  :init
  (setq markdown-command "blackfriday-tool")
  ;; variable font height for markdown-mode
  (custom-set-faces
   '(markdown-header-face ((t (:inherit font-lock-function-name-face :weight bold :family "variable-pitch"))))
   '(markdown-header-face-1 ((t (:inherit markdown-header-face :height 1.8))))
   '(markdown-header-face-2 ((t (:inherit markdown-header-face :height 1.4))))
   '(markdown-header-face-3 ((t (:inherit markdown-header-face :height 1.2))))))

(use-package magit
  :ensure t)

(use-package paredit
  :ensure t)


(use-package parinfer
  :ensure t
  :init
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
  (setq circe-network-options tudurom/irc-servers))

(use-package smartparens
  :ensure t
  :config
  (defun disable-smartparens ()
    (smartparens-mode -1))
  (smartparens-global-mode)
  (add-hook 'emacs-lisp-mode-hook #'disable-smartparens))

(use-package ido
  :config
  (ido-mode t))
