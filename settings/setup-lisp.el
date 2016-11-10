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
  `((candidates .
                '("!=" "!=" "%" "%=" "&" "&=" "*" "*" "**" "**=" "*=" "*map" "+" "+" "+=" "," "-" "-" "." "/" "/" "//" "//=" "/=" "<" "<" "<<" "<<=" "<=" "<=" "=" "=" ">" ">" ">=" ">=" ">>" ">>=" "@" "@=" "^" "^=" "-=" "->" "->>" "accumulate" "and" "apply" "as->" "assert" "assoc" "break" "butlast" "calling-module-name" "car" "cdr" "chain" "combinations" "compress" "cond" "cons" "continue" "count" "cut" "cycle" "dec" "def" "defclass" "defmacro" "defmacro/g-bang" "defmain" "defn" "defreader" "del" "dict-comp" "disassemble" "dispatch-reader-macro" "distinct" "do" "doto" "drop" "drop-last" "drop-while" "eval" "eval-and-compile" "eval-when-compile" "except" "filter" "first" "flatten" "fn" "for" "for*" "fraction" "genexpr" "gensym" "get" "global" "group-by" "ideas" "ideas" "identity" "if" "if*" "if-not" "if-python2" "import" "in" "inc" "input" "integer" "interleave" "interpose" "is" "is-coll" "is-cons" "is-empty" "is-even" "is-every" "is-float" "is-instance" "is-integer" "is-integer-char" "is-iterable" "is-iterator" "is-keyword" "is-neg" "is-nil" "is-none" "is-not" "is-numeric" "is-odd" "is-pos" "is-string" "is-symbol" "is-zero" "islice" "iterate" "keyword" "koan" "koan" "lambda" "last" "let" "lif" "lif-not" "list*" "list-comp" "macro-error" "macroexpand" "macroexpand-1" "map" "merge-with" "multicombinations" "name" "nonlocal" "not" "not-in" "nth" "or" "partition" "permutations" "product" "quasiquote" "quote" "raise" "range" "read" "read-str" "reduce" "remove" "repeat" "repeatedly" "require" "rest" "second" "set-comp" "setv" "some" "string" "take" "take-nth" "take-while" "tee" "try" "unless" "unquote" "unquote-splicing" "when" "while" "with" "with*" "with-decorator" "with-gensyms" "xor" "yield" "yield-from" "zip" "zip-longest" "|" "|=" "~")))
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
(add-hook 'hy-mode-hook (lambda () (auto-complete-mode 1)))

(provide 'setup-lisp)
