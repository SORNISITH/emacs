(use-package lsp-mode
  :commands (lsp lsp-deferred)
  :hook ((prog-mode . lsp-deferred)
         (lsp-mode . lsp-enable-which-key-integration))

  :init
  (setq lsp-completion-provider :none)
  (setq lsp-keymap-prefix "C-c l")
  (setq lsp-diagnostics-provider :flycheck))


(use-package apheleia
  :hook (prog-mode . apheleia-mode)
  :config
  (setf (alist-get 'prettier apheleia-formatters)
        '("prettier" "--stdin-filepath" filepath)))

(provide 'init-lsp)
