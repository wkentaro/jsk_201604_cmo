#!/usr/bin/env python

from gazebo_msgs.msg import ModelStates
from geometry_msgs.msg import PoseStamped
import rospy
import rostest
import unittest


class TestLevel1(unittest.TestCase):

    def setUp(self):
        self.sub_end_effector = rospy.Subscriber(
            '~end_effector', PoseStamped, self._cb_end_effector)
        self.sub_model = rospy.Subscriber(
            '/gazebo/model_states', ModelStates, self._cb_model_states)

    def _cb_end_effector(self, msg):
        self.pose_end_effector = msg.pose

    def _cb_model_states(self, msg):
        name = 'hover_cube'
        index = msg.name.index(name)
        self.pose_model = msg.pose[index]

    def assertAlmostEqualPose(self, pose0, pose1):
        rospy.loginfo('Checking diff beteween\n%s\nand\n%s' % (pose0, pose1))
        for attr in 'xyz':
            self.assertAlmostEqual(
                getattr(pose0.position, attr),
                getattr(pose1.position, attr),
                delta=0.1,
            )
        for attr in 'xyzw':
            self.assertAlmostEqual(
                getattr(pose0.orientation, attr),
                getattr(pose1.orientation, attr),
                delta=0.1,
            )

    def test_model_pose(self):
        # wait for finish of task
        while rospy.get_param('~state', None) != 'finished':
            rospy.loginfo('Waiting for level1 task to finish')
            rospy.sleep(1)

        self.assertAlmostEqualPose(self.pose_model, self.pose_end_effector)


if __name__ == '__main__':
    PKG = 'jsk_201604_cmo'
    ID = 'test_level1'
    rospy.init_node(ID)
    rostest.rosrun(PKG, ID, TestLevel1)
