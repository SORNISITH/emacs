;;; user-custom-configs.init.el --- DESCRIPTION -*- no-byte-compile: t; lexical-binding: t; -*-
(delete-selection-mode 1)
;; Display the current line and column numbers in the mode line
(setq line-number-mode t)
(setq column-number-mode t)
(setq mode-line-position-column-line-format '("%l:%C"))
(setq-default mode-line-buffer-identification nil)
(setq tab-width 4)
(setq select-enable-clipboard t)
(setq select-enable-primary t)
(windmove-default-keybindings)
(global-display-line-numbers-mode)
(setq backup-directory-alist
      `(("." . ,(expand-file-name "backups" user-emacs-directory))))
(setq custom-file (locate-user-emacs-file "custom.el"))
(load custom-file 'noerror 'no-message)
;; Enabled backups save your changes to a file intermittently
(setq make-backup-files t)
(setq vc-make-backup-files t)
(setq kept-old-versions 10)
(setq kept-new-versions 10)
(setq dired-movement-style 'bounded-files)
(setenv "LSP_USE_PLISTS" "true")
(setq lsp-use-plists t)
(defun display-startup-time ()
  "Display the startup time and number of garbage collections."
  (message "Emacs init loaded in %.2f seconds (Full emacs-startup: %.2fs) with %d garbage collections."
           (float-time (time-subtract after-init-time before-init-time))
           (time-to-seconds (time-since before-init-time))
           gcs-done))

(add-hook 'emacs-startup-hook #'display-startup-time 100)

(defun emacs-reload ()
  (interactive)
  (load-file user-init-file))

(defun emacs-conf ()
  (interactive)
  (find-file "~/.emacs.d/package-init.el")
  )

;; GLOBAL KEYS
(global-unset-key (kbd "C-z"))
(global-unset-key (kbd "C-x C-p"))
(global-set-key (kbd "C-c p") 'compile)
(global-set-key (kbd "C-z") 'undo-fu-only-undo)
(global-set-key (kbd "C-S-z") 'undo-fu-only-redo)
(global-set-key (kbd "C-x k") 'kill-current-buffer)
(global-set-key (kbd "<escape>") 'keyboard-escape-quit)
(global-set-key (kbd "C-q") 'set-mark-command)
(global-set-key (kbd "C-<return>") 'vterm)

(custom-set-faces
 ;; Default font for all text
 '(default ((t (:family "Iosevka" :height 230))))
 '(fixed-pitch ((t (:family "Iosevka" :height 170))))
 ;; Current line number
 '(line-number-current-line ((t (:foreground "yellow" :inherit line-number))))
 '(mode-line ((t (:family "Iosevka Term Slab" :height 190 ))))
 ;; Styles
 '(font-lock-function-name-face ((t (:family "Iosevka" ))))
 '(font-lock-variable-name-face ((t (:family "Iosevka" ))))
 )

(tab-bar-mode 1)
(set-cursor-color "gold")
(blink-cursor-mode 1)
(setq blink-cursor-interval 0.4 )
