;;;; Created on 2011-09-25 20:27:25
(in-package :com.nabacg.spam)

(defun spam-probability (feature)
  (with-slots (spam-count ham-count) feature
              (let ((spam-frequency (/ spam-count (max 1 *total-spams*)))
                    (ham-frequency (/ ham-count (max 1 *total-hams*))))
                (/ spam-frequency (+ spam-frequency ham-frequency)))))

(defun bayesian-spam-probability (feature &optional (assumed-probability 1/2) (weight 1))
  (let ((basic-probability (spam-probability feature))
        (data-points (+ (spam-count feature) (ham-count feature))))
    (/ (+ (* weight assumed-probability) (* data-points basic-probability))
       (+ weight data-points))))

; (bayesian-spam-probability (gethash "Kind" *feature-database*))
; (bayesian-spam-probability (gethash "SEX" *feature-database*))

(defun score (features)
  (let ((spam-probs ()) (ham-probs ()) (number-of-probs 0))
    (dolist (feature features)
      (unless (untrained-p feature)
        (let ((spam-prob (float (bayesian-spam-probability feature) 0.0d0)))
          (push spam-prob spam-probs)
          (push (- 1.0d0 spam-prob) ham-probs)
          (incf number-of-probs))))
    (let ((h (- 1 (fisher spam-probs number-of-probs)))
          (s (- 1 (fisher ham-probs number-of-probs))))
      (/ (+ (- 1 h) s) 2.0d0))))

(defun untrained-p (feature)
  (with-slots (spam-count ham-count) feature
              (and (zerop spam-count) (zerop ham-count))))

(defun fisher (probs number-of-probs)
  "The fisher computation using inverse chi square" 
  (inverse-chi-square 
   ;to moze underflow to zero w reduce
   ;(* -2    (log (reduce #'* probs)))
   ; wiec zamiast logarytmu z iloczynu policzymy sume logarytmow
   (* -2 (reduce #'+ probs :key #'log))
   (* 2 number-of-probs)))


(defun inverse-chi-square (value degrees-of-freedom)
  (assert (evenp degrees-of-freedom))
  (min
      (loop with m = (/ value 2)
            for i below (/ degrees-of-freedom 2)
            for prob = (exp (- m)) then (* prob (/ m i))
            summing prob)
   1.0))