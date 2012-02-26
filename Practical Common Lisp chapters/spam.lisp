;;;; Created on 2011-09-25 17:33:41
(in-package :com.nabacg.spam)


(defclass word-feature ()
  ((word
    :initarg :word
    :accessor word
    :initform (error "Must supply word")
    :documentation "The word this feature represents")
   (spam-count 
    :initarg :spam-count
    :accessor spam-count
    :initform 0
    :documentation "Number of spams this word was in.")
   (ham-count 
    :initarg :ham-count
    :accessor ham-count
    :initform 0
    :documentation "Number of ham emails this word was in")))

(defun main ()
  (format *query-io* "Please provide text to classify")
  (classify (read-line *query-io*)))

(defun classify (text)
  (classification (score (extract-features text))))

(defparameter *max-ham-score* .4)
(defparameter *min-spam-score* .6)


(defun classification (score)
  "returning multiple values"
  (values (cond
    ((<= score *max-ham-score*) 'ham)
    ((>= score *min-spam-score*) 'spam)
    (t 'unsure))
  score))

(defun extract-features (text)
  (mapcar #'intern-feature (extract-words text)))

;(classification .2) => ham
;(eql (classification .2) 'ham)
;(eql (classification .6) 'spam)
;(eql (classification .45) 'unsure)

;sprawdaznie czy slowo juz jest bazie (dodawanie jezeli nie)
(defun intern-feature (word)
  "Zwraca slowo z hashtablicy lub tworzy je, dodaje do tablicy i zwraca jezeli jeszcze go nie ma"
  (or 
   (gethash word *feature-database*)
   (setf (gethash word *feature-database*) 
         (make-instance 'word-feature :word word))))

;rozpylanie stringa na slowa
(defun extract-words (text)
  "Splituje stringa na slowa zgodnie z RegExem [a-zA-Z]{3,} (czyli wszystkie lower i upper case letters) 
   dlugosci przynajmniej 3 chary"
  (delete-duplicates 
   (all-matches-as-strings "[a-zA-Z0-9]{3,}" text) :test #'string= ))

(defmethod print-object ((object word-feature) stream)
  (print-unreadable-object (object stream :type t)
                           (with-slots (word ham-count spam-count) object
                                       (format stream "~s :hams ~d :spams ~d" word ham-count spam-count))))

;(extract-words "Anna powiedziala mi wczoraj, ze boli ja dupa i z seksu nici")

;lista slow w globalnej zmiennej !!!!
(defvar *feature-database* (make-hash-table :test #'equal))

;reset bazy
(defun clear-database ()
  (setf *feature-database* (make-hash-table :test #'equal)))


; clasa word-feature


;(make-instance 'word-feature :word "dupa") 
;(make-instance 'word-feature :word "dupa" :spam-count 120 :ham-count 2)
;(make-instance 'word-feature :word "dupa")  => FAIL
