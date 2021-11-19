%% Load the file
% Filename
fname = 'rabbit_follow.bag';
% Create a bag file object with the file name
% by omitting the semicolon this displays some information about
% the bag file
bag = rosbag(fname);
  
% Display a list of the topics and message types in the bag file
bag.AvailableTopics;
 
%% Create a time series of the Odometry data
% Retrieve the messages as a cell array
usv_odom_msgs = select(bag,'Topic','cora1/cora/sensors/p3d');
 
% Create a timeseries object of the subset of message fields we are interested in
usv_odom_ts = timeseries(usv_odom_msgs,'Pose.Pose.Position.X','Pose.Pose.Position.Y', ...
    'Pose.Pose.Orientation.W','Pose.Pose.Orientation.X','Pose.Pose.Orientation.Y','Pose.Pose.Orientation.Z', ...
    'Twist.Twist.Linear.X','Twist.Twist.Angular.Z');

%Time series for the twist messages sent to USV
cmd_msgs = select(bag,'Topic','/cora1/cora/cmd_vel');

cmd_ts = timeseries(cmd_msgs,'Linear.X','Linear.Y','Linear.Z',...
    'Angular.X','Angular.Y','Angular.Z');

%Time series for rabbit position
rab_msgs = select(bag,'Topic','/rabbit');

rab_ts = timeseries(rab_msgs,'Point.X','Point.Y');
%% XY Plot
figure(1);clf;
plot(usv_odom_ts.Data(:,1),usv_odom_ts.Data(:,2),rab_ts.Data(:,1),rab_ts.Data(:,2))
xlabel('X [m]')
ylabel('Y [m]')
legend('USV Track','Rabbit Track')
grid on

%% X vs Time; Y vs Time
figure(2);clf;
subplot(211),plot(usv_odom_ts.Time,usv_odom_ts.Data(:,1),rab_ts.Time,rab_ts.Data(:,1))
ylabel('X [m]')
grid on
legend('USV','Rabbit')
subplot(212),plot(usv_odom_ts.Time,usv_odom_ts.Data(:,2),rab_ts.Time,rab_ts.Data(:,2))
grid on
ylabel('Y [m]')
xlabel('Time [s]')