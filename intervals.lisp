(defclass interval-node ()
	  ((low :initarg :low :accessor low)
	  (high :initarg :high :accessor high)
	  (left :initarg :left :accessor left)
	  (right :initarg :right :accessor right)))

(defun partition (input)
  ;(partition '("1:5" "3:8"))
  (let ((nodes (mapcar #'create-node input))
	(root '())
	(result '()))
    (loop for n in nodes
	 do (add-interval root n #'(lambda (n) (setf root n))))
    (traverse root #'(lambda (n) (push n result)))
    (mapcar #'(lambda (n)
		(format nil "~a:~a" 
			(low n) (high n))) (reverse result))))

(defparameter *root* nil)

(defun create-node (input)
"creates node instance out of single string interval input like 1:4
returns interval-node object"
; (high (create-node "1:4"))
  (let ((bounds (string-split input #\:)))
    (make-node (parse-integer (car bounds)) (parse-integer (cadr bounds)))))

(defun make-node (low high)
      (make-instance 'interval-node :low low
		   :high high
		   :left '()
		   :right '()))

(defun add-interval (parent node insert-node)
  ;(print parent)
  (cond 
    ((not parent) (progn
		    (print parent)
		    (funcall insert-node node)
		    (print parent)))
    ;if less then left side
    ( (< (high node) (low parent))
     ;add to the left)
     (add-interval (left parent) node #'(lambda (n) 
					  (setf (left parent) n))))
    ((> (low node) (high parent))
	 ;add to the right
	 (add-interval (right parent) node #'(lambda (n)
					       (setf (right parent) n))))
    (t (resolve-collision parent node ))))
			

(defun interval-member (node i)
  (and (>= i (low node)) (<= i (high node))))

(defun resolve-collision (a b)
  (let ((lower-bound (if (< (low a) (low b))
			 (low a)
			 (low b)))
	(higher-bound (if (> (high a) (high b))
			  (high a)
			  (high b)))
	(mid-low (if (< (low a) (low b))
		     (low b)
		     (low a)))
	(mid-high (if (> (high a) (high b))
		      (high b)
		      (high a))))
    ;(format t "~a ~a ~a ~a ~%" lower-bound mid-low mid-high higher-bound)
    ;first set the new parent object to bounds of intersection
    (setf (low a) mid-low)
    (setf (high a) mid-high)

    ;check if a\b is a not empty set if a difference between mid-low-1 and low is more than zero, i.e. if [lower-bound, mid-low) is a non empty set
    (if (> mid-low lower-bound) 
	(add-interval (left a)
		      (make-node lower-bound (- mid-low 1))
		      #'(lambda (n) (setf (left a) n))))

    
    (if (> higher-bound mid-high)
	(add-interval (right a)
		      (make-node (+ mid-high 1) higher-bound)
		      #'(lambda (n) (setf (right a) n))))))
  
(defun test ()
  #|

    Tests from Task Definition
    E2: {} ==> {} 
    E3: {0:9999} ==> {0:9999} 
    E4: {10:21,10:21} ==> {10:21}
    E5: {6:10,3:10} ==> {3:5,6:10} 
    E6: {1:10,3:5} ==> {1:2,3:5,6:10}
    E7: {6:7,1:8,2:4,5:7,2:3} ==> {1:1,2:3,4:4,5:5,6:7,8:8}
    E8: {1:99,6:10,3:10} ==> {1:2,3:5,6:10,11:99}

  |#
  (print (partition '("1:2" "3:4" "6:10")))
  (print (partition '()))
  (print (partition '("0:9999")))
  (print (partition '("10:21" "10:21")))
  (print (partition '("6:10" "3:10")))
  (print (partition '("1:10" "3:5")))
  (print (partition '("6:7" "1:8" "2:4" "5:7" "2:3")))
  (print (partition '("1:99" "6:10"  "3:10")))

;perf test
  (print (partition '("1:199" "600:10241"  "300:1000" "33:77" "123:1500" "301:305"
		      "4:6" "5:6" "601:777" "555:777" "777:1001" "4:10000000")))

)
 

(defun traverse (node operation)
  (if node
      (progn
	(traverse (left node) operation)	
	(funcall operation node)
	(traverse (right node) operation))
      nil))

(defun print-tree ()
  (traverse *root* #'(lambda (n) 
		       (format t "~a:~a~%" (low n) (high n)))))
  
