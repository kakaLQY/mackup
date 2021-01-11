;;; $DOOMDIR/config.el -*- lexical-binding: t; -*-

;; Place your private configuration here! Remember, you do not need to run 'doom
;; sync' after modifying this file!


;; Some functionality uses this to identify you, e.g. GPG configuration, email
;; clients, file templates and snippets.
(setq user-full-name "Kaka LI"
      user-mail-address "drkaka@drkaka.com")

;; Doom exposes five (optional) variables for controlling fonts in Doom. Here
;; are the three important ones:
;;
;; + `doom-font'
;; + `doom-variable-pitch-font'
;; + `doom-big-font' -- used for `doom-big-font-mode'; use this for
;;   presentations or streaming.
;;
;; They all accept either a font-spec, font string ("Input Mono-12"), or xlfd
;; font string. You generally only need these two:
(setq doom-font (font-spec :family "JetBrains Mono" :size 30))

;; There are two ways to load a theme. Both assume the theme is installed and
;; available. You can either set `doom-theme' or manually load a theme with the
;; `load-theme' function. This is the default:
(setq doom-theme 'doom-dracula)

;; If you use `org' and don't want your org files in the default location below,
;; change `org-directory'. It must be set before org loads!
(setq org-directory "~/OneDrive/Org")

;; This determines the style of line numbers in effect. If set to `nil', line
;; numbers are disabled. For relative line numbers, set this to `relative'.
(setq display-line-numbers-type 'nil)

;; key bindings
(setq evil-snipe-override-evil-repeat-keys nil)
(setq doom-localleader-key ",")

(map! :leader
      ;; "TAB" nil
      "SPC" 'evil-switch-to-windows-last-buffer)

;; window key mapping
(winum-mode)
(map! (:leader
       (:desc "Select window" :g "0" #'treemacs-select-window)))

(map! :leader
      "1" 'winum-select-window-1
      "2" 'winum-select-window-2
      "3" 'winum-select-window-3
      "4" 'winum-select-window-4            ;
      "5" 'winum-select-window-5
      "6" 'winum-select-window-6
      "7" 'winum-select-window-7
      "8" 'winum-select-window-8
      "9" 'winum-select-window-9)

;; Clojure
(use-package! lispy
  :config
  (setq lispy-backward nil)
  (map! "M-[" #'lispy-wrap-brackets)
  (map! "M-{" #'lispy-wrap-braces)
  (map! "M-(" #'lispy-wrap-round))

(after! cider
  (set-popup-rule! "^\\*cider-repl" :side 'right :quit nil :size 100))

(setq clojure-indent-style 'align-arguments)
(setq clojure-toplevel-inside-comment-form t)

(defun spacemacs//cider-eval-in-repl-no-focus (form)
  "Insert FORM in the REPL buffer and eval it."
  (while (string-match "\\`[ \t\n\r]+\\|[ \t\n\r]+\\'" form)
    (setq form (replace-match "" t t form)))
  (with-current-buffer (cider-current-connection)
    (let ((pt-max (point-max)))
      (goto-char pt-max)
      (insert form)
      (indent-region pt-max (point))
      (cider-repl-return)
      (with-selected-window (get-buffer-window (cider-current-connection))
        (goto-char (point-max))))))

(defun send-sexp-to-repl ()
  (interactive)
  (spacemacs//cider-eval-in-repl-no-focus (cider-sexp-at-point)))

(defun send-fn-to-repl ()
  (interactive)
  (spacemacs//cider-eval-in-repl-no-focus (cider-defun-at-point)))

(map! (:localleader
       (:map (clojure-mode-map clojurescript-mode-map)
             "a" #'send-sexp-to-repl
             "f" #'send-fn-to-repl)))

(add-hook! 'cider-repl-mode-hook #'cider-company-enable-fuzzy-completion)
(add-hook! 'cider-mode-hook #'cider-company-enable-fuzzy-completion)
(add-hook! 'clojure-mode-hook #'paredit-mode)
(add-hook! 'clojurec-mode-hook #'paredit-mode)
(add-hook! 'clojurescript-mode-hook #'paredit-mode)

;; Magit
(after! magit
  (set-popup-rule! "^\\(?:\\*magit\\|magit:\\| \\*transient\\*\\)"
    :side 'right :size 0.5))

;; Org
(setq org-default-notes-file "~/OneDrive/Org/tasks.org")
(setq org-enable-org-journal-support t)
(setq org-journal-dir "~/OneDrive/Org/journal/")
(setq org-journal-file-format "%Y-%m")
(setq org-journal-date-format "%Y-%m-%d, %A")
(setq org-journal-file-type 'monthly)

;; Here are some additional functions/macros that could help you configure Doom:
;;
;; - `load!' for loading external *.el files relative to this one
;; - `use-package!' for configuring packages
;; - `after!' for running code after a package has loaded
;; - `add-load-path!' for adding directories to the `load-path', relative to
;;   this file. Emacs searches the `load-path' when you load packages with
;;   `require' or `use-package'.
;; - `map!' for binding new keys
;;
;; To get information about any of these functions/macros, move the cursor over
;; the highlighted symbol at press 'K' (non-evil users must press 'C-c c k').
;; This will open documentation for it, including demos of how they are used.
;;
;; You can also try 'gd' (or 'C-c c d') to jump to their definition and see how
;; they are implemented.
