(require 'package)
(setq package-archives '(
			("melpa" . "https://melpa.org/packages/")
			("org" . "https://orgmode.org/elpa/")
			("elpa" . "https://elpa.gnu.org/packages/")))
(package-initialize)
(unless package-archive-contents
  (package-refresh-contents))
(setq package-native-compile t)

(use-package auto-package-update
:ensure t
:config
(setq auto-package-update-delete-old-versions t))

(require 'bind-key)
(unless (package-installed-p 'use-package)
  (package-install 'use-package))

(add-to-list 'default-frame-alist
	    '(font . "Iosevka-25"))

(defalias 'yes-or-no-p 'y-or-n-p)

(setq inhibit-startup-screen t)
(setq compile-command "")
(setq compilation-ask-about-save nil)
(tool-bar-mode 0)
(menu-bar-mode 0)
(scroll-bar-mode 0)
(blink-cursor-mode 0)
(column-number-mode 1)
(electric-pair-mode 1)
(electric-pair-mode 1)
(global-display-line-numbers-mode 1)
(menu-bar--display-line-numbers-mode-relative)
(fringe-mode 0)
(setq org-src-tab-acts-natively 't)

(global-set-key (kbd "<escape>") 'keyboard-escape-quit)
(global-set-key (kbd "C-c C-c") 'comment-or-uncomment-region)

(setq make-backup-files nil)
(setq auto-save-default nil)
(defun my-minibuffer-setup-hook ()
  (setq gc-cons-threshold most-positive-fixnum))

(defun my-minibuffer-exit-hook ()
  (setq gc-cons-threshold 10000000))

(add-hook 'minibuffer-setup-hook #'my-minibuffer-setup-hook)
(add-hook 'minibuffer-exit-hook #'my-minibuffer-exit-hook)

(use-package evil
:ensure t
:init
(setq evil-want-integration t)
(setq evil-want-keybinding nil)
(setq cursor-type 'box)
(setq evil-normal-state-cursor 'box)
(setq evil-insert-state-cursor 'box)
(setq evil-visual-state-cursor 'box)
(setq evil-motion-state-cursor 'box)
(setq evil-replace-state-cursor 'box)
(setq evil-operator-state-cursor 'box)
(global-set-key (kbd "C-u") 'evil-scroll-page-up)
:config 
(define-key evil-normal-state-map "\ s" 'shell-command)
(evil-mode))

(use-package evil-collection
:ensure t
:after evil
:config
(evil-collection-init))

(use-package magit
  :ensure t
  :commands (magit-status magit-get-current-branch)
  :custom
  (magit-display-buffer-function #'magit-display-buffer-same-window-except-diff-v1))

(use-package markdown-mode
  :ensure t
  :mode ("README\\.md\\'" . gfm-mode)
  :init (setq markdown-command "multimarkdown"))

;;(use-package auctex
  ;;:ensure t
  ;;:defer t)
;;(add-hook 'doc-view-mode-hook 'auto-revert-mode)
;;
;;(use-package lsp-latex
  ;;:ensure t)

(use-package lsp-mode
  :commands (lsp lsp-deferred)
  :bind ("C-k" . lsp-find-definition)
  :custom
  (lsp-eldoc-render-all t)
  (lsp-idle-delay 0.6)
  :config
  (add-hook 'lsp-mode-hook 'lsp-ui-mode)
  :init
  (setq lsp-keymap-prefix "C-l"))

(use-package lsp-ui
  :ensure
  :commands lsp-ui-mode
  :custom
  (lsp-ui-peek-always-show t)
  (lsp-ui-sideline-show-hover t))

;;(with-eval-after-load "tex-mode"
;;(add-hook 'tex-mode-hook 'lsp)
;;(add-hook 'latex-mode-hook 'lsp))

;; C/C++
(add-hook 'c-mode-hook 'lsp)
(add-hook 'c++-mode-hook 'lsp)

;; python
(use-package lsp-pyright
  :ensure t
  :hook (python-mode . (lambda () (require 'lsp-pyright)
			 (lsp))))

(setq lsp-enable-symbol-highlighting nil)
(setq lsp-enable-links nil)
(setq lsp-headerline-breadcrumb-enable nil)
(setq lsp-ui-sideline-show-diagnostics 1)
(setq lsp-ui-doc-enable nil)

(use-package company
  :ensure
  :custom
  (company-idle-delay 0.5)
  (company-minimum-prefix-length 1)
  :bind
  (:map company-active-map
	("C-n". company-select-next)
	("C-p". company-select-previous)))

(use-package yasnippet
  :ensure
  :config
  (yas-reload-all)
  (add-hook 'prog-mode-hook 'yas-minor-mode)
  (add-hook 'text-mode-hook 'yas-minor-mode))

(use-package flycheck
  :ensure t
  :init (global-flycheck-mode))

(use-package rust-mode
:ensure t)

(use-package rustic
:ensure t)

(use-package projectile
  :ensure t
  :bind (
  ("C-x d" . projectile-dired)
  ("C-c c" . project-compile)
  ("C-c s" . projectile-switch-project))
  :init
  (when (file-directory-p "~/documents")
    (setq projectile-project-search-path '("~/documents")))
  (when (file-directory-p "~/code")
    (setq projectile-project-search-path '("~/code")))
  (projectile-mode 1))

(setq ido-enable-flex-matching t)
(setq ido-everywhere t)
(ido-mode 1)

(use-package ido-vertical-mode
  :ensure t
  :init
  (ido-vertical-mode 1))
(setq ido-vertical-define-keys 'C-n-and-C-p-only)

(use-package smex
  :ensure t
  :init (smex-initialize)
  :bind
  ("M-x" . smex))

(use-package diminish
  :ensure t
  :init
  (diminish 'which-key-mode)
  (diminish 'flycheck-mode)
  (diminish 'projectile-mode))

;;(use-package pdf-tools
;;:ensure t
;;:pin manual ;; don't reinstall when package updates
;;:mode  ("\\.pdf\\'" . pdf-view-mode)
;;:config
;;(setq-default pdf-view-display-size 'fit-page)
;;(setq pdf-annot-activate-created-annotations t)
;;(pdf-tools-install :no-query)
;;(require 'pdf-occur))

(use-package gdb
  :ensure nil
  :commands gdb)

(use-package cmake-mode
:ensure t
:mode ("CMakeLists\\.txt\\'" "\\.cmake\\'")
:hook (cmake-mode . lsp-deferred))

(use-package cmake-ide
  :ensure t
  :defer 2
  :config
  (cmake-ide-setup))
