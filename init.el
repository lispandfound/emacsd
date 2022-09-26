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

(use-package meow
  :ensure t
  :config
  (defun meow-setup ()
  (setq meow-cheatsheet-layout meow-cheatsheet-layout-dvorak)
  (meow-leader-define-key
   '("1" . meow-digit-argument)
   '("2" . meow-digit-argument)
   '("3" . meow-digit-argument)
   '("4" . meow-digit-argument)
   '("5" . meow-digit-argument)
   '("6" . meow-digit-argument)
   '("7" . meow-digit-argument)
   '("8" . meow-digit-argument)
   '("9" . meow-digit-argument)
   '("0" . meow-digit-argument)
   '("/" . meow-keypad-describe-key)
   '("?" . meow-cheatsheet))
  (meow-motion-overwrite-define-key
   ;; custom keybinding for motion state
   '("<escape>" . ignore))
  (meow-normal-define-key
   '("0" . meow-expand-0)
   '("9" . meow-expand-9)
   '("8" . meow-expand-8)
   '("7" . meow-expand-7)
   '("6" . meow-expand-6)
   '("5" . meow-expand-5)
   '("4" . meow-expand-4)
   '("3" . meow-expand-3)
   '("2" . meow-expand-2)
   '("1" . meow-expand-1)
   '("-" . negative-argument)
   '(";" . meow-reverse)
   '("," . meow-inner-of-thing)
   '("." . meow-bounds-of-thing)
   '("<" . meow-beginning-of-thing)
   '(">" . meow-end-of-thing)
   '("a" . meow-append)
   '("A" . meow-open-below)
   '("b" . meow-back-word)
   '("B" . meow-back-symbol)
   '("c" . meow-change)
   '("d" . meow-delete)
   '("D" . meow-backward-delete)
   '("e" . meow-line)
   '("E" . meow-goto-line)
   '("f" . meow-find)
   '("g" . meow-cancel-selection)
   '("G" . meow-grab)
   '("h" . meow-left)
   '("H" . meow-left-expand)
   '("i" . meow-insert)
   '("I" . meow-open-above)
   '("j" . meow-join)
   '("k" . meow-kill)
   '("l" . meow-till)
   '("m" . meow-mark-word)
   '("M" . meow-mark-symbol)
   '("n" . meow-next)
   '("N" . meow-next-expand)
   '("o" . meow-block)
   '("O" . meow-to-block)
   '("p" . meow-prev)
   '("P" . meow-prev-expand)
   '("q" . meow-quit)
   '("Q" . meow-goto-line)
   '("r" . meow-replace)
   '("R" . meow-swap-grab)
   '("s" . meow-search)
   '("t" . meow-right)
   '("T" . meow-right-expand)
   '("u" . meow-undo)
   '("U" . meow-undo-in-selection)
   '("v" . meow-visit)
   '("w" . meow-next-word)
   '("W" . meow-next-symbol)
   '("x" . meow-save)
   '("X" . meow-sync-grab)
   '("y" . meow-yank)
   '("z" . meow-pop-selection)
   '("'" . repeat)
   '("<escape>" . ignore)))
  (meow-setup)
  (meow-global-mode))

(use-package org
  :init
  
  (setq org-agenda-files '("~/Sync/todo.org")
	org-stuck-projects '("+LEVEL=2+PROJECT" ("TODO") nil "")
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
	org-highlight-latex-and-related '(script entities)
        org-agenda-block-separator "")
  
  (add-hook 'org-mode-hook #'org-cdlatex-mode)
  (global-set-key (kbd "C-c l") #'org-store-link)
  (global-set-key (kbd "C-c a") #'org-agenda)
  (global-set-key (kbd "C-c c") #'org-capture)
  (add-hook 'org-mode-hook #'org-indent-mode)
  (add-hook 'auto-save-hook 'org-save-all-org-buffers)
  )
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
  (add-to-list 'cdlatex-math-modify-alist
	       '(115 "\\mathbb" nil t nil nil))
  (dolist (kv '(("theorem" "thm") ("definition" "def") ("corollary" "cor") ("lemma" "lem")))
	    (add-labelled-env (car kv) (cadr kv))))

(electric-pair-mode t)
(electric-indent-mode t)

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
  (push "*GAP Help*" popwin:special-display-config)
  (push "*Embark Actions*" popwin:special-display-config)
  (push '("^CAPTURE-.+\*.org$" :regexp t) popwin:special-display-config)
  (push '("*Select*" :height 0.2 :noselect nil :stick t) popwin:special-display-config)
  (push '("*Org Agenda*" :height 15) popwin:special-display-config)
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
  (defconst emacs-tmp-dir (expand-file-name (format "emacs%d" (user-uid)) temporary-file-directory))
  (setq
   dired-dwim-target t
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
   completion-cycle-threshold 3
   tab-always-indent 'complete
   read-buffer-completion-ignore-case t
   read-file-name-completion-ignore-case t
   auto-save-file-name-transforms `((".*" ,emacs-tmp-dir t))  ; Change autosave dir to tmp
   backup-directory-alist `((".*" . ,emacs-tmp-dir)))
  (setq-default cursor-type 'bar)           ; Line-style cursor similar to other text editors
  (setq-default frame-title-format '("%b")) ; Make window title the buffer name
  (fset 'yes-or-no-p 'y-or-n-p)             ; y-or-n-p makes answering questions faster
  (show-paren-mode 1)                       ; Show closing parens by default
  (global-linum-mode)
  (delete-selection-mode 1)                 ; Selected text will be overwritten when you start typing
  (global-auto-revert-mode t)

  (defadvice he-substitute-string (after he-paredit-fix)
    "remove extra paren when expanding line in paredit"
    (message str)
    (message (and electric-pair-mode (equal (substring str -1) ")")))
    (if (and electric-pair-mode (equal (substring str -1) ")"))
	(progn (backward-delete-char 1) (forward-char))))
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
  (info-initialize))
