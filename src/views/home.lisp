(in-package :hello-world)

;; Home page
(defun home-page ()
  (standard-page (:title "Hello World")
    (:div :class "home-wrapper"
	  (:h1 "Hello World in Common Lisp")
	  (:p (:a :href "https://github.com/rajasegar/cl-webapp-seed" "Github Source code"))
	  (:p "Built with: ")
	  (:p (:a :href "https://lisp-lang.org" "Common Lisp"))
	  (:p "Server: " (:a :href "https://edicl.github.io/hunchentoot/" "Hunchentoot"))
	  (:p (:img :src "lisp-logo120x80.png")))))

