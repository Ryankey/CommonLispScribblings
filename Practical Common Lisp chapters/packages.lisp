;;;; Created on 2011-09-24 20:06:25
;SBCL initfile
; #P"C:\\Users\\nabacg\\.sbclrc"
(in-package :common-lisp-user)
(load "C:\\Users\\nabacg\\quicklisp\\setup.lisp")
(ql:quickload "cl-ppcre")
;CURRENT PACKAGE 
;  *PACKAGE*

;wyswietlenie aktualnie zaimportowanych pakietow
;(mapcar #'package-name (package-use-list :cl-user))

;znalezc nazwe pakietu z ktorego pochodzi symbol
;(package-name (symbol-package 'eql))                         => "COMMON-LISP"
;(package-name (symbol-package 'malformed-log-entry-error))   => "COMMON-LISP-USER"

(in-package :cl-user)

;pakiet siebela do sciezek
(defpackage :com.gigamonkeys.pathnames
  (:use :common-lisp)
  (:export
   :list-directory
   :file-exists-p
   :directory-pathname-p
   :file-pathname-p
   :pathname-as-directory
   :pathname-as-file
   :walk-directory
   :directory-p
   :file-p))

; SPAM FILTER
(defpackage :com.nabacg.spam
  (:use :common-lisp :com.gigamonkeys.pathnames  :cl-ppcre))

; w jednym pliku zamieszczamy wszystkie definicje pakietow
(defpackage :com.gmc.file.io
  (:use :common-lisp)
  (:export 
    :print-file
    :print-first-line
    :save-to-file))

; tutaj chyba powinno sie zaladowac :com.gmc.file.io
(load (compile-file "D:\\DEV\\projects\\practical-common-lisp-sandbox\\file-io.lisp"))


(defpackage :com.nabacg.binary
  (:use :common-lisp)) ; powinno tez korzystac z => :com.gigamonkeys.macro-utilities 

; definicja pakietu
(defpackage :com.gigamonkeys.email-db
  (:use "COMMON-LISP" :com.gmc.file.io)
  ;importing single function
 ; (:import-from :com.acme.email :parse-email-address)
  ;zeby zaslonic dana metode
  ;:shadow :build-index
  )

; a to powinno zapisac lispa, biblioteki i program do executable binary
;(sb-ext:save-lisp-and-die "cl-main.exe" :executable t :toplevel 'main-program-function)

;ustawienie pakietu na CURRENT PACKAGE
;(in-package :com.gigamonkeys.email-db)

#|
(in-package :common-lisp-user)


COMMON-LISP-USER>
(defun hello (format t "Hello World from COMMON-LISP-USER"))


COMMON-LISP-USER>
(defun hello () (format t "Hello World from COMMON-LISP-USER"))

HELLO

COMMON-LISP-USER>
(hello) => Hello World from COMMON-LISP-USER

(in-package :com.gigamonkeys.email-db)


(defun hello () (format t "Hello World from EMAIL-DB"))
(hello)

|#