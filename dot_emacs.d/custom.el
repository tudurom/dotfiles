;;; -*- lexical-binding: t -*-
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(apropos-do-all t)
 '(auto-dark-themes '((flexoki-themes-dark) (flexoki-themes-light)))
 '(auto-save-default nil)
 '(backup-directory-alist '(("." . "~/.emacs.d/backups")))
 '(blink-cursor-mode nil nil nil "It's annoying")
 '(c-basic-offset 4)
 '(c-default-style
   '((java-mode . "java") (awk-mode . "awk") (csharp-mode . "csharp")
     (other . "linux")))
 '(cider-repl-history-file "~/.emacs.d/cider-history")
 '(cider-repl-wrap-history t)
 '(coffee-tab-width 2)
 '(create-lockfiles nil)
 '(custom-safe-themes
   '("48cf035091998c18dd617a907cbc07effe917c5805621cb975a21979bd601c3d"
     "3e67f6329c22e0ffcbaa7995b58faf0534c31dac44533583814945f347d78cb6"
     "f1e8339b04aef8f145dd4782d03499d9d716fdc0361319411ac2efc603249326"
     "b7a09eb77a1e9b98cafba8ef1bd58871f91958538f6671b22976ea38c2580755"
     default))
 '(default-frame-alist '((width . 100) (height . 45)))
 '(eglot-events-buffer-config '(:size 2000000 :format short))
 '(enable-remote-dir-locals t)
 '(explicit-bash-args '("--noediting" "-i" "-l"))
 '(explicit-shell-file-name "/bin/bash")
 '(fido-vertical-mode t)
 '(fringe-mode 20 nil (fringe))
 '(garbage-collection-messages t)
 '(hippie-expand-try-functions-list
   '(try-expand-dabbrev try-expand-dabbrev-all-buffers
                        try-expand-dabbrev-from-kill
                        try-complete-lisp-symbol-partially
                        try-complete-lisp-symbol) nil nil "Lisp-friendly hippie expand")
 '(indent-tabs-mode nil)
 '(inhibit-startup-screen t)
 '(ivy-count-format "%d/%d ")
 '(ivy-use-virtual-buffers t)
 '(js-indent-level 2)
 '(menu-bar-mode nil)
 '(mistty-shell-command '("/bin/bash" "-l"))
 '(mouse-yank-at-point t)
 '(nrepl-use-ssh-fallback-for-remote-hosts t)
 '(package-archives
   '(("melpa" . "https://melpa.org/packages/")
     ("melpa-stable" . "https://stable.melpa.org/packages/")
     ("elpa" . "https://elpa.gnu.org/packages/")
     ("nongnu" . "https://elpa.nongnu.org/nongnu/")))
 '(package-selected-packages
   '(ace-window all-the-icons anaconda-mode auto-dark cfrs clj-refactor
                conda cuda-mode devil doom-modeline doom-themes eat
                eldoc-box flexoki-themes git-gutter-fringe ivy-rich
                lsp-ivy lsp-ui majutsu mise nov pfuture poly-ansible
                rainbow-delimiters setup tramp-rpc typst-ts-mode vc-jj
                vterm wgrep))
 '(package-vc-selected-packages
   '((majutsu :url "https://github.com/0WD0/majutsu")
     (tramp-rpc :url
                "https://github.com/ArthurHeymans/emacs-tramp-rpc"
                :lisp-dir "lisp")
     (typst-ts-mode :url
                    "https://codeberg.org/meow_king/typst-ts-mode.git")))
 '(projectile-mode t)
 '(ring-bell-function 'ignore)
 '(safe-local-variable-directories '("/ssh:trn203@3.compute.vu.nl:/home/trn203/acce/"))
 '(save-interprogram-paste-before-kill t)
 '(save-place-mode t)
 '(scroll-bar-mode nil)
 '(select-enable-clipboard t)
 '(sh-basic-offset 2)
 '(tab-always-indent 'complete)
 '(tool-bar-mode nil)
 '(tooltip-mode nil)
 '(tramp-copy-size-limit 1048576)
 '(tramp-remote-path
   '(tramp-own-remote-path tramp-default-remote-path "/bin" "/usr/bin"
                           "/sbin" "/usr/sbin" "/usr/local/bin"
                           "/usr/local/sbin" "/local/bin"
                           "/local/freeware/bin" "/local/gnu/bin"
                           "/usr/freeware/bin" "/usr/pkg/bin"
                           "/usr/contrib/bin" "/opt/bin" "/opt/sbin"
                           "/opt/local/bin" "/opt/homebrew/bin"
                           "/opt/homebrew/sbin"))
 '(tramp-use-scp-direct-remote-copying t)
 '(tramp-verbose 2)
 '(use-package-always-ensure t)
 '(which-key-idle-delay 0.3)
 '(which-key-mode t))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(default ((t (:family "Berkeley Mono" :foundry "UKWN" :slant normal :weight regular :height 120 :width normal))))
 '(variable-pitch ((t (:family "Source Serif 4")))))
