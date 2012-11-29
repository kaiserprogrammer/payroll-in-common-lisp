(in-package :payroll)

(defun add-salaried-employee (name address salary &optional (db *db*))
  (add-employee db (make-instance 'employee
                                  :name name
                                  :address address
                                  :payment (make-instance 'salaried-classification
                                                          :salary salary)
                                  :schedule (make-instance 'monthly-schedule)
                                  :method (make-instance 'hold-method))))

(defun add-commissioned-employee (name address salary rate &optional (db *db*))
  (add-employee db (make-instance 'employee
                                  :name name
                                  :address address
                                  :payment (make-instance 'commissioned-classification
                                                          :salary salary
                                                          :rate rate)
                                  :schedule (make-instance 'bi-weekly-schedule)
                                  :method (make-instance 'hold-method))))
