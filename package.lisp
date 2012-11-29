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
   :*db*
   :add-commissioned-employee
   :rate
   :add-hourly-employee
   :hourly-rate
   :change-address
   :change-name
   :change-commissioned
   :change-hourly
   :change-salaried))
