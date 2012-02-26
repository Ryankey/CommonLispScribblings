;;;; Created on 2011-09-14 00:19:52



#||#

;(loop for f in '((= 1 2) (= 2 2)) collect (format t "~a~%" f))
;(macroexpand-1 '(check (= (+ 1 2 1) 4) (= (+ 23 1) 123)))

;!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
; FINAL VERSION TEST FRAMEWORK
;!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!

(defvar *test-name* nil)

(defmacro with-gensyms ((&rest varnames) &body forms)
  "Wraps body 'forms' in a let with a all variables defined in varnames (gemsym)'ed to avoid leaky abstraction"
  `(let ,(loop for var in varnames collect `(,var (gensym)))
     ,@forms))

(defun report-result (result expression)
   "Report the results of a single test case. Called by 'check'."
  (format t "~:[FAIL~;pass~] ... ~a: ~a~%" result *test-name* expression)
  result)


(defmacro combine-results (&body expr)
   "Combine the results (as booleans) of evaluating 'expr' in order."
  (with-gensyms (result)
                `(let ((,result t))
                   ,@(loop for e in expr collect `(unless ,e (setf ,result nil)))
                   ,result)))

(defmacro check (&body expr)
   "Run each expression in 'expr' as a test case."
  `(combine-results
     ,@(loop for e in expr collect `(report-result ,e ',e))))


(defmacro deftest (name parameters &body body)
   "Define a test function. Within a test function we can call
   other test functions or use 'check' to run individual test
   cases."
  `(defun ,name ,parameters 
     (let ((*test-name* (append *test-name* (list',name))))
       ,@body)))
;!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!

(deftest test+- ()
    (check 
    (= (+ 1 2 1) 4)
    (= (- 4 1) 3)
    (= (+ 99 23 1) 123)))

(deftest test* ()
    (check 
    (= (* 2 2) 4)
    (= (* 2 2 4) 15)))


(deftest test-arithmetic ()
  (test+-)
  (test*))

(deftest test-math ()
  (test-arithmetic))

#|
;VERSION 1 naive
(defun test+- () 
    (format t "~:[FAIL~;pass~] ... ~a~%" (= (+ 1 2 1) 4) '(= (+ 1 2 1) 4))
    (format t "~:[FAIL~;pass~] ... ~a~%" (= (- 4 1) 3) '(= (+ 1 2 1) 4))
    (format t "~:[FAIL~;pass~] ... ~a~%"  (= (+ 23 1) 123) '(= (+ 1 2 1) 4)))


;VERSION 2 VARIABLE ABSTRACTION
(defun test+- () 
  (let ((print-template "~:[FAIL~;pass~] ... ~a~%"))
    (format t print-template (= (+ 1 2 1) 4) '(= (+ 1 2 1) 4))
    (format t print-template (= (- 4 1) 3) '(= (+ 1 2 1) 4))
    (format t print-template  (= (+ 23 1) 123) '(= (+ 1 2 1) 4))))

;VERSION 3 function abstraction
(defun report-result (result expression)
  (format t "~:[FAIL~;pass~] ... ~a~%" result expression))

(defun print-test+- () 
    (report-result (= (+ 1 2 1) 4) '(= (+ 1 2 1) 4))
    (report-result (= (- 4 1) 3) '(= (+ 1 2 1) 4))
    (report-result  (= (+ 23 1) 123) '(= (+ 1 2 1) 4)))


;VERSION 4 macros
(defmacro check (expr)
  `(report-result ,expr ',expr))

(defun test+- ()
  (check (= (+ 1 2 1) 4))
  (check (= (- 4 1) 3))
  (check (= (+ 23 1) 123)))

;VERSION 5 removed macro call duplication

;(loop for f in '((= 1 2) (= 2 2)) collect (format t "~a~%" f))
;(macroexpand-1 '(check (= (+ 1 2 1) 4) (= (+ 23 1) 123)))
(defmacro check (&body expr)
  `(progn
     ,@(loop for e in expr collect `(report-result ,e ',e))))

(defun test+- ()
  (check 
    (= (+ 1 2 1) 4)
    (= (- 4 1) 3)
    (= (+ 23 1) 123)))

;VERSION 6 error reporting
(defmacro with-gensyms ((&rest varnames) &body forms)
  `(let ,(loop for var in varnames collect `(,var (gensym)))
     ,@forms))
        

(defmacro params ((&rest names) &body forms)
  (format t "~a~%" names)
  (format t "~a~%" forms))

(defmacro combine-results (&body expr)
  (with-gensyms (result)
                `(let ((,result t))
                   ,@(loop for e in expr collect `(unless ,e (setf ,result nil)))
                   ,result)))

(defmacro check (&body expr)
  `(combine-results
     ,@(loop for e in expr collect `(report-result ,e ',e))))

(defun test+- ()
  (check 
    (= (+ 1 2 1) 4)
    (= (- 4 1) 3)
    (= (+ 99 23 1) 123)))

|#

