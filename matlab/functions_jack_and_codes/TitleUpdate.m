
function [anline,anline1,fid] = TitleUpdate(arg,SUBJECTID)
cd('F:\github\wearable-jacket\matlab\kinect+imudata\');
font = 20;
figure(2);
hold on
set( gcf, 'DoubleBuffer', 'on','keypress','k=get(gcf,''currentchar'');' );
xlabel('Time (seconds)','FontWeight','bold','FontSize',font);
ylabel('Joint angles (degrees)','FontWeight','bold','FontSize',font);
legend('Location','NorthWest','FontWeight','bold','FontSize',font);
axes1 = gca;axes2  = gca;
anline = animatedline(axes1,'Color','r','DisplayName','KINECT');
anline1 = animatedline(axes2,'Color','b','DisplayName','WISE');

switch arg
    case 'lef'
         title('Left shoulder flexion-extension','FontWeight','bold','FontSize',font);
    case 'lbd'
         title('Left shoulder abduction-adduction','FontWeight','bold','FontSize',font);
    case {'lelb','lelb1'}
         title('Left elbow flexion-extension','FontWeight','bold','FontSize',font);
    case 'lps'
         title('Left forearm pronation-supination','FontWeight','bold','FontSize',font);
    case {'lie','lie1'} 
         title('Left shoulder internal-external rotation','FontWeight','bold','FontSize',font);
    case 'ref'
         title('Right shoulder flexion-extension','FontWeight','bold','FontSize',font);
    case 'rbd'
         title('Right shoulder abduction-adduction','FontWeight','bold','FontSize',font);
    case {'relb','relb1'}
         title('Right elbow flexion-extension','FontWeight','bold','FontSize',font);
    case 'rps'
         title('Right forearm pronation-supination','FontWeight','bold','FontSize',font);
    case {'rie','rie1'}
         title('Right shoulder internal-external rotation','FontWeight','bold','FontSize',font);
end
hold off
file = sprintf('%s_WISE+KINECT_%s_%s.txt',num2str(SUBJECTID),datestr(now,'mm-dd-yyyy HH-MM'),arg);
fid = fopen(file,'wt');
fprintf( fid, '%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s\n','Timestamp','Kinect left shoulder flex.-ext.',...
'WISE left shoulder flex.-ext.','Kinect left shoulder abd.-add.','WISE left shoulder abd.-add.','Kinect left shoulder int.- ext.',...
'WISE left shoulder int.- ext.','Kinect left elbow flex.-ext.','WISE left elbow flex.-ext.','WISE left forearm pro.- sup.',...
'Kinect right shoulder flex.-ext.','WISE right shoulder flex.-ext.','Kinect right shoulder Abd.-Add.','WISE right shoulder abd.-add.',...
'Kinect right shoulder int.-ext.','WISE right shoulder int.-ext.','Kinect right elbow flex.-ext.','WISE right elbow flex.-ext.',...
'WISE right forearm pro.-sup.');
vi = sprintf('%s%s.mp4','F:\unityrecordings\vid_',arg);
[~,~] = system(vi);
end

