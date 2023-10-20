;;;; -*- mode: common-lisp; indent-tabs-mode: t -*-
;;;; parameters.lisp

(in-package #:test-hunchentoot)

;; Parameters.
(defparameter *ssl-acceptor* nil)
(defparameter *default-document-root-directory-pathname* (cl-fad:merge-pathnames-as-directory (user-homedir-pathname)
                                                                                              #p"Development/lisp/test-hunchentoot/"))
(defparameter *default-ssl-private-key-file-pathname* (cl-fad:merge-pathnames-as-file (user-homedir-pathname)
										      #p"Development/lisp/test-hunchentoot/scripts/private-key.pem"))
(defparameter *default-ssl-certificate-file-pathname* (cl-fad:merge-pathnames-as-file (user-homedir-pathname)
										      #p"Development/lisp/test-hunchentoot/scripts/certificate.pem"))
(defparameter *default-port* 4242)
(defparameter *default-ssl-port* 9443)
(defparameter *port* 4242)
(defparameter *ssl-port* 9443)
(defparameter *default-start-page-reload-timeout* 0)
(defparameter *default-info-email* "angelo.rossi.homelab@gmail.com")

;;;; end of file parameters.lisp
