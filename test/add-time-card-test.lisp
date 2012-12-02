(in-package :payroll-test)

(def-suite timecard-test :in payroll-test)
(in-suite timecard-test)

(test adding-time-cards
  (let* ((*db* (make-instance 'memory-db))
         (id (add-hourly-employee "John" "Home" 12.75))
         (e (get-employee *db* id))
         (date (local-time:parse-timestring "20012-12-31")))
    (add-timecard id date 8.0)
    (let ((tc (timecard (payment-classification e) date)))
      (is (= 8.0
             (hours tc)))
      (is (local-time:timestamp= date
                      (date tc))))))

