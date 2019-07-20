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
figure(1)
sgtitle(strcat(num2str(SID),' Kinect+WISE',' errors vs angles'));


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
        
        switch(typ)
            
            case markers(1)
                k = 1;
                Merr = 0;
                angles = [];
                Merrors = [];
                ind = [];
                err = abs(lfe(:,1)-lfe(:,2));
                IMUref = lfe(:,2);
                size(IMUref)
                
                while ~isempty(err)
                    ind = find(IMUref(:)==IMUref(1));
                    angles(k,1) = IMUref(1);
                    for a=1:length(ind)
                        Merr = Merr + err(ind(a));
                    end
                    Merrors(k,1) = Merr/length(ind);
                    Merr = 0;
                    k = k+1;
                    for a=1:length(ind)
                        err(ind(a)) = [];
                        IMUref(ind(a)) =  [];
                    end
                    ind = [];
                end
                
                AngErr = [angles,Merrors];
%                 AngErr = sortrows(AngErr,1);
                
                figure(1)
%                 subplot(7,2,1)
                polarplot(AngErr(:,1)*pi/180,AngErr(:,2),'*');
                hold on
                title('Left arm flexion-extension')
%                 ylabel('Joint angle (degrees)')
%                 xlabel('Time (seconds)')
                hold off    
                
         %{      
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
                
                lie(lie==666) = NaN;
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
                
            case markers(7)
                
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
                
                rie(rie==666) = NaN;
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
                
            case markers(14)
                
                figure(1)
                subplot(7,2,14)
                hold on
                plot(Time,rie(:,2),'b');
                title(strcat('Right arm internal-external rotation with abduction'))
                ylabel('Joint angle (degrees)')
                xlabel('Time (seconds)')
                hold off
                
                 %}
        end
               
    fclose(fid);
    end
    end

   end 
end

