clear all, close all, clc
delete(instrfind({'Port'},{'COM15'}))
s = serial('COM15','BaudRate',115200);
s.ReadAsyncMode = 'continuous';
p = -1; %y = m x + p where y(-1 1) x(0 999) from rfduino z(-2^14 2^14)
m = 2/999;

qB = [1,0,0,0];
qD = [1,0,0,0];
qBD = [1,0,0,0];

sp = 1.5;

qI = [0,1,0,0];
qJ = [0,0,1,0];
qK = [0,0,0,1];

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

while true
    flushinput(s);
    pause(0.01);
    line = fscanf(s);   % get data if there exists data in the next line
    data = strsplit(string(line),',');
    if(length(data) == 5 || length(data) == 6)
    switch data(1)
        case 'cal'
            switch data(2)
                case 'b'
                    C_mag = str2double(data(3));
                    C_acc = str2double(data(4));
                    C_gyr = str2double(data(5));
                    C_sys = str2double(data(6));  
                    Cal_B = [C_mag C_acc C_gyr C_sys]
                case 'd'
                    D_mag = str2double(data(3));
                    D_acc = str2double(data(4));
                    D_gyr = str2double(data(5));
                    D_sys = str2double(data(6));      
                    Cal_D = [D_mag D_acc D_gyr D_sys]
            end    
        case 'e'
            qB(1) = str2double(data(2))*m+p;
            qB(2) = str2double(data(3))*m+p;
            qB(3) = str2double(data(4))*m+p;
            qB(4) = str2double(data(5))*m+p;
            qB = quatnormalize(qB);
            qBD = quatmultiply(quatconj(qB),qD);
            
            [~,I1,I2,I3] = parts(quaternion(quatmultiply(qB,quatmultiply(qI,quatconj(qB)))));
            IC = [I1,I2,I3];
            [~,J1,J2,J3] = parts(quaternion(quatmultiply(qB,quatmultiply(qJ,quatconj(qB)))));
            JC = [J1,J2,J3];
            [~,K1,K2,K3] = parts(quaternion(quatmultiply(qB,quatmultiply(qK,quatconj(qB)))));
            KC = [K1,K2,K3];
            
            [~,I1,I2,I3] = parts(quaternion(quatmultiply(qBD,quatmultiply(qI,quatconj(qBD)))));
            ICD = [I1,I2,I3];
            [~,J1,J2,J3] = parts(quaternion(quatmultiply(qBD,quatmultiply(qJ,quatconj(qBD)))));
            JCD = [J1,J2,J3];
            [~,K1,K2,K3] = parts(quaternion(quatmultiply(qBD,quatmultiply(qK,quatconj(qBD)))));
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
            qD(1) = str2double(data(2))*m+p;
            qD(2) = str2double(data(3))*m+p;
            qD(3) = str2double(data(4))*m+p;
            qD(4) = str2double(data(5))*m+p;
            qD = quatnormalize(qD);
            qBD = quatmultiply(quatconj(qB),qD);
            
            [~,I1,I2,I3] = parts(quaternion(quatmultiply(qD,quatmultiply(qI,quatconj(qD)))));
            ID = [I1,I2,I3];
            [~,J1,J2,J3] = parts(quaternion(quatmultiply(qD,quatmultiply(qJ,quatconj(qD)))));
            JD = [J1,J2,J3];
            [~,K1,K2,K3] = parts(quaternion(quatmultiply(qD,quatmultiply(qK,quatconj(qD)))));
            KD = [K1,K2,K3];
            
            [~,I1,I2,I3] = parts(quaternion(quatmultiply(qBD,quatmultiply(qI,quatconj(qBD)))));
            ICD = [I1,I2,I3];
            [~,J1,J2,J3] = parts(quaternion(quatmultiply(qBD,quatmultiply(qJ,quatconj(qBD)))));
            JCD = [J1,J2,J3];
            [~,K1,K2,K3] = parts(quaternion(quatmultiply(qBD,quatmultiply(qK,quatconj(qBD)))));
            KCD = [K1,K2,K3];
            
            figure(1)
            hold on
            delete([B1,B2,B3])
            B1 = plot3([2*sp,2*sp+ID(1)],[0,ID(2)],[0,ID(3)],'r');  
            B2 = plot3([2*sp,2*sp+JD(1)],[0,JD(2)],[0,JD(3)],'g');
            B3 = plot3([2*sp,2*sp+KD(1)],[0,KD(2)],[0,KD(3)],'b');
            
            figure(2)
            hold on
            delete([AB1,AB2,AB3])
            AB1 = plot3([sp,sp+ICD(1)],[0,ICD(2)],[0,ICD(3)],'r');  
            AB2 = plot3([sp,sp+JCD(1)],[0,JCD(2)],[0,JCD(3)],'g');
            AB3 = plot3([sp,sp+KCD(1)],[0,KCD(2)],[0,KCD(3)],'b');
    end 
    end
    


end