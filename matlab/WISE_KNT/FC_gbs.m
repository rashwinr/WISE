%% Initialization section
clear all; close all;clc;


prompt1 = 'Please enter the subject ID given for the user: ';
SUBJECTID = input(prompt1);
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


instrreset
ser = serial('COM38','BaudRate',115200);
ser.ReadAsyncMode = 'continuous';
fopen(ser);
k=[];

%Angle initialization for WISE+KINECT system
limuef = 0;rimuef = 0;lkinef = 0;rkinef = 0;
limubd = 0;rimubd = 0;lkinbd = 0;rkinbd = 0;
limuie = 0;rimuie = 10;lkinie = 0;rkinie = 0;
limuelb = 0;rimuelb = 0;lkinelb = 0;rkinelb = 0;
% limuelb1 = 0;rimuelb1 = 0;lkinelb1 = 0;rkinelb1 = 0;
ls = 0;rs = 1350;lw = 475;H = 1080;rw = 570;     
qC = [1,0,0,0];qD = [1,0,0,0];qA = [1,0,0,0];qB = [1,0,0,0];qE = [1,0,0,0];
lshoangle = [0,0,0,0,0]';
rshoangle = [0,0,0,0,0]';
file = sprintf('%s_WISE+KINECT_testing_%s.txt',num2str(SUBJECTID),datestr(now,'mm-dd-yyyy HH-MM'));
fid = fopen(file,'wt');
%%  
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
       Angle = getAnglefromFC(ser);
       kinect_ang = get_Kinect(pos2Dxxx);
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
       fprintf( fid, '%.2f,%.2f,%.2f\n',telapsed,rkinbd,Angle);
       end
       if numBodies == 0
           figure(1)
           s1 = strcat('No persons in view');   
           text((1920/2) - 250,100,s1,'Color','red','FontSize',30,'FontWeight','bold');
       end      
       if numBodies > 1
           while numBodies > 1
           validData = k2.updateData;
            if validData
               depth = k2.getDepth;color = k2.getColor;face = k2.getFaces;
               depth8u = uint8(depth*(255/outOfRange));depth8uc3 = repmat(depth8u,[1 1 3]);
               [bodies, fcp, timeStamp] = k2.getBodies('Quat');
               numBodies = size(bodies,2);
               figure(1)
               s1 = strcat('Too many people in view');
               text(1920/2,100,s1,'Color','red','FontSize',30,'FontWeight','bold');
            end
           end
       end     
       
       if ~isempty(k)
           if strcmp(k,'q') 
           k=[];
           break; 
           end
       end
   end
   
if telapsed>=30
     break;
end

telapsed = telapsed+toc(tstart);
pause(0.05)
end
fclose(fid);