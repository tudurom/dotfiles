;;; -*- lexical-binding: t -*-

;;; aesthetics.el - A E S T H E T I C

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

;; custom themes are safe
(setq custom-safe-themes t)

(defun tudurom/customize-frame (frame)
  "Apply customization on FRAME."
  (select-frame frame)
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
;;(custom-set-faces
;; '(mode-line ((t (:box nil)))))

(setq-default fringes-outside-margins t)


(require 'fringe-helper)
(eval-after-load "git-gutter-fringe"
  (lambda ()
    (fringe-helper-define 'git-gutter-fr:added '(center repeated)
      "XXX.....")
    (fringe-helper-define 'git-gutter-fr:modified '(center repeated)
      "XXX.....")
    (fringe-helper-define 'git-gutter-fr:deleted 'bottom
      "X......."
      "XX......"
      "XXX....."
      "XXXX....")))

(eval-after-load "flycheck"
  (lambda ()
    (eval-when-compile
      (defvar flycheck-indication-mode))
    (setq flycheck-indication-mode 'right-fringe)
    (fringe-helper-define 'flycheck-fringe-bitmap-double-arrow 'center
      "...X...."
      "..XX...."
      ".XXX...."
      "XXXX...."
      ".XXX...."
      "..XX...."
      "...X....")))


;;; MODELINE

;; Stolen from https://emacs.stackexchange.com/a/16660
(defun tudurom/mode-line-render (left center right &optional lpad rpad)
  "Return a string the width of the current window with
LEFT, CENTER, and RIGHT spaced out accordingly, LPAD and RPAD,
can be used to add a number of spaces to the front and back of the string."
  (condition-case err
      (let* ((left (if lpad (concat (make-string lpad ?\s) left) left))
             (right (if rpad (concat right (make-string rpad ?\s)) right))
             (width (apply '+ (window-width) (let ((m (window-margins))) (list (or (car m) 0) (or (cdr m) 0)))))
             (total-length (+ (length left) (length center) (length right) 2)))
        (when (> total-length width) (setq left "" right ""))
        (let* ((left-space (/ (- width (length center)) 2))
               (right-space (- width left-space (length center)))
               (lspaces (max (- left-space (length left)) 1))
               (rspaces (max (- right-space (length right)) 1 0)))
          (concat left (make-string lspaces  ?\s)
                  center
                  (make-string rspaces ?\s)
                  right)))
    (error (format "[%s]: (%s) (%s) (%s)" err left center right))))

(defun tudurom/mode-line-file-line-ending ()
  "Return a human-readable string for the type of line-ending currently used (LF, CRLF, CR)"
  (let ((eol-type (coding-system-eol-type buffer-file-coding-system)))
    (cond ((eq eol-type 0) "LF")
          ((eq eol-type 1) "CRLF")
          ((eq eol-type 2) "CR"))))

(defun tudurom/mode-line-file-coding ()
  "Return a human-readable string representing the coding currently use (example: UTF-8)"
  (let* ((csys (coding-system-plist buffer-file-coding-system))
         (csys-name (plist-get csys :name))
         (csys-category (plist-get csys :category)))
    (cond ((memq csys-category '(coding-category-undecided coding-category-utf-8))
           "UTF-8")
          (t (upcase (symbol-name csys-name))))))

(setq-default mode-line-format
              (list
               '((:eval (tudurom/mode-line-render
                         (format-mode-line
                          (concat
                           "%I "
                           "%b "
                           "%l,%c "
                           "%p"))
                         ""
                         (format-mode-line
                          (concat
                           (tudurom/mode-line-file-line-ending)
                           " "
                           (tudurom/mode-line-file-coding)
                           " "
                           "%m"))
                         0 0)))))

(tudurom/reload-theme)
