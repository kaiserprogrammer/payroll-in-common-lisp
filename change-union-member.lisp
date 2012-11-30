(in-package :payroll)

(defclass affiliation ()
  ((dues :initarg :dues
         :accessor dues)
   (service-charges :initform (make-hash-table :test #'equalp)
                    :accessor service-charges)))

(defgeneric get-service-charge (affiliation date))
(defmethod get-service-charge ((af affiliation) (date timestamp))
  (gethash date (service-charges af)))

(defclass no-affiliation () ())

(defun change-union-member (id dues &optional (db *db*))
  (let ((e (get-employee db id)))
    (add-union-member db e)
    (setf (affiliation e)
          (make-instance 'affiliation
                         :dues dues))))

(defun change-unaffiliated (id &optional (db *db*))
  (setf (affiliation (get-employee db id))
        (make-instance 'no-affiliation)))
