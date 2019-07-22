clear all, clc
clf(figure(1),'reset')
addpath('C:\Users\ranst\OneDrive\Documents\GitHub\WISE\matlab\IEEE_spmb\');
delete(instrfind({'Port'},{'COM9'}))
ser = serial('COM9','BaudRate',115200);
ser.ReadAsyncMode = 'continuous';
fopen(ser);k=[];
sts = 'C:\Users\ranst\OneDrive\Documents\GitHub\WISE\matlab\IEEE_spmb\data\';
cd(sts);
ttotal = 0.5*60;
prompt1 = 'Please enter the sensor ID attached on the moving arm (A,B,C,D): ';
WISESENSORID = input(prompt1,'s');
% WISESENSORID = 'A';
if ~exist(num2str(WISESENSORID),'dir')
mkdir(WISESENSORID);
end
cd(strcat(sts,WISESENSORID,'\'));

prompt2 = 'Please enter the AXIS evaluated during the experiment (X,Y,Z): ';
AX = input(prompt2,'s');
if ~exist(num2str(AX),'dir')
mkdir(AX);
end

cd(strcat(sts,WISESENSORID,'\',AX,'\'));
clearvars sts;

prompt = 'Please enter the angle in degrees used for the experiment (0-180): ';
ANGLE = input(prompt,'s');

f = sprintf('%s_WISE+turntable_%s.txt',num2str(ANGLE),datestr(now,'mm-dd-yyyy HH-MM'));
fwrite = fopen(f,'wt');


q1 = [1,0,0,0];q2 = [1,0,0,0];q3 = [1,0,0,0];q4 = [1,0,0,0];q5 = [1,0,0,0];q12 = [1,0,0,0];
qI = [0,1,0,0];qJ = [0,0,1,0];qK = [0,0,0,1];qR = [1,0,0,0];
I1 = [1 0 0]; I2 = [1 0 0]; I12 = [1 0 0]; I4 = [1 0 0]; I5 = [1 0 0];
J1 = [0 1 0]; J2 = [0 1 0]; J12 = [0 1 0]; J4 = [0 1 0]; J5 = [0 1 0];
K1 = [0 0 1]; K2 = [0 0 1]; K12 = [0 0 1]; K4 = [0 0 1]; K5 = [0 0 1];
sp = 2;lw = 1.25;fs = 12;

th = linspace( -pi, pi, 360);
R = 5;  %or whatever radius you want
Cx = R*cos(th);
Cy = R*sin(th);

time= 0;
% sz2 = screensize(2);
figure(1)
set(figure (1),'keypress','k=get(gcf,''currentchar'');' );
hold on

subplot(2,1,1)
hold on
axis([-2 6 -1 2 -1 2]);
view([35,24]);
P1 = plot3([0,I1(1)],[0,I1(2)],[0,I1(3)],'r','LineWidth',lw);  
P2 = plot3([0,J1(1)],[0,J1(2)],[0,J1(3)],'g','LineWidth',lw);
P3 = plot3([0,K1(1)],[0,K1(2)],[0,K1(3)],'b','LineWidth',lw);
t1 = text(-0.5,0,-0.1,'q_1','FontSize',fs);
t2 = text(I1(1),I1(2),I1(3),'X','FontSize',fs);
t3 = text(J1(1),J1(2),J1(3),'Y','FontSize',fs);
t4 = text(K1(1),K1(2),K1(3),'Z','FontSize',fs);
E1 = plot3([sp,sp+I2(1)],[0,I2(2)],[0,I2(3)],'r','LineWidth',lw);  
E2 = plot3([sp,sp+J2(1)],[0,J2(2)],[0,J2(3)],'g','LineWidth',lw);
E3 = plot3([sp,sp+K2(1)],[0,K2(2)],[0,K2(3)],'b','LineWidth',lw);
t5 = text(-0.5+sp,0,-0.1,'q_2','FontSize',fs);
t6 = text(sp+I2(1),I2(2),I2(3),'X','FontSize',fs);
t7 = text(sp+J2(1),J2(2),J2(3),'Y','FontSize',fs);
t8 = text(sp+K2(1),K2(2),K2(3),'Z','FontSize',fs);
C1 = plot3([2*sp,2*sp+I12(1)],[0,I12(2)],[0,I12(3)],'r','LineWidth',lw);
C2 = plot3([2*sp,2*sp+J12(1)],[0,J12(2)],[0,J12(3)],'g','LineWidth',lw);
C3 = plot3([2*sp,2*sp+K12(1)],[0,K12(2)],[0,K12(3)],'b','LineWidth',lw);
W1 = plot3([2*sp,2*sp+I1(1)],[0,I1(2)],[0,I1(3)],'r--','LineWidth',0.5);  
W2 = plot3([2*sp,2*sp+J1(1)],[0,J1(2)],[0,J1(3)],'g--','LineWidth',0.5);
W3 = plot3([2*sp,2*sp+K1(1)],[0,K1(2)],[0,K1(3)],'b--','LineWidth',0.5);
t9 = text(2*sp+I1(1),I1(2),I1(3),'X','FontSize',fs);
t10 = text(2*sp+J1(1),J1(2),J1(3),'Y','FontSize',fs);
t11 = text(2*sp+K1(1),K1(2),K1(3),'Z','FontSize',fs);
t12 = text(-0.5+2*sp,0,-0.1,'q_{12}','FontSize',fs);
t13 = text(2*sp+I12(1),I12(2),I12(3),'X''','FontSize',fs);
t14 = text(2*sp+J12(1),J12(2),J12(3),'Y''','FontSize',fs);
t15 = text(2*sp+K12(1),K12(2),K12(3),'Z''','FontSize',fs);
% delete([P1,P2,P3,C1,C2,C3,E1,E2,E3,t1,t2,t3,t4,t5,t6,t7,t8,W1,W2,W3,t9,t10,t11,t12,t13,t14,t15])
hold off

subplot(2,1,2)
hold on

% grid on
axis equal
axis([-8 8 -8 8])
Cir1 = plot(Cx,Cy,'k.'); 
C12 = plot([0,1.2*R*cos(0)],[0,1.2*R*sin(0)],'r','LineWidth',lw);
t16 = text(5.5,0,'0^o','FontSize',fs);
t17 = text(-6.5,0,'180^o','FontSize',fs);
t18 = text(0,+5.5,'90^o','FontSize',fs);
t19 = text(0,-5.5,'270^o','FontSize',fs);
t20 = text(0.25+1.2*R*cos(0),0.25+1.2*R*sin(0),strcat(num2str(0*180/pi),'^{o}'),'FontSize',fs);
% delete([t16,t17,t18,t19,t20,C12])
hold off



while time<=ttotal
tic;
    switch (WISESENSORID)
        case 'A'
           [q2,q3,q4,q5,q1] = DataReceive(ser,q2,q3,q4,q5,q1);
        case 'B'
           [q3,q2,q4,q5,q1] = DataReceive(ser,q3,q2,q4,q5,q1); 
        case 'C'
           [q4,q3,q2,q5,q1] = DataReceive(ser,q4,q3,q2,q5,q1); 
        case 'D'
           [q5,q3,q4,q2,q1] = DataReceive(ser,q5,q3,q4,q2,q1); 
        case 'E'
           [q1,q3,q4,q5,q2] = DataReceive(ser,q1,q3,q4,q5,q2); 
    end
    
[~,I1(1),I1(2),I1(3)] = parts(quaternion(quatmultiply(q1,quatmultiply(qI,quatconj(q1)))));
[~,J1(1),J1(2),J1(3)] = parts(quaternion(quatmultiply(q1,quatmultiply(qJ,quatconj(q1)))));
[~,K1(1),K1(2),K1(3)] = parts(quaternion(quatmultiply(q1,quatmultiply(qK,quatconj(q1)))));

[~,I2(1),I2(2),I2(3)] = parts(quaternion(quatmultiply(q2,quatmultiply(qI,quatconj(q2)))));
[~,J2(1),J2(2),J2(3)] = parts(quaternion(quatmultiply(q2,quatmultiply(qJ,quatconj(q2)))));
[~,K2(1),K2(2),K2(3)] = parts(quaternion(quatmultiply(q2,quatmultiply(qK,quatconj(q2)))));
q12 = quatmultiply(quatconj(q1),q2);
[~,I12(1),I12(2),I12(3)] = parts(quaternion(quatmultiply(q12,quatmultiply(qI,quatconj(q12)))));
[~,J12(1),J12(2),J12(3)] = parts(quaternion(quatmultiply(q12,quatmultiply(qJ,quatconj(q12)))));
[~,K12(1),K12(2),K12(3)] = parts(quaternion(quatmultiply(q12,quatmultiply(qK,quatconj(q12)))));

thetaX = atan2(dot(I2,K1),dot(I2,I1));
thetaY = atan2(dot(J2,K1),dot(J2,I1));
thetaZ = atan2(dot(K2,K1),dot(K2,I1));

switch (AX)
    case 'X'
        theta = thetaX;
    case 'Y'
        theta  = thetaY;
    case 'Z'
        theta = thetaZ;
end

figure(1)
hold on

subplot(2,1,1)
hold on
delete([P1,P2,P3,C1,C2,C3,E1,E2,E3,t1,t2,t3,t4,t5,t6,t7,t8,W1,W2,W3,t9,t10,t11,t12,t13,t14,t15])
% grid on
axis([-1 5.5 -1 2 -1 2]);
view([35,24]);
P1 = plot3([0,I1(1)],[0,I1(2)],[0,I1(3)],'r','LineWidth',lw);  
P2 = plot3([0,J1(1)],[0,J1(2)],[0,J1(3)],'g','LineWidth',lw);
P3 = plot3([0,K1(1)],[0,K1(2)],[0,K1(3)],'b','LineWidth',lw);
t1 = text(-0.5,0,-0.1,'q_1','FontSize',fs);
t2 = text(I1(1),I1(2),I1(3),'X_1','FontSize',fs);
t3 = text(J1(1),J1(2),J1(3),'Y_1','FontSize',fs);
t4 = text(K1(1),K1(2),K1(3),'Z_1','FontSize',fs);
E1 = plot3([sp,sp+I2(1)],[0,I2(2)],[0,I2(3)],'r','LineWidth',lw);  
E2 = plot3([sp,sp+J2(1)],[0,J2(2)],[0,J2(3)],'g','LineWidth',lw);
E3 = plot3([sp,sp+K2(1)],[0,K2(2)],[0,K2(3)],'b','LineWidth',lw);
t5 = text(-0.5+sp,0,-0.1,'q_2','FontSize',fs);
t6 = text(sp+I2(1),I2(2),I2(3),'X_2','FontSize',fs);
t7 = text(sp+J2(1),J2(2),J2(3),'Y_2','FontSize',fs);
t8 = text(sp+K2(1),K2(2),K2(3),'Z_2','FontSize',fs);
C1 = plot3([2*sp,2*sp+I2(1)],[0,I2(2)],[0,I2(3)],'r','LineWidth',lw);
C2 = plot3([2*sp,2*sp+J2(1)],[0,J2(2)],[0,J2(3)],'g','LineWidth',lw);
C3 = plot3([2*sp,2*sp+K2(1)],[0,K2(2)],[0,K2(3)],'b','LineWidth',lw);
W1 = plot3([2*sp,2*sp+I1(1)],[0,I1(2)],[0,I1(3)],'r--','LineWidth',0.5);  
W2 = plot3([2*sp,2*sp+J1(1)],[0,J1(2)],[0,J1(3)],'g--','LineWidth',0.5);
W3 = plot3([2*sp,2*sp+K1(1)],[0,K1(2)],[0,K1(3)],'b--','LineWidth',0.5);
t9 = text(2*sp+I1(1),I1(2),I1(3),'X_1','FontSize',fs);
t10 = text(2*sp+J1(1),J1(2),J1(3),'Y_1','FontSize',fs);
t11 = text(2*sp+K1(1),K1(2),K1(3),'Z_1','FontSize',fs);
t12 = text(-0.5+2*sp,0,-0.1,'q_{12}','FontSize',fs);
t13 = text(2*sp+I12(1),I12(2),I12(3),'X_2','FontSize',fs);
t14 = text(2*sp+J12(1),J12(2),J12(3),'Y_2','FontSize',fs);
t15 = text(2*sp+K12(1),K12(2),K12(3),'Z_2','FontSize',fs);

hold off

subplot(2,1,2)
hold on
delete([t16,t17,t18,t19,t20,C12])
% grid on
axis equal
axis([-8 8 -8 8])
Cir1 = plot(Cx,Cy,'k.'); 
C12 = plot([0,1.2*R*cos(theta)],[0,1.2*R*sin(theta)],'r','LineWidth',lw);
t16 = text(5.5,0,'0^o','FontSize',fs);
t17 = text(-6.5,0,'180^o','FontSize',fs);
t18 = text(0,+5.5,'90^o','FontSize',fs);
t19 = text(0,-5.5,'270^o','FontSize',fs);
t20 = text(0.25+1.2*R*cos(theta),0.25+1.2*R*sin(theta),strcat(num2str(theta*180/pi),'^{o}'),'FontSize',fs);
% suptitle(strcat('Turntable testing sensorID:   ',WISESENSORID, '   ',AX,' axis'));
hold off
fprintf(fwrite,'%f,%f,%f,%f,%f,%f,%f,%f,%f,%f\n',time,q1(1),q1(2),q1(3),q1(4),q2(1),q2(2),q2(3),q2(4),theta);
time = time+toc;
       if ~isempty(k)
           if strcmp(k,'q') 
           k=[];
           fclose(fwrite);
           break; 
           end
       end
pause(0.1);       
end
fclose(fwrite);