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
(require 'paren)
(setq show-paren-delay 0)
(show-paren-mode t)

;; follow symlinks when using version control
(setq vc-follow-symlinks t)

;; custom themes are safe
(setq custom-safe-themes t)

(defun tudurom/customize-frame (frame)
  "Apply customization on FRAME."
  (load-theme 'xresources)

  ;; disable bold
  ;; courtesy of
  ;; http://stackoverflow.com/questions/2064904/how-to-disable-bold-font-weight-globally-in-emacs
  (mapc
   (lambda (face)
     (set-face-attribute face nil :weight 'normal))
   (face-list)))

(defun tudurom/reload-theme ()
  "Reload theme and reapply customizations for all frames."
  (interactive)
  (load-theme 'xresources)
  (mapc 'tudurom/customize-frame (frame-list)))

;; border padding
(tudurom/customize-frame (selected-frame))

;; customize frames
(add-hook 'after-make-frame-functions 'tudurom/customize-frame)

;; beveled modelines are ugly
(custom-set-faces
 '(mode-line ((t (:box nil)))))
