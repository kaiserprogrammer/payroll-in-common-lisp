(in-package :payroll-test)

(def-suite hourly-employee-test :in employee-test)
(in-suite hourly-employee-test)

(test creating-hourly-employee
  (let* ((*db* (make-instance 'memory-db))
         (empid (add-hourly-employee "Bob" "Toilet" 17.5))
         (e (get-employee *db* empid)))
    (is (string= "Bob" (name e)))
    (is (string= "Toilet" (address e)))
    (let ((pc (payment-classification e)))
      (is (= 17.5 (hourly-rate pc))))
    (let ((ps (schedule e)))
      (is (eql 'payroll::weekly-schedule
               (class-name (class-of ps)))))
    (let ((pm (payment-method e)))
      (is (eql 'payroll::hold-method
               (class-name (class-of pm)))))))

(run!)
