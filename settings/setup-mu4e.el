(add-to-list 'load-path "/usr/share/emacs/site-lisp/mu4e")
(require 'mu4e)

(setq mu4e-maildir "~/.mail"
      mu4e-account-alist '(("personal"
                            ;; Under each account, set the account-specific variables you want.
                            (mu4e-sent-messages-behavior delete)
                            (mu4e-sent-folder "/personal/[Gmail].Sent Mail")
                            (mu4e-drafts-folder "/personal/[Gmail].Drafts")
                            (mu4e-trash-folder "/personal/[Gmail].Trash")
                            (user-mail-address "alecatfel@gmail.com")
                            (user-full-name "Alejandro Catalina Feliú")
                            (smtpmail-default-smtp-server "smtp.gmail.com")
                            (smtpmail-local-domain "gmail.com")
                            (smtpmail-smtp-user "alecatfel@gmail.com")
                            (smtpmail-smtp-server "smtp.gmail.com")
                            (smtpmail-stream-type starttls)
                            (smtpmail-smtp-service 587))
                           ("college"
                            (mu4e-sent-messages-behavior sent)
                            (mu4e-sent-folder "/college/.Sent Mail")
                            (mu4e-drafts-folder "/college/.Drafts")
                            (mu4e-trash-folder "/college/.Trash")
                            (user-mail-address "alejandro.catalina@estudiante.uam.es")
                            (user-full-name "Alejandro Catalina Feliú")
                            (smtpmail-default-smtp-server "smtpinterno.uam.es")
                            (smtpmail-local-domain "uam.es")
                            (smtpmail-smtp-user "alejandro.catalina@estudiante.uam.es")
                            (smtpmail-smtp-server "smtpinterno.uam.es")
                            (smtpmail-stream-type ssl)
                            (smtpmail-smtp-service 465))))

(defun my-mu4e-set-account ()
  "Set the account for composing a message."
  (let* ((account
          (if mu4e-compose-parent-message
              (let ((maildir (mu4e-message-field mu4e-compose-parent-message :maildir)))
                (string-match "/\\(.*?\\)/" maildir)
                (match-string 1 maildir))
            (completing-read (format "Compose with account: (%s) "
                                     (mapconcat #'(lambda (var) (car var))
                                                mu4e-account-alist "/"))
                             (mapcar #'(lambda (var) (car var)) mu4e-account-alist)
                             nil t nil nil (caar mu4e-account-alist))))
         (account-vars (cdr (assoc account mu4e-account-alist))))
    (if account-vars
        (mapc #'(lambda (var)
                  (set (car var) (cadr var)))
              account-vars)
      (error "No email account found"))))

(add-hook 'mu4e-compose-pre-hook 'my-mu4e-set-account)

;; mu4e config
(with-eval-after-load 'mu4e-alert
  ;; Enable Desktop notifications
  (mu4e-alert-set-default-style 'notifications))

(setq mu4e-maildir-shortcuts
      '(("/personal/INBOX"   . ?i)
        ("/college/INBOX"    . ?c)))

;; allow for updating mail using 'U' in the main view:
(setq mu4e-get-mail-command "offlineimap")

;; something about ourselves
(setq mu4e-compose-signature
      (concat
       "Un saludo,\n"
       "Alejandro Catalina Feliu\n"))

(setq mu4e-update-interval 120
      mu4e-headers-auto-update t) ;; Retrieve mail every 120 seconds

;; don't keep message buffers around
(setq message-kill-buffer-on-exit t)

;;; Bookmarks
(setq mu4e-bookmarks
      `(("flag:unread AND NOT flag:trashed" "Unread messages" ?u)
        ("date:today..now" "Today's messages" ?t)
        ("date:7d..now" "Last 7 days" ?w)
        ("mime:image/*" "Messages with images" ?p)
        ("maildir:/personal/spacemacs" "Spacemacs Mail List" ?s)
        (,(mapconcat 'identity
                     (mapcar
                      (lambda (maildir)
                        (concat "maildir:" (car maildir)))
                      mu4e-maildir-shortcuts) " OR ")
         "All inboxes" ?i)))

;; tell message-mode how to send mail
(setq message-send-mail-function 'smtpmail-send-it)

(provide 'setup-mu4e)
