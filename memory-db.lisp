(in-package :payroll)

(defvar *db*)

(defclass memory-db ()
  ((id :initform 0
       :accessor id)
   (employees :initform (make-hash-table)
              :accessor employees)))

(defun next-id (db)
  (incf (id db)))

(defgeneric get-employee (db id))

(defmethod get-employee ((db memory-db) (id number))
  (gethash id (employees db)))

(defgeneric add-employee (db employee))
(defmethod add-employee ((db memory-db) (e employee))
  (setf (id e) (next-id db))
  (setf (gethash (id e) (employees db)) e)
  (id e))

(defgeneric delete-employee-from-database (db id))
(defmethod delete-employee-from-database ((db memory-db) (id number))
  (remhash id (employees db)))
