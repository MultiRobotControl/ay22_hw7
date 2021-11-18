function usv_odom_callback(~, msg)

% Example callback function to be called with odometry message

% For testing only - print a message when this function is called.
%disp('Received USV Odometry')
% USV Position
%X_usv=msg.Pose.Pose.Position.X;
%Y_usv=msg.Pose.Pose.Position.Y;

% USV Angle (from quaternions)
%W=msg.Pose.Pose.Orientation.W;
%X=msg.Pose.Pose.Orientation.X;
%Y=msg.Pose.Pose.Orientation.Y;
%Z=msg.Pose.Pose.Orientation.Z;

%q = [W,X,Y,Z];
%e = quat2eul(q);
%yaw = e(1)


% Declare global variables and store Odometry message
global USV_ODOM;
USV_ODOM = msg;
