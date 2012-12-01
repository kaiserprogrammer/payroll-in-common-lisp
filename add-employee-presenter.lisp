(in-package :payroll)

(defclass add-employee-presenter ()
  ((view :initarg :view
         :accessor view)
   (container :initarg :container
              :accessor container)
   (database :initarg :database
             :accessor database)
   (name :accessor name
         :initform nil)
   (address :accessor address
            :initform nil)
   (hourly :accessor hourly
           :initform nil)
   (houlry-rate :accessor hourly-rate
                :initform nil)
   (salary? :accessor salary?
            :initform nil)
   (salary :accessor salary
           :initform nil)
   (commission? :accessor commission?
                :initform nil)
   (commission-salary :accessor commission-salary
                      :initform nil)
   (commission-rate :accessor commission-rate
                    :initform nil)))


(defun update-view (presenter)
  (setf (submit-enabled? (view presenter)) (all-information-collected? presenter)))

(let ((methods '(name address hourly hourly-rate salary?
                 salary commission? commission-salary commission-rate)))
  (dolist (m methods)
    (symbol-macrolet ((def `(defmethod (setf ,m) :after (arg (p add-employee-presenter))
                                       (update-view p))))
      (eval def))))

(defgeneric all-information-collected? (presenter))
(defmethod all-information-collected? (presenter)
  (and (name presenter)
       (address presenter)
       (or (and (hourly presenter)
                (hourly-rate presenter))
           (and (salary? presenter)
                (salary presenter))
           (and (commission? presenter)
                (commission-salary presenter)
                (commission-rate presenter)))))

