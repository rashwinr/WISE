%Joint angles of Wearable Jacket connected with Kinect
clear all; close all; clc;
telapsed = 0;i = 1;tt = 0;lkinef = 0;font = 18;flag=0;
cd('F:\github\wearable-jacket\matlab\kinect+imudata\');
addpath('F:\github\wearable-jacket\matlab\KInectProject\Kin2');
addpath('F:\github\wearable-jacket\matlab\KInectProject\Kin2\Mex');
addpath('F:\github\wearable-jacket\matlab\KInectProject');
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
title('Shoulder Flexion-Extension','bold','FontSize',font)
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
title('Shoulder Abduction-Adduction','bold','FontSize',font)
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
        depth = k2.getDepth;
        color = k2.getColor;
        face = k2.getFaces;
        depth8u = uint8(depth*(255/outOfRange));
        depth8uc3 = repmat(depth8u,[1 1 3]);
        color = imresize(color,COL_SCALE);
        c.im = imshow(color, 'Parent', c.ax);
        rectangle('Position',[ls 0 lw H],'LineWidth',3,'FaceColor','k');  
        rectangle('Position',[rs 0 rw H],'LineWidth',3,'FaceColor','k');
        [bodies, fcp, timeStamp] = k2.getBodies('Quat');
        numBodies = size(bodies,2);
       if numBodies == 1
            k2.drawBodies(c.ax,bodies,'color',3,2,1);
            k2.drawFaces(c.ax,face,5,false,20);
                            %%%%%%%  Measuring the joints of the body in camera spac
                % Left arm(modified): 5,6,7 ; RightArm: 9,10,11            
            pos2Dxxx = bodies(1).Position;              % All 25 joints positions are stored to the variable pos2Dxxx.
                                                %Left Side Joints
            leftShoulder = pos2Dxxx(:,5);
            leftElbow = pos2Dxxx(:,6);
            leftWrist = pos2Dxxx(:,7);
                                                %Right Side Joints
            rightShoulder = pos2Dxxx(:,9); % Left arm: 4,5,6 ; RightArm: 8,9,10
            rightElbow = pos2Dxxx(:,10);
            rightWrist = pos2Dxxx(:,11);
            rightHand = pos2Dxxx(:,12);
            rightHandtip = pos2Dxxx(:,24);
                                                %Spine Joints
            spineShoulder = pos2Dxxx(:,21);
            spineCenter = pos2Dxxx(:,2);
            spinebase = pos2Dxxx(:,1);
            hipRight = pos2Dxxx(:,17);
            hipLeft = pos2Dxxx(:,13);
%%%%%% ELBOW           
                                                %Right Elbow joint angle calculation 3D
            E1=rightElbow-rightShoulder;
            E2=rightWrist-rightElbow;
            rkinelbangle=acosd(dot(E1,E2)/(norm(E1)*norm(E2)));
            F1=leftElbow-leftShoulder;
            F2=leftWrist-leftElbow;
            lkinelbangle=acosd(dot(F1,F2)/(norm(F1)*norm(F2)));
%%%%%% SHOULDER 
            % Right Shoulder abduction-adduction Movement
            RH2=rightElbow([1:3])-rightShoulder([1:3]);
            LH2=leftElbow([1:3])-leftShoulder([1:3]);    
                                    %coronal plane calculation
            RSLS = leftShoulder-rightShoulder;
            LSRS = rightShoulder-leftShoulder;
            TrunkVector = spinebase-spineShoulder;
            coronalnormalL = cross(LSRS,TrunkVector);
            coronalnormalR = cross(RSLS,TrunkVector);
            armaxisnormalL = cross(LSRS,LH2);
            armaxisnormalR = cross(RSLS,RH2);
                                    %sagittal plane calculation
            leftElbowprojection = LH2 - dot(LH2,coronalnormalL)*coronalnormalL;
            A = cross(TrunkVector,LH2);
            lkinbdangle = sign(-A(3))*atan2d(norm(A),dot(TrunkVector,LH2));                      %Abduction-adduction angle left
            rightElbowprojection = RH2 - dot(RH2,coronalnormalR)*coronalnormalR;
            B = cross(TrunkVector,RH2);
            rkinbdangle = sign(B(3))*atan2d(norm(B),dot(TrunkVector,RH2));                     %Abduction-adduction angle right  
            sagittalnormalL = cross(coronalnormalL,TrunkVector);
            sagittalnormalR = cross(coronalnormalR,TrunkVector);
            leftShoulderprojection = LH2 - (dot(LH2,sagittalnormalL)/norm(sagittalnormalL)^2)*sagittalnormalL;
            C = cross(TrunkVector,leftShoulderprojection);
            lkinefangle=sign(C(1))*atan2d(norm(C),dot(TrunkVector,leftShoulderprojection));       %Extension-flexion left
            rightShoulderprojection = RH2 - (dot(RH2,sagittalnormalR)/norm(sagittalnormalR)^2)*sagittalnormalR;
            D = cross(TrunkVector,rightShoulderprojection);
            rkinefangle=sign(D(1))*atan2d(norm(D),dot(TrunkVector,rightShoulderprojection));    %Extension-flexion right
                        %arm-axis plane calculation
            leftwristprojection = armaxisnormalL - (dot(LH2,armaxisnormalL)/norm(LH2)^2)*LH2;
            rightwristprojection = armaxisnormalR - (dot(RH2,armaxisnormalR)/norm(RH2)^2)*RH2;
            rkiniestr = strcat('NA');
            lkiniestr = strcat('NA');
            E = cross(-rightwristprojection,E2);
            if lkinefangle<=-150
                lkinefangle = -1*lkinefangle;
            end
            if rkinefangle<=-150
                rkinefangle = -1*rkinefangle;
            end
            if lkinbdangle<=-150
                lkinbdangle = -1*lkinbdangle;
            end
            if rkinbdangle<=-150
                rkinbdangle = -1*rkinbdangle;
            end
            if rkinelbangle>=70
                rkinieangle = sign(E(1))*atan2d(norm(E),dot(-rightwristprojection,E2));
                rkiniestr = num2str(rkinieangle,'%.1f');
            end
            F = cross(leftwristprojection,F2);
            if lkinelbangle>=70
                lkinieangle = sign(F(1))*atan2d(norm(F),dot(leftwristprojection,F2));
                lkiniestr = num2str(lkinieangle,'%.1f');
            end
            if lkinefangle<=0
            lefflag = 1;
            end
            if lkinefangle>=160 && lefflag && lec
                lef=lef+1;
                lefflag =0;
                if lef>=7
                    close figure 2
                    lec = 0;
                    clearvars lef
                end
            end
            clearvars A B C D E F leftElbowprojection rightElbowprojection coronalnormalL coronalnormalR armaxisnormalL armaxisnormalR
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
