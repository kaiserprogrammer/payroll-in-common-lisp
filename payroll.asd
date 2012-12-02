(asdf:defsystem payroll
    :version "0"
    :description "A Payroll Application "
    :maintainer "Jürgen Bickert <juergenbickert@gmail.com>"
    :author "Jürgen Bickert <juergenbickert@gmail.com>"
    :licence "MIT-style"
    :depends-on (local-time fiveam)
    :serial t
    ;; components likely need manual reordering
    :components ((:static-file "README")
                 (:file "package")
                 (:file "payday")
                 (:file "employee")
                 (:file "payment-classification")
                 (:file "schedule")
                 (:file "payment-method")
                 (:file "memory-db")
                 (:file "add-employee")
                 (:file "add-employee-presenter")
                 (:file "add-sales-receipt")
                 (:file "add-service-charge")
                 (:file "add-timecard")
                 (:file "change-union-member")
                 (:file "delete-employee")
                 (:module test
                          :serial t
                          :components
                          ((:file "payroll-test")
                           (:file "add-commissioned-employee-test")
                           (:file "add-employee-presenter-test")
                           (:file "add-hourly-employee-test")
                           (:file "add-salaried-employee-test")
                           (:file "add-sales-receipt-test")
                           (:file "change-union-member-test")
                           (:file "add-service-charge-test")
                           (:file "add-time-card-test")
                           (:file "delete-employee-test")
                           (:file "payday-test")))))
