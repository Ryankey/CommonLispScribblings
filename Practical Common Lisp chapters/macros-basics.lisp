;;;; Created on 2011-09-13 20:31:21

#|
(progn
  (format t "aa~%")
  (format t "bb~%"))

(when (equal 1 1)
  (format t "aaa~%")
  (format t "end~%"))

|#

;redefinicja makra WHEN
;(when2 (equal 1 1)
;  (format t "aaa~%")
;  (format t "end~%"))

(defmacro when2 (condition &rest body)
  `(if ,condition (progn ,@body)))

;odwrotnie UNLESS
;(unless2 nil (format t "nieee~%") (format t "Taaak~%"))
(defmacro unless2 (condition &rest body)
  `(if (not ,condition) (progn ,@body)))


;cond macro
; (cond (a (do-x))
;      (b (do-y))
;      (t (do-z)))

;Redefining AND

;(defmacro and2 (&rest params)
;  `(if ,(pop params) (and2 ,@params)))

;do-primes
(defun is-prime (number)
  (when (> number 1)
    (loop for fac from 2 to (isqrt number) never (zerop (mod number fac)))))

(defun next-prime (number)
  (loop for n from number when (is-prime n) return n))

;VERY FUCK'N CRYPTIC!!!!!!!!!
; `(,a b)  ==>  (list a 'b). 

; chcemy miec
;(do-primes (p 0 19)
;           (format t "~d" p))

; chcemy miec to:
#|
(do ((p (next-prime 0) (next-prime (1+ p))))
    ((> p 19))
  (format t "~d" p))
|#
; USAGE

;(macroexpand-1 '(do-primes (x 0 15) (format t "~d~%" x)))
#|
; leaky abstraction, max will be calculated every loop pass, consicer (random 100) passed as max..
(defmacro do-primes ((p start max) &body body)
  `(do ((,p (next-prime ,start) (next-prime (1+ ,p))))
       ((> ,p ,max))
     ,@body))

;to nie zadziala jezeli ktos uzyje nazwy zmiennej takiej jak 'endig-val'
;np:
; (do-primes (ending-value 0 10)
;   (print ending-value))
(defmacro do-primes ((p start max) &body body)
  `(do ((,p (next-prime ,start) (next-prime (1+ ,p)))
        (ending-val ,max))
       ((> ,p ending-val))
     ,@body))

|#

;WORKING ONE, try on:
#|(macroexpand-1 '(do-primes (ending-value 0 10)
  (print ending-value)))
(macroexpand-1 '(let ((ending-value 0))
  (do-primes (p 0 10)
    (incf ending-value p))
  ending-value))

|#
(defmacro do-primes ((p start max) &body body)
  (let ((ending-value-name (gensym)))
    `(do ((,p (next-prime ,start) (next-prime (1+ ,p)))
          (,ending-value-name ,max))
         ((> ,p ,ending-value-name))
       ,@body)))
;(do-primes (x 0 15) (format t "~d~%" x))

;macro to gensym variables
;(loop for n in '(a b c) collect `(,n (gensym)))   =>> ((A (GENSYM)) (B (GENSYM)) (C (GENSYM)))
(defmacro with-gensyms ( (&rest names) &body body)
  `(let ,(loop for var in names collect `(,var (gensym)))
  ,@body))

(defmacro once-only ((&rest names) &body body)
  (let ((gensyms (loop for n in names collect (gensym))))
    `(let (,@(loop for g in gensyms collect `(,g (gensym))))
      `(let (,,@(loop for g in gensyms for n in names collect ``(,,g ,,n)))
        ,(let (,@(loop for n in names for g in gensyms collect `(,n ,g)))
           ,@body)))))

;MACROS WRITING MACROS!!!!!!!!!!!!!
(defmacro do-primes-macro ((var start end) &body body)
  (with-gensyms (ending-value-name) ; yes this is a macro!!!!!!!!!!
    `(do ((,var (next-prime ,start) (next-prime (1+ ,var)))
          (,ending-value-name ,end))
         ((> ,var ,ending-value-name))
       ,@body)))