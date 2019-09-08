
clc;clear all;close all
markers = ["lef","lbd","lelb","lelb1","lie","ref","rbd","relb","relb1","rie"];
addpath('F:\github\wearable-jacket\matlab\data_analysis_codes')
Ndef = 30;Ndbd = 30;Ndelb = 40;Ndie = 25;Ndelb1 = 30;smoovar = 2;
subjectID = [312,2064,2463,2990,3154,3162,3380,3409,3581,3689,5837,6219,6339,6525,7612,9053,9717];
for fu=1:length(subjectID)

SID = subjectID(fu);

% addpath('C:\Users\fabio\github\wearable-jacket\matlab\WISE_KNT') % fabio address
cd(strcat('F:\github\wearable-jacket\matlab\kinect+imudata\',num2str(SID)));

% addpath('C:\Users\fabio\github\wearable-jacket\matlab\WISE_KNT') % fabio address
cd(strcat('F:\github\wearable-jacket\matlab\kinect+imudata\',num2str(SID)));
% cd(strcat('C:\Users\fabio\github\wearable-jacket\matlab\kinect+imudata\',num2str(SID))); % fabio address

list = dir();
spike_files=dir('*.txt');

figure(1)
sgtitle(strcat(num2str(SID),' Kinect+WISE'));

figure(2)
sgtitle(strcat(num2str(SID),' Error signal'));

figure(3)
sgtitle(strcat(num2str(SID),' Peaks'));

tf = strcat(num2str(SID),'_dtw_normalized');
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
        delnumarr = find(round(Time)==12);
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
        fid = fopen(trfile,'a+');

        
        switch(typ)
            
            case markers(1)
                mk = max(lfe(:,1));
                mi = max(lfe(:,2));
                [~,X,Y] = dtw(lfe(:,1)/mk,lfe(:,2)/mi,2);
                Time1 = 0:Time(length(Time))/length(X):Time(length(Time));
                Time1(length(Time1))=[];
                lfe_dtw = zeros(length(X),2);
                lfe_dtw(:,1) = smooth(lfe(X,1),smoovar);
                lfe_dtw(:,2) = smooth(lfe(Y,2),smoovar);
                figure(1)
                subplot(5,2,1)
                plot(Time1,lfe_dtw(:,1),'r');
                hold on
                plot(Time1,lfe_dtw(:,2),'b');
                title('Left arm flexion-extension')
                legend('Kinect','WISE')
                ylabel('Joint angle (degrees)')
                xlabel('Time (seconds)')
                hold off    
                rmse1 = signal_RMSE(lfe_dtw(:,1),lfe_dtw(:,2));
                figure(2)
                hold on
                subplot(5,2,1)
                plot(Time1,abs(lfe_dtw(:,1)-lfe_dtw(:,2)),'k');
                title(strcat('Left arm flexion-extension ',' RMSE = ',num2str(rmse1)))
                ylabel('Error angle (degrees)')
                xlabel('Time (seconds)')
                hold off
                [pkinect,kloc] = findpeaks(lfe_dtw(:,1),Time1,'MinPeakHeight',80,'MinPeakProminence',50,'NPeaks',7);
                [pwise,wloc] = findpeaks(lfe_dtw(:,2),Time1,'MinPeakHeight',80,'MinPeakProminence',50,'NPeaks',7);
                [p,k] = findpeaks(-lfe_dtw(:,1),Time1,'MinPeakHeight',-40,'MinPeakProminence',50,'NPeaks',8);
                [p1,l] = findpeaks(-lfe_dtw(:,1),'MinPeakHeight',-40,'MinPeakProminence',50,'NPeaks',8);
                var = (min(min(length(pwise),length(pkinect)),length(p)));
                rmse2 = signal_RMSE(pkinect(1:var),pwise(1:var));
                figure(3)
                subplot(5,2,1)
                plot(Time1,lfe_dtw(:,1),'r');
                hold on
                plot(Time1,lfe_dtw(:,2),'b');
                hold off
                for j=1:var
                    fprintf(fid,"%s,%s,%s,%s,%s\n",typ,strcat('P',string(j)),string(pkinect(j)),string(pwise(j)),string(p(j)));
                end
                        figure(3)
                        subplot(5,2,1)
                        hold on
                        scatter(kloc,pkinect,'r*')
                        scatter(wloc,pwise,'b*')
                        scatter(k,-p,'k*')
                        title(strcat('Left arm flexion-extension ',' RMSE peaks = ',num2str(rmse2)))
                        legend('Kinect','WISE')
                        ylabel('Joint angle (degrees)')
                        xlabel('Time (seconds)')
                        hold off
                rmse_trial = zeros(length(l)+2,1);
                rmse_trial(1) = signal_RMSE(lfe_dtw(1:l(1),1),lfe_dtw(1:l(1),2));
                for j=1:length(l)-1
                   rmse_trial(j+1) =  signal_RMSE(lfe_dtw(l(j):l(j+1),1),lfe_dtw(l(j):l(j+1),2));
                end
                rmse_trial(j+2) = signal_RMSE(lfe_dtw(l(j+1):length(lfe_dtw),1),lfe_dtw(l(j+1):length(lfe_dtw),2));
                for j=1:length(rmse_trial)
                    fprintf(fid,"%s,%s,%s\n",typ,strcat('R',string(j)),string(rmse_trial(j)));
                end
                fprintf(fid,"%s,%s,%s,%s,%s\n",typ,'RMSE signal: ',num2str(rmse1),'RMSE peaks: ',num2str(rmse2));
                clearvars pwise pkinect kloc wloc p k p1 l  rmse_trial rmse1 rmse2 var diff
                
            case markers(2)
                mk = max(lbd(:,1));
                mi = max(lbd(:,2));
                [~,X,Y] = dtw(lbd(:,1)/mk,lbd(:,2)/mi,2);
                Time1 = 0:Time(length(Time))/length(X):Time(length(Time));
                Time1(length(Time1))=[];
                lbd_dtw = zeros(length(X),2);
                lbd_dtw(:,1) = smooth(lbd(X,1),smoovar);
                lbd_dtw(:,2) = smooth(lbd(Y,2),smoovar);
                figure(1)
                subplot(5,2,3)
                plot(Time1,lbd_dtw(:,1),'r');
                hold on
                plot(Time1,lbd_dtw(:,2),'b');
                title('Left arm abduction-adduction')
                ylabel('Joint angle (degrees)')
                xlabel('Time (seconds)')
                hold off
                rmse1 = signal_RMSE(lbd(:,1),lbd(:,2));
                figure(2)
                hold on
                subplot(5,2,3)
                plot(Time1,abs(lbd_dtw(:,1)-lbd_dtw(:,2)),'k');
                title(strcat(' Left arm abduction-adduction ',' RMSE = ',num2str(rmse1)))
                ylabel('Error angle (degrees)')
                xlabel('Time (seconds)')
                hold off
                [pkinect,kloc] = findpeaks(lbd_dtw(:,1),Time1,'MinPeakHeight',80,'MinPeakProminence',50,'NPeaks',7);
                [pwise,wloc] = findpeaks(lbd_dtw(:,2),Time1,'MinPeakHeight',80,'MinPeakProminence',50,'NPeaks',7);
                [p,k] = findpeaks(-lbd_dtw(:,1),Time1,'MinPeakHeight',-20,'MinPeakProminence',50,'NPeaks',8);
                [p1,l] = findpeaks(-lbd_dtw(:,1),'MinPeakHeight',-20,'MinPeakProminence',50,'NPeaks',8);
                figure(3)
                subplot(5,2,3)
                plot(Time1,lbd_dtw(:,1),'r');
                hold on
                plot(Time1,lbd_dtw(:,2),'b');
                var = (min(min(length(pwise),length(pkinect)),length(p)));
                rmse2 = signal_RMSE(pkinect(1:var),pwise(1:var));
                        for j=1:var
                            fprintf(fid,"%s,%s,%s,%s,%s\n",typ,strcat('P',string(j)),string(pkinect(j)),string(pwise(j)),string(p(j)));
                        end
                        figure(3)
                        subplot(5,2,3)
                        hold on
                        title(strcat('Left arm abduction-adduction ',' RMSE peaks = ',num2str(rmse2)))
                        scatter(kloc,pkinect,'r*')
                        scatter(wloc,pwise,'b*')
                        scatter(k,-p,'k*')
                        ylabel('Joint angle (degrees)')
                        xlabel('Time (seconds)')
                        hold off
                rmse_trial = zeros(length(l)+2,1);
                rmse_trial(1) = signal_RMSE(lbd_dtw(1:l(1),1),lbd_dtw(1:l(1),2));
                for j=1:length(l)-1
                   rmse_trial(j+1) =  signal_RMSE(lbd_dtw(l(j):l(j+1),1),lbd_dtw(l(j):l(j+1),2));
                end
                rmse_trial(j+2) = signal_RMSE(lbd_dtw(l(j+1):length(lbd_dtw),1),lbd_dtw(l(j+1):length(lbd_dtw),2));
                for j=1:length(rmse_trial)
                    fprintf(fid,"%s,%s,%s\n",typ,strcat('R',string(j)),string(rmse_trial(j)));
                end
                fprintf(fid,"%s,%s,%s,%s,%s\n",typ,'RMSE signal: ',num2str(rmse1),'RMSE peaks: ',num2str(rmse2));
                clearvars pwise pkinect kloc wloc p k p1 l  rmse_trial rmse1 rmse2 var diff
                
            case markers(3)
                lelbfe(lelbfe>=200) = NaN;
                [Row] = find(isnan(lelbfe(:,2)));
                lelbfe(Row,:) = [];
                Time(length(lelbfe)+1:length(Time)) = [];
                mk = max(lelbfe(:,1));
                mi = max(lelbfe(:,2));
                [~,X,Y] = dtw(lelbfe(:,1)/mk,lelbfe(:,2)/mi,2);
                Time1 = 0:Time(length(Time))/length(X):Time(length(Time));
                Time1(length(Time1))=[];
                lelbfe_dtw = zeros(length(X),2);
                lelbfe_dtw(:,1) = smooth(lelbfe(X,1),smoovar);
                lelbfe_dtw(:,2) = smooth(lelbfe(Y,2),smoovar);
                figure(1)
                subplot(5,2,5)
                plot(Time1,lelbfe_dtw(:,1),'r');
                hold on
                plot(Time1,lelbfe_dtw(:,2),'b');
                title(strcat('Left forearm Flexion-Extension without abduction'))
                ylabel('Joint angle (degrees)')
                xlabel('Time (seconds)')
                hold off              
                rmse1 = signal_RMSE(lelbfe_dtw(:,1),lelbfe_dtw(:,2));
                figure(2)
                hold on
                subplot(5,2,5)
                plot(Time1,abs(lelbfe_dtw(:,1)-lelbfe_dtw(:,2)),'k');
                title(strcat('Left forearm Flexion-Extension without abduction ',' RMSE = ',num2str(rmse1)))
                ylabel('Error angle (degrees)')
                xlabel('Time (seconds)')
                hold off
                figure(3)
                subplot(5,2,5)
                plot(Time1,lelbfe_dtw(:,1),'r');
                hold on
                plot(Time1,lelbfe_dtw(:,2),'b');
                [pkinect,kloc] = findpeaks(lelbfe_dtw(:,1),Time1,'MinPeakHeight',80,'MinPeakProminence',50,'NPeaks',7);
                [pwise,wloc] = findpeaks(lelbfe_dtw(:,2),Time1,'MinPeakHeight',80,'MinPeakProminence',50,'NPeaks',7);
                [p,k] = findpeaks(-lelbfe_dtw(:,1),Time1,'MinPeakHeight',-40,'MinPeakProminence',50,'NPeaks',8);
                [p1,l] = findpeaks(-lelbfe_dtw(:,1),'MinPeakHeight',-40,'MinPeakProminence',50,'NPeaks',8);
                var = (min(min(length(pwise),length(pkinect)),length(p)));
                rmse2 = signal_RMSE(pkinect(1:var),pwise(1:var));
                        for j=1:var
                            fprintf(fid,"%s,%s,%s,%s,%s\n",typ,strcat('P',string(j)),string(pkinect(j)),string(pwise(j)),string(p(j)));
                        end
                        figure(3)
                        subplot(5,2,5)
                        hold on
                        title(strcat('Left forearm flexion-extension without abduction ',' RMSE peaks = ',num2str(rmse2)))
                        scatter(kloc,pkinect,'r*')
                        scatter(wloc,pwise,'b*')
                        scatter(k,-p,'k*')
                        ylabel('Joint angle (degrees)')
                        xlabel('Time (seconds)')
                        hold off
                rmse_trial = zeros(length(l)+2,1);
                rmse_trial(1) = signal_RMSE(lelbfe_dtw(1:l(1),1),lelbfe_dtw(1:l(1),2)); 
                for j=1:length(l)-1
                   rmse_trial(j+1) =  signal_RMSE(lelbfe_dtw(l(j):l(j+1),1),lelbfe_dtw(l(j):l(j+1),2));
                end
                rmse_trial(j+2) = signal_RMSE(lelbfe_dtw(l(j+1):length(lelbfe_dtw),1),lelbfe_dtw(l(j+1):length(lelbfe_dtw),2));
                for j=1:length(rmse_trial)
                    fprintf(fid,"%s,%s,%s\n",typ,strcat('R',string(j)),string(rmse_trial(j)));
                end
                fprintf(fid,"%s,%s,%s,%s,%s\n",typ,'RMSE signal: ',num2str(rmse1),'RMSE peaks: ',num2str(rmse2));
                clearvars pwise pkinect kloc wloc p k p1 l  rmse_trial rmse1 rmse2 var diff
                
            case markers(4)
                lelbfe(lelbfe>=200) = NaN;
                [Row] = find(isnan(lelbfe(:,2)));
                lelbfe(Row,2) = lelbfe(Row,1);
                Time(length(lelbfe)+1:length(Time)) = [];
                mk = max(lelbfe(:,1));
                mi = max(lelbfe(:,2));
                [~,X,Y] = dtw(lelbfe(:,1)/mk,lelbfe(:,2)/mi,2);
                Time1 = 0:Time(length(Time))/length(X):Time(length(Time));
                Time1(length(Time1))=[];
                lelbfe_dtw = zeros(length(X),2);
                lelbfe_dtw(:,1) = smooth(lelbfe(X,1),smoovar);
                lelbfe_dtw(:,2) = smooth(lelbfe(Y,2),smoovar);
                figure(1)
                subplot(5,2,7)
                plot(Time1,lelbfe_dtw(:,1),'r');
                hold on
                plot(Time1,lelbfe_dtw(:,2),'b');
                title(strcat('Left forearm flexion-extension with abduction')) 
                ylabel('Joint angle (degrees)')
                xlabel('Time (seconds)')
                hold off
                rmse1 = signal_RMSE(lelbfe_dtw(:,1),lelbfe_dtw(:,2));
                figure(2)
                hold on
                subplot(5,2,7)
                plot(Time1,abs(lelbfe_dtw(:,1)-lelbfe_dtw(:,2)),'k');
                title(strcat('Left forearm flexion-extension without abduction ',' RMSE = ',num2str(rmse1)))
                ylabel('Error angle (degrees)')
                xlabel('Time (seconds)')
                hold off
                [pkinect,kloc] = findpeaks(lelbfe_dtw(:,1),Time1,'MinPeakHeight',80,'MinPeakProminence',50,'NPeaks',7);
                [pwise,wloc] = findpeaks(lelbfe_dtw(:,2),Time1,'MinPeakHeight',80,'MinPeakProminence',50,'NPeaks',7);
                [p,k] = findpeaks(-lelbfe_dtw(:,1),Time1,'MinPeakHeight',-40,'MinPeakProminence',50,'NPeaks',8);
                [p1,l] = findpeaks(-lelbfe_dtw(:,1),'MinPeakHeight',-40,'MinPeakProminence',50,'NPeaks',8);
                figure(3)
                subplot(5,2,7)
                plot(Time1,lelbfe_dtw(:,1),'r');
                hold on
                plot(Time1,lelbfe_dtw(:,2),'b');
                hold off        
                var = (min(min(length(pwise),length(pkinect)),length(p)));
                rmse2 = signal_RMSE(pkinect(1:var),pwise(1:var));
                        for j=1:var
                            fprintf(fid,"%s,%s,%s,%s,%s\n",typ,strcat('P',string(j)),string(pkinect(j)),string(pwise(j)),string(p(j)));
                        end
                        figure(3)
                        subplot(5,2,7)
                        hold on
                        title(strcat('Left forearm flexion-extension with abduction ',' RMSE peaks = ',num2str(rmse2)))
                        scatter(kloc,pkinect,'r*')
                        scatter(wloc,pwise,'b*')
                        scatter(k,-p,'k*')
                        ylabel('Joint angle (degrees)')
                        xlabel('Time (seconds)')
                        hold off
                rmse_trial = zeros(length(l)+2,1);
                rmse_trial(1) = signal_RMSE(lelbfe_dtw(1:l(1),1),lelbfe_dtw(1:l(1),2));
                for j=1:length(l)-1
                   rmse_trial(j+1) =  signal_RMSE(lelbfe_dtw(l(j):l(j+1),1),lelbfe_dtw(l(j):l(j+1),2));
                end
                rmse_trial(j+2) = signal_RMSE(lelbfe_dtw(l(j+1):length(lelbfe_dtw),1),lelbfe_dtw(l(j+1):length(lelbfe_dtw),2));
                for j=1:length(rmse_trial)
                    fprintf(fid,"%s,%s,%s\n",typ,strcat('R',string(j)),string(rmse_trial(j)));
                end
                fprintf(fid,"%s,%s,%s,%s,%s\n",typ,'RMSE signal: ',num2str(rmse1),'RMSE peaks: ',num2str(rmse2));
                clearvars pwise pkinect kloc wloc p k p1 l  rmse_trial rmse1 rmse2 var diff
                
            case markers(5)
                
                lie(lie>=500) = NaN;
                [Row] = find(isnan(lie(:,1)));
                lie(Row,:) = [];
                [Row1] = find(isnan(lie(:,2)));
                lie(Row1,:) = [];
                Zerokinectpos = find(round(lie(:,1)/10)==0);
                min1kinectpos = find(round(lie(:,1)/10)==-1);
                pls1kinectpos = find(round(lie(:,1)/10)==+1);
                ZeroIMUval = mean(lie([Zerokinectpos;min1kinectpos;pls1kinectpos],2));
                lie(:,2) = lie(:,2)-ZeroIMUval;
                Time(length(lie)+1:length(Time)) = [];
                mk = max(lie(:,1));
                mi = max(lie(:,2));
                [~,X,Y] = dtw(lie(:,1)/mk,lie(:,2)/mi,2);
                Time1 = 0:Time(length(Time))/length(X):Time(length(Time));
                Time1(length(Time1))=[];
                lie_dtw = zeros(length(X),2);
                lie_dtw(:,1) = smooth(lie(X,1),smoovar);
                lie_dtw(:,2) = smooth(lie(Y,2),smoovar);
                Time(length(lie_dtw)+1:length(Time)) = [];
                figure(1)
                subplot(5,2,9)
                plot(Time1,lie_dtw(:,1),'r');
                hold on
                plot(Time1,lie_dtw(:,2),'b');
                title(strcat('Left arm internal-external rotation with flexion'))
                ylabel('Joint angle (degrees)')
                xlabel('Time (seconds)')
                hold off
                rmse1 = signal_RMSE(lie_dtw(:,1),lie_dtw(:,2));
                figure(2)
                hold on
                subplot(5,2,9)
                plot(Time1,abs(lie_dtw(:,1)-lie_dtw(:,2)),'k');
                title(strcat('Left arm internal-external rotation with flexion ',' RMSE = ',num2str(rmse1)))
                ylabel('Error angle (degrees)')
                xlabel('Time (seconds)')
                figure(3)
                subplot(5,2,9)
                plot(Time1,lie_dtw(:,1),'r');
                hold on
                plot(Time1,lie_dtw(:,2),'b');
                [pkinect,kloc] = findpeaks(lie_dtw(:,1),Time1,'MinPeakHeight',20,'NPeaks',7,'MinPeakProminence',20);
                [pwise,wloc] = findpeaks(lie_dtw(:,2),Time1,'MinPeakHeight',20,'NPeaks',7,'MinPeakProminence',20);
                [p,k] = findpeaks(-lie_dtw(:,1),Time1,'MinPeakHeight',0,'MinPeakProminence',20,'NPeaks',8);
                [p1,l] = findpeaks(-lie_dtw(:,1),'MinPeakHeight',0,'MinPeakProminence',20,'NPeaks',8);
                var = (min(min(length(pwise),length(pkinect)),length(p)));
                rmse2 = signal_RMSE(pkinect(1:var),pwise(1:var));
                        for j=1:var
                            fprintf(fid,"%s,%s,%s,%s,%s\n",typ,strcat('P',string(j)),string(pkinect(j)),string(pwise(j)),string(p(j)));
                        end
                        figure(3)
                        subplot(5,2,9)
                        plot(Time1,lie_dtw(:,1),'r');
                        hold on
                        plot(Time1,lie_dtw(:,2),'b');
                        title(strcat('Left arm internal-external rotation with flexion ',' RMSE peaks = ',num2str(rmse2)))
                        scatter(kloc,pkinect,'r*')
                        scatter(wloc,pwise,'b*')
                        scatter(k,-p,'k*');
                        ylabel('Joint angle (degrees)')
                        xlabel('Time (seconds)')
                        hold off
                rmse_trial = zeros(length(l)+2,1);
                rmse_trial(1) = signal_RMSE(lie_dtw(1:l(1),1),lie_dtw(1:l(1),2));
                for j=1:length(l)-1
                   rmse_trial(j+1) =  signal_RMSE(lie_dtw(l(j):l(j+1),1),lie_dtw(l(j):l(j+1),2));
                end
                rmse_trial(j+2) = signal_RMSE(lie_dtw(l(j+1):length(lie_dtw),1),lie_dtw(l(j+1):length(lie_dtw),2));
                for j=1:length(rmse_trial)
                    fprintf(fid,"%s,%s,%s\n",typ,strcat('R',string(j)),string(rmse_trial(j)));
                end
                fprintf(fid,"%s,%s,%s,%s,%s\n",typ,'RMSE signal: ',num2str(rmse1),'RMSE peaks: ',num2str(rmse2));
                clearvars pwise pkinect kloc wloc p k p1 l  rmse_trial rmse1 rmse2 var diff
                
            case markers(6)
                mk = max(rfe(:,1));
                mi = max(rfe(:,2));
                [~,X,Y] = dtw(rfe(:,1)/mk,rfe(:,2)/mi,2);
                Time1 = 0:Time(length(Time))/length(X):Time(length(Time));
                Time1(length(Time1))=[];
                rfe_dtw = zeros(length(X),2);
                rfe_dtw(:,1) = smooth(rfe(X,1),smoovar);
                rfe_dtw(:,2) = smooth(rfe(Y,2),smoovar);
                figure(1)
                subplot(5,2,2)
                plot(Time1,rfe_dtw(:,1),'r');
                hold on
                plot(Time1,rfe_dtw(:,2),'b');
                title(strcat('Right arm flexion extension'))
                ylabel('Joint angle (degrees)')
                xlabel('Time (seconds)')
                hold off
                rmse1 = signal_RMSE(rfe_dtw(:,1),rfe_dtw(:,2));
                figure(2)
                hold on
                subplot(5,2,2)
                plot(Time1,abs(rfe_dtw(:,1)-rfe_dtw(:,2)),'k');
                title(strcat('Right arm flexion extension ',' RMSE = ',num2str(rmse1)))
                ylabel('Error angle (degrees)')
                xlabel('Time (seconds)')
                hold off
                figure(3)
                subplot(5,2,2)
                plot(Time1,rfe_dtw(:,1),'r');
                hold on
                plot(Time1,rfe_dtw(:,2),'b');
                [pkinect,kloc] = findpeaks(rfe_dtw(:,1),Time1,'MinPeakHeight',80,'MinPeakProminence',50,'NPeaks',7);
                [pwise,wloc] = findpeaks(rfe_dtw(:,2),Time1,'MinPeakHeight',80,'MinPeakProminence',50,'NPeaks',7);
                [p,k] = findpeaks(-rfe_dtw(:,1),Time1,'MinPeakHeight',-40,'MinPeakProminence',50,'NPeaks',8);
                [p1,l] = findpeaks(-rfe_dtw(:,1),'MinPeakHeight',-40,'MinPeakProminence',50,'NPeaks',8);
                var = (min(min(length(pwise),length(pkinect)),length(p)));
                    rmse2 = signal_RMSE(pkinect(1:var),pwise(1:var));
                        for j=1:var
                            fprintf(fid,"%s,%s,%s,%s,%s\n",typ,strcat('P',string(j)),string(pkinect(j)),string(pwise(j)),string(p(j)));
                        end
                        figure(3)
                        subplot(5,2,2)
                        hold on
                        title(strcat('Right arm flexion extension ',' RMSE peaks = ',num2str(rmse2)))
                        scatter(kloc,pkinect,'r*')
                        scatter(wloc,pwise,'b*')
                        scatter(k,-p,'k*')
                        ylabel('Joint angle (degrees)')
                        xlabel('Time (seconds)')
                        hold off
                rmse_trial = zeros(length(l)+2,1);
                rmse_trial(1) = signal_RMSE(rfe_dtw(1:l(1),1),rfe_dtw(1:l(1),2));
                for j=1:length(l)-1
                   rmse_trial(j+1) =  signal_RMSE(rfe_dtw(l(j):l(j+1),1),rfe_dtw(l(j):l(j+1),2));
                end
                rmse_trial(j+2) = signal_RMSE(rfe_dtw(l(j+1):length(rfe_dtw),1),rfe_dtw(l(j+1):length(rfe_dtw),2));
                for j=1:length(rmse_trial)
                    fprintf(fid,"%s,%s,%s\n",typ,strcat('R',string(j)),string(rmse_trial(j)));
                end
                fprintf(fid,"%s,%s,%s,%s,%s\n",typ,'RMSE signal: ',num2str(rmse1),'RMSE peaks: ',num2str(rmse2));
                clearvars pwise pkinect kloc wloc p k p1 l  rmse_trial rmse1 rmse2 var diff
                
            case markers(7)
                mk = max(rbd(:,1));
                mi = max(rbd(:,2));
                [~,X,Y] = dtw(rbd(:,1)/mk,rbd(:,2)/mi,2);
                Time1 = 0:Time(length(Time))/length(X):Time(length(Time));
                Time1(length(Time1))=[];
                rbd_dtw = zeros(length(X),2);
                rbd_dtw(:,1) = smooth(rbd(X,1),smoovar);
                rbd_dtw(:,2) = smooth(rbd(Y,2),smoovar);
                figure(1)
                subplot(5,2,4)
                plot(Time1,rbd_dtw(:,1),'r');
                hold on
                plot(Time1,rbd_dtw(:,2),'b');
                title(strcat('Right arm abduction-adduction'))
                ylabel('Joint angle (degrees)')
                xlabel('Time (seconds)')
                hold off   
                rmse1 = signal_RMSE(rbd_dtw(:,1),rbd_dtw(:,2));
                figure(2)
                hold on
                subplot(5,2,4)
                plot(Time1,abs(rbd_dtw(:,1)-rbd_dtw(:,2)),'k');
                title(strcat('Right arm abduction-adduction ',' RMSE = ',num2str(rmse1)))
                ylabel('Error angle (degrees)')
                xlabel('Time (seconds)')
                hold off
                figure(3)
                subplot(5,2,4)
                plot(Time1,rbd_dtw(:,1),'r');
                hold on
                plot(Time1,rbd_dtw(:,2),'b');
                [pkinect,kloc] = findpeaks(rbd_dtw(:,1),Time1,'MinPeakHeight',80,'MinPeakProminence',50,'NPeaks',7);
                [pwise,wloc] = findpeaks(rbd_dtw(:,2),Time1,'MinPeakHeight',80,'MinPeakProminence',50,'NPeaks',7);
                [p,k] = findpeaks(-rbd_dtw(:,1),Time1,'MinPeakHeight',-40,'MinPeakProminence',50,'NPeaks',8);
                [p1,l] = findpeaks(-rbd_dtw(:,1),'MinPeakHeight',-40,'MinPeakProminence',50,'NPeaks',8);
                var = (min(min(length(pwise),length(pkinect)),length(p)));
                rmse2 = signal_RMSE(pkinect(1:var),pwise(1:var));

                        for j=1:var
                            fprintf(fid,"%s,%s,%s,%s,%s\n",typ,strcat('P',string(j)),string(pkinect(j)),string(pwise(j)),string(p(j)));
                        end
                        figure(3)
                        subplot(5,2,4)
                        hold on
                        title(strcat('Right arm abduction-adduction ',' RMSE peaks = ',num2str(rmse2)))
                        scatter(kloc,pkinect,'r*')
                        scatter(wloc,pwise,'b*')
                        scatter(k,-p,'k*')
                        ylabel('Joint angle (degrees)')
                        xlabel('Time (seconds)')
                        
                        hold off
                rmse_trial = zeros(length(l)+2,1);
                rmse_trial(1) = signal_RMSE(rbd_dtw(1:l(1),1),rbd_dtw(1:l(1),2));
                for j=1:length(l)-1
                   rmse_trial(j+1) =  signal_RMSE(rbd_dtw(l(j):l(j+1),1),rbd_dtw(l(j):l(j+1),2));
                end
                rmse_trial(j+2) = signal_RMSE(rbd_dtw(l(j+1):length(rbd_dtw),1),rbd_dtw(l(j+1):length(rbd_dtw),2));
                for j=1:length(rmse_trial)
                    fprintf(fid,"%s,%s,%s\n",typ,strcat('R',string(j)),string(rmse_trial(j)));
                end
                fprintf(fid,"%s,%s,%s,%s,%s\n",typ,'RMSE signal: ',num2str(rmse1),'RMSE peaks: ',num2str(rmse2));
                clearvars pwise pkinect kloc wloc p k p1 l  rmse_trial rmse1 rmse2 var diff
                
            case markers(8)
                relbfe(relbfe>=200) = NaN;
                [Row] = find(isnan(relbfe(:,2)));
                relbfe(Row,:) = [];
                mk = max(relbfe(:,1));
                mi = max(relbfe(:,2));
                [~,X,Y] = dtw(relbfe(:,1)/mk,relbfe(:,2)/mi,2);
                Time1 = 0:Time(length(Time))/length(X):Time(length(Time));
                Time1(length(Time1))=[];
                relbfe_dtw = zeros(length(X),2);
                relbfe_dtw(:,1) = smooth(relbfe(X,1),smoovar);
                relbfe_dtw(:,2) = smooth(relbfe(Y,2),smoovar);
                figure(1)
                subplot(5,2,6)
                plot(Time1,relbfe_dtw(:,1),'r');
                hold on
                plot(Time1,relbfe_dtw(:,2),'b');
                title(strcat('Right forearm flexion-extension without abduction'))
                ylabel('Joint angle (degrees)')
                xlabel('Time (seconds)')
                hold off
                rmse1 = signal_RMSE(relbfe_dtw(:,1),relbfe_dtw(:,2));
                figure(2)
                hold on
                subplot(5,2,6)
                plot(Time1,abs(relbfe_dtw(:,1)-relbfe_dtw(:,2)),'k');
                title(strcat('Right forearm flexion-extension without abduction ',' RMSE = ',num2str(rmse1)))
                ylabel('Error angle (degrees)')
                xlabel('Time (seconds)')
                hold off
                figure(3)
                subplot(5,2,6)
                plot(Time1,relbfe_dtw(:,1),'r');
                hold on
                plot(Time1,relbfe_dtw(:,2),'b');
                [pkinect,kloc] = findpeaks(relbfe_dtw(:,1),Time1,'MinPeakHeight',80,'MinPeakProminence',50,'NPeaks',7);
                [pwise,wloc] = findpeaks(relbfe_dtw(:,2),Time1,'MinPeakHeight',80,'MinPeakProminence',50,'NPeaks',7);
                [p,k] = findpeaks(-relbfe_dtw(:,1),Time1,'MinPeakHeight',-40,'MinPeakProminence',50,'NPeaks',8);
                [p1,l] = findpeaks(-relbfe_dtw(:,1),'MinPeakHeight',-40,'MinPeakProminence',50,'NPeaks',8);
                var = (min(min(length(pwise),length(pkinect)),length(p)));
                rmse2 = signal_RMSE(pkinect(1:var),pwise(1:var));
                        for j=1:var
                            fprintf(fid,"%s,%s,%s,%s,%s\n",typ,strcat('P',string(j)),string(pkinect(j)),string(pwise(j)),string(p(j)));
                        end
                        figure(3)
                        subplot(5,2,6)
                        hold on
                        title(strcat('Right forearm flexion-extension without abduction ',' RMSE peaks = ',num2str(rmse2)))
                        scatter(kloc,pkinect,'r*')
                        scatter(wloc,pwise,'b*')
                        scatter(k,-p,'k*');
                        ylabel('Joint angle (degrees)')
                        xlabel('Time (seconds)')
                        hold off
                rmse_trial = zeros(length(l)+2,1);
                rmse_trial(1) = signal_RMSE(relbfe_dtw(1:l(1),1),relbfe_dtw(1:l(1),2));
                
                for j=1:length(l)-1
                   rmse_trial(j+1) =  signal_RMSE(relbfe_dtw(l(j):l(j+1),1),relbfe_dtw(l(j):l(j+1),2));
                end
                rmse_trial(j+2) = signal_RMSE(relbfe_dtw(l(j+1):length(relbfe_dtw),1),relbfe_dtw(l(j+1):length(relbfe_dtw),2));
                for j=1:length(rmse_trial)
                    fprintf(fid,"%s,%s,%s\n",typ,strcat('R',string(j)),string(rmse_trial(j)));
                end
                fprintf(fid,"%s,%s,%s,%s,%s\n",typ,'RMSE signal: ',num2str(rmse1),'RMSE peaks: ',num2str(rmse2));
                clearvars pwise pkinect kloc wloc p k p1 l  rmse_trial rmse1 rmse2 var diff
                                
            case markers(9)
                relbfe(relbfe>=200) = NaN;
                [Row] = find(isnan(relbfe(:,2)));
                relbfe(Row,2) = relbfe(Row,1);
                mk = max(relbfe(:,1));
                mi = max(relbfe(:,2));
                [~,X,Y] = dtw(relbfe(:,1)/mk,relbfe(:,2)/mi,2);
                Time1 = 0:Time(length(Time))/length(X):Time(length(Time));
                Time1(length(Time1))=[];
                relbfe_dtw = zeros(length(X),2);
                relbfe_dtw(:,1) = smooth(relbfe(X,1),smoovar);
                relbfe_dtw(:,2) = smooth(relbfe(Y,2),smoovar);
                figure(1)
                subplot(5,2,8)
                plot(Time,relbfe(:,1),'r');
                hold on
                plot(Time,relbfe(:,2),'b');
                title(strcat('Right elbow flexion-extension with abduction'))
                ylabel('Joint angle (degrees)')
                xlabel('Time (seconds)')
                hold off
                rmse1 = signal_RMSE(relbfe_dtw(:,1),relbfe_dtw(:,2));
                figure(2)
                hold on
                subplot(5,2,8)
                plot(Time1,abs(relbfe_dtw(:,1)-relbfe_dtw(:,2)),'k');
                title(strcat('Right elbow flexion-extension with abduction ',' RMSE = ',num2str(rmse1)))
                ylabel('Error angle (degrees)')
                xlabel('Time (seconds)')
                hold off
                [pkinect,kloc] = findpeaks(relbfe_dtw(:,1),Time1,'MinPeakHeight',80,'MinPeakProminence',50,'NPeaks',7);
                [pwise,wloc] = findpeaks(relbfe_dtw(:,2),Time1,'MinPeakHeight',80,'MinPeakProminence',50,'NPeaks',7);
                [p,k] = findpeaks(-relbfe_dtw(:,1),Time1,'MinPeakHeight',-40,'MinPeakProminence',50,'NPeaks',8);
                [p1,l] = findpeaks(-relbfe_dtw(:,1),'MinPeakHeight',-40,'MinPeakProminence',50,'NPeaks',8);
                figure(3)
                subplot(5,2,8)
                plot(Time1,relbfe_dtw(:,1),'r');
                hold on
                plot(Time1,relbfe_dtw(:,2),'b');
                var = (min(min(length(pwise),length(pkinect)),length(p)));
                rmse2 = signal_RMSE(pkinect(1:var),pwise(1:var));
                        for j=1:var
                            fprintf(fid,"%s,%s,%s,%s,%s\n",typ,strcat('P',string(j)),string(pkinect(j)),string(pwise(j)),string(p(j)));
                        end
                        figure(3)
                        subplot(5,2,8)
                        hold on
                        title(strcat('Right elbow flexion-extension with abduction ',' RMSE peaks = ',num2str(rmse2)))
                        scatter(kloc,pkinect,'r*')
                        scatter(wloc,pwise,'b*')
                        scatter(k,-p,'k*')
                        ylabel('Joint angle (degrees)')
                        xlabel('Time (seconds)')
                        hold off
                rmse_trial = zeros(length(l)+2,1);
                rmse_trial(1) = signal_RMSE(relbfe_dtw(1:l(1),1),relbfe_dtw(1:l(1),2));
                for j=1:length(l)-1
                   rmse_trial(j+1) =  signal_RMSE(relbfe_dtw(l(j):l(j+1),1),relbfe_dtw(l(j):l(j+1),2));
                end
                rmse_trial(j+2) = signal_RMSE(relbfe_dtw(l(j+1):length(relbfe_dtw),1),relbfe_dtw(l(j+1):length(relbfe_dtw),2));
                for j=1:length(rmse_trial)
                    fprintf(fid,"%s,%s,%s\n",typ,strcat('R',string(j)),string(rmse_trial(j)));
                end
                fprintf(fid,"%s,%s,%s,%s,%s\n",typ,'RMSE signal: ',num2str(rmse1),'RMSE peaks: ',num2str(rmse2));
                clearvars pwise pkinect kloc wloc p k p1 l  rmse_trial rmse1 rmse2 var diff
                
            case markers(10)
                
                rie(rie>=500) = NaN;
                [Row] = find(isnan(rie(:,1)));
                rie(Row,:) = [];
                [Row1] = find(isnan(rie(:,2)));
                rie(Row1,:) = [];
                Zerokinectpos = find(round(rie(:,1)/10)==0);
                min1kinectpos = find(round(rie(:,1)/10)==-1);
                pls1kinectpos = find(round(rie(:,1)/10)==+1);
                ZeroIMUval = mean(rie([Zerokinectpos;min1kinectpos;pls1kinectpos],2));
                rie(:,2) = rie(:,2)-ZeroIMUval;
                Time(length(rie)+1:length(Time)) = [];
                mk = max(rie(:,1));
                mi = max(rie(:,2));
                [~,X,Y] = dtw(rie(:,1)/mk,rie(:,2)/mi,2);
                Time1 = 0:Time(length(Time))/length(X):Time(length(Time));
                Time1(length(Time1))=[];
                rie_dtw = zeros(length(X),2);
                rie_dtw(:,1) = smooth(rie(X,1),smoovar);
                rie_dtw(:,2) = smooth(rie(Y,2),smoovar);
                figure(1)
                subplot(5,2,10)
                plot(Time1,rie_dtw(:,1),'r');
                hold on
                plot(Time1,rie_dtw(:,2),'b');
                title(strcat('Right arm internal-external rotation with flexion'))
                ylabel('Joint angle (degrees)')
                xlabel('Time (seconds)')
                hold off
                rmse1 = signal_RMSE(rie_dtw(:,1),rie_dtw(:,2));
                figure(2)
                hold on
                subplot(5,2,10)
                plot(Time1,abs(rie_dtw(:,1)-rie_dtw(:,2)),'k');
                title(strcat('Right arm internal-external rotation with flexion ',' RMSE = ',num2str(rmse1)))
                ylabel('Error angle (degrees)')
                xlabel('Time (seconds)')
                hold off
                figure(3)
                subplot(5,2,10)
                plot(Time1,rie_dtw(:,1),'r');
                hold on
                plot(Time1,rie_dtw(:,2),'b');
                [pkinect,kloc] = findpeaks(rie_dtw(:,1),Time1,'MinPeakHeight',20,'NPeaks',7,'MinPeakProminence',20);
                [pwise,wloc] = findpeaks(rie_dtw(:,2),Time1,'MinPeakHeight',20,'NPeaks',7,'MinPeakProminence',20);
                [p,k] = findpeaks(-rie_dtw(:,1),Time1,'MinPeakHeight',0,'MinPeakProminence',20,'NPeaks',8);
                [p1,l] = findpeaks(-rie_dtw(:,1),'MinPeakHeight',0,'MinPeakProminence',20,'NPeaks',8);
                var = (min(min(length(pwise),length(pkinect)),length(p)));
                rmse2 = signal_RMSE(pkinect(1:var),pwise(1:var));
                        for j=1:var
                            fprintf(fid,"%s,%s,%s,%s,%s\n",typ,strcat('P',string(j)),string(pkinect(j)),string(pwise(j)),string(p(j)));
                        end
                        figure(3)
                        subplot(5,2,10)
                        title(strcat('Right arm internal-external rotation with flexion ',' RMSE peaks = ',num2str(rmse2)))
                        scatter(kloc,pkinect,'r*')
                        scatter(wloc,pwise,'b*')
                        scatter(k,-p,'k*');
                        ylabel('Joint angle (degrees)')
                        xlabel('Time (seconds)')
                        hold off
                rmse_trial = zeros(length(l)+2,1);
                rmse_trial(1) = signal_RMSE(rie_dtw(1:l(1),1),rie_dtw(1:l(1),2));
                
                for j=1:length(l)-1
                   rmse_trial(j+1) =  signal_RMSE(rie_dtw(l(j):l(j+1),1),rie_dtw(l(j):l(j+1),2));
                end
                rmse_trial(j+2) = signal_RMSE(rie_dtw(l(j+1):length(rie_dtw),1),rie_dtw(l(j+1):length(rie_dtw),2));
                for j=1:length(rmse_trial)
                    fprintf(fid,"%s,%s,%s\n",typ,strcat('R',string(j)),string(rmse_trial(j)));
                end
                fprintf(fid,"%s,%s,%s,%s,%s\n",typ,'RMSE signal: ',num2str(rmse1),'RMSE peaks: ',num2str(rmse2));
                clearvars pwise pkinect kloc wloc p k p1 l  rmse_trial rmse1 rmse2 var diff
        end
    fclose(fid);
    end
    end

   end 
end
end



%%


%                 figure(4)
%                 subplot(5,1,2)
%                 hold on
% %                 title('Right arm shoulder flexion-extension','FontSize',15)
%                 xlim([0,50]);
% %                 xlabel('Time [s]','FontSize',15);
%                 ylabel('Angle [deg^o]','FontSize',15);
%                 A = plot(Time1,rbd_dtw(:,1),'r');
%                 B = plot(Time1,rbd_dtw(:,2),'b');
%                 scatter(kloc,pkinect,'r*')
%                 scatter(wloc,pwise,'b*')
%                 scatter(k,-p,'k*')
%                 hold off
