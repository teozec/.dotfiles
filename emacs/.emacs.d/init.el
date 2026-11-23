;; -*- lexical-binding: nil; -*-

;; Minimum supported Emacs version: 31.1

(defvar my/features nil
  "Alist (FEATURE . PLIST) of enabled features.")

(load (expand-file-name "local.el" user-emacs-directory) t t)

(defun my/feature-p (feature)
  "(FEATURE . PLIST) if FEATURE is enabled, nil otherwise."
  (assq feature my/features))

(defun my/feature-opt (feature opt &optional default)
  "Value of option OPT of FEATURE, or DEFAULT if absent."
  (or (plist-get (cdr (my/feature-p feature)) opt) default))

(setq custom-file (expand-file-name "custom.el" user-emacs-directory))
(setq visible-bell t)
(setq package-install-upgrade-built-in t)

(add-to-list 'exec-path "~/.local/bin")

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

(use-package dired
  :config
  (setq dired-kill-when-opening-new-dired-buffer t))

(use-package dired-sidebar
  :ensure t
  :preface
  (defun my/dired-sidebar--mouse-toggle (event)
    "Expand/collapse the directory actually clicked on, not point."
    (interactive "e")
    (let ((pos (posn-point (event-end event)))
          (window (posn-window (event-end event))))
      (with-selected-window window
	(goto-char pos)
	(dired-sidebar-subtree-toggle))))
  :bind (("C-x s" . dired-sidebar-toggle-sidebar)
	 :map dired-sidebar-mode-map
         ([mouse-3] . my/dired-sidebar--mouse-toggle))
  :commands (dired-sidebar-toggle-sidebar)
  :config
  (setq dired-sidebar-window-fixed nil
	dired-sidebar-width 50))

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
  (evil-collection-init '(magit dired vterm)))

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

(setq treesit-auto-install-grammar 'ask)

(use-package eglot
  :hook (prog-mode . eglot-ensure))

(use-package eldoc
  :init
  (global-eldoc-mode))

(use-package exec-path-from-shell
  :ensure t
  :if (memq window-system '(mac ns x))
  :config
  (exec-path-from-shell-initialize))

(add-to-list 'load-path (expand-file-name "local-packages/beancount-mode/" user-emacs-directory))
(use-package beancount
  :ensure t
  :config
  (add-to-list 'auto-mode-alist '("\\.bean\\'" . beancount-mode)))

(use-package nvm
  :ensure t
  :config (setenv "NVM_DIR" (expand-file-name "~/.nvm"))
  :hook ((js-ts-mode typescript-ts-mode) .
         (lambda () (nvm-use-for-buffer))))

(setq scheme-program-name "/usr/bin/mit-scheme")

(use-package rfc-mode
  :ensure t
  :config
  (setq rfc-mode-directory (expand-file-name "~/.rfc/")))

(use-package vterm
  :ensure t
  :bind (:map vterm-mode-map
	      ("<wheel-up>" . (lambda () (interactive) (vterm-send-key "<prior>")))
	      ("<wheel-down>" . (lambda () (interactive) (vterm-send-key "<next>")))))

(use-package perspective
  :bind
  ("C-x C-b" . persp-list-buffers)
  :custom
  (persp-mode-prefix-key (kbd "C-c x"))  ; pick your own prefix key here
  :init
  (persp-mode))

(use-package emms
  :ensure t
  :config
  (require 'emms-setup)
  (emms-all)
  (emms-default-players)
  ;; MPRIS needs D-Bus, which macOS builds of Emacs don't have.
  (when (featurep 'dbusbind)
    (require 'emms-mpris)
    (emms-mpris-enable)))

(use-package rust-ts-mode
  :if (my/feature-p 'rust)
  :ensure t
  :config
  (add-to-list 'eglot-server-programs
               '((rust-ts-mode) .
		 ("rustup" "run" "stable" "rust-analyzer" :initializationOptions (:check (:command "clippy"))))))

(use-package terraform-ts-mode
  :if (my/feature-p 'terraform)
  :vc (:url "https://codeberg.org/ccbash-oss/terraform-ts-mode"
	    :rev "v1.1")
  :ensure t
  :hook (terraform-ts-mode . eglot-ensure))

(use-package clojure-ts-mode
  :if (my/feature-p 'clojure)
  :ensure t)

(use-package cider
  :if (my/feature-p 'clojure)
  :ensure t)

