o(defun my-sqrt (n &optional (power 2) (low 0) (high n))
  (let* ((mid (floor (/ (+ low high) 2))) (quadr (expt mid power)))
    ;(format t "~a ~a ~a ~%" low high mid)
    (cond
      ((eql low high) -1)
      ((eql quadr n) mid)
      ((> n quadr) (my-sqrt n power mid high))
      ((< n quadr) (my-sqrt n power low mid)))))



(defun say-hello ()
  (print "Tell me your name")
  (let ((name (read)))
    (format t "Hello ~a, nice to meet you!" name)))

(defun parrot ()
  (print "Tell me sth and I'll repeat")
  (let ((line (read-line)))
    (princ line)))

(defparameter *expression* '(+ (* 2 2) 2))

;(eval *expression*)

(defparameter *alist* '((a . test) (b . dwa-testy)))

(assoc 'a *alist*)
