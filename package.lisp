(defpackage :payroll
  (:use :cl :local-time)
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
   :change-salaried
   :add-sales-receipt
   :amount
   :sales-receipts
   :date
   :timecard
   :add-timecard
   :hours
   :delete-employee
   :change-union-member
   :affiliation
   :dues
   :union-member-id
   :get-union-member
   :change-unaffiliated
   :add-service-charge
   :get-service-charge
   :charge
   :payday
   :pay-date
   :get-paycheck
   :gross-pay
   :disposition
   :deductions
   :net-pay))
