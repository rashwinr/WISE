clear all, close all, clc
delete(instrfind({'Port'},{'COM15'}))
s = serial('COM15','BaudRate',115200);
s.ReadAsyncMode = 'continuous';
p = -1;                 %y = m x + p where y(-1 1) x(0 999) from rfduino z(-2^14 2^14)
m = 2/999;
qE = [1,0,0,0];
qC = [1,0,0,0];
qA = [1,0,0,0];

sp = 1.5;

qI = [0,1,0,0];
qJ = [0,0,1,0];
qK = [0,0,0,1];
IE = [1 0 0]; IC = [1 0 0]; 
JE = [0 1 0]; JC = [0 1 0];
KE = [0 0 1]; KC = [0 0 1];
figure(1)
hold on
grid on
axis equal
axis([-1 4 -1 2 -1 2])
view([35,24])
% plot3([0,qI(2)],[0,qI(3)],[0,qI(4)],'k');
% text(qI(2),qI(3),qI(4),'i');
% plot3([0,qJ(2)],[0,qJ(3)],[0,qJ(4)],'k');
% text(qJ(2),qJ(3),qJ(4),'j');
% plot3([0,qK(2)],[0,qK(3)],[0,qK(4)],'k');
% text(qK(2),qK(3),qK(4),'k');
AZ = text(qK(2),qK(3),qK(4),'k');
VEC = text(2*sp+qK(2),qK(3),qK(4),'0');

E1 = plot3([sp,sp+IE(1)],[0,IE(2)],[0,IE(3)],'r');  
E2 = plot3([sp,sp+JE(1)],[0,JE(2)],[0,JE(3)],'g');
E3 = plot3([sp,sp+KE(1)],[0,KE(2)],[0,KE(3)],'b');
C1 = plot3([2*sp,2*sp+IC(1)],[0,IC(2)],[0,IC(3)],'r');

fopen(s);
while true
    flushinput(s);
    pause(0.01);
    line = fscanf(s);   % get data if there exists data in the next line
    data = strsplit(string(line),',');
    if(length(data) == 5 || length(data) == 6)
    switch data(1)
        case 'cal'
            switch data(2)
                case 'e'
                    E_mag = str2double(data(3));
                    E_acc = str2double(data(4));
                    E_gyr = str2double(data(5));
                    E_sys = str2double(data(6));  
                    Cal_E = [E_mag E_acc E_gyr E_sys]
                case 'c'
                    C_mag = str2double(data(3));
                    C_acc = str2double(data(4));
                    C_gyr = str2double(data(5));
                    C_sys = str2double(data(6));  
                    Cal_C = [C_mag C_acc C_gyr C_sys]
                case 'a'
                    A_mag = str2double(data(3));
                    A_acc = str2double(data(4));
                    A_gyr = str2double(data(5));
                    A_sys = str2double(data(6));      
                    Cal_A = [A_mag A_acc A_gyr A_sys]
            end  
        case 'e'
            qE(1) = str2double(data(2))*m+p;
            qE(2) = str2double(data(3))*m+p;
            qE(3) = str2double(data(4))*m+p;
            qE(4) = str2double(data(5))*m+p;
            qE = quatnormalize(qE);
            qE = fix_E(qE);
            Qx = quatmultiply(qE,quatmultiply(qI,quatconj(qE)));
            theta = -pi/2;
            Qx1 = [cos(theta/2) Qx(2)*sin(theta/2) Qx(3)*sin(theta/2) Qx(4)*sin(theta/2)];
            qE = quatmultiply(Qx1,qE);
            
            [~,I1,I2,I3] = parts(quaternion(quatmultiply(qE,quatmultiply(qI,quatconj(qE)))));
            IE = [I1,I2,I3];
            [~,J1,J2,J3] = parts(quaternion(quatmultiply(qE,quatmultiply(qJ,quatconj(qE)))));
            JE = [J1,J2,J3];
            [~,K1,K2,K3] = parts(quaternion(quatmultiply(qE,quatmultiply(qK,quatconj(qE)))));
            KE = [K1,K2,K3];
            
            V = [dot(IC,IE) , dot(IC,JE) , dot(IC,KE)];
            [azimuth,elevation,r] = cart2sph(V(1),V(2),V(3));
            azimuth = azimuth*180/pi;
            
            figure(1)
            hold on
            delete([E1,E2,E3,AZ,VEC])
            E1 = plot3([sp,sp+IE(1)],[0,IE(2)],[0,IE(3)],'r');  
            E2 = plot3([sp,sp+JE(1)],[0,JE(2)],[0,JE(3)],'g');
            E3 = plot3([sp,sp+KE(1)],[0,KE(2)],[0,KE(3)],'b');
            AZ = text(qK(2),qK(3),qK(4),num2str(azimuth));
            VEC = text(2*sp+qK(2),qK(3),qK(4),num2str(V));
            
        case 'c'
            qC(1) = str2double(data(2))*m+p;
            qC(2) = str2double(data(3))*m+p;
            qC(3) = str2double(data(4))*m+p;
            qC(4) = str2double(data(5))*m+p;
            qC = quatnormalize(qC);
            qC = fix_C(qC);
            
            [~,I1,I2,I3] = parts(quaternion(quatmultiply(qC,quatmultiply(-qI,quatconj(qC)))));
            IC = [I1,I2,I3];
            
            V = [dot(IC,IE) , dot(IC,JE) , dot(IC,KE)];
            [azimuth,elevation,r] = cart2sph(V(1),V(2),V(3));
            azimuth = azimuth*180/pi;
            
            figure(1)
            hold on
            delete([C1,AZ,VEC])
            C1 = plot3([sp,sp+IC(1)],[0,IC(2)],[0,IC(3)],'k');
            AZ = text(qK(2),qK(3),qK(4),num2str(azimuth));
            VEC = text(2*sp+qK(2),qK(3),qK(4),num2str(V));
      
            
    end 
    end
end



