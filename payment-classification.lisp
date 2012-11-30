(in-package :payroll)

(defclass payment-classification ()
  ())

(defclass salaried-classification (payment-classification)
  ((salary :initarg :salary
           :accessor salary)))

(defmethod calculate-pay ((cls salaried-classification) (pc paycheck))
  (salary cls))

(defclass commissioned-classification (payment-classification)
  ((salary :initarg :salary
           :accessor salary)
   (rate :initarg :rate
         :accessor rate)
   (receipts :initform (list)
             :accessor sales-receipts)))

(defmethod calculate-pay ((cls commissioned-classification) (pc paycheck))
  (let ((receipts-in-period (remove-if (lambda (sale) (or (timestamp< (date sale) (start-date pc))
                                                     (timestamp> (date sale) (pay-date pc))))
                                       (sales-receipts cls))))
    (reduce (lambda (salary sale)
              (+ salary
                 (* (/ (rate cls) 100)
                    (amount sale))))
            receipts-in-period
            :initial-value (salary cls))))

(defclass hourly-classification (payment-classification)
  ((hourly-rate :initarg :rate
                :accessor hourly-rate)
   (timecards :accessor timecards
              :initform (make-hash-table :test #'equalp))))

(defmethod calculate-pay ((cls hourly-classification) (pc paycheck))
  (let ((timecards (get-timecards cls pc)))
    (reduce (lambda (salary timecard)
              (+ salary (* (hourly-rate cls) (+ (hours timecard)
                                                (* 0.5 (max (- (hours timecard) 8)
                                                       0))))))
            timecards
            :initial-value 0)))

(defun get-timecards (cls pc)
  (let ((timecards (list)))
    (maphash (lambda (date tc)
               (when (and (timestamp>= (date tc) (start-date pc))
                           (timestamp<= (date tc) (pay-date pc)))
                 (push tc timecards)))
             (timecards cls))
    timecards))

(defgeneric timecard (classification date))
(defmethod timecard ((c hourly-classification) (d timestamp))
  (gethash d (timecards c)))
