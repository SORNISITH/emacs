;; Native compilation enhances Emacs performance by converting Elisp code into
;; native machine code, resulting in faster execution and improved
;; responsiveness.
;; Ensure adding the following compile-angel code at the very beginning
;; of your `~/.emacs.d/post-init.el` file, before all other packages.
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
  (push "/init.el" compile-angel-excluded-files)
  (push "/custom.el" compile-angel-excluded-files)
  (push "/early-init.el" compile-angel-excluded-files)
  (push "/pre-init.el" compile-angel-excluded-files)
  (push "/package-init.el" compile-angel-excluded-files)
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
;; Enable `auto-save-mode' to prevent data loss. Use `recover-file' or
;; `recover-session' to restore unsaved changes.
(setq auto-save-default t)
;; Trigger an auto-save after 300 keystrokes
(setq auto-save-interval 300)
;; Trigger an auto-save 30 seconds of idle time.
(setq auto-save-timeout 30)

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

(use-package vertico-multiform
  :straight (:type built-in)
  :demand t
  :config
  ;; (setq vertico-multiform-commands
  ;;       '((consult-line
  ;;          posframe
  ;;         (vertico-posframe-poshandler . posframe-poshandler-frame-top-center)
  ;;         (vertico-posframe-fallback-mode . vertico-buffer-mode))
  ;;         (consult-org-heading buffer)
  ;;         (consult-imenu buffer)
  ;;         (consult-ripgrep buffer)
  ;;         (consult-project-buffer buffer)
  ;;         (consult-project-extra-find buffer)))
  ;; (setq vertico-multiform-commands
  ;;       '((consult-line
  ;;          posframe
  ;;          (vertico-posframe-poshandler . posframe-poshandler-frame-top-center)
  ;;          (vertico-posframe-border-width . 10)
  ;;          ;; NOTE: This is useful when emacs is used in both in X and
  ;;          ;; terminal, for posframe do not work well in terminal, so
  ;;          ;; vertico-buffer-mode will be used as fallback at the
  ;;          ;; moment.
  ;;          (vertico-posframe-fallback-mode . vertico-buffer-mode)
  ;;          (consult-project-buffer buffer))
  ;;         (t posframe)))
  ;; (setq vertico-multiform-commands
  ;;       '((consult-line
  ;;          ;; posframe
  ;;          ;; (vertico-posframe-poshandler . posframe-poshandler-frame-top-center)
  ;;          ;; (vertico-posframe-border-width . 10)
  ;;          ;; NOTE: This is useful when emacs is used in both in X and
  ;;          ;; terminal, for posframe do not work well in terminal, so
  ;;          ;; vertico-buffer-mode will be used as fallback at the
  ;;          ;; moment.
  ;;          ;; (vertico-posframe-fallback-mode . vertico-buffer-mode))
  ;;         (t posframe)))
  ;; (add-to-list 'vertico-multiform-categories
  ;;              '(jinx grid (vertico-grid-annotate . 35)))

  (setq vertico-multiform-commands
        '((consult-line reverse buffer)
          (consult-project-buffer buffer)
          (consult-ripgrep buffer)
          (xref-find-references buffer)
          (consult-imenu reverse buffer)))
  (vertico-multiform-mode 1))

(use-package orderless
  ;; Vertico leverages Orderless' flexible matching capabilities, allowing users
  ;; to input multiple patterns separated by spaces, which Orderless then
  ;; matches in any order against the candidates.
  :straight t
  :custom
  (completion-styles '(orderless basic))
  (completion-category-defaults nil)
  (completion-category-overrides '((file (styles partial-completion)))))

(use-package marginalia
  ;; Marginalia allows Embark to offer you preconfigured actions in more contexts.
  ;; In addition to that, Marginalia also enhances Vertico by adding rich
  ;; annotations to the completion candidates displayed in Vertico's interface.
  :straight t
  :defer t
  :bind (("M-A" . marginalia-cycle)
         :map minibuffer-local-map
         ("M-A" . marginalia-cycle))
  :commands (marginalia-mode marginalia-cycle)
  :hook (after-init . marginalia-mode))


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

;; install + load theme




;; (let ((inhibit-redisplay t))
;;   ;; Disable all active themes
;;   (mapc #'disable-theme custom-enabled-themes)
;;   ;; Load the built-in theme
;;   (load-theme 'gruber-darker t))



;; The easysession Emacs package is a session manager for Emacs that can persist
;; and restore file editing buffers, indirect buffers/clones, Dired buffers,
;; windows/splits, the built-in tab-bar (including tabs, their buffers, and
;; windows), and Emacs frames. It offers a convenient and effortless way to
;; manage Emacs editing sessions and utilizes built-in Emacs functions to
;; persist and restore frames.
(use-package easysession
  :commands (easysession-switch-to
             easysession-save-as
             easysession-save-mode
             easysession-load-including-geometry)

  :custom
  (easysession-mode-line-misc-info t)  ; Display the session in the modeline
  (easysession-save-interval (* 10 60))  ; Save every 10 minutes

  :init
  ;; Key mappings
  (global-set-key (kbd "C-c ss") #'easysession-save)
  (global-set-key (kbd "C-c sl") #'easysession-switch-to)
  (global-set-key (kbd "C-c sL") #'easysession-switch-to-and-restore-geometry)
  (global-set-key (kbd "C-c sr") #'easysession-rename)
  (global-set-key (kbd "C-c sR") #'easysession-reset)
  (global-set-key (kbd "C-c sd") #'easysession-delete)

  (if (fboundp 'easysession-setup)
      ;; The `easysession-setup' function adds hooks:
      ;; - To enable automatic session loading during `emacs-startup-hook', or
      ;;   `server-after-make-frame-hook' when running in daemon mode.
      ;; - To automatically save the session at regular intervals, and when
      ;;   Emacs exits.
      (easysession-setup)
    ;; Legacy
    ;; The depth 102 and 103 have been added to to `add-hook' to ensure that the
    ;; session is loaded after all other packages. (Using 103/102 is
    ;; particularly useful for those using minimal-emacs.d, where some
    ;; optimizations restore `file-name-handler-alist` at depth 101 during
    ;; `emacs-startup-hook`.)
    (add-hook 'emacs-startup-hook #'easysession-load-including-geometry 102)
    (add-hook 'emacs-startup-hook #'easysession-save-mode 103)))

;; The markdown-mode package provides a major mode for Emacs for syntax
;; highlighting, editing commands, and preview support for Markdown documents.
;; It supports core Markdown syntax as well as extensions like GitHub Flavored
;; Markdown (GFM).
(use-package markdown-mode
  :commands (gfm-mode
             gfm-view-mode
             markdown-mode
             markdown-view-mode)
  :mode (("\\.markdown\\'" . markdown-mode)
         ("\\.md\\'" . markdown-mode)
         ("README\\.md\\'" . gfm-mode))
  :bind
  (:map markdown-mode-map
        ("C-c C-e" . markdown-do)))
;; Automatically generate a table of contents when editing Markdown files
(use-package markdown-toc
  :commands (markdown-toc-generate-toc
             markdown-toc-generate-or-refresh-toc
             markdown-toc-delete-toc
             markdown-toc--toc-already-present-p)
  :custom
  (markdown-toc-header-toc-title "**Table of Contents**"))

;; Apheleia is an Emacs package designed to run code formatters (e.g., Shfmt,
;; Black and Prettier) asynchronously without disrupting the cursor position.
(use-package apheleia
  :commands (apheleia-mode
             apheleia-global-mode)
  :hook ((prog-mode . apheleia-mode)))

;; Intelligent code folding by using the structural understanding of the
;; built-in tree-sitter parser. Unlike traditional folding methods that rely on
;; regular expressions or indentation, treesit-fold uses the actual syntax tree
;; of the code to accurately identify foldable regions such as functions,
;; classes, comments, and documentation strings. This allows for faster and more
;; precise folding behavior that respects the grammar of the programming
;; language, ensuring that fold boundaries are always syntactically correct even
;; in complex or nested code structures.
(use-package treesit-fold
  :commands (treesit-fold-close
             treesit-fold-close-all
             treesit-fold-open
             treesit-fold-toggle
             treesit-fold-open-all
             treesit-fold-mode
             global-treesit-fold-mode
             treesit-fold-open-recursively
             treesit-fold-line-comment-mode)
  :custom
  (treesit-fold-line-count-show t)
  (treesit-fold-line-count-format " ▼")

  :config
  (set-face-attribute 'treesit-fold-replacement-face nil
                      :foreground "#808080"
                      :box nil
                      :weight 'bold))

;; Systems and General Purpose
(add-hook 'c-ts-mode-hook #'treesit-fold-mode)
(add-hook 'c++-ts-mode-hook #'treesit-fold-mode)
(add-hook 'java-ts-mode-hook #'treesit-fold-mode)
(add-hook 'rust-ts-mode-hook #'treesit-fold-mode)
(add-hook 'go-ts-mode-hook #'treesit-fold-mode)
(add-hook 'ruby-ts-mode-hook #'treesit-fold-mode)

;; Web and Frontend
(add-hook 'js-ts-mode-hook #'treesit-fold-mode)
(add-hook 'typescript-ts-mode-hook #'treesit-fold-mode)
(add-hook 'tsx-ts-mode-hook #'treesit-fold-mode)
(add-hook 'css-ts-mode-hook #'treesit-fold-mode)
(add-hook 'html-ts-mode-hook #'treesit-fold-mode)

;; Scripting and Infrastructure
(add-hook 'bash-ts-mode-hook #'treesit-fold-mode)
(add-hook 'cmake-ts-mode-hook #'treesit-fold-mode)
(add-hook 'dockerfile-ts-mode-hook #'treesit-fold-mode)

;; Data and Configuration
(add-hook 'json-ts-mode-hook #'treesit-fold-mode)
(add-hook 'toml-ts-mode-hook #'treesit-fold-mode)

;; Third-party
;; (add-hook 'kotlin-ts-mode-hook #'treesit-fold-mode)
;; (add-hook 'swift-ts-mode-hook #'treesit-fold-mode)
;; (add-hook 'elixir-ts-mode-hook #'treesit-fold-mode)
;; (add-hook 'zig-ts-mode-hook #'treesit-fold-mode)

(use-package dumb-jump
  :commands dumb-jump-xref-activate
  :init
  ;; Register `dumb-jump' as an xref backend so it integrates with
  ;; `xref-find-definitions'. A priority of 90 ensures it is used only when no
  ;; more specific backend is available.
  (add-hook 'xref-backend-functions #'dumb-jump-xref-activate 90)

  (setq dumb-jump-aggressive nil)
  ;; (setq dumb-jump-quiet t)

  ;; Number of seconds a rg/grep/find command can take before being warned to
  ;; use ag and config.
  (setq dumb-jump-max-find-time 3)
  
  ;; Use `completing-read' so that selection of jump targets integrates with the
  ;; active completion framework (e.g., Vertico, Ivy, Helm, Icomplete),
  ;; providing a consistent minibuffer-based interface whenever multiple
  ;; definitions are found.
  (setq dumb-jump-selector 'completing-read)

  ;; If ripgrep is available, force `dumb-jump' to use it because it is
  ;; significantly faster and more accurate than the default searchers (grep,
  ;; ag, etc.).
  (when (executable-find "rg")
    (setq dumb-jump-force-searcher 'rg)
    (setq dumb-jump-prefer-searcher 'rg)))

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

;; (use-package diff-hl
;;   :commands (diff-hl-mode
;;              global-diff-hl-mode)
;;   :hook (prog-mode . diff-hl-mode)
;;   :init
;;   (setq diff-hl-flydiff-delay 0.4)  ; Faster
;;   (setq diff-hl-show-staged-changes nil)  ; Realtime feedback
;;   (setq diff-hl-update-async t)  ; Do not block Emacs
;;   (setq diff-hl-global-modes '(not pdf-view-mode image-mode)))

;; Org mode is a major mode designed for organizing notes, planning, task
;; management, and authoring documents using plain text with a simple and
;; expressive markup syntax. It supports hierarchical outlines, TODO lists,
;; scheduling, deadlines, time tracking, and exporting to multiple formats
;; including HTML, LaTeX, PDF, and Markdown.
(use-package org
  :commands (org-mode org-version)
  :mode
  ("\\.org\\'" . org-mode)
  :custom
  (org-hide-leading-stars t)
  (org-startup-indented t)
  (org-adapt-indentation nil)
  (org-edit-src-content-indentation 0)
  ;; (org-fontify-done-headline t)
  ;; (org-fontify-todo-headline t)
  ;; (org-fontify-whole-heading-line t)
  ;; (org-fontify-quote-and-verse-blocks t)
  (org-startup-truncated t))

(use-package org-appear
  :commands org-appear-mode
  :hook (org-mode . org-appear-mode))


(use-package buffer-terminator
  :custom
  ;; Enable/Disable verbose mode to log buffer cleanup events
  (buffer-terminator-verbose nil)

  ;; Set the inactivity timeout (in seconds) after which buffers are considered
  ;; inactive (default is 30 minutes):
  (buffer-terminator-inactivity-timeout (* 30 60)) ; 30 minutes

  ;; Define how frequently the cleanup process should run (default is every 10
  ;; minutes):
  (buffer-terminator-interval (* 10 60)) ; 10 minutes

  :config
  (buffer-terminator-mode 1))

;; Helpful is an alternative to the built-in Emacs help that provides much more
;; contextual information.
;; From https://github.com/dakra/dmacs/blob/nil/init.org#L2056
(use-package helpful
  :straight t
  :bind (("C-h ." . helpful-at-point)
         ("C-h f" . helpful-callable)
         ("C-h v" . helpful-variable)
         ("C-h f" . helpful-function)
         ("C-h s" . describe-symbol)
         ("C-h k" . helpful-key)
         ;; ("C-c h f" . helpful-callable)
         ;; ("C-c h v" . helpful-variable)
         ;; ("C-c h c" . helpful-command)
         ;; ("C-c h m" . helpful-macro)
         ("<C-tab>" . backward-button)
         :map helpful-mode-map
         ("M-?" . helpful-at-point)
         ("RET" . helpful-jump-to-org)
         :map emacs-lisp-mode-map
         ("M-?" . helpful-at-point)
         :map lisp-interaction-mode-map  ; Scratch buffer
         ("M-?" . helpful-at-point))
  :config
  (defun helpful-visit-reference ()
    "Go to the reference at point."
    (interactive)
    (let* ((sym helpful--sym)
           (path (get-text-property (point) 'helpful-path))
           (pos (get-text-property (point) 'helpful-pos))
           (pos-is-start (get-text-property (point) 'helpful-pos-is-start)))
      (when (and path pos)
        ;; If we're looking at a source excerpt, calculate the offset of
        ;; point, so we don't just go the start of the excerpt.
        (when pos-is-start
          (save-excursion
            (let ((offset 0))
              (while (and
                      (get-text-property (point) 'helpful-pos)
                      (not (eobp)))
                (backward-char 1)
                (setq offset (1+ offset)))
              ;; On the last iteration we moved outside the source
              ;; excerpt, so we overcounted by one character.
              (setq offset (1- offset))

              ;; Set POS so we go to exactly the place in the source
              ;; code where point was in the helpful excerpt.
              (setq pos (+ pos offset)))))

        (find-file path)
        (when (or (< pos (point-min))
                  (> pos (point-max)))
          (widen))
        (goto-char pos)
        (recenter 0)
        (save-excursion
          (let ((defun-end (scan-sexps (point) 1)))
            (while (re-search-forward
                    (rx-to-string `(seq symbol-start ,(symbol-name sym) symbol-end))
                    defun-end t)
              (helpful--flash-region (match-beginning 0) (match-end 0)))))
        t))))
(use-package bufferfile
  :commands (bufferfile-copy
             bufferfile-rename
             bufferfile-delete)
  :custom
  ;; If non-nil, display messages during file renaming operations
  (bufferfile-verbose nil)

  ;; If non-nil, enable using version control (VC) when available
  (bufferfile-use-vc nil)

  ;; Specifies the action taken after deleting a file and killing its buffer.
  (bufferfile-delete-switch-to 'parent-directory))



                                        ; ;; Enables automatic indentation of code while typing
                                        ; (use-package aggressive-indent
                                        ;   :commands aggressive-indent-mode
                                        ;   :hook
                                        ;   (emacs-lisp-mode . aggressive-indent-mode))
                                        ;
                                        ; ;; Highlights function and variable definitions in Emacs Lisp mode
                                        ; (use-package highlight-defined
                                        ;   :commands highlight-defined-mode
                                        ;   :hook
                                        ;   (emacs-lisp-mode . highlight-defined-mode))

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


(use-package persist-text-scale
  :commands (persist-text-scale-mode
             persist-text-scale-restore)

  :hook (after-init . persist-text-scale-mode)

  :custom
  (text-scale-mode-step 1.07))


;; `vterm' is an Emacs terminal emulator that provides a fully interactive shell
;; experience within Emacs, supporting features such as color, cursor movement,
;; and advanced terminal capabilities. Unlike standard Emacs terminal modes,
;; `vterm' utilizes the libvterm C library for high-performance emulation. This
;; ensures accurate terminal behavior when running shell programs, text-based
;; applications, and REPLs.
(use-package vterm
  :if (bound-and-true-p module-file-suffix)
  :commands (vterm
             vterm-send-string
             vterm-send-return
             vterm-send-key
             vterm-module-compile)

  :preface
  (when noninteractive
    ;; vterm unnecessarily triggers compilation of vterm-module.so upon loading.
    ;; This prevents that during byte-compilation (`use-package' eagerly loads
    ;; packages when compiling).
    (advice-add #'vterm-module-compile :override #'ignore))
  (defun my-vterm--setup ()
    ;; Hide the mode-line
    (setq mode-line-format nil)
    ;; Inhibit early horizontal scrolling
    (setq-local hscroll-margin 0)
    ;; Suppress prompts for terminating active processes when closing vterm
    (setq-local confirm-kill-processes nil))

  :init
  (add-hook 'vterm-mode-hook #'my-vterm--setup)

  (setq vterm-timer-delay 0.05)  ; Faster vterm
  (setq vterm-kill-buffer-on-exit t)
  (setq vterm-max-scrollback 5000))

;; The Emacs server allows external programs such as `emacsclient' to connect to
;; a single running instance of Emacs. This makes it possible to open files in
;; the existing session rather than starting a new Emacs process each time.
;;
;; Once the server is running, the `emacsclient' command can be used in the
;; terminal to open files in the active Emacs session. For example, running the
;; following command opens the file in the existing Emacs frame without blocking
;; the terminal process.
;;   emacsclient -n filename.txt
;;
(use-package server
  :ensure nil
  :if (not (daemonp))
  :commands (server-running-p
             server-start)
  :hook (after-init . my-server-start)
  :preface
  (defun my-server-start ()
    "Start the Emacs server if no server process is currently active."
    (unless (server-running-p)
      (server-start))))

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
(add-hook 'after-init-hook #'winner-mode)
(add-hook 'after-init-hook #'show-paren-mode)
(add-hook 'after-init-hook #'window-divider-mode)
;; Display of line numbers in the buffer:

(dolist (hook '(prog-mode-hook text-mode-hook conf-mode-hook))
  (add-hook hook #'display-line-numbers-mode))

;; Set the maximum level of syntax highlighting for Tree-sitter modes
(setq treesit-font-lock-level 4)

(use-package which-key
  :ensure nil ; builtin
  :commands which-key-mode
  :hook (after-init . which-key-mode)
  :custom
  (which-key-idle-delay 1.5)
  (which-key-idle-secondary-delay 0.25)
  (which-key-add-column-padding 1)
  (which-key-max-description-length 40))
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

                                        ; (use-package uniquify
                                        ;   :ensure nil
                                        ;   :custom
                                        ;   (uniquify-buffer-name-style 'reverse)
                                        ;   (uniquify-separator "•")
                                        ;   (uniquify-after-kill-buffer-p t))



;; modification date, etc.) and all the files in the `dired-omit-files' regular
;; Hide files from dired
(setq dired-movement-style 'bounded-files)
(setq dired-omit-files (concat "\\`[.]\\'"
                               "\\|\\(?:\\.js\\)?\\.meta\\'"
                                        ;                               "\\|\\.\\(?:elc|a\\|o\\|pyc\\|pyo\\|swp\\|class\\)\\'"
                               "\\|^\\.DS_Store\\'"
                               "\\|^\\.\\(?:svn\\|git\\)\\'"
                               "\\|^\\.ccls-cache\\'"
                               "\\|^__pycache__\\'"
                               "\\|^\\.project\\(?:ile\\)?\\'"
                               "\\|^flycheck_.*"
                               "\\|^flymake_.*"))



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

;; enables visual indication of minibuffer recursion depth after initialization.
(add-hook 'after-init-hook #'minibuffer-depth-indicate-mode)
;; Configure Emacs to ask for confirmation before exiting
(setq confirm-kill-emacs 'y-or-n-p)
;; Enabled backups save your changes to a file intermittently
(setq kept-old-versions 10)
(setq kept-new-versions 10)
;; When tooltip-mode is enabled, certain UI elements (e.g., help text,

(use-package treesit-auto
  :custom
  (treesit-auto-install 'prompt)
  :config
  (treesit-auto-add-to-auto-mode-alist 'all)
  (global-treesit-auto-mode))

(use-package crux   ;;;  duplicate line
  :ensure t
  :bind (("M-i" . crux-duplicate-current-line-or-region)))
(use-package crux
  :straight t
  :bind (("C-x C-d" . crux-duplicate-current-line-or-region)
         ("M-i" . crux-duplicate-current-line-or-region)
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
(use-package multiple-cursors  ;; fk off multi cursor what i need
  :bind
  (("M-o" . 'mc/mark-next-like-this)
   ("" . 'mc/mark-previous-like-this)))

;; Highlight TODO keywords
(use-package hl-todo
  :straight (:host github :repo "tarsius/hl-todo")
  :hook (prog-mode . hl-todo-mode)
  :config
  (cl-callf append hl-todo-keyword-faces
    '(("BUG"   . "#ee5555")
      ("FIX"   . "#0fa050")
      ("PROJ"  . "#447f44")
      ("IDEA"  . "#0fa050")
      ("INFO"  . "#0e9030")
      ("TWEAK" . "#fe9030")
      ("PERF"  . "#e09030"))))

(use-package move-text    ;; drag text move around like vim alt + j/k
  :ensure t
  :config
  (move-text-default-bindings)
  (global-set-key (kbd "C-<up>") #'move-text-up)
  (global-set-key (kbd "C-<down>") #'move-text-down))

(use-package nerd-icons
  ;; :custom
  ;; The Nerd Font you want to use in GUI
  ;; "Symbols Nerd Font Mono" is the default and is recommended
  ;; but you can use any other Nerd Font if you want
  ;; (nerd-icons-font-family "Symbols Nerd Font Mono")
  )

(use-package doom-modeline
  :ensure t
  :init (doom-modeline-mode 1))
(setq doom-modeline-battery nil)
(setq doom-modeline-lsp-icon nil)
(setq doom-modeline-icon nil)
(setq doom-modeline-time nil)
(setq display-time-default-load-average nil)
(setq doom-modeline-time nil)

(use-package forge
  :after magit)

(use-package eldoc
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
;; Quickly switch windows in Emacs
;;
(use-package ibuffer
  :defer t
  :commands (ibuffer)
  :custom
  (ibuffer-default-display-maybe-show-predicates t)
  (ibuffer-saved-filter-groups
   '(("Default"
      ("Programming" (mode . prog-mode))
      ("Org" (mode . org-mode))
      ("Magit" (name . "^magit"))
      ("Dired" (mode . dired-mode))
      ("Help" (or (name . "^\\*Help\\*")
                  (name . "^\\*Apropos\\*")
                  (name . "^\\*info\\*"))))))
  :init
  (add-hook 'ibuffer-mode-hook
            #'(lambda ()
                (ibuffer-switch-to-saved-filter-groups "default"))))
(use-package ibuffer-projectile
  :straight t
  :hook (ibuffer . (lambda ()
                     (ibuffer-projectile-set-filter-groups)
                     (unless (eq ibuffer-sorting-mode 'alphabetic)
                       (ibuffer-do-sort-by-alphabetic)))))


(use-package popper
  :straight t
  :bind (("C-'"   . popper-toggle)
         ("M-'"   . popper-cycle)
         ("C-M-'" . popper-toggle-type))
  :init
  (setq popper-reference-buffers
        '("\\*Messages\\*"
          "Output\\*$"
          "\\*Async Shell Command\\*"
          help-mode
          compilation-mode))
  (popper-mode +1)
  (popper-echo-mode +1))                ; For echo area hints


(use-package nov
  :ensure t
  :mode ("\\.epub\\'" . nov-mode)
  :config
  (setq nov-text-width 95))
;; writeable grepx

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
(load-theme 'modus-operandi-deuteranopia t)

;; --------------------------------------------------------------------------------------------------
;; LSP 
(add-to-list 'load-path "~/.emacs.d/lsp-bridge/")
(require 'lsp-bridge)
(global-lsp-bridge-mode)
(setq lsp-bridge-python-command "~/.pyenv/versions/3.13.13/bin/python3")
(setq acm-candidate-match-function 'orderless-initialism)
(setq acm-enable-doc nil)
(setq acm-enable-preview t)
(setq acm-backend-search-file-words-max-number 5)
(setq lsp-bridge-enable-search-words nil)
(setq acm-enable-tabnine nil)
(setq magit-view-git-manual-method 'man)
(add-hook 'compilation-mode-hook #'acm-mode)
;; END LSP -------------------------------------------------------------------------------------------
;; 
(setq tramp-verbose 1)
(blink-cursor-mode 1)
(setq blink-cursor-interval 0.3 )
(setq tramp-auto-save-directory "/tmp")
(load custom-file 'noerror 'no-message)
(minimal-emacs-load-user-init "local-config.el")
