(in-package :hello-world)

(setf (html-mode) :html5)

(add-template-directory (asdf:system-relative-pathname "hello-world" "templates/"))

(defparameter +base.html+ (djula:compile-template* "base.html"))

(defparameter +home.html+ (djula:compile-template* "home.html"))
(defparameter +about.html+ (djula:compile-template* "about.html"))


