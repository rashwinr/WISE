function SmoothSubPlot(SID,fignum,lfe,lbd,lelbfe,lelbfe1,lie,rfe,rbd,relbfe,relbfe1,rie)

Row = find(lfe(:,3)<10);
lfe(Row,:) = [];

Row = find(lbd(:,3)<10);
lbd(Row,:) = [];

Row = find(lelbfe(:,3)<10);
lelbfe(Row,:) = [];

Row = find(lelbfe1(:,3)<10);
lelbfe1(Row,:) = [];

Row = find(lie(:,3)<10);
lie(Row,:) = [];

Row = find(rfe(:,3)<10);
rfe(Row,:) = [];

Row = find(rbd(:,3)<10);
rbd(Row,:) = [];

Row = find(relbfe(:,3)<10);
relbfe(Row,:) = [];

Row = find(relbfe1(:,3)<10);
relbfe1(Row,:) = [];

Row = find(rie(:,3)<10);
rie(Row,:) = [];

font = 15;
mrk = 10;

figure(fignum)
sgtitle(strcat(num2str(SID),' Kinect+WISE'));

lfe(:,1) = smooth(lfe(:,1),2);
[Kpeak,Kloc] = findpeaks(lfe(:,1),lfe(:,3),'MinPeakHeight',40,'NPeaks',8,'MinPeakProminence',50);
lfe(:,2) = smooth(lfe(:,2),2);
[Ipeak,Iloc] = findpeaks(lfe(:,2),lfe(:,3),'MinPeakHeight',40,'NPeaks',8,'MinPeakProminence',50);

klfe_ = -lfe(:,1);
[~,kloc] = findpeaks(klfe_,'MinPeakHeight',-40,'NPeaks',7,'MinPeakProminence',50);
kmin = lfe(kloc,1);
kloc = lfe(kloc,3);
ilfe_ = -lfe(:,2);
[~,iloc] = findpeaks(ilfe_,'MinPeakHeight',-40,'NPeaks',7,'MinPeakProminence',50);
imin = lfe(iloc,1);
iloc = lfe(iloc,3);

Kw = [Kpeak,Kloc;kmin,kloc];
Kw = sortrows(Kw,2);
Iw = [Ipeak,Iloc;imin,iloc];
Iw = sortrows(Iw,2);

SubP1 = subplot(5,2,1);
title('Left arm flexion-extension')
hold on
KNT = plot(lfe(:,3),lfe(:,1),'r','DisplayName','Kinect');
IMU = plot(lfe(:,3),lfe(:,2),'b','DisplayName','WISE');
scatter(Kw(:,2),Kw(:,1),mrk,'r','filled')
scatter(Iw(:,2),Iw(:,1),mrk,'b','filled')


subplot(5,2,3)
title('Left arm abduction-adduction')
lbd(:,1) = smooth(lbd(:,1),2);
lbd(:,2) = smooth(lbd(:,2),2);
hold on
plot(lbd(:,3),lbd(:,1),'r')
plot(lbd(:,3),lbd(:,2),'b')

subplot(5,2,5)
title('Left forearm Flexion-Extension without abduction')
lelbfe(:,1) = smooth(lelbfe(:,1),2);
lelbfe(:,2) = smooth(lelbfe(:,2),2);
hold on
plot(lelbfe(:,3),lelbfe(:,1),'r')
plot(lelbfe(:,3),lelbfe(:,2),'b')

subplot(5,2,7)
title('Left forearm Flexion-Extension with abduction')
lelbfe1(:,1) = smooth(lelbfe1(:,1),2);
lelbfe1(:,2) = smooth(lelbfe1(:,2),2);
hold on
plot(lelbfe1(:,3),lelbfe1(:,1),'r')
plot(lelbfe1(:,3),lelbfe1(:,2),'b')

subplot(5,2,9)
title('Left arm internal-external rotation')
lie(:,1) = smooth(lie(:,1),2);
lie(:,2) = smooth(lie(:,2),2);
hold on
plot(lie(:,3),lie(:,1),'r')
plot(lie(:,3),lie(:,2),'b')



subplot(5,2,2)
title('Right arm flexion-extension')
rfe(:,1) = smooth(rfe(:,1),2);
rfe(:,2) = smooth(rfe(:,2),2);
hold on
plot(rfe(:,3),rfe(:,1),'r')
plot(rfe(:,3),rfe(:,2),'b')

subplot(5,2,4)
title('Right arm abduction-adduction')
rbd(:,1) = smooth(rbd(:,1),2);
rbd(:,2) = smooth(rbd(:,2),2);
hold on
plot(rbd(:,3),rbd(:,1),'r')
plot(rbd(:,3),rbd(:,2),'b')

subplot(5,2,6)
title('Right forearm Flexion-Extension without abduction')
relbfe(:,1) = smooth(relbfe(:,1),2);
relbfe(:,2) = smooth(relbfe(:,2),2);
hold on
plot(relbfe(:,3),relbfe(:,1),'r')
plot(relbfe(:,3),relbfe(:,2),'b')

subplot(5,2,8)
title('Right forearm Flexion-Extension with abduction')
relbfe1(:,1) = smooth(relbfe1(:,1),2);
relbfe1(:,2) = smooth(relbfe1(:,2),2);
hold on
plot(relbfe1(:,3),relbfe1(:,1),'r')
plot(relbfe1(:,3),relbfe1(:,2),'b')

subplot(5,2,10)
title('Right arm internal-external rotation')
rie(:,1) = smooth(rie(:,1),2);
rie(:,2) = smooth(rie(:,2),2);
hold on
plot(rie(:,3),rie(:,1),'r')
plot(rie(:,3),rie(:,2),'b')

lgnd  = legend(SubP1,[KNT,IMU],'Location','none','FontSize',font);
set(lgnd, 'Position', [0.4196 0.4337 0.1911 0.1326])

end