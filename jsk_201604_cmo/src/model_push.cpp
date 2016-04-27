#include <boost/bind.hpp>
#include <gazebo/gazebo.hh>
#include <gazebo/physics/physics.hh>
#include <gazebo/common/common.hh>
#include <stdio.h>

namespace gazebo
{
  class ModelPush : public ModelPlugin
  {
    public: void Load(physics::ModelPtr _parent, sdf::ElementPtr /*_sdf*/)
    {
      // Store the pointer to the model
      model_ = _parent;

      std::string link_name = "link";
      link_ = model_->GetLink(link_name);

      // Listen to the update event. This event is broadcast every
      // simulation iteration.
      updateConnection_ = event::Events::ConnectWorldUpdateBegin(
          boost::bind(&ModelPush::OnUpdate, this, _1));
    }

    // Called by the world update start event
    public: void OnUpdate(const common::UpdateInfo & /*_info*/)
    {
      // Apply a small linear velocity to the model.
      // model_->SetLinearVel(math::Vector3(.03, 0, 0));
      link_->AddForce(math::Vector3(0, 0, 9.8 / 4));
    }

    // Pointer to the model
    private: physics::ModelPtr model_;
    //
    // Pointer to the link
    private: physics::LinkPtr link_;

    // Pointer to the update event connection
    private: event::ConnectionPtr updateConnection_;
  };

  // Register this plugin with the simulator
  GZ_REGISTER_MODEL_PLUGIN(ModelPush)
}  // namespace gazebo
