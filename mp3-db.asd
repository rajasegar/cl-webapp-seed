(asdf:defsystem #:mp3-db
    :serial t
    :description "MP3 database"
    :depends-on (#:hunchentoot
                #:cl-who
                #:parenscript
                #:smackjack
                #:yason)
    :components ((:file "package")
                (:module :src
                        :serial t
                        :components ((:file "mp3-db")))))
