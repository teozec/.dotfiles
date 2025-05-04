(setq custom-file (expand-file-name "custom.el" user-emacs-directory))
(setq visible-bell t)
(setq package-install-upgrade-built-in t)

(cond ((eq system-type 'darwin)
       (setq default-input-method "MacOSX"
	     mac-command-modifier 'meta
	     mac-option-modifier nil
	     mac-allow-antialiasing t
	     mac-command-key-is-meta t)))

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
	     :config
	     (evil-mode))

(use-package solarized-theme
  :ensure t
  :config
  (load-theme 'solarized-light t))

(use-package magit
  :ensure t)
