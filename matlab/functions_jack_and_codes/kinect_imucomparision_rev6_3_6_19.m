 %Joint angles from the Kinect and the IMU's are processed in a single
%script for viewing 
delete(instrfind({'Port'},{'COM15'}))
% fclose(fid);
clear all; 
close all; 
clc;
tt = 0;
flag = 0;
flg = 1;
if flg 
    Offsets = [0.8589,0.0411,-0.0170,-0.5101; 1.0000,0,0,0; -0.8954,0.0070,0.0010,0.4452; -0.9749,0.0070,-0.0250,0.2210; 0.9791,-0.0371,-0.0170,-0.1994];
end
cd('F:\github\wearable-jacket\matlab\kinect+imudata\');
telapsed = 0;
strfile = sprintf('wearable+kinecttesting_%s.txt', datestr(now,'mm-dd-yyyy HH-MM'));
fid = fopen(strfile,'wt');
fprintf( fid, '%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s\n','Timestamp','Kinect_LeftShoulder_Ext.-Flex.','IMU_LeftShoulder_Ext.-Flex.','Kinect_LeftShoulder_Abd.-Add.','IMU_LeftShoulder_Abd.-Add.','Kinect_LeftShoulder_Int.-Ext.','IMU_LeftShoulder_Int.-Ext.','Kinect_LeftElbow_Ext.-Flex.','IMU_LeftElbow_Ext.-Flex.','IMU_LeftElbow_Pro.-Sup.','Kinect_RightShoulder_Ext.-Flex.','IMU_RightShoulder_Ext.-Flex.','Kinect_RightShoulder_Abd.-Add.','IMU_RightShoulder_Abd.-Add.','Kinect_RightShoulder_Int.-Ext.','IMU_RightShoulder_Int.-Ext.','Kinect_RightElbow_Ext.-Flex.','IMU_RightElbow_Ext.-Flex.','IMU_RightElbow_Pro.-Sup.');
%Kinect initialization script
addpath('F:\github\wearable-jacket\matlab\KInectProject\Kin2');
addpath('F:\github\wearable-jacket\matlab\KInectProject\Kin2\Mex');
addpath('F:\github\wearable-jacket\matlab\KInectProject');
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
k=[];
                        %COM Port details
                        delete(instrfind({'Port'},{'COM15'}))
                        ser = serial('COM15','BaudRate',115200);
                        ser.ReadAsyncMode = 'continuous';
%quaternion variables
qC = [1,0,0,0];qD = [1,0,0,0];qA = [1,0,0,0];qB = [1,0,0,0];qE = [1,0,0,0];
empty = [1,0,0,0];
Cal_A = [0 0 0 0];Cal_B = [0 0 0 0];Cal_C = [0 0 0 0];Cal_D = [0 0 0 0];Cal_E = [0 0 0 0];
imustr = strcat('IMU');
kntstr = strcat('KINECT');
lftstr = strcat('Left arm angles');
rgtstr = strcat('Right arm angles');
efstr = strcat('Flex-Ext');
bdstr = strcat('Abd-Add');
iestr = strcat('Int-Ext Rot.');
psstr = strcat('Pro-Sup');
jtext = strcat('Joint');
etext = strcat('Elbow');         
stext = strcat('Shoulder');
ftext = strcat('Forearm');
limuefangle = 0;rimuefangle = 0;lkinefangle = 0;rkinefangle = 0;
limubdangle = 0;rimubdangle = 0;lkinbdangle = 0;rkinbdangle = 0;
limuieangle = 0;rimuieangle = 10;lkinieangle = 0;rkinieangle = 0;
limuelbangle = 0;rimuelbangle = 0;lkinelbangle = 0;rkinelbangle = 0;
limuelb1angle = 0;rimuelb1angle = 0;lkinelb1angle = 0;rkinelb1angle = 0;
fs = 24;s=35;fontdiv = 1.3;limulocationdiv = 1.9/2.2;rimulocationdiv = 2.1/2.4;lkinlocationdiv = 1.75;rkinlocationdiv = 1.75;
ls = 0;rs = 1350;lw = 475;H = 1080;rw = 570;     %rectangle coordinates
fopen(ser);

while true
    flushinput(ser);
    pause(0.01);
    line = fscanf(ser);   % get data if there exists data in the next line
    data = strsplit(string(line),',');
    if(length(data) == 5 || length(data) == 6)
    switch data(1)
        case 'cal'
          switch data(2)
                case 'b'
                    B_mag = str2double(data(3));B_acc = str2double(data(4));B_gyr = str2double(data(5));B_sys = str2double(data(6));
                    Cal_B = [B_mag B_acc B_gyr B_sys];
                case 'a'
                    A_mag = str2double(data(3));A_acc = str2double(data(4));A_gyr = str2double(data(5));A_sys = str2double(data(6));      
                    Cal_A = [A_mag A_acc A_gyr A_sys];
                case 'c'
                    C_mag = str2double(data(3));C_acc = str2double(data(4));C_gyr = str2double(data(5));C_sys = str2double(data(6));  
                    Cal_C = [C_mag C_acc C_gyr C_sys];
                case 'd'
                    D_mag = str2double(data(3));D_acc = str2double(data(4));D_gyr = str2double(data(5));D_sys = str2double(data(6));      
                    Cal_D = [D_mag D_acc D_gyr D_sys];
                case 'e'
                    E_mag = str2double(data(3));E_acc = str2double(data(4));E_gyr = str2double(data(5));E_sys = str2double(data(6));      
                    Cal_E = [E_mag E_acc E_gyr E_sys];
          end 
          
                case 'e'
            qE = qconvert(data);
            if flg
                break
            else 
                [flg,Offsets] = find_offsets(qA,qB,qC,qD,qE);
            end

                case 'a'
           qA = qconvert(data);
           if flg
               break
           else 
                [flg,Offsets] = find_offsets(qA,qB,qC,qD,qE);
           end
            
                case 'c'
           qC = qconvert(data);
           if flg
               break
           else 
                [flg,Offsets] = find_offsets(qA,qB,qC,qD,qE);
           end
                case 'd'
           qD = qconvert(data);
           if flg
               break
           else 
                [flg,Offsets] = find_offsets(qA,qB,qC,qD,qE);
           end
                case 'b'
            qB = qconvert(data);
            if flg
               break
            else 
                [flg,Offsets] = find_offsets(qA,qB,qC,qD,qE);
            end
                end 
    end
end


while true
   tstart = tic;
   validData = k2.updateData;
   if validData
       depth = k2.getDepth;
       color = k2.getColor;
        depth8u = uint8(depth*(255/outOfRange));
        depth8uc3 = repmat(depth8u,[1 1 3]);
        color = imresize(color,COL_SCALE);
        c.im = imshow(color, 'Parent', c.ax);
        flag=1;
        tt=0;
        [bodies, fcp, timeStamp] = k2.getBodies('Quat');
        numBodies = size(bodies,2);
               if numBodies == 1
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
                   %%%%%% ELBOW angle calculation
                   E1=rightElbow-rightShoulder;
                   E2=rightWrist-rightElbow;
                   rkinelbangle=acosd(dot(E1,E2)/(norm(E1)*norm(E2)));
                   F1=leftElbow-leftShoulder;
                   F2=leftWrist-leftElbow;
                   lkinelbangle=acosd(dot(F1,F2)/(norm(F1)*norm(F2)));
                   %%%%%% SHOULDER angle calculation
                   RH2=rightElbow([1:3])-rightShoulder([1:3]);
                   LH2=leftElbow([1:3])-leftShoulder([1:3]);
                   RSLS = leftShoulder-rightShoulder;
                   LSRS = rightShoulder-leftShoulder;
                   TrunkVector = spinebase-spineShoulder;
                   coronalnormalL = cross(LSRS,TrunkVector);
                   coronalnormalR = cross(RSLS,TrunkVector);
                   armaxisnormalL = cross(LSRS,LH2);
                   armaxisnormalR = cross(RSLS,RH2);
            %coronal plane calculation
%                     if (leftElbow(1)<=(leftShoulder(1)-(0.25*norm(LH2))))
                        leftElbowprojection = LH2 - dot(LH2,coronalnormalL)*coronalnormalL;
                        lkinbdangle = sign(dot(TrunkVector,LH2))*atan2d(norm(cross(TrunkVector,LH2)),dot(TrunkVector,LH2));                      %Abduction-adduction angle left
%                     else
%                         lkinbdangle = 0;
%                     end
%                     if (rightElbow(1)>=(rightShoulder(1)+(0.25*norm(RH2))))
                        rightElbowprojection = RH2 - dot(RH2,coronalnormalR)*coronalnormalR;
                        rkinbdangle = sign(dot(TrunkVector,RH2))*atan2d(norm(cross(TrunkVector,RH2)),dot(TrunkVector,RH2));                     %Abduction-adduction angle right  
%                     else
%                         rkinbdangle = 0;
%                     end
            %Sagittal plane calculation
                    sagittalnormalL = cross(coronalnormalL,TrunkVector);
                    sagittalnormalR = cross(coronalnormalR,TrunkVector);
%             if (leftShoulder(3)>=(leftElbow(3)+(0.25*norm(LH2))))
                leftShoulderprojection = LH2 - (dot(LH2,sagittalnormalL)/norm(sagittalnormalL)^2)*sagittalnormalL;
                lkinefangle=sign(dot(TrunkVector,leftShoulderprojection))*atan2d(norm(cross(TrunkVector,leftShoulderprojection)),dot(TrunkVector,leftShoulderprojection));       %Extension-flexion left
%             else
%                 lkinefangle = 0;
%             end
%             if (rightShoulder(3)>=(rightElbow(3)+(0.25*norm(RH2))))
                rightShoulderprojection = RH2 - (dot(RH2,sagittalnormalR)/norm(sagittalnormalR)^2)*sagittalnormalR;
                rkinefangle=sign(dot(TrunkVector,rightShoulderprojection))*atan2d(norm(cross(TrunkVector,rightShoulderprojection)),dot(TrunkVector,rightShoulderprojection));    %Extension-flexion right
%             else
%                 rkinefangle = 0;
%             end
            %arm-axis plane calculation
                    leftwristprojection = armaxisnormalL - (dot(LH2,armaxisnormalL)/norm(LH2)^2)*LH2;
                    rightwristprojection = armaxisnormalR - (dot(RH2,armaxisnormalR)/norm(RH2)^2)*RH2;
%             if lkinelbangle>=60
                lkinieangle = sign(dot(leftwristprojection,F2))*atan2d(norm(cross(leftwristprojection,F2)),dot(leftwristprojection,F2));
%             else
%                 lkinieangle = 0;
%             end
%             if rkinelbangle>=60
                rkinieangle = sign(dot(-rightwristprojection,F2))*atan2d(norm(cross(-rightwristprojection,E2)),dot(-rightwristprojection,E2));
%             else
%                 rkinieangle = 0;
%             end
            rectangle('Position',[ls 0 lw H],'LineWidth',3,'FaceColor','k');  
            rectangle('Position',[rs 0 rw H],'LineWidth',3,'FaceColor','k');
                        %arduino section
    flushinput(ser);
    line = fscanf(ser);   % get data if there exists data in the next line
    data = strsplit(string(line),',');
%     text(rs+rw/2,750,calib,'Color','white','FontSize',0.75*fs/fontdiv,'FontWeight','normal','HorizontalAlignment','center');
    if(length(data) == 5 || length(data) == 6)
    switch data(1)
        
            case 'e'
            qE = qconvert(data);
            qE = fix_imu('e',qE,Offsets);
            lshoangle = getleftarm(qE,qC);
            limuieangle = lshoangle(3);limubdangle = lshoangle(2);limuefangle = lshoangle(1); 
            rshoangle = getrightarm(qE,qD);
            rimuieangle = rshoangle(3);rimubdangle = rshoangle(2);rimuefangle = rshoangle(1);
                
            case 'a'
            qA = qconvert(data);
            qA = fix_imu('a',qA,Offsets);
            lwriangle = getleftwrist(qC,qA);
            limuelbangle = lwriangle(1);
            limuelb1angle = lwriangle(2);
            
            case 'c'
            qC = qconvert(data);
            qC = fix_imu('c',qC,Offsets);
            lshoangle = getleftarm(qE,qC);
            lwriangle = getleftwrist(qC,qA);
            limuieangle = lshoangle(3);limubdangle = lshoangle(2);limuefangle = lshoangle(1); 
            limuelbangle = lwriangle(1);
            limuelb1angle = lwriangle(2);
           
            case 'd'
            qD = qconvert(data);
            qD = fix_imu('d',qD,Offsets);
            rshoangle = getrighthand(qE,qD);
            rwriangle = getrightwrist(qD,qB);
            rimuieangle = rshoangle(3);rimubdangle = rshoangle(2);rimuefangle = rshoangle(1);
            rimuelbangle = rwriangle(1);
            rimuelb1angle = rwriangle(2);
            
            case 'b'
            qB = qconvert(data);
            qB = fix_imu('b',qB,Offsets);
            rwriangle = getleftwrist(qD,qB);
            rimuelbangle = rwriangle(1);
            rimuelb1angle = rwriangle(2);
            
    end 
    end

            limuefstr = num2str(limuefangle,'%.1f');rimuefstr = num2str(rimuefangle,'%.1f');
            lkinefstr = num2str(lkinefangle,'%.1f');rkinefstr = num2str(rkinefangle,'%.1f');
            limubdstr = num2str(limubdangle,'%.1f');rimubdstr = num2str(rimubdangle,'%.1f');
            lkinbdstr = num2str(lkinbdangle,'%.1f');rkinbdstr = num2str(rkinbdangle,'%.1f');
            limuiestr = num2str(limuieangle,'%.1f');rimuiestr = num2str(rimuieangle,'%.1f');
            lkiniestr = num2str(lkinieangle,'%.1f');rkiniestr = num2str(rkinieangle,'%.1f');
            limuelbstr = num2str(limuelbangle,'%.1f');rimuelbstr = num2str(rimuelbangle,'%.1f');
            lkinelbstr = num2str(lkinelbangle,'%.1f');rkinelbstr = num2str(rkinelbangle,'%.1f');
            limuelb1str = num2str(limuelb1angle,'%.1f');rimuelb1str = num2str(rimuelb1angle,'%.1f');
            lkinelb1str = num2str(lkinelb1angle,'%.1f');rkinelb1str = num2str(rkinelb1angle,'%.1f');
                                                 %Text placement on the left side
text(ls+lw/2,s,lftstr,'Color','white','FontSize',fs,'FontWeight','bold','HorizontalAlignment','center');
text(rs+rw/2,s,rgtstr,'Color','white','FontSize',fs,'FontWeight','bold','HorizontalAlignment','center');
text(ls+lw/5,4*s,jtext,'Color','white','FontSize',fs/fontdiv,'FontWeight','bold','HorizontalAlignment','center');
text(rs+rw/5,4*s,jtext,'Color','white','FontSize',fs/fontdiv,'FontWeight','bold','HorizontalAlignment','center');
text(ls+(lw/lkinlocationdiv),4*s,kntstr,'Color','white','FontSize',fs/fontdiv,'FontWeight','bold','HorizontalAlignment','center');
text(rs+(rw/rkinlocationdiv),4*s,kntstr,'Color','white','FontSize',fs/fontdiv,'FontWeight','bold','HorizontalAlignment','center');
text(ls+(limulocationdiv*lw),4*s,imustr,'Color','white','FontSize',fs/fontdiv,'FontWeight','bold','HorizontalAlignment','center');
text(rs+(rimulocationdiv*rw),4*s,imustr,'Color','white','FontSize',fs/fontdiv,'FontWeight','bold','HorizontalAlignment','center');
text(ls+lw/5,7*s,stext,'Color','white','FontSize',fs/fontdiv,'FontWeight','bold','HorizontalAlignment','center');
text(rs+rw/5,7*s,stext,'Color','white','FontSize',fs/fontdiv,'FontWeight','bold','HorizontalAlignment','center');
text(ls+lw/5,8*s,efstr,'Color','white','FontSize',fs/fontdiv,'FontWeight','normal','HorizontalAlignment','center');
text(rs+rw/5,8*s,efstr,'Color','white','FontSize',fs/fontdiv,'FontWeight','normal','HorizontalAlignment','center');
text(ls+(lw/lkinlocationdiv),7.5*s,lkinefstr,'Color','white','FontSize',fs/fontdiv,'FontWeight','normal','HorizontalAlignment','center');
text(rs+(rw/rkinlocationdiv),7.5*s,rkinefstr,'Color','white','FontSize',fs/fontdiv,'FontWeight','normal','HorizontalAlignment','center');
text(ls+(limulocationdiv*lw),7.5*s,limuefstr,'Color','white','FontSize',fs/fontdiv,'FontWeight','normal','HorizontalAlignment','center');
text(rs+(rimulocationdiv*rw),7.5*s,rimuefstr,'Color','white','FontSize',fs/fontdiv,'FontWeight','normal','HorizontalAlignment','center');
text(ls+lw/5,11*s,stext,'Color','white','FontSize',fs/fontdiv,'FontWeight','bold','HorizontalAlignment','center');
text(rs+rw/5,11*s,stext,'Color','white','FontSize',fs/fontdiv,'FontWeight','bold','HorizontalAlignment','center');
text(ls+lw/5,12*s,bdstr,'Color','white','FontSize',fs/fontdiv,'FontWeight','normal','HorizontalAlignment','center');
text(rs+rw/5,12*s,bdstr,'Color','white','FontSize',fs/fontdiv,'FontWeight','normal','HorizontalAlignment','center');
text(ls+(lw/lkinlocationdiv),11.5*s,lkinbdstr,'Color','white','FontSize',fs/fontdiv,'FontWeight','normal','HorizontalAlignment','center');
text(rs+(rw/rkinlocationdiv),11.5*s,rkinbdstr,'Color','white','FontSize',fs/fontdiv,'FontWeight','normal','HorizontalAlignment','center');
text(ls+(limulocationdiv*lw),11.5*s,limubdstr,'Color','white','FontSize',fs/fontdiv,'FontWeight','normal','HorizontalAlignment','center');
text(rs+(rimulocationdiv*rw),11.5*s,rimubdstr,'Color','white','FontSize',fs/fontdiv,'FontWeight','normal','HorizontalAlignment','center');
text(ls+lw/5,15*s,stext,'Color','white','FontSize',fs/fontdiv,'FontWeight','bold','HorizontalAlignment','center');
text(rs+rw/5,15*s,stext,'Color','white','FontSize',fs/fontdiv,'FontWeight','bold','HorizontalAlignment','center');
text(ls+lw/5,16*s,iestr,'Color','white','FontSize',fs/fontdiv,'FontWeight','normal','HorizontalAlignment','center');
text(rs+rw/5,16*s,iestr,'Color','white','FontSize',fs/fontdiv,'FontWeight','normal','HorizontalAlignment','center');
text(ls+(lw/lkinlocationdiv),15.5*s,lkiniestr,'Color','white','FontSize',fs/fontdiv,'FontWeight','normal','HorizontalAlignment','center');
text(rs+(rw/rkinlocationdiv),15.5*s,rkiniestr,'Color','white','FontSize',fs/fontdiv,'FontWeight','normal','HorizontalAlignment','center');
text(ls+(limulocationdiv*lw),15.5*s,limuiestr,'Color','white','FontSize',fs/fontdiv,'FontWeight','normal','HorizontalAlignment','center');
text(rs+(rimulocationdiv*rw),15.5*s,rimuiestr,'Color','white','FontSize',fs/fontdiv,'FontWeight','normal','HorizontalAlignment','center');
text(ls+lw/5,19*s,etext,'Color','white','FontSize',fs/fontdiv,'FontWeight','bold','HorizontalAlignment','center');
text(rs+rw/5,19*s,etext,'Color','white','FontSize',fs/fontdiv,'FontWeight','bold','HorizontalAlignment','center');
text(ls+lw/5,20*s,efstr,'Color','white','FontSize',fs/fontdiv,'FontWeight','normal','HorizontalAlignment','center');
text(rs+rw/5,20*s,efstr,'Color','white','FontSize',fs/fontdiv,'FontWeight','normal','HorizontalAlignment','center');
text(ls+(lw/lkinlocationdiv),19.5*s,lkinelbstr,'Color','white','FontSize',fs/fontdiv,'FontWeight','normal','HorizontalAlignment','center');
text(rs+(rw/rkinlocationdiv),19.5*s,rkinelbstr,'Color','white','FontSize',fs/fontdiv,'FontWeight','normal','HorizontalAlignment','center');
text(ls+(limulocationdiv*lw),19.5*s,limuelbstr,'Color','white','FontSize',fs/fontdiv,'FontWeight','normal','HorizontalAlignment','center');
text(rs+(rimulocationdiv*rw),19.5*s,rimuelbstr,'Color','white','FontSize',fs/fontdiv,'FontWeight','normal','HorizontalAlignment','center');
text(ls+lw/5,23*s,ftext,'Color','white','FontSize',fs/fontdiv,'FontWeight','bold','HorizontalAlignment','center');
text(rs+rw/5,23*s,ftext,'Color','white','FontSize',fs/fontdiv,'FontWeight','bold','HorizontalAlignment','center');
text(ls+lw/5,24*s,psstr,'Color','white','FontSize',fs/fontdiv,'FontWeight','normal','HorizontalAlignment','center');
text(rs+rw/5,24*s,psstr,'Color','white','FontSize',fs/fontdiv,'FontWeight','normal','HorizontalAlignment','center');
text(ls+(lw/lkinlocationdiv),23.5*s,lkinelb1str,'Color','white','FontSize',fs/fontdiv,'FontWeight','normal','HorizontalAlignment','center');
text(rs+(rw/rkinlocationdiv),23.5*s,rkinelb1str,'Color','white','FontSize',fs/fontdiv,'FontWeight','normal','HorizontalAlignment','center');
text(ls+(limulocationdiv*lw),23.5*s,limuelb1str,'Color','white','FontSize',fs/fontdiv,'FontWeight','normal','HorizontalAlignment','center');
text(rs+(rimulocationdiv*rw),23.5*s,rimuelb1str,'Color','white','FontSize',fs/fontdiv,'FontWeight','normal','HorizontalAlignment','center');
            telapsed = telapsed+toc(tstart);
            text(ls+lw/3,1050,'Time (seconds)','Color','white','FontSize',fs/(fontdiv),'FontWeight','bold','HorizontalAlignment','center');
            text(ls+(limulocationdiv*lw),1000,num2str(telapsed,'%.2f'),'Color','white','FontSize',fs/fontdiv,'FontWeight','normal','HorizontalAlignment','center');
%               'Timestamp','Kinect_LeftShoulder_Ext.-Flex.','IMU_LeftShoulder_Ext.-Flex.','Kinect_LeftShoulder_Abd.-Add.','IMU_LeftShoulder_Abd.-Add.','Kinect_LeftShoulder_Int.-Ext.','IMU_LeftShoulder_Int.-Ext.','Kinect_LeftElbow_Ext.-Flex.','IMU_LeftElbow_Ext.-Flex.','IMU_LeftElbow_Pro.-Sup.','Kinect_RightShoulder_Ext.-Flex.','IMU_RightShoulder_Ext.-Flex.','Kinect_RightShoulder_Abd.-Add.','IMU_RightShoulder_Abd.-Add.','Kinect_RightShoulder_Int.-Ext.','IMU_RightShoulder_Int.-Ext.','Kinect_RightElbow_Ext.-Flex.','IMU_RightElbow_Ext.-Flex.','IMU_RightElbow_Pro.-Sup.');
        fprintf( fid, '%.2f,%.2f,%.2f,%.2f,%.2f,%.2f,%.2f,%.2f,%.2f,%.2f,%.2f,%.2f,%.2f,%.2f,%.2f,%.2f,%.2f,%.2f,%.2f\n',telapsed,lkinefangle,limuefangle,lkinbdangle,limubdangle,lkinieangle,limuieangle,lkinelbangle,limuelbangle,limuelb1angle,rkinefangle,rimuefangle,rkinbdangle,rimubdangle,rkinieangle,rimuieangle,rkinelbangle,rimuelbangle,rimuelb1angle);
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
        if strcmp(k,'q') 
            break; 
        end
        end
        k2.drawBodies(c.ax,bodies,'color',3,2,1);
        flag = 0;         
   end
     pause(0.00001);
    clearvars pos2Dxxx depth color validData depth8u depth8uc3 leftShoulder leftElbow leftWrist rightShoulder rightElbow rightWrist rightHand rightHandtip spineShoulder spineCenter spinebase hipRight hipLeft E1 E2 F1 F2 RH2 LH2 LSRS RSLS coronalnormalL coronalnormalR TrunkVector sagittalnormalL sagittalnormalR line data
    clearvars limubdstr limuefstr limuelbstr lkinefstr lkinbdstr lkiniestr limuiestr lkinelbstr rimubdstr rimuefstr rimuelbstr rkinefstr rkinbdstr rkiniestr rimuiestr rkinelbstr rimuelb1str rkinelb1str limuelb1str lkinelb1str
end
k2.delete;
clear all;
close all;
delete(instrfind({'Port'},{'COM15'}))
fclose(fid);





%%
delete(instrfind({'Port'},{'COM15'}))
fclose(fid);
font = 18;
[Time,KLSEF,IMULSEF,KLSAA,IMULSAA,KLSIE,IMULSIE,KLEEF,IMULEEF,IMULEPS,KRSEF,IMURSEF,KRSAA,IMURSAA,KRSIE,IMURSIE,KREEF,IMUREEF,IMUREPS] = ....
importtextkinimu(strfile);

figure(1)
plot(Time,KLSEF);
hold on
plot(Time,IMULSEF);
xlabel('Time (seconds)','FontWeight','bold','FontSize',font);
ylabel('Left Shoulder_{Extension-Flexion}','FontWeight','bold','FontSize',font);
legend('Kinect','WISE','Location','NorthWest','FontWeight','bold','FontSize',font);
hold off
figure(2)
plot(Time,KLSAA);
hold on
plot(Time,IMULSAA);
xlabel('Time (seconds)','FontWeight','bold','FontSize',font);
ylabel('Left Shoulder_{Abduction-Adduction}','FontWeight','bold','FontSize',font);
legend('Kinect','WISE','Location','NorthWest','FontWeight','bold','FontSize',font);
hold off

figure(3)
plot(Time,KLSIE);
hold on
plot(Time,IMULSIE);
xlabel('Time (seconds)','FontWeight','bold','FontSize',font);
ylabel('Left Shoulder_{Internal-External Rotation}','FontWeight','bold','FontSize',font);
legend('Kinect','WISE','Location','NorthWest','FontWeight','bold','FontSize',font);
hold off

figure(4)
subplot(2,1,1)
plot(Time,KLEEF);
hold on
plot(Time,IMULEEF);
xlabel('Time (seconds)','FontWeight','bold','FontSize',font);
ylabel('Left Elbow_{Extension-Flexion}','FontWeight','bold','FontSize',font);
legend('Kinect','WISE','Location','NorthWest','FontWeight','bold','FontSize',font);
hold off
subplot(2,1,2)
hold on
plot(Time,IMULEPS);
xlabel('Time (seconds)','FontWeight','bold','FontSize',font);
ylabel('Left Elbow_{Pronation-Supination}','FontWeight','bold','FontSize',font);
legend('WISE','Location','NorthWest','FontWeight','bold','FontSize',font);
hold off

figure(5)
plot(Time,KRSEF);
hold on
plot(Time,IMURSEF);
xlabel('Time (seconds)','FontWeight','bold','FontSize',font);
ylabel('Right Shoulder_{Extension-Flexion}','FontWeight','bold','FontSize',font);
legend('Kinect','WISE','Location','NorthWest','FontWeight','bold','FontSize',font);
hold off

figure(6)
plot(Time,KRSAA);
hold on
plot(Time,IMURSAA);
xlabel('Time (seconds)','FontWeight','bold','FontSize',font);
ylabel('Right Shoulder_{Abduction-Adduction}','FontWeight','bold','FontSize',font);
legend('Kinect','WISE','Location','NorthWest','FontWeight','bold','FontSize',font);
hold off

figure(7)
plot(Time,KRSIE);
hold on
plot(Time,IMURSIE);
xlabel('Time (seconds)','FontWeight','bold','FontSize',font);
ylabel('Right Shoulder_{Internal-External Rotation}','FontWeight','bold','FontSize',font);
legend('Kinect','WISE','Location','NorthWest','FontWeight','bold','FontSize',font);
hold off

figure(8)
subplot(2,1,1)
plot(Time,KREEF);
hold on
plot(Time,IMUREEF);
xlabel('Time (seconds)','FontWeight','bold','FontSize',font);
ylabel('Right Elbow_{Extension-Flexion}','FontWeight','bold','FontSize',font);
legend('Kinect','WISE','Location','NorthWest','FontWeight','bold','FontSize',font);
hold off
subplot(2,1,2)
hold on
plot(Time,IMUREPS);
xlabel('Time (seconds)','FontWeight','bold','FontSize',font);
ylabel('Right Elbow_{Pronation-Supination}','FontWeight','bold','FontSize',font);
legend('WISE','Location','NorthWest','FontWeight','bold','FontSize',font);
hold off