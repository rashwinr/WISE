%Joint angles of Wearable Jacket connected with Kinect
clear all; close all; clc;
telapsed = 0;i = 1;tt = 0;lkinef = 0;font = 18;flag=0;

addpath('C:\Users\fabio\github\wearable-jacket\matlab\KInectProject\Kin2');
addpath('C:\Users\fabio\github\wearable-jacket\matlab\KInectProject\Kin2\Mex');
addpath('C:\Users\fabio\github\wearable-jacket\matlab\KInectProject');

k2 = Kin2('color','depth','body','face');
qC = [1,0,0,0];qD = [1,0,0,0];qA = [1,0,0,0];qB = [1,0,0,0];qE = [1,0,0,0]; %Quaternion variables
lef = 0;ref=0;rbd = 0;lbd = 0;lec=1;lefflag = 0;
empty = [1,0,0,0];
Cal_A = [0 0 0 0];Cal_B = [0 0 0 0];Cal_C = [0 0 0 0];Cal_D = [0 0 0 0];Cal_E = [0 0 0 0];
imustr = strcat('IMU');kntstr = strcat('KINECT');
lftstr = strcat('Left arm angles');rgtstr = strcat('Right arm angles');
efstr = strcat('Flex-Ext');bdstr = strcat('Abd-Add');
iestr = strcat('Int-Ext Rot.');psstr = strcat('Pro-Sup');
jtext = strcat('Joint');etext = strcat('Elbow');         
stext = strcat('Shoulder');ftext = strcat('Forearm');
limuefangle = 0;rimuefangle = 0;lkinefangle = 0;rkinefangle = 0;
limubdangle = 0;rimubdangle = 0;lkinbdangle = 0;rkinbdangle = 0;
limuieangle = 0;rimuieangle = 10;lkinieangle = 0;rkinieangle = 0;
limuelbangle = 0;rimuelbangle = 0;lkinelbangle = 0;rkinelbangle = 0;
limuelb1angle = 0;rimuelb1angle = 0;lkinelb1angle = 0;rkinelb1angle = 0;
fs = 24;s=35;fontdiv = 1.3;limulocationdiv = 1.9/2.2;rimulocationdiv = 2.1/2.4;lkinlocationdiv = 1.75;rkinlocationdiv = 1.75;
ls = 0;rs = 1350;lw = 475;H = 1080;rw = 570;%rectangle coordinates
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
subplot(2,1,1)
title('Shoulder Flexion-Extension','FontWeight','bold','FontSize',font)
set( gcf, 'DoubleBuffer', 'on','keypress','k=get(gcf,''currentchar'');' );
hold on
xlabel('Time (seconds)','FontWeight','bold','FontSize',font);
ylabel('Joint angles (degrees)','FontWeight','bold','FontSize',font);
legend('Location','NorthWest','FontWeight','bold','FontSize',font);
axes1 = gca;
axes2  = gca;
anline = animatedline(axes1,'Color','r','DisplayName','LEFT');
anline1 = animatedline(axes2,'Color','b','DisplayName','RIGHT');
subplot(2,1,2)
title('Shoulder Abduction-Adduction','FontWeight','bold','FontSize',font)
set( gcf, 'DoubleBuffer', 'on','keypress','k=get(gcf,''currentchar'');' );
xlabel('Time (seconds)','FontWeight','bold','FontSize',font);
ylabel('Joint angles (degrees)','FontWeight','bold','FontSize',font);
legend('Location','NorthWest','FontWeight','bold','FontSize',font);
axes3 = gca;
axes4  = gca;
anline2 = animatedline(axes3,'Color','r','DisplayName','LEFT');
anline3 = animatedline(axes4,'Color','b','DisplayName','RIGHT');
hold off
while true
    tstart=tic;
                                                        %Kinect section
    validData = k2.updateData;
    if validData
            depth = k2.getDepth;color = k2.getColor;face = k2.getFaces;
            depth8u = uint8(depth*(255/outOfRange));depth8uc3 = repmat(depth8u,[1 1 3]);
            color = imresize(color,COL_SCALE);c.im = imshow(color, 'Parent', c.ax);
            rectangle('Position',[0 0 475 1080],'LineWidth',3,'FaceColor','k');  
            rectangle('Position',[1350 0 620 1080],'LineWidth',3,'FaceColor','k');
            [bodies, fcp, timeStamp] = k2.getBodies('Quat');
            numBodies = size(bodies,2);
       if numBodies == 1
           k2.drawBodies(c.ax,bodies,'color',3,2,1);
           k2.drawFaces(c.ax,face,5,false,20);
                %  Measuring the joints of the body in camera spac         
                pos2Dxxx = bodies(1).Position;              % All 25 joints positions are stored to the variable pos2Dxxx.
                %Left Side Joints
                leftShoulder = pos2Dxxx(:,5);
                leftElbow = pos2Dxxx(:,6);
                leftWrist = pos2Dxxx(:,7);
                hipLeft = pos2Dxxx(:,13);
                %Right Side Joints
                rightShoulder = pos2Dxxx(:,9); 
                rightElbow = pos2Dxxx(:,10);
                rightWrist = pos2Dxxx(:,11);
                hipRight = pos2Dxxx(:,17);
                %Spine Joints
                spineShoulder = pos2Dxxx(:,21);
                spineCenter = pos2Dxxx(:,2);
                spinebase = pos2Dxxx(:,1);
            
                %BACK REFERENCE
                TrunkVector = spinebase-spineShoulder;
                RSLS = (leftShoulder-rightShoulder)/norm(leftShoulder-rightShoulder);
            
                    %normal to transversal plane
                trans_X = (TrunkVector/norm(TrunkVector)); 
                    %normal to saggital plane
                sag_Y = ((RSLS-dot(RSLS,trans_X)*trans_X)/norm(RSLS-dot(RSLS,trans_X)*trans_X)); 
                    %normal to coronal plane 
                cor_Z = (cross(trans_X,sag_Y)/norm(cross(trans_X,sag_Y)));
                
                %Shoulder orientation computation
                L_arm = leftElbow-leftShoulder;
                L_arm = (L_arm/norm(L_arm));
                L_arm = [dot(L_arm,trans_X) , dot(L_arm,sag_Y) , dot(L_arm,cor_Z)];
                
                R_arm = rightElbow-rightShoulder;
                R_arm = (R_arm/norm(R_arm));
                R_arm = [dot(R_arm,trans_X) , dot(R_arm,sag_Y) , dot(R_arm,cor_Z)];
                
                %Shoulder extension flexion
                lkinefangle = atan2d(L_arm(2),L_arm(1));
                rkinefangle = atan2d(-R_arm(2),R_arm(1));
                
                %Shoulder abduction adduction
                lkinbdangle = atan2d(-L_arm(3),L_arm(1));
                rkinbdangle = atan2d(-R_arm(3),R_arm(1));
                
                %Elbow joint angle calculation
                LA=(leftElbow-leftShoulder)/norm(leftElbow-leftShoulder);
                LFA=(leftWrist-leftElbow)/norm(leftWrist-leftElbow);
                lkinelbangle=acosd(dot(LA,LFA));
                
                RA=(rightElbow-rightShoulder)/norm(rightElbow-rightShoulder);
                RFA=(rightWrist-rightElbow)/norm(rightWrist-rightElbow);
                rkinelbangle=acosd(dot(RA,RFA));

                %Shoulder internal external calculation
                lkiniestr = strcat('NA');
                if lkinelbangle > 30
                    xA = -LA;
                    zA = cross(LFA,LA)/norm(cross(LFA,LA));
                    yA = cross(zA,xA);
  
                    Xb = [dot(trans_X,xA),dot(trans_X,yA),dot(trans_X,zA)];
                    Yb = [dot(sag_Y,xA),dot(sag_Y,yA),dot(sag_Y,zA)];
                    Zb = [dot(cor_Z,xA),dot(cor_Z,yA),dot(cor_Z,zA)];
                    
                    PP = [Xb(1),Yb(1),Zb(1)];
                    AbsPP = abs(PP);
                    [~,ind] = min(AbsPP);
                    switch ind
                        case 1
                            Xb = -Xb;
                            if Yb(1)>0
                                lkinieangle = -atan2d(Xb(2),Xb(3));            
                            else
                                lkinieangle = -atan2d(Xb(2),Xb(3));
                            end
                        case 2
                            if Xb(1)>0
                                lkinieangle = -atan2d(Yb(2),Yb(3));
                            else
                                Yb = -Yb;
                                lkinieangle = -atan2d(Yb(2),Yb(3));
                            end
                        case 3
                            if -Zb(2)>0
                                Zb = -Zb;
                                lkinieangle = atan2d(Zb(3),Zb(2));
                            else
                                lkinieangle = atan2d(Zb(3),Zb(2));
                            end
                    end
                    lkiniestr = num2str(lkinieangle,'%.1f');
                end
                
                rkiniestr = strcat('NA');
                if rkinelbangle > 30
                    xA = RA;
                    zA = cross(RA,RFA)/norm(cross(RA,RFA));
                    yA = cross(zA,xA);
                    
                    Xb = [dot(trans_X,xA),dot(trans_X,yA),dot(trans_X,zA)];
                    Yb = [dot(sag_Y,xA),dot(sag_Y,yA),dot(sag_Y,zA)];
                    Zb = [dot(cor_Z,xA),dot(cor_Z,yA),dot(cor_Z,zA)];
                    
                    PP = [Xb(1),Yb(1),Zb(1)];
                    AbsPP = abs(PP);
                    [~,ind] = min(AbsPP);
                    switch ind
                        case 1
                            Xb = -Xb;
                            if Yb(1)>0
                                rkinieangle = -atan2d(Xb(2),Xb(3));            
                            else
                                rkinieangle = -atan2d(Xb(2),Xb(3));
                            end
                        case 2
                            if Xb(1)>0
                                rkinieangle = -atan2d(Yb(2),Yb(3));
                            else
                                Yb = -Yb;
                                rkinieangle = -atan2d(Yb(2),Yb(3));
                            end
                        case 3
                            if -Zb(2)>0
                                Zb = -Zb;
                                rkinieangle = atan2d(Zb(3),Zb(2));
                            else
                                rkinieangle = atan2d(Zb(3),Zb(2));
                            end
                    rkiniestr = num2str(rkinieangle,'%.1f');
                    end
                end
limuefstr = num2str(limuefangle,'%.1f');rimuefstr = num2str(rimuefangle,'%.1f');
lkinefstr = num2str(lkinefangle,'%.1f');rkinefstr = num2str(rkinefangle,'%.1f');
limubdstr = num2str(limubdangle,'%.1f');rimubdstr = num2str(rimubdangle,'%.1f');
lkinbdstr = num2str(lkinbdangle,'%.1f');rkinbdstr = num2str(rkinbdangle,'%.1f');
limuiestr = num2str(limuieangle,'%.1f');rimuiestr = num2str(rimuieangle,'%.1f');
limuelbstr = num2str(limuelbangle,'%.1f');rimuelbstr = num2str(rimuelbangle,'%.1f');
lkinelbstr = num2str(lkinelbangle,'%.1f');rkinelbstr = num2str(rkinelbangle,'%.1f');
limuelb1str = num2str(limuelb1angle,'%.1f');rimuelb1str = num2str(rimuelb1angle,'%.1f');
lkinelb1str =strcat('NA');rkinelb1str =strcat('NA');
telapsed = telapsed+toc(tstart);
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
text(ls+(limulocationdiv*lw),7.5*s,limuefstr,'Color','white','FontSize',fs/fontdiv,'FontWeight','normal','HorizontalAlignment','center');
text(rs+(rimulocationdiv*rw),7.5*s,rimuefstr,'Color','white','FontSize',fs/fontdiv,'FontWeight','normal','HorizontalAlignment','center');
text(ls+lw/5,11*s,stext,'Color','white','FontSize',fs/fontdiv,'FontWeight','bold','HorizontalAlignment','center');
text(rs+rw/5,11*s,stext,'Color','white','FontSize',fs/fontdiv,'FontWeight','bold','HorizontalAlignment','center');
text(ls+lw/5,12*s,bdstr,'Color','white','FontSize',fs/fontdiv,'FontWeight','normal','HorizontalAlignment','center');
text(rs+rw/5,12*s,bdstr,'Color','white','FontSize',fs/fontdiv,'FontWeight','normal','HorizontalAlignment','center');
text(ls+(lw/lkinlocationdiv),11.5*s,lkinbdstr,'Color','white','FontSize',fs/fontdiv,'FontWeight','normal','HorizontalAlignment','center');
text(rs+(rw/rkinlocationdiv),11.5*s,rkinbdstr,'Color','white','FontSize',fs/fontdiv,'FontWeight','normal','HorizontalAlignment','center');
text(ls+(limulocationdiv*lw),11.5*s,limubdstr,'Color','white','FontSize',fs/fontdiv,'FontWeight','normal','HorizontalAlignment','center');
text(rs+(rimulocationdiv*rw),11.5*s,rimubdstr,'Color','white','FontSize',fs/fontdiv,'FontWeight','normal','HorizontalAlignment','center');
text(ls+lw/5,15*s,stext,'Color','white','FontSize',fs/fontdiv,'FontWeight','bold','HorizontalAlignment','center');
text(rs+rw/5,15*s,stext,'Color','white','FontSize',fs/fontdiv,'FontWeight','bold','HorizontalAlignment','center');
text(ls+lw/5,16*s,iestr,'Color','white','FontSize',fs/fontdiv,'FontWeight','normal','HorizontalAlignment','center');
text(rs+rw/5,16*s,iestr,'Color','white','FontSize',fs/fontdiv,'FontWeight','normal','HorizontalAlignment','center');
text(ls+(lw/lkinlocationdiv),15.5*s,lkiniestr,'Color','white','FontSize',fs/fontdiv,'FontWeight','normal','HorizontalAlignment','center');
text(rs+(rw/rkinlocationdiv),15.5*s,rkiniestr,'Color','white','FontSize',fs/fontdiv,'FontWeight','normal','HorizontalAlignment','center');
text(ls+(limulocationdiv*lw),15.5*s,limuiestr,'Color','white','FontSize',fs/fontdiv,'FontWeight','normal','HorizontalAlignment','center');
text(rs+(rimulocationdiv*rw),15.5*s,rimuiestr,'Color','white','FontSize',fs/fontdiv,'FontWeight','normal','HorizontalAlignment','center');
text(ls+lw/5,19*s,etext,'Color','white','FontSize',fs/fontdiv,'FontWeight','bold','HorizontalAlignment','center');
text(rs+rw/5,19*s,etext,'Color','white','FontSize',fs/fontdiv,'FontWeight','bold','HorizontalAlignment','center');
text(ls+lw/5,20*s,efstr,'Color','white','FontSize',fs/fontdiv,'FontWeight','normal','HorizontalAlignment','center');
text(rs+rw/5,20*s,efstr,'Color','white','FontSize',fs/fontdiv,'FontWeight','normal','HorizontalAlignment','center');
text(ls+(lw/lkinlocationdiv),19.5*s,lkinelbstr,'Color','white','FontSize',fs/fontdiv,'FontWeight','normal','HorizontalAlignment','center');
text(rs+(rw/rkinlocationdiv),19.5*s,rkinelbstr,'Color','white','FontSize',fs/fontdiv,'FontWeight','normal','HorizontalAlignment','center');
text(ls+(limulocationdiv*lw),19.5*s,limuelbstr,'Color','white','FontSize',fs/fontdiv,'FontWeight','normal','HorizontalAlignment','center');
text(rs+(rimulocationdiv*rw),19.5*s,rimuelbstr,'Color','white','FontSize',fs/fontdiv,'FontWeight','normal','HorizontalAlignment','center');
text(ls+lw/5,23*s,ftext,'Color','white','FontSize',fs/fontdiv,'FontWeight','bold','HorizontalAlignment','center');
text(rs+rw/5,23*s,ftext,'Color','white','FontSize',fs/fontdiv,'FontWeight','bold','HorizontalAlignment','center');
text(ls+lw/5,24*s,psstr,'Color','white','FontSize',fs/fontdiv,'FontWeight','normal','HorizontalAlignment','center');
text(rs+rw/5,24*s,psstr,'Color','white','FontSize',fs/fontdiv,'FontWeight','normal','HorizontalAlignment','center');
text(ls+(lw/lkinlocationdiv),23.5*s,lkinelb1str,'Color','white','FontSize',fs/fontdiv,'FontWeight','normal','HorizontalAlignment','center');
text(rs+(rw/rkinlocationdiv),23.5*s,rkinelb1str,'Color','white','FontSize',fs/fontdiv,'FontWeight','normal','HorizontalAlignment','center');
text(ls+(limulocationdiv*lw),23.5*s,limuelb1str,'Color','white','FontSize',fs/fontdiv,'FontWeight','normal','HorizontalAlignment','center');
text(rs+(rimulocationdiv*rw),23.5*s,rimuelb1str,'Color','white','FontSize',fs/fontdiv,'FontWeight','normal','HorizontalAlignment','center');
text(ls+lw/3,1050,'Time (seconds)','Color','white','FontSize',fs/(fontdiv),'FontWeight','bold','HorizontalAlignment','center');
text(ls+(limulocationdiv*lw),1000,num2str(telapsed,'%.2f'),'Color','white','FontSize',fs/fontdiv,'FontWeight','normal','HorizontalAlignment','center');
addpoints(anline,telapsed,lkinefangle);addpoints(anline1,telapsed,rkinefangle);
addpoints(anline2,telapsed,lkinbdangle);addpoints(anline3,telapsed,rkinbdangle);
drawnow
        end   
 if numBodies == 0
      figure(1)
      s1 = strcat('No persons in view');   
      text((1920/2) - 250,100,s1,'Color','red','FontSize',30,'FontWeight','bold');
 end      
 if numBodies > 1
      figure(1)
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
figure(1)
end
% Close kinect object
k2.delete;
close all;
