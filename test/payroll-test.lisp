(defpackage :payroll-test
  (:use :cl :payroll :fiveam))

(in-package :payroll-test)

(def-suite payroll-test)
(def-suite employee-test :in payroll-test)

(in-suite employee-test)

(test changing-address
  (let* ((*db* (make-instance 'memory-db))
         (id (add-hourly-employee "Jim" "wrong" 12.5))
         (e (get-employee *db* id)))
    (change-address id "right")
    (is (string= "right" (address e)))))

(test changing-name
  (let* ((*db* (make-instance 'memory-db))
         (id (add-hourly-employee "wrong" "Home" 12.5))
         (e (get-employee *db* id)))
    (change-name id "right")
    (is (string= "right" (name e)))))

(test change-employee-to-be-commissioned
  (let* ((*db* (make-instance 'memory-db))
         (id (add-hourly-employee "John" "Work" 12.5))
         (e (get-employee *db* id)))
    (change-commissioned id 300.0 400.0)
    (let ((pc (payment-classification e)))
      (is (eql 'payroll::commissioned-classification
               (class-name (class-of pc))))
      (is (= 300.0
             (salary pc)))
      (is (= 400.0
             (rate pc))))
    (let ((ps (schedule e)))
      (is (eql 'payroll::bi-weekly-schedule
               (class-name (class-of ps)))))))

(test change-employee-to-be-hourly
  (let* ((*db* (make-instance 'memory-db))
         (id (add-commissioned-employee "Jimmy" "Garage" 400.0 300.0))
         (e (get-employee *db* id)))
    (change-hourly id 12.75)
    (let ((pc (payment-classification e)))
      (is (eql 'payroll::hourly-classification
               (class-name (class-of pc))))
      (is (= 12.75
             (hourly-rate pc))))
    (let ((ps (schedule e)))
      (is (eql 'payroll::weekly-schedule
               (class-name (class-of ps)))))))

(test change-employee-to-be-salaried
  (let* ((*db* (make-instance 'memory-db))
         (id (add-hourly-employee "Jim" "Blue" 11.0))
         (e (get-employee *db* id)))
    (change-salaried id 2000.0)
    (let ((pc (payment-classification e)))
      (is (eql 'payroll::salaried-classification
               (class-name (class-of pc))))
      (is (= 2000.0
             (salary pc))))
    (let ((ps (schedule e)))
      (is (eql 'payroll::monthly-schedule
               (class-name (class-of ps)))))))

(run! 'payroll-test)
