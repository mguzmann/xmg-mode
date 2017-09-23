;;; xmg-mode.el --- Edit xmg files. -*- lexical-binding: t; -*-

;; xmg-mode for editing xmg files in Emacs
;; Copyright (C) 2017  Matías Guzmán Naranjo

;; Author: Matías Guzmán Naranjo <mortem.dei@gmail.com>
;; URL: http://github.com/mguzmann/xmg-mode/
;; Package-Requires: ((emacs "25"))
;; Version: 0.1
;; Keywords: xmg

;; This program is free software: you can redistribute it and/or modify
;; it under the terms of the GNU General Public License as published by
;; the Free Software Foundation, either version 3 of the License, or
;; (at your option) any later version.

;; This program is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;; GNU General Public License for more details.

;; You should have received a copy of the GNU General Public License
;; along with this program.  If not, see <http://www.gnu.org/licenses/>.

;;; Commentary:
;; 

;;; Code:

;; define several category of keywords
(setq xmg-keywords '("class" "type" "feature" "export" "declare" "value" "import" "property"))
(setq xmg-functions '("node" "syn" "sem" "frame"))

;; generate regex string for each category of keywords
(setq xmg-keywords-regexp (regexp-opt xmg-keywords 'words))
(setq xmg-functions-regexp (regexp-opt xmg-functions 'words))

;; create the list for font-lock.
;; each category of keyword is given a particular face
(setq xmg-font-lock-keywords
      `(
        (,xmg-keywords-regexp . font-lock-keyword-face)
	(,"[:=!;]" . font-lock-function-name-face)
	(,"->" . font-lock-function-name-face)
        (,">>" . font-lock-function-name-face)
	(,xmg-functions-regexp . font-lock-function-name-face)
	(,"\?[a-zA-Z0-9]+" . font-lock-variable-name-face)
	(,"\![a-zA-Z0-9]+" . font-lock-constant-face)
	(,"\(\\(\\sw[a-zA-Z0-9_.-]*\\(,\\sw[a-zA-Z0-9_.-]*\\)*\\)\)" 1 font-lock-constant-face)
        ("class\\s(\*\*)* +\\(\\sw[a-zA-Z0-9_.-]*\\)" 1 'font-lock-type-face)
        ("type\\s(\*\*)* +\\(\\sw[a-zA-Z0-9_.-]*\\)" 1 'font-lock-type-face)
        ("feature\\s(\*\*)* +\\(\\sw[a-zA-Z0-9_.-]*\\)" 1 'font-lock-type-face)
        ("property\\s(\*\*)* +\\(\\sw[a-zA-Z0-9_.-]*\\) " 1 'font-lock-type-face)
        ))

;; basic indentation
(defvar xmg-indent-offset 4
  "*Indentation offset for `xmg-mode'.")
(setq-default indent-tabs-mode nil)

(defun xmg-indent-line ()
  "Indent current line for `xmg-mode'."
  (interactive)
  (let ((indent-col 0))
    (save-excursion
      (beginning-of-line)
      (condition-case nil
          (while t
            (backward-up-list 1)
            (when (looking-at "[[{]")
              (setq indent-col (+ indent-col xmg-indent-offset))))
        (error nil)))
    (save-excursion
      (back-to-indentation)
      (when (and (looking-at "[]}]") (>= indent-col xmg-indent-offset))
        (setq indent-col (- indent-col xmg-indent-offset))))
    (indent-line-to indent-col)))

;;autoload
(setq xmg-mode-syntax-table
      (let ( (synTable (make-syntax-table)))
        ;; python style comment: “# …”
        (modify-syntax-entry ?% "<" synTable)
        (modify-syntax-entry ?\n ">" synTable)
        (modify-syntax-entry ?- "w" synTable)
        synTable))

(define-derived-mode xmg-mode  fundamental-mode "xmg script"
  ;;(define-derived-mode xmg-mode c-mode "lsl mode"
  ;; code for syntax highlighting
  (set-syntax-table xmg-mode-syntax-table)
  (setq font-lock-defaults '((xmg-font-lock-keywords)))
  (make-local-variable 'xmg-indent-offset)
  (set (make-local-variable 'indent-line-function) 'xmg-indent-line)
  )

;; clear memory. no longer needed
(setq xmg-keywords nil)
(setq xmg-functions nil)

;; clear memory. no longer needed
(setq xmg-keywords-regexp nil)
(setq xmg-functions-regexp nil)

;; add the mode to the `features' list
(provide 'xmg-mode)

;;; xmg-mode.el ends here
