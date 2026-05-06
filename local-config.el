;;; user-custom-configs.init.el --- DESCRIPTION -*- no-byte-compile: t; lexical-binding: t; -*-
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
(setq dired-movement-style 'bounded-files)
(delete-selection-mode 1)
(defun emacs-reload ()
  (interactive)
  (load-file user-init-file))
(defun emacs-conf ()
  (interactive)
  (find-file "~/.emacs.d/package-init.el"))

(tab-bar-mode 1)
(set-cursor-color "gold")
(blink-cursor-mode 1)
(setq blink-cursor-interval 0.4 )

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
 '(font-lock-variable-name-face ((t (:family "Iosevka" )))))

