(in-package :payroll)

(defclass sale-receipt ()
  ((amount :initarg :amount
           :reader amount)
   (date :initarg :date
         :reader date)))

(defun add-sales-receipt (id date amount &optional (db *db*))
  (push (make-instance 'sale-receipt
                       :amount amount
                       :date date)
        (sales-receipts (payment-classification (get-employee db id)))))
