clc
clear all
close all
q = axang2quat([0.333 0.333 0.333 0]);

X = [1 0 0];
Y = [0 1 0];
Z = [0 0 1];

X1 = X;
Y1 = Y;
Z1 = Z;

[~,X1(1),X1(2),X1(3)] = parts(quaternion(quatmultiply(q,quatmultiply([0,X],quatconj(q)))));
[~,Y1(1),Y1(2),Y1(3)] = parts(quaternion(quatmultiply(q,quatmultiply([0,Y],quatconj(q)))));
[~,Z1(1),Z1(2),Z1(3)] = parts(quaternion(quatmultiply(q,quatmultiply([0,Z],quatconj(q)))));

figure(1)
hold on
axis equal
view([35,24])
axis([-2 4 -2 2 -2 2])
plot3([0,X(1)],[0,X(2)],[0,X(3)],'r','LineWidth',2);  
plot3([0,Y(1)],[0,Y(2)],[0,Y(3)],'g','LineWidth',2);
plot3([0,Z(1)],[0,Z(2)],[0,Z(3)],'b','LineWidth',2);
plot3([1.5,1.5+X1(1)],[0,X1(2)],[0,X1(3)],'r--','LineWidth',2);  
plot3([1.5,1.5+Y1(1)],[0,Y1(2)],[0,Y1(3)],'g--','LineWidth',2);
plot3([1.5,1.5+Z1(1)],[0,Z1(2)],[0,Z1(3)],'b--','LineWidth',2);
text(X(1),X(2),X(3),'X_{W}','Color','k','FontSize',14);
text(Y(1),Y(2),Y(3),'Y_{W}','Color','k','FontSize',14);
text(Z(1),Z(2),Z(3),'Z_{W}','Color','k','FontSize',14);
text(1.5+X1(1),X1(2),X1(3),'X_{S}','Color','k','FontSize',14);
text(1.5+Y1(1),Y1(2),Y1(3),'Y_{S}','Color','k','FontSize',14);
text(1.5+Z1(1),Z1(2),Z1(3),'Z_{S}','Color','k','FontSize',14);

