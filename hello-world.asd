(asdf:defsystem #:hello-world
    :serial t
    :description "Simple Web app boiler-plate using Common Lisp"
    :depends-on (#:hunchentoot
                 #:cl-who
		 #:easy-routes
		 #:djula
		 )

    :components ((:file "package")
		 (:file "main")
                (:module :src
                        :serial t
		 :components ((:file "config")
			      (:file "controllers")))))
