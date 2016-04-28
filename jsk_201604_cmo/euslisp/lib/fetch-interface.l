;; vim: set ft=lisp:

(require :fetch "package://fetcheus/fetch.l")
(require :fetcheus-fetch-interface "package://fetcheus/fetch-interface.l")


(ros::load-ros-manifest "jsk_2016_04_cmo")


(unless (find-package "JSK_2016_04_CMO")
  (make-package "JSK_2016_04_CMO"))


(defclass jsk_2016_04_cmo::fetch-interface
  :super fetch-interface
  :slots (_tfl)
  )

(defmethod jsk_2016_04_cmo::fetch-interface
  (:init
    (&rest args)
    (send-super* :init args)
    (setq _tfl (instance ros::transform-listener :init))
    )
  (:tf-pose->coords
    (frame_id pose)
    (let (coords)
      (setq coords (ros::tf-pose->coords pose))
      (send (send _tfl :lookup-transform "base_link" frame_id (ros::time 0)) :transform coords)
      ))
  (:bbox->cube
    (bbox)
    (let* ((dims (ros::tf-point->pos (send bbox :dimensions)))
           (cube (make-cube (elt dims 0) (elt dims 1) (elt dims 2))))
      (send cube :newcoords
            (send self :tf-pose->coords
                  (send bbox :header :frame_id)
                  (send bbox :pose)))
      cube))
  (:detect-hover-cube
    (&key (stamp (ros::time-now)))
    (let (msg)
      (setq msg
        (one-shot-subscribe "cpi_decomposer/boxes"
                            jsk_recognition_msgs::BoundingBoxArray
                            :after-stamp stamp)
        )
      (send self :bbox->cube (first (send msg :boxes)))))
  )


(defun fetch-init ()
  (unless (boundp '*fetch*)
    (setq *fetch* (instance fetch-robot :init))
    )
  (unless (boundp '*ri*)
    (setq *ri* (instance jsk_2016_04_cmo::fetch-interface :init))
    )
  )