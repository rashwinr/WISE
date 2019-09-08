[muHat,sigmaHat] = normfit(err);
y = gaussmf(err,[sigmaHat muHat]);
figure(2)
scatter(err,y)
%%

k = 1;
ind = [];
Bin = [];
err = lfe(:,1)-lfe(:,2);
d = lfe(:,1)-lfe(:,2);

while ~isempty(err)
        ind = find(err(:)==err(1));
        Bin(k,1) = err(1);
        err(ind) = [];
        ind = [];
        k=k+1;
end

%     AngErr = [angles,Merrors];
%                 AngErr = sortrows(AngErr,1);

len = length(Bin);

[muHat,sigmaHat] = normfit(d);
pd = fitdist(d,'Normal');



figure(4)
hold on
title(strcat("Mu = ",num2str(muHat)," ",num2str(pd.mu)," ","S = ",num2str(sigmaHat)," ",num2str(pd.sigma)," "))
h=histogram(d);
% h.NumBins = len;
histfit(d);

%%
clear all, close all, clc
R = linspace(5,10,2); % (distance in km)
Az = linspace(0,80,100); % in degrees
windSpeed = rand(2,100); % radial wind speed
figure
[h,c]=polarPcolor(R,Az,windSpeed);
%%
th = pi/4:pi/4:2*pi;
r = [19 6 12 18 16 11 15 15];
sz = 100*[6 15 20 3 15 3 6 40];
c = [1 2 3 4 5 6 7 8];
polarscatter(th,r,sz,c,'filled','MarkerFaceAlpha',.5)