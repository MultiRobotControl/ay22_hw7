function [v_c, r_c] = vbap_slsv(USV_ODOM, RABBIT_POSITION)
% Function prototype for implementing 
% Virtual Body, Artificial Potential - Single Leader, Single Vehicle

% Rabbit Position
X_r=RABBIT_POSITION.Point.X;
Y_r=RABBIT_POSITION.Point.Y;

% USV Position
X_usv=USV_ODOM.Pose.Pose.Position.X;
Y_usv=USV_ODOM.Pose.Pose.Position.Y;

% USV Angle (from quaternions)
W=USV_ODOM.Pose.Pose.Orientation.W;
X=USV_ODOM.Pose.Pose.Orientation.X;
Y=USV_ODOM.Pose.Pose.Orientation.Y;
Z=USV_ODOM.Pose.Pose.Orientation.Z;

q = [W,X,Y,Z];
e = quat2eul(q);
psi=rad2deg(e(1));

% Angular Error and Correction
% Convert USV orientation and goal to angles 0-360 degrees
% Values converted to degrees for visualization/testing
% Control law will be based on angle in radians

if psi <0
    psi=psi+360;
end

Y_err=(Y_r-Y_usv);
X_err=(X_r-X_usv);

% First Quadrant
if Y_err > 0 && X_err > 0
psi_goal=atand(Y_err/X_err);
end
% Second Quadrant
if Y_err > 0 && X_err < 0
psi_goal=atand(Y_err/X_err)+180;
end
% Third Quadrant
if Y_err < 0 && X_err < 0
psi_goal=atand(Y_err/X_err)+180;
end
% Fourth Quadrant
if Y_err < 0 && X_err > 0
psi_goal=atand(Y_err/X_err)+360;
end

psi_err=psi_goal-psi;

if psi_err>180
   psi_err=psi_err-(360);
   
end

if psi_err<-180
    psi_err=psi_err+(360);
end

psi
psi_goal
psi_err

% Gain Values for Surge and Yaw
k_v=0.2;
k_h=0.5;

% Just setting surge velocity and yaw-rate commands to zero.
v_c = k_v*sqrt((X_r - X_usv)^2 + (Y_r - Y_usv)^2);
r_c = k_h*deg2rad(psi_err);
%v_c=0.0;
%r_c=0.1;

return
