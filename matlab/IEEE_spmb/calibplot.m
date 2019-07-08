clear all, close all, clc
delete(instrfind({'Port'},{'COM15'}))
s = serial('COM15','BaudRate',115200);
s.ReadAsyncMode = 'continuous';

q1 = [1,0,0,0];
th = 10*pi/180;
q2 = [1,0,0,0];
q2 = quatnormalize(q2);
q12 = [1,0,0,0];
q4 = [1,0,0,0];
q5 = [1,0,0,0];
qI = [0,1,0,0];
qJ = [0,0,1,0];
qK = [0,0,0,1];
I1 = [1 0 0]; I2 = [1 0 0]; I12 = [1 0 0]; I4 = [1 0 0]; I5 = [1 0 0];
J1 = [0 1 0]; J2 = [0 1 0]; J12 = [0 1 0]; J4 = [0 1 0]; J5 = [0 1 0];
K1 = [0 0 1]; K2 = [0 0 1]; K12 = [0 0 1]; K4 = [0 0 1]; K5 = [0 0 1];
sp = 0;

v1 = [0,1,1,0];
v1 = quatnormalize(v1);
[~,x,y,z] = parts(quaternion(quatmultiply(q2,quatmultiply(v1,quatconj(q2)))));
qv1_2 = [cos(th/2),x*sin(th/2),y*sin(th/2),z*sin(th/2)];
q12 = quatmultiply(qv1_2,q2);

[~,I1(1),I1(2),I1(3)] = parts(quaternion(quatmultiply(q1,quatmultiply(qI,quatconj(q1)))));
[~,J1(1),J1(2),J1(3)] = parts(quaternion(quatmultiply(q1,quatmultiply(qJ,quatconj(q1)))));
[~,K1(1),K1(2),K1(3)] = parts(quaternion(quatmultiply(q1,quatmultiply(qK,quatconj(q1)))));

[~,I2(1),I2(2),I2(3)] = parts(quaternion(quatmultiply(q2,quatmultiply(qI,quatconj(q2)))));
[~,J2(1),J2(2),J2(3)] = parts(quaternion(quatmultiply(q2,quatmultiply(qJ,quatconj(q2)))));
[~,K2(1),K2(2),K2(3)] = parts(quaternion(quatmultiply(q2,quatmultiply(qK,quatconj(q2)))));

[~,I12(1),I12(2),I12(3)] = parts(quaternion(quatmultiply(q12,quatmultiply(qI,quatconj(q12)))));
[~,J12(1),J12(2),J12(3)] = parts(quaternion(quatmultiply(q12,quatmultiply(qJ,quatconj(q12)))));
[~,K12(1),K12(2),K12(3)] = parts(quaternion(quatmultiply(q12,quatmultiply(qK,quatconj(q12)))));

figure(1)
hold on


subplot(2,1,1)
hold on
grid on
axis equal
axis([-1 5.5 -1 2 -1 2])
view([35,24])
% P1 = plot3([0,I1(1)],[0,I1(2)],[0,I1(3)],'r');  
% P2 = plot3([0,J1(1)],[0,J1(2)],[0,J1(3)],'g');
% P3 = plot3([0,K1(1)],[0,K1(2)],[0,K1(3)],'b');

E1 = plot3([sp,sp+I2(1)],[0,I2(2)],[0,I2(3)],'r');  
E2 = plot3([sp,sp+J2(1)],[0,J2(2)],[0,J2(3)],'g');
E3 = plot3([sp,sp+K2(1)],[0,K2(2)],[0,K2(3)],'b');

C1 = plot3([2*sp,2*sp+I12(1)],[0,I12(2)],[0,I12(3)],'r');
C2 = plot3([2*sp,2*sp+J12(1)],[0,J12(2)],[0,J12(3)],'g');
C3 = plot3([2*sp,2*sp+K12(1)],[0,K12(2)],[0,K12(3)],'b');

subplot(2,1,2)
hold on
grid on
axis equal
axis([-1 5.5 -1 2 -1 2])
view([35,24])
C12 = plot3([2*sp,2*sp+I12(1)],[0,I12(2)],[0,I12(3)],'r');
C22 = plot3([2*sp,2*sp+J12(1)],[0,J12(2)],[0,J12(3)],'g');
C32 = plot3([2*sp,2*sp+K12(1)],[0,K12(2)],[0,K12(3)],'b');

