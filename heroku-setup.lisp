(in-package :cl-user)

(print ">>> Building system....")

(load (merge-pathnames "hello-world.asd" *build-dir*))

(ql:quickload :hello-world)

;;; Redefine / extend heroku-toplevel here if necessary

(print ">>> Done building sytem")
