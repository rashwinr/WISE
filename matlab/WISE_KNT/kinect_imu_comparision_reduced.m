%% Initialization section
clear all; close all;clc;
tp = 0.0;
prompt1 = 'Please enter the subject ID given for the user: ';
SUBJECTID = input(prompt1);
% SUBJECTID = 2900;

markers = ["lef","lbd","lelb","lelb1","lie","ref","rbd","relb","relb1","rie"];

%Kinect initialization script
addpath('F:\github\wearable-jacket\matlab\KInectProject\Kin2');
addpath('F:\github\wearable-jacket\matlab\KInectProject\Kin2\Mex');
addpath('F:\github\wearable-jacket\matlab\KInectProject');
addpath('F:\github\wearable-jacket\matlab\WISE_KNT');
k2 = Kin2('color','depth','body','face');
outOfRange = 4000;

sz1 = screensize(1);
c_width = sz1(3); c_height = sz1(4);COL_SCALE = 1;
color = zeros(c_height*COL_SCALE,c_width*COL_SCALE,3,'uint8');
c.h = figure('units', 'pixels', 'outerposition', sz1);
c.ax = axes;
color = imresize(color,COL_SCALE);
c.im = imshow(color, 'Parent', c.ax);

set( figure(1) , 'DoubleBuffer', 'on','keypress','k=get(gcf,''currentchar'');' );

%COM Port details
delete(instrfind({'Port'},{'COM15'}))
ser = serial('COM15','BaudRate',115200);
ser.ReadAsyncMode = 'continuous';
fopen(ser);k=[];


%% find and fix the wearing offsets


sts = 'F:\github\wearable-jacket\matlab\kinect+imudata\';
cd(sts);
if ~exist(num2str(SUBJECTID),'dir')
mkdir(num2str(SUBJECTID));
end
cd(strcat(sts,num2str(SUBJECTID),'\'));

clearvars sts;

f = sprintf('%s_WISE+KINECT_offset_%s.txt',num2str(SUBJECTID),datestr(now,'mm-dd-yyyy HH-MM'));
fwrite = fopen(f,'wt');
%Kinect rectangle coordinates
ls = 0;rs = 1350;lw = 475;H = 1080;rw = 570;     
%quaternion variables
qC = [1,0,0,0];qD = [1,0,0,0];qA = [1,0,0,0];qB = [1,0,0,0];qE = [1,0,0,0];
lshoangle = [0,0,0,0,0]';
rshoangle = [0,0,0,0,0]';


G = [0,0,-1];
qI = [0,1,0,0];
qJ = [0,0,1,0];
qK = [0,0,0,1];

qEg = [1,0,0,0];
qEl = [1,0,0,0];

font = 10;
sz2 = screensize(2);
figure('units', 'pixels', 'outerposition', sz2)
hold on
subplot(3,2,1)
xlabel('Sample number','FontWeight','bold','FontSize',font);
ylabel('Mounting offset angle (degrees)','FontWeight','bold','FontSize',font);
legend('Location','NorthWest','FontWeight','bold','FontSize',font);
axes = gca;
Moff_line = animatedline(axes,'Color','b','DisplayName','Back IMU mounting offset');

subplot(3,2,2)
xlabel('Sample number','FontWeight','bold','FontSize',font);
ylabel('Lumbar spine angle (degrees)','FontWeight','bold','FontSize',font);
legend('Location','NorthWest','FontWeight','bold','FontSize',font);
axes1 = gca;
LumbSpine_line = animatedline(axes1,'Color','b','DisplayName','Lumbar spine inclination');

subplot(3,2,3)
xlabel('Sample number','FontWeight','bold','FontSize',font);
ylabel('Left flex-ext offset (degrees)','FontWeight','bold','FontSize',font);
legend('Location','NorthWest','FontWeight','bold','FontSize',font);
axes2 = gca;
L_imu_extflex_line = animatedline(axes2,'Color','b','DisplayName','WISE left flex-ext offset');
L_knt_extflex_line = animatedline(axes2,'Color','r','DisplayName','KINECT left flex-ext offset');


subplot(3,2,4)
xlabel('Sample number','FontWeight','bold','FontSize',font);
ylabel('Left flex-ext offset (degrees)','FontWeight','bold','FontSize',font);
legend('Location','NorthWest','FontWeight','bold','FontSize',font);
axes3 = gca;
R_imu_extflex_line = animatedline(axes3,'Color','b','DisplayName','WISE right flex-ext offset');
R_knt_extflex_line = animatedline(axes3,'Color','r','DisplayName','KINECT right flex-ext offset');

subplot(3,2,5)
xlabel('Sample number','FontWeight','bold','FontSize',font);
ylabel('Left flex-ext offset (degrees)','FontWeight','bold','FontSize',font);
legend('Location','NorthWest','FontWeight','bold','FontSize',font);
axes4 = gca;
L_imu_abdadd_line = animatedline(axes4,'Color','b','DisplayName','WISE left abd-add offset');
L_knt_abdadd_line = animatedline(axes4,'Color','r','DisplayName','KINECT left abd-add offset');

subplot(3,2,6)
xlabel('Sample number','FontWeight','bold','FontSize',font);
ylabel('Left flex-ext offset (degrees)','FontWeight','bold','FontSize',font);
legend('Location','NorthWest','FontWeight','bold','FontSize',font);
axes5 = gca;
R_imu_abdadd_line = animatedline(axes5,'Color','b','DisplayName','WISE right abd-add offset');
R_knt_abdadd_line = animatedline(axes5,'Color','r','DisplayName','KINECT right abd-add offset');

thtol = 1*pi/180;
tol = 3;

thg_old = 0;
thg_avg = 0;

tl = 0;
while tl <=5
    tic
if ser.BytesAvailable
        
       [qA,qB,qC,qD,qEg] = DataReceive(ser,qA,qB,qC,qD,qEg,0,0);
       qX = quatmultiply(qEg,quatmultiply(qI,quatconj(qEg)));
       qY = quatmultiply(qEg,quatmultiply(qJ,quatconj(qEg)));
       thg_old = atan2(dot(G,qY(2:4)),dot(G,qX(2:4)));  
       
end
    tl = tl+ toc; 

end

count = 0;
while count<=50
    if ser.BytesAvailable
        
       [qA,qB,qC,qD,qEg] = DataReceive(ser,qA,qB,qC,qD,qEg,0,0);
       qX = quatmultiply(qEg,quatmultiply(qI,quatconj(qEg)));
       qY = quatmultiply(qEg,quatmultiply(qJ,quatconj(qEg)));
       
       thg = atan2(dot(G,qY(2:4)),dot(G,qX(2:4)));    
       
       if abs(thg_old-thg)<=thtol
            thg_avg = thg+thg_avg;
            thg_old = thg;
            count = count+1;
            addpoints(Moff_line,count,thg*180/pi); 
            drawnow;
       else
            
       end
       
    end
end

thg = thg_avg/count;


thl_old = 0;
thl_avg = 0;

tl = 0;
while tl <=5
    tic
if ser.BytesAvailable
        
       [qA,qB,qC,qD,qEl] = DataReceive(ser,qA,qB,qC,qD,qEg,thg,0);
       qX = quatmultiply(qEl,quatmultiply(qI,quatconj(qEl)));
       qZ = quatmultiply(qEl,quatmultiply(qK,quatconj(qEl)));
       thl_old = atan2(dot(G,qZ(2:4)),dot(G,qX(2:4)));   
       
end
    tl = tl+ toc; 

end


count = 0;
while count<=50
    if ser.BytesAvailable
        
       [qA,qB,qC,qD,qEl] = DataReceive(ser,qA,qB,qC,qD,qEg,thg,0);
       qX = quatmultiply(qEl,quatmultiply(qI,quatconj(qEl)));
       qZ = quatmultiply(qEl,quatmultiply(qK,quatconj(qEl)));
       
       thl = atan2(dot(G,qZ(2:4)),dot(G,qX(2:4)));
       
       if abs(thl_old-thl)<=thtol
            thl_avg = thl+thl_avg;
            thl_old = thl;
            count = count+1;
            addpoints(LumbSpine_line,count,thl*180/pi); 
            drawnow;
       else

       end
       
    end
end

thl = thl_avg/count;

lshoangle_x = [0,0,0,0,0]';
rshoangle_x = [0,0,0,0,0]';
lshoangle_avg = [0,0,0,0,0]';
rshoangle_avg = [0,0,0,0,0]';

kinoff = [0;0;0;0;0;0;0;0];
kin_avg = [0;0;0;0;0;0;0;0];

tl = 0;
while tl <=5
    tic
    
    if ser.BytesAvailable

           [qA,qB,qC,qD,qE] = DataReceive(ser,qA,qB,qC,qD,qE,thg,thl);       
           lshoangle_x = get_Left(qE,qC,qA);
           rshoangle_x = get_Right(qE,qD,qB);  

    end
    
    validData = k2.updateData;       
    if validData
           depth = k2.getDepth;color = k2.getColor;face = k2.getFaces;
           depth8u = uint8(depth*(255/outOfRange));depth8uc3 = repmat(depth8u,[1 1 3]);
           figure(1)
           color = imresize(color,COL_SCALE);
           c.im = imshow(color, 'Parent', c.ax);
           rectangle('Position',[0 0 475 1080],'LineWidth',3,'FaceColor','k');  
           rectangle('Position',[1350 0 620 1080],'LineWidth',3,'FaceColor','k');
           [bodies, fcp, timeStamp] = k2.getBodies('Quat');
           numBodies = size(bodies,2);
           if numBodies == 1
               pos2Dxxx = bodies(1).Position; 
               kinoff = get_Kinect(pos2Dxxx);
               k2.drawBodies(c.ax,bodies,'color',3,2,1);k2.drawFaces(c.ax,face,5,false,20);
           end
    end
%     flushinput(ser);
    pause(tp);
    tl = tl+ toc; 

end


count=0;
while count<=50
    
    validData = k2.updateData;
       if ser.BytesAvailable && validData
           depth = k2.getDepth;color = k2.getColor;face = k2.getFaces;
           depth8u = uint8(depth*(255/outOfRange));depth8uc3 = repmat(depth8u,[1 1 3]);
           [bodies, fcp, timeStamp] = k2.getBodies('Quat');
           numBodies = size(bodies,2);
           if numBodies == 1
               pos2Dxxx = bodies(1).Position; 
               [qA,qB,qC,qD,qE] = DataReceive(ser,qA,qB,qC,qD,qE,thg,thl);       
               lshoangle = get_Left(qE,qC,qA);
               rshoangle = get_Right(qE,qD,qB);
               kinect_angles = get_Kinect(pos2Dxxx);
      
               figure(1)
               color = imresize(color,COL_SCALE);
               c.im = imshow(color, 'Parent', c.ax);
               rectangle('Position',[0 0 475 1080],'LineWidth',3,'FaceColor','k');  
               rectangle('Position',[1350 0 620 1080],'LineWidth',3,'FaceColor','k');
               k2.drawBodies(c.ax,bodies,'color',3,2,1);k2.drawFaces(c.ax,face,5,false,20);
               
              if all(abs(kinect_angles(1:4)-kinoff(1:4))<tol) && all(abs(lshoangle(1:2)-lshoangle_x(1:2))<tol) && all(abs(rshoangle(1:2)-rshoangle_x(1:2))<tol)
               count = count+1;
               
               kin_avg = kin_avg+kinect_angles;
               kinoff = kinect_angles;
               lshoangle_avg = lshoangle+lshoangle_avg;
               rshoangle_avg = rshoangle+rshoangle_avg;
               lshoangle_x = lshoangle;
               rshoangle_x = rshoangle;
               
               addpoints(L_imu_extflex_line,count,lshoangle(1)); 
               drawnow;
               addpoints(L_imu_abdadd_line,count,lshoangle(2)); 
               drawnow;
               addpoints(R_imu_extflex_line,count,rshoangle(1)); 
               drawnow;
               addpoints(R_imu_abdadd_line,count,rshoangle(2)); 
               drawnow;
               addpoints(L_knt_extflex_line,count,kinect_angles(1)); 
               drawnow;
               addpoints(L_knt_abdadd_line,count,kinect_angles(3)); 
               drawnow;
               addpoints(R_knt_extflex_line,count,kinect_angles(2)); 
               drawnow;
               addpoints(R_knt_abdadd_line,count,kinect_angles(4)); 
               drawnow;

              else
                
              end
              
           end

%           flushinput(ser); 
          pause(tp);    
        end
        
end
lshoangle_x = lshoangle_avg/count;
rshoangle_x = rshoangle_avg/count;
kinoff = kin_avg/count;



fprintf(fwrite,'Mounting offset angle: %s in degrees\n',num2str(thg*180/pi));
fprintf(fwrite,'Lumbar spine angle: %s in degrees\n',num2str(thl*180/pi));
fprintf(fwrite,'Kinect offset angles: %f in degrees\n',kinoff);
fprintf(fwrite,'WISE left side offset angles: %f in degrees\n',lshoangle_x);
fprintf(fwrite,'WISE right side offset angles: %f in degrees\n',rshoangle_x);
fclose(fwrite);
clearvars fwrite;

%Angle initialization for WISE+KINECT system
limuef = 0;rimuef = 0;lkinef = 0;rkinef = 0;
limubd = 0;rimubd = 0;lkinbd = 0;rkinbd = 0;
limuie = 0;rimuie = 10;lkinie = 0;rkinie = 0;
limuelb = 0;rimuelb = 0;lkinelb = 0;rkinelb = 0;
limuelb1 = 0;rimuelb1 = 0;lkinelb1 = 0;rkinelb1 = 0;


%%  Complete routine for updating data with 14 different angles

close figure 2
sz2 = screensize(2);
figure('units', 'pixels', 'outerposition', sz2)

lshoangle_x(3:5) = 0;
rshoangle_x(3:5) = 0;
kinoff(5:8) = 0;

kinect_ang = zeros(8,1);
for i=1:length(markers)
arg = char(markers(i));    
[anline,anline1,fid] = TitleUpdate_red(arg,SUBJECTID);
lc=1;l=0;lflag = 0;telapsed=0;
while (lc) 
   tstart = tic;
   validData = k2.updateData;
   if ser.BytesAvailable && validData
       depth = k2.getDepth;color = k2.getColor;face = k2.getFaces;
       depth8u = uint8(depth*(255/outOfRange));depth8uc3 = repmat(depth8u,[1 1 3]);
       [bodies, fcp, timeStamp] = k2.getBodies('Quat');
       numBodies = size(bodies,2);
       
       if numBodies == 1

       pos2Dxxx = bodies(1).Position; 
       [qA,qB,qC,qD,qE] = DataReceive(ser,qA,qB,qC,qD,qE,thg,thl);

       lshoangle = get_Left(qE,qC,qA);
       lshoangle = lshoangle-lshoangle_x;
       limuef = lshoangle(1);
       limubd = lshoangle(2);
       limuie = lshoangle(3); 
       limuelb = lshoangle(4);
       limuelb1 = lshoangle(5);
       
       rshoangle = get_Right(qE,qD,qB);
       rshoangle = rshoangle - rshoangle_x;
       rimuef = rshoangle(1);
       rimubd = rshoangle(2);
       rimuie = rshoangle(3);
       rimuelb = rshoangle(4);
       rimuelb1 = rshoangle(5);

           kinect_ang = get_Kinect(pos2Dxxx);
           kinect_ang = kinect_ang-kinoff;
           lkinef = kinect_ang(1);
           rkinef = kinect_ang(2);
           lkinbd = kinect_ang(3);
           rkinbd = kinect_ang(4);
           lkinie = kinect_ang(5);
           rkinie = kinect_ang(6);
           lkinelb = kinect_ang(7);
           rkinelb = kinect_ang(8); 
           
       figure(1)
       color = imresize(color,COL_SCALE);c.im = imshow(color, 'Parent', c.ax);
       rectangle('Position',[0 0 475 1080],'LineWidth',3,'FaceColor','k');  
       rectangle('Position',[1350 0 620 1080],'LineWidth',3,'FaceColor','k');
       k2.drawBodies(c.ax,bodies,'color',3,2,1);k2.drawFaces(c.ax,face,5,false,20);
       
           switch arg
                case 'lef'
                    kin = lkinef; imu = limuef;
                    lim = kin;
                    tlow = 10; thigh=120;
                case 'lbd'
                    kin = lkinbd; imu = limubd;
                    lim = kin;
                    tlow = 30; thigh=100;
                case 'lelb'
                    kin = lkinelb; imu = limuelb;
                    lim = kin;
                    tlow = 30; thigh=100;
                case 'lelb1'
                    kin = lkinelb; imu = limuelb;
                    lim = kin;
                    tlow = 30; thigh=100;
                case 'lie'
                    kin = lkinie; imu = limuie;
                    lim = imu;
                    tlow = -40; thigh=40;
                case 'ref'
                    kin = rkinef; imu = rimuef;
                    lim = kin;
                    tlow = 10; thigh=120;
                case 'rbd'
                    kin = rkinbd; imu = rimubd;
                    lim = kin;
                    tlow = 30; thigh=100;
                case 'relb'
                    kin = rkinelb; imu = rimuelb;
                    lim = kin;
                    tlow = 30; thigh=100;
                case 'relb1'
                    kin = rkinelb; imu = rimuelb;
                    lim = kin;
                    tlow = 30; thigh=100;
                case 'rie'
                    kin = rkinie; imu = rimuie;
                    lim = imu;
                    tlow = -40; thigh=40;
           end
           updateWiseKinect_red(arg,kin,imu,telapsed,anline,anline1)
           %'Timestamp','Kinect_LeftShoulder_Ext.-Flex.','IMU_LeftShoulder_Ext.-Flex.','Kinect_LeftShoulder_Abd.-Add.','IMU_
           % LeftShoulder_Abd.-Add.','Kinect_LeftShoulder_Int.-Ext.','IMU_LeftShoulder_Int.-Ext.','Kinect_LeftElbow_Ext.-Flex.','IMU_LeftElbow_Ext.-Flex.',
           %'Kinect_RightShoulder_Ext.-Flex.','IMU_RightShoulder_Ext.-Flex.','Kinect_RightShoulder_Abd.-Add.','IMU_RightShoulder_Abd.-Add.',
           %'Kinect_RightShoulder_Int.-Ext.','IMU_RightShoulder_Int.-Ext.','Kinect_RightElbow_Ext.-Flex.','IMU_RightElbow_Ext.-Flex.');
           fprintf( fid, '%.2f,%.2f,%.2f,%.2f,%.2f,%.2f,%.2f,%.2f,%.2f,%.2f,%.2f,%.2f,%.2f,%.2f,%.2f,%.2f,%.2f\n',telapsed,...
           lkinef,limuef,lkinbd,limubd,lkinie,limuie,lkinelb,limuelb,rkinef,rimuef,...
           rkinbd,rimubd,rkinie,rimuie,rkinelb,rimuelb);
       
       %{
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
           %}
           
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
%    flushinput(ser);
   pause(tp);

 if telapsed>=65
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
instrreset

