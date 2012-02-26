;;;; Created on 2011-09-16 19:08:03

;najprostszy wektor
;(vector 1 2 3 'a)

;vektor z przesuwanym wskaznikiem, fixed length
;(make-array 5 :fill-pointer 0)
; (vector-push 1 *x*)
; (vector-push 'a *x*)

;tworzony do zmiennej
;(defparameter *x* (make-array 5 :fill-pointer 0))


;rozszerzalny array, o zmiennej dlugosci
;(make-array 5 :fill-pointer 0 :adjustable t)
;(vector-push-extend 1 *x*)
;(vector-push-extend 'a *x*)
;tworzenie do zmiennej
;(defparameter *x* (make-array 5 :fill-pointer 0 :adjustable t))

