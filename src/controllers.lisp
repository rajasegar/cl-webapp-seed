(in-package :hello-world)

;; Define hunchentoot dispatch table
(setq *dispatch-table*
      (list
       (create-regex-dispatcher "^/$" 'home-page)
       (create-static-file-dispatcher-and-handler "/styles.css"  "static/styles.css")
       (create-static-file-dispatcher-and-handler "/lisp-logo120x80.png"  "static/lisp-logo120x80.png")))
