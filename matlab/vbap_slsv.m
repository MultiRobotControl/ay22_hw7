function [u_c, r_c] = vbap_slsv(USV_ODOM, RABBIT_POSITION)
% Function prototype for implementing 
% Virtual Body, Artificial Potential - Single Leader, Single Vehicle

u = USV_ODOM.Twist.Twist.Linear.X;    % CORA Surge Velocity [m/s]
v = USV_ODOM.Twist.Twist.Linear.Y;    % CORA Sway Velocity [m/s]
psi = USV_ODOM.Twist.Twist.Angular.Z; % CORA Yaw Rate [rad/sec]

R_ib = [cos(psi), -sin(psi);...     % Rotation matrix from intertial frame
        sin(psi),  cos(psi)];       % to body frame

dist2rabbit_x = RABBIT_POSITION.Point.X - USV_ODOM.Pose.Pose.Position.X;
dist2rabbit_y = RABBIT_POSITION.Point.Y - USV_ODOM.Pose.Pose.Position.Y;


k_vl = -0.5;      % Attraction to Virtual Leader
k_dx = 0.05;      % Surge Damping Term
k_dy = 0.2;      % Sway Damping Term

% control law
CORA_inertial_accel_x = -k_vl * abs(dist2rabbit_x) * dist2rabbit_x * (1/sqrt(dist2rabbit_x^2)) -k_dx*u;
CORA_inertial_accel_y = -k_vl * abs(dist2rabbit_y) * dist2rabbit_y * (1/sqrt(dist2rabbit_y^2)) -k_dy*v;

% Convert from intertial frame to body frame
CORA_body_accel = R_ib'*[CORA_inertial_accel_x ; CORA_inertial_accel_y];

u_dot_u = CORA_body_accel(1);
v_dot_u = CORA_body_accel(2);
% Send commands to CORA
dt = 0.1; 
k_r = 0.05;       % Turn Rate Gain   
u_c = u + u_dot_u *dt;  % Surge Velocity Command
r_c = k_r * v_dot_u;        % Yaw Rate Command i.e Turn Rate Cmd
return