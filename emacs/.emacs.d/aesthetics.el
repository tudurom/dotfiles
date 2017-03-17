;;; aesthetics.el - A E S T H E T I C

(load-theme 'xresources t)

;; remove clutter
(setq inhibit-splash-screen t
      inhibit-startup-message t
      inhibit-startup-echo-area-message t)
(menu-bar-mode -1)
(tool-bar-mode -1)

;; disable scroll bar
(when (boundp 'scroll-bar-mode)
  (scroll-bar-mode -1))

;; highlight matching paren
(setq show-paren-delay 0)
(show-paren-mode 1)

;; follow symlinks when using version control
(setq vc-follow-symlinks t)

;; custom themes are safe
(setq custom-safe-themes t)

(defun tudurom/customize-frame (frame)
  "Apply customization on FRAME."
  (load-theme 'xresources)
  (set-frame-parameter frame 'internal-border-width 20))

;; border padding
(tudurom/customize-frame (selected-frame))

;; customize new frames
(add-hook 'after-make-frame-functions 'tudurom/customize-frame)

;; beveled modelines are ugly
(custom-set-faces
 '(mode-line ((t (:box nil)))))
