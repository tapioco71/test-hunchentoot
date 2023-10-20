;;;; -*- mode: common-lisp; indent-tabs-mode: t -*-
;;;; test-hunchentoot.lisp

(in-package #:test-hunchentoot)

;; Initial setup for javascript environment
(eval-when (:compile-toplevel :execute)
  (setq cl-who:*attribute-quote-char* #\"
        ps:*js-string-delimiter* #\"))

;; "test-hunchentoot" goes here. Hacks and glory await!
;; Methods.

(defmethod hunchentoot:acceptor-dispatch-request ((vhost system-class) request)
  (mapc (lambda (dispatcher)
	  (let ((handler (funcall dispatcher request)))
	    (when handler
	      (return-from hunchentoot:acceptor-dispatch-request (funcall handler)))))
	(dispatch-table vhost))
  (call-next-method))

(defmethod start-web-server ((object system-class) &rest parameters &key
                                                                      (document-root-directory-pathname *default-document-root-directory-pathname* document-root-directory-pathname-p)
								      (ssl-private-key-file-pathname *default-ssl-private-key-file-pathname* ssl-private-key-file-pathname-p)
								      (ssl-certificate-file-pathname *default-ssl-certificate-file-pathname* ssl-certificate-file-pathname-p)
                                                                      (port *default-port* port-p)
								      (ssl-port *default-ssl-port* ssl-port-p)
                                                                      (page-reload-timeout *default-start-page-reload-timeout* page-reload-timeout-p)
                                                                      (verbose nil))
  (declare (ignorable parameters
                      document-root-directory-pathname
		      ssl-private-key-file-pathname
		      ssl-certificate-file-pathname
		      port
		      ssl-port
                      page-reload-timeout
                      verbose))
  (when document-root-directory-pathname-p
    (check-type document-root-directory-pathname pathname)
    (assert (cl-fad:directory-exists-p document-root-directory-pathname)))
  (when ssl-private-key-file-pathname-p
    (check-type ssl-private-key-file-pathname pathname)
    (assert (cl-fad:file-exists-p ssl-private-key-file-pathname)))
  (when ssl-certificate-file-pathname-p
    (check-type ssl-certificate-file-pathname pathname)
    (assert (cl-fad:file-exists-p ssl-certificate-file-pathname)))
  (when port-p
    (check-type port (unsigned-byte 16)))
  (when ssl-port-p
    (check-type ssl-port (unsigned-byte 16)))
  (when (and port-p ssl-port-p)
    (assert (/= port ssl-port)))
  (when page-reload-timeout-p
    (check-type page-reload-timeout (unsigned-byte 16)))
  ;;
  (unwind-protect
       (when (> (cl+ssl:use-certificate-chain-file (namestring ssl-certificate-file-pathname)) 0)
	 (setf (lock-object object) (bt:make-lock (symbol-name (gensym "webserver-lock-"))))
	 (setf (condition-object object) (bt:make-condition-variable :name (symbol-name (gensym "webserver-condition-"))))
	 ;; Server setup and start
	 (setf (ssl-acceptor object) (make-instance 'hunchentoot:easy-ssl-acceptor
						    :name 'ssl-acceptor
						    :ssl-privatekey-file ssl-private-key-file-pathname
						    :ssl-certificate-file ssl-certificate-file-pathname
						    :address "localhost"
						    :port ssl-port
						    :document-root document-root-directory-pathname))
	 (hunchentoot:start (ssl-acceptor object))
	 (setq *ssl-acceptor* (ssl-acceptor object))
	 (when verbose
	   (format *standard-output*
		   "~%;; Starting SSL Web Server on port ~a.~%~%" ssl-port)
	   (format *standard-output*
		   ";; Certificate pathname ~s.~%" ssl-certificate-file-pathname)
	   (format *standard-output*
		   ";; Private key pathname ~s.~%~%" ssl-private-key-file-pathname)
	   (finish-output *standard-output*))
	 (setq hunchentoot:*dispatch-table* (list 'hunchentoot:dispatch-easy-handlers))
	 (bt:with-lock-held ((lock-object object))
	   (bt:condition-wait (condition-object object)
			      (lock-object object))))
    ;; unwind-protect cleanup form.
    (progn
      (when verbose
	(format *standard-output* ";; Shutting down webserver.~%")
	(finish-output *standard-output*))
      (stop-web-server object :verbose t))))

(defmethod stop-web-server ((object system-class) &rest parameters &key (verbose nil))
  (declare (ignorable parameters verbose))
  (when (ssl-acceptor object)
    (hunchentoot:stop (ssl-acceptor object))
    (setq *ssl-acceptor* nil)
    (when verbose
      (format *standard-output*
              "~%;; Stopping SSL Web Server.~%~%")
      (finish-output *standard-output*)))
  (bt:condition-notify (condition-object object)))

;; Hunchentoot html stuffs.
(hunchentoot:define-easy-handler (main-page :uri "/") ()
  (hunchentoot:redirect "/index"))

(hunchentoot:define-easy-handler (index-page :uri "/index") ()
  (cl-who:with-html-output-to-string (s)
    (cl-who:htm
     (:html
      (:ul
       (loop for item in '(apple pear banana)
             do (cl-who:htm
		 (:li (cl-who:str item)))))))))

;; Start at quickload.
(start-web-server (make-system)
		  :ssl-port *default-ssl-port*
		  :verbose t)

;; End of file test-hunchentoot.lisp
