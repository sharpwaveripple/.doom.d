;;; .doom.d/config.el -*- lexical-binding: t; -*-

;; Place your private configuration here

(setq doom-font (font-spec :family "Deja Vu Sans Mono" :size 18))

(add-to-list 'initial-frame-alist '(fullscreen . maximized))
(setq frame-resize-pixelwise t)

(setq company-idle-delay 0.3
      company-minimum-prefix-length 2)

;; Allow jk and kj to be used as escape keys
(setq evil-escape-unordered-key-sequence t)

(load! "bindings")

(setq display-line-numbers-type nil)

;; Allow C-h to trigger which-key before it is done automatically
(setq which-key-show-early-on-C-h t)
(setq which-key-idle-delay 0.3)
(setq which-key-idle-secondary-delay 0.05)

(global-unset-key (kbd "C-SPC"))
(evilem-default-keybindings "C-SPC")

(map! :leader
      :desc "Open ranger" "f d" #'ranger
      :desc "Search buffer" "s b" #'counsel-grep)

(use-package! org-ref
  :after org
  :custom
  (org-ref-completion-library 'org-ref-ivy-cite)
  (org-ref-default-bibliography '("~/work/references/references_abbr.bib"))
  (org-ref-ivy-cite)
  :init
  (add-hook 'org-mode-hook (lambda () (require 'org-ref))))

(auto-sudoedit-mode 1)

(setq evil-ex-substitute-global t)

(use-package matlab
  :config (add-to-list 'auto-mode-alist '("\\.m\\'" . matlab-mode))
  :custom
  (matlab-indent-function t)
  (matlab-shell-command "matlab"))

(defun format-biblio ()
  "Make short form biblio on editing the file"
  (when (file-equal-p buffer-file-name "~/work/references/references.bib")
    (shell-command "python3 ~/work/references/abbreviate.py")))

(add-hook 'after-save-hook #'format-biblio)
(add-hook 'org-mode-hook (lambda () (smartparens-mode -1)))
(global-visual-line-mode t)

(setq! recentf-exclude '("~/.orhc-bibtex-cache"
                         "~/.emacs.d/.local/*"
                         "\\.tmp$"))


(defun open-popup-on-side (buffer &optional alist)
  (+popup-display-buffer-stacked-side-window-fn
   buffer (append `((side . right)
                    (size . 0.4))
                  alist)))

;; Wrap in an `after!' block so that you popup rule takes precedence over
;; default ones.
(after! python
  (set-popup-rule! "^\\*Python" :actions '(open-popup-on-side)))

(after! ess
  (set-popup-rule! "^\\*R" :actions '(open-popup-on-side)))

(setq! evil-move-cursor-back nil)
(setq! evil-want-fine-undo t)

(setq! ein:output-area-inlined-images t)

(add-hook 'org-babel-after-execute-hook 'org-display-inline-images)
(add-hook 'org-mode-hook 'org-display-inline-images)

(use-package recentf
  :hook (kill-emacs-hook . recentf-cleanup))

(setq! org-startup-folded t)

(setq! browse-url-browser-function 'browse-url-firefox)

;; https://stackoverflow.com/questions/21756052/how-to-send-c-left-into-emacs-term
(defun vterm-send-Cbackspace () (interactive) (vterm-send-key (kbd "C-w")))
(defun term-send-Cright () (interactive) (term-send-raw-string "\e[1;5C"))
(defun term-send-Cleft  () (interactive) (term-send-raw-string "\e[1;5D"))

(use-package vterm
  :bind (:map vterm-mode-map
         ("<C-backspace>" . vterm-send-Cbackspace)
         ("C-<right>" . term-send-Cright)
         ("C-<left>" . term-send-Cleft))
  :init
  (setq vterm-always-compile-module t)
  (add-hook 'vterm-mode-hook (lambda () (read-only-mode -1))))

(require 'warnings)
(add-to-list 'warning-suppress-types '(undo discard-info))
(setq ranger-show-hidden t)

;; (setq org-latex-listings t)
;; (setq python-shell-completion-native-disabled-interpreters '("python"))

;; (require 'ob-ein)

;; (org-babel-do-load-languages
;;  'org-babel-load-languages
;;  '((emacs-lisp . t)
;;    (R . t)
;;    (python . t)
;;    (ein . t)))
