%% Load the file
% Filename
clear all

fname = '2021-11-18-20-35-29.bag';
% Create a bag file object with the file name
% by omitting the semicolon this displays some information about
% the bag file
bag = rosbag(fname);
  
% Display a list of the topics and message types in the bag file
bag.AvailableTopics;

odom_msgs = select(bag, 'Topic', '/rabbit');

odom_ts = timeseries(odom_msgs, 'Point.X', 'Point.Y', 'Point.Z');

% Plot X-Y Pos

figure(1); clf();
plot(odom_ts.Data(:,1), odom_ts.Data(:,2), 'LineWidth', 2);
title('(1) X-Y Position of Rabbit')
xlabel('X');
ylabel('Y');
xlim([0 60]);
grid on

% Plot X Pos vs. Time and Y Pos vs. Time

figure (2); clf();
subplot(2,1,1);
plot(odom_ts.Time, odom_ts.Data(:,1), 'LineWidth', 2);
title('(2.1) X Position vs Time');
xlabel('Time');
ylabel('X');
grid on
ylim([0 60]);

subplot(2,1,2);
plot(odom_ts.Time, odom_ts.Data(:,2), 'LineWidth', 2);
title('(2.2) Y Position vs Time');
xlabel('Time');
ylabel('Y');
grid on
