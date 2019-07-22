clc;clear all;close all;
X = [1,0,0];
Y = [0,1,0];
Z = [0,0,1];
g = [0,0,1];
q = [0.996, 0.019,0.016,0.087];
q = quatnormalize(q);
angax = quat2axang(q);
qx = quatmultiply(quatmultiply(q,[0,X]),quatconj(q));
qy = quatmultiply(quatmultiply(q,[0,Y]),quatconj(q));
qz = quatmultiply(quatmultiply(q,[0,Z]),quatconj(q));
tf = 0.005;
theta = acosd(dot(g,qz(2:4)));
p = cross(g,qz(2:4))/norm(cross(g,qz(2:4)));
qp = [cosd(theta/2),p(1)*sind(theta/2),p(2)*sind(theta/2),p(3)*sind(theta/2)];
% qp = [cosd(theta/2),angax(1)*sind(theta/2),angax(2)*sind(theta/2),angax(3)*sind(theta/2)];
qs = quatmultiply(quatconj(qp),q);
qsx = quatmultiply(quatmultiply(qs,[0,X]),quatconj(qs));
qsy = quatmultiply(quatmultiply(qs,[0,Y]),quatconj(qs));
qsz = quatmultiply(quatmultiply(qs,[0,Z]),quatconj(qs));



figure(1)
hold on
axis([-1 1 -1 1 -1 1])
view([83,26])
% plot3([0,X(1)],[0,X(2)],[0,X(3)],'Color',[0.5 0 0]);
% plot3([0,Y(1)],[0,Y(2)],[0,Y(3)],'Color',[0 0.5 0]);
% plot3([0,Z(1)],[0,Z(2)],[0,Z(3)],'Color',[0 0 0.5]);
plot3([0,qx(2)],[0,qx(3)],[0,qx(4)],'--','Color',[1 0 0],'LineWidth',1.5);
plot3([0,qy(2)],[0,qy(3)],[0,qy(4)],'--','Color',[0 1 0],'LineWidth',1.5);
plot3([0,qz(2)],[0,qz(3)],[0,qz(4)],'--','Color',[0 0 0.8],'LineWidth',1.5);
plot3([0,p(1)],[0,p(2)],[0,p(3)],'Color',[0.5 0.5 0.75],'LineWidth',1.5);
text(8*tf+g(1),15*tf+g(2),tf+g(3),'Gravity','Rotation',270,'FontSize',15)
text(tf+qx(2),-5*tf+qx(3),10*tf+qx(4),'X','FontSize',15)
text(tf+qy(2),10*tf+qy(3),tf+qy(4),'Y','FontSize',15)
text(8*tf+qz(2),-10*tf+qz(3),tf+qz(4),'Z','FontSize',15)
text(tf+p(1),tf+p(2),5*tf+p(3),'$$\hat{P}$$','Interpreter','Latex','FontSize',15)
% text(-5*tf,tf,-5*tf,'q_S','FontSize',15)
% plot3([0,qsx(2)],[0,qsx(3)],[0,qsx(4)],'-.','Color',[1 0 0],'LineWidth',1.5);
% plot3([0,qsy(2)],[0,qsy(3)],[0,qsy(4)],'-.','Color',[0 1 0],'LineWidth',1.5);
% plot3([0,qsz(2)],[0,qsz(3)],[0,qsz(4)],'-.','Color',[0 0 1],'LineWidth',1.5);
plot3([0,g(1)],[0,g(2)],[0,g(3)],'Color',[0 0 0],'LineWidth',1);
set(gca,'YTick',[]);
set(gca,'XTick',[]);
set(gca,'ZTick',[]);
set(gca,'Yticklabel',[]); 
set(gca,'Xticklabel',[]);
set(gca,'Zticklabel',[]); 
hold off

Yrot = [cos((pi-0.1)/4),qsy(2)*sin((pi-0.1)/4),qsy(3)*sin((pi-0.1)/4),qsy(4)*sin((pi-0.1)/4)];
qsd = quatmultiply(quatconj(Yrot),qs);
qsdx = quatmultiply(quatmultiply(qsd,[0,X]),quatconj(qsd));
qsdy = quatmultiply(quatmultiply(qsd,[0,Y]),quatconj(qsd));
qsdz = quatmultiply(quatmultiply(qsd,[0,Z]),quatconj(qsd));

figure(2)
hold on
axis([-1 1 -1 1 -1 1])
view([35,8])
plot3([0,qsdx(2)],[0,qsdx(3)],[0,qsdx(4)],'-.','Color',[1 0 0],'LineWidth',1.5);
plot3([0,qsdy(2)],[0,qsdy(3)],[0,qsdy(4)],'-.','Color',[0 1 0],'LineWidth',1.5);
plot3([0,qsdz(2)],[0,qsdz(3)],[0,qsdz(4)],'-.','Color',[0 0 1],'LineWidth',1.5);
plot3([0,g(1)],[0,g(2)],[0,g(3)],'Color',[0 0 0],'LineWidth',1);
text(tf+qsdx(2),-5*tf+qsdx(3),10*tf+qsdx(4),'X''','FontSize',15)
text(15*tf+qsdy(2),10*tf+qsdy(3),tf+qsdy(4),'Y''','FontSize',15)
text(-8*tf+qsdz(2),tf+qsdz(3),tf+qsdz(4),'Z''','FontSize',15)
text(-10*tf+g(1),5*tf+g(2),tf+g(3),'Gravity','Rotation',270,'FontSize',15)
set(gca,'YTick',[]);
set(gca,'XTick',[]);
set(gca,'ZTick',[]);
set(gca,'Yticklabel',[]); 
set(gca,'Xticklabel',[]);
set(gca,'Zticklabel',[]); 
hold off