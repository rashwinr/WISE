clc;clear all;close all;
X = (0:1:180)*pi/180;
Y = zeros(1,length(X));
Z = zeros(1,length(X));
eulerX = [X;Y;Z];
eulerY = [Y;X;Z];
eulerZ = [Y;Z;X];
eulerarbit = [X;X;X];
quatX = zeros(length(X),4);
quatY = zeros(length(X),4);
quatZ = zeros(length(X),4);
quatarbit = zeros(length(X),4);
for i=1:length(X)
    quatX(i,:) = eul2quat(eulerX(:,i)','XYZ');
    quatY(i,:) = eul2quat(eulerY(:,i)','XYZ');
    quatZ(i,:) = eul2quat(eulerZ(:,i)','XYZ');
    quatarbit(i,:) = eul2quat(eulerarbit(:,i)','XYZ');
end
for i=1:length(X)
    eulconvertedX(i,:) = quat2eul(quatX(i,:),'XYZ')*180/pi;
    eulconvertedY(i,:) = quat2eul(quatY(i,:),'XYZ')*180/pi;
    eulconvertedZ(i,:) = quat2eul(quatZ(i,:),'XYZ')*180/pi;
    eulconvertedarbit(i,:) = quat2eul(quatarbit(i,:),'XYZ')*180/pi;
    eulconvertednewX(i,:) = quaterniontoeulernew(quatX(i,:))*180/pi;
    eulconvertednewY(i,:) = quaterniontoeulernew(quatY(i,:))*180/pi;
    eulconvertednewZ(i,:) = quaterniontoeulernew(quatZ(i,:))*180/pi;
    eulconvertednewarbit(i,:) = quaterniontoeulernew(quatarbit(i,:))*180/pi;
end

figure(1)
plot(eulerX(1,:)*180/pi,'-.r','LineWidth',1)
hold on
grid on
plot(eulerX(2,:)*180/pi,'-.g','LineWidth',1)
plot(eulerX(3,:)*180/pi,'-.b','LineWidth',1)
plot(eulconvertedX(:,1),':r','LineWidth',3)
plot(eulconvertedX(:,2),':g','LineWidth',1)
plot(eulconvertedX(:,3),':b','LineWidth',1)
plot(eulconvertednewX(:,1),'--r','LineWidth',3)
plot(eulconvertednewX(:,2),'--g','LineWidth',1)
plot(eulconvertednewX(:,3),'--b','LineWidth',1)
xlabel('Angle in degrees of X axis');
ylabel('Angle in degrees obtained from Quaternion to Euler');
legend({'X axis input','Y axis input','Z axis input','X axis Matlab output','Y axis Matlab output','Z axis Matlab output','X axis Our code output','Y axis Our code output','Z axis Our code output'},'Location','north','NumColumns',9,'FontSize',10,'TextColor','blue');
hold off

figure(2)
plot(eulerY(1,:)*180/pi,'-.r','LineWidth',1)
hold on
grid on
plot(eulerY(2,:)*180/pi,'-.g','LineWidth',1)
plot(eulerY(3,:)*180/pi,'-.b','LineWidth',1)
plot(eulconvertedY(:,1),':r','LineWidth',2)
plot(eulconvertedY(:,2),':g','LineWidth',3)
plot(eulconvertedY(:,3),':b','LineWidth',2)
plot(eulconvertednewY(:,1),'--r','LineWidth',2)
plot(eulconvertednewY(:,2),'--g','LineWidth',3)
plot(eulconvertednewY(:,3),'--b','LineWidth',2)
xlabel('Angle in degrees of Y axis');
ylabel('Angle in degrees obtained from Quaternion to Euler');
legend({'X axis input','Y axis input','Z axis input','X axis Matlab output','Y axis Matlab output','Z axis Matlab output','X axis Our code output','Y axis Our code output','Z axis Our code output'},'Location','north','NumColumns',9,'FontSize',10,'TextColor','blue');
hold off

figure(3)
hold on
grid on
plot(eulerZ(1,:)*180/pi,'-.r','LineWidth',1)
plot(eulerZ(2,:)*180/pi,'-.g','LineWidth',1)
plot(eulerZ(3,:)*180/pi,'-.b','LineWidth',1)
plot(eulconvertedZ(:,1),':r','LineWidth',1)
plot(eulconvertedZ(:,2),':g','LineWidth',1)
plot(eulconvertedZ(:,3),':b','LineWidth',3)
plot(eulconvertednewZ(:,1),'--r','LineWidth',1)
plot(eulconvertednewZ(:,2),'--g','LineWidth',1)
plot(eulconvertednewZ(:,3),'--b','LineWidth',3)
xlabel('Angle in degrees of Z axis');
ylabel('Angle in degrees obtained from Quaternion to Euler');
legend({'X axis input','Y axis input','Z axis input','X axis Matlab output','Y axis Matlab output','Z axis Matlab output','X axis Our code output','Y axis Our code output','Z axis Our code output'},'Location','north','NumColumns',9,'FontSize',10,'TextColor','blue');
hold off

figure(4)
hold on
grid on
plot(eulerarbit(1,:)*180/pi,'-.r','LineWidth',1)
plot(eulerarbit(2,:)*180/pi,'-.g','LineWidth',1)
plot(eulerarbit(3,:)*180/pi,'-.b','LineWidth',1)
plot(eulconvertedarbit(:,1),':r','LineWidth',1)
plot(eulconvertedarbit(:,2),':g','LineWidth',1)
plot(eulconvertedarbit(:,3),':b','LineWidth',2)
plot(eulconvertednewarbit(:,1),'--r','LineWidth',1)
plot(eulconvertednewarbit(:,2),'--g','LineWidth',1)
plot(eulconvertednewarbit(:,3),'--b','LineWidth',2)
xlabel('Angle in degrees of Z axis');
ylabel('Angle in degrees obtained from Quaternion to Euler');
legend({'X axis input','Y axis input','Z axis input','X axis Matlab output','Y axis Matlab output','Z axis Matlab output','X axis Our code output','Y axis Our code output','Z axis Our code output'},'Location','north','NumColumns',9,'FontSize',10,'TextColor','blue');
hold off
quaterniontoeulernew(quatarbit(91,:))
function euler = quaterniontoeulernew(Q)
sinr_cosp = 2*(Q(1)*Q(2)-Q(3)*Q(4));
cosr_cosp = 1-(2*(Q(2)^2 + Q(3)^2));
eul(1) = atan2(sinr_cosp,cosr_cosp);
siny_cosp = 2*(Q(1)*Q(4)-Q(3)*Q(2));
cosy_cosp = 1-(2*(Q(3)*Q(3)+Q(4)*Q(4)));
eul(3) = atan2(siny_cosp,cosy_cosp);
sinp = 2*(Q(1)*Q(3)+Q(4)*Q(2));
if (abs(sinp) >= 0.9999999)
    disp('inside if');
eul(2) = sign(sinp)*pi/2;
% eul(1)=0;
% eul(3)=sign(sinp)*2*atan2(Q(4),Q(1));
end
if abs(sinp)<0.9999999
eul(2) = asin(sinp);
end
euler = eul;
end



% Code for conversion of quaternion to euler implemented in UNITY
% Vector3 quat2eul(Quaternion Q, int Device)
%     {
%         float sinr_cosp = 2.0f * (Q.w * Q.x + Q.y * Q.z);
%         float cosr_cosp = 1.0f - (2.0f * (Q.x * Q.x + Q.y * Q.y));
%         Vector3 euler = new Vector3();
%         euler.x = Mathf.Rad2Deg * Mathf.Atan2(sinr_cosp, cosr_cosp);
%         
%         float sinp = 2.0f * (Q.w * Q.y - Q.z * Q.x);
%         euler.y = - Mathf.Rad2Deg * Mathf.Asin(sinp);
%         
%         float siny_cosp = 2.0f * (Q.w * Q.z + Q.y * Q.x);
%         float cosy_cosp = 1.0f -(2.0f * (Q.y * Q.y + Q.z * Q.z));
%         euler.z = Mathf.Rad2Deg * Mathf.Atan2(siny_cosp, cosy_cosp);
%         if (float.IsNaN(euler.x)|| float.IsNaN(euler.y)||float.IsNaN(euler.z))
%         {
%             euler.x = angle_x[Device];
%             euler.y = angle_y[Device];
%             euler.z = angle_z[Device];
%         }
%         return euler;
%     }