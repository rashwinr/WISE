 %% BEGIN
%%Clearing all the variables used and delete any Serial Port Objects
clear
clc
close all
% Add path to the kinect 2.0 interface by Juan and Diana
addpath('D:\MatLab\Kin2')
addpath('D:\MatLab\Kin2\Mex');

%%
% Create Kinect 2 object and initialize it
% Available sources: 'color', 'depth', 'infrared', 'body_index', 'body',
% 'face' and 'HDface'
k2 = Kin2('color','depth','body');
% images sizes
d_width = 512; d_height = 424; outOfRange = 4000;
c_width = 1920; c_height = 1080;

% Color image is to big, let's scale it down
COL_SCALE = 1.0;

% Create matrices for the images
depth = zeros(d_height,d_width,'uint16');
color = zeros(c_height*COL_SCALE,c_width*COL_SCALE,3,'uint8');

% depth stream figure
d.h = figure;
d.ax = axes;
d.im = imshow(zeros(d_height,d_width,'uint8'));
%hold on;

title('Depth Source (press q to exit)')
set(gcf,'keypress','k=get(gcf,''currentchar'');'); % listen keypress

% color stream figure
c.h = figure;
c.ax = axes;
c.im = imshow(color,[]);
title('Color Source (press q to exit)');
set(gcf,'keypress','k=get(gcf,''currentchar'');'); % listen keypress
%hold on

% Loop until pressing 'q' on any figure
k=[];

disp('Press q on any figure to exit')
while true
    % Get frames from Kinect and save them on underlying buffer
    validData = k2.updateData;
    
    % Before processing the data, we need to make sure that a valid
    % frame was acquired.
    if validData
        % Copy data to Matlab matrices
        depth = k2.getDepth;
        color = k2.getColor;

        % update depth figure
        depth8u = uint8(depth*(255/outOfRange));
        depth8uc3 = repmat(depth8u,[1 1 3]);
        d.im = imshow(depth8uc3, 'Parent', d.ax);

        %set(d.im,'CData',depth8uc3); 

        % update color figure
        color = imresize(color,COL_SCALE);
        c.im = imshow(color, 'Parent', c.ax);

        %set(c.im,'CData',color); 

        % Get 3D bodies joints 
        % Input parameter can be 'Quat' or 'Euler' for the joints
        % orientations.
        % getBodies returns a structure array.
        % The structure array (bodies) contains 6 bodies at most
        % Each body has:
        % -Position: 3x25 matrix containing the x,y,z of the 25 joints in
        %   camera space coordinates
        % - Orientation: 
        %   If input parameter is 'Quat': 4x25 matrix containing the 
        %   orientation of each joint in [x; y; z, w]
        %   If input parameter is 'Euler': 3x25 matrix containing the 
        %   orientation of each joint in [Pitch; Yaw; Roll] 
        % -TrackingState: state of each joint. These can be:
        %   NotTracked=0, Inferred=1, or Tracked=2
        % -LeftHandState: state of the left hand
        % -RightHandState: state of the right hand
        
        [bodies, fcp, timeStamp] = k2.getBodies('Quat');        
        %[bodies, fcp, timeStamp] = k2.getBodies('Euler');   
        % Number of bodies detected
        numBodies = size(bodies,2);
        disp(['Bodies Detected: ' num2str(numBodies)])
        
        % Example of how to extract information from getBodies output.
       if numBodies > 0
            % first body info:
            %disp(bodies(1).TrackingState)
            %disp(bodies(1).RightHandState)
            %disp(bodies(1).LeftHandState)
            
            %disp('Right Hand Orientation') % see Kin2.m constants
            %disp(bodies(1).Orientation(:,k2.JointType_HandRight));   
            
            %disp('Left Elbow Orientation') % see Kin2.m constants
            %disp(bodies(1).Orientation(:,k2.JointType_ElbowLeft)); 
            
            %disp('Floor Clip Plane')
            %disp(fcp);
            
            
        
           % To get the joints on depth image space, you can use:
           % pos2D = k2.mapCameraPoints2Depth(bodies(1).Position');
           %To track the state of the joints: 0 not tracked, 1 inferred, 2
           %tracked.
           trackXXX= bodies(1).TrackingState; 
           pos2Dxxx = bodies(1).Position;% All 24 joints positions are stored to the variable pos2Dxxx.
            leftShoulder = pos2Dxxx(:,5); % Left arm(modified): 5,6,7 ; RightArm: 9,10,11
            leftElbow = pos2Dxxx(:,6);
            leftWrist = pos2Dxxx(:,7);
            
            rightShoulder = pos2Dxxx(:,9); % Left arm: 4,5,6 ; RightArm: 8,9,10
            rightElbow = pos2Dxxx(:,10);
            rightWrist = pos2Dxxx(:,11);
            
            % Eliminating the Z component for 2D data
            leftShoulderXY=leftShoulder(1:2);
            leftElbowXY=leftElbow(1:2);
            leftWristXY=leftWrist(1:2);
            
            rightShoulderXY=rightShoulder(1:2);
            rightElbowXY=rightElbow(1:2);
            rightWristXY=rightWrist(1:2);
                      
            %Left Elbow joint angle calculation
            L1=leftShoulderXY-leftElbowXY;
            L2=leftWristXY-leftElbowXY;
            %elbowAngle= atan2d(norm(cross(v1,v2)),dot(v1,v2));
            leftelbowAngle=acosd(dot(L1,L2)/(norm(L1)*norm(L2)));
           
            %Right Elbow joint angle calculation
            R1=rightShoulderXY-rightElbowXY;
            R2=rightWristXY-rightElbowXY;
            %elbowAngle= atan2d(norm(cross(v1,v2)),dot(v1,v2));
            rightelbowAngle=acosd(dot(R1,R2)/(norm(R1)*norm(R2)));
            
            %For dispalying
                        
            %disp('Body Timestamp');
            disp('Time:')
            disp(timeStamp);
            %disp('Tracking status');
            %disp(trackXXX);
            %disp('All joints');
            %disp(pos2Dxxx);
%             disp('Left Elbow X and Y values');
%             disp(leftElbowXY);
%             disp('Left Shoulder XY');
%             disp(leftShoulderXY);
%             disp('Left Wrist');
%             disp(leftWristXY);       
            disp('Left Elbow angle');
            disp(leftelbowAngle);

%             disp('Right Elbow X and Y values');
%             disp(rightElbowXY);
%             disp('Right Elbow angle');
%             disp(rightelbowAngle);           
                
       end
         
        %To get the joints on color image space, you can use:
        %pos2D = k2.mapCameraPoints2Color(bodies(1).Position');

        % Draw bodies on depth image
        k2.drawBodies(d.ax,bodies,'depth',5,3,15);
        
        % Draw bodies on color image
        %k2.drawBodies(c.ax,bodies,'color',10,6,30);
        k2.drawBodies(c.ax,bodies,'color',5,4,10);
    end
    
    % If user presses 'q', exit loop
    if ~isempty(k)
        if strcmp(k,'q'); break; end;
    end
  
    pause(0.02)
end

% Close kinect object
k2.delete;
close all;
