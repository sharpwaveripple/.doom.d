;;; ~/.doom.d/bindings.el -*- lexical-binding: t; -*-

(map!
 :n  "SPC o k" #'counsel-yank-pop)

(map! :leader
      :desc "Open ranger" "f d" #'ranger
      :desc "Search buffer" "s b" #'counsel-grep)

(map! ;; ported from vim-unimpaired
      :n  "] p" #'evil-unimpaired-paste-below
      :n  "[ P" #'evil-unimpaired-paste-above)
