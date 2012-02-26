(defparameter *location* 'living-room)

(defparameter *nodes* '((living-room (you are in a living room.
				      a wizart is snoring loudly on the couch))
			(garden (you are in a garden. there is a well in front
				 of you))
			(attic (you are in the attic. there is a giant torhc in the
				corner))))

(defparameter *edges* '((living-room (garden west door)
			 (attic upstairs ladder))
			(garden (living-room east door))
			(attic (living-room downstairs ladder))))

(defparameter *objects* '(whiskey bucket frog chain))

(defparameter *object-locations* '((whiskey living-room)
				   (bucket living-room)
				   (chain garden)
				   (frog garden)))

(defun look ()
  (append 
   (describe-location *location* *nodes*)
   (describe-paths *location* *edges*)
   (describe-objects *location* *objects* *object-locations*)))

(defun walk (direction)
  (let ((next-loc (find direction (cdr (assoc *location* *edges*)) :key #'cadr)))
    (if next-loc
	(progn
	  (setf *location* (car next-loc))
	  (look))
	'(you cannot go in this direction))))

(defun objects-at (location objects object-locations)
  (remove-if-not #'(lambda (obj)
		     (eq (cadr (assoc obj object-locations)) location)) objects))

(defun inventory ()
  (cons 'items- (objects-at 'body *objects* *object-locations*)))

(defun pick-object (object)
  (cond ((member object (objects-at *location* *objects* *object-locations*))
	 (push (list object 'body) *object-locations*)
	 `(you are now carrying the ,object))
	(t '(you cannot get that))))

(defun objects-at-alt (location object-locations)
  (remove-if-not #'(lambda (x) x)
   (mapcar #'(lambda (o) 
	       (check-object location objects o)) object-locations)))

(defun describe-objects (loc objs object-loc)
  (apply #'append (mapcar #'(lambda (obj) 
			      `(you see a ,obj on the floor.))
			  (objects-at loc objs object-loc))))



(defun check-object (location pair)
  (if (eq location (cadr pair))
      (car pair)
      nil))

(defun describe-location (location nodes)
  (second (assoc location nodes)))

;(defun describe-path (from to edges)
;  (cdr (assoc to (cdr (assoc from edges)))))

(defun describe-path (edge)
  `(there is a ,(caddr edge) going ,(cadr edge) from here.))

(defun describe-paths (location edges)
  (apply #'append (mapcar #'describe-path (cdr (assoc location edges)))))
  



;(describe-path
;		     'garden 'living-room *edges*)

;(describe-paths 'living-room *edges*)
; (append '(mary) '(had a)  '(little lamb))

;(apply #'append '((mary) (had a) (little chainsaw)))

;(defun game-repl ()
;  (loop (print (eval (read)))))

(defun game-repl ()
  (let ((cmd (game-read)))
;    (print cmd)
    (unless (member 'quit cmd)
      (game-print (game-eval cmd))
      (game-repl))))

(defun game-read ()
  (let ((cmd (read-from-string (concatenate 'string "(" (read-line) ")"))))
    (cons (car cmd) (mapcar #'(lambda (item) (list 'quote item)) (cdr cmd)))))

(defparameter *allowed-commands* '(look walk pick-object inventory))

(defun game-eval (sexpr)
  (if (member (car sexpr) *allowed-commands*)
      (eval sexpr)
      '(Unknown command)))

(defun tweak-text (lst caps lit)
  (when lst
    (let ((item (car lst)) 
	  (rest (cdr lst)))
      (cond
	((eq item #\space) (cons item (tweak-text rest caps lit)))
	((member item '(#\! #\? #\.)) (cons item (tweak-text rest t lit)))
	((eq item #\") (tweak-text rest caps (not lit)))
	(lit (cons item (tweak-text rest nil lit)))
      ((or caps lit) (cons (char-upcase item) (tweak-text rest nil lit)))
      (t (cons (char-downcase item) (tweak-text rest nil nil)))))))


(defun game-print (sexp)
  (princ (coerce 
	  (tweak-text 
	   (coerce (string-trim "() " (prin1-to-string sexp)) 
		   'list)
	   t
	   nil)
	   'string)))


(defun dot-name (exp)
  (substitute-if #\_ (complement #'alphanumericp) (prin1-to-string exp)))

(defparameter *max-label-len* 30)

(defun dot-label (exp)
  (if exp
      (let ((str (write-to-string exp :pretty nil)))
	(if (> (length str) *max-label-len*)
	    (concatenate 'string (subseq str 0 (- *max-label-len* 3)) "...")
	    str))
      ""))

(defun nodes->dot (nodes)
  (mapc #'(lambda (node)
	  (fresh-line)
	  (princ (dot-name (car node)))
	  (princ "[label=\"")
	  (princ (dot-label node))
	  (princ "\"];"))
	nodes))
		
;(living-room (garden west door)
;			 (attic upstairs ladder))

(defun edges->dot (edges)
  (generic-edges->dot edges #'(lambda ()
				" -> ")))
#|  (mapc #'(lambda (edge)
	    (mapc #'(lambda (target) 
		      (fresh-line)
		      (princ (dot-name (car edge)))
		      (princ " -> ")
		      (princ (dot-name (car target)))
		      (princ "[label=\"")
		      (princ (dot-label (cdr target)))
		      (princ "\"];")
		      )
		  (cdr edge))
	    )
	edges))
|#

(defun uedges->dot (edges)
  (generic-edges->dot edges #'(lambda ()
				" -- ")))

(defun generic-edges->dot (edges get-edge-symbol)
  (mapc #'(lambda (edge)
	    (mapc #'(lambda (target) 
		      (fresh-line)
		      (princ (dot-name (car edge)))
		      (princ (funcall get-edge-symbol))
		      (princ (dot-name (car target)))
		      (princ "[label=\"")
		      (princ (dot-label (cdr target)))
		      (princ "\"];")
		      )
		  (cdr edge))
	    )
	edges))

(defun uedges->dot (edges)
   (mapc #'(lambda (edge)
	     (mapc #'(lambda (target)
		       (fresh-line)
		       (princ (dot-name (car edge)))
		       (princ " -- ")
		       


(defun graph->dot (nodes edges)
  (princ "digraph{")
  (nodes->dot nodes)
  (edges->dot edges)
  (princ "}"))

(defun ugraph->dot (nodes edges)
  (princ "graph{")
  (nodes->dot nodes)
  (uedges->dot edges)
  (princ "}"))

(graph->dot *nodes* *edges*)

(defun dot->png (file-path thunk)
  (with-open-file (*standard-output*
		   file-path
		   :direction :output
		   :if-exists :supersede)
    (funcall thunk))
  (shell (concatenate 'string "neato -Tpng -O" file-path)))

(defun shell (cmd)
  (sb-ext:run-program "/bin/sh" (list "-C" cmd) :output t))


(defun graph->png (file-path)
  (dot->png file-path #'(lambda ()
			    (graph->dot *nodes* *edges*))))

(defun ugraph->png (file-path)
  (dot->png file-path #'(lambda ()
			  (ugraph->dot *nodes* *edges*))))
			   