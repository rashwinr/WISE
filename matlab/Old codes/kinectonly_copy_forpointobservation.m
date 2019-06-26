%Joint angles of Wearable Jacket connected with Kinect
clear all; close all; clc;
telapsed = 0;tt = 0;lkinef = 0;font = 18;flag=0;
cd('F:\github\wearable-jacket\matlab\kinect+imudata\');
addpath('F:\github\wearable-jacket\matlab\KInectProject\Kin2');
addpath('F:\github\wearable-jacket\matlab\KInectProject\Kin2\Mex');
addpath('F:\github\wearable-jacket\matlab\KInectProject');
k2 = Kin2('color','depth','body','face');
qC = [1,0,0,0];qD = [1,0,0,0];qA = [1,0,0,0];qB = [1,0,0,0];qE = [1,0,0,0];                                                 %Quaternion variables
lef = 0;lec=1;lefflag = 0;
empty = [1,0,0,0];
Cal_A = [0 0 0 0];Cal_B = [0 0 0 0];Cal_C = [0 0 0 0];Cal_D = [0 0 0 0];Cal_E = [0 0 0 0];
imustr = strcat('mKINECT');kntstr = strcat('KINECT');
lftstr = strcat('Left arm angles');rgtstr = strcat('Right arm angles');
efstr = strcat('Flex-Ext');bdstr = strcat('Abd-Add');
iestr = strcat('Int-Ext Rot.');psstr = strcat('Pro-Sup');
jtext = strcat('Joint');etext = strcat('Elbow');         
stext = strcat('Shoulder');ftext = strcat('Forearm');
lkinefangle = 0;rkinefangle = 0;
lkinbdangle = 0;rkinbdangle = 0;
lkinieangle = 0;rkinieangle = 0;
lkinelbangle = 0;rkinelbangle = 0;
lkinelb1angle = 0;rkinelb1angle = 0;
lkinefangle1 = 0;rkinefangle1 = 0;
lkinbdangle1 = 0;rkinbdangle1 = 0;
lkinieangle1 = 0;rkinieangle1 = 0;
lkinelbangle1 = 0;rkinelbangle1 = 0;
lkinelb1angle1 = 0;rkinelb1angle1 = 0;
fs = 24;s=35;fontdiv = 1.3;limulocationdiv = 1.9/2.2;rimulocationdiv = 2.1/2.4;lkinlocationdiv = 1.75;rkinlocationdiv = 1.75;
ls = 0;rs = 1350;lw = 475;H = 1080;rw = 570;                                                                                %rectangle coordinates
outOfRange = 4000;
c_width = 1920; c_height = 1080;
COL_SCALE = 1.0;
color = zeros(c_height*COL_SCALE,c_width*COL_SCALE,3,'uint8');
c.h = figure;
c.ax = axes;
c.im = imshow(color,[]);
set( gcf, 'DoubleBuffer', 'on','keypress','k=get(gcf,''currentchar'');' );
k=[];
figure(2)
title('Z position','FontWeight','bold','FontSize',font)
set( gcf, 'DoubleBuffer', 'on','keypress','k=get(gcf,''currentchar'');' );
hold on
xlabel('Time (seconds)','FontWeight','bold','FontSize',font);
ylabel('Z-pos (meters)','FontWeight','bold','FontSize',font);
legend('Location','NorthWest','FontWeight','bold','FontSize',font);
axes1 = gca;
axes2 = gca;
axes3 = gca;
axes4 = gca;
anline = animatedline(axes1,'Color','r','DisplayName','LS');
anline1 = animatedline(axes2,'Color','g','DisplayName','RS');
anline2 = animatedline(axes3,'Color','b','DisplayName','SS');
anline3 = animatedline(axes4,'Color','k','DisplayName','SC');
hold off
figure(1)                                                                                      

while true
    tstart=tic;
    validData = k2.updateData;                                                                                              %Kinect section
    if validData
        depth = k2.getDepth;color = k2.getColor;face = k2.getFaces;
        depth8u = uint8(depth*(255/outOfRange));depth8uc3 = repmat(depth8u,[1 1 3]);color = imresize(color,COL_SCALE);
        c.im = imshow(color, 'Parent', c.ax);rectangle('Position',[ls 0 lw H],'LineWidth',3,'FaceColor','k');rectangle('Position',[rs 0 rw H],'LineWidth',3,'FaceColor','k');
        [bodies, fcp, timeStamp] = k2.getBodies('Quat');
        numBodies = size(bodies,2);
       if numBodies == 1
            k2.drawBodies(c.ax,bodies,'color',3,2,1);
            k2.drawFaces(c.ax,face,5,false,20);
            pos2Dxxx = bodies(1).Position;                                                                              % All 25 joints positions are stored to the variable pos2Dxxx.
            [lkinef,rkinef,lkinbd,rkinbd,lkinie,rkinie,lkinelb,rkinelb] = get_Kinect(pos2Dxxx);
            x = pos2Dxxx(3,2);
            pos2Dxxx1 = pos2Dxxx;
            pos2Dxxx1(3,5) = x;   pos2Dxxx1(3,21) = x;     pos2Dxxx1(3,9) = x;
            [lkinefangle1,rkinefangle1,lkinbdangle1,rkinbdangle1,lkinieangle1,rkinieangle1,lkinelbangle1,rkinelbangle1] = get_Kinect(pos2Dxxx1);
            leftShoulder = pos2Dxxx(:,5);leftElbow = pos2Dxxx(:,6);leftWrist = pos2Dxxx(:,7);                               %Left Side Joints
            rightShoulder = pos2Dxxx(:,9);rightElbow = pos2Dxxx(:,10);rightWrist = pos2Dxxx(:,11);                          %Right Side Joints
            rightHand = pos2Dxxx(:,12);rightHandtip = pos2Dxxx(:,24);
            spineShoulder = pos2Dxxx(:,21);spineCenter = pos2Dxxx(:,2);spinebase = pos2Dxxx(:,1);                           %Spine Joints
            disp(strcat('LS: ',num2str(leftShoulder(3))));
            disp(strcat('RS: ',num2str(rightShoulder(3))));
            disp(strcat('SS: ',num2str(spineShoulder(3))));
            disp(strcat('SC: ',num2str(spineCenter(3))));
            
lkinefstr = num2str(lkinef,'%.1f');rkinefstr = num2str(rkinef,'%.1f');
lkinbdstr = num2str(lkinbd,'%.1f');rkinbdstr = num2str(rkinbd,'%.1f');
lkinelbstr = num2str(lkinelb,'%.1f');rkinelbstr = num2str(rkinelb,'%.1f');
lkiniestr = num2str(lkinie,'%.1f');rkiniestr = num2str(rkinie,'%.1f');
lkinefstr1 = num2str(lkinefangle1,'%.1f');rkinefstr1 = num2str(rkinefangle1,'%.1f');
lkinbdstr1 = num2str(lkinbdangle1,'%.1f');rkinbdstr1 = num2str(rkinbdangle1,'%.1f');
lkinelbstr1 = num2str(lkinelbangle1,'%.1f');rkinelbstr1 = num2str(rkinelbangle1,'%.1f');
lkiniestr1 = num2str(lkinieangle1,'%.1f');rkiniestr1 = num2str(rkinieangle1,'%.1f');
lkinelb1str =strcat('NA');rkinelb1str =strcat('NA');
lkinelb1str1 =strcat('NA');rkinelb1str1 =strcat('NA');
                                                                                                                            %Text placement on the left side
text(ls+lw/2,s,lftstr,'Color','white','FontSize',fs,'FontWeight','bold','HorizontalAlignment','center');
text(rs+rw/2,s,rgtstr,'Color','white','FontSize',fs,'FontWeight','bold','HorizontalAlignment','center');
text(ls+lw/5,4*s,jtext,'Color','white','FontSize',fs/fontdiv,'FontWeight','bold','HorizontalAlignment','center');
text(rs+rw/5,4*s,jtext,'Color','white','FontSize',fs/fontdiv,'FontWeight','bold','HorizontalAlignment','center');
text(ls+(lw/lkinlocationdiv),4*s,kntstr,'Color','white','FontSize',fs/fontdiv,'FontWeight','bold','HorizontalAlignment','center');
text(rs+(rw/rkinlocationdiv),4*s,kntstr,'Color','white','FontSize',fs/fontdiv,'FontWeight','bold','HorizontalAlignment','center');
text(ls+(limulocationdiv*lw),4*s,imustr,'Color','white','FontSize',fs/fontdiv,'FontWeight','bold','HorizontalAlignment','center');
text(rs+(rimulocationdiv*rw),4*s,imustr,'Color','white','FontSize',fs/fontdiv,'FontWeight','bold','HorizontalAlignment','center');
text(ls+lw/5,7*s,stext,'Color','white','FontSize',fs/fontdiv,'FontWeight','bold','HorizontalAlignment','center');
text(rs+rw/5,7*s,stext,'Color','white','FontSize',fs/fontdiv,'FontWeight','bold','HorizontalAlignment','center');
text(ls+lw/5,8*s,efstr,'Color','white','FontSize',fs/fontdiv,'FontWeight','normal','HorizontalAlignment','center');
text(rs+rw/5,8*s,efstr,'Color','white','FontSize',fs/fontdiv,'FontWeight','normal','HorizontalAlignment','center');
text(ls+(lw/lkinlocationdiv),7.5*s,lkinefstr,'Color','white','FontSize',fs/fontdiv,'FontWeight','normal','HorizontalAlignment','center');
text(rs+(rw/rkinlocationdiv),7.5*s,rkinefstr,'Color','white','FontSize',fs/fontdiv,'FontWeight','normal','HorizontalAlignment','center');
text(ls+(limulocationdiv*lw),7.5*s,lkinefstr1,'Color','white','FontSize',fs/fontdiv,'FontWeight','normal','HorizontalAlignment','center');
text(rs+(rimulocationdiv*rw),7.5*s,rkinefstr1,'Color','white','FontSize',fs/fontdiv,'FontWeight','normal','HorizontalAlignment','center');
text(ls+lw/5,11*s,stext,'Color','white','FontSize',fs/fontdiv,'FontWeight','bold','HorizontalAlignment','center');
text(rs+rw/5,11*s,stext,'Color','white','FontSize',fs/fontdiv,'FontWeight','bold','HorizontalAlignment','center');
text(ls+lw/5,12*s,bdstr,'Color','white','FontSize',fs/fontdiv,'FontWeight','normal','HorizontalAlignment','center');
text(rs+rw/5,12*s,bdstr,'Color','white','FontSize',fs/fontdiv,'FontWeight','normal','HorizontalAlignment','center');
text(ls+(lw/lkinlocationdiv),11.5*s,lkinbdstr,'Color','white','FontSize',fs/fontdiv,'FontWeight','normal','HorizontalAlignment','center');
text(rs+(rw/rkinlocationdiv),11.5*s,rkinbdstr,'Color','white','FontSize',fs/fontdiv,'FontWeight','normal','HorizontalAlignment','center');
text(ls+(limulocationdiv*lw),11.5*s,lkinbdstr1,'Color','white','FontSize',fs/fontdiv,'FontWeight','normal','HorizontalAlignment','center');
text(rs+(rimulocationdiv*rw),11.5*s,rkinbdstr1,'Color','white','FontSize',fs/fontdiv,'FontWeight','normal','HorizontalAlignment','center');
text(ls+lw/5,15*s,stext,'Color','white','FontSize',fs/fontdiv,'FontWeight','bold','HorizontalAlignment','center');
text(rs+rw/5,15*s,stext,'Color','white','FontSize',fs/fontdiv,'FontWeight','bold','HorizontalAlignment','center');
text(ls+lw/5,16*s,iestr,'Color','white','FontSize',fs/fontdiv,'FontWeight','normal','HorizontalAlignment','center');
text(rs+rw/5,16*s,iestr,'Color','white','FontSize',fs/fontdiv,'FontWeight','normal','HorizontalAlignment','center');
text(ls+(lw/lkinlocationdiv),15.5*s,lkiniestr,'Color','white','FontSize',fs/fontdiv,'FontWeight','normal','HorizontalAlignment','center');
text(rs+(rw/rkinlocationdiv),15.5*s,rkiniestr,'Color','white','FontSize',fs/fontdiv,'FontWeight','normal','HorizontalAlignment','center');
text(ls+lw/5,19*s,etext,'Color','white','FontSize',fs/fontdiv,'FontWeight','bold','HorizontalAlignment','center');
text(rs+rw/5,19*s,etext,'Color','white','FontSize',fs/fontdiv,'FontWeight','bold','HorizontalAlignment','center');
text(ls+lw/5,20*s,efstr,'Color','white','FontSize',fs/fontdiv,'FontWeight','normal','HorizontalAlignment','center');
text(rs+rw/5,20*s,efstr,'Color','white','FontSize',fs/fontdiv,'FontWeight','normal','HorizontalAlignment','center');
text(ls+(lw/lkinlocationdiv),19.5*s,lkinelbstr,'Color','white','FontSize',fs/fontdiv,'FontWeight','normal','HorizontalAlignment','center');
text(rs+(rw/rkinlocationdiv),19.5*s,rkinelbstr,'Color','white','FontSize',fs/fontdiv,'FontWeight','normal','HorizontalAlignment','center');
text(ls+(limulocationdiv*lw),19.5*s,lkinelbstr1,'Color','white','FontSize',fs/fontdiv,'FontWeight','normal','HorizontalAlignment','center');
text(rs+(rimulocationdiv*rw),19.5*s,rkinelbstr1,'Color','white','FontSize',fs/fontdiv,'FontWeight','normal','HorizontalAlignment','center');
text(ls+lw/5,23*s,ftext,'Color','white','FontSize',fs/fontdiv,'FontWeight','bold','HorizontalAlignment','center');
text(rs+rw/5,23*s,ftext,'Color','white','FontSize',fs/fontdiv,'FontWeight','bold','HorizontalAlignment','center');
text(ls+lw/5,24*s,psstr,'Color','white','FontSize',fs/fontdiv,'FontWeight','normal','HorizontalAlignment','center');
text(rs+rw/5,24*s,psstr,'Color','white','FontSize',fs/fontdiv,'FontWeight','normal','HorizontalAlignment','center');
text(ls+(lw/lkinlocationdiv),23.5*s,lkinelb1str,'Color','white','FontSize',fs/fontdiv,'FontWeight','normal','HorizontalAlignment','center');
text(rs+(rw/rkinlocationdiv),23.5*s,rkinelb1str,'Color','white','FontSize',fs/fontdiv,'FontWeight','normal','HorizontalAlignment','center');
text(ls+lw/3,1050,'Time (seconds)','Color','white','FontSize',fs/(fontdiv),'FontWeight','bold','HorizontalAlignment','center');
text(ls+(limulocationdiv*lw),1000,num2str(telapsed,'%.2f'),'Color','white','FontSize',fs/fontdiv,'FontWeight','normal','HorizontalAlignment','center');
addpoints(anline,telapsed,leftShoulder(3));
addpoints(anline1,telapsed,leftShoulder(3));
addpoints(anline2,telapsed,spineShoulder(3));
addpoints(anline3,telapsed,spineCenter(3));
drawnow
        end   
 if numBodies == 0
      s1 = strcat('No persons in view');   
      text((1920/2) - 250,100,s1,'Color','red','FontSize',30,'FontWeight','bold');
 end      
 if numBodies > 1
      s1 = strcat('Too many people in view');
      text(1920/2,100,s1,'Color','red','FontSize',30,'FontWeight','bold');
 end      
 if ~isempty(k)
  if strcmp(k,'q')
    break; 
  end
 end
    end
 pause(0.02);
 telapsed = telapsed+toc(tstart);
figure(1)
end

% Close kinect object
k2.delete;
close all;
