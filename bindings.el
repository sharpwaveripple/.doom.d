;;; ~/.doom.d/bindings.el -*- lexical-binding: t; -*-


(map! ;; ported from vim-unimpaired
      :n  "] p" #'evil-unimpaired-paste-below
      :n  "[ P" #'evil-unimpaired-paste-above)

(map!
 :n  "SPC o k" #'counsel-yank-pop)
