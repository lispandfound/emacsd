(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(backup-by-copying t)
 '(cdlatex-math-modify-alist '((115 "\\mathbb" "" t nil nil)))
 '(cdlatex-use-dollar-to-ensure-math nil)
 '(completion-category-overrides '((file (styles partial-completion))))
 '(completion-cycle-threshold 3)
 '(completion-styles '(orderless basic))
 '(completions-format 'one-column)
 '(completions-header-format nil)
 '(completions-max-height 20)
 '(corfu-cycle t)
 '(cursor-type 'bar)
 '(delete-old-versions t)
 '(dired-dwim-target t)
 '(display-line-numbers t)
 '(enable-recursive-minibuffers t)
 '(inhibit-startup-screen t)
 '(initial-frame-alist '((fullscreen . fullscreen)))
 '(initial-major-mode 'org-mode)
 '(initial-scratch-message "")
 '(ispell-alternate-dictionary "/usr/share/dict/words")
 '(ispell-program-name "hunspell")
 '(kept-new-versions 6)
 '(minibuffer-prompt-properties '(read-only t cursor-intangible t face minibuffer-prompt))
 '(org-M-RET-may-split-line '((default)))
 '(org-agenda-block-separator "")
 '(org-agenda-files '("~/Sync/todo.org"))
 '(org-attach-id-dir ".attach")
 '(org-capture-templates
   '(("t" "Personal todo" entry
      (file+headline "~/Sync/todo.org" "Inbox")
      "* TODO %?\12%i\12" :prepend t)
     ("n" "Personal notes" entry
      (file+headline "~/Sync/notes.org" "Inbox")
      "* %u %?\12%i\12" :prepend t)))
 '(org-cite-export-processors '((latex biblatex nil nil) (t csl nil nil)))
 '(org-default-notes-file "~/Sync/todo.org")
 '(org-directory "~/Sync/")
 '(org-ellipsis "")
 '(org-export-in-background t)
 '(org-hide-emphasis-markers t)
 '(org-highlight-latex-and-related '(script entities))
 '(org-latex-classes
   '(("book" "\\documentclass{book}"
      ("\\chapter{%s}" . "\\chapter*{%s}")
      ("\\section{%s}" . "\\section*{%s}")
      ("\\subsection{%s}" . "\\subsection*{%s}")
      ("\\subsubsection{%s}" . "\\subsubsection*{%s}"))
     ("article" "\\documentclass[11pt]{article}"
      ("\\section{%s}" . "\\section*{%s}")
      ("\\subsection{%s}" . "\\subsection*{%s}")
      ("\\subsubsection{%s}" . "\\subsubsection*{%s}")
      ("\\paragraph{%s}" . "\\paragraph*{%s}")
      ("\\subparagraph{%s}" . "\\subparagraph*{%s}"))
     ("report" "\\documentclass[11pt]{report}"
      ("\\part{%s}" . "\\part*{%s}")
      ("\\chapter{%s}" . "\\chapter*{%s}")
      ("\\section{%s}" . "\\section*{%s}")
      ("\\subsection{%s}" . "\\subsection*{%s}")
      ("\\subsubsection{%s}" . "\\subsubsection*{%s}"))
     ("book" "\\documentclass[11pt]{book}"
      ("\\part{%s}" . "\\part*{%s}")
      ("\\chapter{%s}" . "\\chapter*{%s}")
      ("\\section{%s}" . "\\section*{%s}")
      ("\\subsection{%s}" . "\\subsection*{%s}")
      ("\\subsubsection{%s}" . "\\subsubsection*{%s}"))))
 '(org-latex-pdf-process '("latexmk -output-directory=%o -f -pdf %f"))
 '(org-modules
   '(ol-bbdb ol-bibtex ol-docview ol-doi ol-eww ol-gnus org-habit ol-info ol-irc ol-mhe ol-rmail ol-w3m))
 '(org-pretty-entities t)
 '(org-refile-targets '((nil :maxlevel . 2) ("~/Sync/archive.org" :level . 1)))
 '(org-structure-template-alist
   '(("r" . "result")
     ("p" . "proof")
     ("ll" . "lemma")
     ("t" . "theorem")
     ("a" . "export ascii")
     ("c" . "center")
     ("C" . "comment")
     ("e" . "example")
     ("E" . "export")
     ("h" . "export html")
     ("l" . "export latex")
     ("q" . "quote")
     ("s" . "src")
     ("v" . "verse")))
 '(org-stuck-projects '("+LEVEL=2+PROJECT" ("TODO") nil ""))
 '(org-todo-keywords
   '((sequence "TODO(t)" "WAIT(w)" "|" "DONE(d)" "KILL(k)")
     (sequence "[ ](T)" "[?](W)" "[P](P)" "|" "[X](D)" "[-](K)")))
 '(package-selected-packages
   '(skempo citar visible-mark embrace cdlatex tongbu beacon smartparens org-appear avy citar-embark moody expand-region embark-consult orderless vertico popwin gap-mode tree-sitter-langs tree-sitter auctex embark flymake-collection corfu which-key))
 '(popwin:special-display-config
   '(("*Help*" :height 0.4 :stick t)
     ("*Warnings*" :height 0.3 :position bottom)
     ("*Backtrace*" :height 0.3 :position bottom)
     ("*Messages*" :height 0.3 :position bottom)
     ("*Compile-Log*" :height 0.3 :position bottom)
     ("*Shell Command Output*" :height 0.3 :position bottom)
     (".*overtone.log" :regexp t :height 0.3)
     ("collected.org" :height 15 :position top)
     (flycheck-error-list-mode :height 0.3 :position bottom :stick t)
     (compilation-mode :height 0.3 :position bottom :noselect t)
     ("helm" :regexp t :height 0.3)
     ("*Occur*" :height 0.3 :position bottom)
     ("\\*Slime Description.*" :regexp t :height 0.3 :noselect t)
     ("*undo-tree*" :width 0.3 :position right)
     ("*grep*" :height 0.2 :position bottom :stick t)
     ("*compilation*" :height 0.4 :noselect t :stick t)
     ("*quickrun*" :height 0.3 :stick t)
     (magit-status-mode :height 0.3 :position bottom :noselect t :stick t)
     ("COMMIT_EDITMSG" :height 0.3 :position bottom :noselect t :stick t)
     ("*magit-commit*" :height 0.3 :position bottom :noselect t :stick t)
     ("\\*magit.*" :regexp t :height 0.3 :position bottom :noselect t :stick t)
     ("*magit-diff*" :height 0.3 :position bottom :noselect t)
     ("*magit-edit-log*" :height 0.2 :position bottom :noselect t)
     ("*magit-process*" :height 0.2 :position bottom :noselect t)
     ("*vc-diff*" :height 0.2 :position bottom :noselect t)
     ("*vc-change-log*" :height 0.2 :position bottom :noselect t)
     ("*Ibuffer*" :height 0.2 :position bottom)
     ("*imenu-tree*" :width 50 :position left :stick t)
     ("*gists*" :height 0.3)
     ("*sldb.*" :regexp t :height 0.3)
     ("*Gofmt Errors*" :noselect t)
     ("\\*godoc*" :regexp t :height 0.3)
     ("*nrepl-error*" :height 0.2 :stick t)
     ("*nrepl-doc*" :height 0.2 :stick t)
     ("*nrepl-src*" :height 0.2 :stick t)
     ("*Kill Ring*" :height 0.3)
     ("*project-status*" :noselect t)
     ("*Compile-Log" :height 0.2 :stick t)
     ("*pytest*" :noselect t)
     ("Django:" :regexp t :width 0.3 :position right)
     ("*Python*" :stick t)
     ("*jedi:doc*" :noselect t)
     ("*shell*" :height 0.3)
     ("\\*ansi-term.*\\*" :regexp t :height 0.3)
     ("\\*terminal.*\\*" :regexp t :height 0.3)
     (diary-fancy-display-mode :width 50 :position left :stick nil)
     (diary-mode :height 15 :position bottom :stick t)
     (calendar-mode :height 15 :position bottom :stick nil)
     (org-agenda-mode :height 15 :position bottom :stick t)
     ("*Org Agenda.*\\*" :regexp t :height 15 :position bottom :stick t)
     ("^CAPTURE-.+*.org$" :regexp t)
     ("*Select*" :height 0.2 :noselect nil :stick t)))
 '(read-buffer-completion-ignore-case t)
 '(read-file-name-completion-ignore-case t)
 '(ring-bell-function 'ignore)
 '(sentence-end-double-space nil)
 '(version-control t)
 '(visible-mark-max 3)
 '(x-underline-at-descent-line t))

(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
