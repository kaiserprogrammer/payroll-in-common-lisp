(in-package :payroll-test)

(def-suite payday-test :in payroll-test)
(in-suite payday-test)

(test paying-a-single-salaried-employee
  (let* ((*db* (make-instance 'memory-db))
         (id (add-salaried-employee "Jim" "Home" 2250.0))
         (pay-date (local-time:parse-timestring "2012-11-30"))
         (payday (payday pay-date)))
    (let ((pc (get-paycheck payday id)))
      (is (local-time:timestamp= pay-date
                                 (pay-date pc)))
      (is (local-time:timestamp= (local-time:parse-timestring "2012-11-1")
                                 (payroll::start-date pc)))
      (is (= 2250.0
             (gross-pay pc)))
      (is (string= "Hold"
                   (disposition pc)))
      (is (= 0
             (deductions pc)))
      (is (= 2250.0
             (net-pay pc))))))

(test not-paying-a-salaried-employee-on-wrong-date
  (let* ((*db* (make-instance 'memory-db))
         (id (add-salaried-employee "Jim" "Home" 2250.0))
         (payday (payday (local-time:parse-timestring "2012-11-29"))))
    (is (null (get-paycheck payday id)))))

(test no-pay-with-zero-timecards
  (let* ((*db* (make-instance 'memory-db))
         (id (add-hourly-employee "John" "Work" 12.5))
         (pay-date (local-time:parse-timestring "2001-11-9"))
         (payday (payday pay-date)))
    (let ((pc (get-paycheck payday id)))
      (is (local-time:timestamp= pay-date
                                 (pay-date pc)))
      (is (local-time:timestamp= (local-time:parse-timestring "2001-11-05")
                                 (payroll::start-date pc)))
      (is (= 0
             (gross-pay pc)))
      (is (= 0
             (deductions pc)))
      (is (= 0
             (net-pay pc))))))

(test pay-with-one-time-card
  (let* ((*db* (make-instance 'memory-db))
         (id (add-hourly-employee "John" "Work" 12.5))
         (pay-date (local-time:parse-timestring "2001-11-09")))
    (add-timecard id pay-date 2.0)
    (let* ((payday (payday pay-date))
           (pc (get-paycheck payday id)))
      (is (= 25.0
             (gross-pay pc)))
      (is (= 25.0
             (net-pay pc))))))

(test pay-for-over-time
  (let* ((*db* (make-instance 'memory-db))
         (id (add-hourly-employee "John" "Work" 15.25))
         (pay-date (local-time:parse-timestring "2001-11-09")))
    (add-timecard id pay-date 9.0)
    (let ((pc (get-paycheck (payday pay-date) id)))
      (is (= (* (+ 8 1.5)
                15.25)
             (gross-pay pc))))))

(test no-pay-on-wrong-date-for-hourly-employee
  (let* ((*db* (make-instance 'memory-db))
         (id (add-hourly-employee "John" "Work" 15.25))
         (pay-date (local-time:parse-timestring "2001-11-08")))
    (add-timecard id pay-date 9.0)
    (let ((pc (get-paycheck (payday pay-date) id)))
      (is (null pc)))))

(test pay-with-two-time-cards
  (let* ((*db* (make-instance 'memory-db))
         (id (add-hourly-employee "John" "Work" 12.5))
         (pay-date (local-time:parse-timestring "2001-11-09")))
    (add-timecard id pay-date 2.0)
    (add-timecard id (local-time:timestamp- pay-date 1 :day) 8.0)
    (let* ((payday (payday pay-date))
           (pc (get-paycheck payday id)))
      (is (= 125.0
             (gross-pay pc)))
      (is (= 125.0
             (net-pay pc))))))

(test pay-only-one-period
  (let* ((*db* (make-instance 'memory-db))
         (id (add-hourly-employee "John" "Work" 12.5))
         (pay-date (local-time:parse-timestring "2001-11-09")))
    (add-timecard id pay-date 2.0)
    (add-timecard id (local-time:timestamp- pay-date 7 :day) 8.0)
    (add-timecard id (local-time:timestamp+ pay-date 7 :day) 8.0)
    (let* ((payday (payday pay-date))
           (pc (get-paycheck payday id)))
      (is (= 25.0
             (gross-pay pc)))
      (is (= 25.0
             (net-pay pc))))))

(test pay-with-one-sale-in-period
  (let* ((*db* (make-instance 'memory-db))
         (id (add-commissioned-employee "John" "Work" 1000. 10))
         (pay-date (local-time:parse-timestring "2001-11-30")))
    (add-sales-receipt id pay-date 500)
    (add-sales-receipt id (local-time:timestamp- pay-date 14 :day) 1000)
    (let* ((payday (payday pay-date))
           (pc (get-paycheck payday id)))
      (is (= 1050.
             (gross-pay pc)))
      (is (= 1050.
             (net-pay pc))))))

(test no-pay-on-wrong-date-for-commissioned-employee
    (let* ((*db* (make-instance 'memory-db))
         (id (add-commissioned-employee "John" "Work" 1000. 10))
         (pay-date (local-time:parse-timestring "2001-11-23")))
    (let* ((payday (payday pay-date))
           (pc (get-paycheck payday id)))
      (is (null pc)))))

(test deduct-service-charges
  (let* ((*db* (make-instance 'memory-db))
         (id (add-hourly-employee "John" "Work" 12.5))
         (pay-date (local-time:parse-timestring "2001-11-09"))
         (e (get-employee *db* id)))
    (add-timecard id pay-date 8.0)
    (change-union-member id 80)
    (add-service-charge (union-member-id e) pay-date 15)
    (let* ((payday (payday pay-date))
           (pc (get-paycheck payday id)))
      (is (= 100.0
             (gross-pay pc)))
      (is (= 95.
             (deductions pc)))
      (is (= 5.
             (net-pay pc))))))

(test deduct-service-charges-when-spanning-multiple-periods
  (let* ((*db* (make-instance 'memory-db))
         (id (add-hourly-employee "John" "Work" 12.5))
         (pay-date (local-time:parse-timestring "2001-11-09"))
         (e (get-employee *db* id)))
    (add-timecard id pay-date 8.0)
    (change-union-member id 80)
    (add-service-charge (union-member-id e) pay-date 15)
    (add-service-charge (union-member-id e) (local-time:timestamp- pay-date 7 :day) 15)
    (add-service-charge (union-member-id e) (local-time:timestamp+ pay-date 7 :day) 15)
    (let* ((payday (payday pay-date))
           (pc (get-paycheck payday id)))
      (is (= 100.0
             (gross-pay pc)))
      (is (= 95.
             (deductions pc)))
      (is (= 5.
             (net-pay pc))))))
