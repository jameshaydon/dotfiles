;; little garbage collection during init
(setq gc-cons-threshold 64000000)
;; restore after startup
(add-hook 'after-init-hook (lambda ()
                             (setq gc-cons-threshold 100000000)))

;;;;;;;;;;;;;;;;;;;;;
;; Package configs ;;
;;;;;;;;;;;;;;;;;;;;;

(require 'package)

(setq package-enable-at-startup nil)
(setq package-archives '(("org"   . "http://orgmode.org/elpa/")
                         ("gnu"   . "http://elpa.gnu.org/packages/")
                         ("melpa" . "https://melpa.org/packages/")))
(package-initialize)

;; Bootstrap `use-package`
(unless (package-installed-p 'use-package)
  (package-refresh-contents)
  (package-install 'use-package))

(eval-when-compile
  (require 'use-package))

;; Always load newest byte code
(setq load-prefer-newer t)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Start an emacs daemon/server ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;;(server-start)

;;;;;;;;;;
;; Font ;;
;;;;;;;;;;

;; This packages seems needed for fira-code-emacs
(use-package dash-functional
  :ensure t)

;; https://github.com/johnw42/fira-code-emacs
;; (add-to-list 'load-path "~/dev/fira-code-emacs/")
;; (load-file "~/dev/fira-code-emacs/fira-code.el")
(set-face-attribute 'default nil :family "IBM Plex Mono" :height 125)
;;(add-hook 'prog-mode-hook 'fira-code-mode)

;; line-height
(setq-default line-spacing 6)
;; Always with the font-locking
(setq font-lock-maximum-decoration t)

;;;;;;;;;;;;;;;
;; Small fry ;;
;;;;;;;;;;;;;;;

(use-package better-defaults
  :ensure t)

(setq exec-path (append exec-path '("~/.local/bin")))

;; get rid of splash screen
(setq inhibit-startup-message t
      inhibit-startup-screen t
      inhibit-startup-echo-area-message t)

;; No blinking cursor
(blink-cursor-mode -1)

;; disable the annoying bell ring
(setq ring-bell-function 'ignore)

;; line numbers
(global-linum-mode 1)

;; Minimal UI
(scroll-bar-mode -1)
(menu-bar-mode -1)
(tool-bar-mode -1)

;; nice scrolling
(setq scroll-margin 0
      scroll-conservatively 100000
      scroll-preserve-screen-position 1)

;; tabs and indentation level

;; don't use tabs to indent
(setq-default indent-tabs-mode nil)

;; smart tab behavior - indent or complete
(setq tab-always-indent 'complete)

(setq tab-width 2)

;; Show matching parens
(setq show-paren-delay 0)
(show-paren-mode 1)

;; bind imenu brings up a really nice menu (table-of-contents like thing) of
;; the current buffer
(global-set-key (kbd "M-i") 'imenu)

;; Warn before you exit emacs!
(setq confirm-kill-emacs 'yes-or-no-p)

;; make all "yes or no" prompts show "y or n" instead
(fset 'yes-or-no-p 'y-or-n-p)

;; I use version control, don't annoy me with backup files everywhere
(setq make-backup-files nil)
(setq auto-save-default nil)

;; Allows moving point to other windows by using SHIFT+<arrow key>.
(windmove-default-keybindings)

;; revert buffers automatically when underlying files are changed externally
(global-auto-revert-mode t)

;; UTF8
(prefer-coding-system 'utf-8)
(set-default-coding-systems 'utf-8)
(set-terminal-coding-system 'utf-8)
(set-keyboard-coding-system 'utf-8)

;; Fill to 80 columns.
(setq-default fill-column 80)

;; Sessions
(desktop-save-mode 1)

;; Make ediff diff at the character level
(setq-default ediff-forward-word-function 'forward-char)

;; Show which column I'm in in the mode line as well
(column-number-mode t)

;; Let me upcase or downcase a region, which is disabled by default.
(put 'downcase-region 'disabled nil)
(put 'upcase-region 'disabled nil)

;; prettify-symbols-mode was introduced in 24.4
(global-prettify-symbols-mode +1)
(setq prettify-symbols-unprettify-at-point 'right-edge)

;; "after pressing C-u C-SPC to jump to a mark popped off the local mark ring, you can just keeping pressing C-SPC to repeat!"
(setq set-mark-command-repeat-pop t)

;; Save buffer after some idle time after a change.
(auto-save-visited-mode 1)
(setq auto-save-visited-interval 1)

;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Auto-update packages ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;

(use-package auto-package-update
  :ensure t
  :config
  (setq auto-package-update-delete-old-versions t
        auto-package-update-interval 1)
  (auto-package-update-maybe))

;;;;;;;;;;;
;; Theme ;;
;;;;;;;;;;;

(use-package doom-themes
  :ensure t
  :config
  (load-theme 'doom-Iosvkem t)
  (set-face-background 'default "black"))

;; (use-package zenburn-theme
;;   :ensure t
;;   :config (load-theme 'zenburn t))

(use-package popwin
  :ensure t
  :config (popwin-mode 1))

;; ;; highlight the current line
;; (use-package hl-line
;;   :ensure t
;;   :config (global-hl-line-mode 1))

(use-package doom-modeline
  :ensure t
  :hook (after-init . doom-modeline-mode))

;;;;;;;;;;;;;;;
;; which-key ;;
;;;;;;;;;;;;;;;

(use-package which-key
  :ensure t
  :defer 0.2
  :diminish
  :config (which-key-mode))

;;;;;;;;;;;;;;;;;;;;;;;;;
;; sane-term terminal ;;
;;;;;;;;;;;;;;;;;;;;;;;;;

(use-package sane-term
  :ensure t
  :bind (("C-x t" . sane-term)
         ("C-x T" . sane-term-create))
  :config
  (setq sane-term-shell-command "/bin/zsh"))

;;;;;;;;;;;;;;
;; flycheck ;;
;;;;;;;;;;;;;;

(use-package flycheck
  :ensure t
  :defer t
  :init
  (global-flycheck-mode t)
  )

(use-package flycheck-pos-tip
  :ensure t
  :defer t
  :config (with-eval-after-load 'flycheck (flycheck-pos-tip-mode))
  )

;;;;;;;;;;
;; Helm ;;
;;;;;;;;;;

;; (use-package helm
;;   :ensure t
;;   :demand t
;;   :init
;;   (setq helm-M-x-fuzzy-match t
;; 	helm-mode-fuzzy-match t
;; 	helm-buffers-fuzzy-matching t
;; 	helm-recentf-fuzzy-match t
;; 	helm-locate-fuzzy-match t
;; 	helm-semantic-fuzzy-match t
;; 	helm-imenu-fuzzy-match t
;; 	helm-completion-in-region-fuzzy-match t
;; 	helm-candidate-number-list 150
;; 	helm-split-window-in-side-p t
;; 	helm-move-to-line-cycle-in-source t
;; 	helm-echo-input-in-header-line t
;; 	helm-autoresize-max-height 0
;; 	helm-autoresize-min-height 20)
;;   :config (helm-mode 1)
;;   :bind (("C-x C-f" . helm-find-files)
;; 	 ("M-x" . helm-M-x)))

;;;;;;;;;;;;;;;
;; prescient ;;
;;;;;;;;;;;;;;;

(use-package prescient
  :ensure t
  :config (prescient-persist-mode t))

(use-package ivy-prescient
  :ensure t
  :after (ivy prescient)
  :config (ivy-prescient-mode t))

(use-package company-prescient
  :after (company prescient)
  :ensure t
  :config (company-prescient-mode t))

;;;;;;;;;
;; Ivy ;;
;;;;;;;;;

(use-package amx
  :ensure t
  :config (amx-mode)
  )

(use-package ivy
  :demand t
  :ensure t
  :config
  (setq ivy-use-virtual-buffers t
        ivy-count-format "%d/%d "
        enable-recursive-minibuffers t)
  (setq ivy-re-builders-alist
        '((swiper . ivy--regex-plus)
          (t      . ivy--regex-fuzzy)))
  (ivy-mode 1)
  (global-set-key (kbd "<f6>") 'ivy-resume)
  (global-set-key (kbd "C-c v") 'ivy-push-view)
  :bind ("C-c C-r" . ivy-resume))

(use-package swiper
  :ensure t
  :config (global-set-key "\C-s" 'swiper)
  :bind (("C-s" . swiper)
         ("C-r" . swiper)))

(use-package counsel
  :ensure t
  :after ivy
  :demand t
  :config
  (define-key minibuffer-local-map (kbd "C-r") 'counsel-minibuffer-history)
  :bind (("M-x" . counsel-M-x)
         ("C-x C-f" . counsel-find-file)))

(use-package counsel-projectile
  :after (counsel projectile)
  :ensure t
  :config
  (setq counsel-projectile-sort-files t)
  (counsel-projectile-mode t))

(use-package ivy-posframe
  :ensure t
  :after ivy
  :custom
  (ivy-display-function #'ivy-posframe-display-at-frame-center)
  :config (ivy-posframe-mode t))

;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Line-based searching ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;

;; (use-package helm-ag
;;   :ensure t
;;   :bind ("C-c r g" . helm-do-ag-project-root)
;;   :init (setq helm-ag-base-command "rg --no-heading --smart-case"))

(use-package deadgrep
  :ensure t
  :config
  (global-set-key (kbd "<f5>") #'deadgrep))

;;;;;;;;;;;;;;;
;; Multiterm ;;
;;;;;;;;;;;;;;;

(use-package multi-term
  :ensure t
  ;; :bind (("C-x M" . multi-term)
  ;;        ("C-x m" . switch-to-term-mode-buffer))
  ;; :config
  ;; (setq multi-term-dedicated-select-after-open-p t
  ;;       multi-term-dedicated-window-height 25
  ;;       multi-term-program "/bin/bash")

  ;; ;; Enable compilation-shell-minor-mode in multi term.
  ;; ;; http://www.masteringemacs.org/articles/2012/05/29/compiling-running-scripts-emacs/

  ;; ;; TODO: WTF? Turns off colors in terminal.
  ;; ;; (add-hook 'term-mode-hook 'compilation-shell-minor-mode)
  ;; (add-hook 'term-mode-hook
  ;;           (lambda ()
  ;;             (dolist
  ;;                 (bind '(("<S-down>" . multi-term)
  ;;                         ("<S-left>" . multi-term-prev)
  ;;                         ("<S-right>" . multi-term-next)
  ;;                         ("C-<backspace>" . term-send-backward-kill-word)
  ;;                         ("C-<delete>" . term-send-forward-kill-word)
  ;;                         ("C-<left>" . term-send-backward-word)
  ;;                         ("C-<right>" . term-send-forward-word)
  ;;                         ("C-c C-j" . term-line-mode)
  ;;                         ("C-c C-k" . term-char-mode)
  ;;                         ("C-v" . scroll-up)
  ;;                         ("C-y" . term-paste)
  ;;                         ("C-z" . term-stop-subjob)
  ;;                         ("M-DEL" . term-send-backward-kill-word)
  ;;                         ("M-d" . term-send-forward-kill-word)))
  ;;               (add-to-list 'term-bind-key-alist bind))))
  )

;;;;;;;;;;;;;;;;;;;;;;
;; Multiple Cursors ;;
;;;;;;;;;;;;;;;;;;;;;;

(use-package multiple-cursors
  :ensure t
  :demand t
  :bind (("C-S-c C-S-c" . mc/edit-lines)
	 ("C->"         . mc/mark-next-like-this)
	 ("C-<"         . mc/mark-previous-like-this)
         ("C-x a"       . mc/mark-all-like-this))
  )

;;;;;;;;;;;;;;;;;
;; Completions ;;
;;;;;;;;;;;;;;;;;

(use-package company
  :ensure t
  :config
  (setq company-idle-delay 0.5)
  (setq company-show-numbers t)
  (setq company-tooltip-limit 10)
  (setq company-minimum-prefix-length 2)
  (setq company-tooltip-align-annotations t)
  ;; invert the navigation direction if the the completion popup-isearch-match
  ;; is displayed on top (happens near the bottom of windows)
  (setq company-tooltip-flip-when-above t)
  (global-company-mode))

; Documentation popups for Company
(use-package company-quickhelp
  :ensure t
  :defer t
  :init (add-hook 'global-company-mode-hook #'company-quickhelp-mode))

;;;;;;;;;;;;;;;;
;; Projectile ;;
;;;;;;;;;;;;;;;;

(use-package projectile
  :ensure t
  :bind (("C-x p f" . projectile-find-file)
         ("C-x p p" . projectile-find-file-in-known-projects))
  :init
  (setq projectile-require-project-root nil)
  (setq projectile-completion-system 'ivy)
  :config
  (projectile-mode 1))

;;;;;;;;;;;;;;;
;; Searching ;;
;;;;;;;;;;;;;;;

;; Smart jump
(use-package smart-jump
  :ensure t
  :config (smart-jump-setup-default-registers)
  :defer t
  ;; TODO: figure out why these are sometimes bound and sometimes not:
  :bind (("M-." . smart-jump-go)
         ("M-," . smart-jump-back))
  )

;; Visual jump
(use-package avy
  :ensure t
  :bind (("C-;" . avy-goto-char-timer)
	 ("C-:" . avy-goto-char)
         ("C-'" . avy-goto-char-2)
	 ;; ("C-." . avy-goto-word-or-subword-1)
	 ;; ("C-," . avy-goto-line)
         )
  :config (setq avy-background t))

;; Visual window select
(use-package ace-window
  :ensure t
  :bind* ("M-o" . ace-window)
  :init (setq aw-keys '(?a ?s ?d ?f ?g ?h ?j ?k ?l)))

;;;;;;;;;;;;;
;; Editing ;;
;;;;;;;;;;;;;

(use-package smartparens
  :ensure t
  :init
  (require 'smartparens-config)
  (smartparens-global-mode 1)
  (show-smartparens-global-mode 1)
  :config
  (setq smartparens-strict-mode t)
  (add-hook 'prog-mode-hook 'turn-on-smartparens-strict-mode)
  (add-hook 'markdown-mode-hook 'turn-on-smartparens-strict-mode)

  ;; Inspired by:
  ;; - https://github.com/Fuco1/.emacs.d/blob/master/files/smartparens.el
  ;; - https://gist.github.com/pvik/8eb5755cc34da0226e3fc23a320a3c95
  
  (define-key smartparens-mode-map (kbd "C-M-f") 'sp-forward-sexp)
  (define-key smartparens-mode-map (kbd "C-M-b") 'sp-backward-sexp)

  (define-key smartparens-mode-map (kbd "C-M-u") 'sp-backward-up-sexp)
  (define-key smartparens-mode-map (kbd "C-M-d") 'sp-down-sexp)
  (define-key smartparens-mode-map (kbd "C-M-e") 'sp-up-sexp)
  (define-key smartparens-mode-map (kbd "C-M-a") 'sp-backward-down-sexp)
  
  (define-key smartparens-mode-map (kbd "C-S-d") 'sp-beginning-of-sexp)
  (define-key smartparens-mode-map (kbd "C-S-a") 'sp-end-of-sexp)

  (define-key smartparens-mode-map (kbd "C-M-t") 'sp-transpose-hybrid-sexp)

  (define-key smartparens-mode-map (kbd "C-M-n") 'sp-forward-hybrid-sexp)
  (define-key smartparens-mode-map (kbd "C-M-p") 'sp-backward-hybrid-sexp)

  (define-key smartparens-mode-map (kbd "C-M-k") 'sp-kill-sexp)
  (define-key smartparens-mode-map (kbd "C-M-w") 'sp-copy-sexp)

  ;; Unwrapping
  (define-key smartparens-mode-map (kbd "M-<delete>") 'sp-unwrap-sexp)
  ;;(define-key smartparens-mode-map (kbd "C-M-<backspace>") 'sp-backward-unwrap-sexp)

  ;; Slurping and barfing
  (define-key smartparens-mode-map (kbd "C-<right>") 'sp-slurp-hybrid-sexp)
  (define-key smartparens-mode-map (kbd "C-<left>") 'sp-forward-barf-sexp)
  (define-key smartparens-mode-map (kbd "C-M-<left>") 'sp-backward-slurp-sexp)
  (define-key smartparens-mode-map (kbd "C-M-<right>") 'sp-backward-barf-sexp)

  (define-key smartparens-mode-map (kbd "M-D") 'sp-splice-sexp)
  (define-key smartparens-mode-map (kbd "C-M-<delete>") 'sp-splice-sexp-killing-forward)
  (define-key smartparens-mode-map (kbd "C-M-<backspace>") 'sp-splice-sexp-killing-backward)
  (define-key smartparens-mode-map (kbd "C-S-<backspace>") 'sp-splice-sexp-killing-around)
  
  (define-key smartparens-mode-map (kbd "C-]") 'sp-select-next-thing-exchange)
  (define-key smartparens-mode-map (kbd "C-<left_bracket>") 'sp-select-previous-thing)
  (define-key smartparens-mode-map (kbd "C-M-]") 'sp-select-next-thing)

  (define-key smartparens-mode-map (kbd "M-F") 'sp-forward-symbol)
  (define-key smartparens-mode-map (kbd "M-B") 'sp-backward-symbol)

  (define-key smartparens-mode-map (kbd "C-\"") 'sp-change-inner)
  ;;(define-key smartparens-mode-map (kbd "M-i") 'sp-change-enclosing)

  (bind-key "C-c f" (lambda () (interactive) (sp-beginning-of-sexp 2)) smartparens-mode-map)
  (bind-key "C-c b" (lambda () (interactive) (sp-beginning-of-sexp -2)) smartparens-mode-map)

  ;; And some more:
  (define-key smartparens-mode-map (kbd "M-(") 'sp-wrap-round)
  (define-key smartparens-mode-map (kbd "M-[") 'sp-wrap-square)
  (define-key smartparens-mode-map (kbd "M-{") 'sp-wrap-curly)
  )

;;;;;;;;;;;;;;;
;; Indenting ;;
;;;;;;;;;;;;;;;

(electric-indent-mode 1)

(use-package aggressive-indent
  :ensure t
  :config
  (global-aggressive-indent-mode 1)
  (add-hook 'emacs-lisp-mode-hook #'aggressive-indent-mode)
  (add-hook 'lisp-mode-hook #'aggressive-indent-mode)
  )

(use-package expand-region
  :ensure t
  :bind ("C-=" . er/expand-region))

;;;;;;;;;;;;;;
;; Snippets ;;
;;;;;;;;;;;;;;

(use-package yasnippet
  :ensure t
  :init (add-hook 'prog-mode-hook #'yas-minor-mode)
  :config
  (yas-reload-all)
  (use-package yasnippet-snippets
    :ensure t)
  (yas-global-mode 1)
  )

;;;;;;;;;;;;;;;;;;;
;; Git and Magit ;;
;;;;;;;;;;;;;;;;;;;

(use-package magit
  :ensure t
  :defer t
  :bind (("C-x g" . magit-status)))

(use-package magit-todos
  :ensure t
  :hook (magit-mode . magit-todos-mode))

(use-package git-gutter-fringe
  :ensure t
  :config
  (global-git-gutter-mode t)
  ;; (setq git-gutter-fr:side 'right-fringe)
  )

;;;;;;;;;;;;;;;;;
;; Small langs ;;
;;;;;;;;;;;;;;;;;

(use-package yaml-mode
  :ensure t
  :defer t
  )

(use-package markdown-mode
  :ensure t
  :mode (("\\.md\\'" . gfm-mode)
         ("\\.markdown\\'" . gfm-mode))
  :config
  (setq markdown-fontify-code-blocks-natively t))

;;;;;;;;;;;;;;;;;;;;
;; dired settings ;;
;;;;;;;;;;;;;;;;;;;;

(setq dired-dwim-target t
      dired-recursive-deletes t
      dired-use-ls-dired nil
      delete-by-moving-to-trash t)

;;;;;;;;;;;;;;;;;
;; Programming ;;
;;;;;;;;;;;;;;;;;

(add-hook 'prog-mode-hook 'subword-mode)

;; (use-package lsp-mode
;;   :ensure t
;;   :hook (haskell-mode . lsp)
;;   :commands lsp)

;; (use-package company-lsp
;;   :ensure t
;;   :commands company-lsp)

;; (use-package lsp-ui
;;   :ensure t
;;   :commands lsp-ui-mode)

;;;;;;;;;;;
;; Idris ;;
;;;;;;;;;;;

;; (use-package idris-mode
;;   :ensure t)

;; (use-package helm-idris
;;   :ensure t)

;;;;;;;;;;;;;
;; Haskell ;;
;;;;;;;;;;;;;

;; Learn more SHM keybindings here:
;; https://github.com/projectional-haskell/structured-haskell-mode/blob/master/elisp/shm.el
;; (add-to-list 'load-path "~/.emacs.d/structured-haskell-mode/elisp")
;; (require 'shm)
;; (add-hook 'haskell-mode-hook 'structured-haskell-mode)
;; (add-hook 'structured-haskell-mode-hook
;;           (lambda ()
;;             (haskell-indent-mode nil)
;;             (set-face-background 'shm-current-face "gray20")))

(add-hook 'haskell-mode-hook
          (lambda () (setq haskell-indent-spaces 2)))

(use-package lsp-haskell
  :ensure t
  :config
  (setq lsp-haskell-process-path-hie "ghcide")
  (setq lsp-haskell-process-args-hie '())
  ;; Comment/uncomment this line to see interactions between lsp client/server.
  ;;(setq lsp-log-io t)
  )

(use-package dante
  :ensure t
  :after haskell-mode
  :commands 'dante-mode
  :init
  (add-hook 'haskell-mode-hook 'dante-mode)
  (add-hook 'haskell-mode-hook 'flycheck-mode)
  (setq flymake-no-changes-timeout nil)
  (setq flymake-start-syntax-check-on-newline nil)
  (setq flycheck-check-syntax-automatically '(save mode-enabled))
  (add-hook 'dante-mode-hook
            '(lambda () (flycheck-add-next-checker 'haskell-dante
                                              '(warning . haskell-hlint)))))
;;;;;;;;;
;; Elm ;;
;;;;;;;;;

(use-package elm-mode
  :ensure t
  :defer t
  :init
  (add-hook 'elm-mode-hook #'elm-oracle-setup-completion)
  (add-hook 'elm-mode-hook 'subword-mode)
  ;; (add-hook 'flycheck-mode-hook #'flycheck-elm-setup)
  (add-to-list 'company-backends 'company-elm)
  (setq elm-format-on-save t)
  (setq tab-always-indent t))

;;;;;;;;;;;;;;;;;;;;;;;;;
;; Clojure and Radicle ;;
;;;;;;;;;;;;;;;;;;;;;;;;;

(use-package clojure-mode
  :ensure t
  :mode (("\\.edn$" . clojure-mode)
         ("\\.rad$" . clojure-mode))
  :config
  (global-set-key (kbd "C-c C-e") 'lisp-eval-defun)
  )

;;;;;;;;;;;;;;;;;;;;;
;; web html liquid ;;
;;;;;;;;;;;;;;;;;;;;;

(use-package web-mode
  :ensure t
  )

;;;;;;;;;;;;;;;;
;; Spellcheck ;;
;;;;;;;;;;;;;;;;

(use-package flyspell
  :ensure t
  :defer t
  :hook ((prog-mode . flyspell-prog-mode)
         (text-mode . flyspell-mode))
  :config
  ;; We want to keep these for avy-jump
  (define-key flyspell-mode-map (kbd "C-.") nil)
  (define-key flyspell-mode-map (kbd "C-,") nil)
  (define-key flyspell-mode-map (kbd "C-;") nil)
  )

;;;;;;;;;;;;
;; Ebooks ;;
;;;;;;;;;;;;

(use-package nov
  :ensure t
  :mode ("\\.epub\\'" . nov-mode))

;;;;;;;;;
;; Lua ;;
;;;;;;;;;

(use-package lua-mode
  :ensure t
  :defer t
  )

;;;;;;;;;;;;;;;;
;; JavaScript ;;
;;;;;;;;;;;;;;;;

(setq js-indent-level 2)

;;;;;;;;;
;; CSS ;;
;;;;;;;;;

(setq css-indent-offset 2)

;;;;;;;;;;;
;; Latex ;;
;;;;;;;;;;;

;; (use-package tex
;;   :ensure auctex
;;   )

;;;;;;;;;;;;
;; Fennel ;;
;;;;;;;;;;;;

;; This is a git repo, you should pull it once in a while.
(autoload 'fennel-mode "~/dev/fennel-mode/fennel-mode" nil t)
(add-to-list 'auto-mode-alist '("\\.fnl\\'" . fennel-mode))

(defun run-love ()
  "Run a love project."
  (interactive)
  (run-lisp "love ."))

(global-set-key (kbd "C-c l") 'run-love)

;;;;;;;;;;;;;
;; Radicle ;;
;;;;;;;;;;;;;

(defun run-radicle ()
  "Run a radicle project."
  (interactive)
  (run-lisp "stack exec rad-repl"))

;;;;;;;;;;;;;
;; Firefox ;;
;;;;;;;;;;;;;

(use-package atomic-chrome
  :ensure t
  :config
  (atomic-chrome-start-server)
  (setq atomic-chrome-default-major-mode 'markdown-mode)
  (setq atomic-chrome-url-major-mode-alist
        '(("github\\.com" . gfm-mode)))
  )

;;;;;;;;;;;;;;
;; Org mode ;;
;;;;;;;;;;;;;;

(defun next-org-slide ()
  "Show the next slide."
  (interactive)
  (widen)
  (org-next-visible-heading 1)
  (org-narrow-to-subtree))

(global-set-key (kbd "C-c n") 'next-org-slide)

(defun prev-org-slide ()
  "Show the previous slide."
  (interactive)
  (widen)
  (org-previous-visible-heading 1)
  (org-narrow-to-subtree))

(global-set-key (kbd "C-c p") 'prev-org-slide)

;;;;;;;;;;;;;;;;
;; Font icons ;;
;;;;;;;;;;;;;;;;

(use-package all-the-icons
  :ensure t
  :init (unless (member "all-the-icons" (font-family-list))
          (all-the-icons-install-fonts t))) 

;;;;;

(provide 'init)
;;; init.el ends here
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(package-selected-packages
   '(atomic-chrome lua-mode nov clojure-mode elm-mode dante lsp-haskell helm-idris idris-mode lsp-ui lsp-mode markdown-mode yaml-mode git-gutter-fringe magit-todos magit yasnippet-snippets yasnippet expand-region aggressive-indent smartparens ace-window avy smart-jump projectile company-quickhelp company multiple-cursors counsel swiper ivy flycheck-pos-tip flycheck multi-term which-key doom-modeline popwin doom-themes auto-package-update better-defaults use-package dash-functional))
 '(safe-local-variable-values
   '((dante-methods stack)
     (dante-repl-command-line "stack" "repl"))))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
