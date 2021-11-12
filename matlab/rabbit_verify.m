%% ay22_hw7 - Tim Howarth
%% Load the file
% Filename
fname = 'my_rabbit_test.bag';
% Create a bag file object with the file name
% by omitting the semicolon this displays some information about
% the bag file
bag = rosbag(fname);
  
% Display a list of the topics and message types in the bag file
bag.AvailableTopics
 
%% Create a time series of the Odometry data
% Retrieve the messages as a cell array
odom_msgs = select(bag,'Topic','/rabbit');
 
% Create a timeseries object of the subset of message fields we are interested in
odom_ts = timeseries(odom_msgs,'Point.X', 'Point.Y', 'Point.Z');

%% XY
figure(1); clf();
% Plot the Data index corresponding to X Y
plot(odom_ts.Data(:,1), odom_ts.Data(:,2))
title('XY Posit of rabbit')
hold on
xlabel('X [m]')
ylabel('Y [m]')
xlim([0 60]);
grid on

%% plot x vs time and y vs time
figure(2); clf();
    subplot(2,1,1)
    plot(odom_ts.Time, odom_ts.Data(:,1));
    title('X Posit vs Time');
    xlabel('Time');
    ylabel('X');
    grid on
    ylim([0 60]);
    
    subplot(2,1,2)
    plot(odom_ts.Time, odom_ts.Data(:,2));
    title('Y Posit vs Time');
    xlabel('Time');
    ylabel('Y');
    grid on