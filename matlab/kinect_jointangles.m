%Joint angles of Wearable Jackeet connected with Kinect
clear all; 
close all; 
clc;
tt = 0;
flag = 0;
<<<<<<< HEAD
cd('C:\Users\satis\Git\wearable-jacket\matlab\kinect+imudata\');
=======
cd('C:\Users\fabio\github\wearable-jacket\matlab\kinect+imudata\');
>>>>>>> 94d4396579f30b56c40c258fba29a9b95d0c82a8
telapsed = 0;
strfile = sprintf('wearable+kinecttesting_%s.txt', datestr(now,'mm-dd-yyyy HH-MM'));
fid = fopen(strfile,'wt');
fprintf( fid, '%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s\n','Timestamp','Kinect_LShoulderExt-Y','Kinect_LShoulderAbd-Z','Kinect_LElbow','Kinect_RShoulderExt-Y','Kinect_RShoulderAbd-Z','Kinect_RElbow','IMULS_Y','IMULS_Z','IMUL_Elbow','IMURS_Y','IMURS_Z','IMURElbow');
delete(instrfind({'Port'},{'COM15'}))
s = serial('COM3','BaudRate',115200);
s.ReadAsyncMode = 'continuous';
%Kinect initialization script
addpath('C:\Users\fabio\github\wearable-jacket\matlab\KInectProject\Kin2');
addpath('C:\Users\fabio\github\wearable-jacket\matlab\KInectProject\Kin2\Mex');
addpath('C:\Users\fabio\github\wearable-jacket\matlab\KInectProject');
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
fopen(s);
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
            %elbowAngle= atan2d(norm(cross(v1,v2)),dot(v1,v2));
            rightElbowAngle=acosd(dot(E1,E2)/(norm(E1)*norm(E2)));
            F1=leftElbow-leftShoulder;
            F2=leftWrist-leftElbow;
            leftElbowAngle=acosd(dot(F1,F2)/(norm(F1)*norm(F2)));
%%%%%% SHOULDER 
                                % Right Shoulder abduction-adduction Movement
            SH1=spineCenter([1:3])-spineShoulder([1:3]);
            SH2=rightElbow([1:3])-rightShoulder([1:3]);
            rightShoulderAngle_h=acosd(dot(SH1,SH2)/(norm(SH1)*norm(SH2))); 
            %             smooth(rightShoulderAngle_h,50);
                                %right shoulder extension-flexion angle calculation.
            SV1=hipRight([1:3])-spinebase([1:3]);
            SV2=rightElbow([1:3])-rightShoulder([1:3]);
            rightShoulderAngle_v=acosd(dot(SV1,SV2)/(norm(SV1)*norm(SV2))); 
            %             smooth(rightShoulderAngle_v,50);
                                % Left Shoulder Extension-Flexion Movement
            LH1=spineCenter([1:3])-spineShoulder([1:3]);
            LH2=leftElbow([1:3])-leftShoulder([1:3]);
            leftShoulderAngle_h=acosd(dot(LH1,LH2)/(norm(LH1)*norm(LH2))); 
            %             smooth(leftShoulderAngle_h,50);
                                %shoulder vertical movement angle calculation.
            LV1=hipLeft([1:3])-spinebase([1:3]);
            LV2=leftElbow([1:3])-leftShoulder([1:3]);
            leftShoulderAngle_v=acosd(dot(LV1,LV2)/(norm(LV1)*norm(LV2))); 
            %             smooth(leftShoulderAngle_v,50);      
            
% theta1 = (acosd(rightElbow(2)/sqrt(rightElbow(1)^2+rightElbow(2)^2)))
% theta2 = (acosd(rightElbow(3)/sqrt(rightElbow(2)^2+rightElbow(3)^2)))
% theta3 = (acosd(rightElbow(1)/sqrt(rightElbow(1)^2+rightElbow(3)^2)))

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
                    Cal_B = [B_mag B_acc B_gyr B_sys]
                case 'a'
                    A_mag = str2double(data(3));
                    A_acc = str2double(data(4));
                    A_gyr = str2double(data(5));
                    A_sys = str2double(data(6));      
                    Cal_A = [A_mag A_acc A_gyr A_sys]
                case 'c'
                    C_mag = str2double(data(3));
                    C_acc = str2double(data(4));
                    C_gyr = str2double(data(5));
                    C_sys = str2double(data(6));  
                    Cal_C = [C_mag C_acc C_gyr C_sys]
                case 'd'
                    D_mag = str2double(data(3));
                    D_acc = str2double(data(4));
                    D_gyr = str2double(data(5));
                    D_sys = str2double(data(6));      
                    Cal_D = [D_mag D_acc D_gyr D_sys]
                case 'e'
                    E_mag = str2double(data(3));
                    E_acc = str2double(data(4));
                    E_gyr = str2double(data(5));
                    E_sys = str2double(data(6));      
                    Cal_E = [E_mag E_acc E_gyr E_sys]
          end 
          
        case 'e'
            qE(1) = str2double(data(2))*m+p;
            qE(2) = str2double(data(3))*m+p;
            qE(3) = str2double(data(4))*m+p;
            qE(4) = str2double(data(5))*m+p;
            qE = quatnormalize(qE);
            R_sho = getShoulder(qE,qD);
            L_sho = getShoulder(qE,qC);
        case 'a'
            qA(1) = str2double(data(2))*m+p;
            qA(2) = str2double(data(3))*m+p;
            qA(3) = str2double(data(4))*m+p;
            qA(4) = str2double(data(5))*m+p;
            qA = quatnormalize(qA);
            L_elb = getElbow(qA,qC);
        case 'c'
            qC(1) = str2double(data(2))*m+p;
            qC(2) = str2double(data(3))*m+p;
            qC(3) = str2double(data(4))*m+p;
            qC(4) = str2double(data(5))*m+p;
            qC = quatnormalize(qC);
            L_elb = getElbow(qA,qC);
            L_sho = getShoulder(qE,qC);
        case 'd'
            qD(1) = str2double(data(2))*m+p;
            qD(2) = str2double(data(3))*m+p;
            qD(3) = str2double(data(4))*m+p;
            qD(4) = str2double(data(5))*m+p;
            qD = quatnormalize(qD);
            R_sho = getShoulder(qE,qD);
            R_elb = getElbow(qD,qB);
        case 'b'
            qB(1) = str2double(data(2))*m+p;
            qB(2) = str2double(data(3))*m+p;
            qB(3) = str2double(data(4))*m+p;
            qB(4) = str2double(data(5))*m+p;
            qB = quatnormalize(qB);
            qBD = quatmultiply(quatconj(qB),qD);
            R_elb = getElbow(qD,qB);
    end 
    end


imu = strcat('IMU');
knt= strcat('Kinect');

lft = strcat('Left angles');
rgt = strcat('Right angles');

shldY = strcat('Shoulder Y:');
shldZ = strcat('Shoulder Z:');

elbR = strcat('Elbow Rot:');

jl1 = num2str(L_sho(1),'%.1f');
jl2 = num2str(L_sho(2),'%.1f');
jl4 = num2str(L_elb,'%.1f');



jr1 = num2str(R_sho(1),'%.1f');
jr2 = num2str(R_sho(2),'%.1f');
jr4 = num2str(R_elb,'%.1f');



s1 = num2str(rightShoulderAngle_v,'%.1f');
s2 = num2str(rightShoulderAngle_h,'%.1f');
s3 = num2str(rightElbowAngle,'%.1f');


r1 = num2str(leftShoulderAngle_v,'%.1f');
r2 = num2str(leftShoulderAngle_h,'%.1f');
r3 = num2str(leftElbowAngle,'%.1f');

fs = 30;

text(100,40,lft,'Color','black','FontSize',fs,'FontWeight','bold');

text(400,100,knt,'Color','blue','FontSize',fs,'FontWeight','bold');
text(0,150,shldY,'Color','black','FontSize',fs,'FontWeight','bold');
text(400,150,r1,'Color','blue','FontSize',fs,'FontWeight','bold');
text(0,200,shldZ,'Color','black','FontSize',fs,'FontWeight','bold');
text(400,200,r2,'Color','blue','FontSize',fs,'FontWeight','bold');
text(0,250,elbR,'Color','black','FontSize',fs,'FontWeight','bold');
text(400,250,r3,'Color','blue','FontSize',fs,'FontWeight','bold');

text(600,100,imu,'Color','red','FontSize',fs,'FontWeight','bold');
text(600,150,jl1,'Color','red','FontSize',fs,'FontWeight','bold');
text(600,200,jl2,'Color','red','FontSize',fs,'FontWeight','bold');
text(600,250,jl4,'Color','red','FontSize',fs,'FontWeight','bold');


text(1000,40,rgt,'Color','black','FontSize',fs,'FontWeight','bold');

text(1300,100,knt,'Color','blue','FontSize',fs,'FontWeight','bold');
text(900,150,shldY,'Color','black','FontSize',fs,'FontWeight','bold');
text(1300,150,s1,'Color','blue','FontSize',fs,'FontWeight','bold');
text(900,200,shldZ,'Color','black','FontSize',fs,'FontWeight','bold');
text(1300,200,s2,'Color','blue','FontSize',fs,'FontWeight','bold');
text(900,250,elbR,'Color','black','FontSize',fs,'FontWeight','bold');
text(1300,250,s3,'Color','blue','FontSize',fs,'FontWeight','bold');

text(1500,100,imu,'Color','red','FontSize',fs,'FontWeight','bold');
text(1500,150,jr1,'Color','red','FontSize',fs,'FontWeight','bold');
text(1500,200,jr2,'Color','red','FontSize',fs,'FontWeight','bold');
text(1500,250,jr4,'Color','red','FontSize',fs,'FontWeight','bold');

telapsed = telapsed+toc(tstart);
%'Timestamp','Kinect_LShoulderExt-Y','Kinect_LShoulderAbd-Z','Kinect_LElbow','Kinect_RShoulderExt-Y','Kinect_RShoulderAbd-Z','Kinect_RElbow','IMULS_Y','IMULS_Z','IMUL_Elbow','IMURS_Y','IMURS_Z','IMURElbow');

fprintf( fid, '%.2f,%.2f,%.2f,%.2f,%.2f,%.2f,%.2f,%.2f,%.2f,%.2f,%.2f,%.2f,%.2f\n',telapsed,leftShoulderAngle_v,leftShoulderAngle_h,leftElbowAngle,rightShoulderAngle_v,rightShoulderAngle_h,rightElbowAngle,L_sho(1),L_sho(2),L_elb,R_sho(1),R_sho(2),R_elb);
end 
       
 if numBodies == 0
           s1 = strcat('No persons in view');
           text(1920/2,100,s1,'Color','red','FontSize',30,'FontWeight','bold');
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
 
% if(flag==1)
        k2.drawBodies(c.ax,bodies,'color',3,2,1);
        flag = 0;
% end
    end
 pause(0.02);
 clearvars pos2Dxxx depth color validData data line leftShoulderAngle_h leftShoulderAngle_v rightShoulderAngle_h rightShoulderAngle_v rightElbowAngle leftElbowAngle SH1 SH2 LH1 LH2 SV1 SV2 LV1 LV2 leftShoulder leftElbow leftWrist rightShoulder rightElbow  rightWrist rightHand rightHandtip spineShoulder spineCenter E1 E2 F1 F2
end

fclose(fid);
% Close kinect object
k2.delete;
delete(instrfind({'Port'},{'COM15'}))
%clear s a % Clear Arduino and Servo Objects
close all;


function Elb = getElbow(q1,q2)
Qi = [0,1,0,0];
Q1 = quatmultiply(q1,quatmultiply(Qi,quatconj(q1)));
V1 = [Q1(2),Q1(3),Q1(4)];
Q2 = quatmultiply(q2,quatmultiply(Qi,quatconj(q2)));
V2 = [Q2(2),Q2(3),Q2(4)];
Elb = acosd(dot(V1,V2)/(norm(V1)*norm(V2)));
end


function Sho = getShoulder(back,arm)
Qi = [0,1,0,0];
Qj = [0,0,1,0];
Qbx = quatmultiply(back,quatmultiply(Qi,quatconj(back)));
Bx = [Qbx(2),Qbx(3),Qbx(4)];
Qby = quatmultiply(back,quatmultiply(Qj,quatconj(back)));
By = -[Qby(2),Qby(3),Qby(4)];
Qarm = quatmultiply(arm,quatmultiply(Qi,quatconj(arm)));
Ax = [Qarm(2),Qarm(3),Qarm(4)];
Shoz = acosd(dot(Bx,Ax)/(norm(Bx)*norm(Ax)));
Shoy = acosd(dot(By,Ax)/(norm(By)*norm(Ax)));
Sho = [Shoy, Shoz];
end
