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
                  (tags-todo "+work+TODO=\"DOING\""))))

  (add-to-list 'org-agenda-custom-commands
               '("P" "Personal Projects"
                 ((agenda "" ((org-agenda-files (list (expand-file-name "projects/personal/" org-directory)))))
                  (tags-todo "+personal+TODO=\"DOING\""))))

  (add-to-list 'org-agenda-custom-commands
               '("X" "All Projects Overview"
                 ((agenda "" ((org-agenda-span 7)))
                  (tags-todo "+project+TODO=\"DOING\"")
                  (tags-todo "+project+TODO=\"BLOCKED\"")))))

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

  (defun my/add-todo-task ()
    "Add a task to project's To Do section"
    (interactive)
    (let ((task-desc (read-string "Task: "))
          (type (completing-read "Type: " '("TODO" "BUG" "QUICK"))))
      (goto-char (point-min))
      (if (re-search-forward "\\*\\* To Do / Ready" nil t)
          (progn
            (org-end-of-subtree)
            (insert (format "\n*** %s %s\n    SCHEDULED: <%s>\n"
                            type
                            task-desc
                            (format-time-string "%Y-%m-%d %a"))))
        (message "Couldn't find To Do / Ready section"))))

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
    (let ((idea (read-string "Idea: "))
          (type (completing-read "Type: " '("EXPLORE" "MAYBE" "NO"))))
      (goto-char (point-min))
      (if (re-search-forward "\\*\\* Ideas / Backlog" nil t)
          (progn
            (org-end-of-subtree)
            (insert (format "\n*** %s %s\n    Added: %s\n"
                            type
                            idea
                            (format-time-string "[%Y-%m-%d]"))))
        (message "Couldn't find Ideas / Backlog section"))))

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

  (defun my/add-to-capture ()
    "Add item to capture bin"
    (interactive)
    (let ((idea (read-string "Capture: "))
          (type (completing-read "Type: " '("personal" "work"))))
      (find-file (expand-file-name (format "projects/%s/index.org" type) org-directory))
      (goto-char (point-min))
      (when (re-search-forward "\\* 📥 Capture" nil t)
        (org-end-of-subtree)
        (insert (format "\n** CAPTURE %s\n   [%s]\n"
                        idea
                        (format-time-string "%Y-%m-%d %a"))))
      (save-buffer)
      (message "Captured '%s' to %s index" idea type)))

  (defun my/guided-capture ()
    "Guided capture with templates"
    (interactive)
    (let* ((capture-type (completing-read "What are you capturing? "
                                          '("Project idea"
                                            "Bug/Issue"
                                            "Feature request"
                                            "Research topic"
                                            "Quick thought"
                                            "Question to explore")))
           (area (completing-read "Area: " '("personal" "work")))
           (title (read-string
                   (pcase capture-type
                     ("Project idea" "Project name: ")
                     ("Bug/Issue" "Bug description: ")
                     ("Feature request" "Feature: ")
                     ("Research topic" "Topic: ")
                     ("Quick thought" "Thought: ")
                     ("Question to explore" "Question: "))))
           (details (when (y-or-n-p "Add details? ")
                      (read-string "Details: ")))
           (related-project (when (y-or-n-p "Related to existing project? ")
                              (let* ((project-files (directory-files-recursively
                                                     (expand-file-name "projects" org-directory)
                                                     "active.*\\.org$"))
                                     (project-names (mapcar #'file-name-base project-files)))
                                (completing-read "Project: " project-names)))))
      ;; Build the capture entry
      (find-file (expand-file-name (format "projects/%s/index.org" area) org-directory))
      (goto-char (point-min))
      (when (re-search-forward "\\* 📥 Capture" nil t)
        (org-end-of-subtree)
        (let ((type-tag (pcase capture-type
                          ("Project idea" "PROJECT")
                          ("Bug/Issue" "BUG")
                          ("Feature request" "FEATURE")
                          ("Research topic" "RESEARCH")
                          ("Quick thought" "THOUGHT")
                          ("Question to explore" "QUESTION"))))
          (insert (format "\n** CAPTURE [%s] %s\n   [%s]\n"
                          type-tag
                          title
                          (format-time-string "%Y-%m-%d %a")))
          (when details
            (insert (format "   Details: %s\n" details)))
          (when related-project
            (insert (format "   Related: [[file:active/%s.org][%s]]\n"
                            related-project (upcase related-project))))))
      (save-buffer)
      (message "✓ Captured to %s index!" area)))

  (defun my/quick-capture-menu ()
    "Quick capture menu with common templates"
    (interactive)
    (let ((choice (read-char-choice
                   (concat "Quick capture:\n"
                           "  [i] Idea\n"
                           "  [b] Bug\n"
                           "  [f] Feature\n"
                           "  [q] Question\n"
                           "  [t] Task\n"
                           "  [n] Note\n"
                           "  [x] Cancel\n"
                           "Choice: ")
                   '(?i ?b ?f ?q ?t ?n ?x))))
      (unless (eq choice ?x)
        (let* ((area (completing-read "Area: " '("personal" "work")))
               (content (read-string
                         (pcase choice
                           (?i "Idea: ")
                           (?b "Bug: ")
                           (?f "Feature: ")
                           (?q "Question: ")
                           (?t "Task: ")
                           (?n "Note: ")))))
          (find-file (expand-file-name (format "projects/%s/index.org" area) org-directory))
          (goto-char (point-min))
          (when (re-search-forward "\\* 📥 Capture" nil t)
            (org-end-of-subtree)
            (insert (format "\n** CAPTURE [%s] %s\n   [%s]\n"
                            (pcase choice
                              (?i "IDEA")
                              (?b "BUG")
                              (?f "FEATURE")
                              (?q "QUESTION")
                              (?t "TASK")
                              (?n "NOTE"))
                            content
                            (format-time-string "%Y-%m-%d %a"))))
          (save-buffer)
          (message "✓ Captured!")))))

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
    (find-file (expand-file-name "projects/personal/index.org" org-directory)))

  (defun my/get-process-template (capture-type)
    "Get type-specific processing template"
    (pcase capture-type
      ("PROJECT"
       "\n   - Purpose: What problem does this solve?\n   - Target users: Who needs this?\n   - MVP scope: What's the smallest useful version?\n   - Estimated effort: Days/Weeks/Months?\n   - Decision: [ ] Create project  [ ] Add to existing  [ ] Reject\n   - Next: → ")
      ("BUG"
       "\n   - Severity: Critical/High/Medium/Low?\n   - Affected project: Which project?\n   - Root cause: What's broken?\n   - Fix approach: How to solve?\n   - Decision: [ ] Fix now  [ ] Schedule  [ ] Won't fix\n   - Next: → ")
      ("FEATURE"
       "\n   - Value: What benefit does this provide?\n   - Complexity: Simple/Medium/Complex?\n   - Dependencies: What's needed first?\n   - Target project: Where does this belong?\n   - Decision: [ ] Implement  [ ] Defer  [ ] Reject\n   - Next: → ")
      ("RESEARCH"
       "\n   - Goal: What do you want to learn?\n   - Application: How will you use this?\n   - Time needed: Hours/Days/Weeks?\n   - Resources: What do you need?\n   - Decision: [ ] Start research  [ ] Schedule  [ ] Skip\n   - Next: → ")
      ("QUESTION"
       "\n   - Core question: What exactly are you asking?\n   - Why important: Why does this matter?\n   - Who can help: Who has answers?\n   - Research needed: What to explore?\n   - Decision: [ ] Investigate  [ ] Ask someone  [ ] Let go\n   - Next: → ")
      (_
       "\n   - Purpose: Why does this matter?\n   - Context: What prompted this?\n   - Action needed: What should happen?\n   - Decision: [ ] Act on it  [ ] Delegate  [ ] Archive\n   - Next: → ")))

  (defun my/quick-process-decision ()
    "Make quick decision on current process item"
    (interactive)
    (when (org-at-heading-p)
      (let* ((heading (org-get-heading t t t t))
             (decision (completing-read
                        (format "Decision for '%s': " heading)
                        '("Create new project"
                          "Add to existing project"
                          "Schedule for later"
                          "Need more info"
                          "Reject - not aligned"
                          "Reject - too complex"
                          "Reject - already exists"))))
        (org-end-of-subtree t nil)
        (insert (format "\n   *** DECISION: %s [%s]\n"
                        decision
                        (format-time-string "%Y-%m-%d %H:%M")))
        (when (string-prefix-p "Create new project" decision)
          (call-interactively 'my/ready-for-action))
        (when (string-prefix-p "Add to existing" decision)
          (call-interactively 'my/ready-for-action))
        (when (string-prefix-p "Reject" decision)
          (org-todo "ARCHIVED")
          (message "Item rejected and archived.")))))

  (defun my/process-review-checklist ()
    "Show process review checklist"
    (interactive)
    (with-output-to-temp-buffer "*Process Review*"
      (princ "PROCESS REVIEW CHECKLIST\n")
      (princ "========================\n\n")
      (princ "For each item, ask:\n\n")
      (princ "1. Hell Yeah or No?\n")
      (princ "   □ Does this excite me?\n")
      (princ "   □ Is this the best use of my time?\n")
      (princ "   □ Will I regret NOT doing this?\n\n")
      (princ "2. Alignment Check\n")
      (princ "   □ Does this fit my current goals?\n")
      (princ "   □ Does this match my values?\n")
      (princ "   □ Is this moving me forward?\n\n")
      (princ "3. Reality Check\n")
      (princ "   □ Do I have time for this?\n")
      (princ "   □ Do I have the skills or can learn?\n")
      (princ "   □ Is this the right time?\n\n")
      (princ "4. Decision\n")
      (princ "   → If not \"Hell Yeah!\", it's a no\n")
      (princ "   → Be decisive, don't leave in limbo\n")
      (princ "   → Archive rejects for future reference\n"))
    (message "Review each process item with this checklist"))

  (defun my/project-help-menu ()
    "Show project management command reference"
    (interactive)
    (with-output-to-temp-buffer "*Project Commands Help*"
      (princ "PROJECT MANAGEMENT COMMANDS\n")
      (princ "===========================\n\n")
      (princ "All commands start with: SPC n p\n\n")

      (princ "CAPTURE & ADD\n")
      (princ "-------------\n")
      (princ "  q   Quick capture menu      [i]dea [b]ug [f]eature [q]uestion [t]ask [n]ote\n")
      (princ "  G   Guided capture          Capture with prompts for details\n")
      (princ "  I   Basic capture           Simple text → index capture bin\n")
      (princ "  i   Add idea                Add to current project backlog\n")
      (princ "  t   Add todo task           Add to current project ready\n")
      (princ "  N   Add note                Add to current project notes\n\n")

      (princ "INDEX WORKFLOW (x)\n")
      (princ "-----------------\n")
      (princ "  x p   Process capture       Capture → Process (adds template)\n")
      (princ "  x r   Ready for action      Process → Ready (new/existing project)\n")
      (princ "  x x   Execute ready item    Create project or add to existing\n")
      (princ "  x d   Quick decision        Make decision on process item\n")
      (princ "  x c   Review checklist      Show \"Hell Yeah or No\" checklist\n")
      (princ "  x b   Batch process         Process all captures at once\n\n")

      (princ "INDEX MOVEMENT COMMANDS (x m)\n")
      (princ "-----------------------------\n")
      (princ "Move items between sections in index files:\n")
      (princ "  x m c   Move to capture     Move item back to Capture section\n")
      (princ "  x m p   Move to process     Move item to Process section\n")
      (princ "  x m r   Move to ready       Move item to Ready for Action\n")
      (princ "  x m a   Archive item        Archive item (ARCHIVED state)\n\n")

      (princ "MOVE TASKS (m)\n")
      (princ "--------------\n")
      (princ "  m b   Move to backlog       → Ideas/Backlog (EXPLORE/MAYBE/NO)\n")
      (princ "  m t   Move to todo          → To Do/Ready (TODO/BUG/QUICK)\n")
      (princ "  m p   Move to progress      → In Progress (DOING/BLOCKED)\n")
      (princ "  m d   Move to done          → Done (DONE)\n\n")

      (princ "NAVIGATION & VIEWS\n")
      (princ "------------------\n")
      (princ "  j   Jump to project         Quick switch between projects\n")
      (princ "  n   Create new project      From template\n")
      (princ "  s   Search projects         Search all project files\n")
      (princ "  P   Personal index          Open personal projects index\n")
      (princ "  W   Work index              Open work projects index\n")
      (princ "  p   Personal agenda         View personal project tasks\n")
      (princ "  w   Work agenda             View work project tasks\n")
      (princ "  a   All projects            Combined view\n\n")

      (princ "TIME & MISC\n")
      (princ "-----------\n")
      (princ "  c   Clock in                Start time tracking\n")
      (princ "  C   Clock out               Stop time tracking\n")
      (princ "  .   Current project         Show clocked project\n")
      (princ "  r   Link repository         Add repo URL\n")
      (princ "  R   Weekly review           Start index review\n")
      (princ "  Q   Planning queue          Add future project idea\n\n")

      (princ "TASK STATES\n")
      (princ "-----------\n")
      (princ "Change state: C-c C-t (or SPC m t) then:\n")
      (princ "  e  EXPLORE    m  MAYBE      !  NO         t  TODO\n")
      (princ "  b  BUG        q  QUICK      g  DOING      k  BLOCKED\n")
      (princ "  d  DONE       c  CANCELLED\n\n")

      (princ "WORKFLOW: Capture → Process → Ready → Execute\n")
      (princ "Example: npq [i] → npxp → npxr → npxx\n"))
    (message "Project commands help displayed"))

  (defun my/batch-process-captures ()
    "Process all capture items in batch"
    (interactive)
    (let ((count 0))
      (save-excursion
        (goto-char (point-min))
        (when (re-search-forward "^\\* 📥 Capture" nil t)
          ;; Process items from bottom to top to avoid position issues
          (while (re-search-forward "^\\*\\* CAPTURE" nil t)
            (setq count (1+ count)))))
      (if (zerop count)
          (message "No capture items to process!")
        (when (y-or-n-p (format "Process %d capture items? " count))
          (dotimes (i count)
            (goto-char (point-min))
            (re-search-forward "^\\* 📥 Capture" nil t)
            (when (re-search-forward "^\\*\\* CAPTURE" nil t)
              (beginning-of-line)
              (my/process-capture-item)))
          (message "Batch processed %d items!" count)))))

  (defun my/process-capture-item ()
    "Move current item from Capture to Process section"
    (interactive)
    (when (org-at-heading-p)
      ;; Check if we're in the Capture section
      (let ((item-level (org-current-level))
            (item-start (point)))
        (save-excursion
          (outline-up-heading 1 t)
          (unless (looking-at "\\* 📥 Capture")
            (error "Not in Capture section!")))
        ;; Get the complete subtree content and extract type
        (org-back-to-heading t)
        (let* ((heading-start (point))
               (heading-text (org-get-heading t t t t))
               (capture-type (when (string-match "\\[\\([^]]+\\)\\]" heading-text)
                               (match-string 1 heading-text)))
               (subtree-end (save-excursion (org-end-of-subtree t t) (point)))
               (subtree-content (buffer-substring heading-start subtree-end)))
          ;; Replace CAPTURE with PROCESS in the content
          (setq subtree-content
                (replace-regexp-in-string "^\\(\\*+ \\)CAPTURE " "\\1PROCESS " subtree-content))
          ;; Delete the original
          (delete-region heading-start subtree-end)
          ;; Find Process section and insert
          (goto-char (point-min))
          (when (re-search-forward "^\\* 🔄 Process" nil t)
            (org-end-of-subtree t t)
            ;; Ensure proper spacing
            (unless (bolp) (insert "\n"))
            (insert subtree-content)
            ;; Add type-specific template
            (forward-line -1)
            (org-end-of-subtree t nil)
            (insert (my/get-process-template capture-type))
            (message "Moved to Process. Complete the evaluation template."))))))

  (defun my/ready-for-action ()
    "Move current item to Ready for Action"
    (interactive)
    (when (org-at-heading-p)
      ;; Check if we're in Process section
      (let ((item-level (org-current-level)))
        (save-excursion
          (outline-up-heading 1 t)
          (unless (looking-at "\\* 🔄 Process")
            (error "Not in Process section!")))
        ;; Get item details
        (org-back-to-heading t)
        (let* ((heading-start (point))
               (subtree-end (save-excursion (org-end-of-subtree t t) (point)))
               (subtree-content (buffer-substring heading-start subtree-end))
               (heading-text (org-get-heading t t t t))
               (action-type (completing-read "Action type: "
                                             '("New Project" "Add to Existing Project"))))
          ;; Replace PROCESS with READY and adjust heading level to *** (3 stars)
          (setq subtree-content
                (replace-regexp-in-string "^\\*\\* PROCESS " "*** READY " subtree-content))
          ;; Also adjust any sub-items to maintain proper hierarchy
          (setq subtree-content
                (replace-regexp-in-string "^\\(\\*+\\)"
                                          (lambda (match)
                                            (concat "*" match))
                                          subtree-content))
          ;; Add properties if adding to existing project
          (when (string= action-type "Add to Existing Project")
            (let* ((projects-dir (expand-file-name "projects" org-directory))
                   (personal-files (directory-files
                                    (expand-file-name "personal/active" projects-dir)
                                    t "\\.org$"))
                   (work-files (ignore-errors
                                 (directory-files
                                  (expand-file-name "work/active" projects-dir)
                                  t "\\.org$")))
                   (all-files (append personal-files (or work-files '())))
                   (project-names (delq nil
                                        (mapcar (lambda (file)
                                                  (let ((name (file-name-base file)))
                                                    (unless (string-match-p "index\\|template\\|README\\|HOWTO" name)
                                                      (upcase name))))
                                                all-files)))
                   (project (if project-names
                                (completing-read "Target project: " project-names)
                              (read-string "Target project name: ")))
                   (task-type (completing-read "Task type: "
                                               '("EXPLORE" "TODO" "BUG" "QUICK"))))
              ;; Add properties to content
              (setq subtree-content
                    (replace-regexp-in-string
                     "^\\(\\*\\*\\* READY.*\\)\n"
                     (format "\\1\n    :PROPERTIES:\n    :TARGET: %s\n    :TYPE: %s\n    :END:\n"
                             project task-type)
                     subtree-content))))
          ;; Delete original
          (delete-region heading-start subtree-end)
          ;; Find target section and insert
          (goto-char (point-min))
          (when (re-search-forward "^\\* ✅ Ready for Action" nil t)
            (if (string= action-type "New Project")
                (re-search-forward "^\\*\\* Projects to Create" nil t)
              (re-search-forward "^\\*\\* Tasks for Existing Projects" nil t))
            (org-end-of-subtree t t)
            (unless (bolp) (insert "\n"))
            (insert subtree-content)
            (message "Moved to Ready for Action!"))))))

  (defun my/weekly-index-review ()
    "Start weekly index review process"
    (interactive)
    (let ((type (completing-read "Review index: " '("personal" "work"))))
      (find-file (expand-file-name (format "projects/%s/index.org" type) org-directory))
      (goto-char (point-min))
      (when (re-search-forward "\\*\\* Weekly Processing" nil t)
        (org-tree-to-indirect-buffer)
        (message "Review checklist in indirect buffer. Process items in main buffer."))))

  (defun my/execute-ready-item ()
    "Execute a READY item - create project or add to existing"
    (interactive)
    (if (not (org-at-heading-p))
        (message "Not on a heading!")
      ;; Check if we're in Ready for Action section
      (let ((is-ready nil)
            (item-content nil))
        (save-excursion
          (org-back-to-heading t)
          (let ((heading-text (org-get-heading t t t t)))
            (when (or (string-match "^READY " heading-text)
                      (progn
                        (outline-up-heading 1 t)
                        (or (looking-at "\\*\\* Projects to Create")
                            (looking-at "\\*\\* Tasks for Existing Projects"))))
              (setq is-ready t))))
        (if (not is-ready)
            (message "Not a ready item! Must be in Ready for Action section.")
          ;; Process the item
          (let* ((target (org-entry-get nil "TARGET"))
                 (task-type (org-entry-get nil "TYPE"))
                 (heading-text (org-get-heading t t t t))
                 ;; Clean the heading - remove READY and [TYPE] tags
                 (clean-heading (replace-regexp-in-string
                                 "^\\(READY \\)?\\(\\[[^]]+\\] \\)?" "" heading-text)))
            (if target
                ;; Add to existing project
                (let* ((project-file (car (directory-files-recursively
                                           (expand-file-name "projects" org-directory)
                                           (format "%s\\.org$" (downcase target)))))
                       (task-state (or task-type "TODO")))
                  (if (not project-file)
                      (message "Could not find project file for %s" target)
                    (find-file project-file)
                    (goto-char (point-min))
                    (when (re-search-forward "\\*\\* Ideas / Backlog" nil t)
                      (org-end-of-subtree)
                      (insert (format "\n*** %s %s\n    From index: %s\n"
                                      task-state
                                      clean-heading
                                      (format-time-string "[%Y-%m-%d]"))))
                    (save-buffer)
                    (message "Added '%s' to %s project!" clean-heading target)
                    ;; Go back to index and mark as done
                    (switch-to-prev-buffer)
                    (org-todo "DONE")))
              ;; Create new project
              (let ((project-name (read-string "Project name: " clean-heading)))
                (my/create-new-project project-name
                                       (if (string-match-p "personal" (buffer-file-name))
                                           "personal" "work"))
                (message "Created new project: %s" project-name)
                ;; Mark as done in index
                (switch-to-prev-buffer)
                (when (get-buffer (file-name-nondirectory
                                   (expand-file-name
                                    (format "projects/%s/index.org"
                                            (if (string-match-p "personal" (buffer-file-name))
                                                "personal" "work"))
                                    org-directory)))
                  (switch-to-buffer (file-name-nondirectory
                                     (expand-file-name
                                      (format "projects/%s/index.org"
                                              (if (string-match-p "personal" (buffer-file-name))
                                                  "personal" "work"))
                                      org-directory)))
                  (org-todo "DONE")))))))))

  (defun my/move-task-to-progress ()
    "Move current task to In Progress"
    (interactive)
    (when (org-at-heading-p)
      (let ((new-type (completing-read "Status: " '("DOING" "BLOCKED"))))
        (org-todo new-type)
        (org-cut-subtree)
        (goto-char (point-min))
        (when (re-search-forward "\\*\\* In Progress" nil t)
          (org-end-of-subtree)
          (newline)
          (org-paste-subtree 3)))))

  (defun my/move-task-to-done ()
    "Move current task to Done section"
    (interactive)
    (when (org-at-heading-p)
      (org-todo "DONE")
      (let ((content (org-get-entry)))
        (org-cut-subtree)
        (goto-char (point-min))
        (when (re-search-forward "\\*\\* Done" nil t)
          (org-end-of-subtree)
          (newline)
          (org-paste-subtree 3)))))

  (defun my/move-task-to-todo ()
    "Move current task to To Do section"
    (interactive)
    (when (org-at-heading-p)
      (let ((new-type (completing-read "Type: " '("TODO" "BUG" "QUICK"))))
        (org-todo new-type)
        (org-cut-subtree)
        (goto-char (point-min))
        (when (re-search-forward "\\*\\* To Do / Ready" nil t)
          (org-end-of-subtree)
          (newline)
          (org-paste-subtree 3)))))

  (defun my/move-task-to-backlog ()
    "Move current task to Ideas/Backlog"
    (interactive)
    (when (org-at-heading-p)
      (let ((new-type (completing-read "Type: " '("EXPLORE" "MAYBE" "NO"))))
        (org-todo new-type)
        (org-cut-subtree)
        (goto-char (point-min))
        (when (re-search-forward "\\*\\* Ideas / Backlog" nil t)
          (org-end-of-subtree)
          (newline)
          (org-paste-subtree 3)))))

  ;; Index movement functions
  (defun my/index-move-to-capture ()
    "Move current item back to Capture section in index"
    (interactive)
    (when (org-at-heading-p)
      (org-back-to-heading t)
      (let* ((heading-start (point))
             (subtree-end (save-excursion (org-end-of-subtree t t) (point)))
             (subtree-content (buffer-substring heading-start subtree-end)))
        ;; Convert any TODO state to CAPTURE and adjust heading level
        (setq subtree-content
              (replace-regexp-in-string "^\\(\\*+\\) \\(PROCESS\\|READY\\|TODO\\|DONE\\) " "** CAPTURE " subtree-content))
        ;; Adjust sub-item levels if moving from level 3 to level 2
        (when (string-match "^\\*\\*\\*" subtree-content)
          (setq subtree-content
                (replace-regexp-in-string "^\\(\\*+\\)"
                                          (lambda (match)
                                            (if (> (length match) 2)
                                                (substring match 1)
                                              match))
                                          subtree-content)))
        ;; Delete original
        (delete-region heading-start subtree-end)
        ;; Insert in Capture section
        (goto-char (point-min))
        (when (re-search-forward "^\\* 📥 Capture" nil t)
          (org-end-of-subtree t t)
          (unless (bolp) (insert "\n"))
          (insert subtree-content)
          (message "Moved back to Capture!")))))

  (defun my/index-move-to-process ()
    "Move current item to Process section in index"
    (interactive)
    (when (org-at-heading-p)
      (org-back-to-heading t)
      (let* ((heading-start (point))
             (subtree-end (save-excursion (org-end-of-subtree t t) (point)))
             (subtree-content (buffer-substring heading-start subtree-end))
             (heading-text (org-get-heading t t t t))
             (capture-type (when (string-match "\\[\\([^]]+\\)\\]" heading-text)
                             (match-string 1 heading-text))))
        ;; Convert to PROCESS and ensure level 2
        (setq subtree-content
              (replace-regexp-in-string "^\\(\\*+\\) \\(CAPTURE\\|READY\\|TODO\\|DONE\\) " "** PROCESS " subtree-content))
        ;; Adjust sub-item levels to maintain hierarchy
        (when (string-match "^\\*\\*\\*" subtree-content)
          (setq subtree-content
                (replace-regexp-in-string "^\\(\\*+\\)"
                                          (lambda (match)
                                            (if (> (length match) 2)
                                                (substring match 1)
                                              match))
                                          subtree-content)))
        ;; Delete original
        (delete-region heading-start subtree-end)
        ;; Insert in Process section
        (goto-char (point-min))
        (when (re-search-forward "^\\* 🔄 Process" nil t)
          (org-end-of-subtree t t)
          (unless (bolp) (insert "\n"))
          (insert subtree-content)
          ;; Add template if doesn't exist
          (unless (string-match "Purpose:\\|Questions:" subtree-content)
            (forward-line -1)
            (org-end-of-subtree t nil)
            (insert (my/get-process-template capture-type))))
        (message "Moved to Process!"))))

  (defun my/index-move-to-ready ()
    "Move current item to Ready for Action in index"
    (interactive)
    (when (org-at-heading-p)
      ;; Just call the existing ready-for-action function
      (condition-case err
          (my/ready-for-action)
        (error
         ;; If not in Process section, move it there first
         (when (string-match "Not in Process section" (error-message-string err))
           (my/index-move-to-process)
           (my/ready-for-action))))))

  (defun my/index-archive-item ()
    "Archive current item in index"
    (interactive)
    (when (org-at-heading-p)
      (org-todo "ARCHIVED")
      (let ((content (buffer-substring (line-beginning-position)
                                       (save-excursion (org-end-of-subtree t t) (point)))))
        (org-cut-subtree)
        ;; Find or create Archive section
        (goto-char (point-max))
        (unless (re-search-backward "^\\* Archive" nil t)
          (goto-char (point-max))
          (insert "\n* Archive\n"))
        (org-end-of-subtree t t)
        (unless (bolp) (insert "\n"))
        (insert content)
        (message "Item archived!"))))

  ;; Project keybindings (need to be outside after! org block)
  (map! :leader
        (:prefix ("n p" . "projects")
         :desc "Create new project" "n" #'my/create-new-project
         :desc "Add todo task" "t" #'my/add-todo-task
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
         :desc "Add to capture bin" "I" #'my/add-to-capture
         :desc "Guided capture" "G" #'my/guided-capture
         :desc "Quick capture menu" "q" #'my/quick-capture-menu
         :desc "Help menu" "h" #'my/project-help-menu
         :desc "Add to planning queue" "Q" #'my/add-to-planning-queue
         :desc "Open work index" "W" #'my/open-work-index
         :desc "Open personal index" "P" #'my/open-personal-index
         :desc "Weekly review" "R" #'my/weekly-index-review
         (:prefix ("x" . "index workflow")
          :desc "Process capture item" "p" #'my/process-capture-item
          :desc "Mark ready for action" "r" #'my/ready-for-action
          :desc "Execute ready item" "x" #'my/execute-ready-item
          :desc "Quick decision" "d" #'my/quick-process-decision
          :desc "Review checklist" "c" #'my/process-review-checklist
          :desc "Batch process captures" "b" #'my/batch-process-captures
          (:prefix ("m" . "move in index")
           :desc "To capture" "c" #'my/index-move-to-capture
           :desc "To process" "p" #'my/index-move-to-process
           :desc "To ready" "r" #'my/index-move-to-ready
           :desc "Archive item" "a" #'my/index-archive-item))
         (:prefix ("m" . "move task")
          :desc "To backlog" "b" #'my/move-task-to-backlog
          :desc "To todo" "t" #'my/move-task-to-todo
          :desc "To progress" "p" #'my/move-task-to-progress
          :desc "To done" "d" #'my/move-task-to-done))))

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


;; Delete AFTER code merged to ELPA
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
      ;; (setq! gptel-model 'claude-opus-4-20250514)
      (setq! gptel-model 'claude-sonnet-4-sonnet-20250514)

      )))
