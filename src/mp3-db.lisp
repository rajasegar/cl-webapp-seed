(in-package :mp3-db)

(defun make-cd (title artist rating ripped)
  (list :title title :artist artist :rating rating :ripped ripped))

(defvar *db* nil)

(defun add-record (cd)
  (push cd *db*))

(add-record (make-cd "Kabali" "Santhosh Narayanan" 9 t))
(add-record (make-cd "IruMugan" "Harris Jayaraj" 8 nil))
(add-record (make-cd "Waha" "D Iman" 8 nil))


;; this should not be the same directory as *TMP-DIRECTORY* and it
;; should be initially empty (or non-existent)
(defvar *tmp-test-directory* #p"/tmp/hunchentoot/test/")


(defun load-db (filename)
  (with-open-file (in filename)
    (with-standard-io-syntax
          (setf *db* (read in)))))

(defun select (selector-fn)
    (remove-if-not selector-fn *db*))

(defun make-comparison-expr (field value)
    `(equal (getf cd ,field) ,value))

(defun make-comparisons-list (fields) 
  (loop while fields 
        collecting (make-comparison-expr (pop fields) (pop fields))))


(defun where (&key title artist)
  #'(lambda (cd)
        (or
            (search title (getf cd :title))
            (search artist (getf cd :artist)))))



(defparameter *ajax-processor*
  (make-instance 'ajax-processor :server-uri "/api"))

(defmethod my-encode (db)
  (yason:with-output-to-string* ()
    (yason:with-array ()
      (dolist (cd db)
        (yason:with-object ()
            (yason:encode-object-element "artist" (getf cd :artist))
            (yason:encode-object-element "title" (getf cd :title))
            (yason:encode-object-element "rating" (getf cd :rating))
            (yason:encode-object-element "ripped" (getf cd :ripped)))))))


(defun-ajax search-db (search-keyword) (*ajax-processor* :callback-data :json)
    (my-encode (select (where :title search-keyword))))

(defun-ajax search-db-xml (search-keyword) (*ajax-processor* :callback-data :response-text)
    (with-html-output-to-string (*standard-output* nil)
        (dolist (cd (select (where :title search-keyword :artist search-keyword)))
                    (htm
                        (:tr
                            (:td (fmt "~a" (getf  cd :title )))
                            (:td (fmt "~a" (getf  cd :artist )))
                            (:td (fmt "~a" (getf  cd :rating)))
                            (:td (fmt "~a" (getf cd :ripped ))))))))

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
                    :href "/css/bootstrap.min.css")
                (str (generate-prologue *ajax-processor*))
                ,(when script
                    `(:script :type "text/javascript" (str, script))))
            (:body
                (:div :class "container"
                    (:div :class "row"
                        (:div :class "col-md-12"
                            (:br)
                            (:h1 "MP3 Database")
            ,@body)))))))

(define-easy-handler (app :uri "/") ()
    (main-layout (:title "MP3 Database"
                :script (ps
                            (chain console (log "MP3 database"))
                            (defun search-callback (response)
                                ;(chain console (log response))
                                (let ((tb (chain document (get-element-by-id "tbMp3"))))
                                    (setf (@ (aref (@ tb t-bodies) 0) inner-h-t-m-l) "")
                                    (setf (@ (aref (@ tb t-bodies) 0) inner-h-t-m-l) response)))


                            (chain document (add-event-listener "input" (lambda (event)
                                ;(chain console (log (@ event target)))
                                (when (= (@ event target id) "txtSearch")
                                    (let ((keyword (@ event target value )))
                                      ;(chain console (log keyword))
                                        (chain smackjack (search-db-xml keyword search-callback)))))))))
        (:div :class "row"
            (:div :class "col-md-6"
                (:div :class "input-group"
                    (:input :type "search" :class "form-control" :id "txtSearch" :placeholder "Search for Title / Artist..." :autofocus t)
                    (:span :class "input-group-addon"
                        (:span :class "glyphicon glyphicon-search"))))
            (:div :class "col-md-6"
                (:p :class "pull-right" 
                    (:a :href "/save-file" :class "btn btn-info" "Save to file")
                    (:a :href "/load-db" :class "btn btn-success" "Load from file") 
                    (:a :href "/new-cd" :class "btn btn-primary" "New CD"))))
        (:table :id "tbMp3" :class "table table-striped table-hover"
            (:thead
                (:tr
                    (:th "Title")
                    (:th "Artist")
                    (:th "Rating")
                    (:th "Ripped")))
            (:tbody
                (dolist (cd *db*)
                    (htm
                        (:tr
                            (:td (fmt "~a" (getf  cd :title )))
                            (:td (fmt "~a" (getf  cd :artist )))
                            (:td (fmt "~a" (getf  cd :rating)))
                            (:td (fmt "~a" (getf cd :ripped ))))))))))

(define-easy-handler (new-cd :uri "/new-cd") ()
    (main-layout (:title "MP3 Database - New CD"
                :script (ps (chain console (log "New CD"))))
        (:form :class "form" :action "/add-cd" :method "post"
            (:div :class "form-group"
                (:label :class "control-label" "Title")
                (:input :type "text" :class "form-control" :name "title" :required t))
            (:div :class "form-group"
                (:label :class "control-label" "Artist")
                (:input :type "text" :class "form-control" :name "artist" :required t))
            (:div :class "form-group"
                (:label :class "control-label" "Rating")
                (:input :type "number" :class "form-control" :name "rating" :max "10" :step "1" :required t))
            (:div :class "form-group"
                (:label :class "control-label" "Ripped")
                (:label :class "radio-inline"
                    (:input :type "radio"  :name "ripped" :value "true" :checked t) "YES")
                (:label :class "radio-inline"
                    (:input :type "radio"  :name "ripped" :value "false") "NO"))
            (:p :class "pull-right"
                (:input :type "submit" :value "Add CD" :class "btn btn-primary")
                (:input :type "reset" :value "Reset" :class "btn btn-danger")
                (:a :href "/" :class "btn btn-warning" "Cancel")))))

(define-easy-handler (add-cd :uri "/add-cd") (title artist rating ripped)
    (add-record (make-cd title artist rating (equal ripped "true")))
    (redirect "/"))

(define-easy-handler (load-from-file :uri "/load-db") ()
    (main-layout 
        (:title "MP3 Database - Load File"
            :script (ps (chain console (log "Load file"))))
        (:form :class "form" :action "/load-file" :method "post"  :enctype "multipart/form-data" 
            (:div :class "form-group"
                (:label :class "control-label" "Select file:")
                (:input :type "file" :class "form-control" :name "file" :accept ".db" :required t))
            (:p :class "pull-right"
                (:input :type "submit" :value "Load Database" :class "btn btn-primary")
                (:a :href "/" :class "btn btn-danger" "Cancel")))))

(define-easy-handler (load-file :uri "/load-file") (file)
    (destructuring-bind (path file-name content-type) (post-parameter "file")
        (print (format nil "Path: ~a"  path))
        (print (format nil "File Name: ~a" (concatenate 'string (format nil "~a" path) "/" file-name)))
        (print (format nil "Content-type: ~a" content-type))
        (let ((new-path (make-pathname :name file-name :type nil :defaults *tmp-test-directory*)))
            (rename-file path (ensure-directories-exist new-path)))
    (load-db (concatenate 'string (format nil "~a" *tmp-test-directory*) "/" file-name)))
    (redirect "/"))

(define-easy-handler (save-file :uri "/save-file") ()
    (main-layout
        (:title "Save as File"
            :script (ps (chain console (log "Save as File"))))
        (:form :action "/save-url" :class "form" :method "post"
            (:div :class "form-group"
                (:label :class "control-label" "FileName: ")
                (:input :type "text" :class "form-control" :name "filename" :required t))
            (:p :class "pull-right"
                (:input :type "submit" :class "btn btn-primary" :value "Save")
                (:a :href "/" :class "btn btn-danger" "Cancel")))))

(define-easy-handler (save-url :uri "/save-url") (filename)
    (with-open-file (out filename :direction :output :if-exists :supersede)
        (with-standard-io-syntax
            (print *db* out)))
    (handle-static-file filename))


(setq *dispatch-table* (list 'dispatch-easy-handlers (create-ajax-dispatcher *ajax-processor*)))
(push (create-folder-dispatcher-and-handler "/css/" "public/css/") *dispatch-table*)
(push (create-folder-dispatcher-and-handler "/fonts/" "public/fonts/") *dispatch-table*)

(defun start-server ()
    (start (make-instance 'easy-acceptor :port 3000)))

