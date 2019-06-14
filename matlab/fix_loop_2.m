clear all, close all, clc

delete(instrfind({'Port'},{'COM15'}))
s = serial('COM15','BaudRate',115200);
s.ReadAsyncMode = 'continuous';
p = -1; %y = m x + p where y(-1 1) x(0 999) from rfduino z(-2^14 2^14)
m = 2/999;

empty = [1,0,0,0];

qE = [1,0,0,0];
qfE = [1,0,0,0];
qOFFe = [0,0,0,0];
qC = [1,0,0,0];
qfC = [1,0,0,0];
qOFFc = [0,0,0,0];

qI = [0,1,0,0];
qJ = [0,0,1,0];
qK = [0,0,0,1];

IE = [1 0 0]; IC = [1 0 0];
JE = [0 1 0]; JC = [0 1 0]; 
KE = [0 0 1]; KC = [0 0 1];


sp = 1.5;

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
plot3([sp,sp+qI(2)],[0,qI(3)],[0,qI(4)],'k');
text(sp+qI(2),qI(3),qI(4),'i');
plot3([sp,sp+qJ(2)],[0,qJ(3)],[0,qJ(4)],'k');
text(sp+qJ(2),qJ(3),qJ(4),'j');
plot3([sp,sp+qK(2)],[0,qK(3)],[0,qK(4)],'k');
text(sp+qK(2),qK(3),qK(4),'k');
E1 = plot3([0,IE(1)],[0,IE(2)],[0,IE(3)],'r');  
E2 = plot3([0,JE(1)],[0,JE(2)],[0,JE(3)],'g');
E3 = plot3([0,KE(1)],[0,KE(2)],[0,KE(3)],'b');
C1 = plot3([sp,sp+IC(1)],[0,IC(2)],[0,IC(3)],'r');
C2 = plot3([sp,sp+JC(1)],[0,JC(2)],[0,JC(3)],'g');
C3 = plot3([sp,sp+KC(1)],[0,KC(2)],[0,KC(3)],'b');

fopen(s);

while true
    flushinput(s);
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
            
        case 'c'
            qC(1) = str2double(data(2))*m+p;
            qC(2) = str2double(data(3))*m+p;
            qC(3) = str2double(data(4))*m+p;
            qC(4) = str2double(data(5))*m+p;
            qC = quatnormalize(qC);
    end
            
            if all(qOFFe == qE) && all(qOFFc == qC) && all(qOFFe ~= empty) && all(qOFFc ~= empty)
                qOFFe = qE
                qOFFc = qC
                break
            end  
            
            qOFFe = qE;
            qOFFc = qC;
      
 
    end
    


end


while true
    flushinput(s);
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
            qfE = axis_fix(qE,qOFFe);
                
            [~,I1,I2,I3] = parts(quaternion(quatmultiply(qfE,quatmultiply(qI,quatconj(qfE)))));
            IE = [I1,I2,I3];
            [~,J1,J2,J3] = parts(quaternion(quatmultiply(qfE,quatmultiply(qJ,quatconj(qfE)))));
            JE = [J1,J2,J3];
            [~,K1,K2,K3] = parts(quaternion(quatmultiply(qfE,quatmultiply(qK,quatconj(qfE)))));
            KE = [K1,K2,K3];
                
            figure(1)
            hold on
            delete([E1,E2,E3])
            E1 = plot3([0,IE(1)],[0,IE(2)],[0,IE(3)],'r');  
            E2 = plot3([0,JE(1)],[0,JE(2)],[0,JE(3)],'g');
            E3 = plot3([0,KE(1)],[0,KE(2)],[0,KE(3)],'b');
            
        case 'c'
            qC(1) = str2double(data(2))*m+p;
            qC(2) = str2double(data(3))*m+p;
            qC(3) = str2double(data(4))*m+p;
            qC(4) = str2double(data(5))*m+p;
            qC = quatnormalize(qC);
            qfC = axis_fix(qC,qOFFc);
            
            [~,I1,I2,I3] = parts(quaternion(quatmultiply(qfC,quatmultiply(qI,quatconj(qfC)))));
            IC = [I1,I2,I3];
            [~,J1,J2,J3] = parts(quaternion(quatmultiply(qfC,quatmultiply(qJ,quatconj(qfC)))));
            JC = [J1,J2,J3];
            [~,K1,K2,K3] = parts(quaternion(quatmultiply(qfC,quatmultiply(qK,quatconj(qfC)))));
            KC = [K1,K2,K3];
            
            figure(1)
            hold on
            delete([C1,C2,C3])
            C1 = plot3([sp,sp+IC(1)],[0,IC(2)],[0,IC(3)],'r');
            C2 = plot3([sp,sp+JC(1)],[0,JC(2)],[0,JC(3)],'g');
            C3 = plot3([sp,sp+KC(1)],[0,KC(2)],[0,KC(3)],'b');
    end
    end
end
