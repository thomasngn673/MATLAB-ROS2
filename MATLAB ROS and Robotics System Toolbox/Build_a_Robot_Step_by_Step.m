%% Build a Robot Step by Step
clc,clear,close all;
% 1. Create Rigid Body
body1 = rigidBody('body1'); % create rigid body object

% 2. Attach a Joint to the Body
jnt1 = rigidBodyJoint('jnt1','revolute'); % create rigid body joint object
jnt1.HomePosition = pi/4; % define home position for joint
tform = trvec2tform([0.25, 0.25, 0]); % transform translation vector to homogeneous vector
setFixedTransform(jnt1,tform); % set fixed transform properties of joint
body1.Joint = jnt1; % assign joint as part of 'body1'

% 3. Create a Rigid Body Tree
robot = rigidBodyTree;

% 4. Add a Base as a Body to the Robot
addBody(robot,body1,'base'); % add 'body1' to 'robot' base

% 5. Add a 2nd Joint
% Summary
% -------------------------------------------------------------------------
%   1. Create rigid body.
%   2. Create joint.
%   3. Define home position of joint.
%   4. Transform translation vector to tform vector.
%   5. Set the new tform vector as the fixed transformations of the joint.
%   6. Add joint to the body.
%   7. Add body to rigid body tree.

body2 = rigidBody('body2');
jnt2 = rigidBodyJoint('jnt2','revolute');
jnt2.HomePosition = pi/6;
tform2 = trvec2tform([1, 0, 0]); 
setFixedTransform(jnt2,tform2);
body2.Joint = jnt2;
addBody(robot,body2,'body1'); % add 'body2' to 'body1' in 'robot'

% 6. Add 3rd and 4th Joint to 2nd Body
body3 = rigidBody('body3');
jnt3 = rigidBodyJoint('jnt3','revolute');
jnt3.HomePosition = pi/4;
tform3 = trvec2tform([0.6, -0.1, 0])*eul2tform([-pi/2, 0, 0]);
% transform translation vector & euler angles to homogeneous transformation
setFixedTransform(jnt3,tform3);
body3.Joint = jnt3;
addBody(robot,body3,'body2'); % add 'body3' to 'body2' in 'robot'

body4 = rigidBody('body4');
jnt4 = rigidBodyJoint('jnt4','revolute');
jnt4.HomePosition = pi/6;
tform4 = trvec2tform([1, 0, 0]);
setFixedTransform(jnt4,tform4);
body4.Joint = jnt4;
addBody(robot,body4,'body2'); % add 'body4' to 'body2' in 'robot'

% 7. Body End Effector
bodyEndEffector = rigidBody('endeffector');
tform5 = trvec2tform([0.5, 0, 0]); 
setFixedTransform(bodyEndEffector.Joint,tform5);
addBody(robot,bodyEndEffector,'body4');

% 8. Robot Configurations
config = randomConfiguration(robot); % generate random configuration
tform = getTransform(robot,config,'endeffector','base'); % get a transformation from 'endeffector' of 'body4' to 'base'

% 9. Subtree of Rigid Body Tree
newArm = subtree(robot,'body2'); % create second robot model of 'body2' and all connected parts
removeBody(newArm,'body3'); % remove 'body3' from 'body2' subtree ('body4' still attached)
removeBody(newArm,'endeffector'); % remove 'endeffector' from 'body4'

% 10. Adding Subtrees to Original Robot
newBody1 = copy(getBody(newArm,'body2')); % make a copy of 'body4' of newArm subtree (doesn't have endeffector)
newBody1.Name = 'newBody1';
newBody1.Joint = rigidBodyJoint('newJnt1','revolute');
tformTree = trvec2tform([0.2, 0, 0]);
setFixedTransform(newBody1.Joint, tformTree);
replaceBody(newArm,'body2',newBody1); % replace 'body2' with 'newBody1' in 'newArm'

newBody2 = copy(getBody(newArm,'body4'));
newBody2.Name = 'newBody2';
newBody2.Joint = rigidBodyJoint('newJnt2','revolute');
setFixedTransform(newBody2.Joint,tformTree);
replaceBody(newArm,'body4',newBody2);

addSubtree(robot,'body1',newArm);

% 11. Show Details
showdetails(robot)