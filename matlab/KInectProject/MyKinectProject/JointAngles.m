
%% THIS IS Main MATLAB file FOR THE ROBOT ARM control
% This script is responsible for getting 3D data from the Kinect. The Kinect toolbox 
% MATLAB interface for Kinect 2.0 by Terven Juan and Cordova-Esparza Dian
% is used for developing the scripts.
%% BEGIN
%%Clearing all the variables used and delete any Serial Port Objects
clear
clc
close all
% Add path to the kinect 2.0 interface by Juan and Diana
addpath('D:\MatLab\Kin2');
addpath('D:\MatLab\Kin2\Mex');
addpath('D:\MatLab\MyKinectProject');

 a = arduino('com3', 'uno');    
 s = servo(a, 'D3');

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
        [bodies, fcp, timeStamp] = k2.getBodies('Quat');        
        %[bodies, fcp, timeStamp] = k2.getBodies('Euler');   
        % Number of bodies detected
        numBodies = size(bodies,2);
        disp(['Bodies Detected: ' num2str(numBodies)])
        
        %%%%%%
        
        % Example of how to extract information from getBodies output.
       if numBodies > 0
                  
           
%%%%%%%  Measuring the joints of the body in camera space

            pos2Dxxx = bodies(1).Position;% All 24 joints positions are stored to the variable pos2Dxxx.
            %Left Side Joints
%             leftShoulder = pos2Dxxx(:,5); % Left arm(modified): 5,6,7 ; RightArm: 9,10,11
%             leftElbow = pos2Dxxx(:,6);
%             leftWrist = pos2Dxxx(:,7);
            
            %Right Side Joints
            rightShoulder = pos2Dxxx(:,9); % Left arm: 4,5,6 ; RightArm: 8,9,10
            rightElbow = pos2Dxxx(:,10);
            rightWrist = pos2Dxxx(:,11);
            rightHand = pos2Dxxx(:,12);
            rightHandtip = pos2Dxxx(:,24);
            spineShoulder = pos2Dxxx(:,21);
            
            % Eliminating the Z component for 2D data
%             leftShoulderXY=leftShoulder(1:2);
%             leftElbowXY=leftElbow(1:2);
%             leftWristXY=leftWrist(1:2);
%             rightShoulderXY=rightShoulder(1:2);
%             rightElbowXY=rightElbow(1:2);
%             rightWristXY=rightWrist(1:2);
            
%%%%%% ELBOW           

            %Right Elbow joint angle calculation 3D
            E1=rightShoulder-rightElbow;
            E2=rightWrist-rightElbow;
            %elbowAngle= atan2d(norm(cross(v1,v2)),dot(v1,v2));
            rightElbowAngle=acosd(dot(E1,E2)/(norm(E1)*norm(E2)));

%%%%%% SHOULDER 

% Right Shoulder Horizontal movement(XZ 2D)

            SH1=spineShoulder([1 3])-rightShoulder([1 3]);
            SH2=rightElbow([1 3])-rightShoulder([1 3]);
            rightShoulderAngle_h=acosd(dot(SH1,SH2)/(norm(SH1)*norm(SH2))); 

            %shoulder vertical movement angle calculation.
            SV1=spineShoulder(1:2)-rightShoulder(1:2);
            SV2=rightElbow(1:2)-rightShoulder(1:2);
            rightShoulderAngle_v=acosd(dot(SV1,SV2)/(norm(SV1)*norm(SV2))); 
 
 %%%%%% WRIST

            %Right Shoulder (Under arm) angle calculation 3D
            W1=rightElbow-rightWrist;
            W2=rightHandtip- rightWrist;
            rightWristAngle_raw=acosd(dot(W1,W2)/(norm(W1)*norm(W2))); 
            rightWristAngle=WristR_correct(rightWristAngle_raw);
                       
%%%%% GRIPPER

            rightGripper=bodies(1).RightHandState;
            
    switch rightGripper
    case 2 % Open
        rightGripperAngle=0;
        disp('Gripper is opened');
    case 3 % Closed
         rightGripperAngle=1;
         disp('Gripper is closed');
    otherwise % 0,1,4 : Unknown, Not-tracked, Lasso.
        disp('No change');
    end      
           
%%%%For displying
         
            disp('Time:')
            disp(timeStamp);
            disp('Right Shoulder angle Horizontal');
            disp(rightShoulderAngle_h);  
            disp('Right Shoulder angle Vertical');
            disp(rightShoulderAngle_v); 
            disp('Right Elbow angle');
            disp(rightElbowAngle); 
            disp('Right Wrist angle');
            disp(rightWristAngle); 


            
%%%%%% Arduino data sending Code
                 angleB=rightElbowAngle/180;
                 angleW=rightWristAngle;
                 angleS_v=rightShoulderAngle_v;
                 angleS_h=rightShoulderAngle_h/180;
                 
                %angleW=correctangleW(angleW)(rightWristAngle-1)/180;% After Angle correction
                
               % writePosition(s,angleB);
                 writePosition(s,angleS_h);
                 current_pos = readPosition(s);
                 fprintf('Current motor position is %d degrees\n', current_pos);        
       end 
        
        %Draw skeletons on the images!    
        %>> Draw bodies on depth image
        k2.drawBodies(d.ax,bodies,'depth',5,3,8);
        %>>Draw bodies on color image
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
clear s a % Clear Arduino and Servo Objects
close all;
