(require 'lispy)
(add-hook 'common-lisp-mode (lambda () (lispy-mode 1)))
(add-hook 'emacs-lisp-mode-hook (lambda () (lispy-mode 1)))

(require 'hy-mode)
(add-hook 'hy-mode-hook (lambda () (lispy-mode 1)))
(add-hook 'hy-mode-hook 'paredit-mode)
(add-hook 'hy-mode-hook #'rainbow-delimiters-mode)
(add-hook 'hy-mode-hook #'smartparens-strict-mode)

(provide 'setup-lisp)
