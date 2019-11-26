clc;clear all;close all;
instrreset
ser = serial('COM15','BaudRate',115200);
ser.ReadAsyncMode = 'continuous';
fopen(ser);
ttotal = 1*60;
qa = [1,0,0,0];qb = [1,0,0,0];qc = [1,0,0,0];qd = [1,0,0,0];qe = [1,0,0,0];
addpath('F:\github\wearable-jacket\matlab\IEEE_sensors\');
sts = 'F:\github\wearable-jacket\matlab\IEEE_sensors\';
cd(sts);
f1 = sprintf('WISE+time_%s.txt',datestr(now,'mm-dd-yyyy HH-MM'));
fwrite = fopen(f1,'wt');
time = 0;
pause(2);
while time<=ttotal
tic;
[qa,qb,qc,qd,qe] = TransfDataReceive(ser,qa,qb,qc,qd,qe);
   qrel1 = quatmultiply(quatconj(qe),qe);
   qrel2 = quatmultiply(quatconj(qe),qa);
   qrel3 = quatmultiply(quatconj(qe),qb);
   qrel4 = quatmultiply(quatconj(qe),qc);
   qrel5 = quatmultiply(quatconj(qe),qd);
[r1,p1,y1] = quat2angle(qrel1,'ZXY');
[r2,p2,y2] = quat2angle(qrel2,'ZXY');
[r3,p3,y3] = quat2angle(qrel3,'ZXY');
[r4,p4,y4] = quat2angle(qrel4,'ZXY');
[r5,p5,y5] = quat2angle(qrel5,'ZXY');
fprintf(fwrite,'%f,%f,%f,%f,%f,%f,%f,%f,%f,%f,%f,%f,%f,%f,%f,%f\n',time,r1,p1,y1,r2,p2,y2,r3,p3,y3,r4,p4,y4,r5,p5,y5);
pause(0.01) 
time = time+toc;
end
fclose(fwrite);

instrreset    

%%

