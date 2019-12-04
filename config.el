;;; .doom.d/config.el -*- lexical-binding: t; -*-

;; Place your private configuration here

(add-to-list 'initial-frame-alist '(fullscreen . maximized))
(setq lsp-python-ms-executable
      "~/python-language-server/output/bin/Release/linux-x64/publish/Microsoft.Python.LanguageServer")

(setq company-idle-delay 0.1
      company-minimum-prefix-length 1)

;; Allow jk and kj to be used as escape keys
(setq evil-escape-unordered-key-sequence t)

(defun evil-unimpaired-paste-above ()
  (interactive)
  (evil-insert-newline-above)
  (evil-paste-after 1)
  (evil-indent (evil-get-marker ?\[) (evil-get-marker ?\])))

(defun evil-unimpaired-paste-below ()
  (interactive)
  (evil-insert-newline-below)
  (evil-paste-after 1)
  (evil-indent (evil-get-marker ?\[) (evil-get-marker ?\])))

(map! ;; ported from vim-unimpaired
      :n  "] p" #'evil-unimpaired-paste-below
      :n  "[ P" #'evil-unimpaired-paste-above
      :n  "SPC SPC" #'evil-avy-goto-char-2)

(setq display-line-numbers-type 'relative)

;; Allow C-h to trigger which-key before it is done automatically
(setq which-key-show-early-on-C-h t)
(setq which-key-idle-delay 0.1)
(setq which-key-idle-secondary-delay 0.05)
