clear all; close all; clc;
delete(instrfind({'Port'},{'COM15'}))
telapsed = 0;
strfile = sprintf('wearable_%s.txt', datestr(now,'mm-dd-yyyy HH-MM'));s = serial('COM15','BaudRate',115200); s.ReadAsyncMode = 'continuous';
fid = fopen(strfile,'wt');
fprintf( fid, '%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s\n','Timestamp','IMULS_X','IMULS_Y','IMULS_Z','IMULS_Ynew','IMULS_Znew','IMULE_X','IMULE_Y','IMULE_Z','IMULElbow','IMURS_X','IMURS_Y','IMURS_Z','IMURS_Ynew','IMURS_Znew''IMURE_X','IMURE_Y','IMURE_Z','IMURElbow');
qC = [1,0,0,0];qD = [1,0,0,0];qA = [1,0,0,0];qB = [1,0,0,0];qE = [1,0,0,0];qAC = [1,0,0,0];qCE = [1,0,0,0];qDE = [1,0,0,0];qBD = [1,0,0,0];qRE = [1,0,0,0];qLE = [1,0,0,0];
leftelbow = [0,0,0];leftshoulder=[0,0,0];rightshoulder=[0,0,0];rightelbow=[0,0,0];L_elb = 0;R_elb = 0;L_sho = [0,0];R_sho = [0,0];
qI = [0,1,0,0];qJ = [0,0,1,0];qK = [0,0,0,1];
sp = 1.5;
IC = [1 0 0]; ID = [1 0 0]; ICD = [1 0 0];
JC = [0 1 0]; JD = [0 1 0]; JCD = [0 1 0];
KC = [0 0 1]; KD = [0 0 1]; KCD = [0 0 1];
figure(1)
hold on
grid on
axis equal
axis([-1 4 -1 2 -1 2])
view([35,24])
plot3([0,qI(2)],[0,qI(3)],[0,qI(4)],'k');
text(qI(2),qI(3),qI(4),'i');
plot3([0,qJ(2)],[0,qJ(3)],[0,qJ(4)],'k');
text(qJ(2),qJ(3),qJ(4),'j');
plot3([0,qK(2)],[0,qK(3)],[0,qK(4)],'k');
text(qK(2),qK(3),qK(4),'k');
A1 = plot3([sp,sp+IC(1)],[0,IC(2)],[0,IC(3)],'r');  
A2 = plot3([sp,sp+JC(1)],[0,JC(2)],[0,JC(3)],'g');
A3 = plot3([sp,sp+KC(1)],[0,KC(2)],[0,KC(3)],'b');
B1 = plot3([2*sp,2*sp+ID(1)],[0,ID(2)],[0,ID(3)],'r');  
B2 = plot3([2*sp,2*sp+JD(1)],[0,JD(2)],[0,JD(3)],'g');
B3 = plot3([2*sp,2*sp+KD(1)],[0,KD(2)],[0,KD(3)],'b');
k=[];
figure(2)
hold on
grid on
axis equal
axis([-1 4 -1 2 -1 2])
view([35,24])
plot3([0,qI(2)],[0,qI(3)],[0,qI(4)],'r');
plot3([0,qJ(2)],[0,qJ(3)],[0,qJ(4)],'g');
plot3([0,qK(2)],[0,qK(3)],[0,qK(4)],'b');
AB1 = plot3([2*sp,2*sp+ICD(1)],[0,ICD(2)],[0,ICD(3)],'r');  
AB2 = plot3([2*sp,2*sp+JCD(1)],[0,JCD(2)],[0,JCD(3)],'g');
AB3 = plot3([2*sp,2*sp+KCD(1)],[0,KCD(2)],[0,KCD(3)],'b');


fopen(s);
%arduino section
while true
        tstart=tic;
     flushinput(s);
    line = fscanf(s);   % get data if there exists data in the next line
    data = strsplit(string(line),',');
    if(length(data) == 5 || length(data) == 6)
    switch data(1)
        case 'cal'
          switch data(2)
                case 'b'
                    B_mag = str2double(data(3));
                    B_acc = str2double(data(4));
                    B_gyr = str2double(data(5));
                    B_sys = str2double(data(6));
                    Cal_B = [B_mag B_acc B_gyr B_sys];
%                     text(10,10,data);
                case 'a'
                    A_mag = str2double(data(3));
                    A_acc = str2double(data(4));
                    A_gyr = str2double(data(5));
                    A_sys = str2double(data(6));      
                    Cal_A = [A_mag A_acc A_gyr A_sys];
%                     text(10,10,data);
                case 'c'
                    C_mag = str2double(data(3));
                    C_acc = str2double(data(4));
                    C_gyr = str2double(data(5));
                    C_sys = str2double(data(6));  
                    Cal_C = [C_mag C_acc C_gyr C_sys];
%                     text(10,10,data);
                case 'd'
                    D_mag = str2double(data(3));
                    D_acc = str2double(data(4));
                    D_gyr = str2double(data(5));
                    D_sys = str2double(data(6));      
                    Cal_D = [D_mag D_acc D_gyr D_sys];
%                     text(10,10,data);
                case 'e'
                    E_mag = str2double(data(3));
                    E_acc = str2double(data(4));
                    E_gyr = str2double(data(5));
                    E_sys = str2double(data(6));      
                    Cal_E = [E_mag E_acc E_gyr E_sys];
%                     text(10,10,data);
          end 
          
        case 'e'
            qE = val2quat(data);
            qLE = quatorient(qE);
            qRE = quatorient1(qE);
            qCE = quatmultiply(quatconj(qC),qLE);
            qDE = quatmultiply(quatconj(qD),qRE);
            leftshoulder = quaternion2eulerdegrees(qCE);
            rightshoulder = quaternion2eulerdegrees(qDE);
            R_sho = getShoulder(qE,qD);
            L_sho = getShoulder(qE,qC);
        case 'c'
            qC = val2quat(data)
            qCE = quatmultiply(quatconj(qC),qLE);
            leftshoulder = quaternion2eulerdegrees(qCE);
            L_elb = getElbow(qA,qC);
            L_sho = getShoulder(qE,qC);
            
            [~,I1,I2,I3] = parts(quaternion(quatmultiply(qE,quatmultiply(qI,quatconj(qE)))));
            IC = [I1,I2,I3];
            [~,J1,J2,J3] = parts(quaternion(quatmultiply(qE,quatmultiply(qJ,quatconj(qE)))));
            JC = [J1,J2,J3];
            [~,K1,K2,K3] = parts(quaternion(quatmultiply(qE,quatmultiply(qK,quatconj(qE)))));
            KC = [K1,K2,K3];
             
            [~,I1,I2,I3] = parts(quaternion(quatmultiply(qCE,quatmultiply(qI,quatconj(qCE)))));
            ICD = [I1,I2,I3];
            [~,J1,J2,J3] = parts(quaternion(quatmultiply(qCE,quatmultiply(qJ,quatconj(qCE)))));
            JCD = [J1,J2,J3];
            [~,K1,K2,K3] = parts(quaternion(quatmultiply(qCE,quatmultiply(qK,quatconj(qCE)))));
            KCD = [K1,K2,K3];
            
            figure(1)
            hold on
            delete([A1,A2,A3])
            A1 = plot3([sp,sp+IC(1)],[0,IC(2)],[0,IC(3)],'r');  
            A2 = plot3([sp,sp+JC(1)],[0,JC(2)],[0,JC(3)],'g');
            A3 = plot3([sp,sp+KC(1)],[0,KC(2)],[0,KC(3)],'b');
            
            figure(2)
            hold on
            delete([AB1,AB2,AB3])
            AB1 = plot3([sp,sp+ICD(1)],[0,ICD(2)],[0,ICD(3)],'r');  
            AB2 = plot3([sp,sp+JCD(1)],[0,JCD(2)],[0,JCD(3)],'g');
            AB3 = plot3([sp,sp+KCD(1)],[0,KCD(2)],[0,KCD(3)],'b');
 
        case 'd'
            qD = val2quat(data)
            qDE = quatmultiply(quatconj(qD),qRE);
            rightshoulder = quaternion2eulerdegrees(qDE);
            R_sho = getShoulder(qE,qD);
            R_elb = getElbow(qD,qB);
        case 'a'
            qA = val2quat(data);
            qAC = quatmultiply(quatconj(qC),qA);
            leftelbow = quaternion2eulerdegrees(qAC)
            L_elb = getElbow(qA,qC);
        case 'b'
            qB = val2quat(data);
            qBD = quatmultiply(quatconj(qB),qD);
            rightelbow = quaternion2eulerdegrees(qBD);
            R_elb = getElbow(qD,qB);
    end 
    end
    
 if ~isempty(k)
        if strcmp(k,'q'); 
            break; 
        end
 end
 telapsed = telapsed+toc(tstart);
 %'Timestamp','IMULS_X','IMULS_Y','IMULS_Z','IMULS_Ynew','IMULS_Znew','IMULE_X','IMULE_Y','IMULE_Z','IMULElbow','IMURS_X','IMURS_Y','IMURS_Z','IMURS_Ynew','IMURS_Znew''IMURE_X','IMURE_Y','IMURE_Z','IMURElbow');
 fprintf( fid, '%.2f,%.2f,%.2f,%.2f,%.2f,%.2f,%.2f,%.2f,%.2f,%.2f,%.2f,%.2f,%.2f,%.2f,%.2f,%.2f,%.2f,%.2f,%.2f\n',telapsed,leftshoulder(1),leftshoulder(2),leftshoulder(3),L_sho(1),L_sho(2),leftelbow(1),leftelbow(2),leftelbow(3),L_elb,rightshoulder(1),rightshoulder(2),rightshoulder(3),R_sho(1),R_sho(2),rightelbow(1),rightelbow(2),rightelbow(3),R_elb);

end

fclose(fid);
% Close kinect object
delete(instrfind({'Port'},{'COM15'}))
%clear s a % Clear Arduino and Servo Objectss
close all;

function quatmapped = val2quat(data)
p = -1; %y = m x + p where y(-1 1) x(0 999) from rfduino z(-2^14 2^14)
m = 2/999;
            qw(1) = str2double(data(2))*m+p;
            qw(2) = str2double(data(3))*m+p;
            qw(3) = str2double(data(4))*m+p;
            qw(4) = str2double(data(5))*m+p;
            qw = quatnormalize(qw);
quatmapped = qw;
end


function angle = quaternion2eulerdegrees(q)
angle = quat2eul(q)*180/pi;
end

function rotatedquat = quatorient(q)
% Qj = [0,0,1,0];
Qi = [0,1,0,0];
% Qk = [0,0,0,1];
% Qe = [1,0,0,0];
% Qy = quatmultiply(q,quatmultiply(Qj,quatconj(q)));
% Qy = [cos(pi/4),Qy(2)*sin(pi/4),Qy(3)*sin(pi/4),Qy(4)*sin(pi/4)];
% Qe = quatmultiply(Qy,q);
Qx = quatmultiply(q,quatmultiply(Qi,quatconj(q)));
Qx = [cos(pi/4),Qx(2)*sin(pi/4),Qx(3)*sin(pi/4),Qx(4)*sin(pi/4)];
Qe = quatmultiply(Qx,q);
rotatedquat = Qe;
end

function rotatedquat = quatorient1(q)
% Qj = [0,0,1,0];
Qi = [0,1,0,0];
% Qk = [0,0,0,1];
% Qe = [1,0,0,0];
% Qy = quatmultiply(q,quatmultiply(Qj,quatconj(q)));
% Qy = [cos(pi/4),Qy(2)*sin(pi/4),Qy(3)*sin(pi/4),Qy(4)*sin(pi/4)];
% Qe = quatmultiply(Qy,q);
Qx = quatmultiply(q,quatmultiply(Qi,quatconj(q)));
Qx = [cos(-pi/4),Qx(2)*sin(-pi/4),Qx(3)*sin(-pi/4),Qx(4)*sin(-pi/4)];
Qe = quatmultiply(Qx,q);
rotatedquat = Qe;
end


function Elb = getElbow(q1,q2)
Qi = [0,1,0,0];
Q1 = quatmultiply(q1,quatmultiply(Qi,quatconj(q1)));
V1 = [Q1(2),Q1(3),Q1(4)];
Q2 = quatmultiply(q2,quatmultiply(Qi,quatconj(q2)));
V2 = [Q2(2),Q2(3),Q2(4)];
Elb = acosd(dot(V1,V2)/(norm(V1)*norm(V2)));
end

function Sho = getShoulder(back,arm)
Qi = [0,1,0,0];
Qj = [0,0,1,0];
Qbx = quatmultiply(back,quatmultiply(Qi,quatconj(back)));
Bx = [Qbx(2),Qbx(3),Qbx(4)];
Qby = quatmultiply(back,quatmultiply(Qj,quatconj(back)));
By = -[Qby(2),Qby(3),Qby(4)];
Qarm = quatmultiply(arm,quatmultiply(Qi,quatconj(arm)));
Ax = [Qarm(2),Qarm(3),Qarm(4)];
Shoz = acosd(dot(Bx,Ax)/(norm(Bx)*norm(Ax)));
Shoy = acosd(dot(By,Ax)/(norm(By)*norm(Ax)));
Sho = [Shoy, Shoz];
end