function ThorPlot(figNum,lfe,lbd,lelbfe,lelbfe1,lie,rfe,rbd,relbfe,relbfe1,rie)
LW = 1;
LWref = 0.5;
font = 15;

span = 5;
scale = 0.1;

cmax = 20;
cmin = -20;

Rmin = 0.1;
Zstep = 7;
Rint = 10;

thcol = 0:1*pi/180:2*pi;
thref = 0:30*pi/180:2*pi;
txref = 0:pi/2:(3/2)*pi;
txRad = 55*Rint/100;
txthshift = -17*pi/180;

% Figure(figNum) subplot(1) reference and color map initialization

ThMean_Cmap = load('ThMean_Cmap.mat');

figure(figNum);
sgtitle(strcat('Kinect+WISE',' Mean errors vs angles'));

figure(figNum)
SubP1 = subplot(1,2,1);
CLbar = colorbar(SubP1,'southoutside');
caxis(SubP1,[cmin cmax]);
colormap(SubP1,ThMean_Cmap.ThMean_Cmap );
set(CLbar, 'Position', [0.3375 0.0945 0.3347 0.0221])
hold on
axis equal
axis off

for ref =1:length(txref)
        Rref = linspace(0,Rint,100);
        [Xref,Yref] = pol2cart(txref(ref)*ones(size(Rref)),Rref);
        plot3(Xref,Yref,4*Zstep*ones(size(Yref)),'k--','LineWidth',LWref)   
end
for ref =1:length(thref)
    Rref = linspace(Rint,Rint + 4*Zstep,100);
    [Xref,Yref] = pol2cart(thref(ref)*ones(size(Rref)),Rref);
    Zref = linspace(4*Zstep,0,100);
    plot3(Xref,Yref,Zref,'k--','LineWidth',LWref)   
end
for ref=1:length(txref)
    [Xtxt,Ytxt] = pol2cart(txref(ref)+txthshift,txRad);
    text(Xtxt,Ytxt,4*Zstep,num2str(txref(ref)*180/pi),'HorizontalAlignment','center','VerticalAlignment','middle')
end

% Figure(figNum) subplot(1) reference and color map initialization

figure(figNum)
SubP2 = subplot(1,2,2);
colorbar(SubP2);
caxis(SubP2,[cmin cmax]);
colormap(SubP2,ThMean_Cmap.ThMean_Cmap );
colorbar('off')
hold on
axis equal
axis off

for ref =1:length(txref)
        Rref = linspace(0,Rint,100);
        [Xref,Yref] = pol2cart(txref(ref)*ones(size(Rref)),Rref);
        plot3(Xref,Yref,4*Zstep*ones(size(Yref)),'k--','LineWidth',LWref)   
end
for ref =1:length(thref)
    Rref = linspace(Rint,Rint + 4*Zstep,100);
    [Xref,Yref] = pol2cart(thref(ref)*ones(size(Rref)),Rref);
    Zref = linspace(4*Zstep,0,100);
    plot3(Xref,Yref,Zref,'k--','LineWidth',LWref)   
end
for ref=1:length(txref)
    [Xtxt,Ytxt] = pol2cart(txref(ref)+txthshift,txRad);
    text(Xtxt,Ytxt,4*Zstep,num2str(txref(ref)*180/pi),'HorizontalAlignment','center','VerticalAlignment','middle')
end

SubP1.ZLim = [-5,5+4*Zstep];
SubP1.XLim = [-(Rint+4*Zstep+5),Rint+4*Zstep+5];
SubP1.YLim = [-(Rint+4*Zstep+5),Rint+4*Zstep+5];
view(SubP1,[73,60])

SubP2.ZLim = [-5,5+4*Zstep];
SubP2.XLim = [-(Rint+4*Zstep+5),Rint+4*Zstep+5];
SubP2.YLim = [-(Rint+4*Zstep+5),Rint+4*Zstep+5];
view(SubP2,[73,60])

%Left Arm flexion-extension 'lfe'
Radius = Rint;
offZ = 4*Zstep;

    err = lfe(:,1)-lfe(:,2);
                
    TH = lfe(:,2);
    [angles,M,Std] = PolarMean(TH,err,span);

    rTor = zeros(length(M));
    thTor = zeros(length(M));
    Z_top = zeros(length(M));
    Z_bottom = zeros(length(M));
    Cmap = zeros(length(M));

    for mesh=1:length(M)
        rTor(mesh,:) = linspace(Radius-(scale*(2*Std(mesh))+Rmin),Rmin+scale*(2*Std(mesh))+Radius,length(M));
        thTor(:,mesh) = angles*pi/180;
        alf = acos(linspace(-(scale*(2*Std(mesh))+Rmin),(scale*(2*Std(mesh))+Rmin),length(M))/(scale*(2*Std(mesh))+Rmin));
        Z_top(mesh,:) = (scale*(2*Std(mesh))+Rmin)*sin(alf);
        Z_bottom(mesh,:) = -Z_top(mesh,:);
        Cmap(mesh,:) = M(mesh);
    end 

    Rcol = Radius*ones(size(thcol));
    [Xcol,Ycol] = pol2cart(thcol,Rcol);
    
    figure(figNum)
    subplot(1,2,1)
    [X,Y,Z] = pol2cart(thTor,rTor,Z_top);
    caxis('manual');
    surf(X,Y,Z+offZ,Cmap)
    [X,Y,Z] = pol2cart(thTor,rTor,Z_bottom);
    caxis('manual');
    surf(X,Y,Z+offZ,Cmap);
    shading interp
    flex_ext = plot3(Xcol,Ycol,offZ*ones(size(Ycol)),'r','DisplayName','Arm flexion-extension','LineWidth',LW);
    
% Left Arm abduction-adduction 'lbd' 
Radius = Rint + Zstep;
offZ = 3*Zstep;

    err = lbd(:,1)-lbd(:,2);

    TH = lbd(:,2);
    [angles,M,Std] = PolarMean(TH,err,span);

    rTor = zeros(length(M));
    thTor = zeros(length(M));
    Z_top = zeros(length(M));
    Z_bottom = zeros(length(M));
    Cmap = zeros(length(M));

    for mesh=1:length(M)
        rTor(mesh,:) = linspace(Radius-(scale*(2*Std(mesh))+Rmin),Rmin+scale*(2*Std(mesh))+Radius,length(M));
        thTor(:,mesh) = angles*pi/180;
        alf = acos(linspace(-(scale*(2*Std(mesh))+Rmin),(scale*(2*Std(mesh))+Rmin),length(M))/(scale*(2*Std(mesh))+Rmin));
        Z_top(mesh,:) = (scale*(2*Std(mesh))+Rmin)*sin(alf);
        Z_bottom(mesh,:) = -Z_top(mesh,:);
        Cmap(mesh,:) = M(mesh);
    end 
    
    Rcol = Radius*ones(size(thcol));
    [Xcol,Ycol] = pol2cart(thcol,Rcol);

    figure(figNum)
    subplot(1,2,1)
    [X,Y,Z] = pol2cart(thTor,rTor,Z_top);
    caxis('manual');
    surf(X,Y,Z+offZ,Cmap);
    [X,Y,Z] = pol2cart(thTor,rTor,Z_bottom);
    caxis('manual');
    surf(X,Y,Z+offZ,Cmap);
    shading interp
    abd_add = plot3(Xcol,Ycol,offZ*ones(size(Ycol)),'b','DisplayName','Arm abduction-adduction','LineWidth',LW);

% Left Forearm flexion-extension without abduction 'lelbfe'
Radius = Rint + 2*Zstep;
offZ = 2*Zstep;

    err = lelbfe(:,1)-lelbfe(:,2);

    TH = lelbfe(:,2);
    [angles,M,Std] = PolarMean(TH,err,span);

    rTor = zeros(length(M));
    thTor = zeros(length(M));
    Z_top = zeros(length(M));
    Z_bottom = zeros(length(M));
    Cmap = zeros(length(M));

    for mesh=1:length(M)
        rTor(mesh,:) = linspace(Radius-(scale*(2*Std(mesh))+Rmin),Rmin+scale*(2*Std(mesh))+Radius,length(M));
        thTor(:,mesh) = angles*pi/180;
        alf = acos(linspace(-(scale*(2*Std(mesh))+Rmin),(scale*(2*Std(mesh))+Rmin),length(M))/(scale*(2*Std(mesh))+Rmin));
        Z_top(mesh,:) = (scale*(2*Std(mesh))+Rmin)*sin(alf);
        Z_bottom(mesh,:) = -Z_top(mesh,:);
        Cmap(mesh,:) = M(mesh);
    end 
    
    Rcol = Radius*ones(size(thcol));
    [Xcol,Ycol] = pol2cart(thcol,Rcol);

    figure(figNum)
    subplot(1,2,1)
    [X,Y,Z] = pol2cart(thTor,rTor,Z_top);
    caxis('manual');
    surf(X,Y,Z+offZ,Cmap);
    [X,Y,Z] = pol2cart(thTor,rTor,Z_bottom);
    caxis('manual');
    surf(X,Y,Z+offZ,Cmap);
    shading interp
    Elb_felxext = plot3(Xcol,Ycol,offZ*ones(size(Ycol)),'k','DisplayName','Forearm flexion-extension without abduction','LineWidth',LW);

% Left Forearm flexion-extension with abduction 'lelbfe1'
Radius = Rint + 3*Zstep;
offZ = Zstep;

    err = lelbfe1(:,1)-lelbfe1(:,2);

    TH = lelbfe1(:,2);
    [angles,M,Std] = PolarMean(TH,err,span);

    rTor = zeros(length(M));
    thTor = zeros(length(M));
    Z_top = zeros(length(M));
    Z_bottom = zeros(length(M));
    Cmap = zeros(length(M));

    for mesh=1:length(M)
        rTor(mesh,:) = linspace(Radius-(scale*(2*Std(mesh))+Rmin),Rmin+scale*(2*Std(mesh))+Radius,length(M));
        thTor(:,mesh) = angles*pi/180;
        alf = acos(linspace(-(scale*(2*Std(mesh))+Rmin),(scale*(2*Std(mesh))+Rmin),length(M))/(scale*(2*Std(mesh))+Rmin));
        Z_top(mesh,:) = (scale*(2*Std(mesh))+Rmin)*sin(alf);
        Z_bottom(mesh,:) = -Z_top(mesh,:);
        Cmap(mesh,:) = M(mesh);
    end 

    Rcol = Radius*ones(size(thcol));
    [Xcol,Ycol] = pol2cart(thcol,Rcol);

    figure(figNum)
    subplot(1,2,1)
    [X,Y,Z] = pol2cart(thTor,rTor,Z_top);
    caxis('manual');
    surf(X,Y,Z+offZ,Cmap);
    [X,Y,Z] = pol2cart(thTor,rTor,Z_bottom);
    caxis('manual');
    surf(X,Y,Z+offZ,Cmap);
    shading interp
    Elb_felxext1 = plot3(Xcol,Ycol,offZ*ones(size(Ycol)),'Color',[0 153/255 51/255],'DisplayName','Forearm flexion-extension with abduction','LineWidth',LW);

% Left Arm internal-external rotation with flexion 'lie'
Radius = Rint + 4*Zstep;

    err = lie(:,1)-lie(:,2);
                
    TH = lie(:,2);
    [angles,M,Std] = PolarMean(TH,err,span);

    rTor = zeros(length(M));
    thTor = zeros(length(M));
    Z_top = zeros(length(M));
    Z_bottom = zeros(length(M));
    Cmap = zeros(length(M));

    for mesh=1:length(M)
        rTor(mesh,:) = linspace(Radius-(scale*(2*Std(mesh))+Rmin),Rmin+scale*(2*Std(mesh))+Radius,length(M));
        thTor(:,mesh) = angles*pi/180;
        alf = acos(linspace(-(scale*(2*Std(mesh))+Rmin),(scale*(2*Std(mesh))+Rmin),length(M))/(scale*(2*Std(mesh))+Rmin));
        Z_top(mesh,:) = (scale*(2*Std(mesh))+Rmin)*sin(alf);
        Z_bottom(mesh,:) = -Z_top(mesh,:);
        Cmap(mesh,:) = M(mesh);
    end 

    Rcol = Radius*ones(size(thcol));
    [Xcol,Ycol] = pol2cart(thcol,Rcol);

    figure(figNum)
    subplot(1,2,1)
    [X,Y,Z] = pol2cart(thTor,rTor,Z_top);
    caxis('manual');
    surf(X,Y,Z,Cmap);
    [X,Y,Z] = pol2cart(thTor,rTor,Z_bottom);
    caxis('manual');
    surf(X,Y,Z,Cmap);
    shading interp
    int_ext = plot(Xcol,Ycol,'m','DisplayName','Arm internal-external rotation with flexion','LineWidth',LW);
    
% 'rfe'
Radius = Rint;
offZ = 4*Zstep;

    err = rfe(:,1)-rfe(:,2);

    TH = rfe(:,2);
    [angles,M,Std] = PolarMean(TH,err,span);

    rTor = zeros(length(M));
    thTor = zeros(length(M));
    Z_top = zeros(length(M));
    Z_bottom = zeros(length(M));
    Cmap = zeros(length(M));

    for mesh=1:length(M)
        rTor(mesh,:) = linspace(Radius-(scale*(2*Std(mesh))+Rmin),Rmin+scale*(2*Std(mesh))+Radius,length(M));
        thTor(:,mesh) = angles*pi/180;
        alf = acos(linspace(-(scale*(2*Std(mesh))+Rmin),(scale*(2*Std(mesh))+Rmin),length(M))/(scale*(2*Std(mesh))+Rmin));
        Z_top(mesh,:) = (scale*(2*Std(mesh))+Rmin)*sin(alf);
        Z_bottom(mesh,:) = -Z_top(mesh,:);
        Cmap(mesh,:) = M(mesh);
    end 
    
    Rcol = Radius*ones(size(thcol));
    [Xcol,Ycol] = pol2cart(thcol,Rcol);

    figure(figNum)
    subplot(1,2,2)
    [X,Y,Z] = pol2cart(thTor,rTor,Z_top);
    caxis('manual');
    surf(X,Y,Z+offZ,Cmap);
    [X,Y,Z] = pol2cart(thTor,rTor,Z_bottom);
    caxis('manual');
    surf(X,Y,Z+offZ,Cmap);
    shading interp
    plot3(Xcol,Ycol,offZ*ones(size(Ycol)),'r','LineWidth',LW)
    
% 'rbd'
Radius = Rint + Zstep;
offZ = 3*Zstep;

    err = rbd(:,1)-rbd(:,2);

    TH = rbd(:,2);
    [angles,M,Std] = PolarMean(TH,err,span);

    rTor = zeros(length(M));
    thTor = zeros(length(M));
    Z_top = zeros(length(M));
    Z_bottom = zeros(length(M));
    Cmap = zeros(length(M));

    for mesh=1:length(M)
        rTor(mesh,:) = linspace(Radius-(scale*(2*Std(mesh))+Rmin),Rmin+scale*(2*Std(mesh))+Radius,length(M));
        thTor(:,mesh) = angles*pi/180;
        alf = acos(linspace(-(scale*(2*Std(mesh))+Rmin),(scale*(2*Std(mesh))+Rmin),length(M))/(scale*(2*Std(mesh))+Rmin));
        Z_top(mesh,:) = (scale*(2*Std(mesh))+Rmin)*sin(alf);
        Z_bottom(mesh,:) = -Z_top(mesh,:);
        Cmap(mesh,:) = M(mesh);
    end 
    
    Rcol = Radius*ones(size(thcol));
    [Xcol,Ycol] = pol2cart(thcol,Rcol);

    figure(figNum)
    subplot(1,2,2)
    [X,Y,Z] = pol2cart(thTor,rTor,Z_top);
    caxis('manual');
    surf(X,Y,Z+offZ,Cmap);
    [X,Y,Z] = pol2cart(thTor,rTor,Z_bottom);
    caxis('manual');
    surf(X,Y,Z+offZ,Cmap);
    shading interp
    plot3(Xcol,Ycol,offZ*ones(size(Ycol)),'b','LineWidth',LW)
    
% 'relbfe'
Radius = Rint + 2*Zstep;
offZ = 2*Zstep;

    err = relbfe(:,1)-relbfe(:,2);

    TH = relbfe(:,2);
    [angles,M,Std] = PolarMean(TH,err,span);

    rTor = zeros(length(M));
    thTor = zeros(length(M));
    Z_top = zeros(length(M));
    Z_bottom = zeros(length(M));
    Cmap = zeros(length(M));

    for mesh=1:length(M)
        rTor(mesh,:) = linspace(Radius-(scale*(2*Std(mesh))+Rmin),Rmin+scale*(2*Std(mesh))+Radius,length(M));
        thTor(:,mesh) = angles*pi/180;
        alf = acos(linspace(-(scale*(2*Std(mesh))+Rmin),(scale*(2*Std(mesh))+Rmin),length(M))/(scale*(2*Std(mesh))+Rmin));
        Z_top(mesh,:) = (scale*(2*Std(mesh))+Rmin)*sin(alf);
        Z_bottom(mesh,:) = -Z_top(mesh,:);
        Cmap(mesh,:) = M(mesh);
    end 
    
    Rcol = Radius*ones(size(thcol));
    [Xcol,Ycol] = pol2cart(thcol,Rcol);

    figure(figNum)
    subplot(1,2,2)
    [X,Y,Z] = pol2cart(thTor,rTor,Z_top);
    caxis('manual');
    surf(X,Y,Z+offZ,Cmap);
    [X,Y,Z] = pol2cart(thTor,rTor,Z_bottom);
    caxis('manual');
    surf(X,Y,Z+offZ,Cmap);
    shading interp
    plot3(Xcol,Ycol,offZ*ones(size(Ycol)),'k','LineWidth',LW)
    
% 'relbfe1'
Radius = Rint + 3*Zstep;
offZ = Zstep;

    err = relbfe1(:,1)-relbfe1(:,2);

    TH = relbfe1(:,2);
    [angles,M,Std] = PolarMean(TH,err,span);

    rTor = zeros(length(M));
    thTor = zeros(length(M));
    Z_top = zeros(length(M));
    Z_bottom = zeros(length(M));
    Cmap = zeros(length(M));

    for mesh=1:length(M)
        rTor(mesh,:) = linspace(Radius-(scale*(2*Std(mesh))+Rmin),Rmin+scale*(2*Std(mesh))+Radius,length(M));
        thTor(:,mesh) = angles*pi/180;
        alf = acos(linspace(-(scale*(2*Std(mesh))+Rmin),(scale*(2*Std(mesh))+Rmin),length(M))/(scale*(2*Std(mesh))+Rmin));
        Z_top(mesh,:) = (scale*(2*Std(mesh))+Rmin)*sin(alf);
        Z_bottom(mesh,:) = -Z_top(mesh,:);
        Cmap(mesh,:) = M(mesh);
    end 

    Rcol = Radius*ones(size(thcol));
    [Xcol,Ycol] = pol2cart(thcol,Rcol);

    figure(figNum)
    subplot(1,2,2)
    [X,Y,Z] = pol2cart(thTor,rTor,Z_top);
    caxis('manual');
    surf(X,Y,Z+offZ,Cmap);
    [X,Y,Z] = pol2cart(thTor,rTor,Z_bottom);
    caxis('manual');
    surf(X,Y,Z+offZ,Cmap);
    shading interp
    plot3(Xcol,Ycol,offZ*ones(size(Ycol)),'Color',[0 153/255 51/255],'LineWidth',LW)
    
% 'rie'
Radius = Rint + 4*Zstep;

    err = rie(:,1)-rie(:,2);
                
    TH = rie(:,2);
    [angles,M,Std] = PolarMean(TH,err,span);

    rTor = zeros(length(M));
    thTor = zeros(length(M));
    Z_top = zeros(length(M));
    Z_bottom = zeros(length(M));
    Cmap = zeros(length(M));

    for mesh=1:length(M)
        rTor(mesh,:) = linspace(Radius-(scale*(2*Std(mesh))+Rmin),Rmin+scale*(2*Std(mesh))+Radius,length(M));
        thTor(:,mesh) = angles*pi/180;
        alf = acos(linspace(-(scale*(2*Std(mesh))+Rmin),(scale*(2*Std(mesh))+Rmin),length(M))/(scale*(2*Std(mesh))+Rmin));
        Z_top(mesh,:) = (scale*(2*Std(mesh))+Rmin)*sin(alf);
        Z_bottom(mesh,:) = -Z_top(mesh,:);
        Cmap(mesh,:) = M(mesh);
    end 

    Rcol = Radius*ones(size(thcol));
    [Xcol,Ycol] = pol2cart(thcol,Rcol);

    figure(figNum)
    subplot(1,2,2)
    [X,Y,Z] = pol2cart(thTor,rTor,Z_top);
    caxis('manual');
    surf(X,Y,Z,Cmap);
    [X,Y,Z] = pol2cart(thTor,rTor,Z_bottom);
    caxis('manual');
    surf(X,Y,Z,Cmap);
    shading interp
    plot(Xcol,Ycol,'m','LineWidth',LW)
    
% final


lgnd  = legend(SubP1,[flex_ext,abd_add,Elb_felxext,Elb_felxext1,int_ext],'Location','none','FontSize',font);
set(lgnd, 'Position', [0.4498 0.7788 0.1495 0.0891])

                
end