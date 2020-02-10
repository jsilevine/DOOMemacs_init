;;; $DOOMDIR/config.el -*- lexical-binding: t; -*-

(require 'poly-R)
(require 'poly-markdown)

;; Some functionality uses this to identify you, e.g. GPG configuration, email
;; clients, file templates and snippets.
(setq user-full-name "Jacob Levine"
      user-mail-address "jacoblevine@princeton.edu")

;; Doom exposes five (optional) variables for controlling fonts in Doom. Here
;; are the three important ones:
;;
;; + `doom-font'
;; + `doom-variable-pitch-font'
;; + `doom-big-font' -- used for `doom-big-font-mode'
;;

(setq doom-font (font-spec :family "monospace" :size 14))
(setq doom-theme 'doom-one)

;; If you intend to use org, it is recommended you change this!
(setq org-directory "~/org/")

;; Default-Frame-Alist
(add-to-list 'default-frame-alist '(fullscreen . maximized))
(add-to-list 'default-frame-alist '(cursor-color . "white"))

;;;; set up buffer orientation to be like Rstudio
(setq ess-ask-for-ess-directory nil)
(setq ess-local-process-name "R")
(setq ansi-color-for-comint-mode 'filter)
(setq comint-scroll-to-bottom-on-input t)
(setq comint-scroll-to-bottom-on-output t)
(setq comint-move-point-for-output t)
(defun my-ess-start-R ()
  (interactive)
  (unless (mapcar (lambda (s) (string-match "*R" (buffer-name s))) (buffer-list))
;;    (unless (string-match "*R" (mapcar (function buffer-name) (buffer-list)))
      (progn
        (delete-other-windows)
        (setq w1 (selected-window))
        (setq w1name (buffer-name))
        (setq w2 (split-window-right w1 nil t))
        (R)
        (set-window-buffer w2 "*R")
        (set-window-buffer w1 w1name))))
(defun my-ess-eval ()
  (interactive)
  (my-ess-start-R)
  (if (and transient-mark-mode mark-active)
      (call-interactively 'ess-eval-region)
    (call-interactively 'ess-eval-line-and-step)))
(add-hook 'ess-mode-hook
          '(lambda()
             (local-set-key [(shift return)] 'my-ess-eval)))
(add-hook 'inferior-ess-mode-hook
          '(lambda()
             (local-set-key [C-up] 'comint-previous-input)
             (local-set-key [C-down] 'comint-next-input)))
(add-hook 'Rnw-mode-hook
          '(lambda()
             (local-set-key [(shift return)] 'my-ess-eval)))
(require 'ess-site)

(setq display-buffer-alist '(("*R"
                              (display-buffer-reuse-window display-buffer-in-side-window)
                              (side . right)
                              (slot . -1)
                              (window-width . 0.5)
                              (reusable-frames . nil))
                            ("*Help"
                              (display-buffer-reuse-window display-buffer-in-side-window)
                              (side . right)
                              (slot . 1)
                              (window-width . 0.5)
                              (reusable-frames . nil))))

;; add keybinding for rmarkdown code-chunks
(defun jil-insert-r-chunk (header)
  "Insert an r-chunk in markdown mode."
  (interactive "sLabel: ")
  (insert (concat "```{r " header "}\n\n```"))
  (forward-line -1))

(global-set-key (kbd "C-c i") 'jil-insert-r-chunk)

(global-set-key (kbd "C-x t m") 'treemacs)
(global-set-key (kbd "C-c l") 'org-store-link)
(global-set-key (kbd "C-c a") 'org-agenda)
(global-set-key (kbd "C-c c") 'org-capture)
(global-set-key (kbd "C-c s s") 'shell)

;; use lintr and flycheck
(add-hook 'after-init-hook #'global-flycheck-mode)
(add-hook 'ess-mode-hook
          (lambda () (flycheck-mode t)))


;;;; change run shortcut to control+enter
;;(eval-after-load "ess-mode"
  ;;'(progn
    ;; (define-key ess-mode-map [(control return)] 'ess-eval-region-or-line-and-step)))

(use-package projectile
  :init
  (setq
   ;; we mainly want projects defined by a few markers and we always want to take the top-most marker.
   ;; Reorder so other cases are secondary
   projectile-project-root-files #'( ".projectile" )
   projectile-project-root-files-functions #'(projectile-root-top-down
                                              projectile-root-top-down-recurring
                                              projectile-root-bottom-up
                                              projectile-root-local)))

(setq projectile-project-search-path '("~/Documents/Science/Princeton/"))
(setq projectile-indexing-method 'hybrid)

;; Here are some additional functions/macros that could help you configure Doom:
;;
;; - `load!' for loading external *.el files relative to this one
;; - `use-package' for configuring packages
;; - `after!' for running code after a package has loaded
;; - `add-load-path!' for adding directories to the `load-path', where Emacs
;;   looks when you load packages with `require' or `use-package'.
;; - `map!' for binding new keys
;;
;; To get information about any of these functions/macros, move the cursor over
;; the highlighted symbol at press 'K' (non-evil users must press 'C-c g k').
;; This will open documentation for it, including demos of how they are used.
;;
;; You can also try 'gd' (or 'C-c g d') to jump to their definition and see how
;; they are implemented.
