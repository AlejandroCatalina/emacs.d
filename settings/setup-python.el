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

(when (fboundp 'jedi:setup)
  (add-hook 'python-mode-hook 'jedi:setup))
(setq jedi:setup-keys t
      jedi:complete-on-dot t)

(require 'ein)
(setq ein:use-auto-complete-superpack t)
(setq ein:notebook-modes '(ein:notebook-mumamo-mode ein:notebook-python-mode))
(add-hook 'ein:connect-mode-hook 'ein:jedi-setup)

(add-hook 'inferior-python-mode-hook 'smartparens-mode)

(defun python-repl-clear ()
  (interactive)
  (let ((comint-buffer-maximum-size 0))
    (comint-truncate-buffer)))

(define-key comint-mode-map (kbd "C-c M-l") 'python-repl-clear)

(provide 'setup-python)
