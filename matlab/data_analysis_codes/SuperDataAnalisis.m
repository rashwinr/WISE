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


MS = 30;
LW = 1;
LWref = 0.5;
font = 15;
span = 5;

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
        scale = 0.1;
        cmax = 20;
        cmin = 0;
        thcol = 0:1*pi/180:2*pi;
        switch(typ)

            case markers(1)
                Radius = 10;
                err = lfe(:,1)-lfe(:,2);
                
                TH = lfe(:,2);
                Err = abs(err);
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
                
            case markers(2)
                Radius = 15;
                err = lbd(:,1)-lbd(:,2);
                
                TH = lbd(:,2);
                Err = abs(err);
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
                surf(X,Y,Z+15,Cmap);
                [X,Y,Z] = pol2cart(thTor,rTor,Z_bottom);
                surf(X,Y,Z+15,Cmap);
                shading interp
                caxis([cmin cmax])
                abd_add = plot3(Xcol,Ycol,15*ones(size(Ycol)),'b','DisplayName','Arm abduction-adduction','LineWidth',LW);
                
            case markers(3)
                Radius = 20;
                err = lelbfe(:,1)-lelbfe(:,2);
                
                TH = lelbfe(:,2);
                Err = abs(err);
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
                surf(X,Y,Z+10,Cmap);
                [X,Y,Z] = pol2cart(thTor,rTor,Z_bottom);
                surf(X,Y,Z+10,Cmap);
                shading interp
                caxis([cmin cmax])
                Elb_felxext = plot3(Xcol,Ycol,10*ones(size(Ycol)),'k','DisplayName','Forearm flexion-extension without abduction','LineWidth',LW);
                
            case markers(4)
                Radius = 25;
                err = lelbfe(:,1)-lelbfe(:,2);
                
                TH = lelbfe(:,2);
                Err = abs(err);
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
                surf(X,Y,Z+5,Cmap);
                [X,Y,Z] = pol2cart(thTor,rTor,Z_bottom);
                surf(X,Y,Z+5,Cmap);
                shading interp
                caxis([cmin cmax])
                Elb_felxext1 = plot3(Xcol,Ycol,5*ones(size(Ycol)),'Color',[0 153/255 51/255],'DisplayName','Forearm flexion-extension with abduction','LineWidth',LW);
                
            case markers(5)

            case markers(6)
                Radius = 30;
                
                lie(lie==666) = NaN;
                [Row] = find(isnan(lie(:,1)));
                lie(Row,:) = [];
                
                err = lie(:,1)-lie(:,2);
                
                TH = lie(:,2);
                Err = abs(err);
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
                surf(X,Y,Z,Cmap);
                [X,Y,Z] = pol2cart(thTor,rTor,Z_bottom);
                surf(X,Y,Z,Cmap);
                shading interp
                caxis([cmin cmax])
                int_ext = plot(Xcol,Ycol,'m','DisplayName','Arm internal-external rotation with flexion','LineWidth',LW);
                
            case markers(7)

            case markers(8)
                Radius = 10;
                err = rfe(:,1)-rfe(:,2);
                
                TH = rfe(:,2);
                Err = abs(err);
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
                subplot(1,2,2)
                [X,Y,Z] = pol2cart(thTor,rTor,Z_top);
                surf(X,Y,Z+20,Cmap);
                [X,Y,Z] = pol2cart(thTor,rTor,Z_bottom);
                surf(X,Y,Z+20,Cmap);
                shading interp
                caxis([cmin cmax])
                plot3(Xcol,Ycol,20*ones(size(Ycol)),'r','LineWidth',LW)
                

            case markers(9)
                Radius = 15;
                err = rbd(:,1)-rbd(:,2);
                
                TH = rbd(:,2);
                Err = abs(err);
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
                subplot(1,2,2)
                [X,Y,Z] = pol2cart(thTor,rTor,Z_top);
                surf(X,Y,Z+15,Cmap);
                [X,Y,Z] = pol2cart(thTor,rTor,Z_bottom);
                surf(X,Y,Z+15,Cmap);
                shading interp
                caxis([cmin cmax])
                plot3(Xcol,Ycol,15*ones(size(Ycol)),'b','LineWidth',LW)

            case markers(10)
                Radius = 20;
                err = relbfe(:,1)-relbfe(:,2);
                
                TH = relbfe(:,2);
                Err = abs(err);
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
                subplot(1,2,2)
                [X,Y,Z] = pol2cart(thTor,rTor,Z_top);
                surf(X,Y,Z+10,Cmap);
                [X,Y,Z] = pol2cart(thTor,rTor,Z_bottom);
                surf(X,Y,Z+10,Cmap);
                shading interp
                caxis([cmin cmax])
                plot3(Xcol,Ycol,10*ones(size(Ycol)),'k','LineWidth',LW)

            case markers(11)
                Radius = 25;
                err = relbfe(:,1)-relbfe(:,2);
                
                TH = relbfe(:,2);
                Err = abs(err);
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
                subplot(1,2,2)
                [X,Y,Z] = pol2cart(thTor,rTor,Z_top);
                surf(X,Y,Z+5,Cmap);
                [X,Y,Z] = pol2cart(thTor,rTor,Z_bottom);
                surf(X,Y,Z+5,Cmap);
                shading interp
                caxis([cmin cmax])
                plot3(Xcol,Ycol,5*ones(size(Ycol)),'Color',[0 153/255 51/255],'LineWidth',LW)
  
            case markers(12)
     
            case markers(13)
                Radius = 30;
                
                rie(rie==666) = NaN;
                [Row] = find(isnan(rie(:,1)));
                rie(Row,:) = [];
                Time(length(rie)+1:length(Time)) = [];
                
                err = rie(:,1)-rie(:,2);
                
                TH = rie(:,2);
                Err = abs(err);
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
                subplot(1,2,2)
                [X,Y,Z] = pol2cart(thTor,rTor,Z_top);
                surf(X,Y,Z,Cmap);
                [X,Y,Z] = pol2cart(thTor,rTor,Z_bottom);
                surf(X,Y,Z,Cmap);
                shading interp
                caxis([cmin cmax])
                plot(Xcol,Ycol,'m','LineWidth',LW)
     
            case markers(14)
          

        end
       
    fclose(fid);
    end
    end

   end 
end

CLbar = colorbar(SubP1,'southoutside');
% colorbar(SubP2,'southoutside')
lgnd  = legend(SubP1,[flex_ext,abd_add,Elb_felxext,Elb_felxext1,int_ext],'Location','none','FontSize',font);
set(lgnd, 'Position', [0.4498 0.7788 0.1495 0.0891])
set(CLbar, 'Position', [0.3375 0.0945 0.3347 0.0221])