;;; post-init.el --- DESCRIPTION -*- no-byte-compile: t; lexical-binding: t; -*-
(use-package compile-angel
  :demand t
  :config
  ;; The following disables compilation of packages during installation;
  ;; compile-angel will handle it.
  (setq package-native-compile nil)

  ;; Set `compile-angel-verbose' to nil to disable compile-angel messages.
  ;; (When set to nil, compile-angel won't show which file is being compiled.)
  (setq compile-angel-verbose t)

  ;; The following directive prevents compile-angel from compiling your init
  ;; files. If you choose to remove this push to `compile-angel-excluded-files'
  ;; and compile your pre/post-init files, ensure you understand the
  ;; implications and thoroughly test your code. For example, if you're using
  ;; the `use-package' macro, you'll need to explicitly add:
  ;; (eval-when-compile (require 'use-package))
  ;; at the top of your init file.
  (compile-angel-exclude-directory "~/.emacs.d/lsp-bridge/")
  (compile-angel-exclude-directory "~/.emacs.d/pkgs/")
  (push "/init.el" compile-angel-excluded-files)
  (push "/custom.el" compile-angel-excluded-files)
  (push "/early-init.el" compile-angel-excluded-files)
  (push "/pre-init.el" compile-angel-excluded-files)
  (push "/package-init.el" compile-angel-excluded-files)
  (push "/compile-angle.el" compile-angel-excluded-files)
  (push "/pre-early-init.el" compile-angel-excluded-files)
  (push "/post-early-init.el" compile-angel-excluded-files)
  (push "/local-config.el" compile-angel-excluded-files)
  ;; A local mode that compiles .el files whenever the user saves them.
  ;; (add-hook 'emacs-lisp-mode-hook #'compile-angel-on-save-local-mode)
  ;; A global mode that compiles .el files prior to loading them via `load' or
  ;; `require'. Additionally, it compiles all packages that were loaded before
  ;; the mode `compile-angel-on-load-mode' was activated.
  (compile-angel-on-load-mode 1))


;; Auto-revert in Emacs is a feature that automatically updates the
;; contents of a buffer to reflect changes made to the underlying file
;; on disk.
(use-package autorevert
  :ensure nil
  :commands (auto-revert-mode global-auto-revert-mode)
  :hook
  (after-init . global-auto-revert-mode)
  :init
  ;; (setq auto-revert-verbose t)
  (setq auto-revert-interval 3)
  (setq auto-revert-remote-files nil)
  (setq auto-revert-use-notify t)
  (setq auto-revert-avoid-polling nil))

;; Recentf is an Emacs package that maintains a list of recently
;; accessed files, making it easier to reopen files you have worked on
;; recently.
(use-package recentf
  :ensure nil
  :commands (recentf-mode recentf-cleanup)
  :hook
  (after-init . recentf-mode)

  :init
  (setq recentf-auto-cleanup (if (daemonp) 300 'never))
  (setq recentf-exclude
        (list "\\.tar$" "\\.tbz2$" "\\.tbz$" "\\.tgz$" "\\.bz2$"
              "\\.bz$" "\\.gz$" "\\.gzip$" "\\.xz$" "\\.zip$"
              "\\.7z$" "\\.rar$"
              "COMMIT_EDITMSG\\'"
              "\\.\\(?:gz\\|gif\\|svg\\|png\\|jpe?g\\|bmp\\|xpm\\)$"
              "-autoloads\\.el$" "autoload\\.el$"))

  :config
  ;; A cleanup depth of -90 ensures that `recentf-cleanup' runs before
  ;; `recentf-save-list', allowing stale entries to be removed before the list
  ;; is saved by `recentf-save-list', which is automatically added to
  ;; `kill-emacs-hook' by `recentf-mode'.
  (add-hook 'kill-emacs-hook #'recentf-cleanup -90))

;; savehist is an Emacs feature that preserves the minibuffer history between
;; sessions. It saves the history of inputs in the minibuffer, such as commands,
;; search strings, and other prompts, to a file. This allows users to retain
;; their minibuffer history across Emacs restarts.
(use-package savehist
  :ensure nil
  :commands (savehist-mode savehist-save)
  :hook
  (after-init . savehist-mode)
  :init
  (setq history-length 300)
  (setq savehist-autosave-interval 600))

;; save-place-mode enables Emacs to remember the last location within a file
;; upon reopening. This feature is particularly beneficial for resuming work at
;; the precise point where you previously left off.
(use-package saveplace
  :ensure nil
  :commands (save-place-mode save-place-local-mode)
  :hook
  (after-init . save-place-mode)
  :init
  (setq save-place-limit 400))

;; The undo-fu package is a lightweight wrapper around Emacs' built-in undo
;; system, providing more convenient undo/redo functionality.
(use-package undo-fu
  :commands (undo-fu-only-undo
             undo-fu-only-redo
             undo-fu-only-redo-all
             undo-fu-disable-checkpoint)
  :config
  (global-unset-key (kbd "C-z"))
  (global-set-key (kbd "C-z") 'undo-fu-only-undo)
  (global-set-key (kbd "C-S-z") 'undo-fu-only-redo))

;; The undo-fu-session package complements undo-fu by enabling the saving
;; and restoration of undo history across Emacs sessions, even after restarting.
(use-package undo-fu-session
  :commands undo-fu-session-global-mode
  :hook (after-init . undo-fu-session-global-mode))

;; This package is useful for users who want to disable the mouse to:
;; - Prevent accidental clicks or cursor movements that may unexpectedly change
;;   the cursor position.
;; - Reinforce a keyboard-centric workflow by discouraging reliance on the mouse
;;   for navigation.
(use-package inhibit-mouse
  :config
  (if (daemonp)
      (add-hook 'server-after-make-frame-hook #'inhibit-mouse-mode)
    (inhibit-mouse-mode 1)))



;; Set the default font to DejaVu Sans Mono with specific size and weight
(set-face-attribute 'default nil
                    :height 210 :weight 'normal :family "Iosevka")

;; Enable `auto-save-mode' to prevent data loss. Use `recover-file' or
;; `recover-session' to restore unsaved changes.
(setq auto-save-default t)

;; Trigger an auto-save after 300 keystrokes
(setq auto-save-interval 300)

;; Trigger an auto-save 30 seconds of idle time.
(setq auto-save-timeout 30)


;; When auto-save-visited-mode is enabled, Emacs will auto-save file-visiting
;; buffers after a certain amount of idle time if the user forgets to save it
;; with save-buffer or C-x s for example.
;;
;; This is different from auto-save-mode: auto-save-mode periodically saves
;; all modified buffers, creating backup files, including those not associated
;; with a file, while auto-save-visited-mode only saves file-visiting buffers
;; after a period of idle time, directly saving to the file itself without
;; creating backup files.
(setq auto-save-visited-interval 5)   ; Save after 5 seconds if inactivity
(auto-save-visited-mode 1)

(use-package persist-text-scale
  :commands (persist-text-scale-mode
             persist-text-scale-restore)

  :hook (after-init . persist-text-scale-mode)

  :custom
  (text-scale-mode-step 1.07))



;;; useful.el --- DESCRIPTION -*- no-byte-compile: t; lexical-binding: t; -*-
;;; Enable automatic insertion and management of matching pairs of characters
;;; (e.g., (), {}, "") globally using `electric-pair-mode'.
(use-package elec-pair
  :ensure nil
  :commands (electric-pair-mode
             electric-pair-local-mode
             electric-pair-delete-pair)
  :hook (after-init . electric-pair-mode))

;; Allow Emacs to upgrade built-in packages, such as Org mode
(setq package-install-upgrade-built-in t)

;; When Delete Selection mode is enabled, typed text replaces the selection
;; if the selection is active.
(delete-selection-mode 1)

;; Display the current line and column numbers in the mode line
(setq line-number-mode t)
(setq column-number-mode t)
(setq mode-line-position-column-line-format '("%l:%C"))

;; Display of line numbers in the buffer:
;;(setq-default display-line-numbers-type 'relative)
(dolist (hook '(prog-mode-hook text-mode-hook conf-mode-hook))
  (add-hook hook #'display-line-numbers-mode))

;; Set the maximum level of syntax highlighting for Tree-sitter modes
;;(setq treesit-font-lock-level 4)
(use-package which-key
  :ensure nil ; builtin
  :commands which-key-mode
  :hook (after-init . which-key-mode)
  :custom
  (which-key-idle-delay 1.5)
  (which-key-idle-secondary-delay 0.25)
  (which-key-add-column-padding 1)
  (which-key-max-description-length 40))

(unless (and (eq window-system 'mac)
             (bound-and-true-p mac-carbon-version-string))
  ;; Enables `pixel-scroll-precision-mode' on all operating systems and Emacs
  ;; versions, except for emacs-mac.
  ;;
  ;; Enabling `pixel-scroll-precision-mode' is unnecessary with emacs-mac, as
  ;; this version of Emacs natively supports smooth scrolling.
  ;; https://bitbucket.org/mituharu/emacs-mac/commits/65c6c96f27afa446df6f9d8eff63f9cc012cc738
  (setq pixel-scroll-precision-use-momentum nil) ; Precise/smoother scrolling
  (pixel-scroll-precision-mode 1))

;; Display the time in the modeline
(add-hook 'after-init-hook #'display-time-mode)

;; Paren match highlighting
(add-hook 'after-init-hook #'show-paren-mode)

;; Track changes in the window configuration, allowing undoing actions such as
;; closing windows.
(setq winner-boring-buffers '("*Completions*"
                                "*Minibuf-0*"
                                "*Minibuf-1*"
                                "*Minibuf-2*"
                                "*Minibuf-3*"
                                "*Minibuf-4*"
                                "*Compile-Log*"
                                "*inferior-lisp*"
                                "*Fuzzy Completions*"
                                "*Apropos*"
                                "*Help*"
                                "*cvs*"
                                "*Buffer List*"
                                "*Ibuffer*"
                                "*esh command on file*"))
(add-hook 'after-init-hook #'winner-mode)

;; Window dividers separate windows visually. Window dividers are bars that can
;; be dragged with the mouse, thus allowing you to easily resize adjacent
;; windows.
;; https://www.gnu.org/software/emacs/manual/html_node/emacs/Window-Dividers.html
(add-hook 'after-init-hook #'window-divider-mode)

;; DIRED--------------------------------------------------------------------------------------
;; Constrain vertical cursor movement to lines within the buffer
(setq dired-movement-style 'bounded-files)
;; Hide files from dired
(setq dired-omit-files (concat "\\`[.]\\'"
                               "\\|\\(?:\\.js\\)?\\.meta\\'"
                               "\\|\\.\\(?:elc|a\\|o\\|pyc\\|pyo\\|swp\\|class\\)\\'"
                               "\\|^\\.DS_Store\\'"
                               "\\|^\\.\\(?:svn\\|git\\)\\'"
                               "\\|^\\.ccls-cache\\'"
                               "\\|^__pycache__\\'"
                               "\\|^\\.project\\(?:ile\\)?\\'"
                               "\\|^flycheck_.*"
                               "\\|^flymake_.*"))

(add-hook 'dired-mode-hook #'dired-omit-mode)
;; dired: Group directories first
(with-eval-after-load 'dired
  (let ((args "--group-directories-first -ahlv"))
    (when (or (eq system-type 'darwin) (eq system-type 'berkeley-unix))
      (if-let* ((gls (executable-find "gls")))
          (setq insert-directory-program gls)
        (setq args nil)))
    (when args
      (setq dired-listing-switches args))))

(use-package dired-subtree
  :after dired
  :bind
  ( :map dired-mode-map
    ("<tab>" . dired-subtree-toggle)
    ("TAB" . dired-subtree-toggle)
    ("<backtab>" . dired-subtree-remove)
    ("S-TAB" . dired-subtree-remove))
  :config
  (setq dired-subtree-use-backgrounds nil))

;; Enables visual indication of minibuffer recursion depth after initialization.
(add-hook 'after-init-hook #'minibuffer-depth-indicate-mode)

;; Configure Emacs to ask for confirmation before exiting
(setq confirm-kill-emacs 'y-or-n-p)
;; Enabled backups save your changes to a file intermittently
(setq kept-old-versions 10)
(setq kept-new-versions 10)
;; Support for Git files (.gitconfig, .gitignore, .gitattributes...)
(use-package git-modes
  :commands (gitattributes-mode
             gitconfig-mode
             gitignore-mode)
  :mode (("/\\.gitignore\\'" . gitignore-mode)
         ("/info/exclude\\'" . gitignore-mode)
         ("/git/ignore\\'" . gitignore-mode)
         ("/.gitignore_global\\'" . gitignore-mode)  ; jc-dotfiles

         ("/\\.gitconfig\\'" . gitconfig-mode)
         ("/\\.git/config\\'" . gitconfig-mode)
         ("/modules/.*/config\\'" . gitconfig-mode)
         ("/git/config\\'" . gitconfig-mode)
         ("/\\.gitmodules\\'" . gitconfig-mode)
         ("/etc/gitconfig\\'" . gitconfig-mode)

         ("/\\.gitattributes\\'" . gitattributes-mode)
         ("/info/attributes\\'" . gitattributes-mode)
         ("/git/attributes\\'" . gitattributes-mode)))


;; MODE ----------------------------------------------------------------------------------------------------------------------------------------
;; Configure built-in sgml-mode to automatically enable
;; `sgml-electric-tag-pair-mode' in `html-mode' and `mhtml-mode', providing
;; automatic insertion of matching closing tags.

;; Install ob-go
(use-package ob-go
  :straight t
  :defer t)

(use-package jq-mode
  :straight t
  :defer t)

(use-package ob-mermaid
  :straight t
  :defer t)

(use-package ob-graphql
  :straight t
  :defer t)

(use-package sgml-mode
  :ensure nil
  :commands (sgml-mode sgml-electric-tag-pair-mode)
  :hook ((html-mode mhtml-mode) . sgml-electric-tag-pair-mode))

;; Support for YAML files.
;;
;; NOTE: Prefer the tree-sitter-based yaml-ts-mode over yaml-mode when
;; available, as it provides more accurate syntax parsing and enhanced editing
;; features.
(use-package yaml-mode
  :commands yaml-mode
  :mode (("\\.yaml\\'" . yaml-mode)
         ("\\.yml\\'" . yaml-mode)))

;; Support for Dockerfile files.
;;
;; NOTE: Prefer the tree-sitter-based dockerfile-ts-mode over dockerfile-mode
;; when available, as it provides more accurate syntax parsing and enhanced
;; editing features.
(use-package dockerfile-mode
  :commands dockerfile-mode
  :mode ("Dockerfile\\'" . dockerfile-mode))

;; Support for Gnuplot files
(use-package gnuplot
  :commands gnuplot-mode
  :mode ("\\.gp\\'" . gnuplot-mode))

;; Support for *.lua files.
;;
;; Prefer the tree-sitter-based lua-ts-mode over lua-mode when available, as it
;; provides more accurate syntax parsing and enhanced editing features.
(use-package lua-mode
  :commands lua-mode
  :mode ("\\.lua\\'" . lua-mode))

;; Jinja2 template support for files commonly used in configuration management
;; systems and web frameworks. This mode enables syntax highlighting and basic
;; editing facilities for templates written using the Jinja2 templating
;; language.
(use-package jinja2-mode
  :commands jinja2-mode
  :mode ("\\.j2\\'" . jinja2-mode))

;; CSV file support with automatic column alignment. This configuration enables
;; csv-align-mode whenever a CSV file is opened, improving readability by
;; keeping columns visually aligned according to a configurable maximum width
;; and a set of recognized field separators.
(use-package csv-mode
  :commands (csv-mode
             csv-align-mode
             csv-guess-set-separator)
  :mode ("\\.csv\\'" . csv-mode)
  :hook ((csv-mode . csv-align-mode)
         (csv-mode . csv-guess-set-separator))
  :custom
  (csv-align-max-width 100)
  (csv-separators '("," ";" " " "|" "\t")))
(use-package toml-mode
  :straight t
  :defer t
  :mode "/\\(Cargo.lock\\|\\.cargo/config\\)\\'")

(use-package yaml-mode
  :straight t
  :defer t
  :hook (kubed-display-resource-mode . yaml-mode)
  :hook (yaml-mode . apheleia-mode)
  :mode "\\.yml\\'"
  :mode "\\.yaml\\'")

;; (use-package yaml-pro
;;   :straight t
;;   :hook (yaml-mode . yaml-pro-mode)
;;   :hook (yaml-ts-mode . yaml-pro-ts-mode))
(use-package web-mode
  :straight t
  :defer t
  :mode (("\\.phtml\\'"      . web-mode)
         ("\\.tpl\\.php\\'"  . web-mode)
         ("\\.twig\\'"       . web-mode)
         ("\\.xml\\'"        . web-mode)
         ("\\.html\\'"       . web-mode)
         ("\\.htm\\'"        . web-mode)
         ("\\.[gj]sp\\'"     . web-mode)
         ("\\.as[cp]x?\\'"   . web-mode)
         ("\\.eex\\'"        . web-mode)
         ("\\.erb\\'"        . web-mode)
         ("\\.mustache\\'"   . web-mode)
         ("\\.handlebars\\'" . web-mode)
         ("\\.hbs\\'"        . web-mode)
         ("\\.eco\\'"        . web-mode)
         ("\\.ejs\\'"        . web-mode)
         ("\\.svelte\\'"     . web-mode)
         ("\\.ctp\\'"        . web-mode)
         ("\\.djhtml\\'"     . web-mode)
         ("\\.vue\\'"        . web-mode))
  :bind (:map web-mode-map
              ;; Quick actions with direct M-g prefix
              ("M-g /" . web-mode-element-close)
              ("M-g k" . web-mode-element-kill)
              ("M-g s" . web-mode-element-select)

              ;; Tag operations (M-g t prefix)
              ("M-g t n" . web-mode-tag-next)
              ("M-g t p" . web-mode-tag-previous)
              ("M-g t m" . web-mode-tag-match)
              ("M-g t s" . web-mode-tag-select)
              ("M-g t b" . web-mode-tag-beginning)
              ("M-g t e" . web-mode-tag-end)

              ;; Element operations (M-g e prefix)
              ("M-g e n" . web-mode-element-next)
              ("M-g e p" . web-mode-element-previous)
              ("M-g e u" . web-mode-element-parent)
              ("M-g e d" . web-mode-element-child)
              ("M-g e k" . web-mode-element-kill)
              ("M-g e w" . web-mode-element-wrap)
              ("M-g e s" . web-mode-element-select)
              ("M-g e c" . web-mode-element-clone)
              ("M-g e r" . web-mode-element-rename)

              ;; Attribute operations (M-g a prefix)
              ("M-g a n" . web-mode-attribute-next)
              ("M-g a p" . web-mode-attribute-previous)
              ("M-g a k" . web-mode-attribute-kill)
              ("M-g a i" . web-mode-attribute-insert)
              ("M-g a s" . web-mode-attribute-select))
  :config
  (setq web-mode-markup-indent-offset 2
        web-mode-code-indent-offset 2
        web-mode-css-indent-offset 2
        web-mode-enable-auto-pairing t
        web-mode-enable-css-colorization t))

(use-package emmet-mode
  :straight t
  :defer t
  :hook ((css-mode  . emmet-mode)
         (html-mode . emmet-mode)
         (web-mode  . emmet-mode)
         (sass-mode . emmet-mode)
         (scss-mode . emmet-mode)
         (web-mode  . emmet-mode))
  :bind (:map emmet-mode-keymap
              ("M-RET" . 'emmet-expand-yas)))

;; Support for Go
;;
;; NOTE: Prefer the tree-sitter-based go-ts-mode over go-mode
;; when available, as it provides more accurate syntax parsing and enhanced
;; editing features.
(use-package go-mode
  :commands go-mode
  :mode ("\\.go\\'" . go-mode))

;; Support for Rust
(use-package rust-mode
  :commands rust-mode
  :mode ("\\.rs\\'" . rust-mode)
  :custom
  (rust-indent-offset 2))

;; Major mode for editing crontab files
(use-package crontab-mode
  :commands crontab-mode
  :mode ("/crontab\\(\\.X*[[:alnum:]]+\\)?\\'"  . crontab-mode))

;; Major mode for editing Nginx configuration files
(use-package nginx-mode
  :commands nginx-mode
  :mode (("nginx\\.conf\\'" . nginx-mode)
         ("/nginx/.+\\.conf\\'" . nginx-mode)))

;; Major mode for HashiCorp Configuration Language (HCL) files
(use-package hcl-mode
  :commands hcl-mode
  :mode ("\\.hcl\\'" . hcl-mode))

;; Major mode for Nix expression language files
(use-package nix-mode
  :commands nix-mode
  :mode ("\\.nix\\'" . nix-mode))

;; Major mode for editing Fish shell scripts
(use-package fish-mode
  :commands fish-mode
  :mode ("\\.fish\\'" . fish-mode))

;; Vim configuration file support. This mode provides syntax highlighting and
;; editing support for various Vim configuration files, including vimrc, gvimrc,
;; local overrides, and project-specific configuration files.
(use-package vimrc-mode
  :commands vimrc-mode
  :mode ("\\.vim\\(rc\\)?\\'" . vimrc-mode))

;; Support for Jenkinsfile files
(use-package jenkinsfile-mode
  :commands jenkinsfile-mode
  :mode ("Jenkinsfile\\'" . jenkinsfile-mode))


;; BUFFER --------------------------------------------------------------------------------------------------------------
(use-package buffer-guardian
  :custom
  ;; When non-nil, include remote files in the auto-save process
  (buffer-guardian-inhibit-saving-remote-files t)

  ;; When non-nil, buffers visiting nonexistent files are not saved
  (buffer-guardian-inhibit-saving-nonexistent-files nil)

  ;; Save the buffer even if the window change results in the same buffer
  (buffer-guardian-save-on-same-buffer-window-change t)

  ;; Non-nil to enable verbose mode to log when a buffer is automatically saved
  (buffer-guardian-verbose nil)

  ;; Save all buffers after N seconds of user idle time. (Disabled by default)
  ;; (buffer-guardian-save-all-buffers-idle 30)

  ;; Save all buffers every N seconds. (Disabled by default)
  ;; (setq buffer-guardian-save-all-buffers-interval (* 60 30))

  :hook
  (after-init . buffer-guardian-mode))

;; snippet ---------------------------------------------------------------------------
;; The official collection of snippets for yasnippet.
(use-package yasnippet-snippets
  :after yasnippet)

;; YASnippet is a template system designed that enhances text editing by
;; enabling users to define and use snippets. When a user types a short
;; abbreviation, YASnippet automatically expands it into a full template, which
;; can include placeholders, fields, and dynamic content.
(use-package yasnippet
  :commands (yas-minor-mode
             yas-global-mode)

  :hook
  (after-init . yas-global-mode)

  :custom
  (yas-also-auto-indent-first-line t)  ; Indent first line of snippet
  (yas-also-indent-empty-lines t)
  (yas-snippet-revival nil)  ; Setting this to t causes issues with undo
  (yas-wrap-around-region nil) ; Do not wrap region when expanding snippets
  ;; (yas-triggers-in-field nil)  ; Disable nested snippet expansion
  ;; (yas-indent-line 'fixed) ; Do not auto-indent snippet content
  ;; (yas-prompt-functions '(yas-no-prompt))  ; No prompt for snippet choices

  :init
  ;; Suppress verbose messages
  (setq yas-verbosity 0))



;; VERTICO ----------------------------------------------------------------------
(use-package vertico
  :straight t
  :defer t
  :commands vertico-mode
  :hook ((after-init . vertico-mode)
         (vertico-mode . vertico-multiform-mode))
  :hook (minibuffer-setup . vertico-repeat-save)
  :bind (("M-R" . vertico-repeat)
         :map vertico-map
         ("C-g" . abort-minibuffers)
         ("<escape>" . abort-minibuffers)
         ("RET" . vertico-directory-enter)
         ("DEL" . vertico-directory-delete-char)
         ("M-DEL" . vertico-directory-delete-word))
  :custom
  (vertico-cycle t)
  (vertico-resize nil)
  (vertico-count 12))
(use-package orderless
  ;; Vertico leverages Orderless' flexible matching capabilities, allowing users
  ;; to input multiple patterns separated by spaces, which Orderless then
  ;; matches in any order against the candidates.
  :straight t
  :custom
  (completion-styles '(orderless basic))
  (completion-category-defaults nil)
  (completion-category-overrides '((file (styles partial-completion)))))

;; From https://github.com/abougouffa/minemacs/blob/main/core/me-lib-extra.el
;;;###autoload
(defun +region-or-thing-at-point (&optional leave-region-marked)
  "Return the region or the thing at point.

  If LEAVE-REGION-MARKED is no-nil, don't call `desactivate-mark'
  when a region is selected."
  (when-let* ((thing (ignore-errors
                       (or (prog1 (thing-at-point 'region t)
                             (unless leave-region-marked (deactivate-mark)))
                           (cl-some (+apply-partially-right #'thing-at-point t)
                                    '(symbol email number string word))))))
    ;; If the matching thing has multi-lines, join them
    (string-join (string-lines thing))))

(use-package consult
  :straight t
  :hook (embark-collect-mode . consult-preview-at-point-mode)
  ;; Enable automatic preview at point in the *Completions* buffer. This is
  ;; relevant when you use the default completion UI.
  :hook (completion-list-mode . consult-preview-at-point-mode)
  :bind (;; C-c bindings in `mode-specific-map'
         ("C-c M-x" . consult-mode-command)
         ("C-c h" . consult-history)
         ("C-c k" . consult-kmacro)
         ;; ("C-c m" . consult-man)
         ("C-c i" . consult-info)
         ([remap Info-search] . consult-info)
         ([remap recentf-open-files] . consult-recent-file)
         ([remap recentf] . consult-recent-file)
         ;; C-x bindings in `ctl-x-map'
         ("C-x M-:" . consult-complex-command)
         ("C-x b" . consult-buffer)
         ("C-x 4 b" . consult-buffer-other-window)
         ("C-x 5 b" . consult-buffer-other-frame)
         ("C-x t b" . consult-buffer-other-tab)
         ("C-x r b" . consult-bookmark)
         ("C-x p b" . consult-project-buffer)
         ;; Custom M-# bindings for fast register access
         ("M-#" . consult-register-load)
         ("M-'" . consult-register-store)
         ("C-M-#" . consult-register)
         ;; Other custom bindings
         ("M-y" . consult-yank-pop)
         ;; M-g bindings in `goto-map'
         ("M-g C" . consult-theme)
         ("M-g e" . consult-compile-error)
         ("M-g f" . consult-flymake)
         ("M-g g" . consult-goto-line)
         ("M-g M-g" . consult-goto-line)
         ("M-g o" . consult-outline)
         ("M-g O" . consult-org-heading)
         ("M-g j a" . consult-org-agenda)
         ;; Pulsar commands
         ("M-g l t" . pulsar-recenter-top)
         ("M-g l m" . pulsar-recenter-middle)
         ("M-g l c" . pulsar-recenter-center)
         ("M-g m" . consult-mark)
         ("M-g k" . consult-global-mark)
         ("M-g i" . consult-imenu)
         ("M-g I" . consult-imenu-multi)
         ;; M-s bindings in `search-map'
         ("M-s d" . consult-find)
         ("M-s c" . consult-locate)
         ("M-s g" . consult-grep)
         ("M-s G" . consult-git-grep)
         ("M-s r" . consult-ripgrep)
         ("M-s l" . consult-line)
         ("M-s L" . consult-line-multi)
         ("M-s k" . consult-keep-lines)
         ("M-s u" . consult-focus-lines)
         ;; Isearch integration
         ("M-s e" . consult-isearch-history)
         :map isearch-mode-map
         ("M-e" . consult-isearch-history)
         ("M-s e" . consult-isearch-history)
         ("M-s l" . consult-line)
         ("M-s L" . consult-line-multi)
         ;; Minibuffer history
         :map minibuffer-local-map
         ("M-s" . consult-history)
         ("M-r" . consult-history))

  ;; Enable automatic preview at point in the *Completions* buffer.
  :hook (completion-list-mode . consult-preview-at-point-mode)

  :init
  ;; Optionally configure the register formatting. This improves the register
  (setq register-preview-delay 0.5
        register-preview-function #'consult-register-format)

  ;; Optionally tweak the register preview window.
  (advice-add #'register-preview :override #'consult-register-window)

  ;; Use Consult to select xref locations with preview
  (setq xref-show-xrefs-function #'consult-xref
        xref-show-definitions-function #'consult-xref)

  :config
  ;; Don't preview GPG encrypted files to avoid asking about the decryption password
  (push "\\.gpg$" consult-preview-excluded-files)
  (setq-default completion-in-region-function #'consult-completion-in-region)

  (consult-customize
   consult-theme :preview-key '(:debounce 0.2 any)
   consult-ripgrep consult-git-grep consult-grep consult-find consult-grep consult-fd
   consult-bookmark consult-recent-file consult-xref
   consult--source-bookmark consult--source-file-register
   consult--source-recent-file consult--source-project-recent-file
   ;; :preview-key "M-."
   :preview-key '(:debounce 0.4 any)
   :initial (+region-or-thing-at-point))
  (setq consult-narrow-key "<"))

(use-package embrace
  :straight t
  :bind (("M-s w" . embrace-commander)  ; wrap/surround
         ("M-s a" . embrace-add)        ; add surrounding
         ("M-s x" . embrace-delete))    ; extract/remove surrounding
  :config
  ;; Add custom pairs for programming
  ;; (embrace-add-pair ?` "`" "`")     ; backticks
  ;; (embrace-add-pair ?~ "~" "~")     ; tildes
  ;; (embrace-add-pair ?= "=" "=")     ; equals
  ;; (embrace-add-pair ?/ "/" "/")     ; slashes
  ;; (embrace-add-pair ?_ "_" "_")     ; underscores
  ;; (embrace-add-pair ?* "*" "*")     ; asterisks

  ;; HTML/XML tags
  ;; (embrace-add-pair ?< "<" ">")
 
  ;; Mode-specific pairs using hooks
  (add-hook 'org-mode-hook
            (lambda ()
              (embrace-add-pair ?b "*" "*")   ; bold
              (embrace-add-pair ?i "/" "/")   ; italic
              (embrace-add-pair ?c "~" "~")   ; code
              (embrace-add-pair ?v "=" "=")   ; verbatim
              (embrace-add-pair ?u "_" "_")   ; underline
              (embrace-add-pair ?s "+" "+")))) ; strikethrough

  ;; Enhanced completion for org-mode
  (add-hook 'org-mode-hook
            (lambda ()
              ;; Add useful completion functions for org-mode
              (add-hook 'completion-at-point-functions #'cape-dabbrev nil t)
              (add-hook 'completion-at-point-functions #'cape-file nil t)))
  ;;
  ;; (add-hook 'markdown-mode-hook
  ;;           (lambda ()
  ;;             (embrace-add-pair ?c "`" "`")))
  ;; 
  ;; (add-hook 'gfm-mode-hook
  ;;           (lambda ()
  ;;             (embrace-add-pair ?c "`" "`")))
  ;; 
  ;; (add-hook 'emacs-lisp-mode-hook
  ;;           (lambda ()
;;             (embrace-add-pair ?q "`" "'"))))

;; Some usefull functions
(defun dorneanu/vsplit-file-open (f)
  (let ((evil-vsplit-window-right t))
    (split-window-vertically)
    (find-file f)))

(defun dorneanu/split-file-open (f)
  (let ((evil-split-window-below t))
    (split-window-horizontally)
    (find-file f)))

(use-package embark
  :straight t
  :after (vertico)
  :bind
  (("C-." . embark-act)         ;; pick some comfortable binding
   ("C-;" . embark-dwim)        ;; good alternative: M-.
   ("C-h B" . embark-bindings)  ;; alternative for describe-bindings
   :map embark-file-map
   ("V" . dorneanu/vsplit-file-open)
   ("X" . dorneanu/split-file-open))
  :init
  (setq prefix-help-command #'embark-prefix-help-command)

  :config
  ;; Hide the mode line of the Embark live/completions buffers
  (add-to-list 'display-buffer-alist
               '("\\`\\*Embark Collect \\(Live\\|Completions\\)\\*"
                 nil
                 (window-parameters (mode-line-format . none)))))

;; Using embark and ace
;; (require 'ace-window)

(defun dorneanu/embark-ace-action (fn)
  "Create an embark action that uses ace-window to select target window."
  (lambda (target)
    (with-demoted-errors "%S"
      (let ((window (if (> (length (aw-window-list)) 1)
                        (aw-select "Select window: ")
                      (selected-window))))
        (when window
          (select-window window)
          (funcall fn target))))))

;; Define ace-window variants of common actions
(defun dorneanu/embark-find-file-ace (file)
  "Open file in ace-selected window."
  (let ((window (aw-select "Select window: ")))
    (when window
      (select-window window)
      (find-file file))))

(defun dorneanu/embark-switch-to-buffer-ace (buffer)
  "Switch to buffer in ace-selected window."
  (let ((window (aw-select "Select window: ")))
    (when window
      (select-window window)
      (switch-to-buffer buffer))))

;; Add to embark keymaps
(with-eval-after-load 'embark
  (define-key embark-file-map "O" #'dorneanu/embark-find-file-ace)
  (define-key embark-buffer-map "O" #'dorneanu/embark-switch-to-buffer-ace))

(use-package embark-consult
  :straight t
  :hook
  (embark-collect-mode . consult-preview-at-point-mode))

(use-package counsel
  :straight t
  :commands (counsel-org-tag))

(with-eval-after-load 'org
  ;; (setq org-src-window-setup 'reorganize-frame)
  (setq org-src-fontify-natively t)  ; syntax highlighting for source code blocks

  ;; Tab should do indent in code blocks
  (setq org-src-tab-acts-natively nil)

  ;; Don't remove (or add) any extra whitespace
  (setq org-src-preserve-indentation nil)
  (setq org-edit-src-content-indentation 2))


(org-babel-do-load-languages
 'org-babel-load-languages
 '((sql . t)
   (go . t)
   (plantuml . t)
   (emacs-lisp . t)
   (mermaid . t)
   (graphql . t)
   (shell . t)))

;; Automatically display inline images after babel execution
(add-hook 'org-babel-after-execute-hook 'org-display-inline-images 'append)

(use-package treesit
  :straight (:type built-in)
  :mode (("\\.tsx\\'" . tsx-ts-mode)
         ("\\.py\\'" . python-ts-mode)
         ("\\.cmake\\'" . cmake-ts-mode)
         ("\\.go\\'" . go-ts-mode)
         ("\\.js\\'" . typescript-ts-mode)
         ("\\.mjs\\'" . typescript-ts-mode)
         ("\\.mts\\'" . typescript-ts-mode)
         ("\\.cjs\\'" . typescript-ts-mode)
         ("\\.ts\\'" . typescript-ts-mode)
         ("\\.jsx\\'" . tsx-ts-mode)
         ("\\.json\\'" . json-ts-mode)
         ("\\.yaml\\'" . yaml-ts-mode)
         ("\\.css\\'" . css-ts-mode)
         ("\\.yml\\'" . yaml-ts-mode)
         ("\\.php\\'" . php-ts-mode)
         ("\\.prisma\\'" . prisma-ts-mode)
         ("\\.md\\'" . markdown-mode)
         ("\\.mm\\'" . objc-mode)
         ("\\.mdx\\'" . markdown-mode))
  :preface
  (defun os/setup-install-grammars ()
    "Install Tree-sitter grammars if they are absent."
    (interactive)
    (dolist (grammar
             '((css . ("https://github.com/tree-sitter/tree-sitter-css" "v0.20.0"))
               (html . ("https://github.com/tree-sitter/tree-sitter-html" "v0.20.1"))
               (javascript . ("https://github.com/tree-sitter/tree-sitter-javascript" "v0.21.2" "src"))
               (kotlin "https://github.com/fwcd/tree-sitter-kotlin")
               (json . ("https://github.com/tree-sitter/tree-sitter-json" "v0.20.2"))
               (python . ("https://github.com/tree-sitter/tree-sitter-python" "v0.20.4"))
               (go "https://github.com/tree-sitter/tree-sitter-go" "v0.20.0")
               (markdown "https://github.com/ikatyang/tree-sitter-markdown")
               (make "https://github.com/alemuller/tree-sitter-make")
               (elisp "https://github.com/Wilfred/tree-sitter-elisp")
               (cmake "https://github.com/uyha/tree-sitter-cmake")
               ;; (c "https://github.com/tree-sitter/tree-sitter-c")
               (cpp "https://github.com/tree-sitter/tree-sitter-cpp")
               (objc "https://github.com/tree-sitter-grammars/tree-sitter-objc")
               (toml "https://github.com/tree-sitter/tree-sitter-toml")
               (php "https://github.com/tree-sitter/tree-sitter-php" "v0.22.8" "php/src" )
               (tsx . ("https://github.com/tree-sitter/tree-sitter-typescript" "v0.20.3" "tsx/src"))
               (typescript . ("https://github.com/tree-sitter/tree-sitter-typescript" "v0.20.3" "typescript/src"))
               (yaml . ("https://github.com/ikatyang/tree-sitter-yaml" "v0.5.0"))
               (prisma "https://github.com/victorhqc/tree-sitter-prisma")))
      (add-to-list 'treesit-language-source-alist grammar)
      ;; Only install `grammar' if we don't already have it
      ;; installed. However, if you want to *update* a grammar then
      ;; this obviously prevents that from happening.
      (unless (treesit-language-available-p (car grammar))
        (treesit-install-language-grammar (car grammar)))))

  ;; Optional, but recommended. Tree-sitter enabled major modes are
  ;; distinct from their ordinary counterparts.
  ;;
  ;; You can remap major modes with `major-mode-remap-alist'. Note
  ;; that this does *not* extend to hooks! Make sure you migrate them
  ;; also
  ;;(dolist (mapping
  ;;         '((python-mode . python-ts-mode)
  ;;           (css-mode . css-ts-mode)
  ;;           (typescript-mode . typescript-ts-mode)
  ;;           (js-mode . typescript-ts-mode)
  ;;           (js2-mode . typescript-ts-mode)
  ;;           (c-mode . c-ts-mode)
  ;;           (c++-mode . c++-ts-mode)
  ;;           (c-or-c++-mode . c-or-c++-ts-mode)
  ;;           (bash-mode . bash-ts-mode)
  ;;           (css-mode . css-ts-mode)
  ;;           (json-mode . json-ts-mode)
  ;;           (js-json-mode . json-ts-mode)
  ;;           (sh-mode . bash-ts-mode)
  ;;           (sh-base-mode . bash-ts-mode)))
  ;;  (add-to-list 'major-mode-remap-alist mapping))
  :config
  (os/setup-install-grammars))

(use-package combobulate
  :straight t
  :after (treesit)
  :bind (("C-," . combobulate))
  :preface
  ;; You can customize Combobulate's key prefix here.
  ;; Note that you may have to restart Emacs for this to take effect!
  (setq combobulate-key-prefix "C-x ,")
  ;;
  ;; You can manually enable Combobulate with `M-x
  ;; combobulate-mode'.
  :hook
  ((python-ts-mode . combobulate-mode)
   (js-ts-mode . combobulate-mode)
   (go-mode . go-ts-mode)
   (html-ts-mode . combobulate-mode)
   (css-ts-mode . combobulate-mode)
   (yaml-ts-mode . combobulate-mode)
   (typescript-ts-mode . combobulate-mode)
   (json-ts-mode . combobulate-mode)
   (tsx-ts-mode . combobulate-mode))
  ;; Amend this to the directory where you keep Combobulate's source
  ;; code.
  ;;:load-path ("~/workspace/combobulate")
  )

(use-package python
  :defer t
  :straight t
  :after ob
  :mode (("SConstruct\\'" . python-mode)
         ("SConscript\\'" . python-mode)
         ("[./]flake8\\'" . conf-mode)
         ("/Pipfile\\'"   . conf-mode))
  :init
  (setq python-indent-guess-indent-offset-verbose nil)
  ;; (add-hook 'python-mode-local-vars-hook #'lsp)
  :config
  (setq python-indent-guess-indent-offset-verbose nil)
  (when (and (executable-find "python3")
             (string= python-shell-interpreter "python"))
    (setq python-shell-interpreter "python3")))

;; Activate eglot for python-mode
;; (add-hook 'python-mode-hook 'eglot-ensure)


;; From https://github.com/dakra/dmacs/blob/nil/init.org
(use-package markdown-mode
  :mode (("/itsalltext/.*\\(gitlab\\|github\\).*\\.txt$" . gfm-mode)
         ("\\.markdown\\'" . gfm-mode)
         ("\\.md\\'" . gfm-mode))
  :bind (:map markdown-mode-map
         ("M-n" . markdown-next-visible-heading)
         ("M-p" . markdown-previous-visible-heading)
         ("M-N" . markdown-forward-same-level)
         ("M-P" . markdown-backward-same-level)
         ("M-O" . markdown-up-heading)
         ("M-ö" . markdown-forward-paragraph)
         ("M-ä" . markdown-backward-paragraph)
         ("C-c =" . markdown-insert-header-dwim))
  :hook (gfm-mode . apheleia-mode)
  :config
  ;; Display remote images
  (setq markdown-display-remote-images t)
  ;; Enable fontification for code blocks
  (setq markdown-fontify-code-blocks-natively t)
  ;; Add some more languages
  (dolist (x '(("ini" . conf-mode)
               ("clj" . clojure-mode)
               ("cljs" . clojure-mode)
               ("cljc" . clojure-mode)))
    (add-to-list 'markdown-code-lang-modes x))
  ;; use pandoc with source code syntax highlighting to preview markdown (C-c C-c p)
  (setq markdown-command "pandoc -s --highlight-style pygments -f markdown_github -t html5"))


(use-package eldoc
  :straight t
  :hook (prog-mode . eldoc-mode)
  :bind (:map prog-mode-map
              ("C-c e d" . eldoc)
              ("C-c e t" . eldoc-toggle))
  :init
  (global-eldoc-mode -1)
  :config
  (setq eldoc-documentation-strategy 'eldoc-documentation-compose-eagerly
        eldoc-echo-area-use-multiline-p t
        eldoc-echo-area-display-truncation-message nil
        eldoc-idle-delay 0.1))

(use-package apheleia
  :straight t
  :bind (("C-c f f" . apheleia-format-buffer))
  :config
  ;; For Python we want to format with isort and black
  ;; (setf (alist-get 'isort apheleia-formatters)
  ;;       '("isort" "--stdout" "-"))
  ;; (setf (alist-get 'python-mode apheleia-mode-alist)
  ;;       '(isort black))

  ;; Replace default (black) to use ruff for sorting import and formatting.
  (setf (alist-get 'python-mode apheleia-mode-alist)
        '(ruff-isort ruff))
  (setf (alist-get 'python-ts-mode apheleia-mode-alist)
        '(ruff-isort ruff))

  ;; For golang
  (setf (alist-get 'gofmt apheleia-formatters)
        '("goimports"))
  (apheleia-global-mode))


;; FLYCHECK ------------------------------------------------------------
(use-package flycheck
  :straight t
  :hook (prog-mode . flycheck-mode))

(use-package consult-flycheck
  :straight t
  :bind (("M-g f" . consult-flycheck)))

;; CRUX ----------------------------------------------------------------
(use-package crux
  :straight t
  :bind (("C-x C-d" . crux-duplicate-current-line-or-region)
         ("C-c u" . crux-view-url)
         ("C-c f r" . crux-rename-buffer-and-file)
         ("C-c f d" . crux-delete-file-and-buffer)
         ("C-x C-b" . create-scratch-buffer)
         ;; ("s-k"   . crux-kill-whole-line)
         ;;("s-o"   . crux-smart-open-line-above)
         ("C-a"   . crux-move-beginning-of-line)
         ("C-k"   . crux-kill-whole-line)
         ([(shift return)] . crux-smart-open-line)
         ([(control shift return)] . crux-smart-open-line-above))
  :config
  ;; No need to create a new scratch buffer every time
  ;; Just use one.
  (defun create-scratch-buffer ()
    "Create a scratch buffer."
    (interactive)
    (switch-to-buffer (get-buffer-create "*scratch*"))
    (lisp-interaction-mode))

  (crux-with-region-or-buffer indent-region)
  (crux-with-region-or-buffer untabify)
  (crux-with-region-or-point-to-eol kill-ring-save)
  (defalias 'rename-file-and-buffer #'crux-rename-file-and-buffer))

;; MULTIPLE_CURSOR--------------------------------------------------------------------------------------------------------------
(use-package multiple-cursors  ;; fk off multi cursor what i need
  :bind
  (("M-o" . 'mc/mark-next-like-this)
   ("" . 'mc/mark-previous-like-this)))
;; MOVETEXT --------------------------------------------------------------------------------------------------------------------
(use-package move-text    ;; drag text move around like vim alt + j/k
  :ensure t
  :config
  (move-text-default-bindings)
  (global-set-key (kbd "C-<up>") #'move-text-up)
  (global-set-key (kbd "C-<down>") #'move-text-down))

;; MODLINE ---------------------------------------------------------------------------------------------------------------------
(use-package doom-modeline
  :ensure t
  :init (doom-modeline-mode ))
;;;(setq doom-modeline-buffer-name nil)
(setq doom-modeline-battery nil)
(setq doom-modeline-lsp-icon nil)
(setq doom-modeline-icon nil)
(setq doom-modeline-time nil)
(setq display-time-default-load-average nil)
(setq doom-modeline-time nil)

;; THEMES ---------------------------------------------------------------------------------------------------------------------
(use-package doom-themes
  :straight (:build t)
  :defer t

  )
(use-package kaolin-themes
  :straight t
  :defer t)

(use-package ef-themes
  :straight t)

(use-package modus-themes
  :straight t)

(use-package solarized-theme
  :straight t)

(use-package rg-themes
  :straight (:type git :host github :repo "raegnald/rg-themes"))

(use-package lambda-themes
  :straight (:type git :host github :repo "lambda-emacs/lambda-themes")
  :custom
  (lambda-themes-set-italic-comments t)
  (lambda-themes-set-italic-keywords t)
  (lambda-themes-set-variable-pitch t))

(use-package color-theme-sanityinc-tomorrow
  :straight t)
(use-package spacegray-theme)

(let ((inhibit-redisplay t))
  ;; Disable all active themes
  (mapc #'disable-theme custom-enabled-themes)
  ;; Load the built-in theme
  (load-theme 'modus-operandi t))

;; END --------------------------------------------------------------------------------------------------------------------------

(setq tramp-verbose 1)
(blink-cursor-mode 1)
(setq blink-cursor-interval 0.3 )
(setq tramp-auto-save-directory "/tmp")
(setq enable-dir-local-variables nil)

(load custom-file 'noerror 'no-message)
(minimal-emacs-load-user-init "local-config.el")
