                %Figure creation
c.h = figure;
c.ax = axes;
c_width = 1920;
c_height = 1080;
color = 255*ones(c_height,c_width,3,'uint8');
c.im = imshow(color,'Parent',c.ax);
% rectangle('Position',[0 0 10 10]);
ls = 0;rs = 1350;lw = 475;
H = 1080;
rw = 570;

rectangle('Position',[ls 0 lw H],'LineWidth',3,'FaceColor','k');  
rectangle('Position',[rs 0 rw H],'LineWidth',3,'FaceColor','k');
                    %variable to text conversion
                    
imustr = strcat('IMU');
kntstr = strcat('KINECT');
lftstr = strcat('Left arm angles');
rgtstr = strcat('Right arm angles');
efstr = strcat('Flex-Ext');
bdstr = strcat('Abd-Add');
iestr = strcat('Int-Ext Rot');
psstr = strcat('Pro-Sup');
jtext = strcat('Joint');
etext = strcat('Elbow');         
stext = strcat('Shoulder');     
ftext = strcat('Forearm');  
limuefangle = 0;rimuefangle = 0;lkinefangle = 0;rkinefangle = 0;
limubdangle = 5;rimubdangle = 5;lkinbdangle = 5;rkinbdangle = 5;
limuieangle = 10;rimuieangle = 10;lkinieangle = 10;rkinieangle = 10;
limuelbangle = 15;rimuelbangle = 15;lkinelbangle = 15;rkinelbangle = 15;
limuelb1angle = 0;rimuelb1angle = 0;lkinelb1angle = 0;rkinelb1angle = 0;
limuefstr = num2str(limuefangle,'%.1f');
rimuefstr = num2str(rimuefangle,'%.1f');
lkinefstr = num2str(lkinefangle,'%.1f');
rkinefstr = num2str(rkinefangle,'%.1f');
limubdstr = num2str(limubdangle,'%.1f');
rimubdstr = num2str(rimubdangle,'%.1f');
lkinbdstr = num2str(lkinbdangle,'%.1f');
rkinbdstr = num2str(rkinbdangle,'%.1f');
limuiestr = num2str(limuieangle,'%.1f');
rimuiestr = num2str(rimuieangle,'%.1f');
lkiniestr = num2str(lkinieangle,'%.1f');
rkiniestr = num2str(rkinieangle,'%.1f');
limuelbstr = num2str(limuelbangle,'%.1f');
rimuelbstr = num2str(rimuelbangle,'%.1f');
lkinelbstr = num2str(lkinelbangle,'%.1f');
rkinelbstr = num2str(rkinelbangle,'%.1f');
limuelb1str = num2str(limuelbangle,'%.1f');
rimuelb1str = num2str(rimuelbangle,'%.1f');
lkinelb1str = num2str(lkinelbangle,'%.1f');
rkinelb1str = num2str(rkinelbangle,'%.1f');
                                %Text placement in figure
fs = 24;s=40;fontdiv = 1.3;limulocationdiv = 1.9/2.2;rimulocationdiv = 2.1/2.4;lkinlocationdiv = 1.75;rkinlocationdiv = 1.75;
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


function ElbL = getElbowLeft(q1,q2)
Qi = [0,1,0,0];
Q1 = quatmultiply(q1,quatmultiply(Qi,quatconj(q1)));
V1 = -[Q1(2),Q1(3),Q1(4)];
Q2 = quatmultiply(q2,quatmultiply(Qi,quatconj(q2)));
V2 = -[Q2(2),Q2(3),Q2(4)];
ElbL = acosd(dot(V1,V2)/(norm(V1)*norm(V2)));
end

function ElbR = getElbowRight(q1,q2)
Qi = [0,1,0,0];
Q1 = quatmultiply(q1,quatmultiply(Qi,quatconj(q1)));
V1 = [Q1(2),Q1(3),Q1(4)];
Q2 = quatmultiply(q2,quatmultiply(Qi,quatconj(q2)));
V2 = [Q2(2),Q2(3),Q2(4)];
ElbR = acosd(dot(V1,V2)/(norm(V1)*norm(V2)));
end

function L_sho = getShoulderLeft(back,arm)
zrot = 180;
xrot = -90;
Qk = [0,0,0,1];Qj = [0,0,1,0];Qi = [0,1,0,0];
Qz = quatmultiply(back,quatmultiply(Qk,quatconj(back)));
Qz1 = [cosd(zrot/2) Qz(2)*sind(zrot/2) Qz(3)*sind(zrot/2) Qz(4)*sind(zrot/2)];
Qe = quatmultiply(Qz1,back);
Qx = quatmultiply(Qe,quatmultiply(Qi,quatconj(Qe)));
Qx1 = [cosd(xrot/2) Qx(2)*sind(xrot/2) Qx(3)*sind(xrot/2) Qx(4)*sind(xrot/2)];
Qback = quatmultiply(Qx1,Qe);
Qnew =  quatmultiply(quatconj(Qback),arm);
Qzb = quatmultiply(back,quatmultiply(Qk,quatconj(back)));
Qxb = quatmultiply(back,quatmultiply(Qi,quatconj(back)));
Qyb = quatmultiply(back,quatmultiply(Qj,quatconj(back)));
Qza = quatmultiply(arm,quatmultiply(Qk,quatconj(arm)));
Qxa = quatmultiply(arm,quatmultiply(Qi,quatconj(arm)));
Qya = quatmultiply(arm,quatmultiply(Qj,quatconj(arm)));
angle1 = acosd(dot([Qxb(2) Qxb(3) Qxb(4)],[-Qxa(2) -Qxa(3) -Qxa(4)])/(norm([Qxb(2) Qxb(3) Qxb(4)])*norm([-Qxa(2) -Qxa(3) -Qxa(4)])));
angle2 = acosd(dot([-Qyb(2) -Qyb(3) -Qyb(4)],[Qza(2) Qza(3) Qza(4)])/(norm([Qyb(2) Qyb(3) Qyb(4)])*norm([Qza(2) Qza(3) Qza(4)])));
% text(410,900,num2str(angle1,'%.2f'),'Color','white','FontSize',20,'FontWeight','normal','HorizontalAlignment','center');
% text(410,950,num2str(angle2,'%.2f'),'Color','white','FontSize',20,'FontWeight','normal','HorizontalAlignment','center');
L_sho = quat2eul(Qnew,'XYZ')*180/pi;
L_sho(2) = angle2;
end

function R_sho = getShoulderRight(back,arm)
Qi = [0,1,0,0];Qj = [0,0,1,0];Qk = [0,0,0,1];
xrot = -90;
Qx = quatmultiply(back,quatmultiply(Qi,quatconj(back)));
Qx1 = [cosd(xrot/2) Qx(2)*sind(xrot/2) Qx(3)*sind(xrot/2) Qx(4)*sind(xrot/2)];
Qback = quatmultiply(Qx1,back);
Qnew =  quatmultiply(quatconj(Qback),arm);
Qzb = quatmultiply(back,quatmultiply(Qk,quatconj(back)));
Qxb = quatmultiply(back,quatmultiply(Qi,quatconj(back)));
Qyb = quatmultiply(back,quatmultiply(Qj,quatconj(back)));
Qza = quatmultiply(arm,quatmultiply(Qk,quatconj(arm)));
Qxa = quatmultiply(arm,quatmultiply(Qi,quatconj(arm)));
Qya = quatmultiply(arm,quatmultiply(Qj,quatconj(arm)));
R_sho = quat2eul(Qnew,'XYZ')*180/pi;
end


function lefthand = getlefthand(back,arm,wrist)
lefthand = zeros(5,1);
Qi = [0,1,0,0];Qj = [0,0,1,0];Qk = [0,0,0,1];
Vzb = quatmultiply(back,quatmultiply(Qk,quatconj(back)));
Vxb = quatmultiply(back,quatmultiply(Qi,quatconj(back)));
Vyb = quatmultiply(back,quatmultiply(Qj,quatconj(back)));
Vza = quatmultiply(arm,quatmultiply(Qk,quatconj(arm)));
Vza_ = quatmultiply(arm,quatmultiply(Qk,quatconj(arm)));
Vxa = quatmultiply(arm,quatmultiply(Qi,quatconj(arm)));
Vxa_ = quatmultiply(arm,quatmultiply(-Qi,quatconj(arm)));
Vya = quatmultiply(arm,quatmultiply(Qj,quatconj(arm)));
Vya_ = quatmultiply(arm,quatmultiply(-Qj,quatconj(arm)));
Vzw = quatmultiply(wrist,quatmultiply(Qk,quatconj(wrist)));
Vxw = quatmultiply(wrist,quatmultiply(Qi,quatconj(wrist)));
Vxw_ = quatmultiply(wrist,quatmultiply(-Qi,quatconj(wrist)));
Vyw = quatmultiply(wrist,quatmultiply(Qj,quatconj(wrist)));
abs(dot(Vxa(2:4),Vyb(2:4))/(norm(Vxa(2:4))*norm(Vyb(2:4))))
if abs(dot(Vxa(2:4),Vyb(2:4))/(norm(Vxa(2:4))*norm(Vyb(2:4))))<=0.98
        %sagittal plane on back has Y axis as normal for extension and flexion
        Vxasagittal = Vya_(2:4) - (dot(Vya_(2:4),Vyb(2:4))/norm(Vyb(2:4))^2)*Vyb(2:4);
        lefthand(1,1) = acosd(dot(Vxasagittal,Vzb(2:4))/norm(Vxasagittal)*norm(Vzb(2:4)));
else 
        lefthand(1,1) = 0.0;
end
%  if dot(
%coronal plane on back has Z axis as normal for abduction and adduction
Vxacoronal = Vxa_(2:4) - (dot(Vxa_(2:4),Vzb(2:4))/norm(Vzb(2:4))^2)*Vzb(2:4);
lefthand(2,1) = acosd(dot(Vxacoronal,Vxb(2:4))/(norm(Vxacoronal)*norm(Vxb(2:4))));
%elbow angle extension-flexion                    requires a normal plane
lefthand(4,1) = acosd(dot(Vxa_(2:4),Vxw_(2:4))/norm(Vxa_(2:4))*norm(Vxw_(2:4)));
%  end
if lefthand(4,1)>=70
%arm-axis plane
        Vxwarmaxis = Vxw_(2:4) - (dot(Vxw_(2:4),Vxa(2:4))/norm(Vxa(2:4))^2)*Vxa(2:4);
        lefthand(3,1) = acosd(dot(Vxwarmaxis,Vya(2:4))/(norm(Vxwarmaxis)*norm(Vya(2:4))));
else 
        lefthand(3,1) = 0;
end

%elbow pronation-supination                       requires a normal plane
lefthand(5,1) = acosd(dot(Vza(2:4),Vzw(2:4))/norm(Vza(2:4))*norm(Vzw(2:4)));
end

function righthand = getrighthand(back,arm,wrist)
righthand = zeros(5,1);
Qi = [0,1,0,0];Qj = [0,0,1,0];Qk = [0,0,0,1];
Vzb = quatmultiply(back,quatmultiply(Qk,quatconj(back)));
Vxb = quatmultiply(back,quatmultiply(Qi,quatconj(back)));
Vyb = quatmultiply(back,quatmultiply(Qj,quatconj(back)));
Vza = quatmultiply(arm,quatmultiply(Qk,quatconj(arm)));
Vxa = quatmultiply(arm,quatmultiply(Qi,quatconj(arm)));
Vxa_ = quatmultiply(arm,quatmultiply(-Qi,quatconj(arm)));
Vya = quatmultiply(arm,quatmultiply(Qj,quatconj(arm)));
Vzw = quatmultiply(wrist,quatmultiply(Qk,quatconj(wrist)));
Vxw = quatmultiply(wrist,quatmultiply(Qi,quatconj(wrist)));
Vyw = quatmultiply(wrist,quatmultiply(Qj,quatconj(wrist)));
%sagittal plane on back has Y axis as normal for extension and flexion
Vxasagittal = Vya(2:4) - (dot(Vya(2:4),Vyb(2:4))/norm(Vyb(2:4))^2)*Vyb(2:4);
if abs(dot(Vxa(2:4),Vyb(2:4))/(norm(Vxa(2:4))*norm(Vyb(2:4))))<=0.98
    righthand(1,1) = acosd(dot(Vxasagittal,Vxb(2:4))/norm(Vxasagittal)*norm(Vxb(2:4)));
else 
    righthand(1,1) = 90.00;
end
%coronal plane on back has Z axis as normal for abduction and adduction
Vxacoronal = Vxa(2:4) - (dot(Vxa(2:4),Vzb(2:4))/norm(Vzb(2:4))^2)*Vzb(2:4);

righthand(2,1) = acosd(dot(Vxacoronal,Vxb(2:4))/(norm(Vxacoronal)*norm(Vxb(2:4))));
%arm-axis plane
Vxwarmaxis = Vxw(2:4) - (dot(Vxw(2:4),Vxa(2:4))/norm(Vxw(2:4))^2)*Vxw(2:4);
righthand(3,1) = acosd(dot(Vxwarmaxis,Vya(2:4))/(norm(Vxwarmaxis)*norm(Vya(2:4))));
%elbow angle extension-flexion
righthand(4,1) = acosd(dot(-Vxa(2:4),Vxw(2:4))/norm(-Vxa(2:4))*norm(Vxw(2:4)));
%elbow pronation-supination
righthand(5,1) = acosd(dot(Vza(2:4),Vzw(2:4))/norm(Vza(2:4))*norm(Vzw(2:4)));
end