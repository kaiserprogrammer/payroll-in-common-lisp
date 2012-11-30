(in-package :payroll-test)

(def-suite sales-receipt-test :in payroll-test)
(in-suite sales-receipt-test)

(test adding-sales-receipts
  (let* ((*db* (make-instance 'memory-db))
         (id (add-commissioned-employee "Jim" "Floor" 350 5.0))
         (date (local-time:parse-timestring "2012-12-1")))
    (add-sales-receipt id date 500.0)
    (let ((pc (payment-classification (get-employee *db* id))))
      (let ((sales (sales-receipts pc)))
        (is (not (null sales)))
        (is (= 500.0
               (amount (first sales))))
        (is (local-time:timestamp= date
                        (date (first sales))))))))

(run!)
