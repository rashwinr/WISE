function [fid] = Update_video(arg,WID,WID1,WID2)
addpath('F:\github\wearable-jacket\matlab\ieee_jbhi\JCS_data\');
sts = 'F:\github\wearable-jacket\matlab\ieee_jbhi\JCS_data\';
cd(sts);
if ~exist(WID,'dir')
mkdir(WID);
end
cd(strcat(sts,WID,'\'));
f = sprintf('%s_%s_%s_WISE+JCS-%s.txt',arg,WID2,WID1,datestr(now,'mm-dd-yyyy HH-MM'));
fid = fopen(f,'wt');
fprintf(fid,'%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s\n','Time','Left shoulder plane','Left shoulder elevation','Left shoulder int.-ext.','Left carrying angle','Left elbow flex.-ext.','Left forearm pro.-sup.',...
    'Right shoulder plane','Right shoulder elevation','Right shoulder int.-ext.','Right carrying angle','Right elbow flex.-ext.','Right forearm pro.-sup.');
vilink = sprintf('%s%s.mp4','F:\unityrecordings\',arg);
[~,~] = system(vilink);

end