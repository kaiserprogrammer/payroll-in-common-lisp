(in-package :payroll)

(defun delete-employee (id &optional (db *db*))
  (delete-employee-from-database db id))
