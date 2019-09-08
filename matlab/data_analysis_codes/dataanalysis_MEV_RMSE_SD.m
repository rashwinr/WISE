clc;clear all;
markers = ["lef","lbd","lelb","lelb1","lie","ref","rbd","relb","relb1","rie"];
addpath('F:\github\wearable-jacket\matlab\dataanalysis_codes')
% addpath('C:\Users\fabio\github\wearable-jacket\matlab\WISE_KNT') % fabio address
cd(strcat('F:\github\wearable-jacket\matlab\kinect+imudata\'));
% cd(strcat('C:\Users\fabio\github\wearable-jacket\matlab\kinect+imudata\',num2str(SID))); % fabio address
list = dir();
SID = size(list,1);
Nd = 30;
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
            data = importWISEKINECT1(spike_files(k).name);
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
            
        switch(typ)
            
            case markers(1)
                diff = zeros(length(lfe));
                diff = lfe(:,1)-lfe(:,2);
                Num = find(abs(diff)>=Nd);
                lfe(Num,:) = [];
                lfeglobal = [lfeglobal;lfe];
            case markers(2)
                diff = zeros(length(lbd));
                diff = lbd(:,1)-lbd(:,2);
                Num = find(abs(diff)>=Nd);
                lbd(Num,:) = [];
                lbdglobal = [lbdglobal;lbd];
            case markers(3)
                lelbfe(lelbfe>=200) = NaN;
                [Row] = find(isnan(lelbfe(:,2)));
                lelbfe(Row,:) = [];
                diff = zeros(length(lelbfe));
                diff = lelbfe(:,1)-lelbfe(:,2);
                Num = find(abs(diff)>=Nd);
                lelbfe(Num,:) = [];
                lelbfeglobal = [lelbfeglobal;lelbfe];
            case markers(4)
                lelbfe(lelbfe>=200) = NaN;
                [Row] = find(isnan(lelbfe(:,2)));
                lelbfe(Row,:) = [];
                diff = zeros(length(lelbfe));
                diff = lelbfe(:,1)-lelbfe(:,2);
                Num = find(abs(diff)>=Nd);
                lelbfe(Num,:) = [];
                lelbfe1global = [lelbfe1global;lelbfe];
            case markers(5)
                lie(lie>=500) = NaN;
                [Row] = find(isnan(lie(:,1)));
                lie(Row,:) = [];
                Zerokinectpos = find(round(lie(:,1)/10)==0);
                min1kinectpos = find(round(lie(:,1)/10)==-1);
                pls1kinectpos = find(round(lie(:,1)/10)==+1);
                ZeroIMUval = mean(lie([Zerokinectpos;min1kinectpos;pls1kinectpos],2));
                lie(:,2) = lie(:,2)-ZeroIMUval;
                diff = zeros(length(lie));diff = lie(:,1)-lie(:,2);
                Num = find(abs(diff)>=Nd);
                lie(Num,:) = [];
                lieglobal = [lieglobal;lie];
            case markers(6)
                diff = zeros(length(rfe));
                diff = rfe(:,1)-rfe(:,2);
                Num = find(abs(diff)>=Nd);
                rfe(Num,:) = [];
                rfeglobal = [rfeglobal;rfe];
            case markers(7)
                diff = zeros(length(rbd));
                diff = rbd(:,1)-rbd(:,2);
                Num = find(abs(diff)>=Nd);
                rbd(Num,:) = [];
                rbdglobal = [rbdglobal;rbd];
            case markers(8)
                relbfe(relbfe>=200) = NaN;
                [Row] = find(isnan(relbfe(:,2)));
                relbfe(Row,:) = [];
                diff = zeros(length(relbfe));
                diff = relbfe(:,1)-relbfe(:,2);
                Num = find(abs(diff)>=Nd);
                relbfe(Num,:) = [];
                relbfeglobal = [relbfeglobal;relbfe];
            case markers(9)
                relbfe(relbfe>=200) = NaN;
                [Row] = find(isnan(relbfe(:,2)));
                relbfe(Row,2) = relbfe(Row,1);
                diff = zeros(length(relbfe));
                diff = relbfe(:,1)-relbfe(:,2);
                Num = find(abs(diff)>=Nd);
                relbfe(Num,:) = [];
                relbfe1global = [relbfe1global;relbfe];
            case markers(10)
                rie(rie>=500) = NaN;
                [Row] = find(isnan(rie(:,1)));
                rie(Row,:) = [];
                Zerokinectpos = find(round(rie(:,1)/10)==0);
                min1kinectpos = find(round(rie(:,1)/10)==-1);
                pls1kinectpos = find(round(rie(:,1)/10)==+1);
                ZeroIMUval = mean(rie([Zerokinectpos;min1kinectpos;pls1kinectpos],2));
                rie(:,2) = rie(:,2)-ZeroIMUval;
                diff = zeros(length(rie));
                diff = rie(:,1)-rie(:,2);
                Num = find(abs(diff)>=Nd);
                rie(Num,:) = [];
                rieglobal = [rieglobal;rie];
                
        end
 
        end
    end
    end
end
    

end


%%

% [pkin,loc] = findpeaks(-lfeglobal(:,1),'MinPeakHeight',-10,'MinPeakProminence',100);

figure(1)

subplot(5,2,1)
hold on
title('Left shoulder Flexion-extension');
plot(lfeglobal(:,2));
plot(lfeglobal(:,1));
% scatter(loc,-pkin);
subplot(5,2,3)
hold on
title('Left shoulder Abduction-adduction');
plot(lbdglobal(:,2));
plot(lbdglobal(:,1));

subplot(5,2,5)
hold on
title('Left shoulder Internal-extension');
plot(lelbfeglobal(:,2));
plot(lelbfeglobal(:,1));

subplot(5,2,7)
hold on
title('Left elbow Flexion-extension');
plot(lelbfe1global(:,2));
plot(lelbfe1global(:,1));

subplot(5,2,9)
hold on
title('Left elbow internal-external rotation');
plot(lieglobal(:,2));
plot(lieglobal(:,1));

subplot(5,2,2)
hold on
title('Right shoulder Flexion-extension');
plot(rfeglobal(:,2));
plot(rfeglobal(:,1));

subplot(5,2,4)
hold on
title('Right shoulder Abduction-adduction');
plot(rbdglobal(:,2));
plot(rbdglobal(:,1));

subplot(5,2,6)
hold on
title('Right shoulder Flexion-extension from neutral position');
plot(relbfeglobal(:,2));
plot(relbfeglobal(:,1));

subplot(5,2,8)
hold on
title('Right elbow Flexion-extension with abduction');
plot(relbfe1global(:,2));
plot(relbfe1global(:,1));

subplot(5,2,10)
hold on
title('Right elbow internal-external rotation');
plot(rieglobal(:,2));
plot(rieglobal(:,1));

%%

