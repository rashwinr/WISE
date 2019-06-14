%% Initialization section
delete(instrfind({'Port'},{'COM15'}))
clear all; close all;clc;
markers = ["lef","lbd","lelb","lelb1","lps","lie","lie1","ref","rbd","relb","relb1","rps","rie","rie1"];

SUBJECTID = 1234;

flg = 1;

if flg 
    Offsets = [0.8589,0.0411,-0.0170,-0.5101; 1.0000,0,0,0; -0.8954,0.0070,0.0010,0.4452; -0.9749,0.0070,-0.0250,0.2210; 0.9791,-0.0371,-0.0170,-0.1994];
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
fopen(ser);k=[];

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

%%  Complete routine for updating data with 14 different angles
for i=1:14
arg = char(markers(i));    
[anline,anline1,fid] = TitleUpdate(arg,SUBJECTID);
lc=1;l=0;lflag = 0;telapsed=0;
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
           pos2Dxxx = bodies(1).Position; 
           [lkinefangle,rkinefangle,lkinbdangle,rkinbdangle,lkinieangle,rkinieangle,lkinelbangle,rkinelbangle] = get_Kinect(pos2Dxxx);
           k2.drawBodies(c.ax,bodies,'color',3,2,1);k2.drawFaces(c.ax,face,5,false,20);
           switch arg
                case 'lef'
                    kin = lkinefangle; imu = limuefangle;
                    lim = kin;
                    tlow = 10; thigh=150;
                case 'lbd'
                    kin = lkinbdangle; imu = limubdangle;
                    lim = kin;
                    tlow = 20; thigh=150;
                case 'lelb'
                    kin = lkinelbangle; imu = limuelbangle;
                    lim = kin;
                    tlow = 20; thigh=130;
                case 'lelb1'
                    kin = lkinelbangle; imu = limuelbangle;
                    lim = kin;
                    tlow = 20; thigh=130;
                case 'lps'
                    kin = lkinelb1angle; imu = limuelb1angle;
                    lim = imu;
                    tlow = -45; thigh=45;
                case 'lie'
                    kin = lkinieangle; imu = limuieangle;
                    lim = imu;
                    tlow = -40; thigh=40;
                case 'lie1' 
                    kin = lkinieangle; imu = limuieangle;
                    lim = imu;
                    tlow = -40; thigh=40;
                case 'ref'
                    kin = rkinefangle; imu = rimuefangle;
                    lim = kin;
                    tlow = 10; thigh=150;
                case 'rbd'
                    kin = rkinbdangle; imu = rimubdangle;
                    lim = kin;
                    tlow = 20; thigh=150;
                case 'relb'
                    kin = rkinelbangle; imu = rimuelbangle;
                    lim = kin;
                    tlow = 20; thigh=130;
                case 'relb1'
                    kin = rkinelbangle; imu = rimuelbangle;
                    lim = kin;
                    tlow = 20; thigh=130;
                case 'rps'
                    kin = rkinelb1angle; imu = rimuelb1angle;
                    lim = imu;
                    tlow = -45; thigh=45;
                case 'rie'
                    kin = rkinelb1angle; imu = rimuelb1angle;
                    lim = imu;
                    tlow = -40; thigh=40;
                case  'rie1'
                    kin = rkinieangle; imu = rimuieangle;
                    lim = imu;
                    tlow = -40; thigh=40;
           end
           updateWiseKinect(arg,kin,imu,telapsed,anline,anline1)
           %'Timestamp','Kinect_LeftShoulder_Ext.-Flex.','IMU_LeftShoulder_Ext.-Flex.','Kinect_LeftShoulder_Abd.-Add.','IMU_
           % LeftShoulder_Abd.-Add.','Kinect_LeftShoulder_Int.-Ext.','IMU_LeftShoulder_Int.-Ext.','Kinect_LeftElbow_Ext.-Flex.','IMU_LeftElbow_Ext.-Flex.',
           % 'IMU_LeftElbow_Pro.-Sup.','Kinect_RightShoulder_Ext.-Flex.','IMU_RightShoulder_Ext.-Flex.','Kinect_RightShoulder_Abd.-Add.','IMU_RightShoulder_Abd.-Add.',
           %'Kinect_RightShoulder_Int.-Ext.','IMU_RightShoulder_Int.-Ext.','Kinect_RightElbow_Ext.-Flex.','IMU_RightElbow_Ext.-Flex.','IMU_RightElbow_Pro.-Sup.');
           fprintf( fid, '%.2f,%.2f,%.2f,%.2f,%.2f,%.2f,%.2f,%.2f,%.2f,%.2f,%.2f,%.2f,%.2f,%.2f,%.2f,%.2f,%.2f,%.2f,%.2f\n',telapsed,...
           lkinefangle,limuefangle,lkinbdangle,limubdangle,lkinieangle,limuieangle,lkinelbangle,limuelbangle,limuelb1angle,rkinefangle,rimuefangle,...
           rkinbdangle,rimubdangle,rkinieangle,rimuieangle,rkinelbangle,rimuelbangle,rimuelb1angle);
       
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
fclose(ser)
delete(ser)
close all;clear all;
delete(instrfind({'Port'},{'COM15'}))
