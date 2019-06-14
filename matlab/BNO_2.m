clear all, close all, clc
addpath('C:\Users\fabio\Documents\MATLAB\Functions')
%% operation registers

Opr_Mode = hex2dec('3D');

AccMag_mode = bin2dec('00000100');
Config_mode = bin2dec('00000000');
NDOF_mode = bin2dec('00001100');
IMU_mode = bin2dec('00001100');

%% arduino setup 

a = arduino('COM10', 'Uno', 'Libraries', 'I2C');
% addrs = scanI2CBus(a); % uncomment to scan I2C bus
bnoA = i2cdev(a, '0x28');
bnoB = i2cdev(a, '0x29');

%% set opertation mode

BNOsetMode(bnoA,NDOF_mode);
BNOsetMode(bnoB,NDOF_mode);

%% get calibration status

calibA = BNOgetCalib(bnoA);
calibB = BNOgetCalib(bnoB);

%% get quaternions
qA = BNOgetQuat(bnoA);
qB = BNOgetQuat(bnoB);

%% animated plots

sp = 1.5;

qI = [0,1,0,0];
qJ = [0,0,1,0];
qK = [0,0,0,1];

an = animatedline;

ZYX = zeros(1000,3);

for i = 1:1000
    
qA = BNOgetQuat(bnoA);
qB = BNOgetQuat(bnoB);
qAB = quatmultiply(quatconj(qA),qB);
ZYX(i,:) = quat2eul(qAB)*180/pi;

[~,I1,I2,I3] = parts(quaternion(quatmultiply(qA,quatmultiply(qI,quatconj(qA)))));
IA = [I1,I2,I3];

[~,J1,J2,J3] = parts(quaternion(quatmultiply(qA,quatmultiply(qJ,quatconj(qA)))));
JA = [J1,J2,J3];

[~,K1,K2,K3] = parts(quaternion(quatmultiply(qA,quatmultiply(qK,quatconj(qA)))));
KA = [K1,K2,K3];

[~,I1,I2,I3] = parts(quaternion(quatmultiply(qB,quatmultiply(qI,quatconj(qB)))));
IB = [I1,I2,I3];

[~,J1,J2,J3] = parts(quaternion(quatmultiply(qB,quatmultiply(qJ,quatconj(qB)))));
JB = [J1,J2,J3];

[~,K1,K2,K3] = parts(quaternion(quatmultiply(qB,quatmultiply(qK,quatconj(qB)))));
KB = [K1,K2,K3];

figure(1)
hold on
grid on
axis equal
axis([-1 4 -1 2 -1 2])
view([35,24])
plot3([0,qI(2)],[0,qI(3)],[0,qI(4)],'k');
text(qI(2),qI(3),qI(4),'i');
plot3([0,qJ(2)],[0,qJ(3)],[0,qJ(4)],'k');
text(qJ(2),qJ(3),qJ(4),'j');
plot3([0,qK(2)],[0,qK(3)],[0,qK(4)],'k');
text(qK(2),qK(3),qK(4),'k');

A1 = plot3([sp,sp+IA(1)],[0,IA(2)],[0,IA(3)],'r');  
A2 = plot3([sp,sp+JA(1)],[0,JA(2)],[0,JA(3)],'g');
A3 = plot3([sp,sp+KA(1)],[0,KA(2)],[0,KA(3)],'b');

B1 = plot3([2*sp,2*sp+IB(1)],[0,IB(2)],[0,IB(3)],'r');  
B2 = plot3([2*sp,2*sp+JB(1)],[0,JB(2)],[0,JB(3)],'g');
B3 = plot3([2*sp,2*sp+KB(1)],[0,KB(2)],[0,KB(3)],'b');

drawnow
delete([A1,A2,A3,B1,B2,B3])

figure(2)
hold on
addpoints(an,i,ZYX(i,1))
% plot(i,ZYX(i,1));
% plot(i,ZYX(i,2));
% plot(i,ZYX(i,3));
drawnow
end
