(in-package :payroll-test)

(def-suite salaried-employee-test :in employee-test)
(in-suite salaried-employee-test)

(test creating-salaried-employee
  (let* ((db (make-instance 'memory-db))
         (empid (add-salaried-employee "John" "Home" 1111.0 db)))
    (let ((e (get-employee db empid)))
      (is (string= (name e) "John"))
      (is (string= (address e) "Home"))
      (let ((pc (payment-classification e)))
        (is (= (salary pc) 1111.0))
        (let ((ps (schedule e)))
          (is (eql 'PAYROLL::MONTHLY-SCHEDULE
                   (class-name (class-of ps))))
          (let ((pm (payment-method e)))
            (is (eql 'payroll::hold-method
                     (class-name (class-of pm))))))))))

(test creating-salaried-employee-with-special-db
  (let* ((payroll:*db* (make-instance 'memory-db))
         (empid (add-salaried-employee "John" "Home" 1111.0)))
    (let ((e (get-employee payroll:*db* empid)))
      (is (string= (name e) "John"))
      (is (string= (address e) "Home"))
      (let ((pc (payment-classification e)))
        (is (= (salary pc) 1111.0))
        (let ((ps (schedule e)))
          (is (eql 'PAYROLL::MONTHLY-SCHEDULE
                   (class-name (class-of ps))))
          (let ((pm (payment-method e)))
            (is (eql 'payroll::hold-method
                     (class-name (class-of pm))))))))))

(run!)
