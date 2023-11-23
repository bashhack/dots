;;; $DOOMDIR/config.el -*- lexical-binding: t; -*-

;; Place your private configuration here! Remember, you do not need to run 'doom
;; sync' after modifying this file!


;; Some functionality uses this to identify you, e.g. GPG configuration, email
;; clients, file templates and snippets. It is optional.
(setq user-full-name "Marc Alvarez"
      user-mail-address "marcalvarez@fastmail.com")

;; Doom exposes five (optional) variables for controlling fonts in Doom:
;;
;; - `doom-font' -- the primary font to use
;; - `doom-variable-pitch-font' -- a non-monospace font (where applicable)
;; - `doom-big-font' -- used for `doom-big-font-mode'; use this for
;;   presentations or streaming.
;; - `doom-unicode-font' -- for unicode glyphs
;; - `doom-serif-font' -- for the `fixed-pitch-serif' face
;;
;; See 'C-h v doom-font' for documentation and more examples of what they
;; accept. For example:
;;
;;(setq doom-font (font-spec :family "Fira Code" :size 12 :weight 'semi-light)
;;      doom-variable-pitch-font (font-spec :family "Fira Sans" :size 13))
;;
;; If you or Emacs can't find your font, use 'M-x describe-font' to look them
;; up, `M-x eval-region' to execute elisp code, and 'M-x doom/reload-font' to
;; refresh your font settings. If Emacs still can't find your font, it likely
;; wasn't installed correctly. Font issues are rarely Doom issues!

;; There are two ways to load a theme. Both assume the theme is installed and
;; available. You can either set `doom-theme' or manually load a theme with the
;; `load-theme' function. This is the default:
;; (setq doom-theme 'modus-vivendi)
(setq doom-theme 'doom-gruvbox)

;; This determines the style of line numbers in effect. If set to `nil', line
;; numbers are disabled. For relative line numbers, set this to `relative'.
(setq display-line-numbers-type 'relative)

;; If you use `org' and don't want your org files in the default location below,
;; change `org-directory'. It must be set before org loads!
(setq org-directory "~/iCloud/org/")


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

;; (add-to-list 'initial-frame-alist '(fullscreen . maximized))

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

(use-package! copilot
  :hook (prog-mode . copilot-mode)
  :bind (:map copilot-completion-map
              ("<tab>" . 'copilot-accept-completion)
              ("TAB" . 'copilot-accept-completion)
              ("C-TAB" . 'copilot-accept-completion-by-word)
              ("C-<tab>" . 'copilot-accept-completion-by-word)))

(setq auth-sources '("~/.authinfo.gpg"))


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
