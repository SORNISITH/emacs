(message "Loading from PKGs")


;; (use-package treesit-auto
;;   :custom
;;   (treesit-auto-install 'prompt)
;;   :config
;;   (setq treesit-auto-langs '(javascript typescript tsx css html ))
;;   (treesit-auto-add-to-auto-mode-alist '(javascript typescript tsx css html))
;;   (global-treesit-auto-mode))

;; (use-package company)  ;; code completion

(use-package hydra) ;; hydra to create transient keybindings that "stick around" until you intentionally dismiss

(use-package projectile) ;; project 

(use-package yasnippet :config (yas-global-mode)) ;; good autosnipset

(use-package flycheck :ensure t :init (global-flycheck-mode)) ;; check error in copiled time

(use-package multiple-cursors  ;; fk off multi cursor what i need
  :bind
  (("M-o" . 'mc/mark-next-like-this)
   ("M-i" . 'mc/mark-previous-like-this)))

(use-package ox-reveal)   ;; org mode for reveal output

(use-package move-text    ;; drag text move around like vim alt + j/k
  :ensure t
  :config
  (move-text-default-bindings)
  (global-set-key (kbd "C-<up>") #'move-text-up)
  (global-set-key (kbd "C-<down>") #'move-text-down))

(use-package consult      ;;  Completion-
  :custom
  ;; Disable preview
  (consult-preview-key nil)
  :bind
  (("C-x b" . 'consult-buffer)    ;; Switch buffer, including recentf and bookmarks
   ("M-l"   . 'consult-ripgrep)  ;; Search inside a project
   ("C-x C-b"   . 'consult-find)  ;; Search inside a project
   ("M-y"   . 'consult-yank-pop)  ;; Paste by selecting the kill-ring
   ("M-s"   . 'consult-line)      ;; Search current buffer, like swiper
   ))

(use-package crux   ;;;  duplicate line
  :ensure t
  :bind (("M-p" . crux-duplicate-current-line-or-region)))

(use-package vertico
  :custom
  (vertico-count 14)  ;; limit to a fixed size
  :bind (:map vertico-map
	      ;; Use page-up/down to scroll vertico buffer, like ivy does by default.
	      ("<prior>" . 'vertico-scroll-down)
	      ("<next>"  . 'vertico-scroll-up))
  :init
  ;; Activate vertico
  (vertico-mode))

;; Convenient pa[Oth selection
(use-package vertico-directory
  :after vertico
  :ensure nil  ;; no need to install, it comes with vertico
  :bind (:map vertico-map
	      ("DEL" . vertico-directory-delete-char)))


(use-package orderless
  :custom
  ;; Configure a custom style dispatcher (see the Consult wiki)
  ;; (orderless-style-dispatchers '(+orderless-consult-dispatch orderless-affix-dispatch))
  ;; (orderless-component-separator #'orderless-escapable-split-on-space)
  (completion-styles '(orderless basic))
  (completion-category-overrides '((file (styles partial-completion))))
  (completion-category-defaults nil) ;; Disable defaults, use our settings
  (completion-pcm-leading-wildcard t)) ;; Emacs 31: partial-completion behaves like substring

(use-package savehist
  :init
  (savehist-mode))

(use-package embark
  :bind
  (("M-RET"   . embark-act)         ;; Begin the embark process
   ("M-g"   . embark-dwim)        ;; good alternative: M-.
   ("C-h B" . embark-bindings)) ;; alternative for `describe-bindings'

  :config
  (use-package embark-consult))

(setq completion-styles '(orderless basic))
(require 'vertico-directory)

(use-package marginalia
  ;; Bind `marginalia-cycle' locally in the minibuffer.  To make the binding
  ;; available in the *Completions* buffer, add it to the
  ;; `completion-list-mode-map'.
  :bind (:map minibuffer-local-map
              ("M-A" . marginalia-cycle))

  ;; The :init section is always executed.
  :init
  ;; Marginalia must be activated in the :init section of use-package such that
  ;; the mode gets enabled right away. Note that this forces loading the
  ;; package.
  (marginalia-mode))
					; smartparens (more powerful)
;; (use-package smartparens
;;   :ensure t
;;   :init (smartparens-global-mode 1)
;;   :custom
;;   (sp-autoskip-closing-pair 'always)
;;   (sp-autoinsert-pair t)
;;   (sp-autoescape-string-quote t)
;;   :bind
;;   (:map smartparens-mode-map
;;         ("C-M-f" . sp-forward-sexp)
;;         ("C-M-b" . sp-backward-sexp)
;;         ("C-M-d" . sp-down-sexp)
;;         ("C-M-a" . sp-beginning-of-sexp)
;;         ("C-M-e" . sp-end-of-sexp)
;;         ("C-M-n" . sp-forward-symbol)
;;         ("C-M-p" . sp-backward-symbol)
;;         ("C-M-k" . sp-kill-sexp)))

;; Emacs minibuffer configurations.
(use-package emacs
  :custom
  ;; Enable context menu. `vertico-multiform-mode' adds a menu in the minibuffer
  ;; to switch display modes.
  (context-menu-mode t)
  ;; Support opening new minibuffers from inside existing minibuffers.
  (enable-recursive-minibuffers t)
  ;; commands are hidden in normal buffers. This setting is useful beyond
  ;; Vertico.
  (read-extended-command-predicate #'command-completion-default-include-p)
  ;; Do not allow the cursor in the minibuffer prompt
  (minibuffer-prompt-properties
   '(read-only t cursor-intangible t face minibuffer-prompt)))

(provide 'init-pkgs)
;;; init-pkgs.el ends here
