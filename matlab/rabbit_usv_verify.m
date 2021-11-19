%% Load the file
% Filename
clear all

fname = '2021-11-18-21-38-23.bag';
% Create a bag file object with the file name
% by omitting the semicolon this displays some information about
% the bag file
bag = rosbag(fname);
  
% Display a list of the topics and message types in the bag file
bag.AvailableTopics;

odom_msgs_rab = select(bag, 'Topic', '/rabbit');
odom_msgs_usv = select(bag, 'Topic', '/cora1/cora/sensors/p3d');
cmd_msgs_usv = select(bag, 'Topic', '/cora1/cora/cmd_vel');

%Timeseries for rabbit
odom_ts_rab = timeseries(odom_msgs_rab, 'Point.X', 'Point.Y');

odom_ts_usv = timeseries(odom_msgs_usv,'Pose.Pose.Position.X','Pose.Pose.Position.Y',...
    'Pose.Pose.Orientation.W','Pose.Pose.Orientation.X','Pose.Pose.Orientation.Y',...
    'Pose.Pose.Orientation.Z', ...
    'Twist.Twist.Linear.X');

% Plot X-Y Pos for Rabbit and USV
figure(1); clf();
hold on
plot(odom_ts_rab.Data(:,1), odom_ts_rab.Data(:,2), 'LineWidth', 2);
plot(odom_ts_usv.Data(:,1), odom_ts_usv.Data(:,2), 'r', 'LineWidth', 2);
legend('Rabbit', 'USV', 'Location', 'best');
title('(3) X-Y Position of Rabbit and USV')
xlabel('X');
ylabel('Y');
xlim([0 60]);
grid on

% Plot X Pos vs. Time and Y Pos vs. Time

figure (2); clf();
subplot(2,1,1);
hold on
plot(odom_ts_rab.Time, odom_ts_rab.Data(:,1), 'LineWidth', 2);
plot(odom_ts_usv.Time, odom_ts_usv.Data(:,1), 'r', 'LineWidth', 2);
legend('Rabbit', 'USV', 'Location', 'best');
title('(4.1) X Position vs Time for Rabbit and USV');
xlabel('Time');
ylabel('X');
grid on
ylim([0 60]);

subplot(2,1,2);
hold on
plot(odom_ts_rab.Time, odom_ts_rab.Data(:,2), 'LineWidth', 2);
plot(odom_ts_usv.Time, odom_ts_usv.Data(:,2), 'r', 'LineWidth', 2);
legend('Rabbit', 'USV', 'Location', 'best');
title('(2.2) Y Position vs Time for Rabbit and USV');
xlabel('Time');
ylabel('Y');
grid on
