(defun iterate (list)
  (format t "~a~%" (car list))
  (if (cdr list)
      (iterate (cdr list))))

(defun my-list-length (list)
  (if list
      (+1 (iterate (cdr list)))
      0))