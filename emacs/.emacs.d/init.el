(setq custom-file (expand-file-name "custom.el" user-emacs-directory))
(setq visible-bell t)
(setq package-install-upgrade-built-in t)


(cond ((eq system-type 'darwin)
       (setq default-input-method "MacOSX"
	     mac-command-modifier 'meta
	     mac-option-modifier nil
	     mac-allow-antialiasing t
	     mac-command-key-is-meta t)

       ;; When starting emacs directly on MacOS, a gap is left below the frame, so a toggle-frame-maximized call is needed.
       ;; This does not happen when using emacsclient.
       (unless (daemonp)) (add-hook 'emacs-startup-hook #'toggle-frame-maximized)))

(tool-bar-mode -1)

;;; Packages
(require 'package)
(add-to-list 'package-archives '("melpa" . "https://melpa.org/packages/"))
(package-initialize)

(unless (package-installed-p 'use-package)
  (package-refresh-contents)
  (package-install 'use-package))
(require 'use-package)

(use-package evil
  :ensure t
  :init
  (setq evil-want-keybinding nil)
  :config
  (evil-mode))

(use-package evil-collection
  :after evil
  :ensure t
  :config
  (setq evil-collection-mode-list nil)
  (evil-collection-init '(magit dired)))

(use-package solarized-theme
  :ensure t
  :config
  (load-theme 'solarized-light t))

(use-package magit
  :ensure t)

(use-package corfu
  :ensure t
  :custom
  (corfu-auto t)
  :init
  (global-corfu-mode))


(use-package org
  :ensure t
  :config
  (global-set-key (kbd "C-c l") #'org-store-link)
  (global-set-key (kbd "C-c a") #'org-agenda)
  (global-set-key (kbd "C-c c") #'org-capture)
  (setq org-log-done 'time
	org-agenda-files   (list "~/org/")))

(use-package slime
  :ensure t
  :init
  (setq inferior-lisp-program "/opt/homebrew/bin/sbcl"))
  ;(setq slime-contribs                     '(slime-fancy)
        ;slime-complete-symbol-function     'slime-fuzzy-complete-symbol
        ;slime-net-coding-system            'utf-8-unix
        ;slime-lisp-implementations         '((sbcl  ("sbcl"))))))


(dolist (grammar
         '(
	   ;;(css . ("https://github.com/tree-sitter/tree-sitter-css" "v0.20.0"))
           ;;(bash "https://github.com/tree-sitter/tree-sitter-bash")
           ;;(html . ("https://github.com/tree-sitter/tree-sitter-html" "v0.20.1"))
           (javascript . ("https://github.com/tree-sitter/tree-sitter-javascript" "v0.23.1" "src"))
           ;;(json . ("https://github.com/tree-sitter/tree-sitter-json" "v0.20.2"))
           ;;(python . ("https://github.com/tree-sitter/tree-sitter-python" "v0.20.4"))
           ;;(go "https://github.com/tree-sitter/tree-sitter-go" "v0.20.0")
           ;;(markdown "https://github.com/ikatyang/tree-sitter-markdown")
           ;;(make "https://github.com/alemuller/tree-sitter-make")
           ;;(elisp "https://github.com/Wilfred/tree-sitter-elisp")
           ;;(cmake "https://github.com/uyha/tree-sitter-cmake")
           ;;(c "https://github.com/tree-sitter/tree-sitter-c")
           ;;(cpp "https://github.com/tree-sitter/tree-sitter-cpp")
           ;;(toml "https://github.com/tree-sitter/tree-sitter-toml")
           (rust . ("https://github.com/tree-sitter/tree-sitter-rust" "v0.21.2"))
           (tsx . ("https://github.com/tree-sitter/tree-sitter-typescript" "v0.20.3" "tsx/src"))
           (typescript . ("https://github.com/tree-sitter/tree-sitter-typescript" "v0.23.2" "typescript/src"))
           ;;(yaml . ("https://github.com/ikatyang/tree-sitter-yaml" "v0.5.0"))
           ;;(prisma "https://github.com/victorhqc/tree-sitter-prisma"))
	   ))
  (add-to-list 'treesit-language-source-alist grammar)
  (unless (treesit-language-available-p (car grammar))
    (treesit-install-language-grammar (car grammar))))

(use-package eglot
  :hook (prog-mode . eglot-ensure))

(use-package eldoc
  :init
  (global-eldoc-mode))

(use-package exec-path-from-shell
  :ensure t
  :if (memq window-system '(mac ns x))
  :init
  (exec-path-from-shell-initialize))

(add-to-list 'load-path (expand-file-name "local-packages/beancount-mode/" user-emacs-directory))
(use-package beancount
  :ensure t
  :config
  (add-to-list 'auto-mode-alist '("\\.bean\\'" . beancount-mode)))

(setq scheme-program-name "/usr/bin/mit-scheme")

