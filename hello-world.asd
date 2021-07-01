(asdf:defsystem #:hello-world
    :serial t
    :description "Simple Web app boiler-plate using Common Lisp"
    :depends-on (#:hunchentoot
                #:cl-who)
    :components ((:file "package")
		 (:file "main")
                (:module :src
                        :serial t
		 :components ((:file "config")
			      (:file "controllers")
			      (:module :views
			       :serial t
			       :components ((:file "home")
					    (:file "layout")))))))
