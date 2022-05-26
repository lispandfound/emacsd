(add-to-list 'package-archives '("melpa" . "https://melpa.org/packages/") t)

(setq custom-file "~/.emacs.d/custom.el")
(load custom-file)
(tool-bar-mode -1)
(menu-bar-mode -1)

(use-package nano-theme
  :config
    (setq nano-fonts-use t)
    (nano-mode)
    (nano-dark))

(use-package nano-modeline
  :init
  (setq nano-modeline-prefix-padding t)
  :config
    (nano-modeline-mode))

(electric-pair-mode t)
(electric-indent-mode t)

(use-package orderless
  :custom
  (completion-styles '(orderless basic))
  (completion-category-overrides '((file (styles basic partial-completion)))))

(use-package consult)

(use-package vertico
  :config
  (vertico-mode))

(use-package savehist
  :config
  (savehist-mode))

(use-package tree-sitter
  :config
  (global-tree-sitter-mode))

(use-package tree-sitter-langs)

(use-package undo-tree
  :config

  (setq-default undo-tree-auto-save-history nil)
  (global-undo-tree-mode))

(use-package recentf
  :config (recentf-mode))

(use-package which-key
  :config (which-key-mode))

(use-package magit
  :bind (("C-x g" . magit-status)))
  

(use-package avy
  :defer t
  :ensure t)

(use-package cdlatex
  :hook ((org-mode . org-cdlatex-mode)
	 (LaTeX-mode . cdlatex-mode)))

(use-package latex
  :ensure auctex
  :init (setq TeX-auto-save t
	      TeX-parse-self t
	      TeX-master nil))

(use-package reftex
  :init (setq reftex-plug-into-AUCTeX t))


(def org-add-electric-pairs)

(add-hook org-mode-hook 'org-add-electric-pairs)


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
  :init
  (setq tab-always-indent 'complete)
  :config
  (global-corfu-mode))

(defconst emacs-tmp-dir (expand-file-name (format "emacs%d" (user-uid)) temporary-file-directory))

(setq
   backup-by-copying t                                        ; Avoid symlinks
   delete-old-versions t
   kept-new-versions 6
   kept-old-versions 2
   version-control t
   auto-save-list-file-prefix emacs-tmp-dir
   auto-save-file-name-transforms `((".*" ,emacs-tmp-dir t))  ; Change autosave dir to tmp
   backup-directory-alist `((".*" . ,emacs-tmp-dir)))
(setq-default cursor-type 'bar)           ; Line-style cursor similar to other text editors
(setq inhibit-startup-screen t)           ; Disable startup screen
(setq initial-scratch-message "")         ; Make *scratch* buffer blank
(setq-default frame-title-format '("%b")) ; Make window title the buffer name
(setq ring-bell-function 'ignore)         ; Disable bell sound
(fset 'yes-or-no-p 'y-or-n-p)             ; y-or-n-p makes answering questions faster
(show-paren-mode 1)                       ; Show closing parens by default
(setq linum-format "%4d ")                ; Line number format
(delete-selection-mode 1)                 ; Selected text will be overwritten when you start typing
(global-auto-revert-mode t)               ; Auto-update buffer if file has changed on disk
