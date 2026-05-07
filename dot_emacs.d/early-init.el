;; -*- lexical-binding: y; -*-

;; improve startup time by pausing garbage collection during init
;; (setopt gc-cons-threshold most-positive-fixnum)
(let ((restore:gc-cons-threshold 16777216)
      (restore:gc-cons-percentage 0.1)
      (restore:file-name-handler-alist file-name-handler-alist))
  (setq gc-cons-threshold most-positive-fixnum
	gc-cons-percentage 0.6
	file-name-handler-alist nil)
  (defun config:-do-restore-post-init-settings ()
    (setq gc-cons-threshold restore:gc-cons-threshold
	  gc-cons-percentage restore:gc-cons-percentage
	  file-name-handler-alist restore:file-name-handler-alist))
  (declare-function config:-do-restore-post-init-settings nil)
  (defun config:-restore-post-init-settings ()
    "Restore settings changed in order to speed up emacs init."
    (let ((timer (timer-create)))
      (timer-set-time timer 0 nil)
      (timer-set-function timer #'config:-do-restore-post-init-settings)
      (timer-activate-when-idle timer t))))

(add-hook 'emacs-startup-hook #'config:-restore-post-init-settings)
