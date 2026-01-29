(setq inhibit-startup-message t) ; disable startup page

(scroll-bar-mode -1) ; disable scroll bar
(tool-bar-mode -1) ; disable tool bar

(set-face-attribute 'default nil :font "Iosevka Fixed Extended") ; set font

(load-theme 'tango-dark) ; set theme

(require 'package)

(setq package-archives '(("melpa" . "https://melpa.org/packages/")
			 ("org" . "https://orgmode.org/elpa/")
			 ("elpa" . "https://elpa.gnu.org/packages/")))

(package-initialize)
(unless package-archive-contents
  (package-refresh-contents))

(unless (package-installed-p 'use-package)
  (package-install 'use-package))

(require 'use-package)
(setq use-package-always-ensure t)

(use-package ivy
  :diminish
  :config
  (ivy-mode 1))
