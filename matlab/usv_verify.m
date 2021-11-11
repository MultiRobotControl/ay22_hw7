%% Load the file
% Filename
clear all

fname = '2021-11-11-00-17-38.bag';       % Filename
%Create a bag file object with the file name
bag = rosbag(fname)
%Display a list of the topics and message types in the bag file
bag.AvailableTopics

%Create time series for the Odometry & Command data
%Retrieve the messages as a cell array
rabbit_msgs = select(bag,'Topic','/rabbit');
odom_msgs = select(bag,'Topic','/cora/sensors/p3d');
cmd_msgs = select(bag,'Topic','/cora/cmd_vel');

%Create a timeseries object of the subset of message fields we are interested in
odom_ts = timeseries(odom_msgs,'Pose.Pose.Position.X','Pose.Pose.Position.Y', ...
'Pose.Pose.Orientation.W','Pose.Pose.Orientation.X','Pose.Pose.Orientation.Y','Pose.Pose.Orientation.Z', ...
    'Twist.Twist.Linear.X','Twist.Twist.Linear.Y','Twist.Twist.Angular.Z');
cmd_ts = timeseries(cmd_msgs,'Linear.X','Linear.Y','Linear.Z','Angular.X','Angular.Y','Angular.Z');
rabbit_ts = timeseries(rabbit_msgs,'Point.X','Point.Y');



%Plot X / Y Positions of the Rabbit
figure(1); clf();
%Plot the Data indicies for X and Y
hold on
plot(rabbit_ts.Data(:,2),rabbit_ts.Data(:,1))
plot(odom_ts.Data(:,2),odom_ts.Data(:,1))
xlabel('East [m]')
ylabel('North [m]')
legend('Rabbit Position','CORA Position')
title('Rabbit X/Y Position')
axis padded

grid on

%Plot X & Y vs Time
figure(2); clf();
%Plot X vs time
subplot(2,1,1)
hold on
plot(rabbit_ts.Time-rabbit_ts.Time(1),rabbit_ts.Data(:,1))
plot(odom_ts.Time-odom_ts.Time(1),odom_ts.Data(:,1))
xlabel('Time [s]')
ylabel('X-position (NORTH) [m]')
legend('Rabbit position','CORA Position')
title('X & Y position vs. Time')
axis padded
grid on
%Plot Y vs Time
subplot(2,1,2)
hold on
plot(rabbit_ts.Time-rabbit_ts.Time(1),rabbit_ts.Data(:,2))
plot(odom_ts.Time-odom_ts.Time(1),odom_ts.Data(:,2))
grid on
xlabel('Time [s]')
ylabel('Y-position (EAST) [m]')
legend('Rabbit Position','CORA Position')
axis padded

% Plot Vel vs. Time
figure(3); clf();
subplot(3,1,1)
hold on
plot(cmd_ts.Time-cmd_ts.Time(1),cmd_ts.Data(:,1))
plot(odom_ts.Time-odom_ts.Time(1),odom_ts.Data(:,7))
xlabel('Time [s]')
ylabel('X-Velocity [m/s]')
legend('cmd','CORA')
title(' CMD & Odom vs. Time')
axis padded
grid on

subplot(3,1,2)
hold on
plot(cmd_ts.Time-cmd_ts.Time(1),cmd_ts.Data(:,2))
plot(odom_ts.Time-odom_ts.Time(1),odom_ts.Data(:,9))
xlabel('Time [s]')
ylabel('Yaw Velocity [rad/s]')
legend('cmd','CORA')
axis padded
grid on

subplot(3,1,3)
hold on
plot(cmd_ts.Time-cmd_ts.Time(1),cmd_ts.Data(:,6))
plot(odom_ts.Time-odom_ts.Time(1),odom_ts.Data(:,7))
xlabel('Time [s]')
ylabel('X-Velocity [m/s]')
legend('cmd','CORA')
axis padded
grid on
