(defpackage :payroll
  (:use :cl)
  (:export
   :name
   :address
   :memory-db
   :add-salaried-employee
   :get-employee
   :payment-classification
   :salary
   :schedule
   :payment-method
   :*db*))
