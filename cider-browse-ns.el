;;; cider-browse-ns.el --- Browse Clojure namespaces with ease

;; Copyright © 2014 John Andrews

;; Author: John Andrews <john.m.andrews@gmail.com>
;; Version: 0.1.0
;; Package-Requires: ((cider "0.7.0"))
;; URL: https://github.com/jxa/cider-browse-ns
;; Keywords: clojure, cider

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

;; This file is not part of GNU Emacs.

;;; Commentary:

;; cider-browse-ns-all
;; Explore clojure namespaces by browsing a list of all namespaces.
;; Pressing enter expands into a list of that namespace's vars as if by
;; executing the command (cider-browse-ns my.ns)

;; cider-browse-ns
;; Display a list of all vars in a namespace.
;; Pressing <enter> will take you to the cider-doc buffer for that var.
;; Pressing ^ will take you to a list of all namespaces (akin to dired mode)

;;; Code:

(require 'cider-repl)
(require 'cider-client)
(require 'cider-interaction)

(defvar cider-browse-ns-buffer "*Browse NS*")
(defvar cider-browse-ns-current-ns nil)

(make-variable-buffer-local 'cider-browse-ns-current-ns)

(defvar cider-browse-ns-mode-map
  (let ((map (make-sparse-keymap)))
    (set-keymap-parent map cider-popup-buffer-mode-map)
    (define-key map [return] 'cider-browse-ns-operate-on-point)
    (define-key map "^" 'cider-browse-ns-all)
    (define-key map "n" 'next-line)
    (define-key map "p" 'previous-line)
    map))

(define-derived-mode cider-browse-ns-mode fundamental-mode "browse-ns"
  "Major mode for browsing Clojure namespaces.

\\{cider-browse-ns-mode-map}"
  (set-syntax-table clojure-mode-syntax-table)
  (setq buffer-read-only t)
  (setq-local electric-indent-chars nil)
  (setq-local truncate-lines t)
  (setq-local cider-browse-ns-current-ns nil))

(defun cider-browse-ns-list (buffer items)
  "Reset BUFFER to contain elements of ITEMS."
  (with-current-buffer buffer
    (cider-browse-ns-mode)
    (let ((inhibit-read-only t))
      (erase-buffer)
      (dolist (item items)
        (insert item)
        (newline))
      (goto-char (point-min)))))

;;;###autoload
(defun cider-browse-ns-all ()
  "List all loaded namespaces in BUFFER."
  (interactive)
  (with-current-buffer (cider-popup-buffer cider-browse-ns-buffer t)
    (let ((names (cider-eval-and-get-value
                  "(->> (all-ns)
                        (map ns-name)
                        (map name)
                        (sort))")))
      (cider-browse-ns-list (current-buffer)
                            (mapcar (lambda (name)
                                      (propertize name 'font-lock-face 'font-lock-function-name-face))
                                    names))
      (setq-local cider-browse-ns-current-ns nil))))

;;;###autoload
(defun cider-browse-ns (namespace)
  "List all NAMESPACE's vars in BUFFER."
  (interactive (list (completing-read "Switch to namespace: " (cider--all-ns))))
  (with-current-buffer (cider-popup-buffer cider-browse-ns-buffer t)
    (let* ((form "(sort (map name (keys (ns-publics (quote %s)))))")
           (vars (cider-eval-and-get-value (format form namespace)))
           (lines (cons (propertize namespace 'font-lock-face 'cider-doc-strong-face)
                        (mapcar (lambda (var)
                                  (format "  /%s" (propertize var 'font-lock-face 'font-lock-function-name-face))) vars))))
      (cider-browse-ns-list (current-buffer) lines)
      (setq-local cider-browse-ns-current-ns namespace))))

(defun cider-browse-ns-operate-on-point ()
  "Expand browser according to thing at current point."
  (interactive)
  (let* ((bol (line-beginning-position))
         (eol (line-end-position))
         (line (buffer-substring-no-properties bol eol)))
    (if (string-match "  /\\(.+\\)" line)
        (cider-doc-lookup (format "%s/%s" cider-browse-ns-current-ns (match-string 1 line)))
      (cider-browse-ns line))))

(provide 'cider-browse-ns)

;;; cider-browse-ns.el ends here
