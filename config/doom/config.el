;;; $DOOMDIR/config.el -*- lexical-binding: t; -*-

;; Place your private configuration here! Remember, you do not need to run 'doom
;; refresh' after modifying this file!

(load-file "~/.doom.d/private.el")

;; These are used for a number of things, particularly for GPG configuration,
;; some email clients, file templates and snippets.
(setq user-full-name "Tudor-Ioan Roman"
      user-mail-address "tudor@tudorr.ro")

;; Doom exposes five (optional) variables for controlling fonts in Doom. Here
;; are the three important ones:
;;
;; + `doom-font'
;; + `doom-variable-pitch-font'
;; + `doom-big-font' -- used for `doom-big-font-mode'
;;
;; They all accept either a font-spec, font string ("Input Mono-12"), or xlfd
;; font string. You generally only need these two:
(setq doom-font (font-spec :family "Go Mono" :size 18))

;; There are two ways to load a theme. Both assume the theme is installed and
;; available. You can either set `doom-theme' or manually load a theme with the
;; `load-theme' function. These are the defaults.
;; (setq doom-theme 'doom-one)
(setq doom-theme 'gruvbox-light-medium)

;; If you intend to use org, it is recommended you change this!
(setq org-directory "~/usr/org/")

;; If you want to change the style of line numbers, change this to `relative' or
;; `nil' to disable it:
(setq display-line-numbers-type t)

(set-frame-parameter nil 'internal-border-width 10)


;; Here are some additional functions/macros that could help you configure Doom:
;;
;; - `load!' for loading external *.el files relative to this one
;; - `use-package' for configuring packages
;; - `after!' for running code after a package has loaded
;; - `add-load-path!' for adding directories to the `load-path', where Emacs
;;   looks when you load packages with `require' or `use-package'.
;; - `map!' for binding new keys
;;
;; To get information about any of these functions/macros, move the cursor over
;; the highlighted symbol at press 'K' (non-evil users must press 'C-c g k').
;; This will open documentation for it, including demos of how they are used.
;;
;; You can also try 'gd' (or 'C-c g d') to jump to their definition and see how
;; they are implemented.

(setq mode-require-final-newline 't)
(setq initial-frame-alist '((width . 102)
                            (height . 54)))

(setq meson-indent-basic 4)
(after! cc
  (add-hook 'c-mode-hook (lambda () (setq-default c-basic-offset 4
                                                  tab-width 4
                                                  c-default-style "k&r"))))

(add-hook 'before-save-hook 'delete-trailing-whitespace)

(setq ispell-dictionary "ro")
(setq langtool-default-language "ro")
(setq langtool-mother-tongue "ro")

(setq org-roam-directory (expand-file-name "roam" org-directory))
