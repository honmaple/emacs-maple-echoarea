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

(defun maple-echoarea-enter()
  "Setup after enter minibuffer."
  (with-selected-window (minibuffer-selected-window)
    (maple-echoarea-unshow)))

(defun maple-echoarea-show (&optional force)
  "Show modeline with FORCE."
  (when mode-line-format
    (setq maple-echoarea-format mode-line-format)
    (setq mode-line-format nil))
  (set-window-fringes (minibuffer-window) 0 0)
  (setq message-truncate-lines t)
  (with-current-buffer maple-echoarea-buffer
    (erase-buffer)
    (insert (format-mode-line maple-echoarea-format)))
  (when (and (not maple-echoarea-show-p) force)
    (force-window-update))
  (setq maple-echoarea-show-p t))

(defun maple-echoarea-unshow (&optional force)
  "Unshow modeline with FORCE."
  (when maple-echoarea-format
    (setq mode-line-format maple-echoarea-format)
    (force-mode-line-update))
  (set-window-fringes (minibuffer-window) nil nil)
  (with-current-buffer maple-echoarea-buffer
    (erase-buffer))
  (when (and maple-echoarea-show-p force)
    (force-window-update))
  (setq maple-echoarea-show-p nil))

(defun maple-echoarea-mode ()
  "Setup the default modeline."
  (if (current-message)
      (maple-echoarea-unshow t)
    (maple-echoarea-show t)))

(defun maple-echoarea-message (&rest _args)
  "Advice message with ARGS."
  (maple-echoarea-mode))

(defun maple-echoarea-enable ()
  "Setup the default modeline."
  (interactive)
  (when mode-line-format
    (setq maple-echoarea-format mode-line-format)
    (setq mode-line-format nil))
  (maple-echoarea-show t)
  (add-hook 'minibuffer-setup-hook 'maple-echoarea-enter)
  (advice-add 'message :after 'maple-echoarea-message))

(defun maple-echoarea-disable ()
  "Disable modeline."
  (interactive)
  (remove-hook 'minibuffer-setup-hook 'maple-echoarea-enter)
  (advice-remove 'message 'maple-echoarea-message)
  (maple-echoarea-unshow t))

(provide 'maple-echoarea)
;;; maple-echoarea.el ends here
