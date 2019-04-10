function newAngle = WristR_correct(rightWristAngle_raw)
    
if (rightWristAngle_raw >155) % Perpendicular pose of wrist
newAngle=0.65; % Wrist joint value for straight pose
else
newAngle=0.2; %Wrist joint value for Up/Dowm pose

end

end