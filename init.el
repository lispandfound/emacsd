 (add-to-list 'initial-frame-alist '(fullscreen . maximized))
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
(toggle-frame-fullscreen)
(tool-bar-mode -1)
(menu-bar-mode -1)
(add-to-list 'default-frame-alist '(fullscreen . maximized))
(load-theme 'modus-operandi t)

(use-package nano-theme
  :ensure t
  :config
  (setq nano-fonts-use t)
  (nano-mode))

(use-package org
  :init
  (setq org-agenda-files '("~/Sync/todo.org")
	org-refile-targets '((nil . (:level . 1)) ("~/Sync/archive.org" . (:level . 1)))
	org-default-notes-file "~/Sync/todo.org"
	org-directory "~/Sync")
  
  (global-set-key (kbd "C-c l") #'org-store-link)
  (global-set-key (kbd "C-c a") #'org-agenda)
  (global-set-key (kbd "C-c c") #'org-capture)
  (add-hook 'org-mode-hook #'org-indent-mode))

(use-package nano-modeline
  :ensure t
  :init
  (setq nano-modeline-prefix-padding t)
  :config
    (nano-modeline-mode))

(electric-pair-mode t)
(electric-indent-mode t)

(use-package orderless
  :ensure t
  :custom
  (completion-styles '(orderless basic))
  (completion-category-overrides '((file (styles basic partial-completion)))))

;; (use-package org
;;   :init )



(use-package consult
  :ensure t
  ;; Replace bindings. Lazily loaded due by `use-package'.
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
  (setq consult-narrow-key "<"))


(use-package which-key
  :ensure t
  :config (which-key-mode))

(use-package magit
  :ensure t
  :bind (("C-x g" . magit-status)))
  

(use-package avy
  :defer t
  :ensure t)


(use-package corfu
  ;; Optional customizations
  ;; :custom
  ;; (corfu-cycle t)                ;; Enable cycling for `corfu-next/previous'
  ;; (corfu-auto t)                 ;; Enable auto completion
  ;; (corfu-separator ?\s)          ;; Orderless field separator
  ;; (corfu-quit-at-boundary nil)   ;; Never quit at completion boundary
  ;; (corfu-quit-no-match nil)      ;; Never quit, even if there is no match
  ;; (corfu-preview-current nil)    ;; Disable current candidate preview
  ;; (corfu-preselect-first nil)    ;; Disable candidate preselection
  ;; (corfu-on-exact-match nil)     ;; Configure handling of exact matches
  ;; (corfu-echo-documentation nil) ;; Disable documentation in the echo area
  ;; (corfu-scroll-margin 5)        ;; Use scroll margin

  ;; Enable Corfu only for certain modes.
  ;; :hook ((prog-mode . corfu-mode)
  ;;        (shell-mode . corfu-mode)
  ;;        (eshell-mode . corfu-mode))

  ;; Recommended: Enable Corfu globally.
  ;; This is recommended since Dabbrev can be used globally (M-/).
  ;; See also `corfu-excluded-modes'.
  :ensure t
  :init
  (global-corfu-mode))




(use-package flyspell
  :hook ((text-mode . flyspell-mode)
	 (prog-mode . flyspell-prog-mode)))

;; A few more useful configurations...
(use-package emacs
  :init
  ;; cycle if there are only few candidates
  (setq completion-cycle-threshold 3)
  ;; Emacs 28: Hide commands in M-x which do not apply to the current mode.
  ;; Corfu commands are hidden, since they are not supposed to be used via M-x.
  ;; (setq read-extended-command-predicate
  ;;       #'command-completion-default-include-p)

  ;; Enable indentation+completion using the TAB key.
  ;; `completion-at-point' is often bound to M-TAB.
  (setq tab-always-indent 'complete))

(use-package vertico
  :ensure t
  :config
  (vertico-mode))

(use-package marginalia
  ;; Either bind `marginalia-cycle` globally or only in the minibuffer
  :bind (("M-A" . marginalia-cycle)
         :map minibuffer-local-map
         ("M-A" . marginalia-cycle))
  :ensure t

  ;; The :init configuration is always executed (Not lazy!)
  :init

  ;; Must be in the :init section of use-package such that the mode gets
  ;; enabled right away. Note that this forces loading the package.
  (marginalia-mode))
(use-package savehist
  :config
  (savehist-mode))

(use-package tree-sitter
  :ensure t
  :config
  (global-tree-sitter-mode))

(use-package tree-sitter-langs)

(use-package recentf
  :config (recentf-mode))

(use-package which-key
  :ensure t
  :config (which-key-mode))

(use-package magit
  :ensure t
  :bind (("C-x g" . magit-status)))
  

(use-package avy
  :defer t
  :ensure t)

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
  :hook ((LaTeX-mode . turn-on-auto-fill)
	 (LaTeX-mode . LaTeX-math-mode)
	 (latex-mode . flymake-mode)
	 (LaTeX-mode . jake/theorem-environments))
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

(defconst emacs-tmp-dir (expand-file-name (format "emacs%d" (user-uid)) temporary-file-directory))


;; (use-package lsp-mode
;;   :init
;;   ;; set prefix for lsp-command-keymap (few alternatives - "C-l", "C-c l")
;;   (setq lsp-keymap-prefix "C-c l")
;;   :hook (
;; 	 (latex-mode . lsp)
;;          ;; if you want whianoch-key integration
;;          (lsp-mode . lsp-enable-which-key-integration))
;;   :commands lsp)

(use-package apheleia
  :ensure t
  :config (apheleia-global-mode +1))

(use-package gap
  :mode (("\\.g\\'" . gap-mode)
	 ("\\.gap\\'" . gap-mode))
  :custom  ((gap-start-options '("-f" "-b" "-m" "2m" "-E")))
  :ensure gap-mode
  :init
  (setq gap-executable "/usr/bin/gap"
	gap-electric-equals nil))

(use-package dumb-jump
  :ensure t
  :hook (xref-backend-functions . #'dumb-jump-xref-activate))

(use-package popwin
  :ensure t
  :config
  (popwin-mode 1))

(use-package eglot
  :ensure t
  :init
  (add-hook 'latex-mode-hook #'eglot-mode))

(use-package maxima
  :ensure t
  :init
  (add-hook 'maxima-mode-hook #'maxima-hook-function)
  (add-hook 'maxima-inferior-mode-hook #'maxima-hook-function)
  (setq
   org-format-latex-options (plist-put org-format-latex-options :scale 2.0)
   maxima-display-maxima-buffer nil)
  :mode ("\\.mac\\'" . maxima-mode)
  :interpreter ("maxima" . maxima-mode))

(use-package slime
  :ensure t
  :init (setq inferior-lisp-program "sbcl"))

(use-package exec-path-from-shell
  :ensure t
  :init (exec-path-from-shell-initialize))
(add-hook 'prog-mode-hook #'flymake-mode)

(use-package citar
  :bind (("C-c b" . citar-open-library-file)
         :map minibuffer-local-map
         ("M-b" . citar-insert-preset))
  :ensure t
  :custom
  ((citar-bibliography '("~/notes/bibliography/bibliography.bib"))
   (citar-library-paths '("~/notes/bibliography/pdfs"))))

(setq
 sentence-end-double-space nil
 tab-always-indent 'complete
 inhibit-startup-screen t
 initial-scratch-message ""
 ring-bell-function 'ignore
 linum-format "%4d "
 ispell-alternate-dictionary "/usr/share/dict/words"
 backup-by-copying t                                        ; Avoid symlinks
 delete-old-versions t
 kept-new-versions 6
 kept-old-versions 2
 version-control t
 auto-save-list-file-prefix emacs-tmp-dir
 auto-save-file-name-transforms `((".*" ,emacs-tmp-dir t))  ; Change autosave dir to tmp
 backup-directory-alist `((".*" . ,emacs-tmp-dir)))

(setq-default cursor-type 'bar)           ; Line-style cursor similar to other text editors
(setq-default frame-title-format '("%b")) ; Make window title the buffer name
(fset 'yes-or-no-p 'y-or-n-p)             ; y-or-n-p makes answering questions faster
(show-paren-mode 1)                       ; Show closing parens by default
(delete-selection-mode 1)                 ; Selected text will be overwritten when you start typing
(global-auto-revert-mode t)               ; Auto-update buffer if file
					; has changed on disk
(defadvice he-substitute-string (after he-paredit-fix)
  "remove extra paren when expanding line in paredit"
  (message str)
  (message (and electric-pair-mode (equal (substring str -1) ")")))
  (if (and electric-pair-mode (equal (substring str -1) ")"))
      (progn (backward-delete-char 1) (forward-char))))

(global-auto-revert-mode t)
(global-set-key (kbd "M-/") 'hippie-expand)



(defadvice he-substitute-string (after he-paredit-fix)
  "remove extra paren when expanding line in paredit."

  (if (and electric-indent-mode (equal (substring str -1) ")"))
      (progn
        (backward-delete-char 1)
        (forward-char))))

(global-set-key (kbd "M-/") 'hippie-expand)




(setq-default abbrev-mode t)
(add-hook 'prog-mode-hook (lambda () (abbrev-mode -1)))
(setq abbrev-file-name "~/.emacs.d/abbrev.el")

(global-unset-key (kbd "<down-mouse-1>"))
(global-unset-key (kbd "<mouse-1>"))
(global-unset-key (kbd "<down-mouse-3>"))
(global-unset-key (kbd "<mouse-3>"))
(winner-mode 1)
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
(global-set-key [remap move-beginning-of-line] 'smarter-move-beginning-of-line)
