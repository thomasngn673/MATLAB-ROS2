%% Initialization
test_1 = ros2node("/test1"); % create a node called '/test1' with default domain ID of 0, assign to variable 'test1'
ros2 node list % see all current nodes in ROS2 network
clear test1 % shuts down specified node 'test1' in ROS2 network

%% Topics
% each node has a topic, different nodes can have the same topics

ros2 topic list -t
% parameter_events: used by nodes to monitor/change parameters in network
% each topic has a message type

%% Message Information/Inspection
ros2 msg show geometry_msgs/Twist
ros2 msg show geometry_msgs/Vector3 % message types can be further inspected

%% Connect to ROS2 Network
% each node has a domain ID for the network they connect to, different
% nodes can have the same network ID

defaultNode = ros2node("/default_node"); % create a default node with default domain ID of 0
clear defaultNode % clears default node

newDomainNode = ros2node("/new_domain_node",25); % create a node with domain ID of 25
ros2("node","list","DomainID",25) % list all nodes with domain ID 25

getenv("ROS_DOMAIN_ID"); % display the default value for default domain ID which is 0
setenv("ROS_DOMAIN_ID","25"); % set new default domain ID to 25
ros2node("/env_domain_node"); % call new domain node
setenv("ROS_DOMAIN_ID",""); % reset default domain ID to 0

%% Exchange Data Using Messages with Publishers and Subscribers
% - nodes send and receive messages
% - messages are transmitted on a topic
% - nodes use publishers to send data to a topic and subscribers to
% receive data from that topic 

%% Subscribe & Wait for Messages - read messages from topic
% Run "exampleHelperROS2CreateSampleNetwork.m"
detectNode = ros2node("/detection"); % create node called "/detection"
pause(2);
laserSub = ros2subscriber(detectNode,"/scan"); % subscribe to topic "/scan" (from topic list) using newly-created node 
pause(2);
scanData = recieve(laserSub,10); % acquire data from subscriber and store in 'scanData' for 10 seconds
clear laserSub % remove subscriber
clear detectNode % remove node from network

%% Subscribe Using Callback Functions
controlNode = ros2node("/base_station"); % create node 
poseSub = ros2subscriber(controlNode,"/pose",@exampleHelperROS2PoseCallback); % subscribe to /pose with controlNode
global pos;
global orient;
pause(3);
disp(pos)
disp(orient)
clear poseSub
clear controlNode

%% Publish Messages - sends messages to topic
chatterPub = ros2publisher(node_1,"/chatter","std_msgs/String"); % create publisher that sends string messages to /chatter topic
chatterMsg = ros2message(chatterPub); % create message to send to chatter topic
chatterMsg.data = 'hello world'; % specify message content
chatterSub = ros2subscriber(node_2,"/chatter",@exampleHelperROS2ChatterCallback); % define subsciber for /chattertopic
send(chatterPub,chatterMsg); % publish message to /chatter topic
pause(3)

clear global pos orient % clear global variables
clear % clear sample nodes, publishers, subscribers

%% Message Type Information
ros2 topic list -t
% Anatomy of MessageType: {rcl_interfaces/ParameterEvent'}
% 'rcl_interfaces' = package name
% 'ParameterEvent' = type name
scanData = ros2message("sensor_msgs/LaserScan"); % lists field information about message type
clear scanData % clear created message

%% Getting Message Data Using Subscribers
ros2 msg show geometry_msgs/Twist
controlNode = ros2node("/base_station"); % create controlNode called '/base_station'
poseSub = ros2subscriber(controlNode,"/pose","geometry_msgs/Twist");    % subscribe controlNode to /pose topic with specific 'geometry_msgs/Twist' type
% displays subscriber with properties like TopicName, History, Depth

poseData = receive(poseSub,10); % acquire data from subscriber and store in 'poseData' for 10 seconds
poseData.linear % message has type of geometry_msgs/Twist, displays linear
poseData.angular % displays angular
poseData.linear.x

%% Set Message Data
twist = ros2message("geomtry_msgs/Twist"); % lists field information about message type
twist.linear.y = 5; % changes properties of message
twist.linear % check if message data change took place

%% Copy Messages
thermometerNode = ros2node("/thermometer"); % create node named '/thermometer'
tempPub = ros2publisher(thermometerNode,"/temperature","sensor_msgs/Temperature"); % subscribe thermometerNode to /temperature topic with specific type
tempMsgs(10) = tempMsgBlank; % Pre-allocate messages structure array
for iMeasure = 1:10
    % Create blank message fields for each increment
    tempMsgs(iMeasure) = tempMsgBlank;
    
    % Assgign random value to tempMsgs for current increment
    tempMsgs(iMeasure).temperature = 20+randn*3;
    
    % Only calculate variance if sufficient data is observed
    if iMeasure >= 5
        tempMsgs(iMeasure).variance = var([tempMsgs(1:iMeasure).temperature]);
    end
    
    send(tempPub,tempMsgs(iMeasure))
end
errorbar([tempMsgs.temperature],[tempMsgs.variance]);

%% Save and Load Messages
poseData = receive(poseSub,10); % acquire message from subscriber and store in poseData
save("poseFile.mat","poseData"); % save poseData as poseFile.mat
clear poseData % clear variable (not file)
messageData = load("poseFile.mat"); % load file into messageData
messageData.poseData % examine to see message contents
delete("poseFile.mat")