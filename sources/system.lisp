;;;; -*- mode: common-lisp; indent-tabs-mode: t -*-
;;;; system.lisp

(in-package #:test-hunchentoot)

;; System class.
(defclass system-class ()
  ((acceptor :initarg :acceptor :accessor acceptor :initform nil)
   (ssl-acceptor :initarg :ssl-acceptor :accessor ssl-acceptor :initform nil)
   (lock-object :initarg :lock-object :accessor lock-object :initform nil)
   (condition-object :initarg :condition-object :accessor condition-object :initform nil)))

;; functions.

(defun make-system (&rest parameters &key
				       (acceptor nil acceptor-p)
				       (ssl-acceptor nil ssl-acceptor-p)
				       (lock-object nil lock-object-p)
				       (condition-object nil condition-object-p))
  (declare (ignorable parameters
		      acceptor
		      ssl-acceptor
		      lock-object
		      condition-object))
  (make-instance 'system-class
                 :acceptor acceptor
		 :ssl-acceptor ssl-acceptor
                 :lock-object lock-object
                 :condition-object condition-object))

;;;; end of file system.lisp
