(in-package :payroll-test)

(def-suite presenter-test :in payroll-test)
(in-suite presenter-test)

(defclass mock-transaction-container () ())
(defclass mock-add-employee-view ()
  ((submit-enabled? :initform nil
                    :accessor submit-enabled?)))

(test collecting-all-necessary-infos
  (let* ((db (make-instance 'memory-db))
         (view (make-instance 'mock-add-employee-view))
         (container (make-instance 'mock-transaction-container))
         (presenter (make-instance 'add-employee-presenter
                                   :view view
                                   :container container
                                   :database db)))
    (is-false (all-information-collected? presenter))
    (setf (name presenter) "Bill")
    (is-false (all-information-collected? presenter))
    (setf (address presenter) "123 abc")
    (is-false (all-information-collected? presenter))
    (setf (hourly presenter) t)
    (is-false (all-information-collected? presenter))
    (setf (hourly-rate presenter) 12.75)
    (is-true (all-information-collected? presenter))

    (setf (hourly presenter) nil)
    (is-false (all-information-collected? presenter))
    (setf (salary? presenter) t)
    (is-false (all-information-collected? presenter))
    (setf (salary presenter) 1234)
    (is-true (all-information-collected? presenter))

    (setf (salary? presenter) nil)
    (is-false (all-information-collected? presenter))
    (setf (commission? presenter) t)
    (is-false (all-information-collected? presenter))
    (setf (commission-salary presenter) 1234)
    (is-false (all-information-collected? presenter))
    (setf (commission-rate presenter) 12)
    (is-true (all-information-collected? presenter))))

(test updating-view
  (let* ((db (make-instance 'memory-db))
         (view (make-instance 'mock-add-employee-view))
         (container (make-instance 'mock-transaction-container))
         (presenter (make-instance 'add-employee-presenter
                                   :view view
                                   :container container
                                   :database db)))
    (is-false (submit-enabled? view))
    (setf (name presenter) "Bill")
    (is-false (submit-enabled? view))
    (setf (address presenter) "123 abc")
    (is-false (submit-enabled? view))
    (setf (hourly-rate presenter) 12.5)
    (is-false (submit-enabled? view))
    (setf (hourly presenter) t)
    (is-true (submit-enabled? view))))

