;;;; package.lisp
(defpackage #:hello-world
  (:use #:cl #:cl-who #:hunchentoot)
  (:import-from :easy-routes :defroute)
  (:import-from :djula
   :add-template-directory
   :render-template*))
