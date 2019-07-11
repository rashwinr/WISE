
clc;clear all;close all
markers = ["lef","lbd","lelb","lelb1","lps","lie","lie1","ref","rbd","relb","relb1","rps","rie","rie1"];
subjectID = ["1330","1390","1490","1430","1950","1660","1160","1970","1580","1440","1110","1770","1250","1240","1610","1840","1130","1490","1940","1390","1410","1710","1380","1630"];
% <<<<<<< HEAD
% <<<<<<< HEAD
SID = 2900;
addpath('F:\github\wearable-jacket\matlab\WISE_KNT')
% addpath('C:\Users\fabio\github\wearable-jacket\matlab\WISE_KNT') % fabio address
cd(strcat('F:\github\wearable-jacket\matlab\kinect+imudata\',num2str(SID)));
% cd(strcat('C:\Users\fabio\github\wearable-jacket\matlab\kinect+imudata\',num2str(SID))); % fabio address
% =======
% SID = 2420;
addpath('F:\github\wearable-jacket\matlab\WISE_KNT')
% addpath('C:\Users\fabio\github\wearable-jacket\matlab\WISE_KNT') % fabio address
cd(strcat('F:\github\wearable-jacket\matlab\kinect+imudata\',num2str(SID)));
% cd(strcat('C:\Users\fabio\github\wearable-jacket\matlab\kinect+imudata\',num2str(SID))); % fabio address
% >>>>>>> fed6afbc25dd13a3a47d39ffea08fa6a4cebd172
% =======
% SID = 2420;
% addpath('F:\github\wearable-jacket\matlab\WISE_KNT')
% addpath('C:\Users\fabio\github\wearable-jacket\matlab\WISE_KNT') % fabio address
% cd(strcat('F:\github\wearable-jacket\matlab\kinect+imudata\',num2str(SID)));
% cd(strcat('C:\Users\fabio\github\wearable-jacket\matlab\kinect+imudata\',num2str(SID))); % fabio address

SID = 2900;
% addpath('F:\github\wearable-jacket\matlab\WISE_KNT')
% addpath('C:\Users\fabio\github\wearable-jacket\matlab\WISE_KNT') % fabio address
% cd(strcat('F:\github\wearable-jacket\matlab\kinect+imudata\',num2str(SID)));
% cd(strcat('C:\Users\fabio\github\wearable-jacket\matlab\kinect+imudata\',num2str(SID))); % fabio address

% >>>>>>> 93a0a0813f533ed1abbbe5ab9be9612391c4420b
list = dir();
spike_files=dir('*.txt');

%
%fprintf( fid, '%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s\n','Timestamp','Kinect left shoulder flex.-ext.',...
% 'WISE left shoulder flex.-ext.','Kinect left shoulder abd.-add.','WISE left shoulder abd.-add.','Kinect left shoulder int.- ext.',...
% 'WISE left shoulder int.- ext.','Kinect left elbow flex.-ext.','WISE left elbow flex.-ext.','WISE left forearm pro.- sup.',...
% 'Kinect right shoulder flex.-ext.','WISE right shoulder flex.-ext.','Kinect right shoulder Abd.-Add.','WISE right shoulder abd.-add.',...
% 'Kinect right shoulder int.-ext.','WISE right shoulder int.-ext.','Kinect right elbow flex.-ext.','WISE right elbow flex.-ext.',...
% 'WISE right forearm pro.-sup.');
figure(1)
sgtitle(strcat(num2str(SID),' Kinect+WISE'));

figure(2)
sgtitle(strcat(num2str(SID),' Error signal'));

figure(3)
sgtitle(strcat(num2str(SID),' Peaks'));

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
        
        data = importWISEKINECT1(spike_files(i).name);
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
        rfe(j-1,:) = [str2double(data(j,10)) str2double(data(j,11))];
        rbd(j-1,:) = [str2double(data(j,12)) str2double(data(j,13))];
        rie(j-1,:) = [str2double(data(j,14)) str2double(data(j,15))];
        relbfe(j-1,:) = [str2double(data(j,16)) str2double(data(j,17))];
        end

        fopen(trfile,'a+');
%         rmse1 = NaN;
%         rmse2 = NaN;
%         PWise = NaN(7,1);
%         PKinect = NaN(7,1);
%         WLoc = NaN(7,1);
%         KLoc = NaN(7,1);
        
        switch(typ)
            
            case markers(1)
                figure(1)
                subplot(7,2,1)
                plot(Time,lfe(:,1),'r');
                hold on
                plot(Time,lfe(:,2),'b');
                title('Left arm flexion-extension')
                legend('Kinect','WISE')
                ylabel('Joint angle (degrees)')
                xlabel('Time (seconds)')
                hold off    
                
                rmse1 = signal_RMSE(lfe(:,1),lfe(:,2));
                figure(2)
                hold on
                subplot(7,2,1)
                plot(Time,abs(lfe(:,1)-lfe(:,2)),'k');
                title(strcat('Left arm flexion-extension ',' RMSE = ',num2str(rmse1)))
                ylabel('Error angle (degrees)')
                xlabel('Time (seconds)')
                hold off
                
                [pkinect,kloc] = findpeaks(lfe(:,1),Time,'MinPeakHeight',100,'MinPeakProminence',50,'NPeaks',7);
                [pwise,wloc] = findpeaks(lfe(:,2),Time,'MinPeakHeight',100,'MinPeakProminence',50,'NPeaks',7);
                
                if size(pwise,1)~=0 && size(pkinect,1)~=0
                    rmse2 = signal_RMSE(pkinect(1:7),pwise(1:7));
                        for j=1:7
                            fprintf(fid,"%s,%s,%s,%s,%s\n",typ,string(j),string(pkinect(j)),string(pwise(j)),string(rmse1));
                        end
                        figure(3)
                        subplot(7,2,1)
                        plot(Time,lfe(:,1),'r');
                        hold on
                        plot(Time,lfe(:,2),'b');
                        scatter(kloc,pkinect,'r*')
                        scatter(wloc,pwise,'b*')
                        title(strcat('Left arm flexion-extension ',' RMSE peaks = ',num2str(rmse2)))
                        legend('Kinect','WISE')
                        ylabel('Joint angle (degrees)')
                        xlabel('Time (seconds)')
                        hold off
                end
               
            case markers(2)
                figure(1)
                subplot(7,2,3)
                plot(Time,lbd(:,1),'r');
                hold on
                plot(Time,lbd(:,2),'b');
                title('Left arm abduction-adduction')
                ylabel('Joint angle (degrees)')
                xlabel('Time (seconds)')
                hold off
                
                rmse1 = signal_RMSE(lbd(:,1),lbd(:,2));
                figure(2)
                hold on
                subplot(7,2,3)
                plot(Time,abs(lbd(:,1)-lbd(:,2)),'k');
                title(strcat(' Left arm abduction-adduction ',' RMSE = ',num2str(rmse1)))
                ylabel('Error angle (degrees)')
                xlabel('Time (seconds)')
                hold off
                
                [pkinect,kloc] = findpeaks(lbd(:,1),Time,'MinPeakHeight',100,'MinPeakProminence',50,'NPeaks',7);
                [pwise,wloc] = findpeaks(lbd(:,2),Time,'MinPeakHeight',100,'MinPeakProminence',50,'NPeaks',7);
                
                if size(pwise,1)~=0 && size(pkinect,1)~=0
                    rmse2 = signal_RMSE(pkinect(1:7),pwise(1:7));
                        for j=1:7
                            fprintf(fid,"%s,%s,%s,%s,%s\n",typ,string(j),string(pkinect(j)),string(pwise(j)),string(rmse1));
                        end
                        figure(3)
                        subplot(7,2,3)
                        plot(Time,lbd(:,1),'r');
                        hold on
                        plot(Time,lbd(:,2),'b');
                        title(strcat('Left arm abduction-adduction ',' RMSE peaks = ',num2str(rmse2)))
                        scatter(kloc,pkinect,'r*')
                        scatter(wloc,pwise,'b*')
                        ylabel('Joint angle (degrees)')
                        xlabel('Time (seconds)')
                        hold off
                end
                
            case markers(3)
                figure(1)
                subplot(7,2,5)
                plot(Time,lelbfe(:,1),'r');
                hold on
                plot(Time,lelbfe(:,2),'b');
                title(strcat('Left forearm Flexion-Extension without abduction'))
                ylabel('Joint angle (degrees)')
                xlabel('Time (seconds)')
                hold off
                
                rmse1 = signal_RMSE(lelbfe(:,1),lelbfe(:,2));
                figure(2)
                hold on
                subplot(7,2,5)
                plot(Time,abs(lelbfe(:,1)-lelbfe(:,2)),'k');
                title(strcat('Left forearm Flexion-Extension without abduction ',' RMSE = ',num2str(rmse1)))
                ylabel('Error angle (degrees)')
                xlabel('Time (seconds)')
                hold off
                
                [pkinect,kloc] = findpeaks(lelbfe(:,1),Time,'MinPeakHeight',100,'MinPeakProminence',50,'NPeaks',7);
                [pwise,wloc] = findpeaks(lelbfe(:,2),Time,'MinPeakHeight',100,'MinPeakProminence',50,'NPeaks',7);
                
                if size(pwise,1)~=0 && size(pkinect,1)~=0
                    rmse2 = 0;%signal_RMSE(pkinect(1:7),pwise(1:7));
                        for j=1:7
%                             fprintf(fid,"%s,%s,%s,%s,%s\n",typ,string(j),string(pkinect(j)),string(pwise(j)),string(rmse1));
                        end
                        figure(3)
                        subplot(7,2,5)
                        plot(Time,lelbfe(:,1),'r');
                        hold on
                        plot(Time,lelbfe(:,2),'b');
                        title(strcat('Left forearm flexion-extension without abduction ',' RMSE peaks = ',num2str(rmse2)))
                        scatter(kloc,pkinect,'r*')
                        scatter(wloc,pwise,'b*')
                        ylabel('Joint angle (degrees)')
                        xlabel('Time (seconds)')
                        hold off
                end
               
            case markers(4)

                figure(1)
                subplot(7,2,7)
                plot(Time,lelbfe(:,1),'r');
                hold on
                plot(Time,lelbfe(:,2),'b');
                title(strcat('Left forearm flexion-extension with abduction')) 
                ylabel('Joint angle (degrees)')
                xlabel('Time (seconds)')
                hold off
                
                rmse1 = signal_RMSE(lelbfe(:,1),lelbfe(:,2));
                figure(2)
                hold on
                subplot(7,2,7)
                plot(Time,abs(lelbfe(:,1)-lelbfe(:,2)),'k');
                title(strcat('Left forearm flexion-extension without abduction ',' RMSE = ',num2str(rmse1)))
                ylabel('Error angle (degrees)')
                xlabel('Time (seconds)')
                hold off
                
                [pkinect,kloc] = findpeaks(lelbfe(:,1),Time,'MinPeakHeight',100,'MinPeakProminence',50,'NPeaks',7);
                [pwise,wloc] = findpeaks(lelbfe(:,2),Time,'MinPeakHeight',100,'MinPeakProminence',50,'NPeaks',7);
                
                if size(pwise,1)~=0 && size(pkinect,1)~=0
                    rmse2 = 0;%signal_RMSE(pkinect(1:7),pwise(1:7));
                        for j=1:7
%                             fprintf(fid,"%s,%s,%s,%s,%s\n",typ,string(j),string(pkinect(j)),string(pwise(j)),string(rmse1));
                        end
                        figure(3)
                        subplot(7,2,7)
                        plot(Time,lelbfe(:,1),'r');
                        hold on
                        plot(Time,lelbfe(:,2),'b');
                        title(strcat('Left forearm flexion-extension with abduction ',' RMSE peaks = ',num2str(rmse2)))
                        scatter(kloc,pkinect,'r*')
                        scatter(wloc,pwise,'b*')
                        ylabel('Joint angle (degrees)')
                        xlabel('Time (seconds)')
                        hold off
                end
                
            case markers(5)
                
                figure(1)
                subplot(7,2,9)
                plot(Time,lfps(:,1),'b');
                hold on
                title('Left forearm pronation-supination')
                ylabel('Joint angle (degrees)')
                xlabel('Time (seconds)')
                hold off
                
                
            case markers(6)
                
                lie(lie>=500) = NaN;
                [Row] = find(isnan(lie(:,1)));
                lie(Row,:) = [];
                Time(length(lie)+1:length(Time)) = [];
                
                figure(1)
                subplot(7,2,11)
                plot(Time,lie(:,1),'r');
                hold on
                plot(Time,lie(:,2),'b');
                title(strcat('Left arm internal-external rotation with flexion'))
                ylabel('Joint angle (degrees)')
                xlabel('Time (seconds)')
                hold off
                
                rmse1 = signal_RMSE(lie(:,1),lie(:,2));
                figure(2)
                hold on
                subplot(7,2,11)
                plot(Time,abs(lie(:,1)-lie(:,2)),'k');
                title(strcat('Left arm internal-external rotation with flexion ',' RMSE = ',num2str(rmse1)))
                ylabel('Error angle (degrees)')
                xlabel('Time (seconds)')
                hold off
                
                [pkinect,kloc] = findpeaks(lie(:,1),Time,'MinPeakHeight',40,'NPeaks',7,'MinPeakProminence',50);
                [pwise,wloc] = findpeaks(lie(:,2),Time,'MinPeakHeight',40,'NPeaks',7,'MinPeakProminence',50);
                
                if size(pwise,1)~=0 && size(pkinect,1)~=0
                   rmse2 = 0;%signal_RMSE(pkinect(1:7),pwise(1:7));
%                         for j=1:7
%                             fprintf(fid,"%s,%s,%s,%s,%s\n",typ,string(j),string(pkinect(j)),string(pwise(j)),string(rmse1));
%                         end
                        figure(3)
                        subplot(7,2,11)
                        plot(Time,lie(:,1),'r');
                        hold on
                        plot(Time,lie(:,2),'b');
                        title(strcat('Left arm internal-external rotation with flexion ',' RMSE peaks = ',num2str(rmse2)))
                        scatter(kloc,pkinect,'r*')
                        scatter(wloc,pwise,'b*')
                        ylabel('Joint angle (degrees)')
                        xlabel('Time (seconds)')
                        hold off
                end
                
            case markers(7)
                
                lie(lie>=500) = NaN;
                [Row] = find(isnan(lie(:,1)));
                lie(Row,:) = [];
                Time(length(lie)+1:length(Time)) = [];
                figure(1)
                subplot(7,2,13)
                plot(Time,lie(:,2),'b');
                hold on
                title(strcat('Left arm internal-external rotation with abduction'))
                ylabel('Joint angle (degrees)')
                xlabel('Time (seconds)')
                hold off
                
            case markers(8)
                
                figure(1)
                subplot(7,2,2)
                plot(Time,rfe(:,1),'r');
                hold on
                plot(Time,rfe(:,2),'b');
                title(strcat('Right arm flexion extension'))
                ylabel('Joint angle (degrees)')
                xlabel('Time (seconds)')
                hold off
                
                rmse1 = signal_RMSE(rfe(:,1),rfe(:,2));
                figure(2)
                hold on
                subplot(7,2,2)
                plot(Time,abs(rfe(:,1)-rfe(:,2)),'k');
                title(strcat('Right arm flexion extension ',' RMSE = ',num2str(rmse1)))
                ylabel('Error angle (degrees)')
                xlabel('Time (seconds)')
                hold off
                
                [pkinect,kloc] = findpeaks(rfe(:,1),Time,'MinPeakHeight',100,'MinPeakProminence',50,'NPeaks',7);
                [pwise,wloc] = findpeaks(rfe(:,2),Time,'MinPeakHeight',100,'MinPeakProminence',50,'NPeaks',7);
                
                if size(pwise,1)~=0 && size(pkinect,1)~=0
                    rmse2 = signal_RMSE(pkinect(1:7),pwise(1:7));
                        for j=1:7
                            fprintf(fid,"%s,%s,%s,%s,%s\n",typ,string(j),string(pkinect(j)),string(pwise(j)),string(rmse1));
                        end
                        figure(3)
                        subplot(7,2,2)
                        plot(Time,rfe(:,1),'r');
                        hold on
                        plot(Time,rfe(:,2),'b');
                        title(strcat('Right arm flexion extension ',' RMSE peaks = ',num2str(rmse2)))
                        scatter(kloc,pkinect,'r*')
                        scatter(wloc,pwise,'b*')
                        ylabel('Joint angle (degrees)')
                        xlabel('Time (seconds)')
                        hold off
                end
                
            case markers(9)
                
                figure(1)
                subplot(7,2,4)
                plot(Time,rbd(:,1),'r');
                hold on
                plot(Time,rbd(:,2),'b');
                title(strcat('Right arm abduction-adduction'))
                ylabel('Joint angle (degrees)')
                xlabel('Time (seconds)')
                hold off   
                
                rmse1 = signal_RMSE(rbd(:,1),rbd(:,2));
                figure(2)
                hold on
                subplot(7,2,4)
                plot(Time,abs(rbd(:,1)-rbd(:,2)),'k');
                title(strcat('Right arm abduction-adduction ',' RMSE = ',num2str(rmse1)))
                ylabel('Error angle (degrees)')
                xlabel('Time (seconds)')
                hold off
                
                [pkinect,kloc] = findpeaks(rbd(:,1),Time,'MinPeakHeight',100,'MinPeakProminence',50,'NPeaks',7);
                [pwise,wloc] = findpeaks(rbd(:,2),Time,'MinPeakHeight',100,'MinPeakProminence',50,'NPeaks',7);
                
                if size(pwise,1)~=0 && size(pkinect,1)~=0
                    rmse2 = 0;%signal_RMSE(pkinect(1:7),pwise(1:7));
                        for j=1:7
%                             fprintf(fid,"%s,%s,%s,%s,%s\n",typ,string(j),string(pkinect(j)),string(pwise(j)),string(rmse1));
                        end
                        figure(3)
                        subplot(7,2,4)
                        plot(Time,rbd(:,1),'r');
                        hold on
                        plot(Time,rbd(:,2),'b');
                        title(strcat('Right arm abduction-adduction ',' RMSE peaks = ',num2str(rmse2)))
                        scatter(kloc,pkinect,'r*')
                        scatter(wloc,pwise,'b*')
                        ylabel('Joint angle (degrees)')
                        xlabel('Time (seconds)')
                        hold off
                end
                
            case markers(10)
                
                figure(1)
                subplot(7,2,6)
                plot(Time,relbfe(:,1),'r');
                hold on
                plot(Time,relbfe(:,2),'b');
                title(strcat('Right forearm flexion-extension without abduction'))
                ylabel('Joint angle (degrees)')
                xlabel('Time (seconds)')
                hold off
                
                rmse1 = signal_RMSE(relbfe(:,1),relbfe(:,2));
                figure(2)
                hold on
                subplot(7,2,6)
                plot(Time,abs(relbfe(:,1)-relbfe(:,2)),'k');
                title(strcat('Right forearm flexion-extension without abduction ',' RMSE = ',num2str(rmse1)))
                ylabel('Error angle (degrees)')
                xlabel('Time (seconds)')
                hold off
                
                [pkinect,kloc] = findpeaks(relbfe(:,1),Time,'MinPeakHeight',100,'MinPeakProminence',50,'NPeaks',7);
                [pwise,wloc] = findpeaks(relbfe(:,2),Time,'MinPeakHeight',100,'MinPeakProminence',50,'NPeaks',7);
                
                if size(pwise,1)~=0 && size(pkinect,1)~=0
                        rmse2 = signal_RMSE(pkinect(1:7),pwise(1:7));
                        for j=1:7
                            fprintf(fid,"%s,%s,%s,%s,%s\n",typ,string(j),string(pkinect(j)),string(pwise(j)),string(rmse1));
                        end
                        figure(3)
                        subplot(7,2,6)
                        plot(Time,relbfe(:,1),'r');
                        hold on
                        plot(Time,relbfe(:,2),'b');
                        title(strcat('Right forearm flexion-extension without abduction ',' RMSE peaks = ',num2str(rmse2)))
                        scatter(kloc,pkinect,'r*')
                        scatter(wloc,pwise,'b*')
                        ylabel('Joint angle (degrees)')
                        xlabel('Time (seconds)')
                        hold off
                end
                
            case markers(11)
                
                figure(1)
                subplot(7,2,8)
                plot(Time,relbfe(:,1),'r');
                hold on
                plot(Time,relbfe(:,2),'b');
                title(strcat('Right elbow flexion-extension with abduction'))
                ylabel('Joint angle (degrees)')
                xlabel('Time (seconds)')
                hold off
                
                rmse1 = signal_RMSE(relbfe(:,1),relbfe(:,2));
                figure(2)
                hold on
                subplot(7,2,8)
                plot(Time,abs(relbfe(:,1)-relbfe(:,2)),'k');
                title(strcat('Right elbow flexion-extension with abduction ',' RMSE = ',num2str(rmse1)))
                ylabel('Error angle (degrees)')
                xlabel('Time (seconds)')
                hold off
                
                [pkinect,kloc] = findpeaks(relbfe(:,1),Time,'MinPeakHeight',100,'MinPeakProminence',50,'NPeaks',7);
                [pwise,wloc] = findpeaks(relbfe(:,2),Time,'MinPeakHeight',100,'MinPeakProminence',50,'NPeaks',7);
                
                if size(pwise,1)~=0 && size(pkinect,1)~=0
                    rmse2 = signal_RMSE(pkinect(1:7),pwise(1:7));
                        for j=1:7
                            fprintf(fid,"%s,%s,%s,%s,%s\n",typ,string(j),string(pkinect(j)),string(pwise(j)),string(rmse1));
                        end
                        figure(3)
                        subplot(7,2,8)
                        plot(Time,relbfe(:,1),'r');
                        hold on
                        plot(Time,relbfe(:,2),'b');
                        title(strcat('Right elbow flexion-extension with abduction ',' RMSE peaks = ',num2str(rmse2)))
                        scatter(kloc,pkinect,'r*')
                        scatter(wloc,pwise,'b*')
                        ylabel('Joint angle (degrees)')
                        xlabel('Time (seconds)')
                        hold off
                end
                
            case markers(12)
                
                figure(1)
                subplot(7,2,10)
                plot(Time,rfps(:,1),'b');
                hold on
                title(strcat('Right elbow pronation-supination'))
                ylabel('Joint angle (degrees)')
                xlabel('Time (seconds)')
                hold off
                
            case markers(13)
                
                rie(rie>=500) = NaN;
                [Row] = find(isnan(rie(:,1)));
                rie(Row,:) = [];
                Time(length(rie)+1:length(Time)) = [];
                
                figure(1)
                subplot(7,2,12)
                plot(Time,rie(:,1),'r');
                hold on
                plot(Time,rie(:,2),'b');
                title(strcat('Right arm internal-external rotation with flexion'))
                ylabel('Joint angle (degrees)')
                xlabel('Time (seconds)')
                hold off
                
                rmse1 = signal_RMSE(rie(:,1),rie(:,2));
                figure(2)
                hold on
                subplot(7,2,12)
                plot(Time,abs(rie(:,1)-rie(:,2)),'k');
                title(strcat('Right arm internal-external rotation with flexion ',' RMSE = ',num2str(rmse1)))
                ylabel('Error angle (degrees)')
                xlabel('Time (seconds)')
                hold off
                
                [pkinect,kloc] = findpeaks(rie(:,1),Time,'MinPeakHeight',40,'NPeaks',7,'MinPeakProminence',50);
                [pwise,wloc] = findpeaks(rie(:,2),Time,'MinPeakHeight',40,'NPeaks',7,'MinPeakProminence',50);
                
                if size(pwise,1)~=0 && size(pkinect,1)~=0
                    
                        rmse2 = signal_RMSE(pkinect(1:7),pwise(1:7));
                        for j=1:7
                            fprintf(fid,"%s,%s,%s,%s,%s\n",typ,string(j),string(pkinect(j)),string(pwise(j)),string(rmse1));
                        end
                        figure(3)
                        subplot(7,2,12)
                        plot(Time,rie(:,1),'r');
                        hold on
                        plot(Time,rie(:,2),'b');
                        title(strcat('Right arm internal-external rotation with flexion ',' RMSE peaks = ',num2str(rmse2)))
                        scatter(kloc,pkinect,'r*')
                        scatter(wloc,pwise,'b*')
                        ylabel('Joint angle (degrees)')
                        xlabel('Time (seconds)')
                        hold off
                end
                
            case markers(14)
                
                rie(rie>=500) = NaN;
                [Row] = find(isnan(rie(:,1)));
                rie(Row,:) = [];
                Time(length(rie)+1:length(Time)) = [];
                figure(1)
                subplot(7,2,14)
                hold on
                plot(Time,rie(:,2),'b');
                title(strcat('Right arm internal-external rotation with abduction'))
                ylabel('Joint angle (degrees)')
                xlabel('Time (seconds)')
                hold off
                
                
        end
    fclose(fid);
    end
    end

   end 
end

