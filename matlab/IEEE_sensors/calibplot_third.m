clear all, clc
clf(figure(1),'reset')
%%
addpath('F:\github\wearable-jacket\matlab\IEEE_sensors\');
delete(instrfind({'Port'},{'COM15'}))
ser = serial('COM15','BaudRate',115200);
ser.ReadAsyncMode = 'continuous';
fopen(ser);k=[];
pause(2);
sts = 'F:\github\wearable-jacket\matlab\IEEE_sensors\data_matched\';
cd(sts);
ttotal = 1*60;
prompt1 = 'Please enter the sensor ID attached on the moving arm respond LA,LF,RA,RF: ';
WISESENSORID = input(prompt1,'s');

switch WISESENSORID
    case 'LF'
        WISEmod = 'a';
    case 'RF'
        WISEmod = 'b';
    case 'LA'
        WISEmod = 'c';
    case 'RA'
        WISEmod = 'd';
    case 'B'
        WISEmod = 'e';
end

if ~exist(strcat(sts,'\',WISESENSORID),'dir')
mkdir(strcat(sts,'\',WISESENSORID));
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

%%

gam = 0*pi/180;
rp = ((randperm(9,4)*0.1)+(randperm(9,4)*0.01))*pi/180;
gaq = size(rp);
gaq = 0;%gam+rp;
q1 = [1,0,0,0];q2 = [1,0,0,0];
qI = [0,1,0,0];qJ = [0,0,1,0];qK = [0,0,0,1];
I1 = [1 0 0]; I2 = [1 0 0]; 
J1 = [0 1 0]; J2 = [0 1 0]; 
K1 = [0 0 1]; K2 = [0 0 1];
sp = 3;lw = 2;fs = 12;
theta = 0;
th = -pi:10*pi/180:pi;
R = 5;  %or whatever radius you want
Cx = R*cos(th);
Cy = R*sin(th);


q1 = [cos(-pi/4),sin(-pi/4),0,0];
q2 = [cos(gaq(1)/2),0,0,sin(gaq(1)/2)];

[~,I1(1),I1(2),I1(3)] = parts(quaternion(quatmultiply(q1,quatmultiply(qI,quatconj(q1)))));
[~,J1(1),J1(2),J1(3)] = parts(quaternion(quatmultiply(q1,quatmultiply(qJ,quatconj(q1)))));
[~,K1(1),K1(2),K1(3)] = parts(quaternion(quatmultiply(q1,quatmultiply(qK,quatconj(q1)))));

[~,I2(1),I2(2),I2(3)] = parts(quaternion(quatmultiply(q2,quatmultiply(qI,quatconj(q2)))));
[~,J2(1),J2(2),J2(3)] = parts(quaternion(quatmultiply(q2,quatmultiply(qJ,quatconj(q2)))));
[~,K2(1),K2(2),K2(3)] = parts(quaternion(quatmultiply(q2,quatmultiply(qK,quatconj(q2)))));

% sz2 = screensize(2);
figure(1)
set(figure (1),'keypress','k=get(gcf,''currentchar'');' );
hold on

subplot(2,1,1)
hold on
axis equal
% axis off
axis([-10 4 -1.5 1.5 -1.5 1.5]);
view([11,29]);

E1 = plot3([-3*sp,I1(1)-3*sp],[0,I1(2)],[0,I1(3)],'r','LineWidth',lw);  
E2 = plot3([-3*sp,J1(1)-3*sp],[0,J1(2)],[0,J1(3)],'g','LineWidth',lw);
E3 = plot3([-3*sp,K1(1)-3*sp],[0,K1(2)],[0,K1(3)],'b','LineWidth',lw);
Et1 = text(-0.5-3*sp,0,-0.1,'BACK','FontSize',fs);
Et2 = text(I1(1)-3*sp,I1(2),I1(3),'X','FontSize',fs);
Et3 = text(J1(1)-3*sp,J1(2),J1(3),'Y','FontSize',fs);
Et4 = text(K1(1)-3*sp,K1(2),K1(3),'Z','FontSize',fs);

A1 = plot3([-2*sp,-2*sp+I2(1)],[0,I2(2)],[0,I2(3)],'r','LineWidth',lw);
A2 = plot3([-2*sp,-2*sp+J2(1)],[0,J2(2)],[0,J2(3)],'g','LineWidth',lw);
A3 = plot3([-2*sp,-2*sp+K2(1)],[0,K2(2)],[0,K2(3)],'b','LineWidth',lw);
At1 = text(-0.5-2*sp,0,-0.1,WISESENSORID,'FontSize',fs);
At2 = text(-2*sp+I2(1),I2(2),I2(3),'X','FontSize',fs);
At3 = text(-2*sp+J2(1),J2(2),J2(3),'Y','FontSize',fs);
At4 = text(-2*sp+K2(1),K2(2),K2(3),'Z','FontSize',fs);

set(gca,'YTick',[]);
set(gca,'XTick',[]);
set(gca,'ZTick',[]);
set(gca,'Yticklabel',[]); 
set(gca,'Xticklabel',[]);
set(gca,'Zticklabel',[]); 
hold off

SubP2 = subplot(2,1,2);
hold on
% grid on
axis equal
% axis off
axis([-R R -R R])

text(5.5,0,'0^o','FontSize',fs)
text(-6.5,0,'180^o','FontSize',fs)
text(0,+5.5,'90^o','FontSize',fs)
text(0,-5.5,'-90^o','FontSize',fs)

plot(Cx,Cy,'k.'); 
plot(0.25*Cx,0.25*Cy,'k.'); 
plot(0.5*Cx,0.5*Cy,'k.'); 
plot(0.75*Cx,0.75*Cy,'k.'); 
plot([-5.5,5.5],[0,0],'k--');
plot([0,0],[-5.5,5.5],'k--');
Cl1 = plot([0,R*cos(gaq(1))],[0,R*sin(gaq(1))],'r','DisplayName',WISESENSORID,'LineWidth',lw);
t20 = text(-7,7.5,strcat(WISESENSORID,num2str(gaq(1)*180/pi),'^{o}'),'FontSize',fs);
set(gca,'YTick',[]);
set(gca,'XTick',[]);
set(gca,'ZTick',[]);
set(gca,'Yticklabel',[]); 
set(gca,'Xticklabel',[]);
set(gca,'Zticklabel',[]); 
lgnd = legend(SubP2,[Cl1],'Location','none','FontSize',fs);
set(lgnd, 'Position', [0.6524 0.2185 0.0410 0.1185])
hold off


%%

f1 = sprintf('%s_WISE+turntable_%s.txt',num2str(ANGLE),datestr(now,'mm-dd-yyyy HH-MM'));
fwrite = fopen(f1,'wt');
time = 0;
while time<=ttotal
tic;
q = [q1;q2];
[Q] = ModsReceive(ser,strcat('e,',WISEmod),q);
q1 = Q(1,:);
q2 = Q(2,:);
    
theta = Simple_JCS(AX,q1,q2);
    
[~,I1(1),I1(2),I1(3)] = parts(quaternion(quatmultiply(q1,quatmultiply(qI,quatconj(q1)))));
[~,J1(1),J1(2),J1(3)] = parts(quaternion(quatmultiply(q1,quatmultiply(qJ,quatconj(q1)))));
[~,K1(1),K1(2),K1(3)] = parts(quaternion(quatmultiply(q1,quatmultiply(qK,quatconj(q1)))));

[~,I2(1),I2(2),I2(3)] = parts(quaternion(quatmultiply(q2,quatmultiply(qI,quatconj(q2)))));
[~,J2(1),J2(2),J2(3)] = parts(quaternion(quatmultiply(q2,quatmultiply(qJ,quatconj(q2)))));
[~,K2(1),K2(2),K2(3)] = parts(quaternion(quatmultiply(q2,quatmultiply(qK,quatconj(q2)))));

figure(1)
hold on

subplot(2,1,1)
hold on
delete([E1,E2,E3,Et2,Et3,Et4,A1,A2,A3,At2,At3,At4])
% grid on
E1 = plot3([-3*sp,I1(1)-3*sp],[0,I1(2)],[0,I1(3)],'r','LineWidth',lw);  
E2 = plot3([-3*sp,J1(1)-3*sp],[0,J1(2)],[0,J1(3)],'g','LineWidth',lw);
E3 = plot3([-3*sp,K1(1)-3*sp],[0,K1(2)],[0,K1(3)],'b','LineWidth',lw);
Et2 = text(I1(1)-3*sp,I1(2),I1(3),'X','FontSize',fs);
Et3 = text(J1(1)-3*sp,J1(2),J1(3),'Y','FontSize',fs);
Et4 = text(K1(1)-3*sp,K1(2),K1(3),'Z','FontSize',fs);

A1 = plot3([-2*sp,-2*sp+I2(1)],[0,I2(2)],[0,I2(3)],'r','LineWidth',lw);
A2 = plot3([-2*sp,-2*sp+J2(1)],[0,J2(2)],[0,J2(3)],'g','LineWidth',lw);
A3 = plot3([-2*sp,-2*sp+K2(1)],[0,K2(2)],[0,K2(3)],'b','LineWidth',lw);
At2 = text(-2*sp+I2(1),I2(2),I2(3),'X','FontSize',fs);
At3 = text(-2*sp+J2(1),J2(2),J2(3),'Y','FontSize',fs);
At4 = text(-2*sp+K2(1),K2(2),K2(3),'Z','FontSize',fs);

hold off

subplot(2,1,2)
hold on
delete([Cl1,t20])
% grid on
axis equal
axis([-R R -R R])
Cl1 = plot([0,R*cosd(theta)],[0,R*sind(theta)],'r','LineWidth',lw);
t20 = text(-7,7.5,strcat(WISESENSORID,'  ',num2str(theta),'^{o}'),'FontSize',fs);

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
       pause(0.01)
end
fclose(fwrite);