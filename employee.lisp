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
                   :accessor payment-method)))

(defclass salaried-employee (employee)
  ((salary :initarg :salary
           :accessor :salary)))
