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
  :hook ((org-mode . org-indent-mode)
	 (auto-save . org-save-all-org-buffers)
	 (org-mode . visual-line-mode)
	 (org-mode . abbrev-mode))
  :init

    
  (global-set-key (kbd "C-c l") #'org-store-link)
  (global-set-key (kbd "C-c a") #'org-agenda)
  (global-set-key (kbd "C-c c") #'org-capture)
  (defun biblatex-setup ()
    (bibtex-set-dialect 'biblatex))
  (add-hook 'org-mode-hook #'biblatex-setup))

(use-package oc-biblatex)

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
  
  :config
  (add-hook 'cdlatex-mode-hook
	    (lambda () (when (eq major-mode 'org-mode)
			 (make-local-variable 'org-pretty-entities-include-sub-superscripts)
			 (setq org-pretty-entities-include-sub-superscripts nil))))
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
  :init
  (global-corfu-mode))

(use-package flyspell
  :hook ((text-mode . flyspell-mode)
	 (prog-mode . flyspell-prog-mode)))

(use-package flymake
  :hook (prog-mode . flymake-mode))

(use-package flymake-collection
  :ensure t
  :hook ((after-init . flymake-collection-hook-setup)
	 (LaTeX-mode .  (lambda () (add-hook 'flymake-diagnostic-functions 'flymake-collection-proselint nil t) (flymake-mode)))))

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
  :hook ((LaTeX-mode . reftex-mode)))

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
  (add-hook 'minibuffer-setup-hook #'cursor-intangible-mode)

  ;; Emacs 28: Hide commands in M-x which do not work in the current mode.
  ;; Vertico commands are hidden in normal buffers.
  ;; (setq read-extended-command-predicate
  ;;       #'command-completion-default-include-p)
  (global-auto-revert-mode)
  ;; Enable recursive minibuffers
  (defconst emacs-tmp-dir (expand-file-name (format "emacs%d" (user-uid)) temporary-file-directory))
  (setq
     linum-format "%4d "
     auto-save-list-file-prefix emacs-tmp-dir
     auto-save-file-name-transforms `((".*" ,emacs-tmp-dir t))  ; Change autosave dir to tmp
   backup-directory-alist `((".*" . ,emacs-tmp-dir)))
    (setq-default frame-title-format '("%b")) ; Make window title the buffer name
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


(use-package savehist
  :init
  (savehist-mode))

(use-package orderless
  :ensure t
  :custom (completion-category-defaults nil))


;; Example configuration for Consult

;; Configure directory extension.

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
  :custom (prefix-help-command #'embark-prefix-help-command)
  :init

  ;; Optionally replace the key help with a completing-read interface
  :config

  ;; Hide the mode line of the Embark live/completions buffers
  (add-to-list 'display-buffer-alist
               '("\\`\\*Embark Collect \\(Live\\|Completions\\)\\*"
                 nil
                 (window-parameters (mode-line-format . none)))))


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
  :hook (after-init . global-visible-mark-mode))
