;; vim: set ft=lisp:

(require "package://fetcheus/fetch.l")

(defmethod fetch-robot
  (:fold-pose
    ()
    (send self :angle-vector #f(0.0 75.6311 4.455748e-05 -80.1922 98.5484 0.001909 95.1105 8.447113e-05 0.058347 0.131945))
    )
  )
