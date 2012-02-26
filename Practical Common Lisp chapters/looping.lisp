;;;; Created on 2011-09-29 21:12:45
;WYGENEROWANIE 100 LICZB LOSOWYCH W PRZEDZIALE DO 100,000
(loop repeat 100 collect (random 100000))

; iterowanie po kilku zmiennych czyli iterowanie po 2 kolekcjach na raz
(loop for item in '(a b c d e f g h)
      for i from 1 to 10  do 
      (format t "~a ~a ~%" i item))

; a teraz od 1 - 10 co 2
(loop for item in '(a b c d e f g h)
      for i from 1 to 10 by 2 do 
      (format t "~a ~a ~%" i item))


; a tu iteracja po 3 kolekcjach, kazdej innej na raz!
;prosciej
(loop for item in '(a b c d e f g h e f g h i j)
      for i from 0 to 10 by 1 
      for c across "Ala ma kota, angine i dosc AGH" do
      (format t "~a ~a ~a ~%" i item c))

; albo trudniej z wyciaganiem CHAR'ow z stringa przy uzyciu CHAR form
(loop for item in '(a b c d e f g h e f g h i j)
      for i from 0 to 10 by 1 
      for c  = (char "Ala ma kota, angine i dosc AGH" i) do
      (format t "~a ~a ~a ~%" i item c))


;prosta iteracja od -10 do 10 co 2 pola czyli takie : for(int i = -10; i < 10; i += 2)
(loop for i from -10 to 10 by 2 do (format t "~a~%" i))
;iterowanie od -10 w gore lub w dol
(loop for i upfrom -10 to 10 by 2 do (format t "~a~%" i))
(loop for i downfrom -10 to -12 by 2 do (format t "~a~%" i))

;iterowanie DO 10 z gory i z dolu z UPTO i DOWNTO
(loop for i from -10 upto 10 by 2 do (format t "~a~%" i))
(loop for i from 12 downto 10 by 2 do (format t "~a~%" i))
;lub o jedno mnie z BELOW i ABOVE
(loop for i from 12 above 10 by 2 do (format t "~a~%" i))
(loop for i from 8 below 10 by 1 do (format t "~a~%" i))


;zwracanie kolekcji (takie troche range(1, 10) czy raczej range(10))  czyli z defaultowym startem
(loop for i upto 10 collect i)  
;dla iterowania w dol trzeba podac start index
(loop for i from 0 downto -10 collect i)

; ITEROWANIE PO LISTACH
(loop for i in (list 1 2 3) do (format t "~a~%" i))

;proste wykonanie N razy bez zmiennej iteracyjnej
(loop repeat 20 do (format t "a~%"))

; z podaniem funkcji ktore pobiera kolejne elementy z listy (domyslnei CDR) a tutaj CDDR czyli co drugi
; dla przypomnienia  (cddr '(1 2 3))  => (3) (cddr '(1 2 3 4))  => (3 4)

(loop for v in (list 1 2 3 4 5) by #'cddr collect v)

;a jezeli chcemy przeleciec po liscie sklejonej z kolejnych pomniejszanych list (czyli po CONS 'ach list skladajacych sie na ta liste)
(loop for v on (list 1 2 3 4 5) collect v)
;output => ((1 2 3 4 5) (2 3 4 5) (3 4 5) (4 5) (5))  eh lepiej to pokazac niz opisac

;a po VECTOR'ze np stringu to tak
(loop for i across "Ala ma kota, angine i dosc AGH" do (format t "~a~%" i))

; HASHTABLE aka DICTIONARY
#|(defparameter *hash-table* (make-hash-table :test #'equal))
(setf (gethash "test" *hash-table*) "test-value")
(setf (gethash "www" *hash-table*) "XXX.pl")
(loop for k being the hash-keys in *hash-table* using (hash-value v) collect k)
(loop for v being the hash-values in *hash-table* using (hash-key k) collect v)
|#
(defun dummy-hash-table (&optional (keys "ABC"))
  (let ((hash-table (make-hash-table :test #'equal)))
    (loop for k across keys
          for i from 0 do
          (setf (gethash k hash-table) i))
    hash-table))
;zbieranie tylko KEY albo VALUE
(loop for k being the hash-key in (dummy-hash-table "Ala ma kota, angine i dosyc AGH") collect k)
(loop for v being the hash-value in (dummy-hash-table "123456") collect v)
;zbieranie KEY i VALUE i sklejanie ich CONS'em
(loop for k being the hash-key in (dummy-hash-table "Ala ma kota, angine i dosyc AGH") using (hash-value v) collect (cons k (cons v ())))
(loop for v being the hash-value in (dummy-hash-table "123456") using (hash-key k) collect (cons v (cons k ())))

;ITEROWANIE PO SYMBOLACH W PAKIECIE
(loop for sym being the symbols in 'common-lisp-user collect sym)
(loop for sym being the symbols in 'com.nabacg.spam collect sym)




;USTAWIANIE WARTOSCI
(loop repeat 3 
      for i = 0 then (+ i 1) 
      collect i)
; podwajanie wartosci y za kazda iteracja
(loop repeat 5
      for x = 0 then y
      for y = 1 then (+ x y)
      collect y)

(loop repeat 6
      for y = 1 then (+ x y)
      for x = 0 then y
      collect y)
;fibonacci
(loop repeat 16
      for x = 0 then y
      and y = 1 then (+ x y)
      collect y)


;DEKLAROWANIE ZMIENNYCH
(loop for i upto 10 
      with a = 4
      with text = "Ala ma kota, angine  i dosyc AGH!" do
      (format t "~a ~a ~a ~%" i (* a i) (char text i)))

; destrukturyzowane bind'owanie
(loop for (a b) in '((a 1) (b 2) (c 3) (d 4) (e 5)) do (format t "~a: ~a ~%" a b ))

;destrukturyzacja i kilka zmiennych
(loop with list = '((a 1) (b 2) (c 3) (d 4) (e 5))
      with (k v) = (car list) 
      for (a b) in list do
      (format t "~a: ~a => ~a: ~a ~%" k v a b ))

; destrukturyzacja na dotted lists
(loop for (item . rest) on '(a b c d e)
      do (format t "~a" item)
      when rest do (format t ", "))

;olewanie jednej wartosci (czyt splaszczanie kolekcji)
(loop for (a nil) in '((a 1) (b 2) (c 3) (d 4) (e 5)) collect a)

;akumulacja
(loop for i in (loop for i upto 1000 by 3 collect i)
      counting (evenp i) into evens
      counting (oddp i) into odds
      maximizing i into max
      minimizing i into min
      summing i into total
      finally (return (list total max min evens odds)))

(loop for i in (loop for i upto 10 collect i)
      counting (evenp i) into evens
      counting (oddp i) into odds
      maximizing i into max
      minimizing i into min
      summing i into total do
      (format t "~a ~a ~a ~a ~a ~%" total max min evens odds))


; WARuNKOWO
(loop for i from 0 to 10 do
      (if (evenp i)
          (print i)))
;WARUNKOWE SUMOWANIE
(loop for i from 0 to 10 when (evenp i) sum i)

;WArunkowe wyciaganie z hash tablicy
;wyciaganie tylko istniejacych hashy (loop for key in some-list when (gethash key some-hash) collect it) ponizej ZA DUZY przyklad
(loop with list = '(A B C D)
      with hash-table = (dummy-hash-table (format nil "~{~a~}" list))
      with bigger-list = (append list '(T E F))
      for key in list when (gethash (aref (format nil "~a" key) 0) hash-table) collect it )

;inne liczenie tego samego
(loop for i in (loop for j upto 10 collect j) 
      if (evenp i) 
      counting i into evens and
      minimizing i into min-even
      else 
      counting i into odds and
      maximizing i into max-odd
      finally (return (list evens min-even odds max-odd)))

;jeszcze glupszy przyklad z ksiazki
#|
(loop for i from 1 to 100
      if (evenp i)
        minimize i into min-even and 
        maximize i into max-even and
        unless (zerop (mod i 4))
          sum i into even-not-fours-total
        end
        and sum i into even-total
      else
        minimize i into min-odd and
        maximize i into max-odd and
        when (zerop (mod i 5)) 
          sum i into fives-total
        end
        and sum i into odd-total
      do (update-analysis min-even
                          max-even
                          min-odd
                          max-odd
                          even-total
                          odd-total
                          fives-total
                          even-not-fours-total))
|#

; INITIALLY i FINALLY
(loop initially (print "start")
      for i upto 10 do (print i)
      finally (print "finish"))

;PRZERYWANIE PETLI
(loop for i from 0 while (< i 3) collect i)
; weird UNTIL
(loop for i from 0 until (> i 3) collect i)

; NEVER i Always
(loop for i in '(1 2 3 4 0 2 1) never (= i 0))
(loop for i in '(1 2 3 4 0 2 1) always (> i 0))

;THEREIS sprawdza czy przynajmbniej jeden jest spelniony
(loop for char across "abbd21" thereis (digit-char-p char))
(loop for char across "abbdaa" thereis (digit-char-p char))
; petla w petli
#|(loop for x from 1 to 10
      collect (loop for y from 1 to x 
		    collect y) )|#