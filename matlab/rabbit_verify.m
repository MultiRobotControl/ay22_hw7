%% Load the file
% Filename
clear all
fname = 'my_rabbit.bag';
% Create a bag file object with the file name
% by omitting the semicolon this displays some information about
% the bag file
bag = rosbag(fname);
  
% Display a list of the topics and message types in the bag file
bag.AvailableTopics;

% Create a time series of the Odometry data
% Retrieve the messages as a cell array
odom_msgs = select(bag,'Topic','/rabbit');
 
% Create a timeseries object of the subset of message fields we are interested in
odom_ts = timeseries(odom_msgs,'Point.X','Point.Y');

% Plot X vs Y position
figure(1); clf();
x=odom_ts.Data(:,1);
y=odom_ts.Data(:,2);
plot(x,y,'.')
hold on
xlabel('X [m]')
ylabel('Y [m]')
legend('Rabbit Position','Location',"best")
grid on

% Plot X/Y Position vs Time
figure(2); clf();
subplot(2,1,1)
plot(odom_ts.Time,odom_ts.Data(:,1))
hold on
xlabel('Time [s]')
ylabel('X Position [m]')
grid on
title('Rabbit X/Y Position vs Time')
subplot(2,1,2)
plot(odom_ts.Time, odom_ts.Data(:,2),'r')
xlabel('Time [s]')
ylabel('Y Position [m]')
grid on

