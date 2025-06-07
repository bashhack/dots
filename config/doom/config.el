;;; $DOOMDIR/config.el -*- lexical-binding: t; -*-

;; Place your private configuration here! Remember, you do not need to run 'doom
;; sync' after modifying this file!


;; Some functionality uses this to identify you, e.g. GPG configuration, email
;; clients, file templates and snippets. It is optional.
;; Load personal info from auth-sources
(require 'auth-source)

(defun my/get-personal-info (field)
  "Get personal info from auth-sources."
  (let ((auth (car (auth-source-search :host "personal.info" :user field :require '(:secret)))))
    (if auth
        (funcall (plist-get auth :secret))
      "")))

(setq user-full-name (my/get-personal-info "fullname")
      user-mail-address (my/get-personal-info "email"))

;; Doom exposes five (optional) variables for controlling fonts in Doom:
;;
;; - `doom-font' -- the primary font to use
;; - `doom-variable-pitch-font' -- a non-monospace font (where applicable)
;; - `doom-big-font' -- used for `doom-big-font-mode'; use this for
;;   presentations or streaming.
;; - `doom-symbol-font' -- for symbols
;; - `doom-serif-font' -- for the `fixed-pitch-serif' face
;;
;; See 'C-h v doom-font' for documentation and more examples of what they
;; accept. For example:
;;
(setq doom-font (font-spec :family "JetBrains Mono" :size 12 :weight 'semi-light)
      doom-variable-pitch-font (font-spec :family "JetBrains Mono" :size 13))
;;
;; If you or Emacs can't find your font, use 'M-x describe-font' to look them
;; up, `M-x eval-region' to execute elisp code, and 'M-x doom/reload-font' to
;; refresh your font settings. If Emacs still can't find your font, it likely
;; wasn't installed correctly. Font issues are rarely Doom issues!

;; There are two ways to load a theme. Both assume the theme is installed and
;; available. You can either set `doom-theme' or manually load a theme with the
;; `load-theme' function. This is the default:
(setq doom-theme 'doom-gruvbox)

;; This determines the style of line numbers in effect. If set to `nil', line
;; numbers are disabled. For relative line numbers, set this to `relative'.
(setq display-line-numbers-type 'relative)

;; If you use `org' and don't want your org files in the default location below,
;; change `org-directory'. It must be set before org loads!
(setq org-directory (expand-file-name "Library/Mobile Documents/com~apple~CloudDocs/org" "~"))

(after! org
  (setq org-agenda-files
        (append org-agenda-files
                (list (expand-file-name "projects/work/" org-directory)
                      (expand-file-name "projects/personal/" org-directory)
                      (expand-file-name "projects/README.org" org-directory)))))

(with-eval-after-load 'org-capture
  (add-to-list 'org-capture-templates
               '("pw" "Work Project Item" entry
                 (file+headline (lambda () (expand-file-name "projects/work/index.org" org-directory)) "Ideas Inbox")
                 "* TODO %?\n  SCHEDULED: %t\n  %i"))

  (add-to-list 'org-capture-templates
               '("pp" "Personal Project Item" entry
                 (file+headline (lambda () (expand-file-name "projects/personal/index.org" org-directory)) "Ideas Inbox")
                 "* TODO %?\n  SCHEDULED: %t\n  %i")))

(with-eval-after-load 'org-agenda
  (add-to-list 'org-agenda-custom-commands
               '("W" "Work Projects"
                 ((agenda "" ((org-agenda-files (list (expand-file-name "projects/work/" org-directory)))))
                  (tags-todo "+work+TODO=\"NEXT\""))))

  (add-to-list 'org-agenda-custom-commands
               '("P" "Personal Projects"
                 ((agenda "" ((org-agenda-files (list (expand-file-name "projects/personal/" org-directory)))))
                  (tags-todo "+personal+TODO=\"NEXT\""))))

  (add-to-list 'org-agenda-custom-commands
               '("X" "All Projects Overview"
                 ((agenda "" ((org-agenda-span 7)))
                  (tags-todo "+project+TODO=\"NEXT\"")
                  (tags-todo "+project+TODO=\"WAITING\"")))))

(after! org
  (defun my/create-new-project (project-name project-type)
    "Create a new project from template"
    (interactive
     (list (read-string "Project name: ")
           (completing-read "Project type: " '("personal" "work"))))
    (let* ((safe-name (downcase (replace-regexp-in-string "[^a-zA-Z0-9]" "-" project-name)))
           (project-dir (expand-file-name (format "projects/%s/active/" project-type) org-directory))
           (project-file (expand-file-name (format "%s.org" safe-name) project-dir))
           (template-file (expand-file-name "projects/templates/project-template.org" org-directory))
           (index-file (expand-file-name (format "projects/%s/index.org" project-type) org-directory)))

      (copy-file template-file project-file)

      (find-file project-file)
      (goto-char (point-min))
      (while (re-search-forward "PROJECT_NAME" nil t)
        (replace-match project-name))
      (while (re-search-forward "TYPE" nil t)
        (replace-match project-type))
      (while (re-search-forward "STATUS" nil t)
        (replace-match "active"))
      (save-buffer)

      (find-file index-file)
      (goto-char (point-min))
      (when (re-search-forward "\\* Active Projects \\[/\\]" nil t)
        (forward-line 1)
        (insert (format "- [ ] [[file:active/%s.org][%s]]\n" safe-name project-name)))
      (save-buffer)

      (find-file project-file)
      (goto-char (point-min))
      (re-search-forward "\\*\\* Vision & Goals" nil t)
      (forward-line 1)))

  (defun my/add-dev-task ()
    "Add a development task to current project"
    (interactive)
    (let ((task-desc (read-string "Dev task: ")))
      (goto-char (point-min))
      (if (re-search-forward "\\*\\* Phase 1: Foundation" nil t)
          (progn
            (org-end-of-subtree)
            (insert (format "\n*** TODO %s\n    SCHEDULED: <%s>\n    :PROPERTIES:\n    :CATEGORY: dev\n    :END:"
                            task-desc
                            (format-time-string "%Y-%m-%d %a"))))
        (message "Couldn't find development phases section"))))

  (defun my/add-project-note ()
    "Add a quick note to current project"
    (interactive)
    (let ((note (read-string "Note: ")))
      (goto-char (point-min))
      (if (re-search-forward "\\* Research & Notes" nil t)
          (progn
            (org-end-of-subtree)
            (insert (format "\n** %s\n   %s\n"
                            (format-time-string "[%Y-%m-%d %H:%M]")
                            note)))
        (message "Couldn't find Research & Notes section"))))

  (defun my/add-project-idea ()
    "Add an idea to current project"
    (interactive)
    (let ((idea (read-string "Idea: ")))
      (goto-char (point-min))
      (if (re-search-forward "\\*\\* Phase 3: Advanced Features\\|\\* Research & Notes" nil t)
          (progn
            (forward-line 0)
            (insert (format "** SOMEDAY %s\n   Added: %s\n"
                            idea
                            (format-time-string "[%Y-%m-%d]"))))
        (message "Couldn't find a good place for ideas"))))

  (defun my/goto-project ()
    "Quickly jump to any project"
    (interactive)
    (let* ((project-files (directory-files-recursively
                           (expand-file-name "projects" org-directory) "\\.org$"))
           (project-names (mapcar (lambda (file)
                                    (cons (file-name-base file) file))
                                  (seq-filter (lambda (f)
                                                (not (string-match-p "index\\|template\\|README" f)))
                                              project-files)))
           (choice (completing-read "Project: " project-names)))
      (find-file (cdr (assoc choice project-names)))))

  (defun my/search-projects ()
    "Search all project files"
    (interactive)
    (let ((search-term (read-string "Search projects for: ")))
      (rgrep search-term "*.org" (expand-file-name "projects" org-directory))))

  (defun my/link-project-repo ()
    "Add GitHub/GitLab repo link to current project"
    (interactive)
    (let ((repo-url (read-string "Repository URL: ")))
      (save-excursion
        (goto-char (point-min))
        (if (re-search-forward "\\*\\* Repository" nil t)
            (progn
              (org-end-of-subtree)
              (insert (format "\n   [[%s][Project Repository]]\n" repo-url)))
          (when (re-search-forward "\\* Project Overview" nil t)
            (org-end-of-subtree)
            (insert (format "\n** Repository\n   [[%s][Project Repository]]\n" repo-url)))))))

  (defun my/clock-in-project ()
    "Clock into current project"
    (interactive)
    (save-excursion
      (goto-char (point-min))
      (if (re-search-forward "\\* Project Overview" nil t)
          (org-clock-in)
        (message "Couldn't find Project Overview section"))))

  (defun my/clock-out-project ()
    "Clock out of current project"
    (interactive)
    (if (org-clocking-p)
        (progn
          (org-clock-out)
          (message "Clocked out"))
      (message "No active clock")))

  (defun my/current-project ()
    "Show currently clocked project"
    (interactive)
    (if (org-clocking-p)
        (message "Current project: %s"
                 (with-current-buffer (marker-buffer org-clock-marker)
                   (save-excursion
                     (goto-char org-clock-marker)
                     (org-get-heading t t t t))))
      (message "No project clocked in")))

  (defun my/add-to-ideas-inbox ()
    "Add item to ideas inbox"
    (interactive)
    (let ((idea (read-string "Project idea: "))
          (type (completing-read "Type: " '("personal" "work"))))
      (find-file (expand-file-name (format "projects/%s/index.org" type) org-directory))
      (goto-char (point-min))
      (when (re-search-forward "\\* Ideas Inbox" nil t)
        (org-end-of-subtree)
        (insert (format "\n** TODO %s\n   [%s]\n"
                        idea
                        (format-time-string "%Y-%m-%d %a"))))
      (save-buffer)
      (message "Added '%s' to %s ideas inbox" idea type)))

  (defun my/add-to-planning-queue ()
    "Add item to planning queue"
    (interactive)
    (let ((idea (read-string "Future project idea: "))
          (type (completing-read "Type: " '("personal" "work"))))
      (find-file (expand-file-name (format "projects/%s/index.org" type) org-directory))
      (goto-char (point-min))
      (when (re-search-forward "\\* Planning Queue" nil t)
        (org-end-of-subtree)
        (insert (format "\n** SOMEDAY %s\n   Added: %s\n"
                        idea
                        (format-time-string "[%Y-%m-%d]"))))
      (save-buffer)
      (message "Added '%s' to %s planning queue" idea type)))

  (defun my/open-work-index ()
    "Open work projects index"
    (interactive)
    (find-file (expand-file-name "projects/work/index.org" org-directory)))

  (defun my/open-personal-index ()
    "Open personal projects index"
    (interactive)
    (find-file (expand-file-name "projects/personal/index.org" org-directory))))

;; Project keybindings (need to be outside after! org block)
(map! :leader
      (:prefix ("n p" . "projects")
       :desc "Create new project" "n" #'my/create-new-project
       :desc "Add dev task" "t" #'my/add-dev-task
       :desc "Add note" "N" #'my/add-project-note
       :desc "Add idea" "i" #'my/add-project-idea
       :desc "Work projects agenda" "w" (lambda () (interactive) (org-agenda nil "W"))
       :desc "Personal projects agenda" "p" (lambda () (interactive) (org-agenda nil "P"))
       :desc "All projects overview" "a" (lambda () (interactive) (org-agenda nil "X"))
       :desc "Jump to project" "j" #'my/goto-project
       :desc "Search projects" "s" #'my/search-projects
       :desc "Link repository" "r" #'my/link-project-repo
       :desc "Clock in" "c" #'my/clock-in-project
       :desc "Clock out" "C" #'my/clock-out-project
       :desc "Current project" "." #'my/current-project
       :desc "Add to ideas inbox" "I" #'my/add-to-ideas-inbox
       :desc "Add to planning queue" "Q" #'my/add-to-planning-queue
       :desc "Open work index" "W" #'my/open-work-index
       :desc "Open personal index" "P" #'my/open-personal-index))

;; Whenever you reconfigure a package, make sure to wrap your config in an
;; `after!' block, otherwise Doom's defaults may override your settings. E.g.
;;
;;   (after! PACKAGE
;;     (setq x y))
;;
;; The exceptions to this rule:
;;
;;   - Setting file/directory variables (like `org-directory')
;;   - Setting variables which explicitly tell you to set them before their
;;     package is loaded (see 'C-h v VARIABLE' to look up their documentation).
;;   - Setting doom variables (which start with 'doom-' or '+').
;;
;; Here are some additional functions/macros that will help you configure Doom.
;;
;; - `load!' for loading external *.el files relative to this one
;; - `use-package!' for configuring packages
;; - `after!' for running code after a package has loaded
;; - `add-load-path!' for adding directories to the `load-path', relative to
;;   this file. Emacs searches the `load-path' when you load packages with
;;   `require' or `use-package'.
;; - `map!' for binding new keys
;;
;; To get information about any of these functions/macros, move the cursor over
;; the highlighted symbol at press 'K' (non-evil users must press 'C-c c k').
;; This will open documentation for it, including demos of how they are used.
;; Alternatively, use `C-h o' to look up a symbol (functions, variables, faces,
;; etc).
;;
;; You can also try 'gd' (or 'C-c c d') to jump to their definition and see how
;; they are implemented.

(add-to-list 'initial-frame-alist '(fullscreen . maximized))

(map! :leader
      :desc "FuZzily find File in home"
      "f z f" (cmd!! #'affe-find "~/"))

(map! :leader
      :desc "FuZzily find File in this Dir"
      "f z d" (cmd!! #'affe-find))

;; DOOM!!!
(setq fancy-splash-image "/Users/marcalvarez/Pictures/doom-emacs-color2.png")

;; Just a little transparency
(set-frame-parameter (selected-frame) 'alpha '(90 . 90)) (add-to-list 'default-frame-alist '(alpha . (90 . 90)))

(setq auth-sources '("~/.authinfo"))
;; (setq auth-sources '("~/.authinfo.gpg"))

;; ** Keybindings To Open Dired

;; | COMMAND    | DESCRIPTION                        | KEYBINDING |
;; |------------+------------------------------------+------------|
;; | dired      | /Open dired file manager/            | SPC d d    |
;; | dired-jump | /Jump to current directory in dired/ | SPC d j    |

;; ** Keybindings Within Dired
;; *** Basic dired commands

;; | COMMAND                | DESCRIPTION                                 | KEYBINDING |
;; |------------------------+---------------------------------------------+------------|
;; | dired-view-file        | /View file in dired/                          | SPC d v    |
;; | dired-up-directory     | /Go up in directory tree/                     | h          |
;; | dired-find-file        | /Go down in directory tree (or open if file)/ | l          |
;; | dired-next-line        | /Move down to next line/                      | j          |
;; | dired-previous-line    | /Move up to previous line/                    | k          |
;; | dired-mark             | /Mark file at point/                          | m          |
;; | dired-unmark           | /Unmark file at point/                        | u          |
;; | dired-do-copy          | /Copy current file or marked files/           | C          |
;; | dired-do-rename        | /Rename current file or marked files/         | R          |
;; | dired-hide-details     | /Toggle detailed listings on/off/             | (          |
;;                                                                                       | dired-git-info-mode    | /Toggle git information on/off/               | )          |
;; | dired-create-directory | /Create new empty directory/                  | +          |
;; | dired-diff             | /Compare file at point with another/          | =          |
;; | dired-subtree-toggle   | /Toggle viewing subtree at point/             | TAB        |

;; *** Dired commands using regex

;; | COMMAND                 | DESCRIPTION                | KEYBINDING |
;; |-------------------------+----------------------------+------------|
;; | dired-mark-files-regexp | /Mark files using regex/     | % m        |
;; | dired-do-copy-regexp    | /Copy files using regex/     | % C        |
;; | dired-do-rename-regexp  | /Rename files using regex/   | % R        |
;; | dired-mark-files-regexp | /Mark all files using regex/ | * %        |

;; *** File permissions and ownership

;; | COMMAND         | DESCRIPTION                      | KEYBINDING |
;; |-----------------+----------------------------------+------------|
;; | dired-do-chgrp  | /Change the group of marked files/ | g G        |
;; | dired-do-chmod  | /Change the mode of marked files/  | M          |
;; | dired-do-chown  | /Change the owner of marked files/ | O          |
;; | dired-do-rename | /Rename file or all marked files/  | R          |
(map! :leader
      (:prefix ("d" . "dired")
       :desc "Open dired" "d" #'dired
       :desc "Dired jump to current" "j" #'dired-jump)
      (:after dired
              (:map dired-mode-map
               :desc "Peep-dired image previews" "d p" #'peep-dired
               :desc "Dired view file"           "d v" #'dired-view-file)))

(evil-define-key 'normal dired-mode-map
  (kbd "M-RET") 'dired-display-file
  (kbd "h") 'dired-up-directory
  (kbd "l") 'dired-find-file
  (kbd "m") 'dired-mark
  (kbd "t") 'dired-toggle-marks
  (kbd "u") 'dired-unmark
  (kbd "C") 'dired-do-copy
  (kbd "D") 'dired-do-delete
  (kbd "J") 'dired-goto-file
  (kbd "M") 'dired-do-chmod
  (kbd "O") 'dired-do-chown
  (kbd "P") 'dired-do-print
  (kbd "R") 'dired-do-rename
  (kbd "T") 'dired-do-touch
  (kbd "Y") 'dired-copy-filenamecopy-filename-as-kill ; copies filename to kill ring.
  (kbd "Z") 'dired-do-compress
  (kbd "+") 'dired-create-directory
  (kbd "-") 'dired-do-kill-lines
  (kbd "% l") 'dired-downcase
  (kbd "% m") 'dired-mark-files-regexp
  (kbd "% u") 'dired-upcase
  (kbd "* %") 'dired-mark-files-regexp
  (kbd "* .") 'dired-mark-extension
  (kbd "* /") 'dired-mark-directories
  (kbd "; d") 'epa-dired-do-decrypt
  (kbd "; e") 'epa-dired-do-encrypt)
;; Get file icons in dired
;; With dired-open plugin, you can launch external programs for certain extensions
;; For example, I set all .png files to open in 'sxiv' and all .mp4 files to open in 'mpv'
(setq dired-open-extensions '(("gif" . "sxiv")
                              ("jpg" . "sxiv")
                              ("png" . "sxiv")
                              ("mkv" . "mpv")
                              ("mp4" . "mpv")))

;; ** Keybindings Within Dired With Peep-Dired-Mode Enabled
;; If peep-dired is enabled, you will get image previews as you go up/down with 'j' and 'k'

;; | COMMAND              | DESCRIPTION                              | KEYBINDING |
;; |----------------------+------------------------------------------+------------|
;; | peep-dired           | /Toggle previews within dired/             | SPC d p    |
;; | peep-dired-next-file | /Move to next file in peep-dired-mode/     | j          |
;; | peep-dired-prev-file | /Move to previous file in peep-dired-mode/ | k          |
(evil-define-key 'normal peep-dired-mode-map
  (kbd "j") 'peep-dired-next-file
  (kbd "k") 'peep-dired-prev-file)
(add-hook 'peep-dired-hook 'evil-normalize-keymaps)

;; Making deleted files go to trash can
(setq delete-by-moving-to-trash t
      trash-directory "~/.Trash/")

;; Common Lisp - Quicklisp
;; NOTE: Using Sly instead of SLIME, so commenting out slime-helper
;; (load (expand-file-name "~/.quicklisp/slime-helper.el"))
(setq inferior-lisp-program "sbcl")

;; C/C++
;; (after! lsp-clangd
;;   (setq lsp-clients-clangd-args
;;         '("-j=3"
;;           "--background-index"
;;           "--clang-tidy"
;;           "--completion-style=detailed"
;;           "--header-insertion=never"
;;           "--header-insertion-decorators=0"))
;;   (set-lsp-priority! 'clangd 2))
(after! ccls
  (setq ccls-initialization-options '(:index (:comments 2) :completion (:detailedLabel t)))
  (set-lsp-priority! 'ccls 2)) ; optional as ccls is the default in Doom


;; Test if :type field matters
(after! dape
  ;; Find and update the existing dlv config
  (let ((dlv-config (assq 'dlv dape-configs)))
    (when dlv-config
      (setcdr dlv-config
              '(modes (go-mode go-ts-mode)
                ensure dape-ensure-command
                command "dlv"
                command-args ("dap" "--listen" "127.0.0.1::autoport")
                command-cwd dape-command-cwd
                command-insert-stderr t
                port :autoport
                :request "launch"
                :type "go"
                :mode "debug"
                :cwd "."
                :program ".")))))

;; GPTel
(use-package! gptel
  :config
  ;; Function to get API key from auth-sources
  (defun my/get-api-key (host)
    "Get API key for HOST from auth-sources."
    (let ((auth (car (auth-source-search :host host :user "apikey" :max 1))))
      (if (and auth (plist-get auth :secret))
          (funcall (plist-get auth :secret))
        nil)))
  
  ;; Set up GPTel with OpenAI
  (let ((openai-key (my/get-api-key "api.openai.com")))
    (setq! gptel-api-key (or openai-key "your-api-key")))
  
  (setq! gptel-org-convert-response t)
  (setq! gptel-response-separator "\n\n")
  
  ;; Create the Claude backend using API key from auth-sources
  (let ((anthropic-key (my/get-api-key "anthropic.com")))
    (when anthropic-key
      (setq! gptel-backend (gptel-make-anthropic "Claude"
                             :stream t
                             :key anthropic-key))
      ;; Set a Claude model as the default
      (setq! gptel-model 'claude-3-7-sonnet-20250219))))
