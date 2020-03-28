;;; .doom.d/config.el -*- lexical-binding: t; -*-

;; Place your private configuration here

(setq doom-font (font-spec :family "Deja Vu Sans Mono" :size 18))

(add-to-list 'initial-frame-alist '(fullscreen . maximized))

;; (setq lsp-python-ms-executable
;;       "~/python-language-server/output/bin/Release/linux-x64/publish/Microsoft.Python.LanguageServer")

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

(use-package! org-ref
  :after org
  :custom
  (org-ref-completion-library 'org-ref-ivy-cite)
  (org-ref-default-bibliography '("~/papers/references_abbr.bib"))
  (org-ref-ivy-cite)
  :init
  (add-hook 'org-mode-hook (lambda () (require 'org-ref))))

(defun format-biblio ()
  "Make short form biblio on editing the file"
  (when (file-equal-p buffer-file-name "~/papers/references.bib")
    (shell-command "python3 ~/papers/abbreviate.py")))

(add-hook 'after-save-hook #'format-biblio)
(add-hook 'org-mode-hook (lambda () (smartparens-mode -1)))
(global-visual-line-mode t)

;; (set! :popup "\\^*Python" :side 'right :size 0.4)
;; (set-popup-rule! "\\^*Python" :side 'right :size 0.4 :noesc nil)

;; this causes r files to open in popup
;; (set-popup-rule! "\\^*R" :side 'right :size 0.5)

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

;; change repl settings:
;; https://github.com/hlissner/doom-emacs/issues/171

(require 'xwidget)

(when
    (featurep 'xwidget-internal)
  (easy-menu-define my-xwidget-tools-menu nil "Menu for Xwidget Webkit."
    `("Xwidget Webkit" :visible
      (featurep 'xwidget-internal)
      ["Browse Url ..." xwidget-webkit-browse-url :help "Ask xwidget-webkit to browse URL"]
      ["End Edit Textarea" xwidget-webkit-end-edit-textarea :help "End editing of a webkit text area"]))
  (easy-menu-add-item menu-bar-tools-menu nil my-xwidget-tools-menu 'separator-net)
  (easy-menu-define my-xwidget-menu xwidget-webkit-mode-map "Menu for Xwidget Webkit."
    '("Xwidget Webkit"
      ["Browse Url" xwidget-webkit-browse-url :help "Ask xwidget-webkit to browse URL"]
      ["Reload" xwidget-webkit-reload :help "Reload current url"]
      ["Back" xwidget-webkit-back :help "Go back in history"]
      "--"
      ["Insert String" xwidget-webkit-insert-string :help "current webkit widget"]
      ["End Edit Textarea" xwidget-webkit-end-edit-textarea :help "End editing of a webkit text area"]
      "--"
      ["Scroll Forward" xwidget-webkit-scroll-forward :help "Scroll webkit forwards"]
      ["Scroll Backward" xwidget-webkit-scroll-backward :help "Scroll webkit backwards"]
      "--"
      ["Scroll Up" xwidget-webkit-scroll-up :help "Scroll webkit up"]
      ["Scroll Down" xwidget-webkit-scroll-down :help "Scroll webkit down"]
      "--"
      ["Scroll Top" xwidget-webkit-scroll-top :help "Scroll webkit to the very top"]
      ["Scroll Bottom" xwidget-webkit-scroll-bottom :help "Scroll webkit to the very bottom"]
      "--"
      ["Zoom In" xwidget-webkit-zoom-in :help "Increase webkit view zoom factor"]
      ["Zoom Out" xwidget-webkit-zoom-out :help "Decrease webkit view zoom factor"]
      "--"
      ["Fit Width" xwidget-webkit-fit-width :help "Adjust width of webkit to window width"]
      ["Adjust Size" xwidget-webkit-adjust-size :help "Manually set webkit size to width W, height H"]
      ["Adjust Size Dispatch" xwidget-webkit-adjust-size-dispatch :help "Adjust size according to mode"]
      ["Adjust Size To Content" xwidget-webkit-adjust-size-to-content :help "Adjust webkit to content size"]
      "--"
      ["Copy Selection As Kill" xwidget-webkit-copy-selection-as-kill :help "Get the webkit selection and put it on the kill-ring"]
      ["Current Url" xwidget-webkit-current-url :help "Get the webkit url and place it on the kill-ring"]
      "--"
      ["Show Element" xwidget-webkit-show-element :help "Make webkit xwidget XW show a named element ELEMENT-SELECTOR"]
      ["Show Id Element" xwidget-webkit-show-id-element :help "Make webkit xwidget XW show an id-element ELEMENT-ID"]
      ["Show Id Or Named Element" xwidget-webkit-show-id-or-named-element :help "Make webkit xwidget XW show a name or element id ELEMENT-ID"]
      ["Show Named Element" xwidget-webkit-show-named-element :help "Make webkit xwidget XW show a named element ELEMENT-NAME"]
      "--"
      ["Cleanup" xwidget-cleanup :help "Delete zombie xwidgets"]
      ["Event Handler" xwidget-event-handler :help "Receive xwidget event"]
      "--"
      ["Xwidget Webkit Mode" xwidget-webkit-mode :style toggle :selected xwidget-webkit-mode :help "Xwidget webkit view mode"])))
