#|in case db is empty and you feel lazy:
(defvar *db* ((:TITLE "Amaranth" :ARTIST "nightwish" :RATING 2 :RIPPED NIL)
 (:TITLE "Sleeping sun" :ARTIST "Nightwish" :RATING 100 :RIPPED T)
 (:TITLE "Carpenter" :ARTIST "Nightwish" :RATING 23 :RIPPED T)
 (:TITLE "Amaranth" :ARTIST "Nightwish" :RATING "5" :RIPPED "t")
 (:TITLE "Angels Fall First" :ARTIST "Nightwish" :RATING 9 :RIPPED NIL)
 (:TITLE "Sweet child of mine" :ARTIST "Guns & Roses" :RATING 3 :RIPPED T)
 (:TITLE "One million bicycles" :ARTIST "Katie Melua" :RATING 3 :RIPPED T)))
|#

(defun hello-world ()
	(format t "hello world"))


	
(defun say (word)
	(format t word))
;zapisuje stringa do pliku
(defun save-to-file (filename content)
  (with-open-file 
     (fstream filename 
      :direction :output
      :if-exists :supersede) 
        (with-standard-io-syntax 
          (print content fstream))))

;return a content of file as string or expression
; np
; wypisanie zawartosci na konsole
; (format t "~a" (load-file "d:/dev/projects/practical-common-lisp-sandbox/sandbox.txt"))
; zwrocenie w stringu
; (format nil "~a" (load-file "d:/dev/projects/practical-common-lisp-sandbox/sandbox.txt"))
(defun load-file (filename)
  (with-open-file (inputstream filename)
                  (with-standard-io-syntax 
                                            (read inputstream))))

;zapisuje do podrecznego pliku
; przykladowe uzycie
; (sandbox-save (format nil "~{~{~a:~10t~a~%~}~%~}~%" *db*))
(defun sandbox-save (content)
              (save-to-file "d:/dev/projects/practical-common-lisp-sandbox/sandbox.txt" content))

