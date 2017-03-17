(use-package circe
  :ensure t
  :commands (circe)
  :config
  (setq circe-network-options
        '(("Unixchat"
           :host "tudorr.xyz"
           :port tudurom/znc-port
           :pass tudurom/znc-unixchat-password))))
