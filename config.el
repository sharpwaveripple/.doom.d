;;; .doom.d/config.el -*- lexical-binding: t; -*-

;; Place your private configuration here

(setq doom-font (font-spec :family "Deja Vu Sans Mono" :size 18))

(add-to-list 'initial-frame-alist '(fullscreen . maximized))

(setq company-idle-delay 0.3
      company-minimum-prefix-length 2)

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

(load! "bindings")


(setq display-line-numbers-type nil)

;; Allow C-h to trigger which-key before it is done automatically
(setq which-key-show-early-on-C-h t)
(setq which-key-idle-delay 0.3)
(setq which-key-idle-secondary-delay 0.05)

(global-unset-key (kbd "C-SPC"))
(evilem-default-keybindings "C-SPC")

(map! :leader
      :desc "Search buffer" "s b" #'counsel-grep)

(use-package! org-ref
  :after org
  :custom
  (org-ref-completion-library 'org-ref-ivy-cite)
  (org-ref-default-bibliography '("~/work/references/references_abbr.bib"))
  (org-ref-ivy-cite)
  :init
  (add-hook 'org-mode-hook (lambda () (require 'org-ref))))

(defun format-biblio ()
  "Make short form biblio on editing the file"
  (when (file-equal-p buffer-file-name "~/work/references/references.bib")
    (shell-command "python3 ~/work/references/abbreviate.py")))

(add-hook 'after-save-hook #'format-biblio)
(add-hook 'org-mode-hook (lambda () (smartparens-mode -1)))
(global-visual-line-mode t)
;; (add-hook 'org-pandoc-after-processing-ms-hook 'recentf-cleanup)

;; https://www.gnu.org/software/emacs/manual/html_node/emacs/Regexps.html
(setq! recentf-exclude '("\\.tmp?$"))
;; (defun recentf-cleanup
;;   (lambda ()
;;     (recentf-cleanup)))

;; (defun export-to-docx-hook ()
;;   (when org-pandoc-export-to-docx
;;     (recentf-cleanup)))

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

(add-hook 'vterm-mode-hook (lambda () (read-only-mode -1)))

;; file backends
;; ;; set default `company-backends'
;; (setq company-backends
;;       '((company-files          ; files & directory
;;          company-keywords       ; keywords
;;          company-capf
;;          company-yasnippet
;;          )
;;         (company-abbrev company-dabbrev)
;;         ))

(setq! evil-move-cursor-back nil)

(setq! ein:output-area-inlined-images t)

(add-hook 'org-babel-after-execute-hook 'org-display-inline-images)
(add-hook 'org-mode-hook 'org-display-inline-images)

(setq! org-startup-folded t)

(setq! browse-url-browser-function 'browse-url-firefox)
