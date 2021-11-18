% Processing script for VBAP SLSV
% Filename
clear all
fname = 'vbap_slsv.bag';
% Create a bag file object with the file name
% by omitting the semicolon this displays some information about
% the bag file
bag = rosbag(fname);
  
% Display a list of the topics and message types in the bag file
bag.AvailableTopics;

% Create a time series of the Odometry data
% Retrieve the messages as a cell array

odom_msgs_rabbit = select(bag,'Topic','/rabbit');
odom_msgs_cora = select(bag,'Topic','/cora1/cora/sensors/p3d');

% Create a time series of the command velocity data
cmd_msgs_cora = select(bag,'Topic','/cora1/cora/cmd_vel');

% Create a timeseries object of the subset of message fields we are interested in
odom_ts_rabbit = timeseries(odom_msgs_rabbit,'Point.X','Point.Y');
odom_ts_cora = timeseries(odom_msgs_cora,'Pose.Pose.Position.X','Pose.Pose.Position.Y',...
    'Pose.Pose.Orientation.W','Pose.Pose.Orientation.X','Pose.Pose.Orientation.Y',...
    'Pose.Pose.Orientation.Z', ...
    'Twist.Twist.Linear.X');

% Plot X vs Y position with Velocity Vectors
figure(1); clf();

% X/Y Position
x_r=odom_ts_rabbit.Data(:,1);
y_r=odom_ts_rabbit.Data(:,2);
x_usv=odom_ts_cora.Data(:,1);
y_usv=odom_ts_cora.Data(:,2);
% Heading angle
q = odom_ts_cora.Data(:,3:6);
e = quat2eul(q);
psi=(e(1));
% Velocity Vectors
vel=odom_ts_cora.Data(:,7);
u_usv = vel.*cos(psi);
v_usv = vel.*sin(psi);
ii = 1:5:length(x_usv);  

plot(x_r,y_r,'.')
hold on
plot(x_usv,y_usv,'r.')
quiver(x_usv(ii),y_usv(ii),u_usv(ii),v_usv(ii))
xlabel('X [m]')
ylabel('Y [m]')
legend('Rabbit Position','USV Position','Location',"best")
grid on


% Plot X/Y Position vs Time
time_r=odom_ts_rabbit.Time;
time_usv=odom_ts_cora.Time;
figure(2); clf();
subplot(2,1,1)
plot(time_r,x_r)
hold on
plot(time_usv,x_usv)
xlabel('Time [s]')
ylabel('X Position [m]')
grid on
title('Rabbit and USV X/Y Position vs Time')
legend('Rabbit','USV','location','best')
subplot(2,1,2)
plot(time_r,y_r,'r')
hold on
plot(time_usv,y_usv)
xlabel('Time [s]')
ylabel('Y Position [m]')
grid on
legend('Rabbit','USV','location','best')
