(in-package :hello-world)

(defmacro standard-page ((&key title) &body body)
  `(with-html-output-to-string
       (*standard-output* nil :prologue t :indent t)
     (:html :lang "en"
	    (:head
	     (:meta :charset "utf-8")
	     (:title, title)
	     (:link :href "/styles.css" :rel "stylesheet")
	     )
	    (:body 
	     (:h1 "Hello World")
	     (:main ,@body)
	     (:script :src "https://unpkg.com/htmx.org@1.4.1")
	     (:script :src "https://unpkg.com/hyperscript.org@0.8.1")
	     ))))
