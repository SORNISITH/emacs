;;; user-custom-configs.init.el --- DESCRIPTION -*- no-byte-compile: t; lexical-binding: t; -*-
;; Display the current line and column numbers in the mode line
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

(lsp-bridge-breadcrumb-mode)
(tab-bar-mode -1)
(set-cursor-color "gold")
(blink-cursor-mode 1)
(setq blink-cursor-interval 0.3 )
(setq dired-dwim-target t)
;; GLOBAL KEYS
(global-unset-key (kbd "C-z"))

(global-unset-key (kbd "M-/"))
(global-unset-key (kbd "C-x C-p"))
(global-set-key (kbd "C-m") 'compile)
(global-set-key (kbd "C-z") 'undo-fu-only-undo)
(global-set-key (kbd "C-S-z") 'undo-fu-only-redo)
(global-set-key (kbd "C-x k") 'kill-current-buffer)
(global-set-key (kbd "<escape>") 'keyboard-escape-quit)
(global-set-key (kbd "C-q") 'set-mark-command)
(global-set-key (kbd "C-<return>") 'eshell)
(global-set-key (kbd "M-p") 'centaur-tabs-forward)
(global-set-key (kbd "M-n") 'centaur-tabs-backward)
(global-set-key (kbd "C-,") 'flycheck-next-error)
(global-set-key (kbd "C-l") 'consult-line)
(global-set-key (kbd "C-j") 'consult-buffer)
(global-set-key (kbd "M-/") 'consult-ripgrep)
(global-set-key (kbd "C-i") 'other-window)


(custom-set-faces
 ;; Default font
 '(default ((t (:family "Iosevka" :height 210))))

 ;; Fixed width font (important for org/vterm alignment)
 '(fixed-pitch ((t (:family "Iosevka" :height 210))))

 ;; Line number highlight
 '(line-number-current-line ((t (:foreground "yellow" :weight bold))))
 '(font-lock-function-call-face ((t (:slant normal ))))


 ;; Mode line
 '(mode-line ((t (:family "Iosevka" :height 200 :slant italic))))

 ;; Syntax highlighting (clean version)
 '(font-lock-function-name-face ((t (:weight bold))))
 '(font-lock-variable-name-face ((t (:weight normal))))
 '(font-lock-builtin-face ((t ( :slant italic :foreground "#ff4d4d"))))
 '(font-lock-function-name-face ((t ( :weight normal ))))
 )

(set-face-attribute 'isearch nil
                    :foreground "#ff4d4d"   ;; soft red
                    :background "#2a0000"   ;; dark red base
                    :weight 'bold)

;; Other matches (lazy highlight)
(set-face-attribute 'lazy-highlight nil
                    :foreground "#000000"   ;; keep text readable
                    :background "#f4e285")  ;; soft warm yellow

