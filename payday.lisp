(in-package :payroll)

(defclass payday ()
  ((paychecks :initform (make-hash-table)
              :accessor paychecks)))

(defclass paycheck ()
  ((pay-date :initarg :date
             :reader pay-date)
   (start-date :initarg :start-date
               :reader start-date)
   (gross-pay :accessor gross-pay)
   (disposition :accessor disposition)
   (deductions :accessor deductions)))

(defgeneric net-pay (paycheck))
(defmethod net-pay ((pc paycheck))
  (- (gross-pay pc) (deductions pc)))

(defgeneric get-paycheck (payday id))
(defmethod get-paycheck ((pd payday) (id number))
  (gethash id (paychecks pd)))

(defun payday (date &optional (db *db*))
  (let ((pd (make-instance 'payday))
        (employees (get-all-employees db)))
    (dolist (e employees)
      (when (payday? e date)
        (let* ((start-date (get-pay-period-start-date e date))
               (pc (make-instance 'paycheck
                                  :start-date start-date
                                  :date date)))
          (calculate-pay e pc)
          (setf (gethash (id e) (paychecks pd)) pc))))
    pd))
