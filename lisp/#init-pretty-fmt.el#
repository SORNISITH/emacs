;; Use reformatter to setup automatic fmt-on-save helpers.
(use-package reformatter :ensure t)

;; The following macro generates two commands: 'deno-format-buffer' and 'deno-format-region'
;; as well as the 'deno-format-on-save-mode' minor mode:
(reformatter-define deno-format
    :program "deno"
    :args `("fmt" "--ext" ,(if buffer-file-name (file-name-extension buffer-file-name) "js") "-"))


(provide 'init-pretty-fmt)

