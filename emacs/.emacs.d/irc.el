(defconst tudurom/irc-servers
  `(("Unixchat"
     :host "tudorr.xyz"
     :port ,tudurom/znc-port
     :pass ,tudurom/znc-unixchat-password)
    ("Rizon"
     :host "tudorr.xyz"
     :port ,tudurom/znc-port
     :pass ,tudurom/znc-rizon-password))
  "Configuration for different irc servers.")

(defun tudurom/rainbow (text)
  "Type rainbow text in circe."
  (interactive "sText to type: ")
  (circe-command-SAY
   (shell-command-to-string
    (concat "toilet -f term --irc --gay -- " text))))
