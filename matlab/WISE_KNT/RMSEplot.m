function RMSEplot(SID,fignum,lfe,lbd,lelbfe,lelbfe1,lie,rfe,rbd,relbfe,relbfe1,rie)

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

figure(fignum)
sgtitle(strcat(num2str(SID),' Kinect+WISE ',' Error vs Time'));

subplot(5,2,1);
title('Left arm flexion-extension')
err = abs(lfe(:,1)-lfe(:,2));
err = smooth(err);
hold on
plot(lfe(:,3),err,'k');

subplot(5,2,3)
title('Left arm abduction-adduction')
err = abs(lbd(:,1)-lbd(:,2));
err = smooth(err);
hold on
plot(lbd(:,3),err,'k')

subplot(5,2,5)
title('Left forearm Flexion-Extension without abduction')
err = abs(lelbfe(:,1)-lelbfe(:,2));
err = smooth(err);
hold on
plot(lelbfe(:,3),err,'k')

subplot(5,2,7)
title('Left forearm Flexion-Extension with abduction')
err = abs(lelbfe1(:,1)-lelbfe1(:,2));
err = smooth(err);
hold on
plot(lelbfe1(:,3),err(:,1),'k')

subplot(5,2,9)
title('Left arm internal-external rotation')
err = abs(lie(:,1)-lie(:,2));
err = smooth(err);
hold on
plot(lie(:,3),err,'k')



subplot(5,2,2)
title('Right arm flexion-extension')
err = abs(rfe(:,1)-rfe(:,2));
err = smooth(err);
hold on
plot(rfe(:,3),err,'k')

subplot(5,2,4)
title('Right arm abduction-adduction')
err = abs(rbd(:,1)-rbd(:,2));
err = smooth(err);
hold on
plot(rbd(:,3),err,'k')

subplot(5,2,6)
title('Right forearm Flexion-Extension without abduction')
err = abs(relbfe(:,1)-relbfe(:,2));
err = smooth(err);
hold on
plot(relbfe(:,3),err,'k')

subplot(5,2,8)
title('Right forearm Flexion-Extension with abduction')
err = abs(relbfe1(:,1)-relbfe1(:,2));
err = smooth(err);
hold on
plot(relbfe1(:,3),err,'k')

subplot(5,2,10)
title('Right arm internal-external rotation')
err = abs(rie(:,1)-rie(:,2));
err = smooth(err);
hold on
plot(rie(:,3),err,'k')


end