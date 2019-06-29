clc;clear all;
markers = ["lef","lbd","lelb","lelb1","lps","lie","lie1","ref","rbd","relb","relb1","rps","rie","rie1"];
addpath('F:\github\wearable-jacket\matlab\WISE_KNT')
% addpath('C:\Users\fabio\github\wearable-jacket\matlab\WISE_KNT') % fabio address
cd(strcat('F:\github\wearable-jacket\matlab\kinect+imudata\'));
% cd(strcat('C:\Users\fabio\github\wearable-jacket\matlab\kinect+imudata\',num2str(SID))); % fabio address
list = dir();
SID = size(list,1);
N = 1;
% Timeglobal = zeros(N,1);
% Timeieglobal = zeros(N,1);
lfeglobal = zeros(N,2);
lbdglobal = zeros(N,2);
lieglobal = zeros(N,2);
lelbfeglobal = zeros(N,2);
lelbfe1global = zeros(N,2);
rfeglobal = zeros(N,2);
rbdglobal = zeros(N,2);
rieglobal = zeros(N,2);
relbfeglobal = zeros(N,2);
relbfe1global = zeros(N,2);


for i=1:size(list,1)
     SID(i) = str2double(list(i).name);
end
SID(isnan(SID)) = [];
clearvars i;
for i=1:length(SID)
cd(strcat('F:\github\wearable-jacket\matlab\kinect+imudata\',num2str(SID(i))));
spike_files=dir('*.txt');
for k = 1:length(spike_files)
    f1 = strsplit(spike_files(k).name,'.');
    f2 = strsplit(string(f1(1)),'_');
    if length(f2)>=2
%         disp('Inside length if');
    if f2(2) == "WISE+KINECT" && f2(1)==num2str(SID(i))
        if f2.length()>=5 && f2(3)== "testing"
            typ = f2(5);
            data = importWISEKINECT(spike_files(k).name);
            len = size(data,1);
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
                lfeglobal = [lfeglobal;lfe];
            case markers(2)
                lbdglobal = [lbdglobal;lbd];
            case markers(3)
                lelbfeglobal = [lelbfeglobal;lelbfe];
            case markers(4)
                lelbfe1global = [lelbfe1global;lelbfe];
            case markers(5)
                
            case markers(6)
                lie(lie>=500) = NaN;
                [Row] = find(isnan(lie(:,1)));
                lie(Row,:) = [];
                lieglobal = [lieglobal;lie];
            case markers(7)
                
            case markers(8)
                rfeglobal = [rfeglobal;rfe];
            case markers(9)
                rbdglobal = [rbdglobal;rbd];
            case markers(10)
                relbfeglobal = [relbfeglobal;relbfe];
            case markers(11)
                relbfe1global = [relbfe1global;relbfe];
            case markers(12)
                
            case markers(13)
                rie(rie>=500) = NaN;
                [Row] = find(isnan(rie(:,1)));
                rie(Row,:) = [];
                rieglobal = [rieglobal;lie];
            case markers(14)
                
        end
 
        end
    end
    end
end
    

end



%%
