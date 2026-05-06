;;; Reducing clutter in ~/.emacs.d by redirecting files to ~/.emacs.d/var/
;; NOTE: This must be placed in 'pre-early-init.el'.
(setq debug-on-error t)
(setq user-emacs-directory (expand-file-name "var_lsp_bridge/" minimal-emacs-user-directory))
(setq package-user-dir (expand-file-name "elpa" user-emacs-directory))
(setq minimal-emacs-gc-cons-threshold (* 64 1024 1024))
