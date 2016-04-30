#!/usr/bin/env roseus
;; vim: set ft=lisp:

(require :util "package://jsk_201604_cmo/euslisp/lib/util.l")
(require :fetch-interface "package://jsk_201604_cmo/euslisp/lib/fetch-interface.l")


;; -------------------------------------------------------------------------
;; main
;; -------------------------------------------------------------------------
(defun main ()
  (ros::roseus "robot_motion")
  (ros::set-param "~state" "running")

  (fetch-init)
  (setq *robot* *fetch*)

  (setq hover-cube (send *ri* :detect-hover-cube))
  (send hover-cube :set-color :Green 0.3)

  (setq goal (send hover-cube :copy-worldcoords))
  (send goal :orient 0 :x :world)
  (send goal :translate #f(-10 0 0) :world)
  ;;
  (setq point (send goal :copy-worldcoords))
  (send point :translate #f(-90 0 0) :world)
  (setq av (send *robot* :rarm :inverse-kinematics point))
  (send *ri* :angle-vector av (* 3 1000))
  (send *ri* :wait-interpolation)
  ;;
  (setq av (send *robot* :rarm :inverse-kinematics goal))
  (send *ri* :angle-vector av (* 1 1000))
  (send *ri* :wait-interpolation)
  ;;
  (send *ri* :start-grasp)
  ;;
  (send *ri* :angle-vector (send *robot* :fold-pose) (* 3 1000))
  (send *ri* :wait-interpolation)
  ;;
  (send *ri* :angle-vector (send *robot* :reset-pose) (* 2 1000))
  (send *ri* :wait-interpolation)

  (ros::set-param "~state" "finished")
  )
