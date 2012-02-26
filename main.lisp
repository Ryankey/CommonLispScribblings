;;;; 2011-01-06 21:54:57
;;;; This is your lisp file. May it serve you well.

;(in-package :mp3-database)

;moj pierwszy program w lispie
;MP3 database

;zmienna globalna przechowujaca dane
(defvar *db* nil)
(defvar *db-file-path* "d:\\DEV\\projects\\mp3-database\\mp3_database.db")

;funkcje wykonujace operacje na danych
; tworzenie rekordow CD
(defun make-cd (title artist rating ripped)
  (list :title title :artist artist :rating rating :ripped ripped))
;dodawanie rekordow do bazy
(defun add-record (cd) 
  (push cd *db*))
;wyswietlanie zawartosci bazy
(defun dump-db ()
  (format t "~{~{~a: ~4t~a~%~}~%~}" *db*))

;pytanie o wartosc
(defun prompt-read (prompt)
  (format *query-io* "~a: " prompt)
  (force-output *query-io*)
  (read-line *query-io*)) 

;dodawanie plyt z konsoli
(defun prompt-for-cd ()
  (make-cd
   (prompt-read "Title")
   (prompt-read "Artist")
   (or (parse-integer (prompt-read "Rating") :junk-allowed  t) 0)
   (y-or-n-p "Ripped [y/n]")))

(defun add-cds ()
  (loop 
        (if (not (y-or-n-p "Add cd? [y/n] : ")) (return))
        (add-record (prompt-for-cd))))

; saving mp3 data to file
; filepath - path to db file
(defun save-db (filepath)
  (with-open-file (out filepath
                   :direction :output
                   :if-exists :supersede)
    (with-standard-io-syntax
      (print *db* out))))

;LOADING mp3 data from file
; filepath - path to db file
(defun load-db (filepath)
  (format t "-------------------------MP3 database loading-------------------------------------------~%")
  (with-open-file (in filepath)
    (with-standard-io-syntax
      (setf *db* (read in)))))

(defun select-artist (name)
  (remove-if-not #'(lambda (cd) (equal (getf cd :artist) name)) *db*))

;(remove-if-not #'(lambda (x) (getf x :a)) (list (list :a 1 :b 2 :c 3) (list :a 1  :c 3 :d 4))) 
(defun select (selector-fn)
  (remove-if-not selector-fn *db* ))

(defun artist-selector (name)
  #'(lambda (cd)
      (equal (getf cd :artist) name)))

(defun null? (v)
  (equal nil v))

;where selector generator
; MY ATTEMPT TO WHERE
; Working but not that feature-full
;(defun where (&key artist title rating (ripped nil ripped-n))
;  (cond
;    ( (not (null artist)) #'(lambda (cd) (equal (getf cd :artist) artist)))
;    ( (not (null title)) #'(lambda (cd) (equal (getf cd :title) title)))
;    ( (not (null rating)) #'(lambda (cd) (equal (getf cd :rating) rating)))
;    ( (not (null ripped-n)) #'(lambda (cd) (equal (getf cd :ripped) ripped-n)))))

(defun where-oldk (&key artist title rating (ripped nil ripped-provided))
  #'(lambda (cd)
      (and 
       (if artist (equal (getf cd :artist) artist) t)
       (if title (equal (getf cd :title) title) t)
       (if rating (equal (getf cd :rating) rating) t)
       (if ripped-provided (equal (getf cd :ripped) ripped) t))))

(defun update (selector-fn &key artist title rating (ripped nil ripped-provided))
  (setf *db*
        (mapcar 
         #'(lambda (row)
             (when (funcall selector-fn row)
               (if artist (setf (getf row :artist) artist))
               (if title (setf (getf row :title) title))
               (if rating (setf (getf row :rating) rating))
               (if ripped-provided (setf (getf row :ripped) ripped)))
         ;po modyfikacjach zwracamy row
         row)
                *db*)))

(defun delete-rows (selector-fn)
  (setf *db* (remove-if selector-fn *db*)))
;macro time
(defun make-comparison-expr (field value)
  (list 'equal (list 'getf 'cd field) value))

(defun make-comparison-list (fields)
  (loop while fields
        collecting (make-comparison-expr (pop fields) (pop fields))))

(defmacro where (&rest clauses)
  `#'(lambda (cd) (and ,@(make-comparison-list clauses))))


;(remove-if-not #'(lambda (x) (= 1 (getf x 'b))) (list :a 1 :b 2 :c 3))
;(remove-if-not #'(lambda (x) (= 0 (mod x 2))) '(1 2 3 4 5 6 7 8 9 10))

;czyszczenie *DB*
;(setf *db* nil)
;(add-record (make-cd "Oda Stefana do Zoski" "Stefan Burak" 1 t))
;(add-record (make-cd "Oda Stafana do zielonego Stara z weglem" "Stefan Bura" 2 t))
;(add-record (make-cd "Roses" "Kathy Melua" 6 t))
;(add-record (make-cd "Fly" "Dixie Chicks" 3 nil))
;(dump-db)


(load-db *db-file-path*)
;(add-cds)      
(save-db *db-file-path*)

(dump-db)
