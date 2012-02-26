;;;; Created on 2011-10-09 16:47:31

(defparameter *upper* 100)
(defparameter *lower* 1)
(defparameter *current* (random *upper*))

(defun lower ()
  (setf *upper* *current*)
  (guess-my-number))

(defun upper ()
  (setf *lower* *current*)
  (guess-my-number ))


(defun guess-my-number ()
  (setf *current* (ceiling (+ (* (random 1.0) (- *upper* *lower*)) *lower*)))
  (format t "~a~%" *current*))

(defun guess-my-number-2 ()
  (setf *current* (ash (+ *lower* *upper*) -1))
  (format t "~a~%" *current*))
