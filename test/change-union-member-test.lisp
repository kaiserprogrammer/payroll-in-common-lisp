(in-package :payroll-test)

(def-suite union-test :in payroll-test)
(in-suite union-test)

(test creating-union-membership
  (let* ((*db* (make-instance 'memory-db))
         (id (add-hourly-employee "Jim" "Home" 22.5))
         (e (get-employee *db* id)))
    (change-union-member id 99.42)
    (let ((af (affiliation e)))
      (is (= 99.42
             (dues af))))
    (let ((m (get-union-member *db* (union-member-id e))))
      (is (not (null m)))
      (is (eql e m)))))

(run!)
