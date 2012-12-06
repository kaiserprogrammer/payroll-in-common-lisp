(in-package :payroll)

(defvar *db*)

(defclass memory-db ()
  ((id :initform 0
       :accessor id)
   (employees :initform (make-hash-table)
              :accessor employees)
   (union-members :initform (make-hash-table)
                  :accessor union-members)))

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

(defgeneric add-union-member (db employee))
(defmethod add-union-member ((db memory-db) (e employee))
  (setf (union-member-id e) (next-id db))
  (setf (gethash (union-member-id e) (union-members db)) e))

(defgeneric get-all-employees (db))
(defmethod get-all-employees ((db memory-db))
  (alexandria:hash-table-values (employees db)))

(defgeneric get-union-member (db union-member-id))
(defmethod get-union-member (db id)
  (gethash id (union-members db)))

(defgeneric delete-employee-from-database (db id))
(defmethod delete-employee-from-database ((db memory-db) (id number))
  (remhash id (employees db)))

(defgeneric delete-union-member-from-database (db member-id))
(defmethod delete-union-member-from-database ((db memory-db) (member-id number))
  (remhash member-id (union-members db)))
