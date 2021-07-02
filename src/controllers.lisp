(in-package :hello-world)

;; Define hunchentoot dispatch table
(push (create-folder-dispatcher-and-handler "/" (merge-pathnames "static/"  ;; starts without a /
                                   (asdf:system-source-directory :hello-world)))
      *dispatch-table*)

(defroute home ("/") ()
  (render-template* +home.html+ nil
                        :title "Ukeleles" ))


(defroute about ("/about") ()
  (render-template* +about.html+ nil
                        :special "About Special" ))
