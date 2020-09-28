;;; .doom.d/config.el -*- lexical-binding: t; -*-

;; Place your private configuration here

(setq doom-font (font-spec :family "Deja Vu Sans Mono" :size 18))
(setq confirm-kill-emacs nil)

;; https://tecosaur.github.io/emacs-config/config.html
(if (eq initial-window-system 'x)
    (toggle-frame-maximized)
  (toggle-frame-fullscreen))

;; (add-to-list 'initial-frame-alist '(fullscreen . maximized))

(load! "bindings")

(setq evil-escape-unordered-key-sequence t
      evil-ex-substitute-global t
      evil-move-cursor-back nil
      evil-want-fine-undo t)

(setq which-key-show-early-on-C-h t
      which-key-idle-delay 0.3
      which-key-idle-secondary-delay 0.05)

(setq company-idle-delay 0.3
      company-minimum-prefix-length 2)

(setq display-line-numbers-type nil)

(setq truncate-lines t)
;; https://emacs.stackexchange.com/questions/5545/how-to-prevent-slow-down-when-an-inferior-processes-generates-long-lines

;; food for indented thought
;; https://emacs.stackexchange.com/questions/31454/evil-mode-how-to-run-evil-indent-on-the-text-ive-just-pasted

(setq display-time-day-and-date t
      display-time-format "%I:%M %p %e %b %Y"
      display-time-default-load-average nil)
(display-time-mode t)
(display-battery-mode t)
(global-visual-line-mode t)
(auto-sudoedit-mode t)

(global-unset-key (kbd "C-SPC"))
(evilem-default-keybindings "C-SPC")

(use-package recentf
  :hook (kill-emacs-hook . recentf-cleanup))

(use-package! org-ref
  :after org
  :custom
  (org-ref-completion-library 'org-ref-ivy-cite)
  (org-ref-default-bibliography '("~/work/references/references_abbr.bib"))
  (org-ref-ivy-cite)
  :init
  (add-hook 'org-mode-hook (lambda () (require 'org-ref))))

(setq doom-modeline-buffer-encoding nil)

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

(setq! recentf-exclude '("~/.orhc-bibtex-cache"
                         "~/.emacs.d/.local/*"
                         "\\COMMIT_EDITMSG$"
                         "\\.tmp$"))

(defun open-popup-on-side (buffer &optional alist)
  (+popup-display-buffer-stacked-side-window-fn
   buffer (append `((side . right)
                    (size . 0.4))
                  alist)))

(after! python
  (set-popup-rule! "^\\*Python" :actions '(open-popup-on-side)))

(after! ess
  (set-popup-rule! "^\\*R" :actions '(open-popup-on-side)))

(setq! ein:output-area-inlined-images t)

(add-hook 'org-babel-after-execute-hook 'org-display-inline-images)
(add-hook 'org-mode-hook 'org-display-inline-images)

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

;; (setq org-latex-listings t)
;; (setq python-shell-completion-native-disabled-interpreters '("python"))

;; (require 'ob-ein)

;; (org-babel-do-load-languages
;;  'org-babel-load-languages
;;  '((emacs-lisp . t)
;;    (R . t)
;;    (python . t)
;;    (ein . t)))

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

;; look at literate config
;; https://github.com/nmartin84/.doom.d#org36d0b20
(defun replace-in-string (what with in)
  (replace-regexp-in-string (regexp-quote what) with in nil 'literal))

(defun org-html--format-image (source attributes info)
  (progn
    (setq source (replace-in-string "%20" " " source))
    (format "<img src=\"data:image/%s;base64,%s\"%s />"
            (or (file-name-extension source) "")
            (base64-encode-string
             (with-temp-buffer
               (insert-file-contents-literally source)
               (buffer-string)))
            (file-name-nondirectory source))))

(setq initial-buffer-choice "/home/jon/life/food.org")
