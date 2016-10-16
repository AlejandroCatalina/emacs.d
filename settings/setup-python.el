(elpy-enable)

(when (require 'flycheck nil t)
  (setq elpy-modules (delq 'elpy-module-flymake elpy-modules))
  (add-hook 'elpy-mode-hook 'flycheck-mode))

(require 'py-autopep8)
(add-hook 'elpy-mode-hook 'py-autopep8-enable-on-save)

(pyvenv-activate "/home/alex/.conda/envs/py35/")

(elpy-use-ipython)
(setq python-shell-interpreter "ipython"
      python-shell-interpreter-args "--simple-prompt -i")

(require 'ein)
(setq ein:use-auto-complete-superpack t)
(setq ein:notebook-modes '(ein:notebook-mumamo-mode ein:notebook-python-mode))
(add-hook 'ein:connect-mode-hook 'ein:jedi-setup)

(provide 'setup-python)
