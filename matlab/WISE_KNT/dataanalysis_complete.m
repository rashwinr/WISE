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
                rieglobal = [rieglobal;rie];
            case markers(14)
                
        end
 
        end
    end
    end
end
    

end



%%
MS = 30;
LW = 1;
LWref = 0.5;
font = 15;
span = 5;
scale = 0.1;
cmax = 20;
cmin = 0;
thcol = 0:1*pi/180:2*pi;
% load myCustomColormap
% colormap( myCustomColormap );

% load Thoroid_Cmap
% colormap( Thoroid_Cmap );

load Mean_Cmap
colormap( Mean_Cmap );

thref = 0:30*pi/180:2*pi;
txref = 0:pi/2:(3/2)*pi;

figure(1);
sgtitle(strcat(num2str(SID),' Kinect+WISE',' errors vs angles'));

figure(1)
SubP1 = subplot(1,2,1);
hold on
axis equal
axis off
for ref =1:length(thref)
    if thref(ref)~=0 && thref(ref)*180/pi~=90 && thref(ref)*180/pi~=180 && thref(ref)*180/pi~=270 && thref(ref)*180/pi~=360
        Rref = linspace(0,10,100);
        [Xref,Yref] = pol2cart(thref(ref)*ones(size(Rref)),Rref);
        plot3(Xref,Yref,20*ones(size(Yref)),'k--','LineWidth',LWref)   
    end
end
for ref =1:length(thref)
    Rref = linspace(10,30,100);
    [Xref,Yref] = pol2cart(thref(ref)*ones(size(Rref)),Rref);
    Zref = linspace(20,0,100);
    plot3(Xref,Yref,Zref,'k--','LineWidth',LWref)   
end
for ref=1:length(txref)
    [Xtxt,Ytxt] = pol2cart(txref(ref),7);
    text(Xtxt,Ytxt,20,num2str(txref(ref)*180/pi),'HorizontalAlignment','center','VerticalAlignment','middle')
end


figure(1)
SubP2 = subplot(1,2,2);
hold on
axis equal
axis off
for ref =1:length(thref)
    if thref(ref)~=0 && thref(ref)*180/pi~=90 && thref(ref)*180/pi~=180 && thref(ref)*180/pi~=270 && thref(ref)*180/pi~=360
        Rref = linspace(0,10,100);
        [Xref,Yref] = pol2cart(thref(ref)*ones(size(Rref)),Rref);
        plot3(Xref,Yref,20*ones(size(Yref)),'k--','LineWidth',LWref)
    end
end
for ref =1:length(thref)
    Rref = linspace(10,30,100);
    [Xref,Yref] = pol2cart(thref(ref)*ones(size(Rref)),Rref);
    Zref = linspace(20,0,100);
    plot3(Xref,Yref,Zref,'k--','LineWidth',LWref)   
end
for ref=1:length(txref)
    [Xtxt,Ytxt] = pol2cart(txref(ref),7);
    text(Xtxt,Ytxt,20,num2str(txref(ref)*180/pi),'HorizontalAlignment','center','VerticalAlignment','middle')
end

SubP1.ZLim = [-10,40];
SubP1.XLim = [-40,40];
SubP1.YLim = [-40,40];
view(SubP1,[73,60])

SubP2.ZLim = [-10,40];
SubP2.XLim = [-40,40];
SubP2.YLim = [-40,40];
view(SubP2,[73,60])


 Radius = 10;
err = lfeglobal(:,1)-lfeglobal(:,2);

TH = lfeglobal(:,2);
Err = err;
[Angles,M] = PolarMean(TH,Err,span);

angles = zeros(size(Angles));
for an = 1:length(Angles)-1
    angles(an)=(Angles(an)+Angles(an+1))/2;
end
angles(length(Angles))= (Angles(length(Angles))*2+span)/2;

PIO = linspace(pi,0,length(M)); 
O_PI = linspace(-pi,0,length(M));
rTor = zeros(length(M));
thTor = zeros(length(M));
Z_top = zeros(length(M));
Z_bottom = zeros(length(M));
Cmap = zeros(length(M));

for mesh=1:length(M)
    rTor(mesh,:) = linspace(Radius-scale*M(mesh),Radius+scale*M(mesh),length(M));
    thTor(:,mesh) = angles*pi/180;
    Z_top(mesh,:) = scale*M(mesh)*sin(PIO);
    Z_bottom(mesh,:) = scale*M(mesh)*sin(O_PI);
    Cmap(mesh,:) = M(mesh);
end                

Rcol = Radius*ones(size(thcol));
[Xcol,Ycol] = pol2cart(thcol,Rcol);

figure(1)
subplot(1,2,1)
[X,Y,Z] = pol2cart(thTor,rTor,Z_top);
surf(X,Y,Z+20,Cmap);
[X,Y,Z] = pol2cart(thTor,rTor,Z_bottom);
surf(X,Y,Z+20,Cmap);
shading interp
caxis([cmin cmax])
flex_ext = plot3(Xcol,Ycol,20*ones(size(Ycol)),'r','DisplayName','Arm flexion-extension','LineWidth',LW);

Radius = 15;
err = lbdglobal(:,1)-lbdglobal(:,2);

TH = lbdglobal(:,2);
Err = err;
[Angles,M] = PolarMean(TH,Err,span);
M = abs(M);

angles = zeros(size(Angles));
for an = 1:length(Angles)-1
    angles(an)=(Angles(an)+Angles(an+1))/2;
end
angles(length(Angles))= (Angles(length(Angles))*2+span)/2;

PIO = linspace(pi,0,length(M)); 
O_PI = linspace(-pi,0,length(M));
rTor = zeros(length(M));
thTor = zeros(length(M));
Z_top = zeros(length(M));
Z_bottom = zeros(length(M));
Cmap = zeros(length(M));

for mesh=1:length(M)
    rTor(mesh,:) = linspace(Radius-scale*M(mesh),Radius+scale*M(mesh),length(M));
    thTor(:,mesh) = angles*pi/180;
    Z_top(mesh,:) = scale*M(mesh)*sin(PIO);
    Z_bottom(mesh,:) = scale*M(mesh)*sin(O_PI);
    Cmap(mesh,:) = M(mesh);
end                

Rcol = Radius*ones(size(thcol));
[Xcol,Ycol] = pol2cart(thcol,Rcol);

figure(1)
subplot(1,2,1)
[X,Y,Z] = pol2cart(thTor,rTor,Z_top);
surf(X,Y,Z+15,Cmap);
[X,Y,Z] = pol2cart(thTor,rTor,Z_bottom);
surf(X,Y,Z+15,Cmap);
shading interp
caxis([cmin cmax])
abd_add = plot3(Xcol,Ycol,15*ones(size(Ycol)),'b','DisplayName','Arm abduction-adduction','LineWidth',LW);


Radius = 20;
err = lelbfeglobal(:,1)-lelbfeglobal(:,2);

TH = lelbfeglobal(:,2);
Err = err;
[Angles,M] = PolarMean(TH,Err,span); M = abs(M);

angles = zeros(size(Angles));
for an = 1:length(Angles)-1
    angles(an)=(Angles(an)+Angles(an+1))/2;
end
angles(length(Angles))= (Angles(length(Angles))*2+span)/2;

PIO = linspace(pi,0,length(M)); 
O_PI = linspace(-pi,0,length(M));
rTor = zeros(length(M));
thTor = zeros(length(M));
Z_top = zeros(length(M));
Z_bottom = zeros(length(M));
Cmap = zeros(length(M));

for mesh=1:length(M)
    rTor(mesh,:) = linspace(Radius-scale*M(mesh),Radius+scale*M(mesh),length(M));
    thTor(:,mesh) = angles*pi/180;
    Z_top(mesh,:) = scale*M(mesh)*sin(PIO);
    Z_bottom(mesh,:) = scale*M(mesh)*sin(O_PI);
    Cmap(mesh,:) = M(mesh);
end

Rcol = Radius*ones(size(thcol));
[Xcol,Ycol] = pol2cart(thcol,Rcol);

figure(1)
subplot(1,2,1)
[X,Y,Z] = pol2cart(thTor,rTor,Z_top);
surf(X,Y,Z+10,Cmap);
[X,Y,Z] = pol2cart(thTor,rTor,Z_bottom);
surf(X,Y,Z+10,Cmap);
shading interp
caxis([cmin cmax])
Elb_felxext = plot3(Xcol,Ycol,10*ones(size(Ycol)),'k','DisplayName','Forearm flexion-extension without abduction','LineWidth',LW);


Radius = 25;
err = lelbfe1global(:,1)-lelbfe1global(:,2);

TH = lelbfe1global(:,2);
Err = err;
[Angles,M] = PolarMean(TH,Err,span); M = abs(M);

angles = zeros(size(Angles));
for an = 1:length(Angles)-1
    angles(an)=(Angles(an)+Angles(an+1))/2;
end
angles(length(Angles))= (Angles(length(Angles))*2+span)/2;

PIO = linspace(pi,0,length(M)); 
O_PI = linspace(-pi,0,length(M));
rTor = zeros(length(M));
thTor = zeros(length(M));
Z_top = zeros(length(M));
Z_bottom = zeros(length(M));
Cmap = zeros(length(M));

for mesh=1:length(M)
    rTor(mesh,:) = linspace(Radius-scale*M(mesh),Radius+scale*M(mesh),length(M));
    thTor(:,mesh) = angles*pi/180;
    Z_top(mesh,:) = scale*M(mesh)*sin(PIO);
    Z_bottom(mesh,:) = scale*M(mesh)*sin(O_PI);
    Cmap(mesh,:) = M(mesh);
end

Rcol = Radius*ones(size(thcol));
[Xcol,Ycol] = pol2cart(thcol,Rcol);

figure(1)
subplot(1,2,1)
[X,Y,Z] = pol2cart(thTor,rTor,Z_top);
surf(X,Y,Z+5,Cmap);
[X,Y,Z] = pol2cart(thTor,rTor,Z_bottom);
surf(X,Y,Z+5,Cmap);
shading interp
caxis([cmin cmax])
Elb_felxext1 = plot3(Xcol,Ycol,5*ones(size(Ycol)),'Color',[0 153/255 51/255],'DisplayName','Forearm flexion-extension with abduction','LineWidth',LW);

Radius = 30;


err = lieglobal(:,1)-lieglobal(:,2);

TH = lieglobal(:,2);
Err = err;
[Angles,M] = PolarMean(TH,Err,span); M = abs(M);

angles = zeros(size(Angles));
for an = 1:length(Angles)-1
    angles(an)=(Angles(an)+Angles(an+1))/2;
end
angles(length(Angles))= (Angles(length(Angles))*2+span)/2;

PIO = linspace(pi,0,length(M)); 
O_PI = linspace(-pi,0,length(M));
rTor = zeros(length(M));
thTor = zeros(length(M));
Z_top = zeros(length(M));
Z_bottom = zeros(length(M));
Cmap = zeros(length(M));

for mesh=1:length(M)
    rTor(mesh,:) = linspace(Radius-scale*M(mesh),Radius+scale*M(mesh),length(M));
    thTor(:,mesh) = angles*pi/180;
    Z_top(mesh,:) = scale*M(mesh)*sin(PIO);
    Z_bottom(mesh,:) = scale*M(mesh)*sin(O_PI);
    Cmap(mesh,:) = M(mesh);
end

Rcol = Radius*ones(size(thcol));
[Xcol,Ycol] = pol2cart(thcol,Rcol);

figure(1)
subplot(1,2,1)
[X,Y,Z] = pol2cart(thTor,rTor,Z_top);
surf(X,Y,Z,Cmap);
[X,Y,Z] = pol2cart(thTor,rTor,Z_bottom);
surf(X,Y,Z,Cmap);
shading interp
caxis([cmin cmax])
int_ext = plot(Xcol,Ycol,'m','DisplayName','Arm internal-external rotation with flexion','LineWidth',LW);


Radius = 10;
err = rfeglobal(:,1)-rfeglobal(:,2);

TH = rfeglobal(:,2);
Err = err;
[Angles,M] = PolarMean(TH,Err,span); M = abs(M);

angles = zeros(size(Angles));
for an = 1:length(Angles)-1
    angles(an)=(Angles(an)+Angles(an+1))/2;
end
angles(length(Angles))= (Angles(length(Angles))*2+span)/2;

PIO = linspace(pi,0,length(M)); 
O_PI = linspace(-pi,0,length(M));
rTor = zeros(length(M));
thTor = zeros(length(M));
Z_top = zeros(length(M));
Z_bottom = zeros(length(M));
Cmap = zeros(length(M));

for mesh=1:length(M)
    rTor(mesh,:) = linspace(Radius-scale*M(mesh),Radius+scale*M(mesh),length(M));
    thTor(:,mesh) = angles*pi/180;
    Z_top(mesh,:) = scale*M(mesh)*sin(PIO);
    Z_bottom(mesh,:) = scale*M(mesh)*sin(O_PI);
    Cmap(mesh,:) = M(mesh);
end

Rcol = Radius*ones(size(thcol));
[Xcol,Ycol] = pol2cart(thcol,Rcol);

figure(1)
subplot(1,2,2)
[X,Y,Z] = pol2cart(thTor,rTor,Z_top);
surf(X,Y,Z+20,Cmap);
[X,Y,Z] = pol2cart(thTor,rTor,Z_bottom);
surf(X,Y,Z+20,Cmap);
shading interp
caxis([cmin cmax])
plot3(Xcol,Ycol,20*ones(size(Ycol)),'r','LineWidth',LW)


Radius = 15;
err = rbdglobal(:,1)-rbdglobal(:,2);

TH = rbdglobal(:,2);
Err = err;
[Angles,M] = PolarMean(TH,Err,span); M = abs(M);

angles = zeros(size(Angles));
for an = 1:length(Angles)-1
    angles(an)=(Angles(an)+Angles(an+1))/2;
end
angles(length(Angles))= (Angles(length(Angles))*2+span)/2;

PIO = linspace(pi,0,length(M)); 
O_PI = linspace(-pi,0,length(M));
rTor = zeros(length(M));
thTor = zeros(length(M));
Z_top = zeros(length(M));
Z_bottom = zeros(length(M));
Cmap = zeros(length(M));

for mesh=1:length(M)
    rTor(mesh,:) = linspace(Radius-scale*M(mesh),Radius+scale*M(mesh),length(M));
    thTor(:,mesh) = angles*pi/180;
    Z_top(mesh,:) = scale*M(mesh)*sin(PIO);
    Z_bottom(mesh,:) = scale*M(mesh)*sin(O_PI);
    Cmap(mesh,:) = M(mesh);
end

Rcol = Radius*ones(size(thcol));
[Xcol,Ycol] = pol2cart(thcol,Rcol);

figure(1)
subplot(1,2,2)
[X,Y,Z] = pol2cart(thTor,rTor,Z_top);
surf(X,Y,Z+15,Cmap);
[X,Y,Z] = pol2cart(thTor,rTor,Z_bottom);
surf(X,Y,Z+15,Cmap);
shading interp
caxis([cmin cmax])
plot3(Xcol,Ycol,15*ones(size(Ycol)),'b','LineWidth',LW)


Radius = 20;
err = relbfeglobal(:,1)-relbfeglobal(:,2);

TH = relbfeglobal(:,2);
Err = err;
[Angles,M] = PolarMean(TH,Err,span); M = abs(M);

angles = zeros(size(Angles));
for an = 1:length(Angles)-1
    angles(an)=(Angles(an)+Angles(an+1))/2;
end
angles(length(Angles))= (Angles(length(Angles))*2+span)/2;

PIO = linspace(pi,0,length(M)); 
O_PI = linspace(-pi,0,length(M));
rTor = zeros(length(M));
thTor = zeros(length(M));
Z_top = zeros(length(M));
Z_bottom = zeros(length(M));
Cmap = zeros(length(M));

for mesh=1:length(M)
    rTor(mesh,:) = linspace(Radius-scale*M(mesh),Radius+scale*M(mesh),length(M));
    thTor(:,mesh) = angles*pi/180;
    Z_top(mesh,:) = scale*M(mesh)*sin(PIO);
    Z_bottom(mesh,:) = scale*M(mesh)*sin(O_PI);
    Cmap(mesh,:) = M(mesh);
end

Rcol = Radius*ones(size(thcol));
[Xcol,Ycol] = pol2cart(thcol,Rcol);

figure(1)
subplot(1,2,2)
[X,Y,Z] = pol2cart(thTor,rTor,Z_top);
surf(X,Y,Z+10,Cmap);
[X,Y,Z] = pol2cart(thTor,rTor,Z_bottom);
surf(X,Y,Z+10,Cmap);
shading interp
caxis([cmin cmax])
plot3(Xcol,Ycol,10*ones(size(Ycol)),'k','LineWidth',LW)



Radius = 25;
err = relbfe1global(:,1)-relbfe1global(:,2);

TH = relbfe1global(:,2);
Err = err;
[Angles,M] = PolarMean(TH,Err,span); M = abs(M);

angles = zeros(size(Angles));
for an = 1:length(Angles)-1
    angles(an)=(Angles(an)+Angles(an+1))/2;
end
angles(length(Angles))= (Angles(length(Angles))*2+span)/2;

PIO = linspace(pi,0,length(M)); 
O_PI = linspace(-pi,0,length(M));
rTor = zeros(length(M));
thTor = zeros(length(M));
Z_top = zeros(length(M));
Z_bottom = zeros(length(M));
Cmap = zeros(length(M));

for mesh=1:length(M)
    rTor(mesh,:) = linspace(Radius-scale*M(mesh),Radius+scale*M(mesh),length(M));
    thTor(:,mesh) = angles*pi/180;
    Z_top(mesh,:) = scale*M(mesh)*sin(PIO);
    Z_bottom(mesh,:) = scale*M(mesh)*sin(O_PI);
    Cmap(mesh,:) = M(mesh);
end

Rcol = Radius*ones(size(thcol));
[Xcol,Ycol] = pol2cart(thcol,Rcol);

figure(1)
subplot(1,2,2)
[X,Y,Z] = pol2cart(thTor,rTor,Z_top);
surf(X,Y,Z+5,Cmap);
[X,Y,Z] = pol2cart(thTor,rTor,Z_bottom);
surf(X,Y,Z+5,Cmap);
shading interp
caxis([cmin cmax])
plot3(Xcol,Ycol,5*ones(size(Ycol)),'Color',[0 153/255 51/255],'LineWidth',LW) 


Radius = 30;

err = rieglobal(:,1)-rieglobal(:,2);

TH = rieglobal(:,2);
Err = err;
[Angles,M] = PolarMean(TH,Err,span); M = abs(M);

angles = zeros(size(Angles));
for an = 1:length(Angles)-1
    angles(an)=(Angles(an)+Angles(an+1))/2;
end
angles(length(Angles))= (Angles(length(Angles))*2+span)/2;

PIO = linspace(pi,0,length(M)); 
O_PI = linspace(-pi,0,length(M));
rTor = zeros(length(M));
thTor = zeros(length(M));
Z_top = zeros(length(M));
Z_bottom = zeros(length(M));
Cmap = zeros(length(M));

for mesh=1:length(M)
    rTor(mesh,:) = linspace(Radius-scale*M(mesh),Radius+scale*M(mesh),length(M));
    thTor(:,mesh) = angles*pi/180;
    Z_top(mesh,:) = scale*M(mesh)*sin(PIO);
    Z_bottom(mesh,:) = scale*M(mesh)*sin(O_PI);
    Cmap(mesh,:) = M(mesh);
end

Rcol = Radius*ones(size(thcol));
[Xcol,Ycol] = pol2cart(thcol,Rcol);

figure(1)
subplot(1,2,2)
[X,Y,Z] = pol2cart(thTor,rTor,Z_top);
surf(X,Y,Z,Cmap);
[X,Y,Z] = pol2cart(thTor,rTor,Z_bottom);
surf(X,Y,Z,Cmap);
shading interp
caxis([cmin cmax])
plot(Xcol,Ycol,'m','LineWidth',LW)

                
                
                
                
                
                
CLbar = colorbar(SubP1,'southoutside');
% colorbar(SubP2,'southoutside')
lgnd  = legend(SubP1,[flex_ext,abd_add,Elb_felxext,Elb_felxext1,int_ext],'Location','none','FontSize',font);
set(lgnd, 'Position', [0.4498 0.7788 0.1495 0.0891])
set(CLbar, 'Position', [0.3375 0.0945 0.3347 0.0221])