;; Display the current line and column numbers in the mode line
(setq line-number-mode t)
(setq column-number-mode t)
(setq mode-line-position-column-line-format '("%l:C"))
(setq-default mode-line-buffer-identification nil)
(setq tab-width 4)
(setq select-enable-clipboard t)
(setq select-enable-primary t)
;; (windmove-default-keybindings)
(global-display-line-numbers-mode)
(setq dired-movement-style 'bounded-files)
(delete-selection-mode 1)
(defun emacs-reload ()
  (interactive)
  (load-file user-init-file))
(defun emacs-conf ()
  (interactive)
  (find-file "~/.emacs.d/package-init.el"))
(setq switch-to-buffer-obey-display-actions t)
(tab-bar-mode -1)
(blink-cursor-mode 1)
(setq compilation-scroll-output t)
(setq blink-cursor-interval 0.2 )
;; GLOBAL KEYS
(global-unset-key (kbd "C-z"))
(global-unset-key (kbd "M-/"))
(global-unset-key (kbd "C-SPC"))
(global-unset-key (kbd "C-x C-p"))
(global-set-key (kbd "C-c p") 'compile)
(global-set-key (kbd "C-z") 'undo-fu-only-undo)
(global-set-key (kbd "C-S-z") 'undo-fu-only-redo)
(global-set-key (kbd "C-x k") 'kill-current-buffer)
(global-set-key (kbd "<escape>") 'keyboard-escape-quit)
(global-set-key (kbd "C-q") 'set-mark-command)
(global-set-key (kbd "C-<return>") 'vterm)
(global-set-key (kbd "M-p") 'next-buffer)
(global-set-key (kbd "M-n") 'previous-buffer)
(global-set-key (kbd "C-,") 'flycheck-next-error)
(global-set-key (kbd "C-l") 'consult-line)
(global-set-key (kbd "C-j") 'consult-buffer)
(global-set-key (kbd "M-/") 'consult-ripgrep)
(global-set-key (kbd "C-SPC") 'execute-extended-command)
(global-set-key (kbd "C-=") 'quickrun)
(set-face-attribute 'default nil :height 230  :family "Iosevka")
;; (custom-set-faces
;;  ;; Default font
;;  '(default ((t (:family "Iosevka" :height 210))))
;;  ;; Fixed width font (important for org/vterm alignment)
;;  '(fixed-pitch ((t (:family "Iosevka" :height 210))))
;;  ;; Line number highlight
;;  ;; Mode line
;;  '(font-lock-function-name-face ((t (:foreground "white"))))
;;  '(font-lock-type-face ((t (:foreground "white"))))
;;  '(font-lock-operator-face ((t (:foreground "#EEEEEE"))))
;;  '(font-lock-keyword-face ((t (:foreground "gold1"))))
;;  '(font-lock-string-face ((t (:foreground "green"))))
;;  '(font-lock-variable-name-face ((t (:foreground "white"))))
;;  '(mode-line ((t (:family "Iosevka" :height 230 :slant italic))))
;;  )
;; 
;; (set-face-attribute 'isearch nil
;;                     :foreground "#000000"   ;; soft red
;;                     :background "#f4e285"   ;; dark red base
;;                     :weight 'bold)
;; 
;; ;; Other matches (lazy highlight)
;; (set-face-attribute 'lazy-highlight nil
;;                     :foreground "#000000"   ;; keep text readable
;;                     :background "#f4e285")  ;; soft warm yellow
