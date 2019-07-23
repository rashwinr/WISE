
clc;clear all;close all
markers = ["lie","rie"];
SID = 97171;

addpath('F:\github\wearable-jacket\matlab\WISE_KNT')
% addpath('C:\Users\fabio\github\wearable-jacket\matlab\WISE_KNT') % fabio address
cd(strcat('F:\github\wearable-jacket\matlab\kinect+imudata\',num2str(SID)));
addpath('F:\github\wearable-jacket\matlab\dataanalysis_codes')
% addpath('C:\Users\fabio\github\wearable-jacket\matlab\WISE_KNT') % fabio address
cd(strcat('F:\github\wearable-jacket\matlab\kinect+imudata\',num2str(SID)));
% cd(strcat('C:\Users\fabio\github\wearable-jacket\matlab\kinect+imudata\',num2str(SID))); % fabio address

list = dir();
spike_files=dir('*.txt');
smoovar = 2;
figure(1)
sgtitle(strcat(num2str(SID),' Kinect+WISE'));
Nd = 500;
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
        fopen(trfile,'a+');

        
        switch(typ)
            

            case markers(1)
                
                lie(lie>=500) = NaN;
                [Row] = find(isnan(lie(:,1)));
                lie(Row,:) = [];
                [Row1] = find(isnan(lie(:,2)));
                lie(Row1,:) = [];
                diff = zeros(length(lie));diff = lie(:,1)-lie(:,2);
                N = find(abs(diff)>=Nd);
                lie(N,:) = [];
                Time(length(lie)+1:length(Time)) = [];
                Zerokinectpos = find(round(lie(:,1)/10)==0);
                min1kinectpos = find(round(lie(:,1)/10)==-1);
                pls1kinectpos = find(round(lie(:,1)/10)==+1);
                ZeroIMUval = mean(lie([Zerokinectpos;min1kinectpos;pls1kinectpos],2));
                lie(:,2) = lie(:,2)-ZeroIMUval;
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
                if size(pwise,1)>=7 && size(pwise,1)>=7
                   rmse2 = signal_RMSE(pkinect(1:var),pwise(1:var));
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

            case markers(2)
                
                rie(rie>=500) = NaN;
                [Row] = find(isnan(rie(:,1)));
                rie(Row,:) = [];
                [Row1] = find(isnan(rie(:,2)));
                rie(Row1,:) = [];
                diff = zeros(length(rie));
                diff = rie(:,1)-rie(:,2);
                N = find(abs(diff)>=Nd);
                rie(N,:) = [];
                Time(length(rie)+1:length(Time)) = [];
                Zerokinectpos = find(round(rie(:,1)/10)==0);
                min1kinectpos = find(round(rie(:,1)/10)==-1);
                pls1kinectpos = find(round(rie(:,1)/10)==+1);
                ZeroIMUval = mean(rie([Zerokinectpos;min1kinectpos;pls1kinectpos],2));
                rie(:,2) = rie(:,2)-ZeroIMUval;
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
                if size(pwise,1)>=7 && size(pwise,1)>=7
                    
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
        clearvars diff pkinect pwise kloc ploc ZeroIMUpos ZeroIMUval zerokinval Zerokinectpos
    fclose(fid);
    end
    end

   end 
end

