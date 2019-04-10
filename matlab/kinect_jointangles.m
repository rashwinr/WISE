%Joint angles of Wearable Jackeet connected with Kinect
clear all; 
close all; 
clc;
cd('F:\github\wearable-jacket\matlab\kinect+imudata\');
telapsed = 0;
strfile = sprintf('wearable+kinecttesting_%s.txt', datestr(now,'mm-dd-yyyy HH-MM'));
fid = fopen(strfile,'wt');
fprintf( fid, '%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s\n','Timestamp','Kinect_LShoulderExt-Flx','Kinect_LShoulderAbd-Add','Kinect_LElbow','Kinect_RShoulderExt-Flx','Kinect_RShoulderAbd-Add','Kinect_RElbow','LS_X','LS_Y','LS_Z','LE_X','LE_Y','LE_Z','RS_X','RS_Y','RS_Z','RE_X','RE_Y','RE_Z');
delete(instrfind({'Port'},{'COM15'}))
s = serial('COM15','BaudRate',115200);
s.ReadAsyncMode = 'continuous';
%Kinect initialization script
addpath('F:\github\wearable-jacket\matlab\KInectProject\Kin2');
addpath('F:\github\wearable-jacket\matlab\KInectProject\Kin2\Mex');
addpath('F:\github\wearable-jacket\matlab\KInectProject');
k2 = Kin2('color','depth','body');
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
fopen(s);
p = -1; %y = m x + p where y(-1 1) x(0 999) from rfduino z(-2^14 2^14)
m = 2/999;
while true
    tstart=tic;
    %Kinect section
    % Get frames from Kinect and save them on underlying buffer
    validData = k2.updateData;
    if validData
        % Copy data to Matlab matrices
        depth = k2.getDepth;
        color = k2.getColor;
        % update depth figure
        depth8u = uint8(depth*(255/outOfRange));
        depth8uc3 = repmat(depth8u,[1 1 3]);
        color = imresize(color,COL_SCALE);
        c.im = imshow(color, 'Parent', c.ax);
        [bodies, fcp, timeStamp] = k2.getBodies('Quat');
        numBodies = size(bodies,2);
       if numBodies == 1
%%%%%%%  Measuring the joints of the body in camera spac
% Left arm(modified): 5,6,7 ; RightArm: 9,10,11            
pos2Dxxx = bodies(1).Position;% All 25 joints positions are stored to the variable pos2Dxxx.
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
            %THE FEASIBILITY OF USING KINECT FOR TRANSFER ASSESSMENT didnt
            %work
            Spine = (spineCenter+spineShoulder)/2;
            Right = (rightShoulder+rightElbow)/2;
            Left = (leftShoulder+leftElbow)/2;
            rang = acos(dot(Spine,Right)/(norm(Spine)*norm(Right)))*180/pi;
            lang = acos(dot(Spine,Left)/(norm(Spine)*norm(Left)))*180/pi;
            rvec = cross(Right,Spine)/(norm(cross(Right,Spine)));
            lvec = cross(Left,Spine)/(norm(cross(Right,Spine)));
            lquat = [cosd(lang/2),lvec(1)*sind(lang/2),lvec(2)*sind(lang/2),lvec(3)*sind(lang/2)];
            rquat = [cosd(rang/2),rvec(1)*sind(rang/2),rvec(2)*sind(rang/2),rvec(3)*sind(rang/2)];
            leuler = quaternion2eulerdegrees(lquat)
            reuler = quaternion2eulerdegrees(rquat)
%             Eliminating the Z component for 2D data
            leftShoulderXY=leftShoulder(1:2);
            leftElbowXY=leftElbow(1:2);
            leftWristXY=leftWrist(1:2);
            rightShoulderXY=rightShoulder(1:2);
            rightElbowXY=rightElbow(1:2);
            rightWristXY=rightWrist(1:2);
%%%%%% ELBOW           
                                                %Right Elbow joint angle calculation 3D
            E1=rightShoulder-rightElbow;
            E2=rightWrist-rightElbow;
            %elbowAngle= atan2d(norm(cross(v1,v2)),dot(v1,v2));
            rightElbowAngle=acosd(dot(E1,E2)/(norm(E1)*norm(E2)));
%             smooth(rightElbowAngle,50,'moving');
            F1=leftShoulder-leftElbow;
            F2=leftWrist-rightElbow;
            leftElbowAngle=acosd(dot(F1,F2)/(norm(F1)*norm(F2)));
%             smooth(leftElbowAngle,50,'moving');
%%%%%% SHOULDER 
            % Right Shoulder Extension-Flexion Movement
            SH1=(spineShoulder([1 2])-spineCenter([1 2]));
            SH2=rightShoulder([1 2])-rightElbow([1 2]);
            rightShoulderAngle_h=acosd(dot(SH1,SH2)/(norm(SH1)*norm(SH2))); 
%             smooth(rightShoulderAngle_h,50);
            %shoulder vertical movement angle calculation.
            SV1=spineShoulder([1 3])-spineCenter([1 3]);
            SV2=rightShoulder([1 3])-rightElbow([1 3]);
            rightShoulderAngle_v=acosd(dot(SV1,SV2)/(norm(SV1)*norm(SV2))); 
%             smooth(rightShoulderAngle_v,50);
            % Left Shoulder Extension-Flexion Movement
            LH1=(spineShoulder([1 2])-spineCenter([1 2]));
            LH2=leftShoulder([1 2])-leftElbow([1 2]);
            leftShoulderAngle_h=acosd(dot(LH1,LH2)/(norm(LH1)*norm(LH2))); 
%             smooth(leftShoulderAngle_h,50);
            %shoulder vertical movement angle calculation.
            LV1=spineShoulder([1 3])-spineCenter([1 3]);
            LV2=leftShoulder([1 3])-leftElbow([1 3]);
            leftShoulderAngle_v=acosd(dot(SV1,SV2)/(norm(SV1)*norm(SV2))); 
%             smooth(leftShoulderAngle_v,50);            
%arduino section
    flushinput(s);
    line = fscanf(s);   % get data if there exists data in the next line
    data = strsplit(string(line),',');
    if(length(data) == 5 || length(data) == 6)
    switch data(1)
        case 'cal'
          switch data(2)
                case 'b'
                    B_mag = str2double(data(3));
                    B_acc = str2double(data(4));
                    B_gyr = str2double(data(5));
                    B_sys = str2double(data(6));
                    Cal_B = [B_mag B_acc B_gyr B_sys];
                case 'a'
                    A_mag = str2double(data(3));
                    A_acc = str2double(data(4));
                    A_gyr = str2double(data(5));
                    A_sys = str2double(data(6));      
                    Cal_A = [A_mag A_acc A_gyr A_sys];
                case 'c'
                    C_mag = str2double(data(3));
                    C_acc = str2double(data(4));
                    C_gyr = str2double(data(5));
                    C_sys = str2double(data(6));  
                    Cal_C = [C_mag C_acc C_gyr C_sys];
                case 'd'
                    D_mag = str2double(data(3));
                    D_acc = str2double(data(4));
                    D_gyr = str2double(data(5));
                    D_sys = str2double(data(6));      
                    Cal_D = [D_mag D_acc D_gyr D_sys];
                case 'e'
                    E_mag = str2double(data(3));
                    E_acc = str2double(data(4));
                    E_gyr = str2double(data(5));
                    E_sys = str2double(data(6));      
                    Cal_E = [E_mag E_acc E_gyr E_sys];
          end 
          
        case 'e'
            qE(1) = str2double(data(2))*m+p;
            qE(2) = str2double(data(3))*m+p;
            qE(3) = str2double(data(4))*m+p;
            qE(4) = str2double(data(5))*m+p;
            qRE = quatnormalize(qE);
            qE = quatorient(qRE);
        case 'c'
            qC(1) = str2double(data(2))*m+p;
            qC(2) = str2double(data(3))*m+p;
            qC(3) = str2double(data(4))*m+p;
            qC(4) = str2double(data(5))*m+p;
            qC = quatnormalize(qC);
            qCE = quatmultiply(quatconj(qC),qE);
            leftshoulder = quaternion2eulerdegrees(qCE)
        case 'd'
            qD(1) = str2double(data(2))*m+p;
            qD(2) = str2double(data(3))*m+p;
            qD(3) = str2double(data(4))*m+p;
            qD(4) = str2double(data(5))*m+p;
            qD = quatnormalize(qD);
            qDE = quatmultiply(quatconj(qD),qE);
            rightshoulder = quaternion2eulerdegrees(qDE);
        case 'a'
            qA(1) = str2double(data(2))*m+p;
            qA(2) = str2double(data(3))*m+p;
            qA(3) = str2double(data(4))*m+p;
            qA(4) = str2double(data(5))*m+p;
            qA = quatnormalize(qA);
            qAC = quatmultiply(quatconj(qC),qA);
            leftelbow = quaternion2eulerdegrees(qAC)
        case 'b'
            qB(1) = str2double(data(2))*m+p;
            qB(2) = str2double(data(3))*m+p;
            qB(3) = str2double(data(4))*m+p;
            qB(4) = str2double(data(5))*m+p;
            qB = quatnormalize(qB);
            qBD = quatmultiply(quatconj(qB),qD);
            rightelbow = quaternion2eulerdegrees(qBD);
    end 
    end
%             %Right Shoulder (Under arm) angle calculation 3D
%             W1=rightElbow-rightWrist;
%             W2=rightHandtip- rightWrist;
%             rightWristAngle_raw=acosd(dot(W1,W2)/(norm(W1)*norm(W2)));  
% %             smooth(rightWristAngle_raw,10);

% disp(quat2eul(qCE))
jl0 = strcat('IMU Left angles');
jl1 = strcat('Left Shoulder: ',num2str(leftshoulder(1),'%.1f'),', ',num2str(leftshoulder(2),'%.1f'),', ',num2str(leftshoulder(3),'%.1f'));
jl4 = strcat('Left Elbow Rotation: ',num2str(leftelbow(1),'%.1f'),', ',num2str(leftelbow(2),'%.1f'),', ',num2str(leftelbow(3),'%.1f'));
jr0 = strcat('IMU Right angles');
jr1 = strcat('Right Shoulder: ',num2str(rightshoulder(1),'%.1f'),', ',num2str(rightshoulder(2),'%.1f'),', ',num2str(rightshoulder(3),'%.1f'));
jr4 = strcat('Right Shoulder: ',num2str(rightelbow(1),'%.1f'),num2str(rightelbow(2),'%.1f'),', ',num2str(rightelbow(3),'%.1f'));
s0 = strcat('Kinect Right angles');
s1 = strcat('Right Shoulder Extension-Flexion: ',num2str(rightShoulderAngle_h,'%.1f'));
s2 = strcat('Right Shoulder Abduction-adduction: ',num2str(rightShoulderAngle_v,'%.1f'));
s3 = strcat('Right Elbow angle: ',num2str(rightElbowAngle,'%.1f'));
r0 = strcat('Kinect Left angles');
r1 = strcat('Left Shoulder Extension-Flexion: ',num2str(leftShoulderAngle_h,'%.1f'));
r2 = strcat('Left Shoulder Abduction-adduction: ',num2str(leftShoulderAngle_v,'%.1f'));
r3 = strcat('Left Elbow angle: ',num2str(leftElbowAngle,'%.1f'));
text(1200,50,s0,'Color','green','FontSize',18,'FontWeight','bold');
text(1200,100,s1,'Color','green','FontSize',18,'FontWeight','bold');
text(1200,150,s2,'Color','green','FontSize',18,'FontWeight','bold');
text(1200,200,s3,'Color','green','FontSize',18,'FontWeight','bold');
text(200,50,r0,'Color','green','FontSize',18,'FontWeight','bold');
text(200,100,r1,'Color','green','FontSize',18,'FontWeight','bold');
text(200,150,r2,'Color','green','FontSize',18,'FontWeight','bold');
text(200,200,r3,'Color','green','FontSize',18,'FontWeight','bold');
text(200,500,jl0,'Color','cyan','FontSize',18,'FontWeight','bold');
text(200,550,jl1,'Color','cyan','FontSize',18,'FontWeight','bold');
text(200,600,jl4,'Color','cyan','FontSize',18,'FontWeight','bold');
text(1200,500,jr0,'Color','cyan','FontSize',18,'FontWeight','bold');
text(1200,550,jr1,'Color','cyan','FontSize',18,'FontWeight','bold');
text(1200,600,jr4,'Color','cyan','FontSize',18,'FontWeight','bold');
telapsed = telapsed+toc(tstart);
%'Timestamp','Kinect_LShoulderExt-Flx','Kinect_LShoulderAbd-Add','Kinect_LElbow','Kinect_RShoulderExt-Flx','Kinect_RShoulderAbd-Add','Kinect_RElbow','LS_X','LS_Y','LS_Z','LE_X','LE_Y','LE_Z','RS_X','RS_Y','RS_Z','RE_X','RE_Y','RE_Z'
fprintf( fid, '%.2f,%.2f,%.2f,%.2f,%.2f,%.2f,%.2f,%.2f,%.2f,%.2f,%.2f,%.2f,%.2f,%.2f,%.2f,%.2f,%.2f,%.2f,%.2f\n',telapsed,leftShoulderAngle_h,leftShoulderAngle_v,leftElbowAngle,rightShoulderAngle_h,rightShoulderAngle_v,rightElbowAngle,leftshoulder(1),leftshoulder(2),leftshoulder(3),leftelbow(1),leftelbow(2),leftelbow(3),rightshoulder(1),rightshoulder(2),rightshoulder(3),rightelbow(1),rightelbow(2),rightelbow(3));
end 
       
 if numBodies == 0
           s1 = strcat('No persons in view');
           text(1920/2,100,s1,'Color','red','FontSize',14);
 end      
 if numBodies > 1
           s1 = strcat('Too many people in view');
           text(1920/2,100,s1,'Color','red','FontSize',14);
 end      
 if ~isempty(k)
        if strcmp(k,'q'); 
            break; 
        end;
 end
        %Draw skeletons on the images!    
        %>> Draw bodies on depth image
%         k2.drawBodies(d.ax,bodies,'depth',5,3,8);
        %>>Draw bodies on color image
        %k2.drawBodies(c.ax,bodies,'color',10,6,30);
        k2.drawBodies(c.ax,bodies,'color',3,2,1);
%         c.text(100,100,rightShoulderAngle_h);
    end
 pause(0.02);
 clearvars pos2Dxxx depth color validData data line leftShoulderAngle_h leftShoulderAngle_v rightShoulderAngle_h rightShoulderAngle_v rightElbowAngle leftElbowAngle SH1 SH2 LH1 LH2 SV1 SV2 LV1 LV2 leftShoulder leftElbow leftWrist rightShoulder rightElbow  rightWrist rightHand rightHandtip spineShoulder spineCenter E1 E2 F1 F2
end
fclose(fid);
% Close kinect object
k2.delete;
%clear s a % Clear Arduino and Servo Objects
close all;


function angle = quaternion2eulerdegrees(q)
angle = quat2eul(q)*180/pi;
end

function rotatedquat = quatorient(q)
Qk = [0,0,0,1];
Qe = [1,0,0,0];
Qz = quatmultiply(q,quatmultiply(Qk,quatconj(q)));
Qz = [cos(pi/4),Qz(2)*sin(pi/4),Qz(3)*sin(pi/4),Qz(4)*sin(pi/4)];
Qe = quatmultiply(Qz,q);
Qi = [0,1,0,0];
Qx = quatmultiply(Qe,quatmultiply(Qi,quatconj(Qe)));
Qx = [cos(pi/4),Qx(2)*sin(pi/4),Qx(3)*sin(pi/4),Qx(4)*sin(pi/4)];
Qe = quatmultiply(Qx,Qe);
rotatedquat = Qe;
end
