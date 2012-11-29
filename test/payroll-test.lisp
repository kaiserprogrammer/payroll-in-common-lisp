(defpackage :payroll-test
  (:use :cl :payroll :fiveam))

(in-package :payroll-test)

(def-suite payroll-test)
(def-suite employee-test :in payroll-test)

(run! 'payroll-test)
