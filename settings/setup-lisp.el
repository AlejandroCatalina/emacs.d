(require 'lispy)
(add-hook 'common-lisp-mode (lambda () (lispy-mode 1)))
(add-hook 'emacs-lisp-mode-hook (lambda () (lispy-mode 1)))

(require 'hy-mode)
(add-hook 'hy-mode-hook (lambda () (lispy-mode 1)))
(add-hook 'hy-mode-hook 'paredit-mode)
(add-hook 'hy-mode-hook #'rainbow-delimiters-mode)
(add-hook 'hy-mode-hook #'smartparens-strict-mode)

(require 'auto-complete)

;;* auto-complete for hy-mode
(add-to-list 'ac-modes 'hy-mode)

(defvar ac-source-hy-keywords
  `((candidates . ,(read (lispy--eval-hy "(str
   (+ \"(\"
      (.join \" \" (list-comp (.format \"\"{}\"\" (.replace x \"_\" \"-\"))
                            [x (hy-all-keywords)]))
      \")\"))"))))
  "Keywords known from hy. The command is defined in hyve.hylp.")


(defun hy-defns-macros ()
  "Get a list of defns in the current file."
  (let ((defns '()))
    (save-excursion
      (goto-char (point-min))
      (while (re-search-forward "\\(?:defn\\|defmacro\\)[[:space:]]+\\(.*?\\) "nil t)
        (push (match-string 1) defns)))
    defns))


(defun hy-variables ()
  "Collect the variable names in the current buffer.
These are every other name after setv or def."
  (let ((vars '())
        expr
        set-vars
        let-vars)
    (save-excursion
      (goto-char (point-min))
      (while (re-search-forward "(setv" nil t)
        (save-excursion
          (goto-char (match-beginning 0))
          (setq expr (read (current-buffer)))
          (setq set-vars (loop for x in (cdr expr) by #'cddr
                               collect x)))))
    (save-excursion
      (goto-char (point-min))
      (while (re-search-forward "(def" nil t)
        (save-excursion
          (goto-char (match-beginning 0))
          (setq expr (read (current-buffer)))
          (setq vars (loop for x in (cdr expr) by #'cddr
                               collect x)))))
    (save-excursion
      (goto-char (point-min))
      (while (re-search-forward "(let" nil t)
        (save-excursion
          (goto-char (match-beginning 0))
          (setq expr (read (current-buffer)))
          ;; this is read as a vector, so we convert to a list.
          (setq let-vars
                (loop for x in (append (nth 1 expr) nil)
                      by #'cddr collect x)))))
    (append set-vars let-vars vars)))

(defvar ac-source-hy-defns
  '((candidates . hy-defns-macros))
  "Functions/macros defined in the file.")

(defvar ac-source-hy-variables
  '((candidates . hy-variables))
  "Hy variables defined in the file.")

(setq ac-sources '(ac-source-hy-keywords
                   ac-source-hy-defns
                   ac-source-hy-variables))

(ac-set-trigger-key "TAB")
(auto-complete-mode 1)

(provide 'setup-lisp)
