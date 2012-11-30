(in-package :payroll)

(defclass payment-method ()
  ())

(defclass hold-method ()
  ())

(defmethod disposition ((method hold-method))
  "Hold")
