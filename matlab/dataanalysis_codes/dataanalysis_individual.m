
clc;clear all;close all
markers = ["lef","lbd","lelb","lelb1","lie","ref","rbd","relb","relb1","rie"];
subjectID = ["1330","1390","1490","1430","1950","1660","1160","1970","1580","1440","1110","1770","1250","1240","1610","1840","1130","1490","1940","1390","1410","1710","1380","1630"];
SID = 78456;




addpath('F:\github\wearable-jacket\matlab\WISE_KNT')
% addpath('C:\Users\fabio\github\wearable-jacket\matlab\WISE_KNT') % fabio address
cd(strcat('F:\github\wearable-jacket\matlab\kinect+imudata\',num2str(SID)));
addpath('F:\github\wearable-jacket\matlab\WISE_KNT')
% addpath('C:\Users\fabio\github\wearable-jacket\matlab\WISE_KNT') % fabio address
cd(strcat('F:\github\wearable-jacket\matlab\kinect+imudata\',num2str(SID)));
% cd(strcat('C:\Users\fabio\github\wearable-jacket\matlab\kinect+imudata\',num2str(SID))); % fabio address

list = dir();
spike_files=dir('*.txt');
smoovar = 2;
figure(1)
sgtitle(strcat(num2str(SID),' Kinect+WISE'));
Nd = 20;
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
        rfe = zeros(len-1,2);
        rbd = zeros(len-1,2);
        rie = zeros(len-1,2);
        relbfe = zeros(len-1,2);
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
        delnumarr = find(round(Time)==10);
        lie(1:delnumarr(1),:) = [];
        lfe(1:delnumarr(1),:) = [];
        lbd(1:delnumarr(1),:) = [];
        lelbfe(1:delnumarr(1),:) = [];
        rfe(1:delnumarr(1),:) = [];
        rbd(1:delnumarr(1),:) = [];
        rie(1:delnumarr(1),:) = [];
        relbfe(1:delnumarr(1),:) = [];
        Time(length(lie)+1:length(Time))=[];
        smoovar = ceil(length(Time)/Time(length(Time)));
        fopen(trfile,'a+');

        
        switch(typ)
            
            case markers(1)
                diff = zeros(length(lfe));
                diff = lfe(:,1)-lfe(:,2);
                N = find(abs(diff)>=Nd);
                lfe(N,:) = [];
                Time(length(lfe)+1:length(Time)) = [];
                figure(1)
                subplot(5,2,1)
                plot(Time,lfe(:,1),'r');
                hold on
                plot(Time,lfe(:,2),'b');
                title('Left arm flexion-extension')
                legend('Kinect','WISE')
                ylabel('Joint angle (degrees)')
                xlabel('Time (seconds)')
                hold off    
                lfe(:,1) = smooth(lfe(:,1),smoovar);
                lfe(:,2) = smooth(lfe(:,2),smoovar);
                rmse1 = signal_RMSE(lfe(:,1),lfe(:,2));
                figure(2)
                hold on
                subplot(5,2,1)
                plot(Time,abs(lfe(:,1)-lfe(:,2)),'k');
                title(strcat('Left arm flexion-extension ',' RMSE = ',num2str(rmse1)))
                ylabel('Error angle (degrees)')
                xlabel('Time (seconds)')
                hold off
                [pkinect,kloc] = findpeaks(lfe(:,1),Time,'MinPeakHeight',80,'MinPeakProminence',50,'NPeaks',7);
                [pwise,wloc] = findpeaks(lfe(:,2),Time,'MinPeakHeight',80,'MinPeakProminence',50,'NPeaks',7);
                figure(3)
                subplot(5,2,1)
                plot(Time,lfe(:,1),'r');
                hold on
                plot(Time,lfe(:,2),'b');
                hold off
                if size(pwise,1)>=2 && size(pkinect,1)>=2
                    rmse2 = signal_RMSE(pkinect(1:7),pwise(1:7));
                        for j=1:7
                            fprintf(fid,"%s,%s,%s,%s,%s\n",typ,string(j),string(pkinect(j)),string(pwise(j)),string(rmse1));
                        end
                        figure(3)
                        subplot(5,2,1)
                        hold on
                        scatter(kloc,pkinect,'r*')
                        scatter(wloc,pwise,'b*')
                        title(strcat('Left arm flexion-extension ',' RMSE peaks = ',num2str(rmse2)))
                        legend('Kinect','WISE')
                        ylabel('Joint angle (degrees)')
                        xlabel('Time (seconds)')
                        hold off
                end
               
            case markers(2)
                diff = zeros(length(lbd));
                diff = lbd(:,1)-lbd(:,2);
                N = find(abs(diff)>=Nd);
                lbd(N,:) = [];
                Time(length(lbd)+1:length(Time)) = [];
                figure(1)
                subplot(5,2,3)
                plot(Time,lbd(:,1),'r');
                hold on
                plot(Time,lbd(:,2),'b');
                title('Left arm abduction-adduction')
                ylabel('Joint angle (degrees)')
                xlabel('Time (seconds)')
                hold off
                lbd(:,1) = smooth(lbd(:,1),smoovar);
                lbd(:,2) = smooth(lbd(:,2),smoovar);
                rmse1 = signal_RMSE(lbd(:,1),lbd(:,2));
                figure(2)
                hold on
                subplot(5,2,3)
                plot(Time,abs(lbd(:,1)-lbd(:,2)),'k');
                title(strcat(' Left arm abduction-adduction ',' RMSE = ',num2str(rmse1)))
                ylabel('Error angle (degrees)')
                xlabel('Time (seconds)')
                hold off
                [pkinect,kloc] = findpeaks(lbd(:,1),Time,'MinPeakHeight',80,'MinPeakProminence',50,'NPeaks',7);
                [pwise,wloc] = findpeaks(lbd(:,2),Time,'MinPeakHeight',80,'MinPeakProminence',50,'NPeaks',7);
                figure(3)
                subplot(5,2,3)
                plot(Time,lbd(:,1),'r');
                hold on
                plot(Time,lbd(:,2),'b');
                if size(pwise,1)>=2 && size(pkinect,1)>=2
                    rmse2 = signal_RMSE(pkinect(1:7),pwise(1:7));
                        for j=1:7
                            fprintf(fid,"%s,%s,%s,%s,%s\n",typ,string(j),string(pkinect(j)),string(pwise(j)),string(rmse1));
                        end
                        figure(3)
                        subplot(5,2,3)
                        hold on
                        title(strcat('Left arm abduction-adduction ',' RMSE peaks = ',num2str(rmse2)))
                        scatter(kloc,pkinect,'r*')
                        scatter(wloc,pwise,'b*')
                        ylabel('Joint angle (degrees)')
                        xlabel('Time (seconds)')
                        hold off
                end
                
            case markers(3)
                diff = zeros(length(lelbfe));
                diff = lelbfe(:,1)-lelbfe(:,2);
                N = find(abs(diff)>=Nd);
                lelbfe(N,:) = [];
                Time(length(lelbfe)+1:length(Time)) = [];
                figure(1)
                subplot(5,2,5)
                plot(Time,lelbfe(:,1),'r');
                hold on
                plot(Time,lelbfe(:,2),'b');
                title(strcat('Left forearm Flexion-Extension without abduction'))
                ylabel('Joint angle (degrees)')
                xlabel('Time (seconds)')
                hold off
                lelbfe(:,1) = smooth(lelbfe(:,1),smoovar);
                lelbfe(:,2) = smooth(lelbfe(:,2),smoovar);                
                rmse1 = signal_RMSE(lelbfe(:,1),lelbfe(:,2));
                figure(2)
                hold on
                subplot(5,2,5)
                plot(Time,abs(lelbfe(:,1)-lelbfe(:,2)),'k');
                title(strcat('Left forearm Flexion-Extension without abduction ',' RMSE = ',num2str(rmse1)))
                ylabel('Error angle (degrees)')
                xlabel('Time (seconds)')
                hold off
                figure(3)
                subplot(5,2,5)
                plot(Time,lelbfe(:,1),'r');
                hold on
                plot(Time,lelbfe(:,2),'b');
                [pkinect,kloc] = findpeaks(lelbfe(:,1),Time,'MinPeakHeight',80,'MinPeakProminence',50,'NPeaks',7);
                [pwise,wloc] = findpeaks(lelbfe(:,2),Time,'MinPeakHeight',80,'MinPeakProminence',50,'NPeaks',7);
                
                if size(pwise,1)>=2 && size(pkinect,1)>=2
                    signal_RMSE(pkinect(1:7),pwise(1:7));
                        for j=1:7
                            fprintf(fid,"%s,%s,%s,%s,%s\n",typ,string(j),string(pkinect(j)),string(pwise(j)),string(rmse1));
                        end
                        figure(3)
                        subplot(5,2,5)
                        hold on
                        title(strcat('Left forearm flexion-extension without abduction ',' RMSE peaks = ',num2str(rmse2)))
                        scatter(kloc,pkinect,'r*')
                        scatter(wloc,pwise,'b*')
                        ylabel('Joint angle (degrees)')
                        xlabel('Time (seconds)')
                        hold off
                end
               
            case markers(4)
                diff = zeros(length(lelbfe));
                diff = lelbfe(:,1)-lelbfe(:,2);
                N = find(abs(diff)>=Nd);
                lelbfe(N,:) = [];
                Time(length(lelbfe)+1:length(Time)) = [];
                figure(1)
                subplot(5,2,7)
                plot(Time,lelbfe(:,1),'r');
                hold on
                plot(Time,lelbfe(:,2),'b');
                title(strcat('Left forearm flexion-extension with abduction')) 
                ylabel('Joint angle (degrees)')
                xlabel('Time (seconds)')
                hold off
                lelbfe(:,1) = smooth(lelbfe(:,1),smoovar);
                lelbfe(:,2) = smooth(lelbfe(:,2),smoovar);  
                rmse1 = signal_RMSE(lelbfe(:,1),lelbfe(:,2));
                figure(2)
                hold on
                subplot(5,2,7)
                plot(Time,abs(lelbfe(:,1)-lelbfe(:,2)),'k');
                title(strcat('Left forearm flexion-extension without abduction ',' RMSE = ',num2str(rmse1)))
                ylabel('Error angle (degrees)')
                xlabel('Time (seconds)')
                hold off
                
                [pkinect,kloc] = findpeaks(lelbfe(:,1),Time,'MinPeakHeight',80,'MinPeakProminence',50,'NPeaks',7);
                [pwise,wloc] = findpeaks(lelbfe(:,2),Time,'MinPeakHeight',80,'MinPeakProminence',50,'NPeaks',7);
                figure(3)
                subplot(5,2,7)
                plot(Time,lelbfe(:,1),'r');
                hold on
                plot(Time,lelbfe(:,2),'b');

                hold off        
                if size(pwise,1)>=2 && size(pkinect,1)>=2
                    signal_RMSE(pkinect(1:7),pwise(1:7));
                        for j=1:7
                            fprintf(fid,"%s,%s,%s,%s,%s\n",typ,string(j),string(pkinect(j)),string(pwise(j)),string(rmse1));
                        end
                        figure(3)
                        subplot(5,2,7)
                        hold on
                        title(strcat('Left forearm flexion-extension with abduction ',' RMSE peaks = ',num2str(rmse2)))
                        scatter(kloc,pkinect,'r*')
                        scatter(wloc,pwise,'b*')
                        ylabel('Joint angle (degrees)')
                        xlabel('Time (seconds)')
                        hold off
                end
                
                
            case markers(5)
                
                lie(lie>=500) = NaN;
                [Row] = find(isnan(lie(:,1)));
                lie(Row,:) = [];
                diff = zeros(length(lie));
                diff = lie(:,1)-lie(:,2);
                N = find(abs(diff)>=Nd);
                lie(N,:) = [];
                Time(length(lie)+1:length(Time)) = [];
                figure(1)
                subplot(5,2,9)
                plot(Time,lie(:,1),'r');
                hold on
                plot(Time,lie(:,2),'b');
                title(strcat('Left arm internal-external rotation with flexion'))
                ylabel('Joint angle (degrees)')
                xlabel('Time (seconds)')
                hold off
                lie(:,1) = smooth(lie(:,1),smoovar);
                lie(:,2) = smooth(lie(:,2),smoovar); 
                rmse1 = signal_RMSE(lie(:,1),lie(:,2));
                figure(2)
                hold on
                subplot(5,2,9)
                plot(Time,abs(lie(:,1)-lie(:,2)),'k');
                title(strcat('Left arm internal-external rotation with flexion ',' RMSE = ',num2str(rmse1)))
                ylabel('Error angle (degrees)')
                xlabel('Time (seconds)')
                figure(3)
                subplot(5,2,9)
                plot(Time,lie(:,1),'r');
                hold on
                plot(Time,lie(:,2),'b');
                [pkinect,kloc] = findpeaks(lie(:,1),Time,'MinPeakHeight',20,'NPeaks',7,'MinPeakProminence',20);
                [pwise,wloc] = findpeaks(lie(:,2),Time,'MinPeakHeight',20,'NPeaks',7,'MinPeakProminence',20);
                var = min(length(pwise),length(pkinect));
                if size(pwise,1)>=2 && size(pkinect,1)>=2
                   signal_RMSE(pkinect(1:var),pwise(1:var));
                        for j=1:var
                            fprintf(fid,"%s,%s,%s,%s,%s\n",typ,string(j),string(pkinect(j)),string(pwise(j)),string(rmse1));
                        end
                        figure(3)
                        subplot(5,2,9)
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
                
            case markers(6)
                diff = zeros(length(rfe));
                diff = rfe(:,1)-rfe(:,2);
                N = find(abs(diff)>=Nd);
                rfe(N,:) = [];
                Time(length(rfe)+1:length(Time)) = [];
                figure(1)
                subplot(5,2,2)
                plot(Time,rfe(:,1),'r');
                hold on
                plot(Time,rfe(:,2),'b');
                title(strcat('Right arm flexion extension'))
                ylabel('Joint angle (degrees)')
                xlabel('Time (seconds)')
                hold off
                rfe(:,1) = smooth(rfe(:,1),smoovar);
                rfe(:,2) = smooth(rfe(:,2),smoovar); 
                rmse1 = signal_RMSE(rfe(:,1),rfe(:,2));
                figure(2)
                hold on
                subplot(5,2,2)
                plot(Time,abs(rfe(:,1)-rfe(:,2)),'k');
                title(strcat('Right arm flexion extension ',' RMSE = ',num2str(rmse1)))
                ylabel('Error angle (degrees)')
                xlabel('Time (seconds)')
                hold off
                figure(3)
                subplot(5,2,2)
                plot(Time,rfe(:,1),'r');
                hold on
                plot(Time,rfe(:,2),'b');
                [pkinect,kloc] = findpeaks(rfe(:,1),Time,'MinPeakHeight',80,'MinPeakProminence',50,'NPeaks',7);
                [pwise,wloc] = findpeaks(rfe(:,2),Time,'MinPeakHeight',80,'MinPeakProminence',50,'NPeaks',7);
                var = min(length(pwise),length(pkinect));
                if size(pwise,1)>=2 && size(pkinect,1)>=2
                    rmse2 = signal_RMSE(pkinect(1:var),pwise(1:var));
                        for j=1:var
                            fprintf(fid,"%s,%s,%s,%s,%s\n",typ,string(j),string(pkinect(j)),string(pwise(j)),string(rmse1));
                        end
                        figure(3)
                        subplot(5,2,2)
                        hold on
                        title(strcat('Right arm flexion extension ',' RMSE peaks = ',num2str(rmse2)))
                        scatter(kloc,pkinect,'r*')
                        scatter(wloc,pwise,'b*')
                        ylabel('Joint angle (degrees)')
                        xlabel('Time (seconds)')
                        hold off
                end
                
            case markers(7)
                diff = zeros(length(rbd));
                diff = rbd(:,1)-rbd(:,2);
                N = find(abs(diff)>=Nd);
                rbd(N,:) = [];
                Time(length(rbd)+1:length(Time)) = [];
                figure(1)
                subplot(5,2,4)
                plot(Time,rbd(:,1),'r');
                hold on
                plot(Time,rbd(:,2),'b');
                title(strcat('Right arm abduction-adduction'))
                ylabel('Joint angle (degrees)')
                xlabel('Time (seconds)')
                hold off   
                rbd(:,1) = smooth(rbd(:,1),smoovar);
                rbd(:,2) = smooth(rbd(:,2),smoovar); 
                rmse1 = signal_RMSE(rbd(:,1),rbd(:,2));
                figure(2)
                hold on
                subplot(5,2,4)
                plot(Time,abs(rbd(:,1)-rbd(:,2)),'k');
                title(strcat('Right arm abduction-adduction ',' RMSE = ',num2str(rmse1)))
                ylabel('Error angle (degrees)')
                xlabel('Time (seconds)')
                hold off
                figure(3)
                subplot(5,2,4)
                plot(Time,rbd(:,1),'r');
                hold on
                plot(Time,rbd(:,2),'b');
                [pkinect,kloc] = findpeaks(rbd(:,1),Time,'MinPeakHeight',80,'MinPeakProminence',50,'NPeaks',7);
                [pwise,wloc] = findpeaks(rbd(:,2),Time,'MinPeakHeight',80,'MinPeakProminence',50,'NPeaks',7);
                
                if size(pwise,1)>=2 && size(pkinect,1)>=2
%                     signal_RMSE(pkinect(1:7),pwise(1:7));
%                         for j=1:7
%                             fprintf(fid,"%s,%s,%s,%s,%s\n",typ,string(j),string(pkinect(j)),string(pwise(j)),string(rmse1));
%                         end
                        figure(3)
                        subplot(5,2,4)
                        hold on
                        title(strcat('Right arm abduction-adduction ',' RMSE peaks = ',num2str(rmse2)))
                        scatter(kloc,pkinect,'r*')
                        scatter(wloc,pwise,'b*')
                        ylabel('Joint angle (degrees)')
                        xlabel('Time (seconds)')
                        hold off
                end
                
            case markers(8)
                diff = zeros(length(relbfe));
                diff = relbfe(:,1)-relbfe(:,2);
                N = find(abs(diff)>=Nd);
                relbfe(N,:) = [];
                Time(length(relbfe)+1:length(Time)) = [];
                figure(1)
                subplot(5,2,6)
                plot(Time,relbfe(:,1),'r');
                hold on
                plot(Time,relbfe(:,2),'b');
                title(strcat('Right forearm flexion-extension without abduction'))
                ylabel('Joint angle (degrees)')
                xlabel('Time (seconds)')
                hold off
                relbfe(:,1) = smooth(relbfe(:,1),smoovar);
                relbfe(:,2) = smooth(relbfe(:,2),smoovar); 
                rmse1 = signal_RMSE(relbfe(:,1),relbfe(:,2));
                figure(2)
                hold on
                subplot(5,2,6)
                plot(Time,abs(relbfe(:,1)-relbfe(:,2)),'k');
                title(strcat('Right forearm flexion-extension without abduction ',' RMSE = ',num2str(rmse1)))
                ylabel('Error angle (degrees)')
                xlabel('Time (seconds)')
                hold off
                figure(3)
                subplot(5,2,6)
                plot(Time,relbfe(:,1),'r');
                hold on
                plot(Time,relbfe(:,2),'b');
                [pkinect,kloc] = findpeaks(relbfe(:,1),Time,'MinPeakHeight',80,'MinPeakProminence',50,'NPeaks',7);
                [pwise,wloc] = findpeaks(relbfe(:,2),Time,'MinPeakHeight',80,'MinPeakProminence',50,'NPeaks',7);
                
                if size(pwise,1)>=2 && size(pkinect,1)>=2
                        rmse2 = signal_RMSE(pkinect(1:7),pwise(1:7));
                        for j=1:7
                            fprintf(fid,"%s,%s,%s,%s,%s\n",typ,string(j),string(pkinect(j)),string(pwise(j)),string(rmse1));
                        end
                        figure(3)
                        subplot(5,2,6)
                        hold on
                        title(strcat('Right forearm flexion-extension without abduction ',' RMSE peaks = ',num2str(rmse2)))
                        scatter(kloc,pkinect,'r*')
                        scatter(wloc,pwise,'b*')
                        ylabel('Joint angle (degrees)')
                        xlabel('Time (seconds)')
                        hold off
                end
                
            case markers(9)
                diff = zeros(length(relbfe));
                diff = relbfe(:,1)-relbfe(:,2);
                N = find(abs(diff)>=Nd);
                relbfe(N,:) = [];
                Time(length(relbfe)+1:length(Time)) = [];
                figure(1)
                subplot(5,2,8)
                plot(Time,relbfe(:,1),'r');
                hold on
                plot(Time,relbfe(:,2),'b');
                title(strcat('Right elbow flexion-extension with abduction'))
                ylabel('Joint angle (degrees)')
                xlabel('Time (seconds)')
                hold off
                relbfe(:,1) = smooth(relbfe(:,1),smoovar);
                relbfe(:,2) = smooth(relbfe(:,2),smoovar); 
                rmse1 = signal_RMSE(relbfe(:,1),relbfe(:,2));
                figure(2)
                hold on
                subplot(5,2,8)
                plot(Time,abs(relbfe(:,1)-relbfe(:,2)),'k');
                title(strcat('Right elbow flexion-extension with abduction ',' RMSE = ',num2str(rmse1)))
                ylabel('Error angle (degrees)')
                xlabel('Time (seconds)')
                hold off
                
                [pkinect,kloc] = findpeaks(relbfe(:,1),Time,'MinPeakHeight',80,'MinPeakProminence',50,'NPeaks',7);
                [pwise,wloc] = findpeaks(relbfe(:,2),Time,'MinPeakHeight',80,'MinPeakProminence',50,'NPeaks',7);
                figure(3)
                subplot(5,2,8)
                plot(Time,relbfe(:,1),'r');
                hold on
                plot(Time,relbfe(:,2),'b');
                if size(pwise,1)>=2 && size(pkinect,1)>=2
                    rmse2 = signal_RMSE(pkinect(1:7),pwise(1:7));
                        for j=1:7
                            fprintf(fid,"%s,%s,%s,%s,%s\n",typ,string(j),string(pkinect(j)),string(pwise(j)),string(rmse1));
                        end
                        figure(3)
                        subplot(5,2,8)
                        hold on
                        title(strcat('Right elbow flexion-extension with abduction ',' RMSE peaks = ',num2str(rmse2)))
                        scatter(kloc,pkinect,'r*')
                        scatter(wloc,pwise,'b*')
                        ylabel('Joint angle (degrees)')
                        xlabel('Time (seconds)')
                        hold off
                end
                
                
            case markers(10)
                
                rie(rie>=500) = NaN;
                [Row] = find(isnan(rie(:,1)));
                rie(Row,:) = [];
                diff = zeros(length(rie));
                diff = rie(:,1)-rie(:,2);
                N = find(abs(diff)>=Nd);
                rie(N,:) = [];
                Time(length(rie)+1:length(Time)) = [];
                figure(1)
                subplot(5,2,10)
                plot(Time,rie(:,1),'r');
                hold on
                plot(Time,rie(:,2),'b');
                title(strcat('Right arm internal-external rotation with flexion'))
                ylabel('Joint angle (degrees)')
                xlabel('Time (seconds)')
                hold off
                rie(:,1) = smooth(rie(:,1),smoovar);
                rie(:,2) = smooth(rie(:,2),smoovar); 
                rmse1 = signal_RMSE(rie(:,1),rie(:,2));
                figure(2)
                hold on
                subplot(5,2,10)
                plot(Time,abs(rie(:,1)-rie(:,2)),'k');
                title(strcat('Right arm internal-external rotation with flexion ',' RMSE = ',num2str(rmse1)))
                ylabel('Error angle (degrees)')
                xlabel('Time (seconds)')
                hold off
                figure(3)
                subplot(5,2,10)
                plot(Time,rie(:,1),'r');
                hold on
                plot(Time,rie(:,2),'b');
                [pkinect,kloc] = findpeaks(rie(:,1),Time,'MinPeakHeight',20,'NPeaks',7,'MinPeakProminence',20);
                [pwise,wloc] = findpeaks(rie(:,2),Time,'MinPeakHeight',20,'NPeaks',7,'MinPeakProminence',20);
                var = min(length(pwise),length(pkinect));
                if size(pwise,1)>=2 && size(pkinect,1)>=2
                    
                        rmse2 = signal_RMSE(pkinect(1:var),pwise(1:var));
                        for j=1:var
                            fprintf(fid,"%s,%s,%s,%s,%s\n",typ,string(j),string(pkinect(j)),string(pwise(j)),string(rmse1));
                        end
                        figure(3)
                        subplot(5,2,10)
                        title(strcat('Right arm internal-external rotation with flexion ',' RMSE peaks = ',num2str(rmse2)))
                        scatter(kloc,pkinect,'r*')
                        scatter(wloc,pwise,'b*')
                        ylabel('Joint angle (degrees)')
                        xlabel('Time (seconds)')
                        hold off
                end
                
                
                
        end
        clearvars diff pkinect pwise kloc ploc
    fclose(fid);
    end
    end

   end 
end

