(setq inhibit-startup-message t) ; disable startup page

(scroll-bar-mode -1) ; disable scroll bar
(tool-bar-mode -1) ; disable tool bar

(set-face-attribute 'default nil :font "Iosevka Fixed") ; set font

(global-display-line-numbers-mode t) ; enable line number
(column-number-mode) ; enable column number

(add-to-list 'auto-mode-alist '("\\.jai\\'" . prog-mode))

(setq-default indent-tabs-mode nil)
(setq-default tab-width 4)
(setq-default tab-always-indent 'complete)

(defun my-tab-to-next-multiple ()
  "Insert spaces to the next tab stop, replacing region if active."
  (interactive)
  (when (use-region-p)
    (delete-region (region-beginning) (region-end)))
  (let* ((col (current-column))
         (n tab-width)
         (spaces (- n (mod col n))))
    (insert (make-string spaces ?\s))))

(add-hook 'prog-mode-hook
          (lambda ()
            (local-set-key (kbd "TAB") #'my-tab-to-next-multiple)))

;; packages
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

(use-package ivy-rich
  :init
  (ivy-rich-mode 1))

(use-package counsel
  :after ivy
  :bind (("M-x" . counsel-M-x)
	 ("C-x b" . counsel-ibuffer)
	 ("C-x C-f" . counsel-find-file)
     ("C-c s" . counsel-rg))
  :config
  (counsel-mode 1)
  (setq ivy-initial-inputs-alist nil))

(use-package swiper
  :after ivy
  :bind (("C-s" . swiper)))

(use-package which-key
  :init (which-key-mode)
  :diminish which-key-mode
  :config
  (setq which-key-idle-delay 0.3))

(use-package helpful
  :custom
  (counsel-describe-function-function #'helpful-callable)
  (counsel-describe-variable-function #'helpful-variable)
  :bind
  ([remap describe-function] . counsel-describe-function)
  ([remap describe-command] . helpful-command)
  ([remap describe-variable] . counsel-describe-variable)
  ([remap describe-key] . helpful-key))

(use-package doom-themes
  :init (load-theme 'doom-badger t))


(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(package-selected-packages '(counsel doom-themes helpful ivy-rich)))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
