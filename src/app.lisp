(in-package :hello-world)

(defparameter *ajax-processor*
  (make-instance 'ajax-processor :server-uri "/api"))

(setf (html-mode) :html5)

(defmacro main-layout ((&key title script) &body body)
  `(with-html-output-to-string (*standard-output* nil :prologue t :indent t)
        (:html :lang "en"
            (:head
                (:meta :charset "utf-8")
                (:title, title)
                (:link
                    :type "text/css"
                    :rel "stylesheet"
                    :href "/css/styles.css")
                (str (generate-prologue *ajax-processor*))
                ,(when script
                    `(:script :type "text/javascript" (str, script))))
            (:body
                            (:h1 "Hello World, Lisp")
            ,@body))))

(define-easy-handler (app :uri "/") ()
    (main-layout (:title "Hello World, Lisp"
                :script (ps
                            (chain console (log "Hello world"))))
                 (:h2 "Welcome to Common Lisp web development...")))


(setq *dispatch-table* (list 'dispatch-easy-handlers (create-ajax-dispatcher *ajax-processor*)))
(push (create-folder-dispatcher-and-handler "/css/" "public/css/") *dispatch-table*)

(defun start-server ()
    (start (make-instance 'easy-acceptor :port 3000)))

