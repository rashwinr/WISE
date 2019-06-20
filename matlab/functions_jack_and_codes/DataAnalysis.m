

clc
clear all
close all
cd('F:\github\wearable-jacket\matlab\kinect+imudata\')
addpath('F:\github\wearable-jacket\matlab\kinect+imudata\')
markers = ["lef","lbd","lelb","lelb1","lps","lie","lie1","ref","rbd","relb","relb1","rps","rie","rie1"];
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
    if f2(2) == "WISE+KINECT" && f2.length()==4
        sid = f2(1);
        typ = f2(4);
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
        switch(arg)
            
            case markers(1)
                
            case markers(2)
                
            case markers(3)
                
            case markers(4)
                
            case markers(5)
                
            case markers(6)
                
            case markers(7)
                
            case markers(8)
                
            case markers(9)
                
            case markers(10)
                
            case markers(11)
                
            case markers(12)
            
            case markers(13)
                
            case markers(14)
                
        end
    end
    
end



