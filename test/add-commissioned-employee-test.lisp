(in-package :payroll-test)

(def-suite commissioned-employee-test :in employee-test)
(in-suite commissioned-employee-test)

(test creating-commissioned-employee
  (let* ((*db* (make-instance 'memory-db))
         (empid (add-commissioned-employee "Johnny" "Work" 250.0 300.)))
    (let ((e (get-employee *db* empid)))
      (is (string= "Johnny" (name e)))
      (is (string= "Work" (address e)))
      (let ((pc (payment-classification e)))
        (is (= 250.0 (salary pc)))
        (is (= 300.0 (rate pc))))
      (let ((pm (payment-method e)))
        (is (eql 'payroll::hold-method
                 (class-name (class-of pm)))))
      (let ((ps (schedule e)))
        (is (eql 'payroll::bi-weekly-schedule
                 (class-name (class-of ps))))))))
