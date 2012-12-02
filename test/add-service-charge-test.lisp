(in-package :payroll-test)

(def-suite service-charge :in union-test)
(in-suite service-charge)

(test adding-a-service-charge
  (let* ((*db* (make-instance 'memory-db))
         (id (add-commissioned-employee "Jimmy" "Red" 2525 100))
         (e (get-employee *db* id))
         (date (local-time:parse-timestring "2012-12-31")))
    (change-union-member id 10.0)
    (add-service-charge (union-member-id e) date 12.95)
    (let ((af (affiliation e)))
      (let ((sc (get-service-charge af date)))
        (is (not (null sc)))
        (is (= 12.95
               (charge sc)))
        (is (local-time:timestamp= date
                                   (date sc)))))))

