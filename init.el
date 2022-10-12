;; -*- lexical-binding: t -*-
(set-language-environment "UTF-8")
(require 'package)
(add-to-list 'package-archives '("melpa" . "https://melpa.org/packages/") t)
(package-initialize)
(unless (package-installed-p 'use-package)
  (package-refresh-contents)
  (package-install 'use-package))

(eval-when-compile
  (require 'use-package))

(setq custom-file "~/.emacs.d/custom.el")
(load custom-file)
(tool-bar-mode -1)
(menu-bar-mode -1)
(scroll-bar-mode -1)
(load-theme 'modus-operandi)
(use-package moody
  :ensure t
  :config
  (setq x-underline-at-descent-line t)
  (moody-replace-vc-mode)
  (moody-replace-mode-line-buffer-identification)
  (moody-replace-eldoc-minibuffer-message-function))


(use-package expand-region
  :ensure t
  :bind (("s-<return>" . er/expand-region))
  :config
  (load (concat (expand-file-name user-emacs-directory) "expand-org.el")))
(use-package embrace
  :ensure t
  :bind (("C-=" . embrace-commander))
  :hook (org-mode . embrace-org-mode-hook))
(use-package org-appear
  :ensure t
  :hook (org-mode . org-appear-mode)
  )

(use-package org
  :init

  (setq org-agenda-files '("~/Sync/todo.org")
	org-stuck-projects '("+LEVEL=2+PROJECT" ("TODO") nil "")

	org-latex-pdf-process (list "latexmk -output-directory=%o -f -pdf %f")
	org-capture-templates '(("t" "Personal todo" entry
                                 (file+headline "~/Sync/todo.org" "Inbox")
                                 "* TODO %?\n%i\n" :prepend t)
                                ("n" "Personal notes" entry
                                 (file+headline "~/Sync/notes.org" "Inbox")
                                 "* %u %?\n%i\n" :prepend t))
        org-refile-targets '((nil . (:maxlevel . 2)) ("~/Sync/archive.org" . (:level . 1)))
	org-M-RET-may-split-line '((default . nil))
        org-default-notes-file "~/Sync/todo.org"
        org-directory "~/Sync/"
        org-todo-keywords '((sequence "TODO(t)" "WAIT(w)" "|" "DONE(d)" "KILL(k)") (sequence "[ ](T)" "[?](W)" "[P](P)" "|" "[X](D)" "[-](K)" ))
        org-pretty-entities t
        org-hide-emphasis-markers t
        org-roam-directory "~/Sync/org-roam"
        org-superstar-headline-bullets-list '(" ")
        org-attach-id-dir ".attach"
        org-ellipsis ""
	org-export-in-background t
	org-highlight-latex-and-related '(script entities)
        org-agenda-block-separator "")
  
  
  (global-set-key (kbd "C-c l") #'org-store-link)
  (global-set-key (kbd "C-c a") #'org-agenda)
  (global-set-key (kbd "C-c c") #'org-capture)
  (add-hook 'org-mode-hook #'org-indent-mode)
  (add-hook 'auto-save-hook 'org-save-all-org-buffers)
  (add-hook 'org-mode-hook #'visual-line-mode)
  (add-hook 'org-mode-hook #'abbrev-mode)
  (defun biblatex-setup ()
    (bibtex-set-dialect 'biblatex))
  (add-hook 'org-mode-hook #'biblatex-setup)
  :config
  (add-to-list 'org-structure-template-alist '("t" . "theorem"))
  (add-to-list 'org-structure-template-alist '("ll" . "lemma"))
  (add-to-list 'org-structure-template-alist '("p" . "proof"))
  (add-to-list 'org-structure-template-alist '("r" . "result"))
  )

;; (use-package xenops
;;   :ensure t
;;   :hook (org-mode . #'xenops-mode)
;;   :custom ((xenops-reveal-on-entry t)))

(use-package oc-biblatex
  :init (setq org-cite-export-processors '((latex biblatex) (t csl))))
(require 'tramp)
(push
 (cons
  "toolbox"
  '((tramp-login-program "flatpak-spawn --host toolbox")
    (tramp-login-args (("enter" "-c") ("%h")))
    (tramp-remote-shell "/bin/bash")
    (tramp-remote-shell-args ("-i") ("-c"))))
 tramp-methods)


(use-package cdlatex
  :ensure t
  :hook (org-mode . org-cdlatex-mode)
  :init (defun add-labelled-env (environment shortcut)
	  (add-to-list 'cdlatex-env-alist (list environment (format "\\begin{%s}\nAUTOLABEL\n?\n\\end{%s}" environment environment) nil))
	  (add-to-list 'cdlatex-command-alist (list shortcut (format "Insert %s env" environment) "" 'cdlatex-environment (list environment) t nil)))
  (defun jake/cdlatex-hook ()
    
    (cdlatex-mode)
    ;; Fixing #35 on github, cdlatex-takeover-parenthesis doesn't work...
    (unbind-key "(" cdlatex-mode-map)
    (unbind-key "{" cdlatex-mode-map)
    (unbind-key "[" cdlatex-mode-map))
  
  (add-hook 'LaTeX-mode-hook 'jake/cdlatex-hook)
  (setq cdlatex-use-dollar-to-ensure-math nil)
  
  :config
  
  (add-hook 'cdlatex-mode-hook
	    (lambda () (when (eq major-mode 'org-mode)
			 (make-local-variable 'org-pretty-entities-include-sub-superscripts)
			 (setq org-pretty-entities-include-sub-superscripts nil))))
  (add-to-list 'cdlatex-math-modify-alist
	       '(115 "\\mathbb" nil t nil nil))
  (dolist (kv '(("theorem" "thm") ("definition" "def") ("corollary" "cor") ("lemma" "lem")))
    (add-labelled-env (car kv) (cadr kv))))




(use-package magit
  :ensure t
  :bind (("C-x g" . magit-status)))

(use-package which-key
  :ensure t
  :config (which-key-mode))
(use-package corfu
  :ensure t
  :custom
  (corfu-cycle t)
  :init
  (global-corfu-mode))

(use-package flyspell
  :hook ((text-mode . flyspell-mode)
	 (prog-mode . flyspell-prog-mode)))
(use-package flymake
  :hook (prog-mode . flymake-mode))
(use-package flymake-collection
  :ensure t
  :hook (after-init . flymake-collection-hook-setup)
  :init
  (add-hook 'LaTeX-mode-hook (lambda () (add-hook 'flymake-diagnostic-functions 'flymake-collection-proselint nil t) (flymake-mode))))

(use-package embark
  :ensure t
  :bind (("C-," . embark-act)))

(use-package latex
  :ensure auctex
  :init
  (setq TeX-auto-save t
	TeX-parse-self t
	TeX-electric-math (cons "\\(" "\\)")
	LaTeX-electric-left-right-brace t
	TeX-electric-sub-and-superscript t
	TeX-command-extra-options "-shell-escape"
	TeX-master nil
	TeX-engine 'xetex)
  :flymake-hook (LaTeX-mode
		 flymake-collection-proselint)
  :hook ((TeX-after-compilation-finished-functions . TeX-revert-document-buffer)
	 (LaTeX-mode . turn-on-auto-fill)
	 (LaTeX-mode . LaTeX-math-mode)
	 (LaTeX-mode . jake/rem-environments))
  :config
  (defun jake/theorem-environments ()
    (LaTeX-add-environments '("theorem"  LaTeX-env-label)
			    '("lemma" LaTeX-env-label)
			    '("definition" LaTeX-env-label)
			    '("corollary" LaTeX-env-label))
    (setf LaTeX-label-alist (cl-list* '("lemma" . "lem:") '("theorem" . "thm:") '("definition" . "def:") '("corollary" . "cor:") LaTeX-label-alist))))
(use-package reftex
  :ensure t
  :after latex
  :hook ((LaTeX-mode . reftex-mode))
  :init (setq reftex-plug-into-AUCTeX t)
  :config
  (add-to-list 'reftex-label-alist '("theorem" ?h "thm:" "~\\ref{%s}" t ("Theorem" "theorem") nil) )  
  (add-to-list 'reftex-label-alist '("definition" ?d "def:" "~\\ref{%s}" t ("Definition" "definition") nil) )  
  (add-to-list 'reftex-label-alist '("corollary" ?c "cor:" "~\\ref{%s}" t ("Corollary" "corollary") nil) )
  (add-to-list 'reftex-label-alist '("lemma" ?m "lem:" "~\\ref{%s}" t ("Lemma" "lemma") nil) )
  (reftex-reset-mode))
(use-package tree-sitter
  :ensure t
  :config
  (global-tree-sitter-mode))

(use-package tree-sitter-langs
  :ensure t)

(use-package gap
  :mode (("\\.g\\'" . gap-mode)
	 ("\\.gap\\'" . gap-mode))
  :custom  ((gap-start-options '("-f" "-b" "-m" "2m" "-E")))
  :ensure gap-mode
  :init
  (setq gap-executable "/usr/bin/gap"
	gap-electric-semicolon nil
	gap-electric-equals nil))


(use-package popwin
  :ensure t
  :config
  (defun popup-eshell ()
    (interactive)
    (let* ((parent (if (buffer-file-name)
		       (file-name-directory (buffer-file-name))
		     default-directory))
	   (name (format "*eshell-popup:%s*" parent))
	   (buf-exists (get-buffer name))
	   (new-buf (get-buffer-create name)))
      (with-current-buffer new-buf
	(when (null buf-exists)
	  (eshell-mode))
	(popwin:popup-buffer new-buf))))

  (global-set-key (kbd "C-c .") #'popup-eshell)
  (defun popup-scratch ()
    (interactive)
      (popwin:popup-buffer (get-buffer "*scratch*")))
  (global-set-key (kbd "C-c x") #'popup-scratch)
  (setq popwin:special-display-config
	(append popwin:special-display-config '(("*Help*" :height 0.4 :stick t)
						("\\*.*" :regexp t :position bottom :noselect t :height 0.3 :stick t)
						;; Debug
						("*Warnings*" :position bottom :height 0.3 )
						("*Backtrace*" :position bottom :height 0.3 )
						("*Messages*" :position bottom :height 0.3 )
						("*Compile-Log*" :position bottom :height 0.3 )
						("*Shell Command Output*" :position bottom :height 0.3 )
						(".*overtone.log" :regexp t :height 0.3)
						("collected.org" :position top :height 15)
						(flycheck-error-list-mode :position bottom :height 0.3 :stick t)
						(compilation-mode :position bottom :height 0.3 :noselect t)
						;; Utils
						("helm" :regexp t :height 0.3)
						("*Occur*" :position bottom :height 0.3)
						("\\*Slime Description.*" :noselect t :regexp t :height 0.3)
						("*undo-tree*" :width 0.3 :position right)
						("*grep*" :position bottom :height 0.2 :stick t)
						("*Completions*" :height 0.4)
						("*compilation*" :height 0.4 :noselect t :stick t)
						("*quickrun*" :height 0.3 :stick t)
						;; Magit/vc
						(magit-status-mode :position bottom :noselect t :height 0.3 :stick t)
						("COMMIT_EDITMSG" :position bottom :noselect t :height 0.3 :stick t)
						("*magit-commit*" :position bottom :noselect t :height 0.3 :stick t)
						("\\*magit.*" :regexp t :position bottom :noselect t :height 0.3 :stick t)
						("*magit-diff*" :position bottom :noselect t :height 0.3)
						("*magit-edit-log*" :position bottom :noselect t :height 0.2)
						("*magit-process*" :position bottom :noselect t :height 0.2)
						("*vc-diff*" :position bottom :noselect t :height 0.2)
						("*vc-change-log*" :position bottom :noselect t :height 0.2)
						;; Navigator
						("*Ibuffer*" :position bottom :height 0.2)
						("*Ido Completions*" :noselect t :height 0.3)
						("*imenu-tree*" :position left :width 50 :stick t)
						("*gists*" :height 0.3)
						("*sldb.*":regexp t :height 0.3)
						("*Gofmt Errors*" :noselect t)
						("\\*godoc*" :regexp t :height 0.3)
						("*nrepl-error*" :height 0.2 :stick t)
						("*nrepl-doc*" :height 0.2 :stick t)
						("*nrepl-src*" :height 0.2 :stick t)
						("*Kill Ring*" :height 0.3)
						("*project-status*" :noselect t)
						("*Compile-Log" :height 0.2 :stick t)
						("*pytest*" :noselect t)
						;; Programing
						("Django:" :regexp t :width 0.3 :position right)
						("*Python*" :stick t)
						("*jedi:doc*" :noselect t)
						;; Console
						("*shell*" :height 0.3)
						("\\*ansi-term.*\\*" :regexp t :height 0.3)
						("\\*terminal.*\\*" :regexp t :height 0.3)
						;; Org/Organized
						(diary-fancy-display-mode :position left :width 50 :stick nil)
						(diary-mode :position bottom :height 15 :stick t)
						(calendar-mode :position bottom :height 15 :stick nil)
						(org-agenda-mode :position bottom :height 15 :stick t)
						("*Org Agenda.*\\*" :regexp t :position bottom :height 15 :stick t)
						("^CAPTURE-.+\*.org$" :regexp t)
						("*Select*" :height 0.2 :noselect nil :stick t))))
  (popwin-mode 1))

(use-package eglot
  :ensure t
  :init
  (add-hook 'LaTeX-mode-hook #'eglot-ensure))
(use-package recentf
  :config (recentf-mode))

(use-package savehist
  :config
  (savehist-mode))
(use-package transient
  :config
  (with-eval-after-load 'org
    (transient-define-prefix org-element-transient ()
      "Org Mode Element Transient State"
      ["Motion"
       ("b" "Up Element" org-up-element :transient t)
       ("f" "Down Element" org-down-element :transient t)
       ("n" "Forward Element" org-forward-element :transient t)
       ("p" "Backward Element" org-backward-element :transient t)
       ("TAB" "Cycle Visibility" org-cycle :transient t)
       ("RET" "Quit" transient-quit-all)]
      ["Move"
       ("P" "Move Subtree Up" org-move-subtree-up :transient t)
       ("N" "Move Subtree Down" org-move-subtree-down :transient t)
       ("B" "Promote Subtree" org-promote-subtree :transient t)
       ("F" "Demote Subtree" org-demote-subtree :transient t)]
      ["Store"
       ("c" "Store Link" org-store-link :transient t)])
    (define-key org-mode-map (kbd "C-c C-j") #'org-element-transient)))

(use-package emacs
  :init
  (keyboard-translate ?\C-t ?\C-x)
  (keyboard-translate ?\C-x ?\C-t)
  (electric-pair-mode)
  (electric-indent-mode t)
  (defun smarter-move-beginning-of-line (arg)
    "Move point back to indentation of beginning of line.

Move point to the first non-whitespace character on this line.
If point is already there, move to the beginning of the line.
Effectively toggle between the first non-whitespace character and
the beginning of the line.

If ARG is not nil or 1, move forward ARG - 1 lines first.  If
point reaches the beginning or end of the buffer, stop there."
    (interactive "^p")
    (setq arg (or arg 1))

    ;; Move lines first
    (when (/= arg 1)
      (let ((line-move-visual nil))
	(forward-line (1- arg))))

    (let ((orig-point (point)))
      (back-to-indentation)
      (when (= orig-point (point))
	(move-beginning-of-line 1))))

  ;; remap C-a to `smarter-move-beginning-of-line'
  (global-set-key [remap move-beginning-of-line]
                  'smarter-move-beginning-of-line)

  (add-hook 'after-init-hook #'repeat-mode)
  (set-default-coding-systems 'utf-8)
  (defun crm-indicator (args)
    (cons (format "[CRM%s] %s"
                  (replace-regexp-in-string
                   "\\`\\[.*?]\\*\\|\\[.*?]\\*\\'" ""
                   crm-separator)
                  (car args))
          (cdr args)))
  (advice-add #'completing-read-multiple :filter-args #'crm-indicator)

  ;; Do not allow the cursor in the minibuffer prompt
  (setq minibuffer-prompt-properties
        '(read-only t cursor-intangible t face minibuffer-prompt))
  (add-hook 'minibuffer-setup-hook #'cursor-intangible-mode)

  ;; Emacs 28: Hide commands in M-x which do not work in the current mode.
  ;; Vertico commands are hidden in normal buffers.
  ;; (setq read-extended-command-predicate
  ;;       #'command-completion-default-include-p)
  (global-auto-revert-mode)
  ;; Enable recursive minibuffers
  (setq enable-recursive-minibuffers t)
  (defconst emacs-tmp-dir (expand-file-name (format "emacs%d" (user-uid)) temporary-file-directory))
  (setq
   completions-format 'one-column
   completions-header-format nil
   completions-max-height 20
   completion-auto-select nil
   initial-frame-alist '((fullscreen . fullscreen))
   dired-dwim-target t
   sentence-end-double-space nil
   tab-always-indent 'complete
   inhibit-startup-screen t
   initial-scratch-message ""
   ring-bell-function 'ignore
   linum-format "%4d "
   ispell-alternate-dictionary "/usr/share/dict/words"
   ispell-program-name "hunspell"
   backup-by-copying t                                        ; Avoid symlinks
   delete-old-versions t
   kept-new-versions 6
   kept-old-versions 2
   version-control t
   auto-save-list-file-prefix emacs-tmp-dir
   completion-cycle-threshold 3
   tab-always-indent 'complete
   initial-major-mode #'org-mode
   read-buffer-completion-ignore-case t
   read-file-name-completion-ignore-case t
   auto-save-file-name-transforms `((".*" ,emacs-tmp-dir t))  ; Change autosave dir to tmp
   backup-directory-alist `((".*" . ,emacs-tmp-dir)))
  (setq-default cursor-type 'bar)           ; Line-style cursor similar to other text editors
  (setq-default frame-title-format '("%b")) ; Make window title the buffer name
  (setq-default display-line-numbers t)
  (fset 'yes-or-no-p 'y-or-n-p)             ; y-or-n-p makes answering questions faster
  (show-paren-mode 1)                       ; Show closing parens by default
  (delete-selection-mode 1)                 ; Selected text will be overwritten when you start typing
  (global-auto-revert-mode t)
  (define-key minibuffer-mode-map (kbd "C-n") 'minibuffer-next-completion)
  (define-key minibuffer-mode-map (kbd "C-p") 'minibuffer-prev-completion)
  (defadvice he-substitute-string (after he-paredit-fix)
    "remove extra paren when expanding line in paredit."

    (if (and electric-pair-mode (equal (substring str -1) ")"))
	(progn
          (backward-delete-char 1)
          (forward-char))))
  (global-set-key (kbd "M-/") 'hippie-expand)
  
  (setq abbrev-file-name "~/.emacs.d/abbrev.el")
  (info-initialize))


;; (use-package vertico
;;   :ensure t
;;   :init
;;   (vertico-mode)

;;   ;; Different scroll margin
;;   ;; (setq vertico-scroll-margin 0)

;;   ;; Show more candidates
;;   ;; (setq vertico-count 20)

;;   ;; Grow and shrink the Vertico minibuffer
;;   ;; (setq vertico-resize t)

;;   ;; Optionally enable cycling for `vertico-next' and `vertico-previous'.
;;   ;; (setq vertico-cycle t)
;;   )


(use-package savehist
  :init
  (savehist-mode))

(use-package orderless
  :ensure t
  :init
  ;; Configure a custom style dispatcher (see the Consult wiki)
  ;; (setq orderless-style-dispatchers '(+orderless-dispatch)
  ;;       orderless-component-separator #'orderless-escapable-split-on-space)
  (setq completion-styles '(orderless basic)
        completion-category-defaults nil
        completion-category-overrides '((file (styles partial-completion)))))


;; Example configuration for Consult
(use-package consult
  ;; Replace bindings. Lazily loaded due by `use-package'.
  :ensure t
  :bind (;; C-c bindings (mode-specific-map)
         ("C-c h" . consult-history)
         ("C-c m" . consult-mode-command)
         ("C-c k" . consult-kmacro)
         ;; C-x bindings (ctl-x-map)
         ("C-x M-:" . consult-complex-command)     ;; orig. repeat-complex-command
         ("C-x b" . consult-buffer)                ;; orig. switch-to-buffer
         ("C-x 4 b" . consult-buffer-other-window) ;; orig. switch-to-buffer-other-window
         ("C-x 5 b" . consult-buffer-other-frame)  ;; orig. switch-to-buffer-other-frame
         ("C-x r b" . consult-bookmark)            ;; orig. bookmark-jump
         ("C-x p b" . consult-project-buffer)      ;; orig. project-switch-to-buffer
         ;; Custom M-# bindings for fast register access
         ("M-#" . consult-register-load)
         ("M-'" . consult-register-store)          ;; orig. abbrev-prefix-mark (unrelated)
         ("C-M-#" . consult-register)
         ;; Other custom bindings
         ("M-y" . consult-yank-pop)                ;; orig. yank-pop
         ("<help> a" . consult-apropos)            ;; orig. apropos-command
         ;; M-g bindings (goto-map)
         ("M-g e" . consult-compile-error)
         ("M-g f" . consult-flymake)               ;; Alternative: consult-flycheck
         ("M-g g" . consult-goto-line)             ;; orig. goto-line
         ("M-g M-g" . consult-goto-line)           ;; orig. goto-line
         ("M-g o" . consult-outline)               ;; Alternative: consult-org-heading
         ("M-g m" . consult-mark)
         ("M-g k" . consult-global-mark)
         ("M-g i" . consult-imenu)
         ("M-g I" . consult-imenu-multi)
         ;; M-s bindings (search-map)
         ("M-s d" . consult-find)
         ("M-s D" . consult-locate)
         ("M-s g" . consult-grep)
         ("M-s G" . consult-git-grep)
         ("M-s r" . consult-ripgrep)
         ("M-s l" . consult-line)
         ("M-s L" . consult-line-multi)
         ("M-s m" . consult-multi-occur)
         ("M-s k" . consult-keep-lines)
         ("M-s u" . consult-focus-lines)
         ;; Isearch integration
         ("M-s e" . consult-isearch-history)
         :map isearch-mode-map
         ("M-e" . consult-isearch-history)         ;; orig. isearch-edit-string
         ("M-s e" . consult-isearch-history)       ;; orig. isearch-edit-string
         ("M-s l" . consult-line)                  ;; needed by consult-line to detect isearch
         ("M-s L" . consult-line-multi)            ;; needed by consult-line to detect isearch
         ;; Minibuffer history
         :map minibuffer-local-map
         ("M-s" . consult-history)                 ;; orig. next-matching-history-element
         ("M-r" . consult-history))                ;; orig. previous-matching-history-element

  ;; Enable automatic preview at point in the *Completions* buffer. This is
  ;; relevant when you use the default completion UI.
  :hook (completion-list-mode . consult-preview-at-point-mode)

  ;; The :init configuration is always executed (Not lazy)
  :init

  ;; Optionally configure the register formatting. This improves the register
  ;; preview for `consult-register', `consult-register-load',
  ;; `consult-register-store' and the Emacs built-ins.
  (setq register-preview-delay 0.5
        register-preview-function #'consult-register-format)

  ;; Optionally tweak the register preview window.
  ;; This adds thin lines, sorting and hides the mode line of the window.
  (advice-add #'register-preview :override #'consult-register-window)

  ;; Use Consult to select xref locations with preview
  (setq xref-show-xrefs-function #'consult-xref
        xref-show-definitions-function #'consult-xref)

  ;; Configure other variables and modes in the :config section,
  ;; after lazily loading the package.
  :config

  ;; Optionally configure preview. The default value
  ;; is 'any, such that any key triggers the preview.
  ;; (setq consult-preview-key 'any)
  ;; (setq consult-preview-key (kbd "M-."))
  ;; (setq consult-preview-key (list (kbd "<S-down>") (kbd "<S-up>")))
  ;; For some commands and buffer sources it is useful to configure the
  ;; :preview-key on a per-command basis using the `consult-customize' macro.
  (consult-customize
   consult-theme
   :preview-key '(:debounce 0.2 any)
   consult-ripgrep consult-git-grep consult-grep
   consult-bookmark consult-recent-file consult-xref
   consult--source-bookmark consult--source-recent-file
   consult--source-project-recent-file
   :preview-key (kbd "M-."))

  ;; Optionally configure the narrowing key.
  ;; Both < and C-+ work reasonably well.
  (setq consult-narrow-key "<") ;; (kbd "C-+")

  ;; Optionally make narrowing help available in the minibuffer.
  ;; You may want to use `embark-prefix-help-command' or which-key instead.
  ;; (define-key consult-narrow-map (vconcat consult-narrow-key "?") #'consult-narrow-help)

  ;; By default `consult-project-function' uses `project-root' from project.el.
  ;; Optionally configure a different project root function.
  ;; There are multiple reasonable alternatives to chose from.
  ;;;; 1. project.el (the default)
  ;; (setq consult-project-function #'consult--default-project--function)
  ;;;; 2. projectile.el (projectile-project-root)
  ;; (autoload 'projectile-project-root "projectile")
  ;; (setq consult-project-function (lambda (_) (projectile-project-root)))
  ;;;; 3. vc.el (vc-root-dir)
  ;; (setq consult-project-function (lambda (_) (vc-root-dir)))
  ;;;; 4. locate-dominating-file
  ;; (setq consult-project-function (lambda (_) (locate-dominating-file "." ".git")))
  )
;; Configure directory extension.
;; (use-package vertico-directory
;;   :after vertico
;;   :ensure nil
;;   ;; More convenient directory navigation commands
;;   :bind (:map vertico-map
;;               ("RET" . vertico-directory-enter)
;;               ("DEL" . vertico-directory-delete-char)
;;               ("M-DEL" . vertico-directory-delete-word))
;;   ;; Tidy shadowed file names
;;   :hook (rfn-eshadow-update-overlay . vertico-directory-tidy))

(use-package marginalia
  :ensure t
  :config
  (marginalia-mode))

(use-package embark
  :ensure t

  :bind
  (("C-," . embark-act)         ;; pick some comfortable binding
   ("M-." . embark-dwim)        ;; good alternative: M-.
   ("C-h B" . embark-bindings)) ;; alternative for `describe-bindings'

  :init

  ;; Optionally replace the key help with a completing-read interface
  (setq prefix-help-command #'embark-prefix-help-command)

  :config

  ;; Hide the mode line of the Embark live/completions buffers
  (add-to-list 'display-buffer-alist
               '("\\`\\*Embark Collect \\(Live\\|Completions\\)\\*"
                 nil
                 (window-parameters (mode-line-format . none)))))

;; Consult users will also want the embark-consult package.
(use-package embark-consult
  :ensure t
  :after (embark consult)
  :demand t ; only necessary if you have the hook below
  ;; if you want to have consult previews as you move around an
  ;; auto-updating embark collect buffer
  :hook
  (embark-collect-mode . consult-preview-at-point-mode))



(use-package citar
  :bind (("C-c b" . citar-insert-citation)
         :map minibuffer-local-map
         ("M-b" . citar-insert-preset))
  :ensure t
  :custom
  ((citar-bibliography '("~/Sync/bibliography/bibliography.bib"))
   (citar-library-paths '("~/Sync/bibliography/pdfs/"))))


(use-package citar-embark
  :after citar embark
  :ensure t
  :no-require
  :config (citar-embark-mode))

(with-eval-after-load 'ox-latex (add-to-list 'org-latex-classes
					     '("book"
					       "\\documentclass{book}"
					       ("\\chapter{%s}" . "\\chapter*{%s}")
					       ("\\section{%s}" . "\\section*{%s}")
					       ("\\subsection{%s}" . "\\subsection*{%s}")
					       ("\\subsubsection{%s}" . "\\subsubsection*{%s}"))))


(use-package avy
  :ensure t
  :custom (avy-keys '(?a ?o ?e ?u ?i ?d ?h ?t ?n ?s))
  :bind (("s-\\" . avy-goto-char-2)))
(defun eval-after-load-all (my-features form)
  "Run FORM after all MY-FEATURES are loaded.
See `eval-after-load' for the possible formats of FORM."
  (if (null my-features)
      (if (functionp form)
	  (funcall form)
	(eval form))
    (eval-after-load (car my-features)
      `(lambda ()
	 (eval-after-load-all
	  (quote ,(cdr my-features))
	  (quote ,form))))))

(eval-after-load-all '(embark consult org)
		     (lambda ()
		       (defun consult-org-store-link (candidate)
			 (save-excursion
			   (goto-char (get-text-property 0 'consult--candidate candidate))
			   (org-store-link nil t)))
		       (embark-define-keymap embark-consult-org-heading
					     "Consult Org Embark Bindings"
					     ("n" consult-org-store-link))
		       (add-to-list 'embark-keymap-alist '(consult-org-heading . embark-consult-org-heading))))
(use-package beacon
  :ensure t
  :hook (after-init . beacon-mode))
(use-package tempo
  :custom (tempo-interactive t)
  :bind (("M-g M-e" . tempo-forward-mark)
	 ("M-g M-a" . tempo-backward-mark))
  :defer nil
  :config
  (require 'tempo)
  (defadvice tempo-define-template (after no-self-insert-in-abbrevs activate)
    "Skip self-insert if template function is called by an abbrev."
    (put (intern (concat "tempo-template-" (ad-get-arg 0))) 'no-self-insert t))
  (load (concat user-emacs-directory "tempo.el")))

(use-package visible-mark
  :ensure t
  :custom (visible-mark-max 3)
  :hook (after-init . global-visible-mark-mode))
