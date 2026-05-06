(use-package eglot
  :ensure t
  ;;  :hook ((c-mode c++-mode ruby-mode vue-mode) . eglot-ensure)
  :config
  (add-to-list 'eglot-server-programs
               '((c++-mode c-mode) . ("clangd"
                                      "--header-insertion=never"
                                      "--completion-style=detailed"
                                      "--background-index")))

  (add-to-list 'eglot-server-programs
               '(ruby-mode . ("solargraph" "stdio")))

  ;; disable inlay hints properly
  (add-hook 'eglot-managed-mode-hook
            (lambda ()
              (eglot-inlay-hints-mode -1))))


(provide 'init-eglot)

