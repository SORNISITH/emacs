;;; init-local.el --- Load Custom Preference --- Configs
;;; Commentary:
;; Code:
(message "hell")
(setq auto-save-default t)
;; Trigger an auto-save after 300 keystrokes
(setq auto-save-interval 300)
;; Trigger an auto-save 30 seconds of idle time.
(setq auto-save-timeout 30)
(setq auto-save-visited-interval 5)   ; Save after 5 seconds if inactivity
(auto-save-visited-mode 1)
(setq suggest-key-bindings nil)
(setq echo-keystrokes 0)
(set-face-attribute 'mode-line nil
                    :height 200)
(setq org-startup-with-inline-images t)
(electric-pair-mode)
(setq require-final-newline t)
(setq load-prefer-newer t)
(setq tab-width 4)
(setq select-enable-clipboard t)
(setq select-enable-primary t)
(setq custom-safe-themes t)

;; Activate flymake for every prog-mode buffers.
;; (add-hook 'prog-mode-hook 'flymake-mode) 
;; Use F3 to jump to the next error.
;; (global-set-key (kbd "<f3>") 'flymake-goto-next-error)
;; Make dired do something intelligent when two directories are shown
(setq dired-dwim-target t)
(setq delete-by-moving-to-trash t)

(global-set-key (kbd "C-c p") 'compile)
(global-set-key (kbd "C-x k") 'kill-current-buffer)
(global-set-key (kbd "<escape>") 'keyboard-escape-quit)
(global-set-key (kbd "C-q") 'set-mark-command)
;; Press F5 to start compilation.
;; (global-set-key (kbd "<f5>") 'project-compile)
;; ;; Press F3 to jump to the next error.
;; (global-set-key (kbd "<f3>") 'next-error)
;; ;; Then re-run the compilation with Shift + F5 (to skip the command prompt)
;; (global-set-key (kbd "S-<f5>") 'project-recompile)
(global-set-key (kbd "C-x g") 'magit-status)

(provide 'init-local)
;;; init-local.el ends here


