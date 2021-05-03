(setq mac-command-modifier 'meta)
(setq mac-option-modifier 'super)

(defun sh ()
  "Start zsh terminal."
  (interactive)
  (ansi-term "/bin/zsh"))
