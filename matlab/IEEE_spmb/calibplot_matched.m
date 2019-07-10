clear all, clc
clf(figure(1),'reset')
addpath('C:\Users\ranst\OneDrive\Documents\GitHub\WISE\matlab\IEEE_spmb\');
delete(instrfind({'Port'},{'COM9'}))
ser = serial('COM9','BaudRate',115200);
ser.ReadAsyncMode = 'continuous';
fopen(ser);k=[];
sts = 'C:\Users\ranst\OneDrive\Documents\GitHub\WISE\matlab\IEEE_spmb\data_matched\';
cd(sts);
ttotal = 0.5*60;
prompt1 = 'Please enter the sensor ID attached on the moving arm respond A,B,C,D: ';
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

f1 = sprintf('%s_WISE+turntable_%s.txt',num2str(ANGLE),datestr(now,'mm-dd-yyyy HH-MM'));
fwrite = fopen(f1,'wt');

q1 = [1,0,0,0];q2 = [1,0,0,0];q3 = [1,0,0,0];q4 = [1,0,0,0];q5 = [1,0,0,0];
qI = [0,1,0,0];qJ = [0,0,1,0];qK = [0,0,0,1];qR = [1,0,0,0];
I1 = [1 0 0]; I2 = [1 0 0]; I3 = [1 0 0];I4 = [1 0 0]; I5 = [1 0 0];
J1 = [0 1 0]; J2 = [0 1 0]; J3 = [0 1 0];J4 = [0 1 0]; J5 = [0 1 0];
K1 = [0 0 1]; K2 = [0 0 1]; K3 = [0 0 1];K4 = [0 0 1]; K5 = [0 0 1];
sp = 3;lw = 1.25;fs = 12;
theta1 = 0;theta2 = 0;theta3 = 0;theta4 = 0;
th = linspace( -pi, pi, 40);
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
axis([-10 4 -1.5 1.5 -1.5 1.5]);
view([11,29]);

E1 = plot3([-3*sp,I1(1)-3*sp],[0,I1(2)],[0,I1(3)],'r','LineWidth',lw);  
E2 = plot3([-3*sp,J1(1)-3*sp],[0,J1(2)],[0,J1(3)],'g','LineWidth',lw);
E3 = plot3([-3*sp,K1(1)-3*sp],[0,K1(2)],[0,K1(3)],'b','LineWidth',lw);
Et1 = text(-0.5-3*sp,0,-0.1,'E','FontSize',fs);
Et2 = text(I1(1)-3*sp,I1(2),I1(3),'X','FontSize',fs);
Et3 = text(J1(1)-3*sp,J1(2),J1(3),'Y','FontSize',fs);
Et4 = text(K1(1)-3*sp,K1(2),K1(3),'Z','FontSize',fs);

A1 = plot3([-2*sp,-2*sp+I2(1)],[0,I2(2)],[0,I2(3)],'r','LineWidth',lw);
A2 = plot3([-2*sp,-2*sp+J2(1)],[0,J2(2)],[0,J2(3)],'g','LineWidth',lw);
A3 = plot3([-2*sp,-2*sp+K2(1)],[0,K2(2)],[0,K2(3)],'b','LineWidth',lw);
At1 = text(-0.5-2*sp,0,-0.1,'A','FontSize',fs);
At2 = text(-2*sp+I2(1),I2(2),I2(3),'X','FontSize',fs);
At3 = text(-2*sp+J2(1),J2(2),J2(3),'Y','FontSize',fs);
At4 = text(-2*sp+K2(1),K2(2),K2(3),'Z','FontSize',fs);

B1 = plot3([-1*sp,-1*sp+I3(1)],[0,I3(2)],[0,I3(3)],'r','LineWidth',lw);
B2 = plot3([-1*sp,-1*sp+J3(1)],[0,J3(2)],[0,J3(3)],'g','LineWidth',lw);
B3 = plot3([-1*sp,-1*sp+K3(1)],[0,K3(2)],[0,K3(3)],'b','LineWidth',lw);
Bt1 = text(-0.5-1*sp,0,-0.1,'B','FontSize',fs);
Bt2 = text(-1*sp+I3(1),I2(2),I2(3),'X','FontSize',fs);
Bt3 = text(-1*sp+J3(1),J2(2),J2(3),'Y','FontSize',fs);
Bt4 = text(-1*sp+K3(1),K2(2),K2(3),'Z','FontSize',fs);

C1 = plot3([0,I4(1)],[0,I4(2)],[0,I4(3)],'r','LineWidth',lw);  
C2 = plot3([0,J4(1)],[0,J4(2)],[0,J4(3)],'g','LineWidth',lw);
C3 = plot3([0,K4(1)],[0,K4(2)],[0,K4(3)],'b','LineWidth',lw);
Ct1 = text(-0.50,0,-0.1,'C','FontSize',fs);
Ct2 = text(I4(1),I4(2),I4(3),'X','FontSize',fs);
Ct3 = text(J4(1),J4(2),J4(3),'Y','FontSize',fs);
Ct4 = text(K4(1),K4(2),K4(3),'Z','FontSize',fs);

D1 = plot3([sp,sp+I5(1)],[0,I5(2)],[0,I5(3)],'r','LineWidth',lw);  
D2 = plot3([sp,sp+J5(1)],[0,J5(2)],[0,J5(3)],'g','LineWidth',lw);
D3 = plot3([sp,sp+K5(1)],[0,K5(2)],[0,K5(3)],'b','LineWidth',lw);
Dt1 = text(sp-0.50,0,-0.1,'D','FontSize',fs);
Dt2 = text(sp+I5(1),I5(2),I5(3),'X','FontSize',fs);
Dt3 = text(sp+J5(1),J5(2),J5(3),'Y','FontSize',fs);
Dt4 = text(sp+K5(1),K5(2),K5(3),'Z','FontSize',fs);

hold off

subplot(2,1,2)
hold on

% grid on
axis equal
axis([-8 8 -8 8])
plot(Cx,Cy,'k.'); 
plot(0.25*Cx,0.25*Cy,'k.'); 
plot(0.5*Cx,0.5*Cy,'k.'); 
plot(0.75*Cx,0.75*Cy,'k.'); 
plot([-5.5,5.5],[0,0],'k--');
plot([0,0],[-5.5,5.5],'k--');
Cl1 = plot([0,0.25*R*cos(0)],[0,0.25*R*sin(0)],'r','LineWidth',lw);
Cl2 = plot([0.25*R*cos(0),0.5*R*cos(0)],[0.25*R*sin(0),0.5*R*sin(0)],'g','LineWidth',lw);
Cl3 = plot([0.5*R*cos(0),0.75*R*cos(0)],[0.5*R*sin(0),0.75*R*sin(0)],'y','LineWidth',lw);
Cl4 = plot([0.75*R*cos(0),R*cos(0)],[0.75*R*sin(0),1*R*sin(0)],'b','LineWidth',lw);
t16 = text(5.5,0,'0^o','FontSize',fs);
t17 = text(-6.5,0,'180^o','FontSize',fs);
t18 = text(0,+5.5,'90^o','FontSize',fs);
t19 = text(0,-5.5,'-90^o','FontSize',fs);
t20 = text(-7,7.5,strcat('A:   ',num2str(0*180/pi),'^{o}'),'FontSize',fs);
t21 = text(-3,7.5,strcat('B:   ',num2str(0*180/pi),'^{o}'),'FontSize',fs);
t22 = text(1,7.5,strcat('C:   ',num2str(0*180/pi),'^{o}'),'FontSize',fs);
t23 = text(5,7.5,strcat('D:   ',num2str(0*180/pi),'^{o}'),'FontSize',fs);
hold off



while time<=ttotal
tic;
    switch (WISESENSORID)
        case 'A,B,C,D'
           [q2,q3,q4,q5,q1] = DataReceive_matched(ser,q2,q3,q4,q5,q1);
    end
    
[~,I1(1),I1(2),I1(3)] = parts(quaternion(quatmultiply(q1,quatmultiply(qI,quatconj(q1)))));
[~,J1(1),J1(2),J1(3)] = parts(quaternion(quatmultiply(q1,quatmultiply(qJ,quatconj(q1)))));
[~,K1(1),K1(2),K1(3)] = parts(quaternion(quatmultiply(q1,quatmultiply(qK,quatconj(q1)))));

[~,I2(1),I2(2),I2(3)] = parts(quaternion(quatmultiply(q2,quatmultiply(qI,quatconj(q2)))));
[~,J2(1),J2(2),J2(3)] = parts(quaternion(quatmultiply(q2,quatmultiply(qJ,quatconj(q2)))));
[~,K2(1),K2(2),K2(3)] = parts(quaternion(quatmultiply(q2,quatmultiply(qK,quatconj(q2)))));

[~,I3(1),I3(2),I3(3)] = parts(quaternion(quatmultiply(q3,quatmultiply(qI,quatconj(q3)))));
[~,J3(1),J3(2),J3(3)] = parts(quaternion(quatmultiply(q3,quatmultiply(qJ,quatconj(q3)))));
[~,K3(1),K3(2),K3(3)] = parts(quaternion(quatmultiply(q3,quatmultiply(qK,quatconj(q3)))));

[~,I4(1),I4(2),I4(3)] = parts(quaternion(quatmultiply(q4,quatmultiply(qI,quatconj(q4)))));
[~,J4(1),J4(2),J4(3)] = parts(quaternion(quatmultiply(q4,quatmultiply(qJ,quatconj(q4)))));
[~,K4(1),K4(2),K4(3)] = parts(quaternion(quatmultiply(q4,quatmultiply(qK,quatconj(q4)))));

[~,I5(1),I5(2),I5(3)] = parts(quaternion(quatmultiply(q5,quatmultiply(qI,quatconj(q5)))));
[~,J5(1),J5(2),J5(3)] = parts(quaternion(quatmultiply(q5,quatmultiply(qJ,quatconj(q5)))));
[~,K5(1),K5(2),K5(3)] = parts(quaternion(quatmultiply(q5,quatmultiply(qK,quatconj(q5)))));

theta1X = atan2(dot(I2,K1),dot(I2,I1));
theta1Y = atan2(dot(J2,K1),dot(J2,I1));
theta1Z = atan2(dot(K2,K1),dot(K2,I1));

theta2X = atan2(dot(I3,K1),dot(I3,I1));
theta2Y = atan2(dot(J3,K1),dot(J3,I1));
theta2Z = atan2(dot(K3,K1),dot(K3,I1));

theta3X = atan2(dot(I4,K1),dot(I4,I1));
theta3Y = atan2(dot(J4,K1),dot(J4,I1));
theta3Z = atan2(dot(K4,K1),dot(K4,I1));

theta4X = atan2(dot(I5,K1),dot(I4,I1));
theta4Y = atan2(dot(J5,K1),dot(J4,I1));
theta4Z = atan2(dot(K5,K1),dot(K4,I1));

switch (AX)
    case 'X'
        theta1 = theta1X;
        theta2 = theta2X;
        theta3 = theta3X;
        theta4 = theta4X;
    case 'Y'
        theta1  = theta1Y;
        theta2  = theta2Y;
        theta3  = theta3Y;
        theta4  = theta4Y;
    case 'Z'
         theta1 = theta1Z;
         theta2 = theta2Z;
         theta3 = theta3Z;
         theta4 = theta4Z;
end

figure(1)
hold on

subplot(2,1,1)
hold on
delete([E1,E2,E3,Et1,Et2,Et3,Et4,A1,A2,A3,At1,At2,At3,At4,B1,B2,B3,Bt1,Bt2,Bt3,Bt4,C1,C2,C3,Ct1,Ct2,Ct3,Ct4,D1,D2,D3,Dt1,Dt2,Dt3,Dt4])
% grid on
E1 = plot3([-3*sp,I1(1)-3*sp],[0,I1(2)],[0,I1(3)],'r','LineWidth',lw);  
E2 = plot3([-3*sp,J1(1)-3*sp],[0,J1(2)],[0,J1(3)],'g','LineWidth',lw);
E3 = plot3([-3*sp,K1(1)-3*sp],[0,K1(2)],[0,K1(3)],'b','LineWidth',lw);
Et1 = text(-0.5-3*sp,0,-0.1,'E','FontSize',fs);
Et2 = text(I1(1)-3*sp,I1(2),I1(3),'X','FontSize',fs);
Et3 = text(J1(1)-3*sp,J1(2),J1(3),'Y','FontSize',fs);
Et4 = text(K1(1)-3*sp,K1(2),K1(3),'Z','FontSize',fs);

A1 = plot3([-2*sp,-2*sp+I2(1)],[0,I2(2)],[0,I2(3)],'r','LineWidth',lw);
A2 = plot3([-2*sp,-2*sp+J2(1)],[0,J2(2)],[0,J2(3)],'g','LineWidth',lw);
A3 = plot3([-2*sp,-2*sp+K2(1)],[0,K2(2)],[0,K2(3)],'b','LineWidth',lw);
At1 = text(-0.5-2*sp,0,-0.1,'A','FontSize',fs);
At2 = text(-2*sp+I2(1),I2(2),I2(3),'X','FontSize',fs);
At3 = text(-2*sp+J2(1),J2(2),J2(3),'Y','FontSize',fs);
At4 = text(-2*sp+K2(1),K2(2),K2(3),'Z','FontSize',fs);

B1 = plot3([-1*sp,-1*sp+I3(1)],[0,I3(2)],[0,I3(3)],'r','LineWidth',lw);
B2 = plot3([-1*sp,-1*sp+J3(1)],[0,J3(2)],[0,J3(3)],'g','LineWidth',lw);
B3 = plot3([-1*sp,-1*sp+K3(1)],[0,K3(2)],[0,K3(3)],'b','LineWidth',lw);
Bt1 = text(-0.5-1*sp,0,-0.1,'B','FontSize',fs);
Bt2 = text(-1*sp+I3(1),I2(2),I2(3),'X','FontSize',fs);
Bt3 = text(-1*sp+J3(1),J2(2),J2(3),'Y','FontSize',fs);
Bt4 = text(-1*sp+K3(1),K2(2),K2(3),'Z','FontSize',fs);

C1 = plot3([0,I4(1)],[0,I4(2)],[0,I4(3)],'r','LineWidth',lw);  
C2 = plot3([0,J4(1)],[0,J4(2)],[0,J4(3)],'g','LineWidth',lw);
C3 = plot3([0,K4(1)],[0,K4(2)],[0,K4(3)],'b','LineWidth',lw);
Ct1 = text(-0.50,0,-0.1,'C','FontSize',fs);
Ct2 = text(I4(1),I4(2),I4(3),'X','FontSize',fs);
Ct3 = text(J4(1),J4(2),J4(3),'Y','FontSize',fs);
Ct4 = text(K4(1),K4(2),K4(3),'Z','FontSize',fs);

D1 = plot3([sp,sp+I5(1)],[0,I5(2)],[0,I5(3)],'r','LineWidth',lw);  
D2 = plot3([sp,sp+J5(1)],[0,J5(2)],[0,J5(3)],'g','LineWidth',lw);
D3 = plot3([sp,sp+K5(1)],[0,K5(2)],[0,K5(3)],'b','LineWidth',lw);
Dt1 = text(sp-0.50,0,-0.1,'D','FontSize',fs);
Dt2 = text(sp+I5(1),I5(2),I5(3),'X','FontSize',fs);
Dt3 = text(sp+J5(1),J5(2),J5(3),'Y','FontSize',fs);
Dt4 = text(sp+K5(1),K5(2),K5(3),'Z','FontSize',fs);

hold off

subplot(2,1,2)
hold on
delete([t16,t17,t18,t19,t20,Cl1,Cl2,Cl3,Cl4,t21,t22,t23])
% grid on
axis equal
axis([-8 8 -8 8])
Cir1 = plot(Cx,Cy,'k.'); 
Cl1 = plot([0,0.25*R*cos(theta1)],[0,0.25*R*sin(theta1)],'r','LineWidth',lw);
Cl2 = plot([0.25*R*cos(theta2),0.5*R*cos(theta2)],[0.25*R*sin(theta2),0.5*R*sin(theta2)],'g','LineWidth',lw);
Cl3 = plot([0.5*R*cos(theta3),0.75*R*cos(theta3)],[0.5*R*sin(theta3),0.75*R*sin(theta3)],'y','LineWidth',lw);
Cl4 = plot([0.75*R*cos(theta4),R*cos(theta4)],[0.75*R*sin(theta4),1*R*sin(theta4)],'b','LineWidth',lw);
t16 = text(5.5,0,'0^o','FontSize',fs);
t17 = text(-6.5,0,'180^o','FontSize',fs);
t18 = text(0,+5.5,'90^o','FontSize',fs);
t19 = text(0,-5.5,'-90^o','FontSize',fs);
t20 = text(-7,7.5,strcat('A:  ',num2str(theta1*180/pi),'^{o}'),'FontSize',fs);
t21 = text(-3,7.5,strcat('B:  ',num2str(theta2*180/pi),'^{o}'),'FontSize',fs);
t22 = text(1,7.5,strcat('C:  ',num2str(theta3*180/pi),'^{o}'),'FontSize',fs);
t23 = text(5,7.5,strcat('D:  ',num2str(theta4*180/pi),'^{o}'),'FontSize',fs);

% suptitle(strcat('Turntable testing sensorID:   ',WISESENSORID, '   ',AX,' axis'));
hold off
fprintf(fwrite,'%f,%f,%f,%f,%f,%f,%f,%f,%f,%f,%f,%f,%f,%f,%f,%f,%f,%f,%f,%f,%f\n',time,q1(1),q1(2),q1(3),q1(4),q2(1),q2(2),q2(3),q2(4),q3(1),q3(2),q3(3),q3(4),q4(1),q4(2),q4(3),q4(4),theta1,theta2,theta3,theta4);
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