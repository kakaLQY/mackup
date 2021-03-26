;;; ob-bb.el --- Babel Functions for Babashka

;;; Commentary:

;; Org-Babel support for evaluating bb source code.

;;; Code:
(require 'ob)
(require 'ob-shell)

(defvar org-babel-tangle-lang-exts)
(add-to-list 'org-babel-tangle-lang-exts '("bb" . "clj"))

(defvar org-babel-default-header-args:bb '())
(defvar org-babel-header-args:bb '((ns . :any) (package . :any)))

(defun org-babel-execute:bb (body params)
  "Evaluate BODY code block with PARAMS using babashka."
  (let ((exe (executable-find "bb")))
    (unless exe (user-error "Babashka CLI (bb) not found"))
    (org-babel-execute:shell (format "%s -e %S" exe body) params)))

(provide 'ob-bb)
;;; ob-bb.el ends here
