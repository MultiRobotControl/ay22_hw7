function rabbit_callback(~, msg)

% Example callback function to be called with odometry message

% For testing only - print a message when this function is called.
% disp('Received Rabbit Position')

% Declare global variables and store Odometry message
global RABBIT_POSITION;
RABBIT_POSITION = msg;

