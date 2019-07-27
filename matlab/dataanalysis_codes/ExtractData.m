clc;clear all;close all
markers = ["lef","lbd","lelb","lelb1","lie","ref","rbd","relb","relb1","rie"];
subjectID = ["1330","1390","1490","1430","1950","1660","1160","1970","1580","1440","1110","1770","1250","1240","1610","1840","1130","1490","1940","1390","1410","1710","1380","1630"];
SID = 3380;
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
                Lfe = [lfe,Time];
                
            case markers(2)
                Lbd = [lbd,Time];
                
            case markers(3)
                Lelbfe = [lelbfe,Time];
                
            case markers(4)
                Lelbfe1 = [lelbfe,Time];

            case markers(5)
                
                lie(lie==666) = NaN;
                [Row,~] = find(isnan(lie));
                lie(Row,:) = [];
                T = Time;
                T(Row) = [];
                
                Lie = [lie,T];

            case markers(6)
                Rfe = [rfe,Time];
                
            case markers(7)
                Rbd = [rbd,Time];

            case markers(8)
                Relbfe = [relbfe,Time];

            case markers(9)
                Relbfe1 = [relbfe,Time];
     
            case markers(10)
                
                rie(rie==666) = NaN;
                [Row,~] = find(isnan(rie));
                rie(Row,:) = [];
                T = Time;
                T(Row) = [];
                
                Rie = [rie,T];
        end
       
    fclose(fid);
    end
    end

   end 
end

%% smooth Subplots of exercises 
SmoothSubPlot(SID,1,Lfe,Lbd,Lelbfe,Lelbfe1,Lie,Rfe,Rbd,Relbfe,Relbfe1,Rie)

%% RMSE plot
RMSEplot(SID,2,Lfe,Lbd,Lelbfe,Lelbfe1,Lie,Rfe,Rbd,Relbfe,Relbfe1,Rie)

%% Thoroid plot
% close all
span = 10;
ThorPlot(SID,3,span,Lfe,Lbd,Lelbfe,Lelbfe1,Lie,Rfe,Rbd,Relbfe,Relbfe1,Rie)