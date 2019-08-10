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
WISESENSORID = string(WISESENSORID);
Mods = strsplit(WISESENSORID,',');
Nm = length(Mods);

WISEmod = "";
for i = 1:Nm
    switch Mods(i)
        case 'LF'
            WISEmod = strcat(WISEmod,'a');
            if i~=Nm
                WISEmod = strcat(WISEmod,',');
            end
        case 'RF'
            WISEmod = strcat(WISEmod,'b');
            if i~=Nm
                WISEmod = strcat(WISEmod,',');
            end
        case 'LA'
            WISEmod = strcat(WISEmod,'c');
            if i~=Nm
                WISEmod = strcat(WISEmod,',');
            end
        case 'RA'
            WISEmod = strcat(WISEmod,'d');
            if i~=Nm
                WISEmod = strcat(WISEmod,',');
            end
    end
end

WISEmod = strcat('e,',WISEmod);

AllMods = ["BA",Mods];

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

q = zeros(Nm+1,4);
q(:,1) = ones(Nm+1,1);
qI = [0,1,0,0];qJ = [0,0,1,0];qK = [0,0,0,1];

I = zeros(Nm+1,3);
I(:,1) = ones(Nm+1,1); 
J = zeros(Nm+1,3);
J(:,2) = ones(Nm+1,1);
K = zeros(Nm+1,3);
K(:,3) = ones(Nm+1,1);

sp = 3;
lw = 2;
fs = 12;
th = -pi:10*pi/180:pi;
R = 5;  %or whatever radius you want
dr = 1/Nm;
Cx = R*cos(th);
Cy = R*sin(th);

for i = 1:Nm+1
[~,I(i,1),I(i,2),I(i,3)] = parts(quaternion(quatmultiply(q(i,:),quatmultiply(qI,quatconj(q(i,:))))));
[~,J(i,1),J(i,2),J(i,3)] = parts(quaternion(quatmultiply(q(i,:),quatmultiply(qJ,quatconj(q(i,:))))));
[~,K(i,1),K(i,2),K(i,3)] = parts(quaternion(quatmultiply(q(i,:),quatmultiply(qK,quatconj(q(i,:))))));
end

% sz2 = screensize(2);
figure(1)
set(figure (1),'keypress','k=get(gcf,''currentchar'');' );
hold on

SubP1 = subplot(2,1,1);
hold on
axis equal
% axis off
axis([-1.5 1.5+sp*Nm -1.5 1.5 -1.5 1.5]);
view([11,29]);

F = gobjects(3,Nm+1);
T = gobjects(4,Nm+1);

for i = 1:Nm+1
F(1,i) = plot3([(i-1)*sp,(i-1)*sp+I(i,1)],[0,I(i,2)],[0,I(i,3)],'r','LineWidth',lw);  
F(2,i) = plot3([(i-1)*sp,(i-1)*sp+J(i,1)],[0,J(i,2)],[0,J(i,3)],'g','LineWidth',lw);
F(3,i) = plot3([(i-1)*sp,(i-1)*sp+K(i,1)],[0,K(i,2)],[0,K(i,3)],'b','LineWidth',lw);
T(1,i) = text((i-1)*sp,0,-0.1,AllMods(i),'FontSize',fs);
T(2,i) = text((i-1)*sp+I(i,1),I(i,2),I(i,3),'X','FontSize',fs);
T(3,i) = text((i-1)*sp+J(i,1),J(i,2),J(i,3),'Y','FontSize',fs);
T(4,i) = text((i-1)*sp+K(i,1),K(i,2),K(i,3),'Z','FontSize',fs);
end

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

for i = 1:Nm
    plot(i*dr*Cx,i*dr*Cy,'k.'); 
end
 
plot([-R,R],[0,0],'k--');
plot([0,0],[-R,R],'k--');

Colors = ['r','g','b','y'];
points = linspace(-R*1.5,R*1.5,Nm);
L = gobjects(1,Nm);
TH = gobjects(1,Nm);
for i = 1:Nm
    L(i) = plot([(i-1)*dr*R*cos(0),i*dr*R*cos(0)],[(i-1)*dr*R*sin(0),i*dr*R*sin(0)],Colors(i),'DisplayName',Mods(i),'LineWidth',lw);
    TH(i) = text(points(i),7.5,strcat(Mods(i),' = ',num2str(0*180/pi),'^{o}'),'FontSize',fs);
end

set(gca,'YTick',[]);
set(gca,'XTick',[]);
set(gca,'ZTick',[]);
set(gca,'Yticklabel',[]); 
set(gca,'Xticklabel',[]);
set(gca,'Zticklabel',[]); 
% lgnd = legend(SubP2,L,'Location','none','FontSize',fs);
% set(lgnd, 'Position', [0.6524 0.2185 0.0410 0.1185])
hold off

%%
theta = zeros(1,Nm);
while true
tic;
[q] = ModsReceive(ser,WISEmod,q);

theta(1) = Simple_JCS(AX,q(1,:),q(2,:));
theta(2) = Simple_JCS(AX,q(1,:),q(3,:));
theta(3) = Simple_JCS(AX,q(1,:),q(4,:));
theta(4) = Simple_JCS(AX,q(1,:),q(5,:));

    

[~,I(1,1),I(1,2),I(1,3)] = parts(quaternion(quatmultiply(q(1,:),quatmultiply(qI,quatconj(q(1,:))))));
[~,J(1,1),J(1,2),J(1,3)] = parts(quaternion(quatmultiply(q(1,:),quatmultiply(qJ,quatconj(q(1,:))))));
[~,K(1,1),K(1,2),K(1,3)] = parts(quaternion(quatmultiply(q(1,:),quatmultiply(qK,quatconj(q(1,:))))));

[~,I(2,1),I(2,2),I(2,3)] = parts(quaternion(quatmultiply(q(2,:),quatmultiply(qI,quatconj(q(2,:))))));
[~,J(2,1),J(2,2),J(2,3)] = parts(quaternion(quatmultiply(q(2,:),quatmultiply(qJ,quatconj(q(2,:))))));
[~,K(2,1),K(2,2),K(2,3)] = parts(quaternion(quatmultiply(q(2,:),quatmultiply(qK,quatconj(q(2,:))))));

[~,I(3,1),I(3,2),I(3,3)] = parts(quaternion(quatmultiply(q(3,:),quatmultiply(qI,quatconj(q(3,:))))));
[~,J(3,1),J(3,2),J(3,3)] = parts(quaternion(quatmultiply(q(3,:),quatmultiply(qJ,quatconj(q(3,:))))));
[~,K(3,1),K(3,2),K(3,3)] = parts(quaternion(quatmultiply(q(3,:),quatmultiply(qK,quatconj(q(3,:))))));

[~,I(4,1),I(4,2),I(4,3)] = parts(quaternion(quatmultiply(q(4,:),quatmultiply(qI,quatconj(q(4,:))))));
[~,J(4,1),J(4,2),J(4,3)] = parts(quaternion(quatmultiply(q(4,:),quatmultiply(qJ,quatconj(q(4,:))))));
[~,K(4,1),K(4,2),K(4,3)] = parts(quaternion(quatmultiply(q(4,:),quatmultiply(qK,quatconj(q(4,:))))));

[~,I(5,1),I(5,2),I(5,3)] = parts(quaternion(quatmultiply(q(5,:),quatmultiply(qI,quatconj(q(5,:))))));
[~,J(5,1),J(5,2),J(5,3)] = parts(quaternion(quatmultiply(q(5,:),quatmultiply(qJ,quatconj(q(5,:))))));
[~,K(5,1),K(5,2),K(5,3)] = parts(quaternion(quatmultiply(q(5,:),quatmultiply(qK,quatconj(q(5,:))))));


delete([F(1,:),F(2,:),F(3,:),T(1,:),T(2,:),T(3,:),T(4,:)])
delete([L(1),L(2),L(3),L(4),TH(1),TH(2),TH(3),TH(4)])

figure(1)
hold on

subplot(2,1,1)
hold on

F(1,1) = plot3([(1-1)*sp,(1-1)*sp+I(1,1)],[0,I(1,2)],[0,I(1,3)],'r','LineWidth',lw);  
F(2,1) = plot3([(1-1)*sp,(1-1)*sp+J(1,1)],[0,J(1,2)],[0,J(1,3)],'g','LineWidth',lw);
F(3,1) = plot3([(1-1)*sp,(1-1)*sp+K(1,1)],[0,K(1,2)],[0,K(1,3)],'b','LineWidth',lw);
T(1,1) = text((1-1)*sp,0,-0.1,AllMods(1),'FontSize',fs);
T(2,1) = text((1-1)*sp+I(1,1),I(1,2),I(1,3),'X','FontSize',fs);
T(3,1) = text((1-1)*sp+J(1,1),J(1,2),J(1,3),'Y','FontSize',fs);
T(4,1) = text((1-1)*sp+K(1,1),K(1,2),K(1,3),'Z','FontSize',fs);

F(1,2) = plot3([(2-1)*sp,(2-1)*sp+I(2,1)],[0,I(2,2)],[0,I(2,3)],'r','LineWidth',lw);  
F(2,2) = plot3([(2-1)*sp,(2-1)*sp+J(2,1)],[0,J(2,2)],[0,J(2,3)],'g','LineWidth',lw);
F(3,2) = plot3([(2-1)*sp,(2-1)*sp+K(2,1)],[0,K(2,2)],[0,K(2,3)],'b','LineWidth',lw);
T(1,2) = text((2-1)*sp,0,-0.1,AllMods(2),'FontSize',fs);
T(2,2) = text((2-1)*sp+I(2,1),I(2,2),I(2,3),'X','FontSize',fs);
T(3,2) = text((2-1)*sp+J(2,1),J(2,2),J(2,3),'Y','FontSize',fs);
T(4,2) = text((2-1)*sp+K(2,1),K(2,2),K(2,3),'Z','FontSize',fs);

F(1,3) = plot3([(3-1)*sp,(3-1)*sp+I(3,1)],[0,I(3,2)],[0,I(3,3)],'r','LineWidth',lw);  
F(2,3) = plot3([(3-1)*sp,(3-1)*sp+J(3,1)],[0,J(3,2)],[0,J(3,3)],'g','LineWidth',lw);
F(3,3) = plot3([(3-1)*sp,(3-1)*sp+K(3,1)],[0,K(3,2)],[0,K(3,3)],'b','LineWidth',lw);
T(1,3) = text((3-1)*sp,0,-0.1,AllMods(3),'FontSize',fs);
T(2,3) = text((3-1)*sp+I(3,1),I(3,2),I(3,3),'X','FontSize',fs);
T(3,3) = text((3-1)*sp+J(3,1),J(3,2),J(3,3),'Y','FontSize',fs);
T(4,3) = text((3-1)*sp+K(3,1),K(3,2),K(3,3),'Z','FontSize',fs);

F(1,4) = plot3([(4-1)*sp,(4-1)*sp+I(4,1)],[0,I(4,2)],[0,I(4,3)],'r','LineWidth',lw);  
F(2,4) = plot3([(4-1)*sp,(4-1)*sp+J(4,1)],[0,J(4,2)],[0,J(4,3)],'g','LineWidth',lw);
F(3,4) = plot3([(4-1)*sp,(4-1)*sp+K(4,1)],[0,K(4,2)],[0,K(4,3)],'b','LineWidth',lw);
T(1,4) = text((4-1)*sp,0,-0.1,AllMods(4),'FontSize',fs);
T(2,4) = text((4-1)*sp+I(4,1),I(4,2),I(4,3),'X','FontSize',fs);
T(3,4) = text((4-1)*sp+J(4,1),J(4,2),J(4,3),'Y','FontSize',fs);
T(4,4) = text((4-1)*sp+K(4,1),K(4,2),K(4,3),'Z','FontSize',fs);

F(1,5) = plot3([(5-1)*sp,(5-1)*sp+I(5,1)],[0,I(5,2)],[0,I(5,3)],'r','LineWidth',lw);  
F(2,5) = plot3([(5-1)*sp,(5-1)*sp+J(5,1)],[0,J(5,2)],[0,J(5,3)],'g','LineWidth',lw);
F(3,5) = plot3([(5-1)*sp,(5-1)*sp+K(5,1)],[0,K(5,2)],[0,K(5,3)],'b','LineWidth',lw);
T(1,5) = text((5-1)*sp,0,-0.1,AllMods(5),'FontSize',fs);
T(2,5) = text((5-1)*sp+I(5,1),I(5,2),I(5,3),'X','FontSize',fs);
T(3,5) = text((5-1)*sp+J(5,1),J(5,2),J(5,3),'Y','FontSize',fs);
T(4,5) = text((5-1)*sp+K(5,1),K(5,2),K(5,3),'Z','FontSize',fs);


hold off

subplot(2,1,2)
hold on

L(1) = plot([(1-1)*dr*R*cosd(theta(1)),i*dr*R*cosd(theta(1))],[(1-1)*dr*R*sind(theta(1)),i*dr*R*sind(theta(1))],Colors(1),'DisplayName',Mods(1),'LineWidth',lw);
TH(1) = text(points(1),7.5,strcat(Mods(1),' = ',num2str(theta(1)),'^{o}'),'FontSize',fs);

L(2) = plot([(2-1)*dr*R*cosd(theta(2)),i*dr*R*cosd(theta(2))],[(2-1)*dr*R*sind(theta(2)),i*dr*R*sind(theta(2))],Colors(2),'DisplayName',Mods(2),'LineWidth',lw);
TH(2) = text(points(2),7.5,strcat(Mods(2),' = ',num2str(theta(2)),'^{o}'),'FontSize',fs);

L(3) = plot([(3-1)*dr*R*cosd(theta(3)),i*dr*R*cosd(theta(3))],[(3-1)*dr*R*sind(theta(3)),i*dr*R*sind(theta(3))],Colors(3),'DisplayName',Mods(3),'LineWidth',lw);
TH(3) = text(points(3),7.5,strcat(Mods(3),' = ',num2str(theta(3)),'^{o}'),'FontSize',fs);

L(4) = plot([(4-1)*dr*R*cosd(theta(4)),i*dr*R*cosd(theta(4))],[(4-1)*dr*R*sind(theta(4)),i*dr*R*sind(theta(4))],Colors(4),'DisplayName',Mods(4),'LineWidth',lw);
TH(4) = text(points(4),7.5,strcat(Mods(4),' = ',num2str(theta(4)),'^{o}'),'FontSize',fs);


% suptitle(strcat('Turntable testing sensorID:   ',WISESENSORID, '   ',AX,' axis'));
hold off

if ~isempty(k)
   if strcmp(k,'q') 
   k=[];
%    fclose(fwrite);
   break; 
   end
end      
pause(0.05)
end

%%

theta = zeros(1,Nm);
f1 = sprintf('%s_WISE+turntable_%s.txt',num2str(ANGLE),datestr(now,'mm-dd-yyyy HH-MM'));
fwrite = fopen(f1,'wt');
time = 0;
while time<=ttotal
tic;
[q] = ModsReceive(ser,WISEmod,q);

theta(1) = Simple_JCS(AX,q(1,:),q(2,:));
theta(2) = Simple_JCS(AX,q(1,:),q(3,:));
theta(3) = Simple_JCS(AX,q(1,:),q(4,:));
theta(4) = Simple_JCS(AX,q(1,:),q(5,:));

    

[~,I(1,1),I(1,2),I(1,3)] = parts(quaternion(quatmultiply(q(1,:),quatmultiply(qI,quatconj(q(1,:))))));
[~,J(1,1),J(1,2),J(1,3)] = parts(quaternion(quatmultiply(q(1,:),quatmultiply(qJ,quatconj(q(1,:))))));
[~,K(1,1),K(1,2),K(1,3)] = parts(quaternion(quatmultiply(q(1,:),quatmultiply(qK,quatconj(q(1,:))))));

[~,I(2,1),I(2,2),I(2,3)] = parts(quaternion(quatmultiply(q(2,:),quatmultiply(qI,quatconj(q(2,:))))));
[~,J(2,1),J(2,2),J(2,3)] = parts(quaternion(quatmultiply(q(2,:),quatmultiply(qJ,quatconj(q(2,:))))));
[~,K(2,1),K(2,2),K(2,3)] = parts(quaternion(quatmultiply(q(2,:),quatmultiply(qK,quatconj(q(2,:))))));

[~,I(3,1),I(3,2),I(3,3)] = parts(quaternion(quatmultiply(q(3,:),quatmultiply(qI,quatconj(q(3,:))))));
[~,J(3,1),J(3,2),J(3,3)] = parts(quaternion(quatmultiply(q(3,:),quatmultiply(qJ,quatconj(q(3,:))))));
[~,K(3,1),K(3,2),K(3,3)] = parts(quaternion(quatmultiply(q(3,:),quatmultiply(qK,quatconj(q(3,:))))));

[~,I(4,1),I(4,2),I(4,3)] = parts(quaternion(quatmultiply(q(4,:),quatmultiply(qI,quatconj(q(4,:))))));
[~,J(4,1),J(4,2),J(4,3)] = parts(quaternion(quatmultiply(q(4,:),quatmultiply(qJ,quatconj(q(4,:))))));
[~,K(4,1),K(4,2),K(4,3)] = parts(quaternion(quatmultiply(q(4,:),quatmultiply(qK,quatconj(q(4,:))))));

[~,I(5,1),I(5,2),I(5,3)] = parts(quaternion(quatmultiply(q(5,:),quatmultiply(qI,quatconj(q(5,:))))));
[~,J(5,1),J(5,2),J(5,3)] = parts(quaternion(quatmultiply(q(5,:),quatmultiply(qJ,quatconj(q(5,:))))));
[~,K(5,1),K(5,2),K(5,3)] = parts(quaternion(quatmultiply(q(5,:),quatmultiply(qK,quatconj(q(5,:))))));

delete([F(1,:),F(2,:),F(3,:),T(1,:),T(2,:),T(3,:),T(4,:)])
delete([L(1),L(2),L(3),L(4),TH(1),TH(2),TH(3),TH(4)])

figure(1)
hold on

subplot(2,1,1)
hold on

F(1,1) = plot3([(1-1)*sp,(1-1)*sp+I(1,1)],[0,I(1,2)],[0,I(1,3)],'r','LineWidth',lw);  
F(2,1) = plot3([(1-1)*sp,(1-1)*sp+J(1,1)],[0,J(1,2)],[0,J(1,3)],'g','LineWidth',lw);
F(3,1) = plot3([(1-1)*sp,(1-1)*sp+K(1,1)],[0,K(1,2)],[0,K(1,3)],'b','LineWidth',lw);
T(1,1) = text((1-1)*sp,0,-0.1,AllMods(1),'FontSize',fs);
T(2,1) = text((1-1)*sp+I(1,1),I(1,2),I(1,3),'X','FontSize',fs);
T(3,1) = text((1-1)*sp+J(1,1),J(1,2),J(1,3),'Y','FontSize',fs);
T(4,1) = text((1-1)*sp+K(1,1),K(1,2),K(1,3),'Z','FontSize',fs);

F(1,2) = plot3([(2-1)*sp,(2-1)*sp+I(2,1)],[0,I(2,2)],[0,I(2,3)],'r','LineWidth',lw);  
F(2,2) = plot3([(2-1)*sp,(2-1)*sp+J(2,1)],[0,J(2,2)],[0,J(2,3)],'g','LineWidth',lw);
F(3,2) = plot3([(2-1)*sp,(2-1)*sp+K(2,1)],[0,K(2,2)],[0,K(2,3)],'b','LineWidth',lw);
T(1,2) = text((2-1)*sp,0,-0.1,AllMods(2),'FontSize',fs);
T(2,2) = text((2-1)*sp+I(2,1),I(2,2),I(2,3),'X','FontSize',fs);
T(3,2) = text((2-1)*sp+J(2,1),J(2,2),J(2,3),'Y','FontSize',fs);
T(4,2) = text((2-1)*sp+K(2,1),K(2,2),K(2,3),'Z','FontSize',fs);

F(1,3) = plot3([(3-1)*sp,(3-1)*sp+I(3,1)],[0,I(3,2)],[0,I(3,3)],'r','LineWidth',lw);  
F(2,3) = plot3([(3-1)*sp,(3-1)*sp+J(3,1)],[0,J(3,2)],[0,J(3,3)],'g','LineWidth',lw);
F(3,3) = plot3([(3-1)*sp,(3-1)*sp+K(3,1)],[0,K(3,2)],[0,K(3,3)],'b','LineWidth',lw);
T(1,3) = text((3-1)*sp,0,-0.1,AllMods(3),'FontSize',fs);
T(2,3) = text((3-1)*sp+I(3,1),I(3,2),I(3,3),'X','FontSize',fs);
T(3,3) = text((3-1)*sp+J(3,1),J(3,2),J(3,3),'Y','FontSize',fs);
T(4,3) = text((3-1)*sp+K(3,1),K(3,2),K(3,3),'Z','FontSize',fs);

F(1,4) = plot3([(4-1)*sp,(4-1)*sp+I(4,1)],[0,I(4,2)],[0,I(4,3)],'r','LineWidth',lw);  
F(2,4) = plot3([(4-1)*sp,(4-1)*sp+J(4,1)],[0,J(4,2)],[0,J(4,3)],'g','LineWidth',lw);
F(3,4) = plot3([(4-1)*sp,(4-1)*sp+K(4,1)],[0,K(4,2)],[0,K(4,3)],'b','LineWidth',lw);
T(1,4) = text((4-1)*sp,0,-0.1,AllMods(4),'FontSize',fs);
T(2,4) = text((4-1)*sp+I(4,1),I(4,2),I(4,3),'X','FontSize',fs);
T(3,4) = text((4-1)*sp+J(4,1),J(4,2),J(4,3),'Y','FontSize',fs);
T(4,4) = text((4-1)*sp+K(4,1),K(4,2),K(4,3),'Z','FontSize',fs);

F(1,5) = plot3([(5-1)*sp,(5-1)*sp+I(5,1)],[0,I(5,2)],[0,I(5,3)],'r','LineWidth',lw);  
F(2,5) = plot3([(5-1)*sp,(5-1)*sp+J(5,1)],[0,J(5,2)],[0,J(5,3)],'g','LineWidth',lw);
F(3,5) = plot3([(5-1)*sp,(5-1)*sp+K(5,1)],[0,K(5,2)],[0,K(5,3)],'b','LineWidth',lw);
T(1,5) = text((5-1)*sp,0,-0.1,AllMods(5),'FontSize',fs);
T(2,5) = text((5-1)*sp+I(5,1),I(5,2),I(5,3),'X','FontSize',fs);
T(3,5) = text((5-1)*sp+J(5,1),J(5,2),J(5,3),'Y','FontSize',fs);
T(4,5) = text((5-1)*sp+K(5,1),K(5,2),K(5,3),'Z','FontSize',fs);


subplot(2,1,2)
hold on

L(1) = plot([(1-1)*dr*R*cosd(theta(1)),1*dr*R*cosd(theta(1))],[(1-1)*dr*R*sind(theta(1)),1*dr*R*sind(theta(1))],Colors(1),'DisplayName',Mods(1),'LineWidth',lw);
TH(1) = text(points(1),7.5,strcat(Mods(1),' = ',num2str(theta(1)),'^{o}'),'FontSize',fs);

L(2) = plot([(2-1)*dr*R*cosd(theta(2)),2*dr*R*cosd(theta(2))],[(2-1)*dr*R*sind(theta(2)),2*dr*R*sind(theta(2))],Colors(2),'DisplayName',Mods(2),'LineWidth',lw);
TH(2) = text(points(2),7.5,strcat(Mods(2),' = ',num2str(theta(2)),'^{o}'),'FontSize',fs);

L(3) = plot([(3-1)*dr*R*cosd(theta(3)),3*dr*R*cosd(theta(3))],[(3-1)*dr*R*sind(theta(3)),3*dr*R*sind(theta(3))],Colors(3),'DisplayName',Mods(3),'LineWidth',lw);
TH(3) = text(points(3),7.5,strcat(Mods(3),' = ',num2str(theta(3)),'^{o}'),'FontSize',fs);

L(4) = plot([(4-1)*dr*R*cosd(theta(4)),4*dr*R*cosd(theta(4))],[(4-1)*dr*R*sind(theta(4)),4*dr*R*sind(theta(4))],Colors(4),'DisplayName',Mods(4),'LineWidth',lw);
TH(4) = text(points(4),7.5,strcat(Mods(4),' = ',num2str(theta(4)),'^{o}'),'FontSize',fs);

percF = "%f,%f,%f,%f,%f";
for i = 1:Nm
    percF = strcat('%f,%f,%f,%f,%f,',percF);
end
percF = strcat(percF,',','\n');
qL = zeros(1,4*(Nm+1));
for i = 1:Nm+1
    qL((i-1)*4+1:(i)*4) = q(i,:);
end

fprintf(fwrite,percF,time,qL,theta);
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