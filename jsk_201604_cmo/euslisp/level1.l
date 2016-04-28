#!/usr/bin/env roseus
;; vim: set ft=lisp:

(require :fetch-interface "package://fetcheus/fetch-interface.l")

(require :util "package://jsk_2016_04_cmo/euslib/util.l")


;; -------------------------------------------------------------------------
;; main
;; -------------------------------------------------------------------------
(defun main ()
  (fetch-init)
  (setq *robot* *fetch*)

  (setq obj-coords
        (make-coords
          :pos (apply #'float-vector (mapcar #'m->mm '(0.8 -0.1 0.9)))
          :rpy (apply #'float-vector (mapcar #'m->mm '(0 0 0)))
          )
        )
  ; (setq obj (make-cube 60 60 60))
  ; (send obj :transform obj-coords :world)

  (objects (list *robot* obj-coords))
  )
