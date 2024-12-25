;;; init.el -- Gregory 'groolot/gdd' David's Emacs configuration
;;; Commentary: This is a complete configuration for Emacs >=29

(require 'package)
;;; Code:
(add-to-list 'package-archives
    '("melpa" . "https://melpa.org/packages/")
    )
(package-initialize)
(when (not package-archive-contents)
  (package-refresh-contents))
(unless (package-installed-p 'use-package)
  (package-install 'use-package))
(require 'use-package)
(setq use-package-always-ensure t)

(use-package ag)

;; (use-package auto-package-update
;;     :ensure t
;;     :config
;;     (setq auto-package-update-delete-old-versions t
;;         auto-package-update-interval 4
;;         )
;;     (auto-package-update-maybe)
;;     )

(use-package gruvbox-theme)

(use-package diff-hl
    :ensure t
    :init
    (diff-hl-margin-mode)
    (diff-hl-flydiff-mode)
    :hook
    (dired-mode . diff-hl-dired-mode)
    (magit-pre-refresh-hook . diff-hl-magit-pre-refresh)
    (magit-post-refresh-hook . diff-hl-magit-post-refresh)
    )

(use-package openwith
    :ensure t
    :init
    (openwith-mode))

;; Global Configuration
(setq rst-pdf-program "zathura")
(setq inhibit-splash-screen t)
(menu-bar-mode -1)
(tool-bar-mode -1)
(ffap-bindings)
(global-diff-hl-mode)
(global-display-line-numbers-mode)
(column-number-mode 1)
(electric-pair-mode 1)
(global-hl-line-mode 1)
(show-paren-mode 1)
(subword-mode t)
(global-auto-revert-mode 1)
(set-terminal-coding-system 'utf-8)
(set-keyboard-coding-system 'utf-8)
(set-language-environment "UTF-8")
(prefer-coding-system 'utf-8)
(delete-selection-mode)
;;; Bindings
(global-set-key (kbd "M-b") 'ibuffer)

;; External packages
;;; xClip to cut/copy to clipboard
(use-package xclip
    :ensure t
    :config
    (xclip-mode 1)
    )

;;; Editorconfig
(use-package editorconfig
  :ensure t
  :config
  (editorconfig-mode 1)
  )

;;; move-text Alt-(Up|Down)Arrow to move line
(use-package move-text
  :config
  (move-text-default-bindings)
  )

;;; Zygospore
(use-package zygospore
  :bind
  (
   ("C-x 1" . zygospore-toggle-delete-other-windows)
   ("RET" . newline-and-indent)
   )
  )

(use-package highlight-parentheses
    :ensure t
    )
(use-package highlight-operators
    :ensure t
    )
(use-package highlight-numbers
    :ensure t
    )

(define-globalized-minor-mode global-highlight-parentheses-mode
  highlight-parentheses-mode
  (lambda ()
    (highlight-parentheses-mode t)))
(global-highlight-parentheses-mode t)

;;;; C/C++ booyaaaka !
;; Treemacs (https://github.com/Alexander-Miller/treemacs)
(use-package treemacs
    :ensure t
    :defer t
    :init
    (with-eval-after-load 'winum
        (define-key winum-keymap (kbd "M-0") #'treemacs-select-window))
    :config
    (progn
        (setq
            treemacs-display-in-side-window          t
            treemacs-follow-after-init               t
            treemacs-expand-after-init               t
            treemacs-header-scroll-indicators        '(nil . "^^^^^^")
            treemacs-indentation                     2
            treemacs-missing-project-action          'ask
            treemacs-persist-file                    (expand-file-name ".cache/treemacs-persist" user-emacs-directory)
            treemacs-position                        'left
            treemacs-recenter-after-project-jump     'always
            treemacs-recenter-after-project-expand   'on-distance
            treemacs-litter-directories              '("/node_modules" "/.venv" "/.cask")
            treemacs-show-cursor                     nil
            treemacs-show-hidden-files               t
            treemacs-sorting                         'alphabetic-asc
            treemacs-width-increment                 5
            )
        (treemacs-resize-icons 16)
        (treemacs-follow-mode t)
        (treemacs-filewatch-mode t)
        (treemacs-fringe-indicator-mode 'always)
        (treemacs-indent-guide-mode t)
        (treemacs-hide-gitignored-files-mode nil))
    :bind
    (:map global-map
        ("M-0"       . treemacs-select-window)
        ("C-x t t"   . treemacs)
        ("C-x t 1"   . treemacs-delete-other-windows)
        ("C-x t d"   . treemacs-select-directory)
        ("C-x t B"   . treemacs-bookmark)
        ("C-x t C-t" . treemacs-find-file)
        ("C-x t M-t" . treemacs-find-tag)
        )
    )

(use-package cmake-mode)

(use-package magit
    :ensure t
    )

(use-package forge
    :after magit
    )

(use-package sqlite3
    :ensure t
    :after forge
    )

(use-package treemacs-magit
    :after (treemacs magit)
    :ensure t
    )

(add-hook 'magit-pre-refresh-hook 'diff-hl-magit-pre-refresh)
(add-hook 'magit-post-refresh-hook 'diff-hl-magit-post-refresh)


(use-package systemd)
(add-to-list 'auto-mode-alist '("\\.service\\'" . systemd-mode))
(add-to-list 'auto-mode-alist '("\\.path\\'" . systemd-mode))
(add-to-list 'auto-mode-alist '("\\.network\\'" . systemd-mode))
(add-to-list 'auto-mode-alist '("\\.unit\\'" . systemd-mode))
(add-to-list 'auto-mode-alist '("\\.timer\\'" . systemd-mode))

(use-package which-key
    :config
    (which-key-mode))

;; company
(use-package company
  :ensure t
  :bind ("M-/" . company-complete-common-or-cycle) ;; overwritten by flyspell
  :init (add-hook 'after-init-hook 'global-company-mode)
  :config
  (setq company-show-numbers t
	company-minimum-prefix-length 1
	company-idle-delay 0.5
	company-backends
	'((company-files          ; files & directory
	   company-keywords       ; keywords
	   company-capf           ; what is this?
	   company-yasnippet)
	  (company-abbrev company-dabbrev))))

(use-package company-box
  :ensure t
  :after company
  :hook (company-mode . company-box-mode))

;; flycheck
(use-package flycheck
  :ensure t
  :init (global-flycheck-mode)
  :config
  (setq flycheck-display-errors-function
	#'flycheck-display-error-messages-unless-error-list)

  (setq flycheck-indication-mode nil))

(use-package flycheck-pkg-config)

(use-package flycheck-pos-tip
  :ensure t
  :after flycheck
  :config
  (flycheck-pos-tip-mode))

(use-package python-black
    :hook
    (python-mode . python-black-on-save-mode)
    )

(use-package python-isort
    :hook
    (python-mode . python-isort-on-save-mode)
    )

(add-to-list 'auto-mode-alist '("Sconstruct" . python-mode))
(add-to-list 'auto-mode-alist '("Sconscript" . python-mode))

;; Available C style:
;; “gnu”: The default style for GNU projects
;; “k&r”: What Kernighan and Ritchie, the authors of C used in their book
;; “bsd”: What BSD developers use, aka “Allman style” after Eric Allman.
;; “whitesmith”: Popularized by the examples that came with Whitesmiths C, an early commercial C compiler.
;; “stroustrup”: What Stroustrup, the author of C++ used in his book
;; “ellemtel”: Popular C++ coding standards as defined by “Programming in C++, Rules and Recommendations,” Erik Nyquist and Mats Henricson, Ellemtel
;; “linux”: What the Linux developers use for kernel development
;; “python”: What Python developers use for extension modules
;; “java”: The default style for java-mode (see below)
;; “user”: When you want to define your own style
(setq c-default-style "bsd")
(setq c-basic-offset 2)
(setq-default indent-tabs-mode nil)
(setq-default tab-width 2)

(use-package highlight-doxygen
  :hook
  (c-mode-common . (lambda ()
                     (highlight-doxygen-mode)
                     )
                 )
  )

;; Semantic modes
(setq semantic-default-submodes
      '(;; Perform semantic actions during idle time
        global-semantic-idle-scheduler-mode
        ;; Use a database of parsed tags
        global-semanticdb-minor-mode
        ;; Decorate buffers with additional semantic information
        global-semantic-decoration-mode
        ;; Highlight the name of the function you're currently in
        global-semantic-highlight-func-mode
        ;; show the name of the function at the top in a sticky
        ;; global-semantic-stickyfunc-mode
        ;; Generate a summary of the current tag when idle
        global-semantic-idle-summary-mode
        ;; Show a breadcrumb of location during idle time
        global-semantic-idle-breadcrumbs-mode
        ;; Switch to recently changed tags with `semantic-mrub-switch-tags',
        ;; or `C-x B'
        ;;global-semantic-mru-bookmark-mode
        )
      )

(require 'semantic/sb)

;;; LaTeX/auctex
(use-package tex
  :ensure auctex
  )

;;; PlantUML mode
(use-package plantuml-mode
  :config
;  (setq plantuml-default-exec-mode 'jar)
;  (setq plantuml-jar-path '/home/gregory/plantuml.jar)
;  (setq plantuml-jar-args '-tsvg)
;  (setq plantuml-java-args '(-Djava.awt.headless=true -jar))
;;  (setq plantuml-executable-path "/usr/bin/plantuml")
;;  (setq plantuml-executable-args "-headless -tsvg")
  )
(use-package flycheck-plantuml
  :config
  (flycheck-plantuml-setup)
  )
;; Enable plantuml-mode for PlantUML files
(add-to-list 'auto-mode-alist '("\\.plantuml\\'" . plantuml-mode))
(add-to-list 'auto-mode-alist '("\\.puml\\'" . plantuml-mode))

;; Markdown
(use-package markdown-mode
  :config
  )
(use-package markdown-toc
  :config
  )

;;; Gitlab et CI/CD
(use-package gitlab-ci-mode)
(use-package gitlab-ci-mode-flycheck)

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(TeX-view-program-selection
      '(((output-dvi has-no-display-manager)
            "dvi2tty")
           ((output-dvi style-pstricks)
               "dvips and gv")
           (output-dvi "xdvi")
           (output-pdf "Zathura")
           (output-html "xdg-open")))
 '(ag-context-lines 4)
 '(ag-highlight-search t)
 '(ag-reuse-buffers t)
 '(comment-empty-lines 'eol)
 '(comment-multi-line t)
 '(custom-enabled-themes '(gruvbox-dark-hard))
 '(custom-safe-themes t)
 '(eglot-java-eglot-server-programs-manual-updates t)
 '(eglot-java-server-install-dir "/usr/local/share/jdtls")
 '(electric-pair-pairs '((34 . 34) (8216 . 8217) (8220 . 8221) (96 . 96)))
 '(electric-pair-skip-whitespace-chars '(32 9 10))
 '(electric-pair-text-pairs '((34 . 34) (8216 . 8217) (8220 . 8221) (96 . 96)))
 '(ezimage-use-images nil)
 '(flycheck-checker-error-threshold 5000)
 '(flycheck-checkers
      '(ada-gnat asciidoctor asciidoc awk-gawk bazel-build-buildifier bazel-module-buildifier bazel-starlark-buildifier bazel-workspace-buildifier c/c++-clang c/c++-gcc c/c++-cppcheck cfengine coffee coffee-coffeelint css-csslint css-stylelint cuda-nvcc cwl d-dmd dockerfile-hadolint elixir-credo emacs-lisp emacs-lisp-checkdoc ember-template erlang-rebar3 erlang eruby-erubis eruby-ruumba fortran-gfortran go-gofmt go-vet go-build go-test go-errcheck go-unconvert go-staticcheck groovy haml haml-lint handlebars haskell-stack-ghc haskell-ghc haskell-hlint html-tidy javascript-eslint javascript-jshint javascript-standard json-jsonlint json-python-json json-jq jsonnet less less-stylelint llvm-llc lua-luacheck lua markdown-markdownlint-cli markdown-mdl markdown-pymarkdown nix nix-linter opam perl perl-perlcritic perl-perlimports php php-phpmd php-phpcs php-phpcs-changed processing proselint protobuf-protoc protobuf-prototool pug puppet-parser puppet-lint python-ruff python-pycompile python-pyright python-mypy r-lintr r racket rpm-rpmlint rst-sphinx rst ruby-rubocop ruby-chef-cookstyle ruby-standard ruby-reek ruby ruby-jruby rust-cargo rust rust-clippy salt-lint scala scala-scalastyle scheme-chicken scss-lint sass-stylelint scss-stylelint sass/scss-sass-lint sass scss sh-bash sh-posix-dash sh-posix-bash sh-zsh sh-shellcheck slim slim-lint sql-sqlint statix systemd-analyze tcl-nagelfar terraform terraform-tflint tex-chktex tex-lacheck texinfo textlint typescript-tslint verilog-verilator vhdl-ghdl xml-xmlstarlet xml-xmllint yaml-actionlint yaml-jsyaml yaml-ruby yaml-yamllint))
 '(flycheck-flake8rc "~/.flake8rc")
 '(flycheck-indication-mode 'left-margin)
 '(flycheck-locate-config-file-functions
      '(flycheck-locate-config-file-home flycheck-locate-config-file-ancestor-directories flycheck-locate-config-file-by-path))
 '(flycheck-python-ruff-executable "/usr/local/bin/ruff")
 '(gdb-many-windows t)
 '(indent-tabs-mode nil)
 '(ispell-dictionary nil)
 '(js-indent-level 2)
 '(openwith-associations
      '(("\\.pdf\\'" "zathura"
            (file))
           ("\\.png\\'" "qimgv"
               (file))
           ("\\.\\(?:pdf|ps|dvi\\)\\'" "zathura"
               (file))
           ("\\.\\(?:mp3|mp4|mpe?g\\|avi\\|wmv\\)\\'" "mpv"
               (file))
           ("\\.\\(?:jpe?g\\|png|gif|tif|bmp|xbm|pbm|pgm|ppm|pnm\\)\\'" "qimgv"
               (file))))
 '(package-selected-packages
      '(eglot-java jinja2-mode ini-mode json-reformat json-mode python-isort isearch-project ag forge crdt rust-mode systemd openwith xclip gruvbox-theme dockerfile-mode lsp-mode sqlite3 highlight-function-calls hl-block-mode magit-todos diff-hl emacsql-sqlite graphviz-dot-mode cmake-mode subed pdf-tools dap-mode django-commands company-auctex company-reftex company-shell company ac-c-headers ac-clang ac-rtags auto-complete auto-complete-c-headers sr-speedbar mermaid-mode aircon-theme iodine-theme twilight-theme one-themes twilight-bright-theme realgud realgud-ipdb realgud-lldb realgud-node-debug realgud-node-inspect editorconfig editorconfig-charset-extras editorconfig-custom-majormode editorconfig-domain-specific editorconfig-generate groovy-mode jenkinsfile-mode company-rtags disaster ecb flycheck-projectile flycheck-rtags helm helm-ag helm-flycheck helm-projectile helm-rtags projectile projectile-git-autofetch rtags srefactor smart-tabs-mode plantuml-mode magit auctex-lua company-lua flymake-lua lua-mode idle-highlight-mode use-package))
 '(plantuml-default-exec-mode 'jar)
 '(plantuml-executable-args '("-charset" "UTF-8" "-tsvg"))
 '(plantuml-indent-level 2)
 '(plantuml-jar-args '("-charset" "UTF-8" "-tpng"))
 '(plantuml-java-args '("-Djava.awt.headless=true" "-jar"))
 '(python-shell-interpreter "ipython3")
 '(python-shell-interpreter-args "-i --simple-prompt")
 '(rst-compile-toolsets '((html "rst2html" ".html" nil) (pdf "rst2pdf" ".pdf" nil)))
 '(split-height-threshold nil)
 '(split-width-threshold 160)
 '(treemacs-RET-actions-config
      '((root-node-open . treemacs-toggle-node)
           (root-node-closed . treemacs-toggle-node)
           (dir-node-open . treemacs-toggle-node)
           (dir-node-closed . treemacs-toggle-node)
           (file-node-open . treemacs-visit-node-default)
           (file-node-closed . treemacs-visit-node-default)
           (tag-node-open . treemacs-toggle-node-prefer-tag-visit)
           (tag-node-closed . treemacs-toggle-node-prefer-tag-visit)
           (tag-node . treemacs-visit-node-default)))
 '(treemacs-filewatch-mode t)
 '(warning-suppress-log-types '((comp) (use-package) (emacsql)))
 '(warning-suppress-types '((emacsql))))

(global-set-key (kbd "C-M-<left>")  'windmove-left)
(global-set-key (kbd "C-M-<right>") 'windmove-right)
(global-set-key (kbd "C-M-<up>")    'windmove-up)
(global-set-key (kbd "C-M-<down>")  'windmove-down)

;;; DevHelp sur le mot via <f7>
(defun devhelp-word-at-point ()
  "Cherche dans DevHelp le mot courant sous le curseur."
  (interactive)
  (start-process-shell-command "devhelp" nil (concat "devhelp" " -s " (current-word)))
  (set-process-query-on-exit-flag (get-process "devhelp") nil)
  )
(global-set-key (kbd "<f7>") 'devhelp-word-at-point)

;;; Whitespace
(global-set-key (kbd "RET") 'newline-and-indent)
(global-set-key (kbd "C-c w") 'whitespace-mode)
(global-set-key (kbd "C-c t") 'whitespace-toggle-options)

;;; Comments
(global-set-key (kbd "C-M-;") 'uncomment-region)

;;; Duplicate line with C-d
(defun duplicate-line-or-region (&optional n)
  "Duplicate current line, or region if active.
    With argument N, make N copies.
    With negative N, comment out original line and use the absolute value."
  (interactive "*p")
  (let ((use-region (use-region-p)))
    (save-excursion
      (let ((text (if use-region        ;Get region if active, otherwise line
                      (buffer-substring (region-beginning) (region-end))
                    (prog1 (thing-at-point 'line)
                      (end-of-line)
                      (if (< 0 (forward-line 1)) ;Go to beginning of next line, or make a new one
                          (newline)
                        )
                      )
                    )
                  )
            )
        (dotimes (i (abs (or n 1)))     ;Insert N times, or once if not specified
          (insert text)
          )
        )
      )
    (if use-region nil                  ;Only if we're working with a line (not a region)
      (let ((pos (- (point) (line-beginning-position)))) ;Save column
        (if (> 0 n)                             ;Comment out original with negative arg
            (comment-region (line-beginning-position) (line-end-position)))
        (forward-line 1)
        (forward-char pos)
        )
      )
    )
  )
(global-set-key (kbd "C-d") 'duplicate-line-or-region)

(defun decrement-number-at-point ()
  (interactive)
  (skip-chars-backward "0-9")
  (or (looking-at "[0-9]+")
          (error "No number at point"))
  (replace-match (number-to-string (- (string-to-number (match-string 0)) 1))))
(defun increment-number-at-point ()
  (interactive)
  (skip-chars-backward "0-9")
  (or (looking-at "[0-9]+")
          (error "No number at point"))
  (replace-match (number-to-string (1+ (string-to-number (match-string 0))))))
(global-set-key (kbd "M-<left>") 'decrement-number-at-point)
(global-set-key (kbd "M-<right>") 'increment-number-at-point)

(add-hook 'c-mode-hook #'(lambda () (define-key c-mode-map (kbd "C-d") 'duplicate-line-or-region)))
(add-hook 'prog-mode-hook #'(lambda () (hs-minor-mode t)))
(global-set-key (kbd "M-[ [") 'hs-show-block)
(global-set-key (kbd "M-[ ]") 'hs-hide-block)
(global-set-key (kbd "M-[ {") 'hs-show-all)
(global-set-key (kbd "M-[ }") 'hs-hide-all)

(use-package json-mode)

(use-package lua-mode
    :config
    '(lua-indent-level 4))

;;; Eglot configuration
(use-package eglot
  :hook (
         (bash-mode . eglot-ensure)
         (bash-ts-mode . eglot-ensure)
         (c++-mode . eglot-ensure)
         (c-mode . eglot-ensure)
         (cmake-mode . eglot-ensure)
         (css-mode . eglot-ensure)
         (dockerfile-ts-mode . eglot-ensure)
         (html-mode . eglot-ensure)
         (java-mode . eglot-ensure)
         (js-jsx-mode . eglot-ensure)
         (js-mode . eglot-ensure)
         (json-mode . eglot-ensure)
         (lua-mode . eglot-ensure)
         (markdown-mode . eglot-ensure)
         (python-mode . eglot-ensure)
         (sh-mode . eglot-ensure)
         (typescript-mode . eglot-ensure)
         (web-mode . eglot-ensure)
         )
  :bind (
         ("C-c e f" . eglot-format)
         ("C-c e r" . eglot-rename)
         ("C-c e s" . sort-lines)
         ("C-c e e n" . flymake-goto-next-error)
         ("C-c e e p" . flymake-goto-prev-error)
         )
  )
(use-package eglot-java)

(provide 'init)
;;; init.el ends here


(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(default ((t (:inherit nil :extend nil :stipple nil :background "color-232" :foreground "brightwhite" :inverse-video nil :box nil :strike-through nil :overline nil :underline nil :slant normal :weight normal :height 1 :width normal :foundry "default" :family "default"))))
 '(eglot-highlight-symbol-face ((t (:inherit bold :background "color-94"))))
 '(line-number ((t (:background "color-235" :foreground "#767676"))))
 '(line-number-current-line ((t (:background "#4e4e4e" :foreground "#ff8700" :weight bold))))
 '(magit-diff-added ((t (:extend t :foreground "brightgreen"))))
 '(magit-diff-added-highlight ((t (:inherit (magit-diff-added magit-diff-context-highlight) :foreground "brightgreen"))))
 '(magit-diff-context ((t (:extend t :foreground "white"))))
 '(magit-diff-context-highlight ((t (:extend t :background "#3a3a3a" :foreground "white"))))
 '(magit-diff-file-heading ((t (:extend t :background "white" :foreground "black" :weight bold))))
 '(magit-diff-file-heading-highlight ((t (:inherit magit-diff-file-heading :extend t :background "brightblack"))))
 '(magit-diff-hunk-region ((t (:inherit bold :extend t :background "black" :slant italic))))
 '(mode-line ((t (:background "color-178" :foreground "color-232" :box nil))))
 '(mode-line-inactive ((t (:background "color-94" :foreground "color-252" :box nil))))
 '(region ((t (:extend t :background "color-234")))))
(put 'magit-diff-edit-hunk-commit 'disabled nil)
