
function [anline,anline1,fid] = TitleUpdate(arg,SUBJECTID)
cd('F:\github\wearable-jacket\matlab\kinect+imudata\');
font = 20;
figure(2)
hold on
set( gcf, 'DoubleBuffer', 'on','keypress','k=get(gcf,''currentchar'');' );
xlabel('Time (seconds)','FontWeight','bold','FontSize',font);
ylabel('Joint angles (degrees)','FontWeight','bold','FontSize',font);
legend('Location','NorthWest','FontWeight','bold','FontSize',font);
axes1 = gca;axes2  = gca;
anline = animatedline(axes1,'Color','r','DisplayName','KINECT');
anline1 = animatedline(axes2,'Color','b','DisplayName','IMU');

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
file = sprintf('%s_WISE+KINECT_testing_%s_%s.txt',num2str(SUBJECTID),datestr(now,'mm-dd-yyyy HH-MM'),arg);
fid = fopen(file,'wt');
fprintf( fid, '%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s\n','Timestamp','Kinect_LeftShoulder_Ext.-Flex.',...
'IMU_LeftShoulder_Ext.-Flex.','Kinect_LeftShoulder_Abd.-Add.','IMU_LeftShoulder_Abd.-Add.','Kinect_LeftShoulder_Int.-Ext.',...
'IMU_LeftShoulder_Int.-Ext.','Kinect_LeftElbow_Ext.-Flex.','IMU_LeftElbow_Ext.-Flex.','IMU_LeftElbow_Pro.-Sup.',...
'Kinect_RightShoulder_Ext.-Flex.','IMU_RightShoulder_Ext.-Flex.','Kinect_RightShoulder_Abd.-Add.','IMU_RightShoulder_Abd.-Add.',...
'Kinect_RightShoulder_Int.-Ext.','IMU_RightShoulder_Int.-Ext.','Kinect_RightElbow_Ext.-Flex.','IMU_RightElbow_Ext.-Flex.',...
'IMU_RightElbow_Pro.-Sup.');
vi = sprintf('%s%s.mp4','F:\unityrecordings\vid_',arg);
[~,~] = system(vi);
end

