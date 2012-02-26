;;;; Created on 2011-09-29 20:50:27
;WARUNKOWe
;(format t "~[A~;b~;c~;d ~]" 2)
;(format t "~:[NIEEE ~; TAAK ~]" t)

;ITERACJA
;(format nil "~{~a, ~}" (list 1 2 3)) = > "1, 2, 3, "
;(format nil "~{~a~^, ~}" (list 1 2 3))  => "1, 2, 3"
;(format nil "~{~a~#[~;, and ~:;, ~]~}" (list 1 2 3)) =>  "1, 2, and 3"


#|
(format nil "I saw ~r el~:*~[ves~;f~:;ves~]." 0) ==> "I saw zero elves."
(format nil "I saw ~r el~:*~[ves~;f~:;ves~]." 1) ==> "I saw one elf."
(format nil "I saw ~r el~:*~[ves~;f~:;ves~]." 2) ==> "I saw two elves."
|#