;;; init-corfu.el --- Interactive completion in buffers -*- lexical-binding: t -*-
;;; Commentary:
;;; Code:
(use-package corfu
  :ensure t
  :init
  (global-corfu-mode)
  :custom
  (corfu-auto 1)
  (tab-always-indent 'complete)
  :config
  (with-eval-after-load 'cc-mode
    (define-key c-mode-map (kbd "TAB") #'completion-at-point)
    (define-key c++-mode-map (kbd "TAB") #'completion-at-point))
  (define-key corfu-map (kbd "TAB") #'corfu-next)
  (define-key corfu-map (kbd "S-TAB") #'corfu-previous))

(use-package cape
  :ensure t
  :init
  (add-hook 'completion-at-point-functions #'cape-file)
  (add-hook 'completion-at-point-functions #'cape-dabbrev))

;; Terminal support (only if needed)
(use-package corfu-terminal
  :ensure t
  :after corfu
  :init
  (unless (display-graphic-p)
    (corfu-terminal-mode +1)))

(provide 'init-corfu)
;;; init-corfu.el ends here


