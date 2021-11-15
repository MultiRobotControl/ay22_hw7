%% Load the file
% Filename
fname = 'rabbit.bag';
% Create a bag file object with the file name
% by omitting the semicolon this displays some information about
% the bag file
bag = rosbag(fname);
  
% Display a list of the topics and message types in the bag file
bag.AvailableTopics;
 
%% Create a time series of the Odometry data
% Retrieve the messages as a cell array
odom_msgs = select(bag,'Topic','/rabbit');
 
% Create a timeseries object of the subset of message fields we are interested in
odom_ts = timeseries(odom_msgs,'Point.X','Point.Y');



%% XY Plot
figure(1);clf;
plot(odom_ts.Data(:,1),odom_ts.Data(:,2))
xlabel('X [m]')
ylabel('Y [m]')
legend('X-Y Position')
grid on
%% X vs Time; Y vs Time
figure(2);clf;
subplot(211),plot(odom_ts.Time,odom_ts.Data(:,1))
ylabel('X [m]')
grid on
subplot(212),plot(odom_ts.Time,odom_ts.Data(:,2))
grid on
ylabel('Y [m]')
xlabel('Time [s]')