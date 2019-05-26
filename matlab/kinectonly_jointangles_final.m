%Joint angles of Wearable Jacket connected with Kinect
clear all; 
close all; 
clc;
tt = 0;
flag = 0;
cd('F:\github\wearable-jacket\matlab\kinect+imudata\');
cd('F:\github\wearable-jacket\matlab\kinect+imudata\');
telapsed = 0;
% strfile = sprintf('wearable+kinecttesting_%s.txt', datestr(now,'mm-dd-yyyy HH-MM'));
% fid = fopen(strfile,'wt');
% fprintf( fid, '%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s\n','Timestamp','Kinect_LShoulderExt-Y','Kinect_LShoulderAbd-Z','Kinect_LElbow','Kinect_RShoulderExt-Y','Kinect_RShoulderAbd-Z','Kinect_RElbow','IMULS_Y','IMULS_Z','IMUL_Elbow','IMURS_Y','IMURS_Z','IMURElbow');
%Kinect initialization script
addpath('F:\github\wearable-jacket\matlab\KInectProject\Kin2');
addpath('F:\github\wearable-jacket\matlab\KInectProject\Kin2\Mex');
addpath('F:\github\wearable-jacket\matlab\KInectProject');
k2 = Kin2('color','depth','body');
handvalue = zeros(4,10000);
i=1;
%Quaternion variables
X = [1,0,0];
Y = [0,1,0];
Z = [0,0,1];
qC = [1,0,0,0];qD = [1,0,0,0];qA = [1,0,0,0];qB = [1,0,0,0];qE = [1,0,0,0];qAC = [1,0,0,0];qCE = [1,0,0,0];qDE = [1,0,0,0];qBD = [1,0,0,0];qRE = [1,0,0,0];
leftelbow = [0,0,0];leftshoulder=[0,0,0];rightshoulder=[0,0,0];rightelbow=[0,0,0];
leftElbowAngle=0;
rightElbowAngle=0;
rightShoulderAngle_h = 0;
rightShoulderAngle_v = 0;
L_elb = 0;R_elb = 0;L_sho = [0,0];R_sho = [0,0];
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
k=[];
p = -1; %y = m x + p where y(-1 1) x(0 999) from rfduino z(-2^14 2^14)
m = 2/999;
while true
%     tt = tt+1;
    tstart=tic;
    %Kinect section
    % Get frames from Kinect and save them on underlying buffer
    validData = k2.updateData;
    if validData
        % Copy data to Matlab matrices
        depth = k2.getDepth;
        color = k2.getColor;
        % update depth figure
%         if(tt>=50)
        depth8u = uint8(depth*(255/outOfRange));
        depth8uc3 = repmat(depth8u,[1 1 3]);
        color = imresize(color,COL_SCALE);
        c.im = imshow(color, 'Parent', c.ax);
        flag=1;
        tt=0;
%         end
        [bodies, fcp, timeStamp] = k2.getBodies('Quat');
        numBodies = size(bodies,2);
       if numBodies == 1
%%%%%%%  Measuring the joints of the body in camera spac
                % Left arm(modified): 5,6,7 ; RightArm: 9,10,11            
pos2Dxxx = bodies(1).Position;              % All 25 joints positions are stored to the variable pos2Dxxx.
                                                %Left Side Joints
            leftShoulder = pos2Dxxx(:,5);
            leftElbow = pos2Dxxx(:,6);
            leftWrist = pos2Dxxx(:,7);
                                                %Right Side Joints
            rightShoulder = pos2Dxxx(:,9); % Left arm: 4,5,6 ; RightArm: 8,9,10
            rightElbow = pos2Dxxx(:,10);
            rightWrist = pos2Dxxx(:,11);
            rightHand = pos2Dxxx(:,12);
            rightHandtip = pos2Dxxx(:,24);
                                                %Spine Joints
            spineShoulder = pos2Dxxx(:,21);
            spineCenter = pos2Dxxx(:,2);
            spinebase = pos2Dxxx(:,1);
            hipRight = pos2Dxxx(:,17);
            hipLeft = pos2Dxxx(:,13);

            %THE FEASIBILITY OF USING KINECT FOR TRANSFER ASSESSMENT didnt %work
%             Spine = (spineCenter+spineShoulder)/2;
%             Right = (rightShoulder+rightElbow)/2;
%             Left = (leftShoulder+leftElbow)/2;
%             rang = acos(dot(Spine,Right)/(norm(Spine)*norm(Right)))*180/pi;
%             lang = acos(dot(Spine,Left)/(norm(Spine)*norm(Left)))*180/pi;
%             rvec = cross(Right,Spine)/(norm(cross(Right,Spine)));
%             lvec = cross(Left,Spine)/(norm(cross(Right,Spine)));
%             lquat = [cosd(lang/2),lvec(1)*sind(lang/2),lvec(2)*sind(lang/2),lvec(3)*sind(lang/2)];
%             rquat = [cosd(rang/2),rvec(1)*sind(rang/2),rvec(2)*sind(rang/2),rvec(3)*sind(rang/2)];
%             leuler = quaternion2eulerdegrees(lquat)
%             reuler = quaternion2eulerdegrees(rquat)
            
            
%             Eliminating the Z component for 2D data
%%%%%% ELBOW           
                                                %Right Elbow joint angle calculation 3D
            E1=rightElbow-rightShoulder;
            E2=rightWrist-rightElbow;
            rightElbowAngle=acosd(dot(E1,E2)/(norm(E1)*norm(E2)));
            F1=leftElbow-leftShoulder;
            F2=leftWrist-leftElbow;
            leftElbowAngle=acosd(dot(F1,F2)/(norm(F1)*norm(F2)));
%%%%%% SHOULDER 
            % Right Shoulder abduction-adduction Movement
            RH2=rightElbow([1:3])-rightShoulder([1:3]);
            LH2=leftElbow([1:3])-leftShoulder([1:3]);    
            
            %sagittal plane:  include the “trunk vector” and “the cross product of shoulder vector and trunk vector”
            %coronal plane includes the vector from the "left shoulder to the right shoulder" and the "trunk vector"
            %arm external rotation plane: 
            %Flexion angle of the shoulder was calculated as the projected angle on the sagittal plane between “the vector from the shoulder to the elbow” 
            % abduction angle of the shoulder was calculated as the projected angle on the coronal plane between the “arm vector” and the “trunk vector.”
            %Rotational angle of the shoulder was calculated as the projected angle on “the plane perpendicular to the arm vector” (the armaxial plane) 
            %between “the vector from the elbow to the wrist” (forearm vector) and “the cross product of the shoulder vector and the arm vector” 
            %Projection of a point q on a plane when given by a point p and a normal n is q_proj = q - dot(q - p, n) * n
         
            %coronal plane calculation
            RSLS = leftShoulder-rightShoulder;
            LSRS = rightShoulder-leftShoulder;
            TrunkVector = spinebase-spineShoulder;
            coronalnormalL = cross(LSRS,TrunkVector);
            coronalnormalR = cross(RSLS,TrunkVector);
            armaxisnormalL = cross(LSRS,LH2);
            armaxisnormalR = cross(RSLS,RH2);
%             syms xc yc zc;
%             P = [xc;yc;zc];
            %coronal plane calculation
            if (leftElbow(1)<=(leftShoulder(1)-(0.25*norm(LH2))))
                leftElbowprojection = LH2 - dot(LH2,coronalnormalL)*coronalnormalL;
                leftShoulderAnglesign_h = atan2d(norm(cross(TrunkVector,LH2)),dot(TrunkVector,LH2));                      %Abduction-adduction angle left
            else
                leftShoulderAnglesign_h = 0;
            end
            if (rightElbow(1)>=(rightShoulder(1)+(0.25*norm(RH2))))
                rightElbowprojection = RH2 - dot(RH2,coronalnormalR)*coronalnormalR;
                rightShoulderAnglesign_h = atan2d(norm(cross(TrunkVector,RH2)),dot(TrunkVector,RH2));                     %Abduction-adduction angle right  
            else
                rightShoulderAnglesign_h = 0;
            end
            %Sagittal plane calculation
            sagittalnormalL = cross(coronalnormalL,TrunkVector);
            sagittalnormalR = cross(coronalnormalR,TrunkVector);
            if (leftShoulder(3)>=(leftElbow(3)+(0.25*norm(LH2))))
                leftShoulderprojection = LH2 - (dot(LH2,sagittalnormalL)/norm(sagittalnormalL)^2)*sagittalnormalL;
                leftShoulderAngle_v=atan2d(norm(cross(TrunkVector,leftShoulderprojection)),dot(TrunkVector,leftShoulderprojection));       %Extension-flexion left
            else
                leftShoulderAngle_v = 0;
            end
            if (rightShoulder(3)>=(rightElbow(3)+(0.25*norm(RH2))))
                rightShoulderprojection = RH2 - (dot(RH2,sagittalnormalR)/norm(sagittalnormalR)^2)*sagittalnormalR;
                rightShoulderAngle_v=atan2d(norm(cross(TrunkVector,rightShoulderprojection)),dot(TrunkVector,rightShoulderprojection));    %Extension-flexion right
            else
                rightShoulderAngle_v = 0;
            end
            %arm-axis plane calculation
            leftwristprojection = armaxisnormalL - (dot(LH2,armaxisnormalL)/norm(LH2)^2)*LH2;
            rightwristprojection = armaxisnormalR - (dot(RH2,armaxisnormalR)/norm(RH2)^2)*RH2;
            if leftElbowAngle>=60
                LSrotation = acosd(dot(leftwristprojection,F2)/(norm(F2)*norm(leftwristprojection)));
            else
                LSrotation = 0;
            end
            if rightElbowAngle>=60
                RSrotation = acosd(dot(-rightwristprojection,E2)/(norm(E2)*norm(-rightwristprojection)));
            else
                RSrotation = 0;
            end
            handvalues(:,i) = [leftShoulder(1) leftElbow(1) rightShoulder(1) rightElbow(1)];
            i=i+1;
imu = strcat('CProd');
knt= strcat('Kinect');
lft = strcat('Left hand angles');
rgt = strcat('Right hand angles');

% shldY = strcat('Shoulder Y:');
shldZ = strcat('Shoulder');
elbR = strcat('Elbow');
% jl1 = num2str(L_sho(1),'%.1f');
il2 = num2str(leftShoulderAnglesign_h,'%.1f');
il4 = num2str(LSrotation,'%.1f');
% jr1 = num2str(R_sho(1),'%.1f');
ir2 = num2str(rightShoulderAnglesign_h,'%.1f');
ir4 = num2str(RSrotation,'%.1f');
% s1 = num2str(rightShoulderAngle_v,'%.1f');
kr2 = num2str(rightShoulderAngle_v,'%.1f');
kr3 = num2str(rightElbowAngle,'%.1f');
% r1 = num2str(leftShoulderAngle_v,'%.1f');
kl2 = num2str(leftShoulderAngle_v,'%.1f');
kl3 = num2str(leftElbowAngle,'%.1f');

fs = 24;
rectangle('Position',[0 0 10 10]);
rectangle('Position',[0 0 475 1080],'LineWidth',3,'FaceColor','k');  
rectangle('Position',[1350 0 620 1080],'LineWidth',3,'FaceColor','k');
text(10,40,lft,'Color','white','FontSize',fs,'FontWeight','bold');
text(10,120,shldZ,'Color','white','FontSize',fs,'FontWeight','bold');
% text(0,150,shldY,'Color','black','FontSize',fs,'FontWeight','bold');
% text(100,150,r1,'Color','white','FontSize',fs,'FontWeight','bold');
% text(600,150,jl1,'Color','red','FontSize',fs,'FontWeight','bold');
text(10,240,knt,'Color','white','FontSize',fs,'FontWeight','bold');
% text(200,240,imu,'Color','white','FontSize',fs,'FontWeight','bold');
text(10,300,kl2,'Color','white','FontSize',fs,'FontWeight','bold');
text(200,300,il2,'Color','white','FontSize',fs,'FontWeight','bold');
text(10,400,elbR,'Color','white','FontSize',fs,'FontWeight','bold');
text(10,500,kl3,'Color','white','FontSize',fs,'FontWeight','bold');
text(200,500,il4,'Color','white','FontSize',fs,'FontWeight','bold');
text(1430,40,rgt,'Color','white','FontSize',fs,'FontWeight','bold');
text(1430,120,shldZ,'Color','white','FontSize',fs,'FontWeight','bold');
text(1430,240,knt,'Color','white','FontSize',fs,'FontWeight','bold');
% text(1620,240,imu,'Color','white','FontSize',fs,'FontWeight','bold');
% text(900,150,shldY,'Color','black','FontSize',fs,'FontWeight','bold');
% text(1300,150,s1,'Color','white','FontSize',fs,'FontWeight','bold');
% text(1500,150,jr1,'Color','red','FontSize',fs,'FontWeight','bold');
text(1430,300,kr2,'Color','white','FontSize',fs,'FontWeight','bold');
text(1620,300,ir2,'Color','white','FontSize',fs,'FontWeight','bold');
text(1430,400,elbR,'Color','white','FontSize',fs,'FontWeight','bold');
text(1430,500,kr3,'Color','white','FontSize',fs,'FontWeight','bold');
text(1620,500,ir4,'Color','white','FontSize',fs,'FontWeight','bold');

telapsed = telapsed+toc(tstart);
%'Timestamp','Kinect_LShoulderExt-Y','Kinect_LShoulderAbd-Z','Kinect_LElbow','Kinect_RShoulderExt-Y','Kinect_RShoulderAbd-Z','Kinect_RElbow','IMULS_Y','IMULS_Z','IMUL_Elbow','IMURS_Y','IMURS_Z','IMURElbow');
% fprintf( fid, '%.2f,%.2f,%.2f,%.2f,%.2f,%.2f,%.2f,%.2f,%.2f,%.2f,%.2f,%.2f,%.2f\n',telapsed,leftShoulderAngle_v,leftShoulderAngle_h,leftElbowAngle,rightShoulderAngle_v,rightShoulderAngle_h,rightElbowAngle,L_sho(1),L_sho(2),L_elb,R_sho(1),R_sho(2),R_elb);
end   
 if numBodies == 0
           s1 = strcat('No persons in view');   
           text((1920/2) - 250,100,s1,'Color','red','FontSize',30,'FontWeight','bold');
           rectangle('Position',[0 0 475 1080],'LineWidth',3,'FaceColor','k');  
           rectangle('Position',[1350 0 620 1080],'LineWidth',3,'FaceColor','k');
 end      
 if numBodies > 1
           s1 = strcat('Too many people in view');
           text(1920/2,100,s1,'Color','red','FontSize',30,'FontWeight','bold');
 end      
 if ~isempty(k)
        if strcmp(k,'q'); 
            break; 
        end;
 end
        k2.drawBodies(c.ax,bodies,'color',3,2,1);
        flag = 0;
    end
 pause(0.02);
%  clearvars pos2Dxxx depth color validData data line leftShoulderAngle_h leftShoulderAngle_v rightShoulderAngle_h rightShoulderAngle_v rightElbowAngle leftElbowAngle SH1 SH2 LH1 LH2 SV1 SV2 LV1 LV2 leftElbow leftWrist rightShoulder rightElbow  rightWrist rightHand rightHandtip spineShoulder spineCenter E1 E2 F1 F2
end
% Close kinect object
k2.delete;
close all;
