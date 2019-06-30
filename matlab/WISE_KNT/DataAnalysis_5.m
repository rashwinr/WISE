clc;clear all;close all
markers = ["lef","lbd","lelb","lelb1","lps","lie","lie1","ref","rbd","relb","relb1","rps","rie","rie1"];
subjectID = ["1330","1390","1490","1430","1950","1660","1160","1970","1580","1440","1110","1770","1250","1240","1610","1840","1130","1490","1940","1390","1410","1710","1380","1630"];
SID = 2420;
% addpath('F:\github\wearable-jacket\matlab\WISE_KNT')
addpath('C:\Users\fabio\github\wearable-jacket\matlab\WISE_KNT') % fabio address
% cd(strcat('F:\github\wearable-jacket\matlab\kinect+imudata\',num2str(SID)));
cd(strcat('C:\Users\fabio\github\wearable-jacket\matlab\kinect+imudata\',num2str(SID))); % fabio address
list = dir();
spike_files=dir('*.txt');

%
%fprintf( fid, '%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s\n','Timestamp','Kinect left shoulder flex.-ext.',...
% 'WISE left shoulder flex.-ext.','Kinect left shoulder abd.-add.','WISE left shoulder abd.-add.','Kinect left shoulder int.- ext.',...
% 'WISE left shoulder int.- ext.','Kinect left elbow flex.-ext.','WISE left elbow flex.-ext.','WISE left forearm pro.- sup.',...
% 'Kinect right shoulder flex.-ext.','WISE right shoulder flex.-ext.','Kinect right shoulder Abd.-Add.','WISE right shoulder abd.-add.',...
% 'Kinect right shoulder int.-ext.','WISE right shoulder int.-ext.','Kinect right elbow flex.-ext.','WISE right elbow flex.-ext.',...
% 'WISE right forearm pro.-sup.');

circleth = 0:1*pi/180:2*pi;
circlero = 10*ones(size(circleth));

MS = 30;
font = 15;
span = 5;
cmax = 30;

% load myCustomColormap
% colormap( myCustomColormap );

load Thoroid_Cmap
colormap( Thoroid_Cmap );




figure(1)
sgtitle(strcat(num2str(SID),' Kinect+WISE',' errors vs angles'));
subplot(1,2,1)
% polarscatter(0,0,MS+30,9,'filled','MarkerFaceAlpha',.5);
hold on


tf = strcat(num2str(SID));
trfile = strcat(tf,'.txt');
fid = fopen(trfile,'wt');
        
for i = 1:length(spike_files)
    f1 = strsplit(spike_files(i).name,'.');
    f2 = strsplit(string(f1(1)),'_');
    if length(f2)>=2
    if f2(2) == "WISE+KINECT" && f2(1)==num2str(SID)
        if f2.length()>=5 && f2(3)== "testing"
            typ = f2(5);
        
        data = importWISEKINECT(spike_files(i).name);
        len = size(data,1);
        textvars = data(1,:);
        Time = zeros(len-1,1);
        lfe = zeros(len-1,2);
        lbd = zeros(len-1,2);
        lie = zeros(len-1,2);
        lelbfe = zeros(len-1,2);
        lfps = zeros(len-1,1);
        rfe = zeros(len-1,2);
        rbd = zeros(len-1,2);
        rie = zeros(len-1,2);
        relbfe = zeros(len-1,2);
        rfps = zeros(len-1,1);
        for j = 2:len 
        Time(j-1) = str2double(data(j,1));
        lfe(j-1,:) = [str2double(data(j,2)) str2double(data(j,3))];
        lbd(j-1,:) = [str2double(data(j,4)) str2double(data(j,5))];
        lie(j-1,:) = [str2double(data(j,6)) str2double(data(j,7))];
        lelbfe(j-1,:) = [str2double(data(j,8)) str2double(data(j,9))];
        lfps(j-1) = str2double(data(j,10));
        rfe(j-1,:) = [str2double(data(j,11)) str2double(data(j,12))];
        rbd(j-1,:) = [str2double(data(j,13)) str2double(data(j,14))];
        rie(j-1,:) = [str2double(data(j,15)) str2double(data(j,16))];
        relbfe(j-1,:) = [str2double(data(j,17)) str2double(data(j,18))];
        rfps(j-1) = str2double(data(j,19));
        end

        fopen(trfile,'a+');
%         rmse1 = NaN;
%         rmse2 = NaN;
%         PWise = NaN(7,1);
%         PKinect = NaN(7,1);
%         WLoc = NaN(7,1);
%         KLoc = NaN(7,1);
        scale = 0.1;
        switch(typ)

            case markers(1)
                err = lfe(:,1)-lfe(:,2);
                
                TH = lfe(:,2);
                Err = abs(err);
                [angles,M] = PolarMean(TH,Err,span);
                Radius = 10;
                
                PIO = linspace(pi,0,length(M)); 
                O_PI = linspace(-pi,0,length(M));
                rTor = zeros(length(M));
                thTor = zeros(length(M));
                Z_top = zeros(length(M));
                Z_bottom = zeros(length(M));
                
                
                for mesh=1:length(M)
                    rTor(mesh,:) = linspace(Radius-scale*M(mesh),Radius+scale*M(mesh),length(M));
                    thTor(:,mesh) = angles*pi/180;
                    Z_top(mesh,:) = scale*M(mesh)*sin(PIO);
                    Z_bottom(mesh,:) = scale*M(mesh)*sin(O_PI);
                end
                
                
%                 [rTor,thTor] = meshgrid(M,angles*pi/180);
                
                
                
                figure(1)
                subplot(1,2,1)
                [X,Y,Z] = pol2cart(thTor,rTor,Z_top);
                surf(X,Y,Z);
                [X,Y,Z] = pol2cart(thTor,rTor,Z_bottom);
                surf(X,Y,Z);
                axis equal
                shading interp
                
%                 sz = MS*ones(size(M))+20*M;
% %                 R = ones(size(M))*0.5;
%                 Mean = [M';M'];
%                 R = ones(size(M))*0.5;
%                 
%                 [x,y,z]=pol2cart(R,lfe(:,2)*pi/180,Err);
                
%                 figure(1)
%                 subplot(1,2,1)
%                 surf(x,y,z)
                %polarscatter(angles*pi/180,R,sz,M,'filled','MarkerFaceAlpha',.5)
%                 caxis([0 cmax])
%                 str = 'Arm flexion-extension';
%                 strL = length(str);
%                 dth = 8;
%                 thi = 270-round(strL/2)*dth;
                
                
%                 for s=1:strL
%                     text((thi+dth*s)*pi/180,0.5,str(s),'Rotation',(thi-270)+dth*s,'HorizontalAlignment','center','VerticalAlignment','middle')
%                 end
                
            case markers(2)
                err = lbd(:,1)-lbd(:,2);
                
                TH = lbd(:,2);
                Err = abs(err);
                [angles,M] = PolarMean(TH,Err,span);
                sz = MS*ones(size(M))+20*M;
                R = ones(size(M))*1;
                
                figure(1)
                subplot(1,2,1)
                polarscatter(angles*pi/180,R,sz,M,'filled','MarkerFaceAlpha',.5)
                caxis([0 cmax])
                
                str = 'Arm abduction-adduction';
                strL = length(str);
                dth = 6;
                thi = 270-round(strL/2)*dth;
                
                
                for s=1:strL
                    text((thi+dth*s)*pi/180,1,str(s),'Rotation',(thi-270)+dth*s,'HorizontalAlignment','center','VerticalAlignment','middle')
                end
                
            case markers(3)
                err = lelbfe(:,1)-lelbfe(:,2);
                
                TH = lelbfe(:,2);
                Err = abs(err);
                [angles,M] = PolarMean(TH,Err,span);
                sz = MS*ones(size(M))+20*M;
                R = ones(size(M))*1.5;
                
                figure(1)
                subplot(1,2,1)
                polarscatter(angles*pi/180,R,sz,M,'filled','MarkerFaceAlpha',.5)
                caxis([0 cmax])
                
                str = 'Forearm flexion-extension without abduction';
                strL = length(str);
                dth = 4;
                thi = 270-round(strL/2)*dth;
                
                
                for s=1:strL
                    text((thi+dth*s)*pi/180,1.5,str(s),'Rotation',(thi-270)+dth*s,'HorizontalAlignment','center','VerticalAlignment','middle')
                end

            case markers(4)
                err = lelbfe(:,1)-lelbfe(:,2);
                
                TH = lelbfe(:,2);
                Err = abs(err);
                [angles,M] = PolarMean(TH,Err,span);
                sz = MS*ones(size(M))+20*M;
                R = ones(size(M))*2;
                
                figure(1)
                subplot(1,2,1)
                polarscatter(angles*pi/180,R,sz,M,'filled','MarkerFaceAlpha',.5)
                caxis([0 cmax])
                
                str = 'Forearm flexion-extension with abduction';
                strL = length(str);
                dth = 3;
                thi = 270-round(strL/2)*dth;
                
                for s=1:strL
                    text((thi+dth*s)*pi/180,2,str(s),'Rotation',(thi-270)+dth*s,'HorizontalAlignment','center','VerticalAlignment','middle')
                end

            case markers(5)

            case markers(6)
                
                lie(lie==666) = NaN;
                [Row] = find(isnan(lie(:,1)));
                lie(Row,:) = [];
                
                err = lie(:,1)-lie(:,2);
                
                TH = lie(:,2);
                Err = abs(err);
                [angles,M] = PolarMean(TH,Err,span);
                sz = MS*ones(size(M))+20*M;
                R = ones(size(M))*2.5;
                
                figure(1)
                subplot(1,2,1)
                polarscatter(angles*pi/180,R,sz,M,'filled','MarkerFaceAlpha',.5)
                caxis([0 cmax])
                
                str = 'Arm internal-external rotation with flexion';
                strL = length(str);
                dth = 2;
                thi = 270-round(strL/2)*dth;
                
                for s=1:strL
                    text((thi+dth*s)*pi/180,2.5,str(s),'Rotation',(thi-270)+dth*s,'HorizontalAlignment','center','VerticalAlignment','middle')
                end

       
            case markers(7)

            case markers(8)
                err = rfe(:,1)-rfe(:,2);
                
                TH = rfe(:,2);
                Err = abs(err);
                [angles,M] = PolarMean(TH,Err,span);
                sz = MS*ones(size(M))+20*M;
                R = ones(size(M))*0.5;
                
                figure(1)
                subplot(1,2,2)
                polarscatter(angles*pi/180,R,sz,M,'filled','MarkerFaceAlpha',.5)
                caxis([0 cmax])
                
                hold on

            case markers(9)
                err = rbd(:,1)-rbd(:,2);
                
                TH = rbd(:,2);
                Err = abs(err);
                [angles,M] = PolarMean(TH,Err,span);
                sz = MS*ones(size(M))+20*M;
                R = ones(size(M))*1;
                
                figure(1)
                subplot(1,2,2)
                polarscatter(angles*pi/180,R,sz,M,'filled','MarkerFaceAlpha',.5)
                caxis([0 cmax])

            case markers(10)
                err = relbfe(:,1)-relbfe(:,2);
                
                TH = relbfe(:,2);
                Err = abs(err);
                [angles,M] = PolarMean(TH,Err,span);
                sz = MS*ones(size(M))+20*M;
                R = ones(size(M))*1.5;
                
                figure(1)
                subplot(1,2,2)
                polarscatter(angles*pi/180,R,sz,M,'filled','MarkerFaceAlpha',.5)
                caxis([0 cmax])

            case markers(11)
                err = relbfe(:,1)-relbfe(:,2);
                
                TH = relbfe(:,2);
                Err = abs(err);
                [angles,M] = PolarMean(TH,Err,span);
                sz = MS*ones(size(M))+20*M;
                R = ones(size(M))*2;
                
                figure(1)
                subplot(1,2,2)
                polarscatter(angles*pi/180,R,sz,M,'filled','MarkerFaceAlpha',.5)
                caxis([0 cmax])
  
            case markers(12)
     
            case markers(13)
                
                rie(rie==666) = NaN;
                [Row] = find(isnan(rie(:,1)));
                rie(Row,:) = [];
                Time(length(rie)+1:length(Time)) = [];
                
                err = rie(:,1)-rie(:,2);
                
                TH = rie(:,2);
                Err = abs(err);
                [angles,M] = PolarMean(TH,Err,span);
                sz = MS*ones(size(M))+20*M;
                R = ones(size(M))*2;
                
                figure(1)
                subplot(1,2,2)
                polarscatter(angles*pi/180,R,sz,M,'filled','MarkerFaceAlpha',.5)
                caxis([0 cmax])
     
            case markers(14)
          

        end
        
        colorbar('southoutside')
               
    fclose(fid);
    end
    end

   end 
end
