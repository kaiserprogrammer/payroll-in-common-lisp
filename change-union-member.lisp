(in-package :payroll)

(defclass affiliation ()
  ((dues :initarg :dues
         :accessor dues)))

(defun change-union-member (id dues &optional (db *db*))
  (let ((e (get-employee db id)))
    (add-union-member db e)
    (setf (affiliation e)
          (make-instance 'affiliation
                         :dues dues))))
