;;; ~/dotfiles/doom/.doom.d/private.el -*- lexical-binding: t; -*-

(after! circe
  (set-irc-server! "znc"
                   `(:tls f
                          :port 42069
                          :nick "tudorr")))
