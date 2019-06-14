clc
clear all
close all
% %'Timestamp','IMULS_X','IMULS_Y','IMULS_Z','IMULS_Ynew','IMULS_Znew','IMULE_X','IMULE_Y','IMULE_Z','IMULElbow','IMURS_X','IMURS_Y','IMURS_Z','IMURS_Ynew','IMURS_Znew''IMURE_X','IMURE_Y','IMURE_Z','IMURElbow');
[t,IMULS_X,IMULS_Y,IMULS_Z,IMULS_Ynew,IMULS_Znew,IMULE_X,IMULE_Y,IMULE_Z,IMULE,IMURS_X,IMURS_Y,IMURS_Z,IMURS_Ynew,IMURS_Znew,IMURE_X,IMURE_Y,IMURE_Z,IMURE] = importangles('F:\github\wearable-jacket\matlab\wearable_04-12-2019 14-02.txt');
n=2;
IMULS_X = smooth(IMULS_X,n);
IMULS_Y = smooth(IMULS_Y,n);
IMULS_Z = smooth(IMULS_Z,n);
IMURS_X = smooth(IMURS_X,n);
IMURS_Y = smooth(IMURS_Y,n);
IMURS_Z = smooth(IMURS_Z,n);
IMURE_X = smooth(IMURE_X,n);
IMURE_Y = smooth(IMURE_Y,n);
IMURE_Z = smooth(IMURE_Z,n);
IMULE_X = smooth(IMULE_X,n);
IMULE_Y = smooth(IMULE_Y,n);
IMULE_Z = smooth(IMULE_Z,n);
IMULS_Ynew = smooth(IMULS_Ynew,n);
IMULS_Znew = smooth(IMULS_Znew,n);
IMURS_Ynew = smooth(IMURS_Ynew,n);
IMURS_Znew = smooth(IMURS_Znew,n);
IMURE = smooth(IMURE,n);
IMULE = smooth(IMULE,n);


figure(1)
hold on
plot(t,IMULS_X)
plot(t,IMULS_Y)
plot(t,IMULS_Z)
plot(t,IMULS_Ynew)
xlabel('Time (seconds)');
ylabel('Angle in degrees');
legend({'IMULS_{X}','IMULS_{Y}','IMULS_{Z}','IMULS_{Ynew}'},'Location','north','NumColumns',5,'FontSize',12,'TextColor','blue');
hold off

figure(2)
hold on
plot(t,IMULS_X)
plot(t,IMULS_Y)
plot(t,IMULS_Z)
plot(t,IMULS_Znew)
xlabel('Time (seconds)');
ylabel('Angle in degrees');
legend({'IMULS_{X}','IMULS_{Y}','IMULS_{Z}','IMULS_{Znew}'},'Location','north','NumColumns',5,'FontSize',12,'TextColor','blue');
hold off

figure(3)
hold on
plot(t,IMURS_X)
plot(t,IMURS_Y)
plot(t,IMURS_Z)
plot(t,IMURS_Ynew)
xlabel('Time (seconds)');
ylabel('Angle in degrees');
legend({'IMURS_{X}','IMURS_{Y}','IMURS_{Z}','IMURS_{Ynew}'},'Location','north','NumColumns',5,'FontSize',12,'TextColor','blue');
hold off

figure(4)
hold on
plot(t,IMURS_X)
plot(t,IMURS_Y)
plot(t,IMURS_Z)
plot(t,IMURS_Znew)
xlabel('Time (seconds)');
ylabel('Angle in degrees');
legend({'IMURS_{X}','IMURS_{Y}','IMURS_{Z}','IMURS_{Znew}'},'Location','north','NumColumns',5,'FontSize',12,'TextColor','blue');
hold off

figure(5)
hold on
plot(t,IMURE_X)
plot(t,IMURE_Y)
plot(t,IMURE_Z)
plot(t,IMURE)
xlabel('Time (seconds)');
ylabel('Angle in degrees');
legend({'IMURE_{X}','IMURE_{Y}','IMURE_{Z}','IMURE_{new}'},'Location','north','NumColumns',5,'FontSize',12,'TextColor','blue');
hold off

figure(6)
hold on
plot(t,IMULE_X)
plot(t,IMULE_Y)
plot(t,IMULE_Z)
plot(t,IMULE)
xlabel('Time (seconds)');
ylabel('Angle in degrees');
legend({'IMULE_{X}','IMULE_{Y}','IMULE_{Z}','IMULE_{new}'},'Location','north','NumColumns',5,'FontSize',12,'TextColor','blue');
hold off



