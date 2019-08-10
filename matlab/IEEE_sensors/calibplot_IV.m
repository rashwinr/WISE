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
ttotal = 1*40;
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


% prompt = 'Please enter the angle in degrees used for the experiment (0-180): ';
% ANGLE = input(prompt,'s');

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

subplot(2,1,1)
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
lgnd = legend(SubP2,L,'Location','none','FontSize',fs);
set(lgnd, 'Position', [0.6524 0.2185 0.0410 0.1185])
hold off

%%
theta = zeros(1,Nm);
while true
tic;
[q] = ModsReceive(ser,WISEmod,q);

for i = 1:Nm
theta(i) = Simple_JCS(AX,q(1,:),q(i+1,:));
end
    
for i = 1:Nm+1
[~,I(i,1),I(i,2),I(i,3)] = parts(quaternion(quatmultiply(q(i,:),quatmultiply(qI,quatconj(q(i,:))))));
[~,J(i,1),J(i,2),J(i,3)] = parts(quaternion(quatmultiply(q(i,:),quatmultiply(qJ,quatconj(q(i,:))))));
[~,K(i,1),K(i,2),K(i,3)] = parts(quaternion(quatmultiply(q(i,:),quatmultiply(qK,quatconj(q(i,:))))));
end

figure(1)
hold on

subplot(2,1,1)
hold on
delete(F)
delete(T)
for i = 1:Nm+1
F(1,i) = plot3([(i-1)*sp,(i-1)*sp+I(i,1)],[0,I(i,2)],[0,I(i,3)],'r','LineWidth',lw);  
F(2,i) = plot3([(i-1)*sp,(i-1)*sp+J(i,1)],[0,J(i,2)],[0,J(i,3)],'g','LineWidth',lw);
F(3,i) = plot3([(i-1)*sp,(i-1)*sp+K(i,1)],[0,K(i,2)],[0,K(i,3)],'b','LineWidth',lw);
T(1,i) = text((i-1)*sp,0,-0.1,AllMods(i),'FontSize',fs);
T(2,i) = text((i-1)*sp+I(i,1),I(i,2),I(i,3),'X','FontSize',fs);
T(3,i) = text((i-1)*sp+J(i,1),J(i,2),J(i,3),'Y','FontSize',fs);
T(4,i) = text((i-1)*sp+K(i,1),K(i,2),K(i,3),'Z','FontSize',fs);
end

hold off

subplot(2,1,2)
hold on
delete([L,TH])

for i = 1:Nm
    L(i) = plot([(i-1)*dr*R*cosd(theta(i)),i*dr*R*cosd(theta(i))],[(i-1)*dr*R*sind(theta(i)),i*dr*R*sind(theta(i))],Colors(i),'DisplayName',Mods(i),'LineWidth',lw);
    TH(i) = text(points(i),7.5,strcat(Mods(i),' = ',num2str(theta(i)),'^{o}'),'FontSize',fs);
end

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
prompt = 'Please enter the angle in degrees used for the experiment (0-180): ';
ANGLE = input(prompt,'s');
theta = zeros(1,Nm);
f1 = sprintf('%s_WISE+turntable_%s.txt',num2str(ANGLE),datestr(now,'mm-dd-yyyy HH-MM'));
fwrite = fopen(f1,'wt');
time = 0;
while time<=ttotal
tic;
[q] = ModsReceive(ser,WISEmod,q);

for i = 1:Nm
theta(i) = Simple_JCS(AX,q(1,:),q(i+1,:));
end
    
for i = 1:Nm+1
[~,I(i,1),I(i,2),I(i,3)] = parts(quaternion(quatmultiply(q(i,:),quatmultiply(qI,quatconj(q(i,:))))));
[~,J(i,1),J(i,2),J(i,3)] = parts(quaternion(quatmultiply(q(i,:),quatmultiply(qJ,quatconj(q(i,:))))));
[~,K(i,1),K(i,2),K(i,3)] = parts(quaternion(quatmultiply(q(i,:),quatmultiply(qK,quatconj(q(i,:))))));
end

figure(1)
hold on

subplot(2,1,1)
hold on
delete(F)
delete(T)
for i = 1:Nm+1
F(1,i) = plot3([(i-1)*sp,(i-1)*sp+I(i,1)],[0,I(i,2)],[0,I(i,3)],'r','LineWidth',lw);  
F(2,i) = plot3([(i-1)*sp,(i-1)*sp+J(i,1)],[0,J(i,2)],[0,J(i,3)],'g','LineWidth',lw);
F(3,i) = plot3([(i-1)*sp,(i-1)*sp+K(i,1)],[0,K(i,2)],[0,K(i,3)],'b','LineWidth',lw);
T(1,i) = text((i-1)*sp,0,-0.1,AllMods(i),'FontSize',fs);
T(2,i) = text((i-1)*sp+I(i,1),I(i,2),I(i,3),'X','FontSize',fs);
T(3,i) = text((i-1)*sp+J(i,1),J(i,2),J(i,3),'Y','FontSize',fs);
T(4,i) = text((i-1)*sp+K(i,1),K(i,2),K(i,3),'Z','FontSize',fs);
end

hold off

subplot(2,1,2)
hold on
delete([L,TH])

for i = 1:Nm
    L(i) = plot([(i-1)*dr*R*cosd(theta(i)),i*dr*R*cosd(theta(i))],[(i-1)*dr*R*sind(theta(i)),i*dr*R*sind(theta(i))],Colors(i),'DisplayName',Mods(i),'LineWidth',lw);
    TH(i) = text(points(i),7.5,strcat(Mods(i),' = ',num2str(theta(i)),'^{o}'),'FontSize',fs);
end

% suptitle(strcat('Turntable testing sensorID:   ',WISESENSORID, '   ',AX,' axis'));
hold off
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