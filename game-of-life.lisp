;;;; Created on 2011-10-05 21:36:18


;get-x-bounds
(defun get-bounds (hash-table)
  ; iterate over hash-table 
  (loop for (x y) being the hash-keys in hash-table
        maximizing x into max-x
        minimizing x into min-x
        maximizing y into max-y
        minimizing y into min-y
        ;and return max-x and min-x min-y and max-y bounds
        finally (return (list min-x max-x min-y max-y))))



;init-living-cells of N
; fix the random generation as it's screwing things
(defun create-living-cells (hash-table &optional (n 10) (density 6))
  ;for random random number times
  (loop for i upto (* density n)
        ; create a random (X,Y) pair both between bounds of (0,N)
        for x = (random n)
        for y = (random n)
        do
        ; add this value to *living-ones*
        (setf (gethash (list x y) hash-table ) t)))

(defun get-neighbours (x y hash-table)
  (let ((count 0))
     	(loop for i from (- 1 y) upto (+ 1 y)
        	do (loop for j from (- 1 x) upto (+ 1 x)
                 	do (if (gethash (list j i) hash-table)
                 	       (incf count))))
    count))
 

;get-next-state (x,y)
(defun get-next-state (x y hash-table)
  ; call get-living-neighbours-count of X, Y, *living-ones*
  (let ((n (get-neighbours x y hash-table)) (alive (gethash (list x y) hash-table)))
   (cond 
     ;  if count less then 2 or more then 3 => return false
      ((or (< n 2) (> n 3))  nil)
     ;  if count equals 3 => true
      ((= n 3) t)
     ;   if count equals 2 and is alive = >true
      ((and (= n 2) alive) t)
     ;    return false
      (t nil ))))
#|1.Any live cell with fewer than two live neighbours dies, as if caused by under-population.
 2.Any live cell with two or three live neighbours lives on to the next generation.
 3.Any live cell with more than three live neighbours dies, as if by overcrowding.
 4.Any dead cell with exactly three live neighbours becomes a live cell, as if by reproduction.|#



;tick function

(defun tick (current-generation)
  (let ( (next-generation (make-hash-table :test #'equal)))
    ; create new hash-table *living-ones-temp*
    (destructuring-bind (min-x max-x min-y max-y) (get-bounds  current-generation) ; call get-bounds on living ones
                        ;for y between vertical bounds
                        (loop for y from (- min-y 1) upto (+ max-y )
                              ; for x in horizontal bounds
                              do (loop for x from (- min-x 1) upto (+ max-x 1)
                                       ;   call get-next-state for (x,y) 
                                       do (if (get-next-state x y current-generation)
                                              ;   if next state is true
                                              ;     add to *living-ones-temp*
                                              (setf (gethash (list x y) next-generation) t)
                                              ))))
    ;   save new state in *living-ones-temp*
    next-generation))




;print-board
(defun print-game (generation)
  (destructuring-bind (min-x max-x min-y max-y) (get-bounds generation)
                      ; from y lower bound to upper bound
                    (loop for y from (- min-y 1) upto (+ max-y )
                          ; from x lower bound to upper boud
                          do (loop for x from (- min-x 1) upto (+ max-x 1) do
                                   ;  if (x,y) in *living-ones*
                                   (if (gethash (list x y) generation)  
                                       ;    print *
                                       (format t "*"g)
                                       ; else   print _ 
                                       (format t "_")))
                          (format t "~%"))))


;start-game function
(defun start-game (&optional(N 10))
  (let ((current-generation (make-hash-table :test #'equal)))
    ;call create-living-cells
    (create-living-cells current-generation N 8)
    (dotimes (i 10)
    ; call print-board function
    (print-game current-generation)
    ; call tick function
    (setf current-generation (tick current-generation))
    ; check for keyboard interrupt
    ; clear console
    (clear-output)
    (format t "!!!!!!!!!!!!!!!!!!!!!!~%~%"))))




