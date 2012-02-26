;;;; Created on 2011-01-08 20:50:06

(defun foo (&key a b c)
  (list a b c))

(format t "(foo :a 3) ==> ~a~%" (foo :a 1 :b 2 :c 3))
(format t "(foo :a 3) ==> ~a~%" (foo :c 3 :a 1 :b 2))
(format t "(foo :a 3) ==> ~a~%" (foo :a 1 :c 3))
(format t "(foo :a 3) ==> ~a~%" (foo))

(defun foop (&key a (b 23) (c 33 c-p))
  (list a b c c-p))

(format t "(foop :a 3) ==> ~a~%" (foop :a 1 :b 2 :c 3))
(format t "(foop :a 3) ==> ~a~%" (foop :c 3 :a 1 :b 2))
(format t "(foop :a 3) ==> ~a~%" (foop :a 1 :c 3))
(format t "(foop :a 3) ==> ~a~%" (foop))

;(map #'(lambda (x) )))

(reverse '(1 2 3))

(defmacro backwards (expr)
  (reverse expr))


`(and ,(list 1 2 3))
`(and ,@(list 1 2 3))
`(and ,@(list 1 2 3) 4)

(defun gplus (&rest values)
  (gplus-rec values))

(defun gplus-rec ( values)
  (cond
    ((not (car values)) 0)
    (t (+ (car values) (gplus-rec (cdr values))))))

(defun plot (fn min max step)
  (loop for i from min to max by step do
        (loop repeat (funcall fn i) do (format t "*"))
        (format t "~%")))

(defun y-linear (x)
  "y = 3*x +2"
  (+ (* 13 x) 2))

(plot #'exp 0 4 1/2)
(plot #'y-linear 0 4 1/2)
(plot #'(lambda (x) (+ (* -2 x) 10)) 0 4 1/2)
(plot (lambda (x) (* x x x x)) 0 4 1/2)

(defvar plot-data '(1 4 1/2))
(apply #'plot (lambda (x) (/ 1 x)) plot-data)

(funcall #'(lambda (x y) (+ x y)) 2 3)