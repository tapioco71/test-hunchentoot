;;;; -*- mode: common-lisp; indent-tabs-mode: t -*-
;;;; test-hunchentoot.asd
;;
;; Copyright (C) 2017-2023 Angelo Rossi <angelo.rossi.homelab@gmail.com>
;;
;; This file is part of test-hunchentoot.
;;
;;     test-hunchentoot is free software: you can redistribute it and/or modify
;;     it under the terms of the GNU General Public License as published by
;;     the Free Software Foundation, either version 3 of the License, or
;;     (at your option) any later version.
;;
;;     test-hunchentoot is distributed in the hope that it will be useful,
;;     but WITHOUT ANY WARRANTY; without even the implied warranty of
;;     MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;;     GNU General Public License for more details.
;;
;;     You should have received a copy of the GNU General Public License
;;     along with smt-webserver.  If not, see <http://www.gnu.org/licenses/>.

(asdf:defsystem #:test-hunchentoot
  :description "Test hunchentoot server (SSL version)."
  :author "Angelo Rossi <angelo.rossi.homelab@gmail.com>"
  :license "GPLv3"
  :depends-on (#:cl-fad
               #:cl-who
	       #:cl+ssl
               #:ironclad
               #:lass
               #:parenscript
               #:hunchentoot
               #:bordeaux-threads
	       #:simple-date-time)
  :serial t
  :components ((:file "sources/package")
	       (:file "sources/parameters")
	       (:file "sources/system")
               (:file "sources/test-hunchentoot")))

;; End of file test-hunchentoot.asd
