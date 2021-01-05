%% Build a Robot Step by Step Functions
% (name of body) = rigidBody('(name of body)')
% (name of joint) = rigidBodyJoint('(name of joint)','(joint type)')
% (name of joint).HomePosition = (position angle)
% (tform variable) = trvec2tform([x, y, z])
% setFixedTransform((name of joint),(tform variable))
% (name of body).Joint = (name of joint)

% robot = rigidBodyTree

% addBody(robot,(name of body),'base') % (name of body) added to 'base'
% setFixedTransform(bodyEndEffector.Joint, (tform variable))
% (config variable) = randomConfiguration(robot)
% getTransform(robot,(config variable),'(name of body)','base')

% (newSubtree) = subtree(robot,'(name of body)')
% removeBody((newSubtree),'(name of body)')

% (copy of body) = copy(getBody((newSubtree),'(name of body in newSubtree)'))
% replaceBody(newSubtree,'(name of body being replaced)',(copy of body that is replacing))
% addSubtree(robot,'(name of body being added on)',(name of body that is added))

% showdetails(robot)