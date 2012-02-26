;;;; Created on 2011-09-12 21:49:30

;;kazde let definiuje wlasny SCOPE dla zmiennych
(defun print-var (x)
  (format t "~a~%" x)
  (let ((x 2))
    (format t "~a~%" x)
    (let ((x 3))
      (format t "~a~%" x))
    (format t "~a~%" x))
  (format t "~a~%" x))

;; powiekszamy zmienna
(defun increment-var (x)
  (format t "~a~%" x)
  (let ((x (* x x) ))
    (format t "~a~%" x)
    (let ((x (* x x)))
      (format t "~a~%" x))
    (format t "~a~%" x))
  (format t "~a~%" x))


;(let ((count 0))
;  #'(lambda () (1+ count))
;  #'(lambda () (decf count))
;  #'(lambda () count))


;(defparameter *fn*  (let ((count 0)) #'(lambda () (setf count (1+ count)))))

(defvar *X* 0)

(defun print-x ()
  (format t "~a~%" *X*))
;(print-x)
;(let ((*X* 100)) (print-x))

(defun global-print ()
  (print-x)
  (let ((*X* 200)) (print-x))
  (print-x))

;setting a variable
; multiple 
;(setf x 1 y 2)
; chained
; (setf x (setf y (random 10))) 
#|
Simple variable:    (setf x 10) 
Array:              (setf (aref a 0) 10)
Hash table:         (setf (gethash 'key hash) 10)
Slot named 'field': (setf (field o) 10)|#
#| C++ C--

(incf x)    === (setf x (+ x 1))
(decf x)    === (setf x (- x 1))
(incf x 10) === (setf x (+ x 10))

|#

;SWAP TWO Variabiles
;(let ((tmp a)) (setf a b b tmp) nil)

;(global-print)
;special variables
; przekierowanie standardowego strumienia na strumien do pliku
; pobiera liczbe liczby ktore ma wpisac do pliku, 
; uzycie
; (spec-var 3)
; (spec-var 300)
(defun spec-var (n)
 (with-open-file 
     (fstream "d:/dev/projects/practical-common-lisp-sandbox/special-variables.txt" 
      :direction :output
      :if-exists :supersede) 
        (with-standard-io-syntax 
          (let ((*standard-output* fstream)) 
            (dotimes (x n) (format t "~d~%" x))))))

;Rysuje asci art graph do pliku
; parabole rysuje tak:
; (spec-var-fun -100 100 1 #'(lambda (x) (+ (* x x) 4))) 
(defun spec-var-fun (start end step fn)
 (with-open-file 
     (fstream "d:/dev/projects/practical-common-lisp-sandbox/special-variables-graph.txt" 
      :direction :output
      :if-exists :supersede) 
        (with-standard-io-syntax 
          (let ((*standard-output* fstream)) 
            (loop for x from start to end by step do
              (loop repeat (funcall fn x) do (format t "*"))
               (format t "~%")    
              )))))
