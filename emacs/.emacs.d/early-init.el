;; Make Emacs fullscreen on startup
(cond ((eq system-type 'darwin)
       (setq frame-resize-pixelwise t
	     window-resize-pixelwise t))
      ((eq system-type 'gnu/linux)
       (add-to-list 'initial-frame-alist '(fullscreen . maximized))))
