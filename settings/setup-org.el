(defun myorg-update-parent-cookie ()
  (when (equal major-mode 'org-mode)
    (save-excursion
      (ignore-errors
        (org-back-to-heading)
        (org-update-parent-todo-statistics)))))

(defadvice org-kill-line (after fix-cookies activate)
  (myorg-update-parent-cookie))

(defadvice kill-whole-line (after fix-cookies activate)
  (myorg-update-parent-cookie))

(setq org-directory "~/Dropbox/dev/org")
(setq org-default-notes-file (concat org-directory "~/Dropbox/dev/org/management/notes.org"))
(define-key global-map (kbd "M-<f6>") 'org-capture)

(require 'org-ref)

(require 'cdlatex)
(add-hook 'org-mode-hook 'turn-on-org-cdlatex)
(setq org-format-latex-options (plist-put org-format-latex-options :scale 1.5))


(provide 'setup-org)
