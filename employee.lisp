(in-package :payroll)

(defclass employee ()
  ((name :initarg :name
         :accessor name)
   (address :initarg :address
            :accessor address)
   (id :accessor id)
   (payment-classification :initarg :payment
                           :accessor payment-classification)
   (schedule :initarg :schedule
             :accessor schedule)
   (payment-method :initarg :method
                   :accessor payment-method)
   (affiliation :accessor affiliation
                :initform (make-instance 'no-affiliation))
   (union-member-id :accessor union-member-id)))

(defgeneric payday? (employee date))
(defmethod payday? ((e employee) (date timestamp))
  (payday? (schedule e) date))

(defgeneric get-pay-period-start-date (employee date))
(defmethod get-pay-period-start-date ((e employee) (date timestamp))
  (get-pay-period-start-date (schedule e) date))

(defgeneric calculate-pay (employee paycheck))
(defmethod calculate-pay ((e employee) (pc paycheck))
  (setf (gross-pay pc) (calculate-pay (payment-classification e) pc))
  (setf (disposition pc) (disposition (payment-method e)))
  (setf (deductions pc) (calculate-deductions (affiliation e) pc)))

(defun change-address (id address &optional (db *db*))
  (setf (address (get-employee db id)) address))

(defun change-name (id name &optional (db *db*))
  (setf (name (get-employee db id)) name))

(defun change-commissioned (id salary rate &optional (db *db*))
  (let ((e (get-employee db id)))
    (setf (schedule e) (make-instance 'bi-weekly-schedule))
    (setf (payment-classification e)
          (make-instance 'commissioned-classification
                         :salary salary
                         :rate rate))))

(defun change-hourly (id hourly-rate &optional (db *db*))
  (let ((e (get-employee db id)))
    (setf (schedule e) (make-instance 'weekly-schedule))
    (setf (payment-classification e)
          (make-instance 'hourly-classification
                         :rate hourly-rate))))

(defun change-salaried (id salary &optional (db *db*))
  (let ((e (get-employee db id)))
    (setf (schedule e) (make-instance 'monthly-schedule))
    (setf (payment-classification e)
                (make-instance 'salaried-classification
                               :salary salary))))

