clc
clear all
close all
%'Timestamp','Kinect_LShoulderExt-Y','Kinect_LShoulderAbd-Z','Kinect_LElbow','Kinect_RShoulderExt-Y','Kinect_RShoulderAbd-Z','Kinect_RElbow','IMULS_Y','IMULS_Z','IMUL_Elbow','IMURS_Y','IMURS_Z','IMURElbow');
%wearable+kinecttesting_04-12-2019 13-46
[t,Kinect_LShoulderExtY,Kinect_LShoulderZ,Kinect_LElbow,Kinect_RShoulder_Y,Kinect_RShoulder_Z,Kinect_RElbow,IMULS_Y,IMULS_Z,IMULE,IMURS_Y,IMURS_Z,IMURE] = importangles('F:\github\wearable-jacket\matlab\kinect+imudata\wearable+kinecttesting_04-12-2019 13-51.txt');
n=10;
Kinect_LShoulderExtY = smooth(Kinect_LShoulderExtY,n);
Kinect_LShoulderZ = smooth(Kinect_LShoulderZ,n);
Kinect_LElbow = smooth(Kinect_LElbow,n);
Kinect_RShoulder_Y = smooth(Kinect_RShoulder_Y,n);
Kinect_RShoulder_Z = smooth(Kinect_RShoulder_Z,n);
Kinect_RElbow = smooth(Kinect_RElbow,n);
IMULS_Y = smooth(IMULS_Y,n);
IMULS_Z = smooth(IMULS_Z,n);
IMULE = smooth(IMULE,n);
IMURS_Y = smooth(IMURS_Y,n);
IMURS_Z = smooth(IMURS_Z,n);
IMURE = smooth(IMURE,n);

figure(1)
hold on
grid on
plot(t,Kinect_LShoulderExtY)
% plot(t,Kinect_LShoulderZ)
plot(t,IMULS_Y)
% plot(t,IMULS_Z)
xlabel('Time (seconds)');
ylabel('Angle in degrees');
legend({'KinectLeftShoulder_{Y}','IMULeft_{Y}'},'Location','northwest','NumColumns',5,'FontSize',12,'TextColor','blue');

figure(2)
hold on
grid on
% plot(t,Kinect_LShoulderExtY)
plot(t,Kinect_LShoulderZ)
% plot(t,IMULS_Y)
plot(t,IMULS_Z)
xlabel('Time (seconds)');
ylabel('Angle in degrees');
legend({'KinectLeftShoulder_{Z}','IMULeft_{Z}'},'Location','northwest','NumColumns',5,'FontSize',12,'TextColor','blue');


figure(3)
hold on
grid on
plot(t,Kinect_LElbow)
plot(t,IMULE)
xlabel('Time (seconds)');
ylabel('Angle in degrees');
legend({'KinectLeftElbow','IMU_{LE}'},'Location','northwest','NumColumns',5,'FontSize',12,'TextColor','blue');

figure(4)
hold on
grid on
plot(t,Kinect_RShoulder_Y)
plot(t,IMURS_Y)
xlabel('Time (seconds)');
ylabel('Angle in degrees');
legend({'KinectRightShoulder_{Y}','IMURIGHT_{Y}'},'Location','northwest','NumColumns',5,'FontSize',12,'TextColor','blue');
% 
% 
% figure(5)
% hold on
% grid on
% plot(t,Kinect_RShoulder_Z)
% plot(t,IMURS_Z)
% xlabel('Time (seconds)');
% ylabel('Angle in degrees');
% legend({'KinectRightShoulder_{Z}','IMURIGHT_{Z}'},'Location','northwest','NumColumns',5,'FontSize',12,'TextColor','blue');
% 
% figure(6)
% hold on
% grid on
% plot(t,Kinect_RElbow)
% plot(t,IMURE)
% xlabel('Time (seconds)');
% ylabel('Angle in degrees');
% legend({'KinectRightElbow','IMU_{RE}'},'Location','northwest','NumColumns',5,'FontSize',12,'TextColor','blue');

