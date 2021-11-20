function [v_c, r_c] = vbap_slsv(USV_ODOM, RABBIT_POSITION)
% Function prototype for implementing 
% Virtual Body, Artificial Potential - Single Leader, Single Vehicle

%% Inputs
% pull cora state information
cora_state.x = USV_ODOM.Pose.Pose.Position.X; % [m]
cora_state.y = USV_ODOM.Pose.Pose.Position.Y; % [m]
cora_state.u = USV_ODOM.Twist.Twist.Linear.X; % [m/s]
cora_state.v = USV_ODOM.Twist.Twist.Linear.Y;    % [m/s]
%cora_state.psi = USV_ODOM.Twist.Twist.Angular.Z; % [rad/sec]
cora_state.w_angle = USV_ODOM.Pose.Pose.Orientation.W; % [quat]
cora_state.x_angle = USV_ODOM.Pose.Pose.Orientation.X; % [quat]
cora_state.y_angle = USV_ODOM.Pose.Pose.Orientation.Y; % [quat]
cora_state.z_angle = USV_ODOM.Pose.Pose.Orientation.Z; % [quat]

q = [cora_state.w_angle, cora_state.x_angle, ...
     cora_state.y_angle, cora_state.z_angle];
e = quat2eul(q); % convert to euler angle
cora_state.psi = rad2deg(e(1));


% pull rabbit state information
rabbit_state.x = RABBIT_POSITION.Point.X;
rabbit_state.y = RABBIT_POSITION.Point.Y;

% SLSV Gains
k_v = 0.2;
k_r = 0.5;

%% Function
% psi error correction
if cora_state.psi < 0
    cora_state.psi = cora_state.psi + 360;
end

% find distance to rabbit
err.x = rabbit_state.x - cora_state.x;
err.y = rabbit_state.y - cora_state.y;

% prevent psi wrapping
if err.y > 0 && err.x > 0
    target_psi = atand(err.y/err.x);
elseif (err.y > 0 && err.x < 0) || (err.y < 0 && err.x < 0)
    target_psi = atand(err.y/err.x) + 180;
elseif err.y < 0 && err.x > 0
    target_psi = atand(err.y/err.x) + 360;
end

err.psi = target_psi - cora_state.psi;

if err.psi > 180
    err.psi = err.psi - 360;
elseif err.psi < -180
    err.psi = err.psi + 360;
end

% rotate from intertial frame to body frame
% R_ib = [cos(cora_state.psi), -sin(cora_state.psi); sin(psi),  ...
%         cos(cora_state.psi)];    

% Convert from intertial frame to body frame
% cora_body_acc = R_ib'*[cora_intertial_acc_x ; cora_intertial_acc_y];
% cora_state.u_dot = cora_body_acc(1);
% cora_state.v_dot = cora_body_acc(2);

%% Output
v_c = k_v * sqrt((rabbit_state.x - cora_state.x)^2 + ...
                 (rabbit_state.y - cora_state.y)^2);
r_c = k_r * deg2rad(err.psi);
                   
% if err > 180
%     err = err - 360;
% elseif err < 180
%     err = err + 360;
% end
return
