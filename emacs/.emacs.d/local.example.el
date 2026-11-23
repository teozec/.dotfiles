;; -*- lexical-binding: nil; -*-

;; Copy this file to local.el, remove undesired features and configure the desired ones if needed.
(setq my/features
      '(
	(terraform) ; Support for the Terraform language and major mode
	(clojure) ; Support for the Clojure language and related modes
	(rust) ; Support for the Rust language and major mode
	(markdown) ; Support for the Markdown language and major mode
	(common-lisp ; Support for the Common Lisp language and major mode
	 :program "/path/to/lisp") ; Common Lisp executable
	))
