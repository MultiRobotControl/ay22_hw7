% Globals
% We will declare global variables that this function and the callbacks
% can all access
% When we receive an odometry messge, save it here.
global USV_ODOM;  
% When we receive a rabbit posiition, save it here
global RABBIT_POSITION;
% set global time step


% Try to start ROS - if it is already started, restart
try
    rosinit
catch
    rosshutdown
    rosinit
end

% Subscribers
usv_sub = rossubscriber('/cora1/cora/sensors/p3d',@usv_odom_callback, 'DataFormat', 'struct');
rabbit_sub = rossubscriber('/rabbit',@rabbit_position_callback, 'DataFormat', 'struct');
% Assign  message
RABBIT_POSITION = rosmessage('geometry_msgs/PointStamped');

% Setup Publisher
cmd_pub = rospublisher('/cora1/cora/cmd_vel','geometry_msgs/Twist');
cmd_msg = rosmessage(cmd_pub);

% Infinite loop
while true
    % Call a function to implement the VBAP algorithm.
    [u_c, r_c] = vbap_slsv(USV_ODOM, RABBIT_POSITION);
    
    % Publish the results
    cmd_msg.Linear.X = u_c;
    cmd_msg.Angular.Z = r_c;
    send(cmd_pub, cmd_msg);
    
    pause(0.1);   
end