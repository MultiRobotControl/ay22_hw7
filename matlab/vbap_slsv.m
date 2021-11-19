function [v_c, r_c] = vbap_slsv(USV_ODOM,RABBIT_POSITION)
% Function prototype for implementing 
% Virtual Body, Artificial Potential - Single Leader, Single Vehicle
% disp('Distance from USV to Rabbit')
% Just setting surge velocity and yaw-rate commands to zero.
K_v = 0.1; %velocity gain
K_h = 0.1; %heading gain
x_usv = USV_ODOM.Pose.Pose.Position.X;
y_usv = USV_ODOM.Pose.Pose.Position.Y;
x_rab = RABBIT_POSITION.Point.X;
y_rab = RABBIT_POSITION.Point.Y;

%Compute surge velocity
v_c = K_v*sqrt((x_rab-x_usv)^2+(y_rab-y_usv)^2);

% Compute heading velocity
% 1. Heading info
W = USV_ODOM.Pose.Pose.Orientation.W;
X = USV_ODOM.Pose.Pose.Orientation.X;
Y = USV_ODOM.Pose.Pose.Orientation.Y;
Z = USV_ODOM.Pose.Pose.Orientation.Z;

q = [W,X,Y,Z];
e = quat2eul(q);
hdg = e(:,1)*180/pi; %heading in degrees
hdg1 = wrapTo180(hdg);%constrain heading to + or - 180deg

% 2. Compute heading to the rabbit
hdg2rab = atan2((y_rab-y_usv),(x_rab-x_usv))*180/pi; %degrees
hdg2rab_1 = wrapTo180(hdg2rab-hdg1);
% 3. Heading velocity output
r_c = K_h*(hdg2rab_1);
return
