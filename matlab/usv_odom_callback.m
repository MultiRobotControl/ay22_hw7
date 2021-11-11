function usv_odom_callback(~, msg)

% Example callback function to be called with odometry message

% For testing only - print a message when this function is called.
disp('Received USV Odometry KM')

% Declare global variables to store odometry message
global USV_ODOM;

USV_ODOM = msg;
