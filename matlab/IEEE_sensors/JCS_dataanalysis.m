clc;clear all;close all
addpath('F:\github\wearable-jacket\matlab\IEEE_sensors\');
cd(strcat('F:\github\wearable-jacket\matlab\IEEE_sensors\JCS_data\Male\'));
list = dir();

Data = importJCS('Male_WISE+JCS_08-10-2019 19-21.txt');

%% Abduction Adduction
Row = Data(:,10)>=200;
Data(Row,:) =[]; 
Lstart = find(round(Data(:,1))<=27);
Lstart = max(Lstart);
Lend = find(Data(:,1)<=44);
Lend = max(Lend);
Rstart = find(Data(:,1)<=8);
Rstart = max(Rstart);
Rend = find(Data(:,1)<=23);
Rend = max(Rend);
% Lstart = 1;
% Lend = length(Data);
% Rstart = 1;
% Rend = length(Data);
LData = Data(Lstart:Lend,2:7);
LTime = Data(1:length(LData),1);
RData = Data(Rstart:Rend,8:end);
RTime = Data(1:length(RData),1);
LW = 2;

figure(1)
hold on
Tl = sgtitle('Left arm abduction-adduction');

subplot(3,2,1)
hold on
title('Shoulder plane & elevation')
xlim([LTime(1),LTime(end)])
plot(LTime,LData(:,1),'Color','r','LineWidth',LW,'DisplayName','Shoulder plane');
plot(LTime,LData(:,2),'Color','g','LineWidth',LW,'DisplayName','Shoulder elevation');
xlabel('Time [s]')
ylabel('Angle [deg^o]')

subplot(3,2,3)
hold on
title('Shoulder elevation')
xlim([LTime(1),LTime(end)])
plot(LTime,LData(:,2),'Color','g','LineWidth',LW,'DisplayName','Shoulder elevation');
xlabel('Time [s]')
ylabel('Angle [deg^o]')

subplot(3,2,5)
hold on
title('Shoulder Int.-ext. rot. & elevation')
xlim([LTime(1),LTime(end)])
plot(LTime,LData(:,3),'Color',[1 0 1],'LineWidth',LW,'DisplayName','Shoulder int-ext rotation');
plot(LTime,LData(:,2),'Color','g','LineWidth',LW,'DisplayName','Shoulder elevation');
xlabel('Time [s]')
ylabel('Angle [deg^o]')

subplot(3,2,2)
hold on
title('Elbow Flex.-Ext.');
xlim([LTime(1),LTime(end)])
plot(LTime,LData(:,4));
xlabel('Time [s]')
ylabel('Angle [deg^o]')


subplot(3,2,4)
hold on
title('Carrying angle')
xlim([LTime(1),LTime(end)])
plot(LTime,LData(:,5));
xlabel('Time [s]')
ylabel('Angle [deg^o]')


subplot(3,2,6)
hold on
title('Forearm Pro.-sup. & Shoulder elevation');
xlim([LTime(1),LTime(end)])
plot(LTime,LData(:,6),'Color','b','LineWidth',LW,'DisplayName','Forearm pro-sup');
plot(LTime,LData(:,2),'Color','g','LineWidth',LW,'DisplayName','Shoulder elevation');
xlabel('Time [s]')
ylabel('Angle [deg^o]')


figure(2)
hold on
Tr = sgtitle('Right arm abduction-adduction');

subplot(3,2,1)
hold on
title('Shoulder plane & elevation')
xlim([RTime(1),RTime(end)])
plot(RTime,RData(:,1),'Color','r','LineWidth',LW,'DisplayName','Shoulder plane');
plot(RTime,RData(:,2),'Color','g','LineWidth',LW,'DisplayName','Shoulder elevation');
xlabel('Time [s]')
ylabel('Angle [deg^o]')
 
subplot(3,2,3)
hold on
title('Shoulder elevation')
xlim([RTime(1),RTime(end)])
plot(RTime,RData(:,2),'Color','g','LineWidth',LW,'DisplayName','Shoulder plane');
xlabel('Time [s]')
ylabel('Angle [deg^o]')

subplot(3,2,5)
hold on
title('Shoulder Int.-ext. rot. & elevation')
xlim([RTime(1),RTime(end)])
plot(RTime,RData(:,3),'Color',[1 0 1],'LineWidth',LW,'DisplayName','Shoulder int-ext rotation');
plot(RTime,RData(:,2),'Color','g','LineWidth',LW,'DisplayName','Shoulder elevation');
xlabel('Time [s]')
ylabel('Angle [deg^o]')

subplot(3,2,2)
hold on
title('Elbow Flex.-Ext.');
xlim([RTime(1),RTime(end)])
plot(RTime,RData(:,4));
xlabel('Time [s]')
ylabel('Angle [deg^o]')
 
subplot(3,2,4)
hold on
title('Carrying angle')
xlim([RTime(1),RTime(end)])
plot(RTime,RData(:,5));
xlabel('Time [s]')
ylabel('Angle [deg^o]')
 
subplot(3,2,6)
hold on
title('Forearm Pro.-sup. and elevation');
xlim([RTime(1),RTime(end)])
plot(RTime,RData(:,6),'Color','b','LineWidth',LW,'DisplayName','Forearm pro-sup');
plot(RTime,RData(:,2),'Color','g','LineWidth',LW,'DisplayName','Shoulder elevation');
xlabel('Time [s]')
ylabel('Angle [deg^o]')

%% Extension Flexion
Row = Data(:,8)<=-100;
Data(Row,:) =[]; 
clearvars Row
Row = Data(:,10)>=200;
Data(Row,:) =[]; 

Lstart = find(round(Data(:,1))<=10);
Lstart = max(Lstart);
Lend = find(Data(:,1)<=30);
Lend = max(Lend);
Rstart = find(Data(:,1)<=Data(1,1));
Rstart = max(Rstart);
Rend = find(Data(:,1)<=12);
Rend = max(Rend);
% Lstart = 1;
% Lend = length(Data);
% Rstart = 1;
% Rend = length(Data);
LData = Data(Lstart:Lend,2:7);
LTime = Data(1:length(LData),1);
RData = Data(Rstart:Rend,8:end);
RTime = Data(1:length(RData),1);
LW = 2;

figure(1)
hold on
Tl = sgtitle('Left arm extension-flexion');

subplot(3,2,1)
hold on
title('Shoulder plane & elevation')
xlim([LTime(1),LTime(end)])
plot(LTime,LData(:,1),'Color','r','LineWidth',LW,'DisplayName','Shoulder plane');
plot(LTime,LData(:,2),'Color','g','LineWidth',LW,'DisplayName','Shoulder elevation');
xlabel('Time [s]')
ylabel('Angle [deg^o]')

subplot(3,2,3)
hold on
title('Shoulder elevation')
xlim([LTime(1),LTime(end)])
plot(LTime,LData(:,2),'Color','g','LineWidth',LW,'DisplayName','Shoulder elevation');
xlabel('Time [s]')
ylabel('Angle [deg^o]')

subplot(3,2,5)
hold on
title('Shoulder Int.-ext. rot. & elevation')
xlim([LTime(1),LTime(end)])
plot(LTime,LData(:,3),'Color',[1 0 1],'LineWidth',LW,'DisplayName','Shoulder int-ext rotation');
plot(LTime,LData(:,2),'Color','g','LineWidth',LW,'DisplayName','Shoulder elevation');
xlabel('Time [s]')
ylabel('Angle [deg^o]')

subplot(3,2,2)
hold on
title('Elbow Flex.-Ext.');
xlim([LTime(1),LTime(end)])
plot(LTime,LData(:,4));
xlabel('Time [s]')
ylabel('Angle [deg^o]')


subplot(3,2,4)
hold on
title('Carrying angle')
xlim([LTime(1),LTime(end)])
plot(LTime,LData(:,5));
xlabel('Time [s]')
ylabel('Angle [deg^o]')


subplot(3,2,6)
hold on
title('Forearm Pro.-sup. & Shoulder elevation');
xlim([LTime(1),LTime(end)])
plot(LTime,LData(:,6),'Color','b','LineWidth',LW,'DisplayName','Forearm pro-sup');
plot(LTime,LData(:,2),'Color','g','LineWidth',LW,'DisplayName','Shoulder elevation');
xlabel('Time [s]')
ylabel('Angle [deg^o]')


figure(2)
hold on
Tr = sgtitle('Right arm extension-flexion');

subplot(3,2,1)
hold on
title('Shoulder plane & elevation')
xlim([RTime(1),RTime(end)])
plot(RTime,RData(:,1),'Color','r','LineWidth',LW,'DisplayName','Shoulder plane');
plot(RTime,RData(:,2),'Color','g','LineWidth',LW,'DisplayName','Shoulder elevation');
xlabel('Time [s]')
ylabel('Angle [deg^o]')
 
subplot(3,2,3)
hold on
title('Shoulder elevation')
xlim([RTime(1),RTime(end)])
plot(RTime,RData(:,2),'Color','g','LineWidth',LW,'DisplayName','Shoulder plane');
xlabel('Time [s]')
ylabel('Angle [deg^o]')

subplot(3,2,5)
hold on
title('Shoulder Int.-ext. rot. & elevation')
xlim([RTime(1),RTime(end)])
plot(RTime,RData(:,3),'Color',[1 0 1],'LineWidth',LW,'DisplayName','Shoulder int-ext rotation');
plot(RTime,RData(:,2),'Color','g','LineWidth',LW,'DisplayName','Shoulder elevation');
xlabel('Time [s]')
ylabel('Angle [deg^o]')

subplot(3,2,2)
hold on
title('Elbow Flex.-Ext.');
xlim([RTime(1),RTime(end)])
plot(RTime,RData(:,4));
xlabel('Time [s]')
ylabel('Angle [deg^o]')
 
subplot(3,2,4)
hold on
title('Carrying angle')
xlim([RTime(1),RTime(end)])
plot(RTime,RData(:,5));
xlabel('Time [s]')
ylabel('Angle [deg^o]')
 
subplot(3,2,6)
hold on
title('Forearm Pro.-sup.');
xlim([RTime(1),RTime(end)])
plot(RTime,RData(:,6),'Color','b','LineWidth',LW,'DisplayName','Forearm pro-sup');
plot(RTime,RData(:,2),'Color','g','LineWidth',LW,'DisplayName','Shoulder elevation');
xlabel('Time [s]')
ylabel('Angle [deg^o]')


%% Shoulder internal external rotation

Row = Data(:,10)>=200;
Data(Row,:) =[]; 
Lstart = find(round(Data(:,1))<=20);
Lstart = max(Lstart);
Lend = find(Data(:,1)<=35);
Lend = max(Lend);
Rstart = find(Data(:,1)<=4);
Rstart = max(Rstart);
Rend = find(Data(:,1)<=17);
Rend = max(Rend);
% Lstart = 1;
% Lend = length(Data);
% Rstart = 1;
% Rend = length(Data);
LData = Data(Lstart:Lend,2:7);
LTime = Data(1:length(LData),1);
RData = Data(Rstart:Rend,8:end);
RTime = Data(1:length(RData),1);
LW = 2;

figure(1)
hold on
Tl = sgtitle('Left shoulder internal-external rotation');

subplot(3,2,1)
hold on
title('Shoulder plane')
xlim([LTime(1),LTime(end)])
plot(LTime,LData(:,1),'Color','r','LineWidth',LW,'DisplayName','Shoulder plane');
xlabel('Time [s]')
ylabel('Angle [deg^o]')

subplot(3,2,3)
hold on
title('Shoulder elevation')
xlim([LTime(1),LTime(end)])
plot(LTime,LData(:,2),'Color','g','LineWidth',LW,'DisplayName','Shoulder elevation');
xlabel('Time [s]')
ylabel('Angle [deg^o]')

subplot(3,2,5)
hold on
title('Shoulder Int.-ext. rot.')
xlim([LTime(1),LTime(end)])
plot(LTime,LData(:,3),'Color',[1 0 1],'LineWidth',LW,'DisplayName','Shoulder int-ext rotation');
xlabel('Time [s]')
ylabel('Angle [deg^o]')

subplot(3,2,2)
hold on
title('Elbow Flex.-Ext.');
xlim([LTime(1),LTime(end)])
plot(LTime,LData(:,4),'Color','r','LineWidth',LW,'DisplayName','Elbow Flex.-Ext.');
xlabel('Time [s]')
ylabel('Angle [deg^o]')


subplot(3,2,4)
hold on
title('Carrying angle')
xlim([LTime(1),LTime(end)])
plot(LTime,LData(:,5),'Color','g','LineWidth',LW,'DisplayName','Carrying angle');
xlabel('Time [s]')
ylabel('Angle [deg^o]')


subplot(3,2,6)
hold on
title('Forearm Pro.-sup.');
xlim([LTime(1),LTime(end)])
plot(LTime,LData(:,6),'Color','b','LineWidth',LW,'DisplayName','Forearm pro-sup');
xlabel('Time [s]')
ylabel('Angle [deg^o]')


figure(2)
hold on
Tr = sgtitle('Right shoulder internal-external rotation');

subplot(3,2,1)
hold on
title('Shoulder plane')
xlim([RTime(1),RTime(end)])
plot(RTime,RData(:,1),'Color','r','LineWidth',LW,'DisplayName','Shoulder plane');
xlabel('Time [s]')
ylabel('Angle [deg^o]')
 
subplot(3,2,3)
hold on
title('Shoulder elevation')
xlim([RTime(1),RTime(end)])
plot(RTime,RData(:,2),'Color','g','LineWidth',LW,'DisplayName','Shoulder plane');
xlabel('Time [s]')
ylabel('Angle [deg^o]')

subplot(3,2,5)
hold on
title('Shoulder Int.-ext. rot.')
xlim([RTime(1),RTime(end)])
plot(RTime,RData(:,3),'Color',[1 0 1],'LineWidth',LW,'DisplayName','Shoulder int-ext rotation');
xlabel('Time [s]')
ylabel('Angle [deg^o]')

subplot(3,2,2)
hold on
title('Elbow Flex.-Ext.');
xlim([RTime(1),RTime(end)])
plot(RTime,RData(:,4),'Color','r','LineWidth',LW,'DisplayName','Elbow Flex.-Ext.');
xlabel('Time [s]')
ylabel('Angle [deg^o]')
 
subplot(3,2,4)
hold on
title('Carrying angle')
xlim([RTime(1),RTime(end)])
plot(RTime,RData(:,5),'g','LineWidth',LW,'DisplayName','Carrying angle');
xlabel('Time [s]')
ylabel('Angle [deg^o]')
 
subplot(3,2,6)
hold on
title('Forearm Pro.-sup.');
xlim([RTime(1),RTime(end)])
plot(RTime,RData(:,6),'Color','b','LineWidth',LW,'DisplayName','Forearm pro-sup');
xlabel('Time [s]')
ylabel('Angle [deg^o]')

%% Forearm pronation-supination

Row = Data(:,10)>=200;
Data(Row,:) =[]; 
Lstart = find(round(Data(:,1))<=12);
Lstart = max(Lstart);
Lend = find(Data(:,1)<=25);
Lend = max(Lend);
Rstart = find(Data(:,1)<=1);
Rstart = max(Rstart);
Rend = find(Data(:,1)<=15);
Rend = max(Rend);
% Lstart = 1;
% Lend = length(Data);
% Rstart = 1;
% Rend = length(Data);
LData = Data(Lstart:Lend,2:7);
LTime = Data(1:length(LData),1);
RData = Data(Rstart:Rend,8:end);
RTime = Data(1:length(RData),1);
LW = 2;

figure(1)
hold on
Tl = sgtitle('Left elbow movements');

subplot(3,2,1)
hold on
title('Shoulder plane')
xlim([LTime(1),LTime(end)])
plot(LTime,LData(:,1),'Color','r','LineWidth',LW,'DisplayName','Shoulder plane');
xlabel('Time [s]')
ylabel('Angle [deg^o]')

subplot(3,2,3)
hold on
title('Shoulder elevation')
xlim([LTime(1),LTime(end)])
plot(LTime,LData(:,2),'Color','g','LineWidth',LW,'DisplayName','Shoulder elevation');
xlabel('Time [s]')
ylabel('Angle [deg^o]')

subplot(3,2,5)
hold on
title('Shoulder Int.-ext. rot.')
xlim([LTime(1),LTime(end)])
plot(LTime,LData(:,3),'Color',[1 0 1],'LineWidth',LW,'DisplayName','Shoulder int-ext rotation');
xlabel('Time [s]')
ylabel('Angle [deg^o]')

subplot(3,2,2)
hold on
title('Elbow Flex.-Ext.');
xlim([LTime(1),LTime(end)])
plot(LTime,LData(:,4),'Color','r','LineWidth',LW,'DisplayName','Elbow Flex.-Ext.');
xlabel('Time [s]')
ylabel('Angle [deg^o]')


subplot(3,2,4)
hold on
title('Carrying angle')
xlim([LTime(1),LTime(end)])
plot(LTime,LData(:,5),'Color','g','LineWidth',LW,'DisplayName','Carrying angle');
xlabel('Time [s]')
ylabel('Angle [deg^o]')


subplot(3,2,6)
hold on
title('Forearm Pro.-sup.');
xlim([LTime(1),LTime(end)])
plot(LTime,LData(:,6),'Color','b','LineWidth',LW,'DisplayName','Forearm pro-sup');
xlabel('Time [s]')
ylabel('Angle [deg^o]')


figure(2)
hold on
Tr = sgtitle('Right elbow movements');

subplot(3,2,1)
hold on
title('Shoulder plane')
xlim([RTime(1),RTime(end)])
plot(RTime,RData(:,1),'Color','r','LineWidth',LW,'DisplayName','Shoulder plane');
xlabel('Time [s]')
ylabel('Angle [deg^o]')
 
subplot(3,2,3)
hold on
title('Shoulder elevation')
xlim([RTime(1),RTime(end)])
plot(RTime,RData(:,2),'Color','g','LineWidth',LW,'DisplayName','Shoulder plane');
xlabel('Time [s]')
ylabel('Angle [deg^o]')

subplot(3,2,5)
hold on
title('Shoulder Int.-ext. rot.')
xlim([RTime(1),RTime(end)])
plot(RTime,RData(:,3),'Color',[1 0 1],'LineWidth',LW,'DisplayName','Shoulder int-ext rotation');
xlabel('Time [s]')
ylabel('Angle [deg^o]')

subplot(3,2,2)
hold on
title('Elbow Flex.-Ext.');
xlim([RTime(1),RTime(end)])
plot(RTime,RData(:,4),'Color','r','LineWidth',LW,'DisplayName','Elbow Flex.-Ext.');
xlabel('Time [s]')
ylabel('Angle [deg^o]')
 
subplot(3,2,4)
hold on
title('Carrying angle')
xlim([RTime(1),RTime(end)])
plot(RTime,RData(:,5),'g','LineWidth',LW,'DisplayName','Carrying angle');
xlabel('Time [s]')
ylabel('Angle [deg^o]')
 
subplot(3,2,6)
hold on
title('Forearm Pro.-sup.');
xlim([RTime(1),RTime(end)])
plot(RTime,RData(:,6),'Color','b','LineWidth',LW,'DisplayName','Forearm pro-sup');
xlabel('Time [s]')
ylabel('Angle [deg^o]')

%% Both data

Row = Data(:,4)>=200;
Data(Row,:) =[]; 
clearvars Row
Row = Data(:,4)<=-200;
Data(Row,:) =[]; 
clearvars Row
Row = Data(:,10)<=-200;
Data(Row,:) =[]; 
clearvars Row
Row = Data(:,2)>=150;
Data(Row,:) =[]; 
clearvars Row
Row = Data(:,8)>=150;
Data(Row,:) =[]; 
clearvars Row
Row = Data(:,8)<=-150;
Data(Row,:) =[]; 
clearvars Row
Row = Data(:,2)<=-150;
Data(Row,:) =[]; 
clearvars Row
Row = Data(:,10)>=200;
Data(Row,:) =[];
clearvars Row

Lstart = find(round(Data(:,1))<=11);
Lstart = max(Lstart);
Lend = find(Data(:,1)<=58);
Lend = max(Lend);
Rstart = find(Data(:,1)<=11);
Rstart = max(Rstart);
Rend = find(Data(:,1)<=58);
Rend = max(Rend);
Rstart = Lstart;
Rend = Lend;
LData = Data(Lstart:Lend,2:7);
LTime = Data(1:length(LData),1);
RData = Data(Rstart:Rend,8:end);
RTime = Data(1:length(RData),1);
LW = 2;

figure(1)
hold on
Tl = sgtitle('Bimanual arm movements');

subplot(3,1,1)
hold on
title(strcat('Shoulder plane, RMSE = ',num2str(signal_RMSE(LData(:,1),RData(:,1)))))
L = plot(LTime,LData(:,1),'Color','r','LineWidth',LW,'DisplayName','Left angles');
R = plot(RTime,RData(:,1),'Color','b','LineWidth',LW,'DisplayName','Right angles');
xlabel('Time [s]')
ylabel('Angle [deg^o]')

subplot(3,1,2)
hold on
title(strcat('Shoulder elevation, RMSE = ',num2str(signal_RMSE(LData(:,2),RData(:,2)))))
plot(LTime,LData(:,2),'Color','r','LineWidth',LW,'DisplayName','Shoulder elevation');
plot(RTime,RData(:,2),'Color','b','LineWidth',LW,'DisplayName','Shoulder plane');
xlabel('Time [s]')
ylabel('Angle [deg^o]')

subplot(3,1,3)
hold on
title(strcat('Shoulder Int.-ext. rot., RMSE = ',num2str(signal_RMSE(LData(:,3),RData(:,3)))))
plot(LTime,LData(:,3),'Color','r','LineWidth',LW,'DisplayName','Shoulder int-ext rotation');
plot(RTime,RData(:,3),'Color','b','LineWidth',LW,'DisplayName','Shoulder int-ext rotation');
xlabel('Time [s]')
ylabel('Angle [deg^o]')

lgd = legend([L,R],'FontSize',15)


figure(2)
hold on

Tl = sgtitle('Bimanual elbow movements');

subplot(3,1,1)
hold on
title(strcat('Elbow Flex.-Ext., RMSE = ',num2str(signal_RMSE(LData(:,4),RData(:,4)))))
L = plot(LTime,LData(:,4),'Color','r','LineWidth',LW,'DisplayName','Elbow Flex.-Ext.','DisplayName','Left angles');
R = plot(RTime,RData(:,4),'Color','b','LineWidth',LW,'DisplayName','Elbow Flex.-Ext.','DisplayName','Right angles');
xlabel('Time [s]')
ylabel('Angle [deg^o]')

subplot(3,1,2)
hold on
title(strcat('Carrying angle, RMSE = ',num2str(signal_RMSE(LData(:,5),RData(:,5)))))
plot(LTime,LData(:,5),'Color','r','LineWidth',LW,'DisplayName','Carrying angle');
plot(RTime,RData(:,5),'b','LineWidth',LW,'DisplayName','Carrying angle');
xlabel('Time [s]')
ylabel('Angle [deg^o]')

subplot(3,1,3)
hold on
title(strcat('Forearm Pro.-sup., RMSE = ',num2str(signal_RMSE(LData(:,6),RData(:,6)))))
plot(LTime,LData(:,6),'Color','r','LineWidth',LW,'DisplayName','Forearm pro-sup');
plot(RTime,RData(:,6),'Color','b','LineWidth',LW,'DisplayName','Forearm pro-sup');
xlabel('Time [s]')
ylabel('Angle [deg^o]')

lgd = legend([L,R],'FontSize',15)