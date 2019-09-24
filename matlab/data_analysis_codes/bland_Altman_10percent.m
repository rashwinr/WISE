clc;clear all;close all
markers = ["lef","lbd","lelb","lelb1","lie","ref","rbd","relb","relb1","rie"];
addpath('F:\github\wearable-jacket\matlab\data_analysis_codes')
smoovar = 4;
subjectID = [312,2064,2463,2990,3154,3162,3380,3409,3581,3689,5837,6219,6339,6525,7612,9053,9717];
% subjectID = [312,2064,2463,2990,3154,3162,3380,3409,3581,3689,5837,6219,6339,7612,9053,9717];
% subjectID = 4332;
N=1;
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

for fu=1:length(subjectID)

SID = subjectID(fu);
cd(strcat('F:\github\wearable-jacket\matlab\kinect+imudata\',num2str(SID)));

list = dir();
spike_files=dir('*.txt');

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
%         delnumarr1 = find(round(Time)==65);
        lie(1:delnumarr(1),:) = [];
        lfe(1:delnumarr(1),:) = [];
        lbd(1:delnumarr(1),:) = [];
        lelbfe(1:delnumarr(1),:) = [];
        rfe(1:delnumarr(1),:) = [];
        rbd(1:delnumarr(1),:) = [];
        rie(1:delnumarr(1),:) = [];
        relbfe(1:delnumarr(1),:) = [];
%         lie(delnumarr1(1):end,:) = [];
%         lfe(delnumarr1(1):end,:) = [];
%         lbd(delnumarr1(1):end,:) = [];
%         lelbfe(delnumarr1(1):end,:) = [];
%         rfe(delnumarr1(1):end,:) = [];
%         rbd(delnumarr1(1):end,:) = [];
%         rie(delnumarr1(1):end,:) = [];
%         relbfe(delnumarr1(1):end,:) = [];
        Time(length(lie)+1:length(Time))=[];
        smoovar = 4;
        lie(:,1) = smooth(lie(:,1),smoovar);
        lie(:,2) = smooth(lie(:,2),smoovar);
        rie(:,1) = smooth(rie(:,1),smoovar);
        rie(:,2) = smooth(rie(:,2),smoovar);
        lfe(:,1) = smooth(lfe(:,1),smoovar);
        lfe(:,2) = smooth(lfe(:,2),smoovar);
        rfe(:,1) = smooth(rfe(:,1),smoovar);
        rfe(:,2) = smooth(rfe(:,2),smoovar);
        rbd(:,1) = smooth(rbd(:,1),smoovar);
        rbd(:,2) = smooth(rbd(:,2),smoovar);
        lbd(:,1) = smooth(lbd(:,1),smoovar);
        lbd(:,2) = smooth(lbd(:,2),smoovar);
        lelbfe(:,1) = smooth(lelbfe(:,1),smoovar);
        lelbfe(:,2) = smooth(lelbfe(:,2),smoovar);
        relbfe(:,1) = smooth(relbfe(:,1),smoovar);
        relbfe(:,2) = smooth(relbfe(:,2),smoovar);
        switch(typ)
            
            case markers(1)
%                 lfe = log10(abs(lfe));
                mk = max(lfe(:,1));
                mi = max(lfe(:,2));
                [~,X,Y] = dtw(lfe(:,1),lfe(:,2));
                lfe_dtw = zeros(length(X),2);
                lfe_dtw(:,1) = lfe(X,1);
                lfe_dtw(:,2) = lfe(Y,2);
                lfeglobal = [lfeglobal;lfe_dtw];
                clearvars X Y mi mk lfe_dtw
            case markers(2)
%                 lbd = log10(abs(lbd));
                mk = max(lbd(:,1));
                mi = max(lbd(:,2));
                [~,X,Y] = dtw(lbd(:,1),lbd(:,2));
                lbd_dtw = zeros(length(X),2);
                lbd_dtw(:,1) = lbd(X,1);
                lbd_dtw(:,2) = lbd(Y,2);
                lbdglobal = [lbdglobal;lbd_dtw];
                clearvars X Y mi mk lbd_dtw
            case markers(3)
                lelbfe(lelbfe>=200) = NaN;
                [Row] = find(isnan(lelbfe(:,2)));
                lelbfe(Row,:) = [];
%                 lelbfe = log10(abs(lelbfe));
                mk = max(lelbfe(:,1));
                mi = max(lelbfe(:,2));
                [~,X,Y] = dtw(lelbfe(:,1),lelbfe(:,2));
                lelbfe_dtw = zeros(length(X),2);
                lelbfe_dtw(:,1) = lelbfe(X,1);
                lelbfe_dtw(:,2) = lelbfe(Y,2);
                lelbfeglobal = [lelbfeglobal;lelbfe_dtw];
                clearvars X Y mi mk lelbfe_dtw
            case markers(4)
                lelbfe(lelbfe>=200) = NaN;
                [Row] = find(isnan(lelbfe(:,2)));
                lelbfe(Row,2) = lelbfe(Row,1);
%                 lelbfe = log10(abs(lelbfe));
                mk = max(lelbfe(:,1));
                mi = max(lelbfe(:,2));
                [~,X,Y] = dtw(lelbfe(:,1),lelbfe(:,2));
                lelbfe_dtw = zeros(length(X),2);
                lelbfe_dtw(:,1) = lelbfe(X,1);
                lelbfe_dtw(:,2) = lelbfe(Y,2);
                lelbfe1global = [lelbfe1global;lelbfe_dtw];
                clearvars X Y mi mk lelbfe_dtw
            case markers(5)
                lie(lie>=200) = NaN;
                [Row] = find(isnan(lie(:,1)));
                lie(Row,:) = [];
                [Row1] = find(isnan(lie(:,2)));
                lie(Row1,:) = [];
                Zerokinectpos = find(round(lie(:,1)/10)==0);
                min1kinectpos = find(round(lie(:,1)/10)==-1);
                pls1kinectpos = find(round(lie(:,1)/10)==+1);
                ZeroIMUval = mean(lie([Zerokinectpos;min1kinectpos;pls1kinectpos],2));
                lie(:,2) = lie(:,2)-ZeroIMUval;
%                 lie = log10(abs(lie));
                mk = max(lie(:,1));
                mi = max(lie(:,2));
                [~,X,Y] = dtw(lie(:,1),lie(:,2));
                lie_dtw = zeros(length(X),2);
                lie_dtw(:,1) = lie(X,1);
                lie_dtw(:,2) = lie(Y,2);
                lieglobal = [lieglobal;lie_dtw];
                clearvars X Y mi mk lie_dtw
            case markers(6)
%                 rfe = log10(abs(rfe));
                mk = max(rfe(:,1));
                mi = max(rfe(:,2));
                [~,X,Y] = dtw(rfe(:,1),rfe(:,2));
                rfe_dtw = zeros(length(X),2);
                rfe_dtw(:,1) = rfe(X,1);
                rfe_dtw(:,2) = rfe(Y,2);
                rfeglobal = [rfeglobal;rfe_dtw];
                clearvars X Y mi mk rfe_dtw
            case markers(7)
%                 rbd = log10(abs(rbd));
                mk = max(rbd(:,1));
                mi = max(rbd(:,2));
                [~,X,Y] = dtw(rbd(:,1),rbd(:,2));
                rbd_dtw = zeros(length(X),2);
                rbd_dtw(:,1) = rbd(X,1);
                rbd_dtw(:,2) = rbd(Y,2);
                rbdglobal = [rbdglobal;rbd_dtw];
                clearvars X Y mi mk rbd_dtw
            case markers(8)
                relbfe(relbfe>=200) = NaN;
                [Row] = find(isnan(relbfe(:,2)));
                relbfe(Row,:) = [];
%                 relbfe = log10(abs(relbfe));
                mk = max(relbfe(:,1));
                mi = max(relbfe(:,2));
                [~,X,Y] = dtw(relbfe(:,1),relbfe(:,2));
                relbfe_dtw = zeros(length(X),2);
                relbfe_dtw(:,1) = relbfe(X,1);
                relbfe_dtw(:,2) = relbfe(Y,2);
                relbfeglobal = [relbfeglobal;relbfe_dtw];
                clearvars X Y mi mk relbfe_dtw
            case markers(9)
                relbfe(relbfe>=200) = NaN;
                [Row] = find(isnan(relbfe(:,2)));
                relbfe(Row,2) = relbfe(Row,1);
%                 relbfe = log10(abs(relbfe));
                mk = max(relbfe(:,1));
                mi = max(relbfe(:,2));
                [~,X,Y] = dtw(relbfe(:,1),relbfe(:,2));
                relbfe_dtw = zeros(length(X),2);
                relbfe_dtw(:,1) = relbfe(X,1);
                relbfe_dtw(:,2) = relbfe(Y,2);
                relbfe1global = [relbfe1global;relbfe_dtw];
                clearvars X Y mi mk relbfe_dtw
            case markers(10)
                rie(rie>=200) = NaN;
                [Row] = find(isnan(rie(:,1)));
                rie(Row,:) = [];
                [Row1] = find(isnan(rie(:,2)));
                rie(Row1,:) = [];
                Zerokinectpos = find(round(rie(:,1)/10)==0);
                min1kinectpos = find(round(rie(:,1)/10)==-1);
                pls1kinectpos = find(round(rie(:,1)/10)==+1);
                ZeroIMUval = mean(rie([Zerokinectpos;min1kinectpos;pls1kinectpos],2));
                rie(:,2) = rie(:,2)-ZeroIMUval;
%                 rie = log10(abs(rie));
                mk = max(rie(:,1));
                mi = max(rie(:,2));
                [~,X,Y] = dtw(rie(:,1),rie(:,2));
                rie_dtw = zeros(length(X),2);
                rie_dtw(:,1) = rie(X,1);
                rie_dtw(:,2) = rie(Y,2);
                rieglobal = [rieglobal;rie_dtw];
                clearvars X Y mi mk rie_dtw
        end



        end




    end
    end
end
end
% figure(1)
% plot(lfeglobal(:,1))
% hold on
% plot(lfeglobal(:,2))
% figure(2)
% plot(rfeglobal(:,1))
% hold on
% plot(rfeglobal(:,2))
% figure(3)
% plot(lfeglobal(:,1))
% hold on
% plot(lfeglobal(:,2))
% figure(4)
% plot(lbdglobal(:,1))
% hold on
% plot(lbdglobal(:,2))
% figure(5)
% plot(rbdglobal(:,1))
% hold on
% plot(rbdglobal(:,2))
% 
mult = 0;

err = lfeglobal(:,1)-lfeglobal(:,2);
mu = prctile(err,[7.5 92.5]);
mu = [mu(1)-mult*iqr(err),mu(2)+mult*iqr(err)]
Dellfe = [find(err<=mu(1));find(err>=mu(2))];
lfep = length(Dellfe)*100/length(lfeglobal);
lfeglobal(Dellfe,:) = [];

err = rfeglobal(:,1)-rfeglobal(:,2);
mu = prctile(err,[7.5 92.5]);
mu = [mu(1)-mult*iqr(err),mu(2)+mult*iqr(err)]
Delrfe = [find(err<=mu(1));find(err>=mu(2))];
rfep = length(Delrfe)*100/length(rfeglobal);
rfeglobal(Delrfe,:) = [];

err = lbdglobal(:,1)-lbdglobal(:,2);
mu = prctile(err,[7.5 92.5]);
mu = [mu(1)-mult*iqr(err),mu(2)+mult*iqr(err)]
Dellbd = [find(err<=mu(1));find(err>=mu(2))];
lbdp = length(Dellbd)*100/length(lbdglobal);
lbdglobal(Dellbd,:) = [];

err = rbdglobal(:,1)-rbdglobal(:,2);
mu = prctile(err,[7.5 92.5]);
mu = [mu(1)-mult*iqr(err),mu(2)+mult*iqr(err)]
Delrbd = [find(err<=mu(1));find(err>=mu(2))];
rbdp = length(Delrbd)*100/length(rbdglobal);
rbdglobal(Delrbd,:) = [];

err = lieglobal(:,1)-lieglobal(:,2);
mu = prctile(err,[7.5 92.5]);
mu = [mu(1)-mult*iqr(err),mu(2)+mult*iqr(err)]
Dellie = [find(err<=mu(1));find(err>=mu(2))];
liep = length(Dellie)*100/length(lieglobal);
lieglobal(Dellie,:) = [];

err = rieglobal(:,1)-rieglobal(:,2);
mu = prctile(err,[7.5 92.5]);
mu = [mu(1)-mult*iqr(err),mu(2)+mult*iqr(err)]
Delrie = [find(err<=mu(1));find(err>=mu(2))];
riep = length(Delrie)*100/length(rieglobal);
rieglobal(Delrie,:) = [];

err = lelbfeglobal(:,1)-lelbfeglobal(:,2);
mu = prctile(err,[7.5 92.5]);
mu = [mu(1)-mult*iqr(err),mu(2)+mult*iqr(err)]
Dellelbfe = [find(err<=mu(1));find(err>=mu(2))];
lelbfep = length(Dellelbfe)*100/length(lelbfeglobal);
lelbfeglobal(Dellelbfe,:) = [];

err = relbfeglobal(:,1)-relbfeglobal(:,2);
mu = prctile(err,[7.5 92.5]);
mu = [mu(1)-mult*iqr(err),mu(2)+mult*iqr(err)]
Delrelbfe = [find(err<=mu(1));find(err>=mu(2))];
relbfep = length(Delrelbfe)*100/length(relbfeglobal);
relbfeglobal(Delrelbfe,:) = [];

err = lelbfe1global(:,1)-lelbfe1global(:,2);
mu = prctile(err,[7.5 92.5]);
mu = [mu(1)-mult*iqr(err),mu(2)+mult*iqr(err)]
Dellelbfe1 = [find(err<=mu(1));find(err>=mu(2))];
lelbfe1p = length(Dellelbfe1)*100/length(lelbfe1global);
lelbfe1global(Dellelbfe1,:) = [];

err = relbfe1global(:,1)-relbfe1global(:,2);
mu = prctile(err,[7.5 92.5]);
mu = [mu(1)-mult*iqr(err),mu(2)+mult*iqr(err)]
Delrelbfe1 = [find(err<=mu(1));find(err>=mu(2))];
relbfe1p = length(Delrelbfe1)*100/length(relbfe1global);
relbfe1global(Delrelbfe1,:) = [];

disp(lfep);
disp(rfep);
disp(lbdp);
disp(rbdp);
disp(lelbfep);
disp(relbfep);
disp(liep);
disp(riep);
disp(lelbfe1p);
disp(relbfe1p);

%%
close all


[a1 b1 c1] = BlandAltman(lfeglobal(:,1),lfeglobal(:,2));
[a2 b2 c2] = BlandAltman(lbdglobal(:,1),lbdglobal(:,2));
[a3 b3 c3] = BlandAltman(lieglobal(:,1),lieglobal(:,2));
[a4 b4 c4] = BlandAltman(lelbfeglobal(:,1),lelbfeglobal(:,2));
[a5 b5 c5] = BlandAltman(lelbfe1global(:,1),lelbfe1global(:,2));
[a6 b6 c6] = BlandAltman(rfeglobal(:,1),rfeglobal(:,2));
[a7 b7 c7] = BlandAltman(rbdglobal(:,1),rbdglobal(:,2));
[a8 b8 c8 ]= BlandAltman(rieglobal(:,1),rieglobal(:,2));
[a9 b9 c9] = BlandAltman(relbfeglobal(:,1),relbfeglobal(:,2));
[a10 b10 c10] = BlandAltman(relbfe1global(:,1),relbfe1global(:,2));
