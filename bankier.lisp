;;;; Created on 2011-10-02 00:32:04
;D:\\DEV\\projects\\practical-common-lisp-sandbox\\
(defun read-file (file-path)
  (with-open-file (input file-path)
                  (loop 
                   for row = (read-line input nil)
                   while row
                   collect row)))

(defun split (string &optional (delimiter #\Space))
  (loop for i = 0 then (+ j 1)
        for j = (position delimiter string :start i)
        collect (subseq string i j)
        while j))

(defun get-table (string-list)
  (loop for row in string-list
        collect (split row #\Tab)))

(defun get-row-data (cells column-def)
  (loop ;with result = (make-array 5 :fill-pointer 0 :adjustable t)
        for cell in cells 
        for col in column-def
        ;do (vector-push-extend (append col (list cell)) result)))
        ;do (print column-def)
        collect (append col (list (read-from-string cell)))))

(defun get-column-def (string-list)
 #| (loop with result = (make-array 5 :fill-pointer 0 :adjustable t)
        for i in (split (car string-list) #\Tab) 
        do
         (vector-push-extend (list i) result)
        finally (return result)))|#
  (loop for i in  (split (car string-list) #\Tab) collect (list i)))

(defun get-column-data (string-list)
  (let ((columns (get-column-def string-list)))
    (loop 
     for row in (cdr string-list)
     for cells = (split row #\Tab)
     do
     (setf columns (get-row-data cells columns))) 
     ;(print columns))
    columns))

;(get-table (read-file "D:\\DEV\\projects\\practical-common-lisp-sandbox\\bankier-data\\price_pop_VISTULA.txt"))
;(get-column-data (read-file "D:\\DEV\\projects\\practical-common-lisp-sandbox\\bankier-data\\price_pop_VISTULA.txt"))
;(get-column-data (read-file "D:\\DEV\\projects\\practical-common-lisp-sandbox\\bankier-data\\sample.txt"))

(defun aver (xs)
  (loop 
   for x in xs 
   summing x into total
   count x into count  
   finally (return (/ total count))))

(defun corelation (xs ys)
  (loop for aver-x = (aver xs)
  for aver-y = (aver ys)
  for x in xs
  for y in ys
  summing (* (- x aver-x) (- y aver-y)) into summ-of-diffs
  summing (expt (- x aver-x) 2) into x-diff-pow
  summing (expt (- y aver-y) 2) into y-diff-pow 
  finally (return (/ summ-of-diffs (* (expt x-diff-pow 1/2) (expt y-diff-pow 1/2))))))


(defun calc-corelation (data-list x-index y-index)
  ;zmiana a popularnosc
  (corelation (cdr (nth x-index data-list)) (cdr (nth y-index data-list))))

(defun corelate-price-pop (file-path)
  (calc-corelation (get-column-data (read-file file-path)) 2 11))

(defun corelate-columns (file-path x y)
  (calc-corelation (get-column-data (read-file file-path)) x y))

;(calc-price-pop-corel (cdr (get-column-data (read-file "D:\\DEV\\projects\\practical-common-lisp-sandbox\\bankier-data\\sample.txt"))))