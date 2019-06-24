

clc
clear all
close all
cd('F:\github\wearable-jacket\matlab\kinect+imudata\')
addpath('F:\github\wearable-jacket\matlab\kinect+imudata\')
markers = ["lef","lbd","lelb","lelb1","lps","lie","lie1","ref","rbd","relb","relb1","rps","rie","rie1"];
markers1 = ["flex-ext","abd-add","","lelb1","lps","lie","lie1","ref","rbd","relb","relb1","rps","rie","rie1"];
subjectID = ["1330","1390","1490","1430","1950","1660","1160","1970","1580","1440","1110","1770","1250","1240","1610","1840","1130","1490","1940","1390","1410","1710","1380","1630"];
list = dir();
spike_files=dir('*.txt');

%
%fprintf( fid, '%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s\n','Timestamp','Kinect left shoulder flex.-ext.',...
% 'WISE left shoulder flex.-ext.','Kinect left shoulder abd.-add.','WISE left shoulder abd.-add.','Kinect left shoulder int.- ext.',...
% 'WISE left shoulder int.- ext.','Kinect left elbow flex.-ext.','WISE left elbow flex.-ext.','WISE left forearm pro.- sup.',...
% 'Kinect right shoulder flex.-ext.','WISE right shoulder flex.-ext.','Kinect right shoulder Abd.-Add.','WISE right shoulder abd.-add.',...
% 'Kinect right shoulder int.-ext.','WISE right shoulder int.-ext.','Kinect right elbow flex.-ext.','WISE right elbow flex.-ext.',...
% 'WISE right forearm pro.-sup.');

for i = 1:length(spike_files)
    f1 = strsplit(spike_files(i).name,'.');
    f2 = strsplit(string(f1(1)),'_');
    if f2(2) == "WISE+KINECT" && f2.length()>=4
        sid = f2(1);
        if f2.length()==4
        typ = f2(4);
        end
        if f2.length()>=5
            typ = f2(5);
        end
        tf = strcat('F:\github\wearable-jacket\matlab\kinect+imudata\dataanalysis\',sid);
        trfile = strcat(tf,'.txt');
        fid = fopen(trfile,'a+');
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
        
        switch(typ)
            
            case markers(1)
                [pkinect,kloc] = findpeaks(lfe(:,1),'MinPeakDistance',10,'MinPeakHeight',40,'NPeaks',8);
                [pwise,wloc] = findpeaks(lfe(:,2),'MinPeakDistance',10,'MinPeakHeight',40,'NPeaks',8);
%                 rmse1 = sqrt(immse(lfe(:,1),lfe(:,2)));
                rmse1 = signal_RMSE(lfe(:,1),lfe(:,2));
                if size(pwise,1)~=0 && size(pkinect,1)~=0
                        for j=1:min(size(pwise,1),size(pkinect,1))
                            fprintf(fid,"%s,%s,%s,%s,%s\n",typ,string(j),string(pkinect(j)),string(pwise(j)),string(rmse1));
                        end
                clearvars pkinect pwise wloc kloc rmse1
                end
            case markers(2)
                [pkinect,kloc] = findpeaks(lbd(:,1),'MinPeakDistance',10,'MinPeakHeight',40,'NPeaks',8);
                [pwise,wloc] = findpeaks(lbd(:,2),'MinPeakDistance',10,'MinPeakHeight',40,'NPeaks',8); 
%                 rmse1 = sqrt(immse(lbd(:,1),lbd(:,2)));
                rmse1 = signal_RMSE(lbd(:,1),lbd(:,2));
                if size(pwise,1)~=0 && size(pkinect,1)~=0
                        for j=1:min(size(pwise,1),size(pkinect,1))
                            fprintf(fid,"%s,%s,%s,%s,%s\n",typ,string(j),string(pkinect(j)),string(pwise(j)),string(rmse1));
                        end
                clearvars pkinect pwise wloc kloc rmse1
                end
            case markers(3)
                [pkinect,kloc] = findpeaks(lelbfe(:,1),'MinPeakDistance',10,'MinPeakHeight',40,'NPeaks',8);
                [pwise,wloc] = findpeaks(lelbfe(:,2),'MinPeakDistance',10,'MinPeakHeight',40,'NPeaks',8); 
                rmse1 = signal_RMSE(lelbfe(:,1),lelbfe(:,2));
                figure
                plot(lelbfe(:,1));
                hold on
                plot(lelbfe(:,2));
                title('Left forearm Flexion-Extension')
                hold off
                if size(pwise,1)~=0 && size(pkinect,1)~=0
                        for j=1:min(size(pwise,1),size(pkinect,1))
                            fprintf(fid,"%s,%s,%s,%s,%s\n",typ,string(j),string(pkinect(j)),string(pwise(j)),string(rmse1));
                        end
                clearvars pkinect pwise wloc kloc rmse1
                end
            case markers(4)
                [pkinect,kloc] = findpeaks(lelbfe(:,1),'MinPeakDistance',10,'MinPeakHeight',40,'NPeaks',8);
                [pwise,wloc] = findpeaks(lelbfe(:,2),'MinPeakDistance',10,'MinPeakHeight',40,'NPeaks',8);          
                rmse1 = signal_RMSE(lelbfe(:,1),lelbfe(:,2));
                figure
                plot(lelbfe(:,1));
                hold on
                plot(lelbfe(:,2));
                title('Left forearm Flexion-Extension 1')
                hold off
                if size(pwise,1)~=0 && size(pkinect,1)~=0
                        for j=1:min(size(pwise,1),size(pkinect,1))
                            fprintf(fid,"%s,%s,%s,%s,%s\n",typ,string(j),string(pkinect(j)),string(pwise(j)),string(rmse1));
                        end
                clearvars pkinect pwise wloc kloc rmse1
                end
            case markers(5)
                [pwise,wloc] = findpeaks(lfps(:,1),'MinPeakDistance',10,'MinPeakHeight',40,'NPeaks',8);         
                rmse1 = 0;
                if size(pwise,1)~=0
                        for j=1:size(pwise,1)
                            fprintf(fid,"%s,%s,%s,%s\n",typ,string(j),string(pwise(j)),string(rmse1));
                        end
                clearvars pkinect pwise wloc kloc rmse1
                end
            case markers(6)
                [pkinect,kloc] = findpeaks(lie(:,1),'MinPeakDistance',10,'MinPeakHeight',40,'NPeaks',8);
                [pwise,wloc] = findpeaks(lie(:,2),'MinPeakDistance',10,'MinPeakHeight',40,'NPeaks',8);         
                rmse1 = signal_RMSE(lie(:,1),lie(:,2));
                if size(pwise,1)~=0 && size(pkinect,1)~=0
                        for j=1:min(size(pwise,1),size(pkinect,1))
                            fprintf(fid,"%s,%s,%s,%s,%s\n",typ,string(j),string(pkinect(j)),string(pwise(j)),string(rmse1));
                        end
                clearvars pkinect pwise wloc kloc rmse1
                end
            case markers(7)
                [pkinect,kloc] = findpeaks(lie(:,1),'MinPeakDistance',10,'MinPeakHeight',40,'NPeaks',8);
                [pwise,wloc] = findpeaks(lie(:,2),'MinPeakDistance',10,'MinPeakHeight',40,'NPeaks',8);      
                rmse1 = signal_RMSE(lie(:,1),lie(:,2));
                if size(pwise,1)~=0 && size(pkinect,1)~=0
                        for j=1:min(size(pwise,1),size(pkinect,1))
                            fprintf(fid,"%s,%s,%s,%s,%s\n",typ,string(j),string(pkinect(j)),string(pwise(j)),string(rmse1));
                        end
                clearvars pkinect pwise wloc kloc rmse1
                end
            case markers(8)
                [pkinect,kloc] = findpeaks(rfe(:,1),'MinPeakDistance',10,'MinPeakHeight',40,'NPeaks',8);
                [pwise,wloc] = findpeaks(rfe(:,2),'MinPeakDistance',10,'MinPeakHeight',40,'NPeaks',8);      
                rmse1 = signal_RMSE(rfe(:,1),rfe(:,2));
                if size(pwise,1)~=0 && size(pkinect,1)~=0
                        for j=1:min(size(pwise,1),size(pkinect,1))
                            fprintf(fid,"%s,%s,%s,%s,%s\n",typ,string(j),string(pkinect(j)),string(pwise(j)),string(rmse1));
                        end
                clearvars pkinect pwise wloc kloc rmse1
                end
                figure
                plot(rfe(:,1));
                hold on
                plot(rfe(:,2));
                title('Right Shoulder Extension Flexion')
                hold off
            case markers(9)
                [pkinect,kloc] = findpeaks(rbd(:,1),'MinPeakDistance',10,'MinPeakHeight',40,'NPeaks',8);
                [pwise,wloc] = findpeaks(rbd(:,2),'MinPeakDistance',10,'MinPeakHeight',40,'NPeaks',8);  
                rmse1 = signal_RMSE(rbd(:,1),rbd(:,2));
                if size(pwise,1)~=0 && size(pkinect,1)~=0
                        for j=1:min(size(pwise,1),size(pkinect,1))
                            fprintf(fid,"%s,%s,%s,%s,%s\n",typ,string(j),string(pkinect(j)),string(pwise(j)),string(rmse1));
                        end
                clearvars pkinect pwise wloc kloc rmse1
                end
                figure
                plot(rbd(:,1));
                hold on
                plot(rbd(:,2));
                title('Right Shoulder Abduction-adduction')
                hold off
            case markers(10)
                [pkinect,kloc] = findpeaks(relbfe(:,1),'MinPeakDistance',10,'MinPeakHeight',40,'NPeaks',8);
                [pwise,wloc] = findpeaks(relbfe(:,2),'MinPeakDistance',10,'MinPeakHeight',40,'NPeaks',8);        
                rmse1 = signal_RMSE(relbfe(:,1),relbfe(:,2));
                if size(pwise,1)~=0 && size(pkinect,1)~=0
                        for j=1:min(size(pwise,1),size(pkinect,1))
                            fprintf(fid,"%s,%s,%s,%s,%s\n",typ,string(j),string(pkinect(j)),string(pwise(j)),string(rmse1));
                        end
                clearvars pkinect pwise wloc kloc rmse1
                end
                figure
                plot(relbfe(:,1));
                hold on
                plot(relbfe(:,2));
                title('Right Elbow flexion-extension')
                hold off
            case markers(11)
                [pkinect,kloc] = findpeaks(relbfe(:,1),'MinPeakDistance',10,'MinPeakHeight',40,'NPeaks',8);
                [pwise,wloc] = findpeaks(relbfe(:,2),'MinPeakDistance',10,'MinPeakHeight',40,'NPeaks',8);    
                rmse1 = signal_RMSE(relbfe(:,1),relbfe(:,2));
                if size(pwise,1)~=0 && size(pkinect,1)~=0
                        for j=1:min(size(pwise,1),size(pkinect,1))
                            fprintf(fid,"%s,%s,%s,%s,%s\n",typ,string(j),string(pkinect(j)),string(pwise(j)),string(rmse1));
                        end
                clearvars pkinect pwise wloc kloc rmse1
                end
            case markers(12)
                [pwise,wloc] = findpeaks(rfps(:,1),'MinPeakDistance',10,'MinPeakHeight',40,'NPeaks',8);      
                rmse1 = 0;
                if size(pwise,1)~=0
                        for j=1:size(pwise,1)
                            fprintf(fid,"%s,%s,%s,%s\n",typ,string(j),string(pwise(j)),string(rmse1));
                        end
                clearvars pkinect pwise wloc kloc rmse1
                end
            case markers(13)
                [pkinect,kloc] = findpeaks(rie(:,1),'MinPeakDistance',10,'MinPeakHeight',40,'NPeaks',8);
                [pwise,wloc] = findpeaks(rie(:,2),'MinPeakDistance',10,'MinPeakHeight',40,'NPeaks',8); 
                rmse1 = signal_RMSE(rie(:,1),rie(:,2));
                if size(pwise,1)~=0 && size(pkinect,1)~=0
                        for j=1:min(size(pwise,1),size(pkinect,1))
                            fprintf(fid,"%s,%s,%s,%s,%s\n",typ,string(j),string(pkinect(j)),string(pwise(j)),string(rmse1));
                        end
                clearvars pkinect pwise wloc kloc rmse1
                end

            case markers(14)
                [pkinect,kloc] = findpeaks(rie(:,1),'MinPeakDistance',10,'MinPeakHeight',40,'NPeaks',8);
                [pwise,wloc] = findpeaks(rie(:,2),'MinPeakDistance',10,'MinPeakHeight',40,'NPeaks',8);    
                rmse1 = signal_RMSE(rie(:,1),rie(:,2));
                if size(pwise,1)~=0 && size(pkinect,1)~=0
                        for j=1:min(size(pwise,1),size(pkinect,1))
                            fprintf(fid,"%s,%s,%s,%s,%s\n",typ,string(j),string(pkinect(j)),string(pwise(j)),string(rmse1));
                        end
                clearvars pkinect pwise wloc kloc rmse1
                end
        end

            fclose(fid);
    end

    
end



