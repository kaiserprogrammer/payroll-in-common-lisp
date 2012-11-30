(in-package :payroll-test)

(def-suite delete-test :in payroll-test)
(in-suite delete-test)

(test deleting-an-employee
  (let* ((*db* (make-instance 'memory-db))
         (id (add-salaried-employee "Jim" "Home" 2222.0)))
    (is (not (null (get-employee *db* id))))
    (delete-employee id)
    (is (null (get-employee *db* id)))))

(run!)
