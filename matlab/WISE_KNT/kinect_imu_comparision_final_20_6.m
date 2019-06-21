%% Initialization section
delete(instrfind({'Port'},{'COM15'}))
clear all; close all;clc;
markers = ["lef","lbd","lelb","lelb1","lps","lie","lie1","ref","rbd","relb","relb1","rps","rie","rie1"];

SUBJECTID = 1234;

flg = 1;

if flg 
    Offsets = [-0.6067    0.0090   -0.0170   -0.7947;
                0.3736   -0.0391   -0.0270    0.9264;
               -0.5604   -0.0090   -0.0050   -0.8281;
               -0.7054    0.0630   -0.0270   -0.7054;
               -0.7886    0.0470    0.0210   -0.6127];
end
       
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
qC = [1,0,0,0];qD = [1,0,0,0];qA = [1,0,0,0];qB = [1,0,0,0];qE = [1,0,0,0];
Cal_A = [0 0 0 0];Cal_B = [0 0 0 0];Cal_C = [0 0 0 0];Cal_D = [0 0 0 0];Cal_E = [0 0 0 0];
limuef = 0;rimuef = 0;lkinef = 0;rkinef = 0;
limubd = 0;rimubd = 0;lkinbdangle = 0;rkinbd = 0;
limuie = 0;rimuie = 10;lkinie = 0;rkinie = 0;
limuelb = 0;rimuelb = 0;lkinelb = 0;rkinelb = 0;
limuelb1 = 0;rimuelb1 = 0;lkinelb1 = 0;rkinelb1 = 0;
xlimuef = 0;xrimuef = 0;xlkinef = 0;xrkinef = 0;
xlimubd = 0;xrimubd = 0;xlkinbd = 0;xrkinbd = 0;
xlimuie = 0;xrimuie = 10;xlkinie = 0;xrkinie = 0;
xlimuelb = 0;xrimuelb = 0;xlkinelb = 0;xrkinelb = 0;
xlimuelb1 = 0;xrimuelb1 = 0;xlkinelb1 = 0;xrkinelb1 = 0;

ls = 0;rs = 1350;lw = 475;H = 1080;rw = 570;     %rectangle coordinates
%COM Port details
delete(instrfind({'Port'},{'COM15'}))
ser = serial('COM15','BaudRate',115200,'InputBufferSize',100);
ser.ReadAsyncMode = 'continuous';
fopen(ser);k=[];


%%  Complete routine for updating data with 14 different angles
for i=1:14
arg = char(markers(i));    
[anline,anline1,fid] = TitleUpdate(arg,SUBJECTID);
lc=1;l=0;lflag = 0;telapsed=0;
while (lc) 
   tstart = tic;
   if ser.BytesAvailable
       [qA,qB,qC,qD,qE] = DataReceive(ser,qA,qB,qC,qD,qE);
       qE = match_frame('e',qE);
       qA = match_frame('a',qA);
       qC = match_frame('c',qC);
       qD = match_frame('d',qD);
       qB = match_frame('b',qB); 

       
       lshoangle = get_Left_Arm(qE,qC);
       limuie = lshoangle(3);limubd = lshoangle(2);limuef = lshoangle(1); 
       
       rshoangle = get_Right_Arm(qE,qD);
       rimuie = rshoangle(3);rimubd = rshoangle(2);rimuef = rshoangle(1);
       
       lwriangle = get_Left_Wrist(qC,qA);
       limuelb = lwriangle(1);limuelb1 = lwriangle(2);
       
       rwriangle = get_Right_Wrist(qD,qB);
       rimuelb = rwriangle(1);rimuelb1 = rwriangle(2);
       
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
           pos2Dxxx = bodies(1).Position; 
           [lkinef,rkinef,lkinbdangle,rkinbd,lkinie,rkinie,lkinelb,rkinelb] = get_Kinect(pos2Dxxx);
           k2.drawBodies(c.ax,bodies,'color',3,2,1);k2.drawFaces(c.ax,face,5,false,20);
           switch arg
                case 'lef'
                    kin = lkinef; imu = limuef;
                    lim = kin;
                    tlow = 10; thigh=150;
                case 'lbd'
                    kin = lkinbdangle; imu = limubd;
                    lim = kin;
                    tlow = 20; thigh=150;
                case 'lelb'
                    kin = lkinelb; imu = limuelb;
                    lim = kin;
                    tlow = 20; thigh=130;
                case 'lelb1'
                    kin = lkinelb; imu = limuelb;
                    lim = kin;
                    tlow = 20; thigh=130;
                case 'lps'
                    kin = lkinelb1; imu = limuelb1;
                    lim = imu;
                    tlow = -45; thigh=45;
                case 'lie'
                    kin = lkinie; imu = limuie;
                    lim = imu;
                    tlow = -40; thigh=40;
                case 'lie1' 
                    kin = lkinie; imu = limuie;
                    lim = imu;
                    tlow = -40; thigh=40;
                case 'ref'
                    kin = rkinef; imu = rimuef;
                    lim = kin;
                    tlow = 10; thigh=150;
                case 'rbd'
                    kin = rkinbd; imu = rimubd;
                    lim = kin;
                    tlow = 20; thigh=150;
                case 'relb'
                    kin = rkinelb; imu = rimuelb;
                    lim = kin;
                    tlow = 20; thigh=130;
                case 'relb1'
                    kin = rkinelb; imu = rimuelb;
                    lim = kin;
                    tlow = 20; thigh=130;
                case 'rps'
                    kin = rkinelb1; imu = rimuelb1;
                    lim = imu;
                    tlow = -45; thigh=45;
                case 'rie'
                    kin = rkinelb1; imu = rimuelb1;
                    lim = imu;
                    tlow = -40; thigh=40;
                case  'rie1'
                    kin = rkinie; imu = rimuie;
                    lim = imu;
                    tlow = -40; thigh=40;
           end
           updateWiseKinect(arg,kin,imu,telapsed,anline,anline1)
           %'Timestamp','Kinect_LeftShoulder_Ext.-Flex.','IMU_LeftShoulder_Ext.-Flex.','Kinect_LeftShoulder_Abd.-Add.','IMU_
           % LeftShoulder_Abd.-Add.','Kinect_LeftShoulder_Int.-Ext.','IMU_LeftShoulder_Int.-Ext.','Kinect_LeftElbow_Ext.-Flex.','IMU_LeftElbow_Ext.-Flex.',
           % 'IMU_LeftElbow_Pro.-Sup.','Kinect_RightShoulder_Ext.-Flex.','IMU_RightShoulder_Ext.-Flex.','Kinect_RightShoulder_Abd.-Add.','IMU_RightShoulder_Abd.-Add.',
           %'Kinect_RightShoulder_Int.-Ext.','IMU_RightShoulder_Int.-Ext.','Kinect_RightElbow_Ext.-Flex.','IMU_RightElbow_Ext.-Flex.','IMU_RightElbow_Pro.-Sup.');
           fprintf( fid, '%.2f,%.2f,%.2f,%.2f,%.2f,%.2f,%.2f,%.2f,%.2f,%.2f,%.2f,%.2f,%.2f,%.2f,%.2f,%.2f,%.2f,%.2f,%.2f\n',telapsed,...
           lkinef,limuef,lkinbdangle,limubd,lkinie,limuie,lkinelb,limuelb,limuelb1,rkinef,rimuef,...
           rkinbd,rimubd,rkinie,rimuie,rkinelb,rimuelb,rimuelb1);
       
           if lim<=tlow
              lflag = 1;
           end
           if (lim>=thigh) && lflag
               l=l+1;
               lflag =0;
               if l>=8
                   lc = 0;
                   [~,~] = system('taskkill /F /IM Video.UI.exe');
                   break;
               end
           end
       end

       if numBodies == 0
           figure(1)
           s1 = strcat('No persons in view');   
           text((1920/2) - 250,100,s1,'Color','red','FontSize',30,'FontWeight','bold');
       end      
       if numBodies > 1
           figure(1)
           s1 = strcat('Too many people in view');
           text(1920/2,100,s1,'Color','red','FontSize',30,'FontWeight','bold');
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
disp(telapsed);
fclose(fid);

clf(figure(2),'reset')
end
%% Closing everything 

close figure 1 figure 2
fclose(ser);
delete(ser);
close all;clear all;
delete(instrfind({'Port'},{'COM15'}))

