[Time,KLSEF,IMULSEF,KLSAA,IMULSAA,KLSIE,IMULSIE,KLEEF,IMULEEF,IMULEPS,KRSEF,IMURSEF,KRSAA,IMURSAA,KRSIE,IMURSIE,KREEF,IMUREEF,IMUREPS] = ....
importtextkinimu('F:\github\wearable-jacket\matlab\kinect+imudata\wearable+kinecttesting_05-31-2019 02-02.txt');
font = 18;
KLSEF = smooth(KLSEF,10);
IMULSEF = smooth(IMULSEF,10);
figure(1)
plot(KLSEF,IMULSEF,'*');
hold on
% plot(Time,IMULSEF);
xlabel('Time (seconds)','FontWeight','bold','FontSize',font);
ylabel('Left Shoulder_{Extension-Flexion}','FontWeight','bold','FontSize',font);
legend('Kinect','WISE','Location','NorthWest','FontWeight','bold','FontSize',font);
hold off
figure(2)
plot(Time,KLSEF);
hold on
plot(Time,IMULSEF);
xlabel('Time (seconds)','FontWeight','bold','FontSize',font);
ylabel('Left Shoulder_{Extension-Flexion}','FontWeight','bold','FontSize',font);
legend('Kinect','WISE','Location','NorthWest','FontWeight','bold','FontSize',font);
hold off
% figure(2)
% plot(Time,KLSAA);
% hold on
% plot(Time,IMULSAA);
% xlabel('Time (seconds)','FontWeight','bold','FontSize',font);
% ylabel('Left Shoulder_{Abduction-Adduction}','FontWeight','bold','FontSize',font);
% legend('Kinect','WISE','Location','NorthWest','FontWeight','bold','FontSize',font);
% hold off
% 
% figure(3)
% plot(Time,KLSIE);
% hold on
% plot(Time,IMULSIE);
% xlabel('Time (seconds)','FontWeight','bold','FontSize',font);
% ylabel('Left Shoulder_{Internal-External Rotation}','FontWeight','bold','FontSize',font);
% legend('Kinect','WISE','Location','NorthWest','FontWeight','bold','FontSize',font);
% hold off
% 
% figure(4)
% subplot(2,1,1)
% plot(Time,KLEEF);
% hold on
% plot(Time,IMULEEF);
% xlabel('Time (seconds)','FontWeight','bold','FontSize',font);
% ylabel('Left Elbow_{Extension-Flexion}','FontWeight','bold','FontSize',font);
% legend('Kinect','WISE','Location','NorthWest','FontWeight','bold','FontSize',font);
% hold off
% subplot(2,1,2)
% hold on
% plot(Time,IMULEPS);
% xlabel('Time (seconds)','FontWeight','bold','FontSize',font);
% ylabel('Left Elbow_{Pronation-Supination}','FontWeight','bold','FontSize',font);
% legend('WISE','Location','NorthWest','FontWeight','bold','FontSize',font);
% hold off
% 
% figure(5)
% plot(Time,KRSEF);
% hold on
% plot(Time,IMURSEF);
% xlabel('Time (seconds)','FontWeight','bold','FontSize',font);
% ylabel('Right Shoulder_{Extension-Flexion}','FontWeight','bold','FontSize',font);
% legend('Kinect','WISE','Location','NorthWest','FontWeight','bold','FontSize',font);
% hold off
% 
% figure(6)
% plot(Time,KRSAA);
% hold on
% plot(Time,IMURSAA);
% xlabel('Time (seconds)','FontWeight','bold','FontSize',font);
% ylabel('Right Shoulder_{Abduction-Adduction}','FontWeight','bold','FontSize',font);
% legend('Kinect','WISE','Location','NorthWest','FontWeight','bold','FontSize',font);
% hold off
% 
% figure(7)
% plot(Time,KRSIE);
% hold on
% plot(Time,IMURSIE);
% xlabel('Time (seconds)','FontWeight','bold','FontSize',font);
% ylabel('Right Shoulder_{Internal-External Rotation}','FontWeight','bold','FontSize',font);
% legend('Kinect','WISE','Location','NorthWest','FontWeight','bold','FontSize',font);
% hold off
% 
% figure(8)
% subplot(2,1,1)
% plot(Time,KREEF);
% hold on
% plot(Time,IMUREEF);
% xlabel('Time (seconds)','FontWeight','bold','FontSize',font);
% ylabel('Right Elbow_{Extension-Flexion}','FontWeight','bold','FontSize',font);
% legend('Kinect','WISE','Location','NorthWest','FontWeight','bold','FontSize',font);
% hold off
% subplot(2,1,2)
% hold on
% plot(Time,IMUREPS);
% xlabel('Time (seconds)','FontWeight','bold','FontSize',font);
% ylabel('Right Elbow_{Pronation-Supination}','FontWeight','bold','FontSize',font);
% legend('WISE','Location','NorthWest','FontWeight','bold','FontSize',font);
% hold off