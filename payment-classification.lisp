(in-package :payroll)

(defclass payment-classification ()
  ())

(defclass salaried-classification (payment-classification)
  ((salary :initarg :salary
           :accessor salary)))
