;;;; Created on 2011-09-24 13:45:30

;define condition
(define-condition malformed-log-entry-error (error)
  ((text :initarg :message :reader message)))

;usage
;(make-condition 'malformed-log-entry-error :message "This log entry if fucked up!")

(defun well-formed-log (text)
  (< (length text) 2))

(defun parse-log-entry (text)
  (if (well-formed-log text)
      (format t text)
      (restart-case (error 'malformed-log-entry-error :message text)
                    (use-value (value) value)
                    (reparse-entry (fixed-text) (parse-log-entry fixed-text)))))

(defun parse-log-file (file)
  (with-open-file (input file :direction :input)
                  (loop for text = (read-line input nil nil ) while text
                        for entry = (restart-case 
                                                  (parse-log-entry text)
                                                  (skip-log-entry () nil))
                        when entry collect it)))

(defun find-all-logs ()
  (list "D:\\DEV\\projects\\practical-common-lisp-sandbox\\special-variables.txt"))

(defun log-analyzer ()
  (handler-bind 
   ((malformed-log-entry-error  #'(lambda (c) 
                                    (declare (ignore c))
                                    ;(format t "Issueing restart~%")
                                    (invoke-restart 'skip-log-entry))))
   (dolist (log (find-all-logs))
     (analyze-log log))))

(defun analyze-log (log-file)
  (dolist (entry (parse-log-file log-file))
    (analyze-entry entry)))

(defun analyze-entry (entry)
  (format t "~a~%" entry))

#|
(defun parse-log-file (file)
  (with-open-file (input file :direction :input)
                  (loop for text = (read-line input nil nil ) while text
                        for entry = (handler-case 
                                                  (parse-log-entry text)
                                                  (malformed-log-entry-error () nil))
                        when entry collect it)))
|#

#|
(dolist (row  (parse-log-file "D:\\DEV\\projects\\practical-common-lisp-sandbox\\special-variables.txt")) 
  (format t "~a~%" row) )
|#