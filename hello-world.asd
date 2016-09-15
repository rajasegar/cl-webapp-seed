(asdf:defsystem #:hello-world
    :serial t
    :description "Simple Web app boiler-plate using Common Lisp"
    :depends-on (#:hunchentoot
                #:cl-who
                #:parenscript
                #:smackjack)
    :components ((:file "package")
                (:module :src
                        :serial t
                        :components ((:file "app")))))
