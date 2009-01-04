
;; start emacs server
;(server-start)


(setq inhibit-splash-screen t)
(setq default-major-mode 'text-mode)
(column-number-mode)
(mouse-wheel-mode t)
(setq case-fold-search t)

;; set ido mode
(ido-mode t)
(setq ido-enable-flex-matching t) ; fuzzy matching is a must have

;; directory to put various el files into
(defvar home-dir (concat (expand-file-name "~") "/"))
(add-to-list 'load-path (concat home-dir ".site-lisp"))
(add-to-list 'load-path (concat home-dir ".site-lisp/color-theme-6.6.0"))

;; MODES/HELPERS

;; loads diff mode when git commit file loaded
(setq auto-mode-alist  (cons '("COMMIT_EDITMSG" . diff-mode) auto-mode-alist))
;; loads html mode when erb file load
(setq auto-mode-alist  (cons '(".html\.erb$" . html-mode) auto-mode-alist))

;; loads ruby mode when a .rb file is opened.
(autoload 'ruby-mode "ruby-mode" "Major mode for editing ruby scripts." t)
(setq auto-mode-alist  (cons '(".\.rb$" . ruby-mode) auto-mode-alist))
(setq auto-mode-alist  (cons '(".rhtml$" . html-mode) auto-mode-alist))
(setq auto-mode-alist  (cons '(".rake$" . ruby-mode) auto-mode-alist))
;; haml mode
(require 'haml-mode nil 't)
(add-to-list 'auto-mode-alist '("\\.haml$" . haml-mode))
;; sass mode
(require 'sass-mode nil 't)
(add-to-list 'auto-mode-alist '("\\.sass$" . sass-mode))
;; js mode
(add-to-list 'auto-mode-alist '("\\.js\\'" . javascript-mode))
(autoload 'javascript-mode "javascript" nil t)
;; css mode
(autoload 'css-mode "css-mode-simple" nil t)
(add-to-list 'auto-mode-alist '(".css$" . css-mode))
;; yaml mode
(require 'yaml-mode)
(add-to-list 'auto-mode-alist '("\\.yml$" . yaml-mode))
;; Rinari (rails helpers)
;(add-to-list 'load-path (concat home-dir ".site-lisp/rinari"))
;(require 'rinari)
;; magit
(add-to-list 'load-path (concat home-dir ".site-lisp/magit"))
(require 'magit)
;; yasnippet
;(add-to-list 'load-path (concat home-dir ".site-lisp/yasnippet-0.5.7"))
(require 'yasnippet)
(yas/initialize)
(yas/load-directory (concat home-dir ".site-lisp/snippets"))

;; KEY BINDINGS


;; Translate C-h to DEL
(keyboard-translate ?\C-h ?\C-?)
;; Define M-h to help  ---  please don't add an extra ' after help!
(global-set-key "\M-h" 'help)


;; BACKUP FILES

;; From http://snarfed.org/space/gnu%20emacs%20backup%20files
;; Put autosave files (ie #foo#) in one place, *not*
;; scattered all over the file system!
(defvar autosave-dir
 (concat "/tmp/emacs_autosaves/" (user-login-name) "/"))

(make-directory autosave-dir t)

(defun auto-save-file-name-p (filename)
  (string-match "^#.*#$" (file-name-nondirectory filename)))

(defun make-auto-save-file-name ()
  (concat autosave-dir
   (if buffer-file-name
      (concat "#" (file-name-nondirectory buffer-file-name) "#")
    (expand-file-name
     (concat "#%" (buffer-name) "#")))))

;; Put backup files (ie foo~) in one place too. (The backup-directory-alist
;; list contains regexp=>directory mappings; filenames matching a regexp are
;; backed up in the corresponding directory. Emacs will mkdir it if necessary.)
(defvar backup-dir (concat "/tmp/emacs_backups/" (user-login-name) "/"))
(setq backup-directory-alist (list (cons "." backup-dir)))

;;; enables outlining for ruby
;;; You may also want to bind hide-body, hide-subtree, show-substree,
;;; show-all, show-children, ... to some keys easy folding and unfolding
(add-hook 'ruby-mode-hook
              '(lambda ()
                 (outline-minor-mode)
                 (setq outline-regexp " *\\(def \\|class\\|module\\)")))
(setq-default outline-minor-mode-prefix  "\C-c") 

;; load color themes
(require 'color-theme)
(color-theme-initialize)
(setq color-theme-is-global t)
(load-file (concat home-dir ".site-lisp/zenburn.el"))
(load-file (concat home-dir ".site-lisp/twilight.el"))
(color-theme-twilight)

;; add func to simulate txtmate apple-t
(require 'filecache)
(defun rails-add-proj-to-file-cache (dir)
  "Adds all the ruby and rhtml files recursively in the current directory to the file-cache"
  (interactive "DAdd directory: ")
    (file-cache-clear-cache)
    (file-cache-add-directory-recursively 
     dir (regexp-opt (list ".rb" ".rhtml" ".xml" ".js" ".yml" ".haml" ".sass" ".css")))
    (file-cache-delete-file-regexp "\\.svn"))

(defun run-current-file ()
  "Execute or compile the current file.
For example, if the current buffer is the file x.pl,
then it'll call “perl x.pl” in a shell.
The file can be php, perl, python, bash, java.
File suffix is used to determine what program to run."
(interactive)
  (let (ext-map file-name file-ext prog-name cmd-str)
; get the file name
; get the program name
; run it
    (setq ext-map
          '(
            ("php" . "php")
            ("pl" . "perl")
            ("py" . "python")
            ("sh" . "bash")
            ("java" . "javac")
            ("rb" . "ruby")
            )
          )
    (setq file-name (buffer-file-name))
    (setq file-ext (file-name-extension file-name))
    (setq prog-name (cdr (assoc file-ext ext-map)))
    (setq cmd-str (concat prog-name " " file-name))
    (shell-command cmd-str)))
(global-set-key (kbd "<f7>") 'run-current-file)
(custom-set-variables
  ;; custom-set-variables was added by Custom.
  ;; If you edit it by hand, you could mess it up, so be careful.
  ;; Your init file should contain only one such instance.
  ;; If there is more than one, they won't work right.
 '(column-number-mode t)
 '(fringe-mode 0 nil (fringe))
 '(paren-match-face (quote paren-face-match-light))
 '(paren-sexp-mode t)
 '(transient-mark-mode t))
(custom-set-faces
  ;; custom-set-faces was added by Custom.
  ;; If you edit it by hand, you could mess it up, so be careful.
  ;; Your init file should contain only one such instance.
  ;; If there is more than one, they won't work right.
 )


;;__________________________________________________________________________
;;;;    Programming - Clojure
;; closure mode
(add-to-list 'load-path (concat home-dir "/projects/resources/clojure/clojure-mode"))
(setq inferior-lisp-program "~/bin/clj")
(require 'clojure-auto)

;;; (defvar clj-root (concat (expand-file-name "~") "/projects/resources/clojure/"))
;;; (setq load-path (append (list (concat clj-root "slime")
;;; 			      (concat clj-root "slime/contrib")
;;; 			      (concat clj-root "clojure-mode")
;;; 			      (concat clj-root "swank-clojure"))
;;; 			load-path))

;;; ;; Clojure mode
;;; (require 'clojure-auto)
;;; ;; (require 'clojure-paredit) ; Uncomment if you use Paredit
 
;;; ;; Slime
;;; (require 'slime)
;;; (slime-setup)
 
;;; ;; clojure swank
;;; (setq swank-clojure-jar-path (concat clj-root "/clojure/trunk/clojure.jar"))
;;; ;alternatively, you can set up the clojure wrapper script and use that: 
;;; ;(setq swank-clojure-binary "/path/to/cljwrapper")
 
;;; ; you can also set up extra classpaths, such as the classes/ directory used by AOT compilation
;;; ;(setq swank-clojure-extra-classpaths (list "/path/to/extra/classpaths" "/even/more/classpaths"))
 
;;; (require 'swank-clojure-autoload)
 
;;; ;; is this required? I don't have this in my emacs configuration; I just execute M-x slime to start slime -- Chousuke 
;;; (defun run-clojure ()
;;;   "Starts clojure in Slime"
;;;   (interactive)
;;;   (slime 'clojure))

;;; (global-set-key [f5] 'slime-eval-buffer)