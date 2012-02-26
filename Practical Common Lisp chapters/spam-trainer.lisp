;;;; Created on 2011-09-25 19:26:50
(in-package :com.nabacg.spam)

;USAGE
;TEST DATA LOADING
;(add-directory-to-corpus "d:\\Spam\\spam" 'spam *corpus*)
;(add-directory-to-corpus "d:\\Spam\ham" 'ham *corpus*)
; ANALYZE WHOLE SET
;(analyze-results (test-classifier *corpus* 0.3d0))
; EXPLAIN FILE
;(explain-classification  "d:\\Spam\\spam\\00097.013347cc91e7d0915074dccb0428883f")
;CLASSIFY SINGLE FILE
;(classify (start-of-file  "d:\\Spam\\spam\\00002.d94f1b97e48ed3b553b3508d116e6a09" *max-chars*))



;(train "XXX PORN SEX stuff" 'spam)
;(train "EARN 1000 $$$$ XXXX PORN SEX stuff" 'spam)
;(train "Hello John, hope you are well. How are things at home? Kind regards Stephen" 'ham)
;(train "Dear Anna, hope you are well. You are doing some weird stuff with this new language of yours.. Kind regards Andrew" 'ham)
;potem:
; (gethash "SEX" *feature-database*)
; (gethash "Kind" *feature-database*)
(defun train (text type)
    
  "Trenowanie filtra, podajemy tekst oraz TYP type in ('spam 'ham 'unsure)))"
  (dolist (feature (extract-features text))
    (increment-count feature type))
  (increment-total-count type))
 
;(increment-count (gethash "seksu" *feature-database*) 'spam)

(defun increment-count (feature type)
  "powieksza ham-count lub spam-count w zaleznosci od typu"
  (ecase type
         (ham (incf (ham-count feature)))
         (spam (incf (spam-count feature)))))

; totals number of messages for each category
; stored here
(defvar *total-spams* 0)
(defvar *total-hams* 0)

(defun increment-total-count (type)
  (ecase type
         (ham (incf *total-hams*))
         (spam (incf *total-spams*))))

(defparameter *corpus* (make-array 1000 :adjustable t :fill-pointer 0)) 

;adding test data
(defun add-file-to-corpus (filename type corpus)
  (vector-push-extend (list filename type) corpus))

(defun add-directory-to-corpus (dir type corpus)
  (dolist (file (list-directory dir))
    (add-file-to-corpus file type corpus)))

(defun test-classifier (corpus testing-fraction)
  (clear-database)
  (let* ((shuffled (shuffle-vector corpus))
         (size (length corpus))
         (train-on (floor (* size (- 1 testing-fraction)))))
                   (train-from-corpus shuffled :start 0 :end train-on)
                   (test-from-corpus shuffled :start train-on)))

(defparameter *max-chars* (* 10 1024))


(defun train-from-corpus (corpus &key (start 0) end)
  (loop for idx from start below (or end (length corpus)) do
        (destructuring-bind (file type) (aref corpus idx)
                            (train (start-of-file file *max-chars*) type))))

(defun test-from-corpus (corpus &key (start 0) end)
  (loop for idx from start below (or end (length corpus)) collect
        (destructuring-bind (file type) (aref corpus idx)
                            (multiple-value-bind (classification score)
                              (classify (start-of-file file *max-chars*))
                              (list 
                                    :file file
                               :type type
                               :classification classification
                               :score score)))))

#|(defun test-from-corpus (corpus &key (start 0) end)
  (loop for idx from start below (or end (length corpus)) collect
        (destructuring-bind (file type) (aref corpus idx)
          (multiple-value-bind (classification score)
              (classify (start-of-file file *max-chars*))
            (list 
             :file file
             :type type
             :classification classification
             :score score)))))|#

(defun shuffle-vector (vector)
  (nshuffle-vector (copy-seq vector)))

(defun nshuffle-vector (vector)
  (loop for idx downfrom (1- (length vector)) to 1
        for other = (random (1+ idx))
        do (unless (= idx other)
             (rotatef (aref vector idx) (aref vector other))))
  vector)

(defun start-of-file (file max-chars)
  (with-open-file (input file)
                  (let* ((length (min (file-length input) max-chars))
                         (text (make-string length))
                         (read (read-sequence text input)))
                    (if (< read length)
                        (subseq text 0 read))
                    text)))

(defun result-type (result)
  (destructuring-bind (&key type classification &allow-other-keys) result
                      (ecase type
                             (ham 
                              (ecase classification
                                     (ham 'correct)
                                     (spam 'false-positive)
                                     (unsure 'missed-ham)))
                             (spam
                              (ecase classification
                                     (ham 'false-negative)
                                     (spam 'correct)
                                     (unsure 'missed-spam))))))

(defun false-positive-p (result)
  (eql (result-type result) 'false-positive))

(defun false-negative-p (result)
  (eql (result-type result) 'false-negative))

(defun missed-ham-p (result)
  (eql (result-type result) 'missed-ham))

(defun missed-spam-p (result)
  (eql (result-type result) 'missed-spam))

(defun correct-p (result)
  (eql (result-type result) 'correct))

; (add-directory-to-corpus "d:\\Spam\\spam" 'spam *corpus*)
; (add-directory-to-corpus "d:\\Spam\ham" 'ham *corpus*)

(defun analyze-results (results)
  (let* ((keys '(total correct false-positive 
                       false-negative missed-ham missed-spam))
         (counts (loop for x in keys collect (cons x 0))))
    (dolist (item results)
      (incf (cdr (assoc 'total counts)))
      (incf (cdr (assoc (result-type item) counts))))
    (loop with total = (cdr (assoc 'total counts))
          for (label . count) in counts
          do (format t "~&~@(~a~):~20t~5d~,5t: ~6,2f%~%"
                     label count (* 100 (/ count total))))))

(defun show-summary (file text classification score)
  (format t "~&~a" file)
  (format t "~2%~a~2%" text)
  (format t "Classified as ~a with score of ~,5f~%" classification score))

(defun explain-classification (file)
  (let* ((text (start-of-file file *max-chars*))
         (features (extract-features text))
         (score (score features))
         (classification (classification score)))
    (show-summary file text classification score)
    (dolist (feature (sorted-interesting features))
      (show-feature feature))))

(defun show-feature (feature)
  (with-slots (word ham-count spam-count) feature
   (format
     t "~&~2t~a~30thams: ~5d; spams: ~5d;~,10tprob: ~,f~%"
     word ham-count spam-count (bayesian-spam-probability feature))))

(defun sorted-interesting (features)
  (sort (remove-if #'untrained-p features) #'< :key #'bayesian-spam-probability))