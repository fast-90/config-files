(setq inhibit-startup-message t)

(tool-bar-mode -1)
(menu-bar-mode -1)
(scroll-bar-mode -1)
(tooltip-mode -1)
(set-fringe-mode 10)

;; Highlight current line
(global-hl-line-mode t)
;; Enable line numbers
(global-display-line-numbers-mode t)
;; Set relative line numbers
(setq display-line-numbers-type 'relative)

(setq ring-bell-function 'ignore)

(require 'package)
(setq package-archives
      '(("melpa" . "https://melpa.org/packages/")
        ("gnu" . "https://elpa.gnu.org/packages/")
        ("org" . "http://orgmode.org/elpa/")))
(package-initialize)

(when (not (package-installed-p 'use-package))
  (package-refresh-contents)
  (package-install 'usepackage))

(use-package delight
  :ensure t)

(use-package doom-themes
  :ensure t
  :init
  (setq doom-themes-enable-bold t
	doom-themes-enable-italic t)
  (load-theme 'doom-one t))

(use-package doom-modeline
  :ensure t
  :init (doom-modeline-mode 1))

(use-package which-key
  :ensure t
  :delight
  :init
  (setq which-key-idle-delay 0.5)
  :config (which-key-mode))

(use-package ivy
  :ensure t
  :diminish
  :bind (("C-s" . swiper)
         :map ivy-minibuffer-map
         ("C-l" . ivy-alt-done)
         ("C-j" . ivy-next-line)
         ("C-k" . ivy-previous-line)
         :map ivy-switch-buffer-map
         ("C-k" . ivy-previous-line)
         ("C-l" . ivy-done)
         ("C-d" . ivy-switch-buffer-kill)
         :map ivy-reverse-i-search-map
         ("C-k" . ivy-previous-line)
         ("C-d" . ivy-reverse-i-search-kill))
  :config
  (ivy-mode 1))
(use-package counsel
  :ensure t
  :after ivy
  :config (counsel-mode))
(use-package swiper
  :ensure t
  :after ivy)
;; Ivy rich to add description to M-x and other menus
(use-package ivy-rich
  :ensure t
  :after ivy
  :custom
  (ivy-virtual-abbreviate 'full
   ivy-rich-switch-buffer-align-virtual-buffer t
   ivy-rich-path-style 'abbrev)
  :config
  (ivy-set-display-transformer 'ivy-switch-buffer
                               'ivy-rich-switch-buffer-transformer))
(ivy-rich-mode 1)
(setq ivy-initial-inputs-alist nil) ; Remove the ^ in ivy buffers
; Smex to allow M-x remember our history
(use-package smex :ensure t)
(smex-initialize)

(use-package helpful
  :ensure t
  :commands (helpful-callable helpful-variable helpful-command helpful-key)
  :custom
  (counsel-describe-function-function #'helpful-callable)
  (counsel-describe-variable-function #'helpful-variable)
  :bind
  ([remap describe-function] . counsel-describe-function)
  ([remap describe-command] . helpful-command)
  ([remap describe-variable] . counsel-describe-variable)
  ([remap describe-key] . helpful-key))

(use-package magit
  :ensure t
  :bind ("C-x g" . magit-status))

(use-package projectile
  :ensure t
  :delight projectile-mode
  :config (projectile-mode)
  :custom ((projectile-completion-system 'ivy))
  :bind-keymap
  ("C-c p" . projectile-command-map)
  :init
  ;; NOTE: Set this to the folder where you keep your Git repos!
  (when (file-directory-p "~/PythonProjects")
    (setq projectile-project-search-path '("~/PythonProjects")))
  (setq projectile-switch-project-action #'projectile-dired))

(use-package counsel-projectile
  :ensure t
  :after projectile)

(use-package hydra
  :ensure t)

(use-package command-log-mode
  :ensure t)

(use-package winum
  :ensure t
  :config (progn
	    (setq winum-scope 'frame-local
		  winum-reverse-frame-list nil
		  winum-auto-setup-setup-mode-line nil
		  winum-ignored-buffers '(" *which-key*"))
	    (winum-mode)))

(defhydra hydra-window-resize ()
  "Resize window"
  ("h" shrink-window-horizontally "shrink window horizontally")
  ("l" enlarge-window-horizontally "enlarge window horizontally")
  ("j" shrink-window "shrink window vertically")
  ("k" enlarge-window "enlarge window vertically")
  ("b" balance-windows "reset window sizes"))

(use-package evil
  :ensure t
  :init      ;; tweak evil's configuration before loading it
  (setq evil-want-integration t) ;; This is optional since it's already set to t by default.
  (setq evil-want-keybinding nil)
  (setq evil-want-C-u-scroll t)
  (setq evil-vsplit-window-right t)
  (setq evil-split-window-below t)
  :config
  (evil-mode)
  ;; Use visual line motions (e.g. for when a long line is wrapped)
  (evil-global-set-key 'motion "j" 'evil-next-visual-line)
  (evil-global-set-key 'motion "k" 'evil-previous-visual-line))

(use-package evil-collection
  :ensure t
  :after evil
  :config
  (setq evil-collection-mode-list '(dashboard dired ibuffer magit)) ; Modes to activate Evil keybindings for
  (evil-collection-init))

(use-package key-chord
  :ensure t
  :init
  (setq key-chord-two-keys-delay 0.5)
  (key-chord-define evil-insert-state-map "jk" 'evil-normal-state)
  (key-chord-mode 1))

(use-package evil-nerd-commenter
  :ensure t)

(use-package undo-tree
  :ensure t
  :init
  (global-undo-tree-mode)
  (evil-set-undo-system 'undo-tree))

(use-package general
  :ensure t
  :init
  (setq general-override-states '(insert
                                  emacs
                                  hybrid
                                  normal
                                  visual
                                  motion
                                  operator
                                  replace))
  :after evil
  :config
  (general-evil-setup t)
  (general-create-definer leader-keys
    :states '(normal visual emacs motion) ; consider adding motion for using with easymotion
    :keymaps 'override 
    :prefix "SPC"))

(defun kill-other-buffers ()
  "Kill all other buffers."
  (interactive)
  (mapc 'kill-buffer (delq (current-buffer) (buffer-list))))

(leader-keys
  "TAB"   '(counsel-switch-buffer :which-key "Switch buffer")
  "b"     '(:ignore t :which-key "Buffer")
  "b b"   '(ibuffer :which-key "Ibuffer")
  "b c"   '(clone-indirect-buffer-other-window :which-key "Clone indirect buffer other window")
  "b k"   '(kill-current-buffer :which-key "Kill current buffer")
  "b n"   '(next-buffer :which-key "Next buffer")
  "b p"   '(previous-buffer :which-key "Previous buffer")
  "b B"   '(ibuffer-list-buffers :which-key "Ibuffer list buffers")
  "b K"   '(kill-buffer :which-key "Kill buffer")
  "b 1"   '(kill-other-buffers :which-key "Kill other buffers"))

(leader-keys
  "f"     '(:ignore t :which-key "File")
  "."     '(find-file :which-key "Find file")
  "f f"   '(find-file :which-key "Find file")
  "f r"   '(counsel-recentf :which-key "Recent files")
  "f s"   '(save-buffer :which-key "Save file")
  "f u"   '(sudo-edit-find-file :which-key "Sudo find file")
  "f y"   '(dt/show-and-copy-buffer-path :which-key "Yank file path")
  "f C"   '(copy-file :which-key "Copy file")
  "f D"   '(delete-file :which-key "Delete file")
  "f R"   '(rename-file :which-key "Rename file")
  "f S"   '(write-file :which-key "Save file as...")
  "f U"   '(sudo-edit :which-key "Sudo edit file"))

(winner-mode 1)
(leader-keys
  ;; Window splits
  "w"     '(:ignore t :which-key "Window")
  "w c"   '(evil-window-delete :which-key "Close window")
  "w n"   '(evil-window-new :which-key "New window")
  "w s"   '(evil-window-split :which-key "Horizontal split window")
  "w v"   '(evil-window-vsplit :which-key "Vertical split window")
  "w C"   '(delete-other-windows :which-key "Close other windows")
  "w r"   '(hydra-window-resize/body :which-key "Resize window")
  ;; Window motions
  "w h"   '(evil-window-left :which-key "Window left")
  "w j"   '(evil-window-down :which-key "Window down")
  "w k"   '(evil-window-up :which-key "Window up")
  "w l"   '(evil-window-right :which-key "Window right")
  "w w"   '(evil-window-next :which-key "Goto next window")
  ;; winner mode
  "w <left>"  '(winner-undo :which-key "Winner undo")
  "w <right>" '(winner-redo :which-key "Winner redo")
  ;; Window numbers
  "1" '(winum-select-window-1 :which-key "Select window 1")
  "2" '(winum-select-window-2 :which-key "Select window 2")
  "3" '(winum-select-window-3 :which-key "Select window 3")
  "4" '(winum-select-window-4 :which-key "Select window 4")
  "5" '(winum-select-window-5 :which-key "Select window 5")
  "6" '(winum-select-window-6 :which-key "Select window 6")
  "7" '(winum-select-window-7 :which-key "Select window 7")
  "8" '(winum-select-window-8 :which-key "Select window 8"))

(leader-keys
  "g"   '(:ignore t :which-key "Git")
  "g s" '(magit :which-key "Magit status"))

(leader-keys
  "x"   '(:ignore t :which-key "Text")
  "x i" '(indent-region :which-key "Indent region")
  ";"   '(evilnc-comment-or-uncomment-lines :which-key "Toggle line comment"))

(leader-keys
 "e"     '(:ignore t :which-key "Eval")
 "e b"   '(eval-buffer :which-key "Eval elisp in buffer")
 "e d"   '(eval-defun :which-key "Eval defun")
 "e e"   '(eval-expression :which-key "Eval elisp expression")
 "e l"   '(eval-last-sexp :which-key "Eval last sexression")
 "e r"   '(eval-region :which-key "Eval region"))

(leader-keys
  "'" '(sh :which-key "Start zsh"))

(defun set-no-process-query-on-exit ()
  (let ((proc (get-buffer-process (current-buffer))))
    (when (processp proc)
    (set-process-query-on-exit-flag proc nil))))

(dolist (mode '(term-mode-hook
		shell-mode-hook))
  (add-hook mode (lambda () (display-line-numbers-mode 0)))
  (add-hook mode (lambda () (setq-local global-hl-line-mode nil)))
  (add-hook mode 'set-no-process-query-on-exit))

(add-hook 'org-mode-hook 'org-indent-mode)
(setq ;org-directory "~/Org/"
      ;org-agenda-files '("~/Org/agenda.org")
      ;org-default-notes-file (expand-file-name "notes.org" org-directory)
      org-ellipsis " ▼ "
      org-log-done 'time
      ;org-journal-dir "~/Org/journal/"
      org-journal-date-format "%B %d, %Y (%A) "
      org-journal-file-format "%Y-%m-%d.org"
      org-hide-emphasis-markers t
      org-startup-indented t)
(setq org-src-preserve-indentation t
      org-src-fontify-natively t
      org-src-tab-acts-natively t
      org-edit-src-content-indentation 0)
(use-package org-bullets
  :ensure t)
(add-hook 'org-mode-hook (lambda () (org-bullets-mode 1)))

(use-package org-tempo)
(with-eval-after-load 'org
  ;; This is needed as of Org 9.2
  (require 'org-tempo)

  (add-to-list 'org-structure-template-alist '("sh" . "src shell"))
  (add-to-list 'org-structure-template-alist '("el" . "src emacs-lisp"))
  (add-to-list 'org-structure-template-alist '("py" . "src python")))

(defun lsp-mode-setup ()
  (setq lsp-headerline-breadcrumb-segments '(path-up-to-project file symbols))
  (lsp-headerline-breadcrumb-mode))

(use-package lsp-mode
  :ensure t
  :commands (lsp lsp-deferred)
  :hook (lsp-mode . lsp-mode-setup)
  :init
  (setq lsp-keymap-prefix "C-c l")  ;; Or 'C-l', 's-l'
  :config
  (lsp-enable-which-key-integration t))

(use-package lsp-ui
  :ensure t
  :hook (lsp-mode . lsp-ui-mode)
  :custom
  (lsp-ui-doc-position 'bottom))

(use-package lsp-treemacs
  :ensure t
  :after lsp)

(use-package lsp-ivy
  :ensure t
  :after lsp)

(use-package dap-mode
  :ensure t
  ;; Uncomment the config below if you want all UI panes to be hidden by default!
  ;; :custom
  ;; (lsp-enable-dap-auto-configure nil)
  ;; :config
  ;; (dap-ui-mode 1)
  :commands dap-debug
  :config
  ;; Set up Node debugging
  (require 'dap-node)
  (dap-node-setup) ;; Automatically installs Node debug adapter if needed

  ;; Bind `C-c l d` to `dap-hydra` for easy access
  (general-define-key
   :keymaps 'lsp-mode-map
   :prefix lsp-keymap-prefix
   "d" '(dap-hydra t :wk "debugger")))

(use-package company
  :ensure t
  :after lsp-mode
  :hook (lsp-mode . company-mode)
  :bind (:map company-active-map
              ("<tab>" . company-complete-selection))
  (:map lsp-mode-map
        ("<tab>" . company-indent-or-complete-common))
  :custom
  (company-minimum-prefix-length 1)
  (company-idle-delay 0.0))

(use-package company-box
  :ensure t
  :hook (company-mode . company-box-mode))

(use-package python-mode
  :ensure t
  :hook (python-mode . lsp-deferred)
  :custom
  ;; NOTE: Set these if Python 3 is called "python3" on your system!
  ;; (python-shell-interpreter "python3")
  ;; (dap-python-executable "python3")
  (dap-python-debugger 'debugpy)
  :config
  (require 'dap-python))

;; (use-package pyvenv
;;   :ensure t
;;   :after python-mode
;;   :config
;;   (setenv "WORKON_HOME" "~/miniconda3/envs")
;;   (pyvenv-mode 1))

(use-package conda
  :ensure t
  :defer t
  :init
  (setq conda-anaconda-home (expand-file-name "~/miniconda3"))
  (setq conda-env-home-directory (expand-file-name "~/miniconda3"))
  :config
  (conda-env-initialize-interactive-shells)
  (conda-env-initialize-eshell))

;; (use-package lsp-pyright
;;   :ensure t
;;   :hook (python-mode . (lambda ()
;;                          (require 'lsp-pyright)
;;                          (lsp-deferred)))
;;   :config
;;   (add-hook 'pyvenv-post-activate-hooks (lambda () (lsp-restart-workspace)))
;;   (add-hook 'conda-postactivate-hook (lambda () (lsp-restart-workspace)))
;;   (add-hook 'conda-postdeactivate-hook (lambda () (lsp-restart-workspace)))) ; or lsp-deferred

(use-package lsp-python-ms
  :ensure t
  :init (setq lsp-python-ms-auto-install-server t)
  :hook (python-mode . (lambda ()
                          (require 'lsp-python-ms)
                          (lsp-deferred)))  ; or lsp-deferred
  :config
  (add-hook 'pyvenv-post-activate-hooks (lambda () (lsp-restart-workspace)))
  (add-hook 'conda-postactivate-hook (lambda () (lsp-restart-workspace)))
  (add-hook 'conda-postdeactivate-hook (lambda () (lsp-restart-workspace)))) ; or lsp-deferred
