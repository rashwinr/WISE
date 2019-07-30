clc;clear all;close all;

delete(instrfind({'Port'},{'COM15'}))
ser = serial('COM15','BaudRate',115200);
ser.ReadAsyncMode = 'continuous';
fopen(ser);
pause(2)
qLF = [1,0,0,0];qRF = [1,0,0,0];qLA = [1,0,0,0];qRA = [1,0,0,0];qB = [1,0,0,0];
qI = [0,1,0,0];qJ = [0,0,1,0];qK = [0,0,0,1];qR = [1,0,0,0];
ttotal = 1000;
figure(1)
%%

while time<=ttotal
   tic;
   [qLF,qRF,qLA,qRA,qB] = DataReceive_matched(ser,qLF,qRF,qLA,qRA,qB);
   Zb = quatmultiply(qB,quatmultiply(qK,quatconj(qB)));
   qZb = [cos(pi/4),-Zb(2)*sin(pi/4),-Zb(3)*sin(pi/4),-Zb(4)*sin(pi/4)];
   qB = quatmultiply(qZb,qB);
   qLAvalue = quatmultiply(quatconj(qB),qLA);
   qRAvalue = quatmultiply(quatconj(qB),qRA);
   [lie,lfe,lbd] = quat2angle(qLAvalue,'YZY');
   [rie,rfe,rbd] = quat2angle(qRAvalue,'YZY');
   subplot(2,1,1)
   hold on
   plot(time,lie);
   plot(time,lfe);
   plot(time,lbd);
   hold off
   subplot(2,1,2)
   hold on
   plot(time,rie);
   plot(time,rfe);
   plot(time,rbd);
   hold off
   time = time+toc;
   
end
