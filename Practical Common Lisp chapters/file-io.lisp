;;;; Created on 2011-09-21 23:31:47


(in-package :com.gmc.file.io)

(defun save-to-file (filename content)
  (with-open-file 
     (fstream filename 
      :direction :output
      :if-exists :supersede) 
        (with-standard-io-syntax 
          (print content fstream))))

(defun print-first-line (file-path)
  (let ((input (open file-path :if-does-not-exist nil)))
    (when input
    (format t "~a~%" (read-line input)))
    (close input)))

(defun print-file (file-path)
  (let ((input (open file-path :if-does-not-exist nil)))
    (when input
      (loop for line = (read input nil) 
            while line do
            (format t "~a~%" line))
      (close input))))

;(print-file "D:\\DEV\\projects\\practical-common-lisp-sandbox\\special-variables.txt")
;below returns NIL as file doesn't exist
;(print-file "D:\\Dects\\practical-common-lisp-sandbox\\special-variables.txt")