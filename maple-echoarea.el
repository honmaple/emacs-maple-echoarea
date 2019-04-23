;;; maple-echoarea.el --- modeline configurations.	-*- lexical-binding: t -*-

;; Copyright (C) 2015-2019 lin.jiang

;; Author: lin.jiang <mail@honmaple.com>
;; URL: https://github.com/honmaple/dotfiles/tree/master/emacs.d

;; This file is free software: you can redistribute it and/or modify
;; it under the terms of the GNU General Public License as published by
;; the Free Software Foundation, either version 3 of the License, or
;; (at your option) any later version.

;; This file is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;; GNU General Public License for more details.

;; You should have received a copy of the GNU General Public License
;; along with this file.  If not, see <http://www.gnu.org/licenses/>.

;;; Commentary:
;;
;; modeline configurations.
;;

;;; Code:
(defvar maple-echoarea-format nil)
(defvar maple-echoarea-show-p nil)
(defvar maple-echoarea-buffer " *Minibuf-0*")

(defgroup maple-echoarea nil
  "Display maple line in window side."
  :group 'maple)

(defun maple-echoarea-enter()
  "Setup after enter minibuffer."
  (with-selected-window (minibuffer-selected-window)
    (maple-echoarea-unshow)))

(defun maple-echoarea-message (&rest _args)
  "Advice message with ARGS."
  (if (current-message)
      (maple-echoarea-unshow)
    (maple-echoarea-show)))

(defun maple-echoarea-hide-mode-line()
  "Unshow modeline with FORCE."
  (setq maple-echoarea-format mode-line-format)
  (setq mode-line-format nil))

(defun maple-echoarea-show ()
  "Show modeline with FORCE."
  (maple-echoarea-hide-mode-line)
  (with-current-buffer maple-echoarea-buffer
    (erase-buffer)
    (insert (format-mode-line maple-echoarea-format)))
  (unless maple-echoarea-show-p
    (set-window-fringes (minibuffer-window) 0 1)
    (set-window-margins (minibuffer-window) 0 0)
    (setq message-truncate-lines t)
    (force-window-update))
  (setq maple-echoarea-show-p t))

(defun maple-echoarea-unshow ()
  "Unshow modeline with FORCE."
  (setq mode-line-format maple-echoarea-format)
  (with-current-buffer maple-echoarea-buffer
    (erase-buffer))
  (when maple-echoarea-show-p
    (set-window-fringes (minibuffer-window) nil nil)
    (set-window-margins (minibuffer-window) nil nil)
    (force-window-update))
  (setq maple-echoarea-show-p nil))

(defun maple-echoarea-enable ()
  "Setup the default modeline."
  (interactive)
  (maple-echoarea-show)
  (advice-add 'message :after 'maple-echoarea-message)
  (add-hook 'minibuffer-setup-hook 'maple-echoarea-enter))

(defun maple-echoarea-disable ()
  "Disable modeline."
  (interactive)
  (maple-echoarea-unshow)
  (advice-remove 'message 'maple-echoarea-message)
  (remove-hook 'minibuffer-setup-hook 'maple-echoarea-enter))

;;;###autoload
(define-minor-mode maple-echoarea-mode
  "maple echoarea mode"
  :group      'maple-echoarea
  :global     t
  (if maple-echoarea-mode (maple-echoarea-enable) (maple-echoarea-disable)))

(provide 'maple-echoarea)
;;; maple-echoarea.el ends here
