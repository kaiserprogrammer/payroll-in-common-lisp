(in-package :payroll)

(defclass service-charge ()
  ((date :initarg :date
         :reader date)
   (charge :initarg :charge
           :reader charge)))

(defun add-service-charge (union-member-id date charge &optional (db *db*))
  (setf (gethash date (service-charges (affiliation (get-union-member db union-member-id))))
        (make-instance 'service-charge
                       :date date
                       :charge charge)))
