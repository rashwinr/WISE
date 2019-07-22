
Ex = [1 0 0];
Ey = [0 1 0];
Ez = [0 0 1];

Rot = [10 25 50];
Trans = [0 0 0];
Tx = [cos(Rot(1,1)) -sin(Rot(1,1)) 0 0; sin(Rot(1,1)) cos(Rot(1,1)) 0 0; 0 0 1 0; 0 0 0 1];
Ty = [cos(Rot(1,2)) 0 sin(Rot(1,2)) 0; 0 1 0 0; -sin(Rot(1,2)) 0 cos(Rot(1,2)) 0; 0 0 0 1];
Tz = [1 0 0 0; 0 cos(Rot(1,3)) -sin(Rot(1,3)) 0; 0 sin(Rot(1,3)) cos(Rot(1,3)) 0; 0 0 0 1];
Tr = [1 0 0 Trans(1,1); 0 1 0 Trans(1,2); 0 0 1 Trans(1,3); 0 0 0 1];
T = Tx * Ty * Tz * Tr;

Ex = (T * [Ex 0]')';
Ex = Ex(1,1:3);
Ey = (T * [Ey 0]')';
Ey = Ey(1,1:3);
Ez = (T * [Ez 0]')';
Ez = Ez(1,1:3);

Rot = [10 29 60];
Trans = [0 0 0];
Tx = [cos(Rot(1,1)) -sin(Rot(1,1)) 0 0; sin(Rot(1,1)) cos(Rot(1,1)) 0 0; 0 0 1 0; 0 0 0 1];
Ty = [cos(Rot(1,2)) 0 sin(Rot(1,2)) 0; 0 1 0 0; -sin(Rot(1,2)) 0 cos(Rot(1,2)) 0; 0 0 0 1];
Tz = [1 0 0 0; 0 cos(Rot(1,3)) -sin(Rot(1,3)) 0; 0 sin(Rot(1,3)) cos(Rot(1,3)) 0; 0 0 0 1];
Tr = [1 0 0 Trans(1,1); 0 1 0 Trans(1,2); 0 0 1 Trans(1,3); 0 0 0 1];
T = Tx * Ty * Tz * Tr;

Ax = (T * [Ex 0]')';
Ax = Ax(1,1:3);
Ay = (T * [Ey 0]')';
Ay = Ay(1,1:3);
Az = (T * [Ez 0]')';
Az = Az(1,1:3);

hold on
plot3([0,Ex(1,1)],[0,Ex(1,2)],[0,Ex(1,3)],'k');
plot3([0,Ey(1,1)],[0,Ey(1,2)],[0,Ey(1,3)],'k');
plot3([0,Ez(1,1)],[0,Ez(1,2)],[0,Ez(1,3)],'k');

text(Ex(1,1),Ex(1,2),Ex(1,3),'Ex','FontSize',15)
text(Ey(1,1),Ey(1,2),Ey(1,3),'Ey','FontSize',15)
text(Ez(1,1),Ez(1,2),Ez(1,3),'Ez','FontSize',15)

plot3([0,Ax(1,1)],[0,Ax(1,2)],[0,Ax(1,3)],'b');
plot3([0,Ay(1,1)],[0,Ay(1,2)],[0,Ay(1,3)],'b');
plot3([0,Az(1,1)],[0,Az(1,2)],[0,Az(1,3)],'b');

text(Ax(1,1),Ax(1,2),Ax(1,3),'Ax','FontSize',15)
text(Ay(1,1),Ay(1,2),Ay(1,3),'Ay','FontSize',15)
text(Az(1,1),Az(1,2),Az(1,3),'Az','FontSize',15)

Yp = Ay - ((dot(Ay,Ez)*Ez)/(norm(Ez)^2));

%theta1 = acosd(dot(Ex,Yp)/(norm(Ex)*(norm(Yp))))
theta1 = atan2d(dot(Ez,cross(Yp,Ex)),dot(Yp,Ex))
theta2 = atan2d(dot(Ay,-Ey),dot(Ay,Ex))
disp("===========================");