(in-package :payroll)

(defclass schedule ()
  ())

(defclass monthly-schedule (schedule)
  ())

(defmethod payday? ((s monthly-schedule) (date timestamp))
  (last-day-of-month? date))

(defmethod get-pay-period-start-date ((s monthly-schedule) (date timestamp))
  (first-day-of-month date))

(defclass bi-weekly-schedule (schedule)
  ())

(defmethod payday? ((s bi-weekly-schedule) (date timestamp))
  (and (last-day-of-week? date) (oddp (truncate (/ (local-time:timestamp-to-universal date) (* 60 60 24 7))))))

(defmethod get-pay-period-start-date ((s bi-weekly-schedule) (date timestamp))
  (timestamp- (first-day-of-week date) 7 :day))

(defclass weekly-schedule (schedule)
  ())

(defmethod payday? ((s weekly-schedule) (date timestamp))
  (last-day-of-week? date))

(defmethod get-pay-period-start-date ((s weekly-schedule) (date timestamp))
  (first-day-of-week date))

(defun last-day-of-month? (date)
  (= (timestamp-month (timestamp+ date 1 :month))
     (timestamp-month (timestamp+ date 1 :day))))

(defun last-day-of-week? (date)
  (= 5
     (timestamp-day-of-week date)))

(defun first-day-of-month (date)
  (timestamp- date (1- (timestamp-day date)) :day))

(defun first-day-of-week (date)
  (timestamp- date (1- (timestamp-day-of-week date)) :day))
