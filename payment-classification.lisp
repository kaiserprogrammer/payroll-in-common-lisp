(in-package :payroll)

(defclass payment-classification ()
  ())

(defclass salaried-classification (payment-classification)
  ((salary :initarg :salary
           :accessor salary)))

(defclass commissioned-classification (payment-classification)
  ((salary :initarg :salary
           :accessor salary)
   (rate :initarg :rate
         :accessor rate)
   (receipts :initform (list)
             :accessor sales-receipts)))

(defclass hourly-classification (payment-classification)
  ((hourly-rate :initarg :rate
                :accessor hourly-rate)
   (timecards :accessor timecards
              :initform (make-hash-table :test #'equalp))))

(defgeneric timecard (classification date))
(defmethod timecard ((c hourly-classification) (d timestamp))
  (gethash d (timecards c)))
