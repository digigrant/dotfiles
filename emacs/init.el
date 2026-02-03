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
(setq case-fold-search nil)

(defun gej/tab-to-next-multiple ()
  "Insert spaces to the next tab stop, replacing region if active."
  (interactive)
  (when (use-region-p)
    (delete-region (region-beginning) (region-end)))
  (let* ((col (current-column))
         (n tab-width)
         (spaces (- n (mod col n))))
    (insert (make-string spaces ?\s))))

(defun gej/unindent-line ()
  "Remove up to `tab-width` leading spaces from the current line."
  (interactive)
  (save-excursion           ; move cursor back to where it was afterwards
    (beginning-of-line)     ; move cursor to column 0
    (let ((start (point)))  ; start = cursor location (point)
      (skip-chars-forward " ") ; move cursor to first non-space character
      (let* ((indent (min tab-width (- (point) start)))) ; indent = min(4, point-start)
        (when (> indent 0)  ; if there are chars to delete (indent>0),
          (delete-region start (+ start indent))))))) ; delete them

(global-set-key (kbd "TAB") #'gej/tab-to-next-multiple)
(global-set-key (kbd "<backtab>") #'gej/unindent-line)

(defun gej/counsel-rg-notes ()
  "Run counsel-rg in a fixed directory without changing the current working directory."
  (interactive)
  (let ((default-directory "~/jai/modules/"))
    (counsel-rg nil default-directory)))

(global-set-key (kbd "C-c m") #'gej/counsel-rg-notes)

(global-set-key (kbd "C-s") #'save-buffer)

(defun gej/duplicate-lines-below ()
  "Duplicate current line or active region below, preserving column."
  (interactive)
  (let* ((col (current-column))
         (use-region (use-region-p))
         (start (if use-region
                    (save-excursion
                      (goto-char (region-beginning))
                      (line-beginning-position))
                  (line-beginning-position)))
         (end (if use-region
                  (save-excursion
                    (goto-char (region-end))
                    (line-end-position))
                (line-end-position)))
         (content (buffer-substring-no-properties start end))
         (line-offset (if use-region
                          (count-lines start (line-beginning-position))
                        0)))
    (goto-char end)
    (newline)
    (let ((insert-start (point)))
      (insert content)
      (goto-char insert-start)
      (forward-line line-offset)
      (move-to-column col))))

(defun gej/duplicate-lines-above ()
  "Duplicate current line or active region above, preserving column."
  (interactive)
  (let* ((col (current-column))
         (use-region (use-region-p))
         (start (if use-region
                    (save-excursion
                      (goto-char (region-beginning))
                      (line-beginning-position))
                  (line-beginning-position)))
         (end (if use-region
                  (save-excursion
                    (goto-char (region-end))
                    (line-end-position))
                (line-end-position)))
         (content (buffer-substring-no-properties start end))
         (line-offset (if use-region
                          (count-lines start (line-beginning-position))
                        0)))
    (goto-char start)
    (newline)
    (forward-line -1)
    (let ((insert-start (point)))
      (insert content)
      (goto-char insert-start)
      (forward-line line-offset)
      (move-to-column col))))

(global-set-key (kbd "C-M-.") #'gej/duplicate-lines-below)
(global-set-key (kbd "C-M-,") #'gej/duplicate-lines-above)

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
  :bind (("C-f" . swiper)))

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

(use-package magit
  :ensure t)

; always display magit in a reusable side buffer
(add-to-list 'display-buffer-alist
             '("\\*Magit"
               (display-buffer-reuse-window
                display-buffer-in-side-window)
               (side . right)
               (slot . 0)
               (window-width . 0.5)))

; refresh magit buffer upon save (only if open)
(defun gej/magit-visible-p ()
  (seq-some (lambda (win)
              (with-current-buffer (window-buffer win)
                (derived-mode-p 'magit-mode)))
            (window-list)))

(defun gej/magit-refresh-after-save ()
  (when (and (featurep 'magit)
             (gej/magit-visible-p))
    (magit-refresh-all)))

(add-hook 'after-save-hook #'gej/magit-refresh-after-save)

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(package-selected-packages '(counsel doom-themes helpful ivy-rich magit with-editor)))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
