;;; -*- lexical-binding: t -*-

(eval-when-compile
  (defvar tudurom/znc-port)
  (defvar tudurom/znc-unixchat-password)
  (defvar tudurom/znc-rizon-password))
(defconst tudurom/irc-servers
  `(("Unixchat"
     :host "tudorr.xyz"
     :port ,tudurom/znc-port
     :pass ,tudurom/znc-unixchat-password)
    ("Rizon"
     :host "tudorr.xyz"
     :port ,tudurom/znc-port
     :pass ,tudurom/znc-rizon-password)))
"Configuration for different irc servers."
