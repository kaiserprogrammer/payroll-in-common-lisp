(in-package :payroll)

(defclass timecard ()
  ((hours :initarg :hours
          :reader hours)
   (date :initarg :date
         :reader date)))

(defun add-timecard (id date hours &optional (db *db*))
  (setf (gethash date (timecards (payment-classification (get-employee db id))))
        (make-instance 'timecard
                       :hours hours
                       :date date)))
