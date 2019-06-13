%% Initialization section
delete(instrfind({'Port'},{'COM15'}))
clear all; close all;clc;
flg = 1;
if flg 
    Offsets = [0.8589,0.0411,-0.0170,-0.5101; 1.0000,0,0,0; -0.8954,0.0070,0.0010,0.4452; -0.9749,0.0070,-0.0250,0.2210; 0.9791,-0.0371,-0.0170,-0.1994];
end
SUBJECTID = 1234;font = 12;
cd('F:\github\wearable-jacket\matlab\kinect+imudata\');
%Kinect initialization script
addpath('F:\github\wearable-jacket\matlab\KInectProject\Kin2');
addpath('F:\github\wearable-jacket\matlab\KInectProject\Kin2\Mex');
addpath('F:\github\wearable-jacket\matlab\KInectProject');
k2 = Kin2('color','depth','body','face');
outOfRange = 4000;c_width = 1920; c_height = 1080;COL_SCALE = 1.0;
color = zeros(c_height*COL_SCALE,c_width*COL_SCALE,3,'uint8');
c.h = figure(1);c.ax = axes;c.im = imshow(color,[]);
set( gcf, 'DoubleBuffer', 'on','keypress','k=get(gcf,''currentchar'');' );
%quaternion variables
qC = [1,0,0,0];qD = [1,0,0,0];qA = [1,0,0,0];qB = [1,0,0,0];qE = [1,0,0,0];empty = [1,0,0,0];
Cal_A = [0 0 0 0];Cal_B = [0 0 0 0];Cal_C = [0 0 0 0];Cal_D = [0 0 0 0];Cal_E = [0 0 0 0];
limuefangle = 0;rimuefangle = 0;lkinefangle = 0;rkinefangle = 0;
limubdangle = 0;rimubdangle = 0;lkinbdangle = 0;rkinbdangle = 0;
limuieangle = 0;rimuieangle = 10;lkinieangle = 0;rkinieangle = 0;
limuelbangle = 0;rimuelbangle = 0;lkinelbangle = 0;rkinelbangle = 0;
limuelb1angle = 0;rimuelb1angle = 0;lkinelb1angle = 0;rkinelb1angle = 0;
ls = 0;rs = 1350;lw = 475;H = 1080;rw = 570;     %rectangle coordinates
%COM Port details
delete(instrfind({'Port'},{'COM15'}))
ser = serial('COM15','BaudRate',115200,'InputBufferSize',100);
ser.ReadAsyncMode = 'continuous';
fopen(ser);

 %% IMU offsetdetermination
while ~flg
    
    flushinput(ser);
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

%%  Flexion-extension left arm 'lef'

file = sprintf('%s_WISE+KINECT_testing_%s_%s.txt',num2str(SUBJECTID),datestr(now,'mm-dd-yyyy HH-MM'),'left_flex-ext');
fid = fopen(file,'wt');
fprintf( fid, '%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s\n','Timestamp','Kinect_LeftShoulder_Ext.-Flex.',...
'IMU_LeftShoulder_Ext.-Flex.','Kinect_LeftShoulder_Abd.-Add.','IMU_LeftShoulder_Abd.-Add.','Kinect_LeftShoulder_Int.-Ext.',...
'IMU_LeftShoulder_Int.-Ext.','Kinect_LeftElbow_Ext.-Flex.','IMU_LeftElbow_Ext.-Flex.','IMU_LeftElbow_Pro.-Sup.',...
'Kinect_RightShoulder_Ext.-Flex.','IMU_RightShoulder_Ext.-Flex.','Kinect_RightShoulder_Abd.-Add.','IMU_RightShoulder_Abd.-Add.',...
'Kinect_RightShoulder_Int.-Ext.','IMU_RightShoulder_Int.-Ext.','Kinect_RightElbow_Ext.-Flex.','IMU_RightElbow_Ext.-Flex.',...
'IMU_RightElbow_Pro.-Sup.');
figure(2)
hold on
title('Left shoulder flexion-extension','FontWeight','bold','FontSize',font);
set( gcf, 'DoubleBuffer', 'on','keypress','k=get(gcf,''currentchar'');' );
xlabel('Time (seconds)','FontWeight','bold','FontSize',font);
ylabel('Joint angles (degrees)','FontWeight','bold','FontSize',font);
legend('Location','NorthWest','FontWeight','bold','FontSize',font);
axes1 = gca;axes2  = gca;
anline = animatedline(axes1,'Color','r','DisplayName','KINECT');
anline1 = animatedline(axes2,'Color','b','DisplayName','IMU');
hold off
k=[];telapsed = 0;lflag = 0;l = 0;lc = 1;
[~,~] = system('F:\unityrecordings\leftflexext.mp4');
while (lc) 
   tstart = tic;
   
   if ser.BytesAvailable
        [qA,qB,qC,qD,qE] = DataReceive(ser,qA,qB,qC,qD,qE);
        qE = fix_imu('e',qE,Offsets);
        qA = fix_imu('a',qA,Offsets);
        qC = fix_imu('c',qC,Offsets);
        qD = fix_imu('d',qD,Offsets);
        qB = fix_imu('b',qB,Offsets); 
        
        lshoangle = getleftarm(qE,qC);
        limuieangle = lshoangle(3);limubdangle = lshoangle(2);limuefangle = lshoangle(1); 
        rshoangle = getrightarm(qE,qD);
        rimuieangle = rshoangle(3);rimubdangle = rshoangle(2);rimuefangle = rshoangle(1); 
        lwriangle = getleftwrist(qC,qA);limuelbangle = lwriangle(1);limuelb1angle = lwriangle(2);
        lshoangle = getleftarm(qE,qC);lwriangle = getleftwrist(qC,qA);
        limuieangle = lshoangle(3);limubdangle = lshoangle(2);limuefangle = lshoangle(1); 
        limuelbangle = lwriangle(1);limuelb1angle = lwriangle(2);
        rshoangle = getrightarm(qE,qD);rwriangle = getrightwrist(qD,qB);
        rimuieangle = rshoangle(3);rimubdangle = rshoangle(2);rimuefangle = rshoangle(1);
        rimuelbangle = rwriangle(1);rimuelb1angle = rwriangle(2);
        rwriangle = getleftwrist(qD,qB);
        rimuelbangle = rwriangle(1);rimuelb1angle = rwriangle(2);     
    end
  
   validData = k2.updateData;
   if validData
       depth = k2.getDepth;color = k2.getColor;face = k2.getFaces;
       depth8u = uint8(depth*(255/outOfRange));depth8uc3 = repmat(depth8u,[1 1 3]);
       figure(1)
        color = imresize(color,COL_SCALE);c.im = imshow(color, 'Parent', c.ax);
        rectangle('Position',[0 0 475 1080],'LineWidth',3,'FaceColor','k');  
        rectangle('Position',[1350 0 620 1080],'LineWidth',3,'FaceColor','k');
        [bodies, fcp, timeStamp] = k2.getBodies('Quat');
        numBodies = size(bodies,2);
               if numBodies == 1
                    pos2Dxxx = bodies(1).Position;                                                              % All 25 joints positions are stored to the variable pos2Dxxx.  
                    [lkinefangle,rkinefangle,lkinbdangle,rkinbdangle,lkinieangle,rkinieangle,lkinelbangle,rkinelbangle] = get_Kinect(pos2Dxxx);
                                                                                                                 %arduino section

k2.drawBodies(c.ax,bodies,'color',3,2,1);k2.drawFaces(c.ax,face,5,false,20);

updateWiseKinect('lef',lkinefangle,limuefangle,telapsed,anline,anline1)

                    %'Timestamp','Kinect_LeftShoulder_Ext.-Flex.','IMU_LeftShoulder_Ext.-Flex.','Kinect_LeftShoulder_Abd.-Add.','IMU_
                    % LeftShoulder_Abd.-Add.','Kinect_LeftShoulder_Int.-Ext.','IMU_LeftShoulder_Int.-Ext.','Kinect_LeftElbow_Ext.-Flex.','IMU_LeftElbow_Ext.-Flex.',
                    % 'IMU_LeftElbow_Pro.-Sup.','Kinect_RightShoulder_Ext.-Flex.','IMU_RightShoulder_Ext.-Flex.','Kinect_RightShoulder_Abd.-Add.','IMU_RightShoulder_Abd.-Add.','Kinect_RightShoulder_Int.-Ext.','IMU_RightShoulder_Int.-Ext.','Kinect_RightElbow_Ext.-Flex.','IMU_RightElbow_Ext.-Flex.','IMU_RightElbow_Pro.-Sup.');
fprintf( fid, '%.2f,%.2f,%.2f,%.2f,%.2f,%.2f,%.2f,%.2f,%.2f,%.2f,%.2f,%.2f,%.2f,%.2f,%.2f,%.2f,%.2f,%.2f,%.2f\n',telapsed,...
lkinefangle,limuefangle,lkinbdangle,limubdangle,lkinieangle,limuieangle,lkinelbangle,limuelbangle,limuelb1angle,rkinefangle,rimuefangle,...
rkinbdangle,rimubdangle,rkinieangle,rimuieangle,rkinelbangle,rimuelbangle,rimuelb1angle);
if lkinefangle<=20
      lflag = 1;
end
if (lkinefangle>=150) && lflag
                l=l+1;
                lflag =0;
if l>=7
    lc = 0;
    clearvars l lflag
    break;
end
end
               end
       if numBodies == 0
           figure(1)
           s1 = strcat('No persons in view');   
           text((1920/2) - 250,100,s1,'Color','red','FontSize',30,'FontWeight','bold');
           clearvars s1
       end      
       if numBodies > 1
           figure(1)
           s1 = strcat('Too many people in view');
           text(1920/2,100,s1,'Color','red','FontSize',30,'FontWeight','bold');
           clearvars s1
       end      
       if ~isempty(k)
        if strcmp(k,'q') 
            k=[];
            break; 
        end
       end
   end
     pause(0.001);

if telapsed>=60
    break;
end

telapsed = telapsed+toc(tstart);
end
fclose(fid);
clearvars fid lc file

%% Abduction-adduction left arm 'lbd'

close figure 2     
file = sprintf('%s_WISE+KINECT_testing_%s_%s.txt',num2str(SUBJECTID),datestr(now,'mm-dd-yyyy HH-MM'),'left_abd-add');
fid = fopen(file,'wt');
fprintf( fid, '%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s\n','Timestamp','Kinect_LeftShoulder_Ext.-Flex.',...
'IMU_LeftShoulder_Ext.-Flex.','Kinect_LeftShoulder_Abd.-Add.','IMU_LeftShoulder_Abd.-Add.','Kinect_LeftShoulder_Int.-Ext.',...
'IMU_LeftShoulder_Int.-Ext.','Kinect_LeftElbow_Ext.-Flex.','IMU_LeftElbow_Ext.-Flex.','IMU_LeftElbow_Pro.-Sup.',...
'Kinect_RightShoulder_Ext.-Flex.','IMU_RightShoulder_Ext.-Flex.','Kinect_RightShoulder_Abd.-Add.','IMU_RightShoulder_Abd.-Add.',...
'Kinect_RightShoulder_Int.-Ext.','IMU_RightShoulder_Int.-Ext.','Kinect_RightElbow_Ext.-Flex.','IMU_RightElbow_Ext.-Flex.',...
'IMU_RightElbow_Pro.-Sup.');
figure(2)
hold on
title('Left shoulder abduction-adduction','FontWeight','bold','FontSize',font);
set( gcf, 'DoubleBuffer', 'on','keypress','k=get(gcf,''currentchar'');' );
xlabel('Time (seconds)','FontWeight','bold','FontSize',font);
ylabel('Joint angles (degrees)','FontWeight','bold','FontSize',font);
legend('Location','NorthWest','FontWeight','bold','FontSize',font);
axes1 = gca;axes2  = gca;
anline = animatedline(axes1,'Color','r','DisplayName','KINECT');
anline1 = animatedline(axes2,'Color','b','DisplayName','IMU');
hold off
k=[];telapsed = 0;lflag = 0;l = 0;lc = 1;
[~,~] = system('F:\unityrecordings\leftabdadd.mp4');
flushinput(ser);
while (lc) 
   tstart = tic;
   validData = k2.updateData;
   if validData
       depth = k2.getDepth;color = k2.getColor;face = k2.getFaces;
       depth8u = uint8(depth*(255/outOfRange));depth8uc3 = repmat(depth8u,[1 1 3]);
       figure(1)
        color = imresize(color,COL_SCALE);c.im = imshow(color, 'Parent', c.ax);
        rectangle('Position',[0 0 475 1080],'LineWidth',3,'FaceColor','k');  
        rectangle('Position',[1350 0 620 1080],'LineWidth',3,'FaceColor','k');
        [bodies, fcp, timeStamp] = k2.getBodies('Quat');
        numBodies = size(bodies,2);
               if numBodies == 1
                    pos2Dxxx = bodies(1).Position;                                                              % All 25 joints positions are stored to the variable pos2Dxxx.  
                    [lkinefangle,rkinefangle,lkinbdangle,rkinbdangle,lkinieangle,rkinieangle,lkinelbangle,rkinelbangle] = get_Kinect(pos2Dxxx);
                                                                                                                %arduino section
    if ser.BytesAvailable
    flushinput(ser);    
    line = fscanf(ser);                                                                                         % get data if there exists data in the next line
    data = strsplit(string(line),',');
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
            qA = qconvert(data);qA = fix_imu('a',qA,Offsets);
            lwriangle = getleftwrist(qC,qA);limuelbangle = lwriangle(1);limuelb1angle = lwriangle(2);
            case 'c'
            qC = qconvert(data);qC = fix_imu('c',qC,Offsets);
            lshoangle = getleftarm(qE,qC);lwriangle = getleftwrist(qC,qA);
            limuieangle = lshoangle(3);limubdangle = lshoangle(2);limuefangle = lshoangle(1); 
            limuelbangle = lwriangle(1);limuelb1angle = lwriangle(2);
            case 'd'
            qD = qconvert(data);qD = fix_imu('d',qD,Offsets);
            rshoangle = getrightarm(qE,qD);rwriangle = getrightwrist(qD,qB);
            rimuieangle = rshoangle(3);rimubdangle = rshoangle(2);rimuefangle = rshoangle(1);
            rimuelbangle = rwriangle(1);rimuelb1angle = rwriangle(2);
            case 'b'
            qB = qconvert(data);qB = fix_imu('b',qB,Offsets);
            rwriangle = getleftwrist(qD,qB);
            rimuelbangle = rwriangle(1);rimuelb1angle = rwriangle(2);     
    end 
    end
    end
k2.drawBodies(c.ax,bodies,'color',3,2,1);k2.drawFaces(c.ax,face,5,false,20);
updateWiseKinect('lbd',lkinbdangle,limubdangle,telapsed,anline,anline1)
                    %'Timestamp','Kinect_LeftShoulder_Ext.-Flex.','IMU_LeftShoulder_Ext.-Flex.','Kinect_LeftShoulder_Abd.-Add.','IMU_
                    % LeftShoulder_Abd.-Add.','Kinect_LeftShoulder_Int.-Ext.','IMU_LeftShoulder_Int.-Ext.','Kinect_LeftElbow_Ext.-Flex.','IMU_LeftElbow_Ext.-Flex.',
                    % 'IMU_LeftElbow_Pro.-Sup.','Kinect_RightShoulder_Ext.-Flex.','IMU_RightShoulder_Ext.-Flex.','Kinect_RightShoulder_Abd.-Add.','IMU_RightShoulder_Abd.-Add.','Kinect_RightShoulder_Int.-Ext.','IMU_RightShoulder_Int.-Ext.','Kinect_RightElbow_Ext.-Flex.','IMU_RightElbow_Ext.-Flex.','IMU_RightElbow_Pro.-Sup.');
fprintf( fid, '%.2f,%.2f,%.2f,%.2f,%.2f,%.2f,%.2f,%.2f,%.2f,%.2f,%.2f,%.2f,%.2f,%.2f,%.2f,%.2f,%.2f,%.2f,%.2f\n',telapsed,...
lkinefangle,limuefangle,lkinbdangle,limubdangle,lkinieangle,limuieangle,lkinelbangle,limuelbangle,limuelb1angle,rkinefangle,rimuefangle,...
rkinbdangle,rimubdangle,rkinieangle,rimuieangle,rkinelbangle,rimuelbangle,rimuelb1angle);
if lkinbdangle<=20
      lflag = 1;
end
if (lkinbdangle>=150) && lflag
                l=l+1;
                lflag =0;
if l>=7
    lc = 0;
    
    clearvars l lflag
    break;
end
end
               end
       if numBodies == 0
           figure(1)
           s1 = strcat('No persons in view');   
           text((1920/2) - 250,100,s1,'Color','red','FontSize',30,'FontWeight','bold');
           clearvars s1
       end      
       if numBodies > 1
           figure(1)
           s1 = strcat('Too many people in view');
           text(1920/2,100,s1,'Color','red','FontSize',30,'FontWeight','bold');
           clearvars s1
       end      
       if ~isempty(k)
        if strcmp(k,'q') 
            k=[];
            break; 
        end
       end
   end
     pause(0.001);
clearvars pos2Dxxx depth color validData depth8u depth8uc3 leftShoulder leftElbow leftWrist rightShoulder rightElbow rightWrist rightHand rightHandtip spineShoulder spineCenter spinebase hipRight hipLeft E1 E2 F1 F2 RH2 LH2 LSRS RSLS coronalnormalL coronalnormalR TrunkVector sagittalnormalL sagittalnormalR line data
clearvars limubdstr limuefstr limuelbstr lkinefstr lkinbdstr lkiniestr limuiestr lkinelbstr rimubdstr rimuefstr rimuelbstr rkinefstr rkinbdstr rkiniestr rimuiestr rkinelbstr rimuelb1str rkinelb1str limuelb1str lkinelb1str

if telapsed>=60
    break;
end
telapsed = telapsed+toc(tstart);
end
fclose(fid);  
clearvars fid lc file

%% Left elbow neutral extension-flexion  'lelb'

close figure 2     
file = sprintf('%s_WISE+KINECT_testing_%s_%s.txt',num2str(SUBJECTID),datestr(now,'mm-dd-yyyy HH-MM'),'left_elb_flex-ext');
fid = fopen(file,'wt');
fprintf( fid, '%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s\n','Timestamp','Kinect_LeftShoulder_Ext.-Flex.',...
'IMU_LeftShoulder_Ext.-Flex.','Kinect_LeftShoulder_Abd.-Add.','IMU_LeftShoulder_Abd.-Add.','Kinect_LeftShoulder_Int.-Ext.',...
'IMU_LeftShoulder_Int.-Ext.','Kinect_LeftElbow_Ext.-Flex.','IMU_LeftElbow_Ext.-Flex.','IMU_LeftElbow_Pro.-Sup.',...
'Kinect_RightShoulder_Ext.-Flex.','IMU_RightShoulder_Ext.-Flex.','Kinect_RightShoulder_Abd.-Add.','IMU_RightShoulder_Abd.-Add.',...
'Kinect_RightShoulder_Int.-Ext.','IMU_RightShoulder_Int.-Ext.','Kinect_RightElbow_Ext.-Flex.','IMU_RightElbow_Ext.-Flex.',...
'IMU_RightElbow_Pro.-Sup.');
figure(2)
hold on
title('Left elbow flexion-extension','FontWeight','bold','FontSize',font);
set( gcf, 'DoubleBuffer', 'on','keypress','k=get(gcf,''currentchar'');' );
xlabel('Time (seconds)','FontWeight','bold','FontSize',font);
ylabel('Joint angles (degrees)','FontWeight','bold','FontSize',font);
legend('Location','NorthWest','FontWeight','bold','FontSize',font);
axes1 = gca;axes2  = gca;
anline = animatedline(axes1,'Color','r','DisplayName','KINECT');
anline1 = animatedline(axes2,'Color','b','DisplayName','IMU');
hold off
k=[];telapsed = 0;lflag = 0;l = 0;lc = 1;
[~,~] = system('F:\unityrecordings\leftelbowflexext.mp4');
flushinput(ser);
while (lc) 
   tstart = tic;
   validData = k2.updateData;
   if validData
       depth = k2.getDepth;color = k2.getColor;face = k2.getFaces;
       depth8u = uint8(depth*(255/outOfRange));depth8uc3 = repmat(depth8u,[1 1 3]);
       figure(1)
        color = imresize(color,COL_SCALE);c.im = imshow(color, 'Parent', c.ax);
        rectangle('Position',[0 0 475 1080],'LineWidth',3,'FaceColor','k');  
        rectangle('Position',[1350 0 620 1080],'LineWidth',3,'FaceColor','k');
        [bodies, fcp, timeStamp] = k2.getBodies('Quat');
        numBodies = size(bodies,2);
               if numBodies == 1
                    pos2Dxxx = bodies(1).Position;                                                              % All 25 joints positions are stored to the variable pos2Dxxx.  
                    [lkinefangle,rkinefangle,lkinbdangle,rkinbdangle,lkinieangle,rkinieangle,lkinelbangle,rkinelbangle] = get_Kinect(pos2Dxxx);

                                                                                                                %arduino section
    
    if ser.BytesAvailable
    line = fscanf(ser);                                                                                         % get data if there exists data in the next line
    data = strsplit(string(line),',');
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
            qA = qconvert(data);qA = fix_imu('a',qA,Offsets);
            lwriangle = getleftwrist(qC,qA);limuelbangle = lwriangle(1);limuelb1angle = lwriangle(2);
            case 'c'
            qC = qconvert(data);qC = fix_imu('c',qC,Offsets);
            lshoangle = getleftarm(qE,qC);lwriangle = getleftwrist(qC,qA);
            limuieangle = lshoangle(3);limubdangle = lshoangle(2);limuefangle = lshoangle(1); 
            limuelbangle = lwriangle(1);limuelb1angle = lwriangle(2);
            case 'd'
            qD = qconvert(data);qD = fix_imu('d',qD,Offsets);
            rshoangle = getrightarm(qE,qD);rwriangle = getrightwrist(qD,qB);
            rimuieangle = rshoangle(3);rimubdangle = rshoangle(2);rimuefangle = rshoangle(1);
            rimuelbangle = rwriangle(1);rimuelb1angle = rwriangle(2);
            case 'b'
            qB = qconvert(data);qB = fix_imu('b',qB,Offsets);
            rwriangle = getleftwrist(qD,qB);
            rimuelbangle = rwriangle(1);rimuelb1angle = rwriangle(2);     
    end 
    end
    end
k2.drawBodies(c.ax,bodies,'color',3,2,1);k2.drawFaces(c.ax,face,5,false,20);

updateWiseKinect('lelb',lkinelbangle,limuelbangle,telapsed,anline,anline1)

                    %'Timestamp','Kinect_LeftShoulder_Ext.-Flex.','IMU_LeftShoulder_Ext.-Flex.','Kinect_LeftShoulder_Abd.-Add.','IMU_
                    % LeftShoulder_Abd.-Add.','Kinect_LeftShoulder_Int.-Ext.','IMU_LeftShoulder_Int.-Ext.','Kinect_LeftElbow_Ext.-Flex.','IMU_LeftElbow_Ext.-Flex.',
                    % 'IMU_LeftElbow_Pro.-Sup.','Kinect_RightShoulder_Ext.-Flex.','IMU_RightShoulder_Ext.-Flex.','Kinect_RightShoulder_Abd.-Add.','IMU_RightShoulder_Abd.-Add.','Kinect_RightShoulder_Int.-Ext.','IMU_RightShoulder_Int.-Ext.','Kinect_RightElbow_Ext.-Flex.','IMU_RightElbow_Ext.-Flex.','IMU_RightElbow_Pro.-Sup.');
fprintf( fid, '%.2f,%.2f,%.2f,%.2f,%.2f,%.2f,%.2f,%.2f,%.2f,%.2f,%.2f,%.2f,%.2f,%.2f,%.2f,%.2f,%.2f,%.2f,%.2f\n',telapsed,...
lkinefangle,limuefangle,lkinbdangle,limubdangle,lkinieangle,limuieangle,lkinelbangle,limuelbangle,limuelb1angle,rkinefangle,rimuefangle,...
rkinbdangle,rimubdangle,rkinieangle,rimuieangle,rkinelbangle,rimuelbangle,rimuelb1angle);
if lkinelbangle<=20
      lflag = 1;
end
if (lkinelbangle>=150) && lflag
                l=l+1;
                lflag =0;
if l>=7
    lc = 0;
    clearvars l lflag
    break;
end
end
               end
       if numBodies == 0
           figure(1)
           s1 = strcat('No persons in view');   
           text((1920/2) - 250,100,s1,'Color','red','FontSize',30,'FontWeight','bold');
           clearvars s1
       end      
       if numBodies > 1
           figure(1)
           s1 = strcat('Too many people in view');
           text(1920/2,100,s1,'Color','red','FontSize',30,'FontWeight','bold');
           clearvars s1
       end      
       if ~isempty(k)
        if strcmp(k,'q') 
            k=[];
            break; 
        end
       end
   end
     pause(0.001);
clearvars pos2Dxxx depth color validData depth8u depth8uc3 leftShoulder leftElbow leftWrist rightShoulder rightElbow rightWrist rightHand rightHandtip spineShoulder spineCenter spinebase hipRight hipLeft E1 E2 F1 F2 RH2 LH2 LSRS RSLS coronalnormalL coronalnormalR TrunkVector sagittalnormalL sagittalnormalR line data
clearvars limubdstr limuefstr limuelbstr lkinefstr lkinbdstr lkiniestr limuiestr lkinelbstr rimubdstr rimuefstr rimuelbstr rkinefstr rkinbdstr rkiniestr rimuiestr rkinelbstr rimuelb1str rkinelb1str limuelb1str lkinelb1str
if telapsed>=60
    break;
end
telapsed = telapsed+toc(tstart);
end
fclose(fid);                                                                                                                
clearvars fid lc file

%% Left elbow extension-flexion after abduction 'lelb'

close figure 2     
file = sprintf('%s_WISE+KINECT_testing_%s_%s.txt',num2str(SUBJECTID),datestr(now,'mm-dd-yyyy HH-MM'),'left_elb_flex-ext-wabd');
fid = fopen(file,'wt');
fprintf( fid, '%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s\n','Timestamp','Kinect_LeftShoulder_Ext.-Flex.',...
'IMU_LeftShoulder_Ext.-Flex.','Kinect_LeftShoulder_Abd.-Add.','IMU_LeftShoulder_Abd.-Add.','Kinect_LeftShoulder_Int.-Ext.',...
'IMU_LeftShoulder_Int.-Ext.','Kinect_LeftElbow_Ext.-Flex.','IMU_LeftElbow_Ext.-Flex.','IMU_LeftElbow_Pro.-Sup.',...
'Kinect_RightShoulder_Ext.-Flex.','IMU_RightShoulder_Ext.-Flex.','Kinect_RightShoulder_Abd.-Add.','IMU_RightShoulder_Abd.-Add.',...
'Kinect_RightShoulder_Int.-Ext.','IMU_RightShoulder_Int.-Ext.','Kinect_RightElbow_Ext.-Flex.','IMU_RightElbow_Ext.-Flex.',...
'IMU_RightElbow_Pro.-Sup.');
figure(2)
hold on
title('Left elbow flexion-extension','FontWeight','bold','FontSize',font);
set( gcf, 'DoubleBuffer', 'on','keypress','k=get(gcf,''currentchar'');' );
xlabel('Time (seconds)','FontWeight','bold','FontSize',font);
ylabel('Joint angles (degrees)','FontWeight','bold','FontSize',font);
legend('Location','NorthWest','FontWeight','bold','FontSize',font);
axes1 = gca;axes2  = gca;
anline = animatedline(axes1,'Color','r','DisplayName','KINECT');
anline1 = animatedline(axes2,'Color','b','DisplayName','IMU');
hold off
k=[];telapsed = 0;lflag = 0;l = 0;lc = 1;
[~,~] = system('F:\unityrecordings\leftelbowflexext1.mp4');
flushinput(ser);
while (lc) 
   tstart = tic;
   validData = k2.updateData;
   if validData
       depth = k2.getDepth;color = k2.getColor;face = k2.getFaces;
       depth8u = uint8(depth*(255/outOfRange));depth8uc3 = repmat(depth8u,[1 1 3]);
       figure(1)
        color = imresize(color,COL_SCALE);c.im = imshow(color, 'Parent', c.ax);
        rectangle('Position',[0 0 475 1080],'LineWidth',3,'FaceColor','k');  
        rectangle('Position',[1350 0 620 1080],'LineWidth',3,'FaceColor','k');
        [bodies, fcp, timeStamp] = k2.getBodies('Quat');
        numBodies = size(bodies,2);
               if numBodies == 1
                    pos2Dxxx = bodies(1).Position;                                                              % All 25 joints positions are stored to the variable pos2Dxxx.  
                    [lkinefangle,rkinefangle,lkinbdangle,rkinbdangle,lkinieangle,rkinieangle,lkinelbangle,rkinelbangle] = get_Kinect(pos2Dxxx);

                                                                                                                %arduino section
    if ser.BytesAvailable
    line = fscanf(ser);                                                                                         % get data if there exists data in the next line
    data = strsplit(string(line),',');
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
            qA = qconvert(data);qA = fix_imu('a',qA,Offsets);
            lwriangle = getleftwrist(qC,qA);limuelbangle = lwriangle(1);limuelb1angle = lwriangle(2);
            case 'c'
            qC = qconvert(data);qC = fix_imu('c',qC,Offsets);
            lshoangle = getleftarm(qE,qC);lwriangle = getleftwrist(qC,qA);
            limuieangle = lshoangle(3);limubdangle = lshoangle(2);limuefangle = lshoangle(1); 
            limuelbangle = lwriangle(1);limuelb1angle = lwriangle(2);
            case 'd'
            qD = qconvert(data);qD = fix_imu('d',qD,Offsets);
            rshoangle = getrightarm(qE,qD);rwriangle = getrightwrist(qD,qB);
            rimuieangle = rshoangle(3);rimubdangle = rshoangle(2);rimuefangle = rshoangle(1);
            rimuelbangle = rwriangle(1);rimuelb1angle = rwriangle(2);
            case 'b'
            qB = qconvert(data);qB = fix_imu('b',qB,Offsets);
            rwriangle = getleftwrist(qD,qB);
            rimuelbangle = rwriangle(1);rimuelb1angle = rwriangle(2);     
    end 
    end
    end
k2.drawBodies(c.ax,bodies,'color',3,2,1);k2.drawFaces(c.ax,face,5,false,20);

updateWiseKinect('lelb',lkinelbangle,limuelbangle,telapsed,anline,anline1)

                    %'Timestamp','Kinect_LeftShoulder_Ext.-Flex.','IMU_LeftShoulder_Ext.-Flex.','Kinect_LeftShoulder_Abd.-Add.','IMU_
                    % LeftShoulder_Abd.-Add.','Kinect_LeftShoulder_Int.-Ext.','IMU_LeftShoulder_Int.-Ext.','Kinect_LeftElbow_Ext.-Flex.','IMU_LeftElbow_Ext.-Flex.',
                    % 'IMU_LeftElbow_Pro.-Sup.','Kinect_RightShoulder_Ext.-Flex.','IMU_RightShoulder_Ext.-Flex.','Kinect_RightShoulder_Abd.-Add.','IMU_RightShoulder_Abd.-Add.','Kinect_RightShoulder_Int.-Ext.','IMU_RightShoulder_Int.-Ext.','Kinect_RightElbow_Ext.-Flex.','IMU_RightElbow_Ext.-Flex.','IMU_RightElbow_Pro.-Sup.');
fprintf( fid, '%.2f,%.2f,%.2f,%.2f,%.2f,%.2f,%.2f,%.2f,%.2f,%.2f,%.2f,%.2f,%.2f,%.2f,%.2f,%.2f,%.2f,%.2f,%.2f\n',telapsed,...
lkinefangle,limuefangle,lkinbdangle,limubdangle,lkinieangle,limuieangle,lkinelbangle,limuelbangle,limuelb1angle,rkinefangle,rimuefangle,...
rkinbdangle,rimubdangle,rkinieangle,rimuieangle,rkinelbangle,rimuelbangle,rimuelb1angle);
if lkinelbangle<=20
      lflag = 1;
end
if (lkinelbangle>=150) && lflag
                l=l+1;
                lflag =0;
if l>=7
    lc = 0;
    
    clearvars l lflag
    break;
end
end
               end
       if numBodies == 0
           figure(1)
           s1 = strcat('No persons in view');   
           text((1920/2) - 250,100,s1,'Color','red','FontSize',30,'FontWeight','bold');
           clearvars s1
       end      
       if numBodies > 1
           figure(1)
           s1 = strcat('Too many people in view');
           text(1920/2,100,s1,'Color','red','FontSize',30,'FontWeight','bold');
           clearvars s1
       end      
       if ~isempty(k)
        if strcmp(k,'q') 
            k=[];
            break; 
        end
       end
   end
     pause(0.001);
clearvars pos2Dxxx depth color validData depth8u depth8uc3 leftShoulder leftElbow leftWrist rightShoulder rightElbow rightWrist rightHand rightHandtip spineShoulder spineCenter spinebase hipRight hipLeft E1 E2 F1 F2 RH2 LH2 LSRS RSLS coronalnormalL coronalnormalR TrunkVector sagittalnormalL sagittalnormalR line data
clearvars limubdstr limuefstr limuelbstr lkinefstr lkinbdstr lkiniestr limuiestr lkinelbstr rimubdstr rimuefstr rimuelbstr rkinefstr rkinbdstr rkiniestr rimuiestr rkinelbstr rimuelb1str rkinelb1str limuelb1str lkinelb1str

if telapsed>=60
    break;
end

telapsed = telapsed+toc(tstart);
end
fclose(fid);
clearvars fid lc file

%% Left forearm pronation supination 'lps'

close figure 2     
file = sprintf('%s_WISE+KINECT_testing_%s_%s.txt',num2str(SUBJECTID),datestr(now,'mm-dd-yyyy HH-MM'),'left_forearm_pro-sup');
fid = fopen(file,'wt');
fprintf( fid, '%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s\n','Timestamp','Kinect_LeftShoulder_Ext.-Flex.',...
'IMU_LeftShoulder_Ext.-Flex.','Kinect_LeftShoulder_Abd.-Add.','IMU_LeftShoulder_Abd.-Add.','Kinect_LeftShoulder_Int.-Ext.',...
'IMU_LeftShoulder_Int.-Ext.','Kinect_LeftElbow_Ext.-Flex.','IMU_LeftElbow_Ext.-Flex.','IMU_LeftElbow_Pro.-Sup.',...
'Kinect_RightShoulder_Ext.-Flex.','IMU_RightShoulder_Ext.-Flex.','Kinect_RightShoulder_Abd.-Add.','IMU_RightShoulder_Abd.-Add.',...
'Kinect_RightShoulder_Int.-Ext.','IMU_RightShoulder_Int.-Ext.','Kinect_RightElbow_Ext.-Flex.','IMU_RightElbow_Ext.-Flex.',...
'IMU_RightElbow_Pro.-Sup.');
figure(2)
hold on
title('Left elbow pronation-supination','FontWeight','bold','FontSize',font);
set( gcf, 'DoubleBuffer', 'on','keypress','k=get(gcf,''currentchar'');' );
xlabel('Time (seconds)','FontWeight','bold','FontSize',font);
ylabel('Joint angles (degrees)','FontWeight','bold','FontSize',font);
legend('Location','NorthWest','FontWeight','bold','FontSize',font);
axes1 = gca;axes2  = gca;
anline = animatedline(axes1,'Color','r','DisplayName','KINECT');
anline1 = animatedline(axes2,'Color','b','DisplayName','IMU');
hold off
k=[];telapsed = 0;lflag = 0;l = 0;lc = 1;
[~,~] = system('F:\unityrecordings\leftprosup.mp4');
flushinput(ser);
while (lc) 
   tstart = tic;
   validData = k2.updateData;
   if validData
       depth = k2.getDepth;color = k2.getColor;face = k2.getFaces;
       depth8u = uint8(depth*(255/outOfRange));depth8uc3 = repmat(depth8u,[1 1 3]);
       figure(1)
        color = imresize(color,COL_SCALE);c.im = imshow(color, 'Parent', c.ax);
        rectangle('Position',[0 0 475 1080],'LineWidth',3,'FaceColor','k');  
        rectangle('Position',[1350 0 620 1080],'LineWidth',3,'FaceColor','k');
        [bodies, fcp, timeStamp] = k2.getBodies('Quat');
        numBodies = size(bodies,2);
               if numBodies == 1
                    pos2Dxxx = bodies(1).Position;                                                              % All 25 joints positions are stored to the variable pos2Dxxx.  
                    [lkinefangle,rkinefangle,lkinbdangle,rkinbdangle,lkinieangle,rkinieangle,lkinelbangle,rkinelbangle] = get_Kinect(pos2Dxxx);

                                                                                                                %arduino section
    if ser.BytesAvailable
    line = fscanf(ser);                                                                                         % get data if there exists data in the next line
    data = strsplit(string(line),',');
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
            qA = qconvert(data);qA = fix_imu('a',qA,Offsets);
            lwriangle = getleftwrist(qC,qA);limuelbangle = lwriangle(1);limuelb1angle = lwriangle(2);
            case 'c'
            qC = qconvert(data);qC = fix_imu('c',qC,Offsets);
            lshoangle = getleftarm(qE,qC);lwriangle = getleftwrist(qC,qA);
            limuieangle = lshoangle(3);limubdangle = lshoangle(2);limuefangle = lshoangle(1); 
            limuelbangle = lwriangle(1);limuelb1angle = lwriangle(2);
            case 'd'
            qD = qconvert(data);qD = fix_imu('d',qD,Offsets);
            rshoangle = getrightarm(qE,qD);rwriangle = getrightwrist(qD,qB);
            rimuieangle = rshoangle(3);rimubdangle = rshoangle(2);rimuefangle = rshoangle(1);
            rimuelbangle = rwriangle(1);rimuelb1angle = rwriangle(2);
            case 'b'
            qB = qconvert(data);qB = fix_imu('b',qB,Offsets);
            rwriangle = getleftwrist(qD,qB);
            rimuelbangle = rwriangle(1);rimuelb1angle = rwriangle(2);     
    end 
    end
    end
k2.drawBodies(c.ax,bodies,'color',3,2,1);k2.drawFaces(c.ax,face,5,false,20);

updateWiseKinect('lps',lkinelb1angle,limuelb1angle,telapsed,anline,anline1)

                    %'Timestamp','Kinect_LeftShoulder_Ext.-Flex.','IMU_LeftShoulder_Ext.-Flex.','Kinect_LeftShoulder_Abd.-Add.','IMU_
                    % LeftShoulder_Abd.-Add.','Kinect_LeftShoulder_Int.-Ext.','IMU_LeftShoulder_Int.-Ext.','Kinect_LeftElbow_Ext.-Flex.','IMU_LeftElbow_Ext.-Flex.',
                    % 'IMU_LeftElbow_Pro.-Sup.','Kinect_RightShoulder_Ext.-Flex.','IMU_RightShoulder_Ext.-Flex.','Kinect_RightShoulder_Abd.-Add.','IMU_RightShoulder_Abd.-Add.','Kinect_RightShoulder_Int.-Ext.','IMU_RightShoulder_Int.-Ext.','Kinect_RightElbow_Ext.-Flex.','IMU_RightElbow_Ext.-Flex.','IMU_RightElbow_Pro.-Sup.');
fprintf( fid, '%.2f,%.2f,%.2f,%.2f,%.2f,%.2f,%.2f,%.2f,%.2f,%.2f,%.2f,%.2f,%.2f,%.2f,%.2f,%.2f,%.2f,%.2f,%.2f\n',telapsed,...
lkinefangle,limuefangle,lkinbdangle,limubdangle,lkinieangle,limuieangle,lkinelbangle,limuelbangle,limuelb1angle,rkinefangle,rimuefangle,...
rkinbdangle,rimubdangle,rkinieangle,rimuieangle,rkinelbangle,rimuelbangle,rimuelb1angle);
if limuelb1angle<=-45
      lflag = 1;
end
if (limuelb1angle>=45) && lflag
                l=l+1;
                lflag =0;
if l>=7
    lc = 0;
    
    clearvars l lflag
    break;
end
end
               end
       if numBodies == 0
           figure(1)
           s1 = strcat('No persons in view');   
           text((1920/2) - 250,100,s1,'Color','red','FontSize',30,'FontWeight','bold');
           clearvars s1
       end      
       if numBodies > 1
           figure(1)
           s1 = strcat('Too many people in view');
           text(1920/2,100,s1,'Color','red','FontSize',30,'FontWeight','bold');
           clearvars s1
       end      
       if ~isempty(k)
        if strcmp(k,'q') 
            k=[];
            break; 
        end
       end
   end
     pause(0.001);
clearvars pos2Dxxx depth color validData depth8u depth8uc3 leftShoulder leftElbow leftWrist rightShoulder rightElbow rightWrist rightHand rightHandtip spineShoulder spineCenter spinebase hipRight hipLeft E1 E2 F1 F2 RH2 LH2 LSRS RSLS coronalnormalL coronalnormalR TrunkVector sagittalnormalL sagittalnormalR line data
clearvars limubdstr limuefstr limuelbstr lkinefstr lkinbdstr lkiniestr limuiestr lkinelbstr rimubdstr rimuefstr rimuelbstr rkinefstr rkinbdstr rkiniestr rimuiestr rkinelbstr rimuelb1str rkinelb1str limuelb1str lkinelb1str

if telapsed>=60
    break;
end

telapsed = telapsed+toc(tstart);
end
fclose(fid);
clearvars fid lc file


%% Left shoulder internal-external rotation with flexed elbow 'lie'

close figure 2     
file = sprintf('%s_WISE+KINECT_testing_%s_%s.txt',num2str(SUBJECTID),datestr(now,'mm-dd-yyyy HH-MM'),'left_int-ext');
fid = fopen(file,'wt');
fprintf( fid, '%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s\n','Timestamp','Kinect_LeftShoulder_Ext.-Flex.',...
'IMU_LeftShoulder_Ext.-Flex.','Kinect_LeftShoulder_Abd.-Add.','IMU_LeftShoulder_Abd.-Add.','Kinect_LeftShoulder_Int.-Ext.',...
'IMU_LeftShoulder_Int.-Ext.','Kinect_LeftElbow_Ext.-Flex.','IMU_LeftElbow_Ext.-Flex.','IMU_LeftElbow_Pro.-Sup.',...
'Kinect_RightShoulder_Ext.-Flex.','IMU_RightShoulder_Ext.-Flex.','Kinect_RightShoulder_Abd.-Add.','IMU_RightShoulder_Abd.-Add.',...
'Kinect_RightShoulder_Int.-Ext.','IMU_RightShoulder_Int.-Ext.','Kinect_RightElbow_Ext.-Flex.','IMU_RightElbow_Ext.-Flex.',...
'IMU_RightElbow_Pro.-Sup.');
figure(2)
hold on
title('Left shoulder internal-external rotation','FontWeight','bold','FontSize',font);
set( gcf, 'DoubleBuffer', 'on','keypress','k=get(gcf,''currentchar'');' );
xlabel('Time (seconds)','FontWeight','bold','FontSize',font);
ylabel('Joint angles (degrees)','FontWeight','bold','FontSize',font);
legend('Location','NorthWest','FontWeight','bold','FontSize',font);
axes1 = gca;axes2  = gca;
anline = animatedline(axes1,'Color','r','DisplayName','KINECT');
anline1 = animatedline(axes2,'Color','b','DisplayName','IMU');
hold off
k=[];telapsed = 0;lflag = 0;l = 0;lc = 1;
[~,~] = system('F:\unityrecordings\leftintext.mp4');
flushinput(ser);
while (lc) 
   tstart = tic;
   validData = k2.updateData;
   if validData
       depth = k2.getDepth;color = k2.getColor;face = k2.getFaces;
       depth8u = uint8(depth*(255/outOfRange));depth8uc3 = repmat(depth8u,[1 1 3]);
       figure(1)
        color = imresize(color,COL_SCALE);c.im = imshow(color, 'Parent', c.ax);
        rectangle('Position',[0 0 475 1080],'LineWidth',3,'FaceColor','k');  
        rectangle('Position',[1350 0 620 1080],'LineWidth',3,'FaceColor','k');
        [bodies, fcp, timeStamp] = k2.getBodies('Quat');
        numBodies = size(bodies,2);
               if numBodies == 1
                    pos2Dxxx = bodies(1).Position;                                                              % All 25 joints positions are stored to the variable pos2Dxxx.  
                    [lkinefangle,rkinefangle,lkinbdangle,rkinbdangle,lkinieangle,rkinieangle,lkinelbangle,rkinelbangle] = get_Kinect(pos2Dxxx);

                                                                                                                %arduino section
    if ser.BytesAvailable
    line = fscanf(ser);                                                                                         % get data if there exists data in the next line
    data = strsplit(string(line),',');
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
            qA = qconvert(data);qA = fix_imu('a',qA,Offsets);
            lwriangle = getleftwrist(qC,qA);limuelbangle = lwriangle(1);limuelb1angle = lwriangle(2);
            case 'c'
            qC = qconvert(data);qC = fix_imu('c',qC,Offsets);
            lshoangle = getleftarm(qE,qC);lwriangle = getleftwrist(qC,qA);
            limuieangle = lshoangle(3);limubdangle = lshoangle(2);limuefangle = lshoangle(1); 
            limuelbangle = lwriangle(1);limuelb1angle = lwriangle(2);
            case 'd'
            qD = qconvert(data);qD = fix_imu('d',qD,Offsets);
            rshoangle = getrightarm(qE,qD);rwriangle = getrightwrist(qD,qB);
            rimuieangle = rshoangle(3);rimubdangle = rshoangle(2);rimuefangle = rshoangle(1);
            rimuelbangle = rwriangle(1);rimuelb1angle = rwriangle(2);
            case 'b'
            qB = qconvert(data);qB = fix_imu('b',qB,Offsets);
            rwriangle = getleftwrist(qD,qB);
            rimuelbangle = rwriangle(1);rimuelb1angle = rwriangle(2);     
    end 
    end
    end
k2.drawBodies(c.ax,bodies,'color',3,2,1);k2.drawFaces(c.ax,face,5,false,20);

updateWiseKinect('lie',lkinieangle,limuieangle,telapsed,anline,anline1)

                    %'Timestamp','Kinect_LeftShoulder_Ext.-Flex.','IMU_LeftShoulder_Ext.-Flex.','Kinect_LeftShoulder_Abd.-Add.','IMU_
                    % LeftShoulder_Abd.-Add.','Kinect_LeftShoulder_Int.-Ext.','IMU_LeftShoulder_Int.-Ext.','Kinect_LeftElbow_Ext.-Flex.','IMU_LeftElbow_Ext.-Flex.',
                    % 'IMU_LeftElbow_Pro.-Sup.','Kinect_RightShoulder_Ext.-Flex.','IMU_RightShoulder_Ext.-Flex.','Kinect_RightShoulder_Abd.-Add.','IMU_RightShoulder_Abd.-Add.','Kinect_RightShoulder_Int.-Ext.','IMU_RightShoulder_Int.-Ext.','Kinect_RightElbow_Ext.-Flex.','IMU_RightElbow_Ext.-Flex.','IMU_RightElbow_Pro.-Sup.');
fprintf( fid, '%.2f,%.2f,%.2f,%.2f,%.2f,%.2f,%.2f,%.2f,%.2f,%.2f,%.2f,%.2f,%.2f,%.2f,%.2f,%.2f,%.2f,%.2f,%.2f\n',telapsed,...
lkinefangle,limuefangle,lkinbdangle,limubdangle,lkinieangle,limuieangle,lkinelbangle,limuelbangle,limuelb1angle,rkinefangle,rimuefangle,...
rkinbdangle,rimubdangle,rkinieangle,rimuieangle,rkinelbangle,rimuelbangle,rimuelb1angle);
if lkinieangle<=-45
      lflag = 1;
end
if (lkinieangle>=45) && lflag
                l=l+1;
                lflag =0;
if l>=7
    lc = 0;
    clearvars l lflag
    break;
end
end
               end
       if numBodies == 0
           figure(1)
           s1 = strcat('No persons in view');   
           text((1920/2) - 250,100,s1,'Color','red','FontSize',30,'FontWeight','bold');
           clearvars s1
       end      
       if numBodies > 1
           figure(1)
           s1 = strcat('Too many people in view');
           text(1920/2,100,s1,'Color','red','FontSize',30,'FontWeight','bold');
           clearvars s1
       end      
       if ~isempty(k)
        if strcmp(k,'q') 
            k=[];
            break; 
        end
       end
   end
     pause(0.001);
clearvars pos2Dxxx depth color validData depth8u depth8uc3 leftShoulder leftElbow leftWrist rightShoulder rightElbow rightWrist rightHand rightHandtip spineShoulder spineCenter spinebase hipRight hipLeft E1 E2 F1 F2 RH2 LH2 LSRS RSLS coronalnormalL coronalnormalR TrunkVector sagittalnormalL sagittalnormalR line data
clearvars limubdstr limuefstr limuelbstr lkinefstr lkinbdstr lkiniestr limuiestr lkinelbstr rimubdstr rimuefstr rimuelbstr rkinefstr rkinbdstr rkiniestr rimuiestr rkinelbstr rimuelb1str rkinelb1str limuelb1str lkinelb1str

if telapsed>=60
    break;
end

telapsed = telapsed+toc(tstart);
end
fclose(fid);
clearvars fid lc file

%% Left shoulder internal-external rotation with abducted arm 'lie'

close figure 2     
file = sprintf('%s_WISE+KINECT_testing_%s_%s.txt',num2str(SUBJECTID),datestr(now,'mm-dd-yyyy HH-MM'),'left_int-ext_wabd');
fid = fopen(file,'wt');
fprintf( fid, '%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s\n','Timestamp','Kinect_LeftShoulder_Ext.-Flex.',...
'IMU_LeftShoulder_Ext.-Flex.','Kinect_LeftShoulder_Abd.-Add.','IMU_LeftShoulder_Abd.-Add.','Kinect_LeftShoulder_Int.-Ext.',...
'IMU_LeftShoulder_Int.-Ext.','Kinect_LeftElbow_Ext.-Flex.','IMU_LeftElbow_Ext.-Flex.','IMU_LeftElbow_Pro.-Sup.',...
'Kinect_RightShoulder_Ext.-Flex.','IMU_RightShoulder_Ext.-Flex.','Kinect_RightShoulder_Abd.-Add.','IMU_RightShoulder_Abd.-Add.',...
'Kinect_RightShoulder_Int.-Ext.','IMU_RightShoulder_Int.-Ext.','Kinect_RightElbow_Ext.-Flex.','IMU_RightElbow_Ext.-Flex.',...
'IMU_RightElbow_Pro.-Sup.');
figure(2)
hold on
title('Left shoulder internal-external rotation','FontWeight','bold','FontSize',font);
set( gcf, 'DoubleBuffer', 'on','keypress','k=get(gcf,''currentchar'');' );
xlabel('Time (seconds)','FontWeight','bold','FontSize',font);
ylabel('Joint angles (degrees)','FontWeight','bold','FontSize',font);
legend('Location','NorthWest','FontWeight','bold','FontSize',font);
axes1 = gca;axes2  = gca;
anline = animatedline(axes1,'Color','r','DisplayName','KINECT');
anline1 = animatedline(axes2,'Color','b','DisplayName','IMU');
hold off
k=[];telapsed = 0;lflag = 0;l = 0;lc = 1;
[~,~] = system('F:\unityrecordings\leftintext1.mp4');
flushinput(ser);
while (lc) 
   tstart = tic;
   validData = k2.updateData;
   if validData
       depth = k2.getDepth;color = k2.getColor;face = k2.getFaces;
       depth8u = uint8(depth*(255/outOfRange));depth8uc3 = repmat(depth8u,[1 1 3]);
       figure(1)
        color = imresize(color,COL_SCALE);c.im = imshow(color, 'Parent', c.ax);
        rectangle('Position',[0 0 475 1080],'LineWidth',3,'FaceColor','k');  
        rectangle('Position',[1350 0 620 1080],'LineWidth',3,'FaceColor','k');
        [bodies, fcp, timeStamp] = k2.getBodies('Quat');
        numBodies = size(bodies,2);
               if numBodies == 1
                    pos2Dxxx = bodies(1).Position;                                                              % All 25 joints positions are stored to the variable pos2Dxxx.  
                    [lkinefangle,rkinefangle,lkinbdangle,rkinbdangle,lkinieangle,rkinieangle,lkinelbangle,rkinelbangle] = get_Kinect(pos2Dxxx);

                                                                                                                %arduino section
    if ser.BytesAvailable
    line = fscanf(ser);                                                                                         % get data if there exists data in the next line
    data = strsplit(string(line),',');
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
            qA = qconvert(data);qA = fix_imu('a',qA,Offsets);
            lwriangle = getleftwrist(qC,qA);limuelbangle = lwriangle(1);limuelb1angle = lwriangle(2);
            case 'c'
            qC = qconvert(data);qC = fix_imu('c',qC,Offsets);
            lshoangle = getleftarm(qE,qC);lwriangle = getleftwrist(qC,qA);
            limuieangle = lshoangle(3);limubdangle = lshoangle(2);limuefangle = lshoangle(1); 
            limuelbangle = lwriangle(1);limuelb1angle = lwriangle(2);
            case 'd'
            qD = qconvert(data);qD = fix_imu('d',qD,Offsets);
            rshoangle = getrightarm(qE,qD);rwriangle = getrightwrist(qD,qB);
            rimuieangle = rshoangle(3);rimubdangle = rshoangle(2);rimuefangle = rshoangle(1);
            rimuelbangle = rwriangle(1);rimuelb1angle = rwriangle(2);
            case 'b'
            qB = qconvert(data);qB = fix_imu('b',qB,Offsets);
            rwriangle = getleftwrist(qD,qB);
            rimuelbangle = rwriangle(1);rimuelb1angle = rwriangle(2);     
    end 
    end
    end
k2.drawBodies(c.ax,bodies,'color',3,2,1);k2.drawFaces(c.ax,face,5,false,20);

updateWiseKinect('lie',lkinieangle,limuieangle,telapsed,anline,anline1)

                    %'Timestamp','Kinect_LeftShoulder_Ext.-Flex.','IMU_LeftShoulder_Ext.-Flex.','Kinect_LeftShoulder_Abd.-Add.','IMU_
                    % LeftShoulder_Abd.-Add.','Kinect_LeftShoulder_Int.-Ext.','IMU_LeftShoulder_Int.-Ext.','Kinect_LeftElbow_Ext.-Flex.','IMU_LeftElbow_Ext.-Flex.',
                    % 'IMU_LeftElbow_Pro.-Sup.','Kinect_RightShoulder_Ext.-Flex.','IMU_RightShoulder_Ext.-Flex.','Kinect_RightShoulder_Abd.-Add.','IMU_RightShoulder_Abd.-Add.','Kinect_RightShoulder_Int.-Ext.','IMU_RightShoulder_Int.-Ext.','Kinect_RightElbow_Ext.-Flex.','IMU_RightElbow_Ext.-Flex.','IMU_RightElbow_Pro.-Sup.');
fprintf( fid, '%.2f,%.2f,%.2f,%.2f,%.2f,%.2f,%.2f,%.2f,%.2f,%.2f,%.2f,%.2f,%.2f,%.2f,%.2f,%.2f,%.2f,%.2f,%.2f\n',telapsed,...
lkinefangle,limuefangle,lkinbdangle,limubdangle,lkinieangle,limuieangle,lkinelbangle,limuelbangle,limuelb1angle,rkinefangle,rimuefangle,...
rkinbdangle,rimubdangle,rkinieangle,rimuieangle,rkinelbangle,rimuelbangle,rimuelb1angle);

if limuieangle<=-45
      lflag = 1;
end
if (limuieangle>=45) && lflag
                l=l+1;
                lflag =0;
if l>=7
    lc = 0;
    clearvars l lflag
    break;
end

end
               end
       if numBodies == 0
           figure(1)
           s1 = strcat('No persons in view');   
           text((1920/2) - 250,100,s1,'Color','red','FontSize',30,'FontWeight','bold');
           clearvars s1
       end      
       if numBodies > 1
           figure(1)
           s1 = strcat('Too many people in view');
           text(1920/2,100,s1,'Color','red','FontSize',30,'FontWeight','bold');
           clearvars s1
       end      
       if ~isempty(k)
        if strcmp(k,'q') 
            k=[];
            break; 
        end
       end
   end
     pause(0.001);
clearvars pos2Dxxx depth color validData depth8u depth8uc3 leftShoulder leftElbow leftWrist rightShoulder rightElbow rightWrist rightHand rightHandtip spineShoulder spineCenter spinebase hipRight hipLeft E1 E2 F1 F2 RH2 LH2 LSRS RSLS coronalnormalL coronalnormalR TrunkVector sagittalnormalL sagittalnormalR line data
clearvars limubdstr limuefstr limuelbstr lkinefstr lkinbdstr lkiniestr limuiestr lkinelbstr rimubdstr rimuefstr rimuelbstr rkinefstr rkinbdstr rkiniestr rimuiestr rkinelbstr rimuelb1str rkinelb1str limuelb1str lkinelb1str

if telapsed>=60
    break;
end

telapsed = telapsed+toc(tstart);
end
fclose(fid);
clearvars fid lc file

%%  Flexion-extension right arm 'ref'

file = sprintf('%s_WISE+KINECT_testing_%s_%s.txt',num2str(SUBJECTID),datestr(now,'mm-dd-yyyy HH-MM'),'right_flex-ext');
fid = fopen(file,'wt');
fprintf( fid, '%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s\n','Timestamp','Kinect_LeftShoulder_Ext.-Flex.',...
'IMU_LeftShoulder_Ext.-Flex.','Kinect_LeftShoulder_Abd.-Add.','IMU_LeftShoulder_Abd.-Add.','Kinect_LeftShoulder_Int.-Ext.',...
'IMU_LeftShoulder_Int.-Ext.','Kinect_LeftElbow_Ext.-Flex.','IMU_LeftElbow_Ext.-Flex.','IMU_LeftElbow_Pro.-Sup.',...
'Kinect_RightShoulder_Ext.-Flex.','IMU_RightShoulder_Ext.-Flex.','Kinect_RightShoulder_Abd.-Add.','IMU_RightShoulder_Abd.-Add.',...
'Kinect_RightShoulder_Int.-Ext.','IMU_RightShoulder_Int.-Ext.','Kinect_RightElbow_Ext.-Flex.','IMU_RightElbow_Ext.-Flex.',...
'IMU_RightElbow_Pro.-Sup.');
figure(2)
hold on
title('Right shoulder flexion-extension','FontWeight','bold','FontSize',font);
set( gcf, 'DoubleBuffer', 'on','keypress','k=get(gcf,''currentchar'');' );
xlabel('Time (seconds)','FontWeight','bold','FontSize',font);
ylabel('Joint angles (degrees)','FontWeight','bold','FontSize',font);
legend('Location','NorthWest','FontWeight','bold','FontSize',font);
axes1 = gca;axes2  = gca;
anline = animatedline(axes1,'Color','r','DisplayName','KINECT');
anline1 = animatedline(axes2,'Color','b','DisplayName','IMU');
hold off
k=[];telapsed = 0;lflag = 0;l = 0;lc = 1;
[~,~] = system('F:\unityrecordings\rightflexext.mp4');
flushinput(ser);
while (lc) 
   tstart = tic;
   validData = k2.updateData;
   if validData
       depth = k2.getDepth;color = k2.getColor;face = k2.getFaces;
       depth8u = uint8(depth*(255/outOfRange));depth8uc3 = repmat(depth8u,[1 1 3]);
       figure(1)
        color = imresize(color,COL_SCALE);c.im = imshow(color, 'Parent', c.ax);
        rectangle('Position',[0 0 475 1080],'LineWidth',3,'FaceColor','k');  
        rectangle('Position',[1350 0 620 1080],'LineWidth',3,'FaceColor','k');
        [bodies, fcp, timeStamp] = k2.getBodies('Quat');
        numBodies = size(bodies,2);
               if numBodies == 1
                    pos2Dxxx = bodies(1).Position;                                                              % All 25 joints positions are stored to the variable pos2Dxxx.  
                    [lkinefangle,rkinefangle,lkinbdangle,rkinbdangle,lkinieangle,rkinieangle,lkinelbangle,rkinelbangle] = get_Kinect(pos2Dxxx);
                                                                                                                 %arduino section
    if ser.BytesAvailable
    line = fscanf(ser);                                                                                         % get data if there exists data in the next line
    data = strsplit(string(line),',');
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
            qA = qconvert(data);qA = fix_imu('a',qA,Offsets);
            lwriangle = getleftwrist(qC,qA);limuelbangle = lwriangle(1);limuelb1angle = lwriangle(2);
            case 'c'
            qC = qconvert(data);qC = fix_imu('c',qC,Offsets);
            lshoangle = getleftarm(qE,qC);lwriangle = getleftwrist(qC,qA);
            limuieangle = lshoangle(3);limubdangle = lshoangle(2);limuefangle = lshoangle(1); 
            limuelbangle = lwriangle(1);limuelb1angle = lwriangle(2);
            case 'd'
            qD = qconvert(data);qD = fix_imu('d',qD,Offsets);
            rshoangle = getrightarm(qE,qD);rwriangle = getrightwrist(qD,qB);
            rimuieangle = rshoangle(3);rimubdangle = rshoangle(2);rimuefangle = rshoangle(1);
            rimuelbangle = rwriangle(1);rimuelb1angle = rwriangle(2);
            case 'b'
            qB = qconvert(data);qB = fix_imu('b',qB,Offsets);
            rwriangle = getleftwrist(qD,qB);
            rimuelbangle = rwriangle(1);rimuelb1angle = rwriangle(2);     
    end 
    end
    end
    

k2.drawBodies(c.ax,bodies,'color',3,2,1);k2.drawFaces(c.ax,face,5,false,20);

updateWiseKinect('ref',rkinefangle,rimuefangle,telapsed,anline,anline1)

                    %'Timestamp','Kinect_LeftShoulder_Ext.-Flex.','IMU_LeftShoulder_Ext.-Flex.','Kinect_LeftShoulder_Abd.-Add.','IMU_
                    % LeftShoulder_Abd.-Add.','Kinect_LeftShoulder_Int.-Ext.','IMU_LeftShoulder_Int.-Ext.','Kinect_LeftElbow_Ext.-Flex.','IMU_LeftElbow_Ext.-Flex.',
                    % 'IMU_LeftElbow_Pro.-Sup.','Kinect_RightShoulder_Ext.-Flex.','IMU_RightShoulder_Ext.-Flex.','Kinect_RightShoulder_Abd.-Add.','IMU_RightShoulder_Abd.-Add.','Kinect_RightShoulder_Int.-Ext.','IMU_RightShoulder_Int.-Ext.','Kinect_RightElbow_Ext.-Flex.','IMU_RightElbow_Ext.-Flex.','IMU_RightElbow_Pro.-Sup.');
fprintf( fid, '%.2f,%.2f,%.2f,%.2f,%.2f,%.2f,%.2f,%.2f,%.2f,%.2f,%.2f,%.2f,%.2f,%.2f,%.2f,%.2f,%.2f,%.2f,%.2f\n',telapsed,...
lkinefangle,limuefangle,lkinbdangle,limubdangle,lkinieangle,limuieangle,lkinelbangle,limuelbangle,limuelb1angle,rkinefangle,rimuefangle,...
rkinbdangle,rimubdangle,rkinieangle,rimuieangle,rkinelbangle,rimuelbangle,rimuelb1angle);

if rkinefangle<=20
      lflag = 1;
end
if (rkinefangle>=150) && lflag
                l=l+1;
                lflag =0;
if l>=7
    lc = 0;
    clearvars l lflag
    break;
end
end
               end
       if numBodies == 0
           figure(1)
           s1 = strcat('No persons in view');   
           text((1920/2) - 250,100,s1,'Color','red','FontSize',30,'FontWeight','bold');
           clearvars s1
       end      
       if numBodies > 1
           figure(1)
           s1 = strcat('Too many people in view');
           text(1920/2,100,s1,'Color','red','FontSize',30,'FontWeight','bold');
           clearvars s1
       end      
       if ~isempty(k)
        if strcmp(k,'q') 
            k=[];
            break; 
        end
       end
   end
     pause(0.001);
clearvars pos2Dxxx depth color validData depth8u depth8uc3 leftShoulder leftElbow leftWrist rightShoulder rightElbow rightWrist rightHand rightHandtip spineShoulder spineCenter spinebase hipRight hipLeft E1 E2 F1 F2 RH2 LH2 LSRS RSLS coronalnormalL coronalnormalR TrunkVector sagittalnormalL sagittalnormalR line data
clearvars limubdstr limuefstr limuelbstr lkinefstr lkinbdstr lkiniestr limuiestr lkinelbstr rimubdstr rimuefstr rimuelbstr rkinefstr rkinbdstr rkiniestr rimuiestr rkinelbstr rimuelb1str rkinelb1str limuelb1str lkinelb1str

if telapsed>=60
    break;
end

telapsed = telapsed+toc(tstart);
end
fclose(fid);
clearvars fid lc file

%% Abduction-adduction right arm 'rbd'

close figure 2     
file = sprintf('%s_WISE+KINECT_testing_%s_%s.txt',num2str(SUBJECTID),datestr(now,'mm-dd-yyyy HH-MM'),'right_abd-add');
fid = fopen(file,'wt');
fprintf( fid, '%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s\n','Timestamp','Kinect_LeftShoulder_Ext.-Flex.',...
'IMU_LeftShoulder_Ext.-Flex.','Kinect_LeftShoulder_Abd.-Add.','IMU_LeftShoulder_Abd.-Add.','Kinect_LeftShoulder_Int.-Ext.',...
'IMU_LeftShoulder_Int.-Ext.','Kinect_LeftElbow_Ext.-Flex.','IMU_LeftElbow_Ext.-Flex.','IMU_LeftElbow_Pro.-Sup.',...
'Kinect_RightShoulder_Ext.-Flex.','IMU_RightShoulder_Ext.-Flex.','Kinect_RightShoulder_Abd.-Add.','IMU_RightShoulder_Abd.-Add.',...
'Kinect_RightShoulder_Int.-Ext.','IMU_RightShoulder_Int.-Ext.','Kinect_RightElbow_Ext.-Flex.','IMU_RightElbow_Ext.-Flex.',...
'IMU_RightElbow_Pro.-Sup.');
figure(2)
hold on
title('Right shoulder abduction-adduction','FontWeight','bold','FontSize',font);
set( gcf, 'DoubleBuffer', 'on','keypress','k=get(gcf,''currentchar'');' );
xlabel('Time (seconds)','FontWeight','bold','FontSize',font);
ylabel('Joint angles (degrees)','FontWeight','bold','FontSize',font);
legend('Location','NorthWest','FontWeight','bold','FontSize',font);
axes1 = gca;axes2  = gca;
anline = animatedline(axes1,'Color','r','DisplayName','KINECT');
anline1 = animatedline(axes2,'Color','b','DisplayName','IMU');
hold off
k=[];telapsed = 0;lflag = 0;l = 0;lc = 1;
[~,~] = system('F:\unityrecordings\rightabdadd.mp4');
flushinput(ser);
while (lc) 
   tstart = tic;
   validData = k2.updateData;
   if validData
       depth = k2.getDepth;color = k2.getColor;face = k2.getFaces;
       depth8u = uint8(depth*(255/outOfRange));depth8uc3 = repmat(depth8u,[1 1 3]);
       figure(1)
        color = imresize(color,COL_SCALE);c.im = imshow(color, 'Parent', c.ax);
        rectangle('Position',[0 0 475 1080],'LineWidth',3,'FaceColor','k');  
        rectangle('Position',[1350 0 620 1080],'LineWidth',3,'FaceColor','k');
        [bodies, fcp, timeStamp] = k2.getBodies('Quat');
        numBodies = size(bodies,2);
               if numBodies == 1
                    pos2Dxxx = bodies(1).Position;                                                              % All 25 joints positions are stored to the variable pos2Dxxx.  
                    [lkinefangle,rkinefangle,lkinbdangle,rkinbdangle,lkinieangle,rkinieangle,lkinelbangle,rkinelbangle] = get_Kinect(pos2Dxxx);
                                                                                                                %arduino section
    if ser.BytesAvailable
        line = fscanf(ser);                                                                                         % get data if there exists data in the next line
        data = strsplit(string(line),',');
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
                qA = qconvert(data);qA = fix_imu('a',qA,Offsets);
                lwriangle = getleftwrist(qC,qA);limuelbangle = lwriangle(1);limuelb1angle = lwriangle(2);
                case 'c'
                qC = qconvert(data);qC = fix_imu('c',qC,Offsets);
                lshoangle = getleftarm(qE,qC);lwriangle = getleftwrist(qC,qA);
                limuieangle = lshoangle(3);limubdangle = lshoangle(2);limuefangle = lshoangle(1); 
                limuelbangle = lwriangle(1);limuelb1angle = lwriangle(2);
                case 'd'
                qD = qconvert(data);qD = fix_imu('d',qD,Offsets);
                rshoangle = getrightarm(qE,qD);rwriangle = getrightwrist(qD,qB);
                rimuieangle = rshoangle(3);rimubdangle = rshoangle(2);rimuefangle = rshoangle(1);
                rimuelbangle = rwriangle(1);rimuelb1angle = rwriangle(2);
                case 'b'
                qB = qconvert(data);qB = fix_imu('b',qB,Offsets);
                rwriangle = getleftwrist(qD,qB);
                rimuelbangle = rwriangle(1);rimuelb1angle = rwriangle(2);     
            end 
        end
    end
k2.drawBodies(c.ax,bodies,'color',3,2,1);k2.drawFaces(c.ax,face,5,false,20);

updateWiseKinect('rbd',rkinbdangle,rimubdangle,telapsed,anline,anline1)

                    %'Timestamp','Kinect_LeftShoulder_Ext.-Flex.','IMU_LeftShoulder_Ext.-Flex.','Kinect_LeftShoulder_Abd.-Add.','IMU_
                    % LeftShoulder_Abd.-Add.','Kinect_LeftShoulder_Int.-Ext.','IMU_LeftShoulder_Int.-Ext.','Kinect_LeftElbow_Ext.-Flex.','IMU_LeftElbow_Ext.-Flex.',
                    % 'IMU_LeftElbow_Pro.-Sup.','Kinect_RightShoulder_Ext.-Flex.','IMU_RightShoulder_Ext.-Flex.','Kinect_RightShoulder_Abd.-Add.','IMU_RightShoulder_Abd.-Add.','Kinect_RightShoulder_Int.-Ext.','IMU_RightShoulder_Int.-Ext.','Kinect_RightElbow_Ext.-Flex.','IMU_RightElbow_Ext.-Flex.','IMU_RightElbow_Pro.-Sup.');
fprintf( fid, '%.2f,%.2f,%.2f,%.2f,%.2f,%.2f,%.2f,%.2f,%.2f,%.2f,%.2f,%.2f,%.2f,%.2f,%.2f,%.2f,%.2f,%.2f,%.2f\n',telapsed,...
lkinefangle,limuefangle,lkinbdangle,limubdangle,lkinieangle,limuieangle,lkinelbangle,limuelbangle,limuelb1angle,rkinefangle,rimuefangle,...
rkinbdangle,rimubdangle,rkinieangle,rimuieangle,rkinelbangle,rimuelbangle,rimuelb1angle);

if rkinbdangle<=20
    lflag = 1;
end
if (rkinbdangle>=150) && lflag
    l=l+1;
    lflag =0;
    if l>=7
        lc = 0;
        clearvars l lflag
        break;
    end
end
               end
       if numBodies == 0
           figure(1)
           s1 = strcat('No persons in view');   
           text((1920/2) - 250,100,s1,'Color','red','FontSize',30,'FontWeight','bold');
           clearvars s1
       end      
       if numBodies > 1
           figure(1)
           s1 = strcat('Too many people in view');
           text(1920/2,100,s1,'Color','red','FontSize',30,'FontWeight','bold');
           clearvars s1
       end      
       if ~isempty(k)
        if strcmp(k,'q') 
            k=[];
            break; 
        end
       end
   end
     pause(0.001);
clearvars pos2Dxxx depth color validData depth8u depth8uc3 leftShoulder leftElbow leftWrist rightShoulder rightElbow rightWrist rightHand rightHandtip spineShoulder spineCenter spinebase hipRight hipLeft E1 E2 F1 F2 RH2 LH2 LSRS RSLS coronalnormalL coronalnormalR TrunkVector sagittalnormalL sagittalnormalR line data
clearvars limubdstr limuefstr limuelbstr lkinefstr lkinbdstr lkiniestr limuiestr lkinelbstr rimubdstr rimuefstr rimuelbstr rkinefstr rkinbdstr rkiniestr rimuiestr rkinelbstr rimuelb1str rkinelb1str limuelb1str lkinelb1str

if telapsed>=60
    break;
end
telapsed = telapsed+toc(tstart);
end
fclose(fid);  
clearvars fid lc file

%% Right elbow neutral extension-flexion  'relb'

close figure 2     
file = sprintf('%s_WISE+KINECT_testing_%s_%s.txt',num2str(SUBJECTID),datestr(now,'mm-dd-yyyy HH-MM'),'right_elb_flex-ext');
fid = fopen(file,'wt');
fprintf( fid, '%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s\n','Timestamp','Kinect_LeftShoulder_Ext.-Flex.',...
'IMU_LeftShoulder_Ext.-Flex.','Kinect_LeftShoulder_Abd.-Add.','IMU_LeftShoulder_Abd.-Add.','Kinect_LeftShoulder_Int.-Ext.',...
'IMU_LeftShoulder_Int.-Ext.','Kinect_LeftElbow_Ext.-Flex.','IMU_LeftElbow_Ext.-Flex.','IMU_LeftElbow_Pro.-Sup.',...
'Kinect_RightShoulder_Ext.-Flex.','IMU_RightShoulder_Ext.-Flex.','Kinect_RightShoulder_Abd.-Add.','IMU_RightShoulder_Abd.-Add.',...
'Kinect_RightShoulder_Int.-Ext.','IMU_RightShoulder_Int.-Ext.','Kinect_RightElbow_Ext.-Flex.','IMU_RightElbow_Ext.-Flex.',...
'IMU_RightElbow_Pro.-Sup.');
figure(2)
hold on
title('Right elbow flexion-extension','FontWeight','bold','FontSize',font);
set( gcf, 'DoubleBuffer', 'on','keypress','k=get(gcf,''currentchar'');' );
xlabel('Time (seconds)','FontWeight','bold','FontSize',font);
ylabel('Joint angles (degrees)','FontWeight','bold','FontSize',font);
legend('Location','NorthWest','FontWeight','bold','FontSize',font);
axes1 = gca;axes2  = gca;
anline = animatedline(axes1,'Color','r','DisplayName','KINECT');
anline1 = animatedline(axes2,'Color','b','DisplayName','IMU');
hold off
k=[];telapsed = 0;lflag = 0;l = 0;lc = 1;
[~,~] = system('F:\unityrecordings\rightelbowflexext.mp4');
flushinput(ser);
while (lc) 
   tstart = tic;
   validData = k2.updateData;
   if validData
       depth = k2.getDepth;color = k2.getColor;face = k2.getFaces;
       depth8u = uint8(depth*(255/outOfRange));depth8uc3 = repmat(depth8u,[1 1 3]);
       figure(1)
        color = imresize(color,COL_SCALE);c.im = imshow(color, 'Parent', c.ax);
        rectangle('Position',[0 0 475 1080],'LineWidth',3,'FaceColor','k');  
        rectangle('Position',[1350 0 620 1080],'LineWidth',3,'FaceColor','k');
        [bodies, fcp, timeStamp] = k2.getBodies('Quat');
        numBodies = size(bodies,2);
               if numBodies == 1
                    pos2Dxxx = bodies(1).Position;                                                              % All 25 joints positions are stored to the variable pos2Dxxx.  
                    [lkinefangle,rkinefangle,lkinbdangle,rkinbdangle,lkinieangle,rkinieangle,lkinelbangle,rkinelbangle] = get_Kinect(pos2Dxxx);

                                                                                                                %arduino section
    if ser.BytesAvailable
        line = fscanf(ser);                                                                                         % get data if there exists data in the next line
        data = strsplit(string(line),',');
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
                qA = qconvert(data);qA = fix_imu('a',qA,Offsets);
                lwriangle = getleftwrist(qC,qA);limuelbangle = lwriangle(1);limuelb1angle = lwriangle(2);
                case 'c'
                qC = qconvert(data);qC = fix_imu('c',qC,Offsets);
                lshoangle = getleftarm(qE,qC);lwriangle = getleftwrist(qC,qA);
                limuieangle = lshoangle(3);limubdangle = lshoangle(2);limuefangle = lshoangle(1); 
                limuelbangle = lwriangle(1);limuelb1angle = lwriangle(2);
                case 'd'
                qD = qconvert(data);qD = fix_imu('d',qD,Offsets);
                rshoangle = getrightarm(qE,qD);rwriangle = getrightwrist(qD,qB);
                rimuieangle = rshoangle(3);rimubdangle = rshoangle(2);rimuefangle = rshoangle(1);
                rimuelbangle = rwriangle(1);rimuelb1angle = rwriangle(2);
                case 'b'
                qB = qconvert(data);qB = fix_imu('b',qB,Offsets);
                rwriangle = getleftwrist(qD,qB);
                rimuelbangle = rwriangle(1);rimuelb1angle = rwriangle(2);     
            end 
        end
    end
k2.drawBodies(c.ax,bodies,'color',3,2,1);k2.drawFaces(c.ax,face,5,false,20);

updateWiseKinect('relb',rkinelbangle,rimuelbangle,telapsed,anline,anline1)

                    %'Timestamp','Kinect_LeftShoulder_Ext.-Flex.','IMU_LeftShoulder_Ext.-Flex.','Kinect_LeftShoulder_Abd.-Add.','IMU_
                    % LeftShoulder_Abd.-Add.','Kinect_LeftShoulder_Int.-Ext.','IMU_LeftShoulder_Int.-Ext.','Kinect_LeftElbow_Ext.-Flex.','IMU_LeftElbow_Ext.-Flex.',
                    % 'IMU_LeftElbow_Pro.-Sup.','Kinect_RightShoulder_Ext.-Flex.','IMU_RightShoulder_Ext.-Flex.','Kinect_RightShoulder_Abd.-Add.','IMU_RightShoulder_Abd.-Add.','Kinect_RightShoulder_Int.-Ext.','IMU_RightShoulder_Int.-Ext.','Kinect_RightElbow_Ext.-Flex.','IMU_RightElbow_Ext.-Flex.','IMU_RightElbow_Pro.-Sup.');
fprintf( fid, '%.2f,%.2f,%.2f,%.2f,%.2f,%.2f,%.2f,%.2f,%.2f,%.2f,%.2f,%.2f,%.2f,%.2f,%.2f,%.2f,%.2f,%.2f,%.2f\n',telapsed,...
lkinefangle,limuefangle,lkinbdangle,limubdangle,lkinieangle,limuieangle,lkinelbangle,limuelbangle,limuelb1angle,rkinefangle,rimuefangle,...
rkinbdangle,rimubdangle,rkinieangle,rimuieangle,rkinelbangle,rimuelbangle,rimuelb1angle);

if rkinelbangle<=20
      lflag = 1;
end
if (rkinelbangle>=150) && lflag
    l=l+1;
    lflag =0;
    if l>=7
        lc = 0;
        clearvars l lflag
        break;
    end
end
               end
       if numBodies == 0
           figure(1)
           s1 = strcat('No persons in view');   
           text((1920/2) - 250,100,s1,'Color','red','FontSize',30,'FontWeight','bold');
           clearvars s1
       end      
       if numBodies > 1
           figure(1)
           s1 = strcat('Too many people in view');
           text(1920/2,100,s1,'Color','red','FontSize',30,'FontWeight','bold');
           clearvars s1
       end      
       if ~isempty(k)
        if strcmp(k,'q') 
            k=[];
            break; 
        end
       end
   end
     pause(0.001);
clearvars pos2Dxxx depth color validData depth8u depth8uc3 leftShoulder leftElbow leftWrist rightShoulder rightElbow rightWrist rightHand rightHandtip spineShoulder spineCenter spinebase hipRight hipLeft E1 E2 F1 F2 RH2 LH2 LSRS RSLS coronalnormalL coronalnormalR TrunkVector sagittalnormalL sagittalnormalR line data
clearvars limubdstr limuefstr limuelbstr lkinefstr lkinbdstr lkiniestr limuiestr lkinelbstr rimubdstr rimuefstr rimuelbstr rkinefstr rkinbdstr rkiniestr rimuiestr rkinelbstr rimuelb1str rkinelb1str limuelb1str lkinelb1str
if telapsed>=60
    break;
end
telapsed = telapsed+toc(tstart);
end
fclose(fid);                                                                                                                
clearvars fid lc file

%% Right elbow extension-flexion after abduction 'relb'

close figure 2     
file = sprintf('%s_WISE+KINECT_testing_%s_%s.txt',num2str(SUBJECTID),datestr(now,'mm-dd-yyyy HH-MM'),'right_elb_flex-ext-wabd');
fid = fopen(file,'wt');
fprintf( fid, '%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s\n','Timestamp','Kinect_LeftShoulder_Ext.-Flex.',...
'IMU_LeftShoulder_Ext.-Flex.','Kinect_LeftShoulder_Abd.-Add.','IMU_LeftShoulder_Abd.-Add.','Kinect_LeftShoulder_Int.-Ext.',...
'IMU_LeftShoulder_Int.-Ext.','Kinect_LeftElbow_Ext.-Flex.','IMU_LeftElbow_Ext.-Flex.','IMU_LeftElbow_Pro.-Sup.',...
'Kinect_RightShoulder_Ext.-Flex.','IMU_RightShoulder_Ext.-Flex.','Kinect_RightShoulder_Abd.-Add.','IMU_RightShoulder_Abd.-Add.',...
'Kinect_RightShoulder_Int.-Ext.','IMU_RightShoulder_Int.-Ext.','Kinect_RightElbow_Ext.-Flex.','IMU_RightElbow_Ext.-Flex.',...
'IMU_RightElbow_Pro.-Sup.');
figure(2)
hold on
title('Right elbow flexion-extension','FontWeight','bold','FontSize',font);
set( gcf, 'DoubleBuffer', 'on','keypress','k=get(gcf,''currentchar'');' );
xlabel('Time (seconds)','FontWeight','bold','FontSize',font);
ylabel('Joint angles (degrees)','FontWeight','bold','FontSize',font);
legend('Location','NorthWest','FontWeight','bold','FontSize',font);
axes1 = gca;axes2  = gca;
anline = animatedline(axes1,'Color','r','DisplayName','KINECT');
anline1 = animatedline(axes2,'Color','b','DisplayName','IMU');
hold off
k=[];telapsed = 0;lflag = 0;l = 0;lc = 1;
[~,~] = system('F:\unityrecordings\rightelbowflexext1.mp4');
flushinput(ser);
while (lc) 
   tstart = tic;
   validData = k2.updateData;
   if validData
       depth = k2.getDepth;color = k2.getColor;face = k2.getFaces;
       depth8u = uint8(depth*(255/outOfRange));depth8uc3 = repmat(depth8u,[1 1 3]);
       figure(1)
        color = imresize(color,COL_SCALE);c.im = imshow(color, 'Parent', c.ax);
        rectangle('Position',[0 0 475 1080],'LineWidth',3,'FaceColor','k');  
        rectangle('Position',[1350 0 620 1080],'LineWidth',3,'FaceColor','k');
        [bodies, fcp, timeStamp] = k2.getBodies('Quat');
        numBodies = size(bodies,2);
               if numBodies == 1
                    pos2Dxxx = bodies(1).Position;                                                              % All 25 joints positions are stored to the variable pos2Dxxx.  
                    [lkinefangle,rkinefangle,lkinbdangle,rkinbdangle,lkinieangle,rkinieangle,lkinelbangle,rkinelbangle] = get_Kinect(pos2Dxxx);

                                                                                                                %arduino section
    if ser.BytesAvailable
        line = fscanf(ser);                                                                                         % get data if there exists data in the next line
        data = strsplit(string(line),',');
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
                qA = qconvert(data);qA = fix_imu('a',qA,Offsets);
                lwriangle = getleftwrist(qC,qA);limuelbangle = lwriangle(1);limuelb1angle = lwriangle(2);
                case 'c'
                qC = qconvert(data);qC = fix_imu('c',qC,Offsets);
                lshoangle = getleftarm(qE,qC);lwriangle = getleftwrist(qC,qA);
                limuieangle = lshoangle(3);limubdangle = lshoangle(2);limuefangle = lshoangle(1); 
                limuelbangle = lwriangle(1);limuelb1angle = lwriangle(2);
                case 'd'
                qD = qconvert(data);qD = fix_imu('d',qD,Offsets);
                rshoangle = getrightarm(qE,qD);rwriangle = getrightwrist(qD,qB);
                rimuieangle = rshoangle(3);rimubdangle = rshoangle(2);rimuefangle = rshoangle(1);
                rimuelbangle = rwriangle(1);rimuelb1angle = rwriangle(2);
                case 'b'
                qB = qconvert(data);qB = fix_imu('b',qB,Offsets);
                rwriangle = getleftwrist(qD,qB);
                rimuelbangle = rwriangle(1);rimuelb1angle = rwriangle(2);     
            end 
        end
    end
k2.drawBodies(c.ax,bodies,'color',3,2,1);k2.drawFaces(c.ax,face,5,false,20);

updateWiseKinect('relb',rkinelbangle,rimuelbangle,telapsed,anline,anline1)

                    %'Timestamp','Kinect_LeftShoulder_Ext.-Flex.','IMU_LeftShoulder_Ext.-Flex.','Kinect_LeftShoulder_Abd.-Add.','IMU_
                    % LeftShoulder_Abd.-Add.','Kinect_LeftShoulder_Int.-Ext.','IMU_LeftShoulder_Int.-Ext.','Kinect_LeftElbow_Ext.-Flex.','IMU_LeftElbow_Ext.-Flex.',
                    % 'IMU_LeftElbow_Pro.-Sup.','Kinect_RightShoulder_Ext.-Flex.','IMU_RightShoulder_Ext.-Flex.','Kinect_RightShoulder_Abd.-Add.','IMU_RightShoulder_Abd.-Add.','Kinect_RightShoulder_Int.-Ext.','IMU_RightShoulder_Int.-Ext.','Kinect_RightElbow_Ext.-Flex.','IMU_RightElbow_Ext.-Flex.','IMU_RightElbow_Pro.-Sup.');
fprintf( fid, '%.2f,%.2f,%.2f,%.2f,%.2f,%.2f,%.2f,%.2f,%.2f,%.2f,%.2f,%.2f,%.2f,%.2f,%.2f,%.2f,%.2f,%.2f,%.2f\n',telapsed,...
lkinefangle,limuefangle,lkinbdangle,limubdangle,lkinieangle,limuieangle,lkinelbangle,limuelbangle,limuelb1angle,rkinefangle,rimuefangle,...
rkinbdangle,rimubdangle,rkinieangle,rimuieangle,rkinelbangle,rimuelbangle,rimuelb1angle);

if rkinelbangle<=20
      lflag = 1;
end
if (rkinelbangle>=150) && lflag
    l=l+1;
    lflag =0;
    if l>=7
        lc = 0;
        clearvars l lflag
        break;
    end
end
               end
       if numBodies == 0
           figure(1)
           s1 = strcat('No persons in view');   
           text((1920/2) - 250,100,s1,'Color','red','FontSize',30,'FontWeight','bold');
           clearvars s1
       end      
       if numBodies > 1
           figure(1)
           s1 = strcat('Too many people in view');
           text(1920/2,100,s1,'Color','red','FontSize',30,'FontWeight','bold');
           clearvars s1
       end      
       if ~isempty(k)
        if strcmp(k,'q') 
            k=[];
            break; 
        end
       end
   end
     pause(0.001);
clearvars pos2Dxxx depth color validData depth8u depth8uc3 leftShoulder leftElbow leftWrist rightShoulder rightElbow rightWrist rightHand rightHandtip spineShoulder spineCenter spinebase hipRight hipLeft E1 E2 F1 F2 RH2 LH2 LSRS RSLS coronalnormalL coronalnormalR TrunkVector sagittalnormalL sagittalnormalR line data
clearvars limubdstr limuefstr limuelbstr lkinefstr lkinbdstr lkiniestr limuiestr lkinelbstr rimubdstr rimuefstr rimuelbstr rkinefstr rkinbdstr rkiniestr rimuiestr rkinelbstr rimuelb1str rkinelb1str limuelb1str lkinelb1str

if telapsed>=60
    break;
end

telapsed = telapsed+toc(tstart);
end
fclose(fid);
clearvars fid lc file

%% Right forearm pronation supination 'rps'

close figure 2     
file = sprintf('%s_WISE+KINECT_testing_%s_%s.txt',num2str(SUBJECTID),datestr(now,'mm-dd-yyyy HH-MM'),'right_forearm_pro-sup');
fid = fopen(file,'wt');
fprintf( fid, '%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s\n','Timestamp','Kinect_LeftShoulder_Ext.-Flex.',...
'IMU_LeftShoulder_Ext.-Flex.','Kinect_LeftShoulder_Abd.-Add.','IMU_LeftShoulder_Abd.-Add.','Kinect_LeftShoulder_Int.-Ext.',...
'IMU_LeftShoulder_Int.-Ext.','Kinect_LeftElbow_Ext.-Flex.','IMU_LeftElbow_Ext.-Flex.','IMU_LeftElbow_Pro.-Sup.',...
'Kinect_RightShoulder_Ext.-Flex.','IMU_RightShoulder_Ext.-Flex.','Kinect_RightShoulder_Abd.-Add.','IMU_RightShoulder_Abd.-Add.',...
'Kinect_RightShoulder_Int.-Ext.','IMU_RightShoulder_Int.-Ext.','Kinect_RightElbow_Ext.-Flex.','IMU_RightElbow_Ext.-Flex.',...
'IMU_RightElbow_Pro.-Sup.');
figure(2)
hold on
title('Right elbow pronation-supination','FontWeight','bold','FontSize',font);
set( gcf, 'DoubleBuffer', 'on','keypress','k=get(gcf,''currentchar'');' );
xlabel('Time (seconds)','FontWeight','bold','FontSize',font);
ylabel('Joint angles (degrees)','FontWeight','bold','FontSize',font);
legend('Location','NorthWest','FontWeight','bold','FontSize',font);
axes1 = gca;axes2  = gca;
anline = animatedline(axes1,'Color','r','DisplayName','KINECT');
anline1 = animatedline(axes2,'Color','b','DisplayName','IMU');
hold off
k=[];telapsed = 0;lflag = 0;l = 0;lc = 1;
[~,~] = system('F:\unityrecordings\rightprosup.mp4');
flushinput(ser);
while (lc) 
   tstart = tic;
   validData = k2.updateData;
   if validData
       depth = k2.getDepth;color = k2.getColor;face = k2.getFaces;
       depth8u = uint8(depth*(255/outOfRange));depth8uc3 = repmat(depth8u,[1 1 3]);
       figure(1)
        color = imresize(color,COL_SCALE);c.im = imshow(color, 'Parent', c.ax);
        rectangle('Position',[0 0 475 1080],'LineWidth',3,'FaceColor','k');  
        rectangle('Position',[1350 0 620 1080],'LineWidth',3,'FaceColor','k');
        [bodies, fcp, timeStamp] = k2.getBodies('Quat');
        numBodies = size(bodies,2);
               if numBodies == 1
                    pos2Dxxx = bodies(1).Position;                                                              % All 25 joints positions are stored to the variable pos2Dxxx.  
                    [lkinefangle,rkinefangle,lkinbdangle,rkinbdangle,lkinieangle,rkinieangle,lkinelbangle,rkinelbangle] = get_Kinect(pos2Dxxx);

                                                                                                                %arduino section
    if ser.BytesAvailable
        line = fscanf(ser);                                                                                         % get data if there exists data in the next line
        data = strsplit(string(line),',');
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
                qA = qconvert(data);qA = fix_imu('a',qA,Offsets);
                lwriangle = getleftwrist(qC,qA);limuelbangle = lwriangle(1);limuelb1angle = lwriangle(2);
                case 'c'
                qC = qconvert(data);qC = fix_imu('c',qC,Offsets);
                lshoangle = getleftarm(qE,qC);lwriangle = getleftwrist(qC,qA);
                limuieangle = lshoangle(3);limubdangle = lshoangle(2);limuefangle = lshoangle(1); 
                limuelbangle = lwriangle(1);limuelb1angle = lwriangle(2);
                case 'd'
                qD = qconvert(data);qD = fix_imu('d',qD,Offsets);
                rshoangle = getrightarm(qE,qD);rwriangle = getrightwrist(qD,qB);
                rimuieangle = rshoangle(3);rimubdangle = rshoangle(2);rimuefangle = rshoangle(1);
                rimuelbangle = rwriangle(1);rimuelb1angle = rwriangle(2);
                case 'b'
                qB = qconvert(data);qB = fix_imu('b',qB,Offsets);
                rwriangle = getleftwrist(qD,qB);
                rimuelbangle = rwriangle(1);rimuelb1angle = rwriangle(2);     
            end 
        end
    end
k2.drawBodies(c.ax,bodies,'color',3,2,1);k2.drawFaces(c.ax,face,5,false,20);

updateWiseKinect('rps',rkinelb1angle,rimuelb1angle,telapsed,anline,anline1)

                    %'Timestamp','Kinect_LeftShoulder_Ext.-Flex.','IMU_LeftShoulder_Ext.-Flex.','Kinect_LeftShoulder_Abd.-Add.','IMU_
                    % LeftShoulder_Abd.-Add.','Kinect_LeftShoulder_Int.-Ext.','IMU_LeftShoulder_Int.-Ext.','Kinect_LeftElbow_Ext.-Flex.','IMU_LeftElbow_Ext.-Flex.',
                    % 'IMU_LeftElbow_Pro.-Sup.','Kinect_RightShoulder_Ext.-Flex.','IMU_RightShoulder_Ext.-Flex.','Kinect_RightShoulder_Abd.-Add.','IMU_RightShoulder_Abd.-Add.','Kinect_RightShoulder_Int.-Ext.','IMU_RightShoulder_Int.-Ext.','Kinect_RightElbow_Ext.-Flex.','IMU_RightElbow_Ext.-Flex.','IMU_RightElbow_Pro.-Sup.');
fprintf( fid, '%.2f,%.2f,%.2f,%.2f,%.2f,%.2f,%.2f,%.2f,%.2f,%.2f,%.2f,%.2f,%.2f,%.2f,%.2f,%.2f,%.2f,%.2f,%.2f\n',telapsed,...
lkinefangle,limuefangle,lkinbdangle,limubdangle,lkinieangle,limuieangle,lkinelbangle,limuelbangle,limuelb1angle,rkinefangle,rimuefangle,...
rkinbdangle,rimubdangle,rkinieangle,rimuieangle,rkinelbangle,rimuelbangle,rimuelb1angle);

if rimuelb1angle<=-45
    lflag = 1;
end
if (rimuelb1angle>=45) && lflag
    l=l+1;
    lflag =0;
    if l>=7
        lc = 0;
        clearvars l lflag
        break;
    end
end
               end
       if numBodies == 0
           figure(1)
           s1 = strcat('No persons in view');   
           text((1920/2) - 250,100,s1,'Color','red','FontSize',30,'FontWeight','bold');
           clearvars s1
       end      
       if numBodies > 1
           figure(1)
           s1 = strcat('Too many people in view');
           text(1920/2,100,s1,'Color','red','FontSize',30,'FontWeight','bold');
           clearvars s1
       end      
       if ~isempty(k)
        if strcmp(k,'q') 
            k=[];
            break; 
        end
       end
   end
     pause(0.001);
clearvars pos2Dxxx depth color validData depth8u depth8uc3 leftShoulder leftElbow leftWrist rightShoulder rightElbow rightWrist rightHand rightHandtip spineShoulder spineCenter spinebase hipRight hipLeft E1 E2 F1 F2 RH2 LH2 LSRS RSLS coronalnormalL coronalnormalR TrunkVector sagittalnormalL sagittalnormalR line data
clearvars limubdstr limuefstr limuelbstr lkinefstr lkinbdstr lkiniestr limuiestr lkinelbstr rimubdstr rimuefstr rimuelbstr rkinefstr rkinbdstr rkiniestr rimuiestr rkinelbstr rimuelb1str rkinelb1str limuelb1str lkinelb1str

if telapsed>=60
    break;
end

telapsed = telapsed+toc(tstart);
end
fclose(fid);
clearvars fid lc file


%% Right shoulder internal-external rotation with flexed elbow 'rie'

close figure 2     
file = sprintf('%s_WISE+KINECT_testing_%s_%s.txt',num2str(SUBJECTID),datestr(now,'mm-dd-yyyy HH-MM'),'right_int-ext');
fid = fopen(file,'wt');
fprintf( fid, '%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s\n','Timestamp','Kinect_LeftShoulder_Ext.-Flex.',...
'IMU_LeftShoulder_Ext.-Flex.','Kinect_LeftShoulder_Abd.-Add.','IMU_LeftShoulder_Abd.-Add.','Kinect_LeftShoulder_Int.-Ext.',...
'IMU_LeftShoulder_Int.-Ext.','Kinect_LeftElbow_Ext.-Flex.','IMU_LeftElbow_Ext.-Flex.','IMU_LeftElbow_Pro.-Sup.',...
'Kinect_RightShoulder_Ext.-Flex.','IMU_RightShoulder_Ext.-Flex.','Kinect_RightShoulder_Abd.-Add.','IMU_RightShoulder_Abd.-Add.',...
'Kinect_RightShoulder_Int.-Ext.','IMU_RightShoulder_Int.-Ext.','Kinect_RightElbow_Ext.-Flex.','IMU_RightElbow_Ext.-Flex.',...
'IMU_RightElbow_Pro.-Sup.');
figure(2)
hold on
title('Right shoulder internal-external rotation','FontWeight','bold','FontSize',font);
set( gcf, 'DoubleBuffer', 'on','keypress','k=get(gcf,''currentchar'');' );
xlabel('Time (seconds)','FontWeight','bold','FontSize',font);
ylabel('Joint angles (degrees)','FontWeight','bold','FontSize',font);
legend('Location','NorthWest','FontWeight','bold','FontSize',font);
axes1 = gca;axes2  = gca;
anline = animatedline(axes1,'Color','r','DisplayName','KINECT');
anline1 = animatedline(axes2,'Color','b','DisplayName','IMU');
hold off
k=[];telapsed = 0;lflag = 0;l = 0;lc = 1;
[~,~] = system('F:\unityrecordings\rightintext.mp4');
flushinput(ser);
while (lc) 
   tstart = tic;
   validData = k2.updateData;
   if validData
       depth = k2.getDepth;color = k2.getColor;face = k2.getFaces;
       depth8u = uint8(depth*(255/outOfRange));depth8uc3 = repmat(depth8u,[1 1 3]);
       figure(1)
        color = imresize(color,COL_SCALE);c.im = imshow(color, 'Parent', c.ax);
        rectangle('Position',[0 0 475 1080],'LineWidth',3,'FaceColor','k');  
        rectangle('Position',[1350 0 620 1080],'LineWidth',3,'FaceColor','k');
        [bodies, fcp, timeStamp] = k2.getBodies('Quat');
        numBodies = size(bodies,2);
               if numBodies == 1
                    pos2Dxxx = bodies(1).Position;                                                              % All 25 joints positions are stored to the variable pos2Dxxx.  
                    [lkinefangle,rkinefangle,lkinbdangle,rkinbdangle,lkinieangle,rkinieangle,lkinelbangle,rkinelbangle] = get_Kinect(pos2Dxxx);

                                                                                                                %arduino section
    if ser.BytesAvailable
        line = fscanf(ser);                                                                                         % get data if there exists data in the next line
        data = strsplit(string(line),',');
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
                qA = qconvert(data);qA = fix_imu('a',qA,Offsets);
                lwriangle = getleftwrist(qC,qA);limuelbangle = lwriangle(1);limuelb1angle = lwriangle(2);
                case 'c'
                qC = qconvert(data);qC = fix_imu('c',qC,Offsets);
                lshoangle = getleftarm(qE,qC);lwriangle = getleftwrist(qC,qA);
                limuieangle = lshoangle(3);limubdangle = lshoangle(2);limuefangle = lshoangle(1); 
                limuelbangle = lwriangle(1);limuelb1angle = lwriangle(2);
                case 'd'
                qD = qconvert(data);qD = fix_imu('d',qD,Offsets);
                rshoangle = getrightarm(qE,qD);rwriangle = getrightwrist(qD,qB);
                rimuieangle = rshoangle(3);rimubdangle = rshoangle(2);rimuefangle = rshoangle(1);
                rimuelbangle = rwriangle(1);rimuelb1angle = rwriangle(2);
                case 'b'
                qB = qconvert(data);qB = fix_imu('b',qB,Offsets);
                rwriangle = getleftwrist(qD,qB);
                rimuelbangle = rwriangle(1);rimuelb1angle = rwriangle(2);     
            end 
        end
    end
k2.drawBodies(c.ax,bodies,'color',3,2,1);k2.drawFaces(c.ax,face,5,false,20);

updateWiseKinect('rie',rkinieangle,rimuieangle,telapsed,anline,anline1)

                    %'Timestamp','Kinect_LeftShoulder_Ext.-Flex.','IMU_LeftShoulder_Ext.-Flex.','Kinect_LeftShoulder_Abd.-Add.','IMU_
                    % LeftShoulder_Abd.-Add.','Kinect_LeftShoulder_Int.-Ext.','IMU_LeftShoulder_Int.-Ext.','Kinect_LeftElbow_Ext.-Flex.','IMU_LeftElbow_Ext.-Flex.',
                    % 'IMU_LeftElbow_Pro.-Sup.','Kinect_RightShoulder_Ext.-Flex.','IMU_RightShoulder_Ext.-Flex.','Kinect_RightShoulder_Abd.-Add.','IMU_RightShoulder_Abd.-Add.','Kinect_RightShoulder_Int.-Ext.','IMU_RightShoulder_Int.-Ext.','Kinect_RightElbow_Ext.-Flex.','IMU_RightElbow_Ext.-Flex.','IMU_RightElbow_Pro.-Sup.');
fprintf( fid, '%.2f,%.2f,%.2f,%.2f,%.2f,%.2f,%.2f,%.2f,%.2f,%.2f,%.2f,%.2f,%.2f,%.2f,%.2f,%.2f,%.2f,%.2f,%.2f\n',telapsed,...
lkinefangle,limuefangle,lkinbdangle,limubdangle,lkinieangle,limuieangle,lkinelbangle,limuelbangle,limuelb1angle,rkinefangle,rimuefangle,...
rkinbdangle,rimubdangle,rkinieangle,rimuieangle,rkinelbangle,rimuelbangle,rimuelb1angle);

if rkinieangle<=-45
    lflag = 1;
end
if (rkinieangle>=45) && lflag
    l=l+1;
    lflag =0;
    if l>=7
        lc = 0;
        clearvars l lflag
        break;
    end
end
               end
       if numBodies == 0
           figure(1)
           s1 = strcat('No persons in view');   
           text((1920/2) - 250,100,s1,'Color','red','FontSize',30,'FontWeight','bold');
           clearvars s1
       end      
       if numBodies > 1
           figure(1)
           s1 = strcat('Too many people in view');
           text(1920/2,100,s1,'Color','red','FontSize',30,'FontWeight','bold');
           clearvars s1
       end      
       if ~isempty(k)
        if strcmp(k,'q') 
            k=[];
            break; 
        end
       end
   end
     pause(0.001);
clearvars pos2Dxxx depth color validData depth8u depth8uc3 leftShoulder leftElbow leftWrist rightShoulder rightElbow rightWrist rightHand rightHandtip spineShoulder spineCenter spinebase hipRight hipLeft E1 E2 F1 F2 RH2 LH2 LSRS RSLS coronalnormalL coronalnormalR TrunkVector sagittalnormalL sagittalnormalR line data
clearvars limubdstr limuefstr limuelbstr lkinefstr lkinbdstr lkiniestr limuiestr lkinelbstr rimubdstr rimuefstr rimuelbstr rkinefstr rkinbdstr rkiniestr rimuiestr rkinelbstr rimuelb1str rkinelb1str limuelb1str lkinelb1str

if telapsed>=60
    break;
end

telapsed = telapsed+toc(tstart);
end
fclose(fid);
clearvars fid lc file

%% Right shoulder internal-external rotation with abducted arm 'rie'

close figure 2     
file = sprintf('%s_WISE+KINECT_testing_%s_%s.txt',num2str(SUBJECTID),datestr(now,'mm-dd-yyyy HH-MM'),'right_int-ext_wabd');
fid = fopen(file,'wt');
fprintf( fid, '%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s\n','Timestamp','Kinect_LeftShoulder_Ext.-Flex.',...
'IMU_LeftShoulder_Ext.-Flex.','Kinect_LeftShoulder_Abd.-Add.','IMU_LeftShoulder_Abd.-Add.','Kinect_LeftShoulder_Int.-Ext.',...
'IMU_LeftShoulder_Int.-Ext.','Kinect_LeftElbow_Ext.-Flex.','IMU_LeftElbow_Ext.-Flex.','IMU_LeftElbow_Pro.-Sup.',...
'Kinect_RightShoulder_Ext.-Flex.','IMU_RightShoulder_Ext.-Flex.','Kinect_RightShoulder_Abd.-Add.','IMU_RightShoulder_Abd.-Add.',...
'Kinect_RightShoulder_Int.-Ext.','IMU_RightShoulder_Int.-Ext.','Kinect_RightElbow_Ext.-Flex.','IMU_RightElbow_Ext.-Flex.',...
'IMU_RightElbow_Pro.-Sup.');
figure(2)
hold on
title('Right shoulder internal-external rotation','FontWeight','bold','FontSize',font);
set( gcf, 'DoubleBuffer', 'on','keypress','k=get(gcf,''currentchar'');' );
xlabel('Time (seconds)','FontWeight','bold','FontSize',font);
ylabel('Joint angles (degrees)','FontWeight','bold','FontSize',font);
legend('Location','NorthWest','FontWeight','bold','FontSize',font);
axes1 = gca;axes2  = gca;
anline = animatedline(axes1,'Color','r','DisplayName','KINECT');
anline1 = animatedline(axes2,'Color','b','DisplayName','IMU');
hold off
k=[];telapsed = 0;lflag = 0;l = 0;lc = 1;
[~,~] = system('F:\unityrecordings\rightintext1.mp4');
flushinput(ser);
while (lc) 
   tstart = tic;
   validData = k2.updateData;
   if validData
       depth = k2.getDepth;color = k2.getColor;face = k2.getFaces;
       depth8u = uint8(depth*(255/outOfRange));depth8uc3 = repmat(depth8u,[1 1 3]);
       figure(1)
        color = imresize(color,COL_SCALE);c.im = imshow(color, 'Parent', c.ax);
        rectangle('Position',[0 0 475 1080],'LineWidth',3,'FaceColor','k');  
        rectangle('Position',[1350 0 620 1080],'LineWidth',3,'FaceColor','k');
        [bodies, fcp, timeStamp] = k2.getBodies('Quat');
        numBodies = size(bodies,2);
               if numBodies == 1
                    pos2Dxxx = bodies(1).Position;                                                              % All 25 joints positions are stored to the variable pos2Dxxx.  
                    [lkinefangle,rkinefangle,lkinbdangle,rkinbdangle,lkinieangle,rkinieangle,lkinelbangle,rkinelbangle] = get_Kinect(pos2Dxxx);

                                                                                                                %arduino section
    if ser.BytesAvailable
        line = fscanf(ser);                                                                                         % get data if there exists data in the next line
        data = strsplit(string(line),',');
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
                qA = qconvert(data);qA = fix_imu('a',qA,Offsets);
                lwriangle = getleftwrist(qC,qA);limuelbangle = lwriangle(1);limuelb1angle = lwriangle(2);
                case 'c'
                qC = qconvert(data);qC = fix_imu('c',qC,Offsets);
                lshoangle = getleftarm(qE,qC);lwriangle = getleftwrist(qC,qA);
                limuieangle = lshoangle(3);limubdangle = lshoangle(2);limuefangle = lshoangle(1); 
                limuelbangle = lwriangle(1);limuelb1angle = lwriangle(2);
                case 'd'
                qD = qconvert(data);qD = fix_imu('d',qD,Offsets);
                rshoangle = getrightarm(qE,qD);rwriangle = getrightwrist(qD,qB);
                rimuieangle = rshoangle(3);rimubdangle = rshoangle(2);rimuefangle = rshoangle(1);
                rimuelbangle = rwriangle(1);rimuelb1angle = rwriangle(2);
                case 'b'
                qB = qconvert(data);qB = fix_imu('b',qB,Offsets);
                rwriangle = getleftwrist(qD,qB);
                rimuelbangle = rwriangle(1);rimuelb1angle = rwriangle(2);     
            end 
        end
    end
k2.drawBodies(c.ax,bodies,'color',3,2,1);k2.drawFaces(c.ax,face,5,false,20);

updateWiseKinect('rie',rkinieangle,rimuieangle,telapsed,anline,anline1)

                    %'Timestamp','Kinect_LeftShoulder_Ext.-Flex.','IMU_LeftShoulder_Ext.-Flex.','Kinect_LeftShoulder_Abd.-Add.','IMU_
                    % LeftShoulder_Abd.-Add.','Kinect_LeftShoulder_Int.-Ext.','IMU_LeftShoulder_Int.-Ext.','Kinect_LeftElbow_Ext.-Flex.','IMU_LeftElbow_Ext.-Flex.',
                    % 'IMU_LeftElbow_Pro.-Sup.','Kinect_RightShoulder_Ext.-Flex.','IMU_RightShoulder_Ext.-Flex.','Kinect_RightShoulder_Abd.-Add.','IMU_RightShoulder_Abd.-Add.','Kinect_RightShoulder_Int.-Ext.','IMU_RightShoulder_Int.-Ext.','Kinect_RightElbow_Ext.-Flex.','IMU_RightElbow_Ext.-Flex.','IMU_RightElbow_Pro.-Sup.');
fprintf( fid, '%.2f,%.2f,%.2f,%.2f,%.2f,%.2f,%.2f,%.2f,%.2f,%.2f,%.2f,%.2f,%.2f,%.2f,%.2f,%.2f,%.2f,%.2f,%.2f\n',telapsed,...
lkinefangle,limuefangle,lkinbdangle,limubdangle,lkinieangle,limuieangle,lkinelbangle,limuelbangle,limuelb1angle,rkinefangle,rimuefangle,...
rkinbdangle,rimubdangle,rkinieangle,rimuieangle,rkinelbangle,rimuelbangle,rimuelb1angle);

if rimuieangle<=-45
      lflag = 1;
end
if (rimuieangle>=45) && lflag
    l=l+1;
    lflag =0;
    if l>=7
        lc = 0;
        clearvars l lflag
        break;
    end
end
               end
       if numBodies == 0
           figure(1)
           s1 = strcat('No persons in view');   
           text((1920/2) - 250,100,s1,'Color','red','FontSize',30,'FontWeight','bold');
           clearvars s1
       end      
       if numBodies > 1
           figure(1)
           s1 = strcat('Too many people in view');
           text(1920/2,100,s1,'Color','red','FontSize',30,'FontWeight','bold');
           clearvars s1
       end      
       if ~isempty(k)
        if strcmp(k,'q') 
            k=[];
            break; 
        end
       end
   end
     pause(0.001);
clearvars pos2Dxxx depth color validData depth8u depth8uc3 leftShoulder leftElbow leftWrist rightShoulder rightElbow rightWrist rightHand rightHandtip spineShoulder spineCenter spinebase hipRight hipLeft E1 E2 F1 F2 RH2 LH2 LSRS RSLS coronalnormalL coronalnormalR TrunkVector sagittalnormalL sagittalnormalR line data
clearvars limubdstr limuefstr limuelbstr lkinefstr lkinbdstr lkiniestr limuiestr lkinelbstr rimubdstr rimuefstr rimuelbstr rkinefstr rkinbdstr rkiniestr rimuiestr rkinelbstr rimuelb1str rkinelb1str limuelb1str lkinelb1str

if telapsed>=60
    break;
end

telapsed = telapsed+toc(tstart);
end
fclose(fid);
clearvars fid lc file

%% Closing everything 
fclose(ser)
delete(ser)
close all;clear all;
delete(instrfind({'Port'},{'COM15'}))