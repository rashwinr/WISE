clear all, close all, clc
delete(instrfind({'Port'},{'COM15'}))
s = serial('COM15','BaudRate',115200);
s.ReadAsyncMode = 'continuous';
p = -1;                 %y = m x + p where y(-1 1) x(0 999) from rfduino z(-2^14 2^14)
m = 2/999;
qE = [1,0,0,0];
qC = [1,0,0,0];
qA = [1,0,0,0];
qEA = [1,0,0,0];
qEC = [1,0,0,0]; eul_ec = [0 0 0]; ec1 = '0'; ec2 = '0'; ec3 = '0';
qCA = [1,0,0,0]; eul_ca = [0 0 0]; ca1 = '0'; ca2 = '0'; ca3 = '0';
sp = 1.5;
qI = [0,1,0,0];
qJ = [0,0,1,0];
qK = [0,0,0,1];
IE = [1 0 0]; IC = [1 0 0]; IA = [1 0 0]; IEC = [1 0 0]; ICA = [1 0 0];
JE = [0 1 0]; JC = [0 1 0]; JA = [0 1 0]; JEC = [0 1 0]; JCA = [0 1 0];
KE = [0 0 1]; KC = [0 0 1]; KA = [0 0 1]; KEC = [0 0 1]; KCA = [0 0 1];
figure(1)
hold on
grid on
axis equal
axis([-1 5.5 -1 2 -1 2])
view([35,24])
plot3([0,qI(2)],[0,qI(3)],[0,qI(4)],'k');
text(qI(2),qI(3),qI(4),'i');
plot3([0,qJ(2)],[0,qJ(3)],[0,qJ(4)],'k');
text(qJ(2),qJ(3),qJ(4),'j');
plot3([0,qK(2)],[0,qK(3)],[0,qK(4)],'k');
text(qK(2),qK(3),qK(4),'k');
E1 = plot3([sp,sp+IE(1)],[0,IE(2)],[0,IE(3)],'r');  
E2 = plot3([sp,sp+JE(1)],[0,JE(2)],[0,JE(3)],'g');
E3 = plot3([sp,sp+KE(1)],[0,KE(2)],[0,KE(3)],'b');
C1 = plot3([2*sp,2*sp+IC(1)],[0,IC(2)],[0,IC(3)],'r');
C2 = plot3([2*sp,2*sp+JC(1)],[0,JC(2)],[0,JC(3)],'g');
C3 = plot3([2*sp,2*sp+KC(1)],[0,KC(2)],[0,KC(3)],'b');
A1 = plot3([3*sp,3*sp+IA(1)],[0,IA(2)],[0,IA(3)],'r');  
A2 = plot3([3*sp,3*sp+JA(1)],[0,JA(2)],[0,JA(3)],'g');
A3 = plot3([3*sp,3*sp+KA(1)],[0,KA(2)],[0,KA(3)],'b');
figure(2)
hold on
grid on
axis equal
axis([-1 5.5 -1 2 -1 2])
view([35,24])
plot3([0,qI(2)],[0,qI(3)],[0,qI(4)],'r'); eC1 =  text(qI(2),qI(3),qI(4),ec1);
plot3([0,qJ(2)],[0,qJ(3)],[0,qJ(4)],'g'); eC2 =  text(qJ(2),qJ(3),qJ(4),ec2);
plot3([0,qK(2)],[0,qK(3)],[0,qK(4)],'b'); eC3 =  text(qK(2),qK(3),qK(4),ec3);
EC1 = plot3([2*sp,2*sp+IEC(1)],[0,IEC(2)],[0,IEC(3)],'r'); 
cA1 =  text(2*sp+IEC(1),IEC(2),IEC(3),ca1);
EC2 = plot3([2*sp,2*sp+JEC(1)],[0,JEC(2)],[0,JEC(3)],'g'); 
cA2 =  text(2*sp+JEC(1),JEC(2),JEC(3),ca2);
EC3 = plot3([2*sp,2*sp+KEC(1)],[0,KEC(2)],[0,KEC(3)],'b'); 
cA3 =  text(2*sp+KEC(1),KEC(2),KEC(3),ca3);
CA1 = plot3([3*sp,3*sp+ICA(1)],[0,ICA(2)],[0,ICA(3)],'r');  
CA2 = plot3([3*sp,3*sp+JCA(1)],[0,JCA(2)],[0,JCA(3)],'g');
CA3 = plot3([3*sp,3*sp+KCA(1)],[0,KCA(2)],[0,KCA(3)],'b');
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
            qEC = quatmultiply(quatconj(qE),qC);
            eul_ec = quat2eul(qEC,'ZYX')*180/pi;
            ec3 = num2str(eul_ec(1)); ec2 = num2str(eul_ec(2)); ec1 = num2str(eul_ec(3));
            [~,I1,I2,I3] = parts(quaternion(quatmultiply(qE,quatmultiply(qI,quatconj(qE)))));
            IE = [I1,I2,I3];
            [~,J1,J2,J3] = parts(quaternion(quatmultiply(qE,quatmultiply(qJ,quatconj(qE)))));
            JE = [J1,J2,J3];
            [~,K1,K2,K3] = parts(quaternion(quatmultiply(qE,quatmultiply(qK,quatconj(qE)))));
            KE = [K1,K2,K3];
            [~,I1,I2,I3] = parts(quaternion(quatmultiply(qEC,quatmultiply(qI,quatconj(qEC)))));
            IEC = [I1,I2,I3];
            [~,J1,J2,J3] = parts(quaternion(quatmultiply(qEC,quatmultiply(qJ,quatconj(qEC)))));
            JEC = [J1,J2,J3];
            [~,K1,K2,K3] = parts(quaternion(quatmultiply(qEC,quatmultiply(qK,quatconj(qEC)))));
            KEC = [K1,K2,K3];
            figure(1)
            hold on
            delete([E1,E2,E3])
            E1 = plot3([sp,sp+IE(1)],[0,IE(2)],[0,IE(3)],'r');  
            E2 = plot3([sp,sp+JE(1)],[0,JE(2)],[0,JE(3)],'g');
            E3 = plot3([sp,sp+KE(1)],[0,KE(2)],[0,KE(3)],'b');
            figure(2)
            hold on
            delete([EC1,EC2,EC3,eC1,eC2,eC3])
            EC1 = plot3([2*sp,2*sp+IEC(1)],[0,IEC(2)],[0,IEC(3)],'r'); 
            EC2 = plot3([2*sp,2*sp+JEC(1)],[0,JEC(2)],[0,JEC(3)],'g'); 
            EC3 = plot3([2*sp,2*sp+KEC(1)],[0,KEC(2)],[0,KEC(3)],'b'); 
            eC1 =  text(qI(2),qI(3),qI(4),ec1); eC2 =  text(qJ(2),qJ(3),qJ(4),ec2); eC3 =  text(qK(2),qK(3),qK(4),ec3);
        case 'c'
            qC(1) = str2double(data(2))*m+p;
            qC(2) = str2double(data(3))*m+p;
            qC(3) = str2double(data(4))*m+p;
            qC(4) = str2double(data(5))*m+p;
            qC = quatnormalize(qC);
            qEC = quatmultiply(quatconj(qE),qC);
            eul_ec = quat2eul(qEC,'ZYX')*180/pi;
            ec3 = num2str(eul_ec(1)); ec2 = num2str(eul_ec(2)); ec1 = num2str(eul_ec(3));
            qCA = quatmultiply(quatconj(qC),qA);
            eul_ca = quat2eul(qCA,'ZYX')*180/pi;
            ca3 = num2str(eul_ca(1)); ca2 = num2str(eul_ca(2)); ca1 = num2str(eul_ca(3));
            [~,I1,I2,I3] = parts(quaternion(quatmultiply(qC,quatmultiply(qI,quatconj(qC)))));
            IC = [I1,I2,I3];
            [~,J1,J2,J3] = parts(quaternion(quatmultiply(qC,quatmultiply(qJ,quatconj(qC)))));
            JC = [J1,J2,J3];
            [~,K1,K2,K3] = parts(quaternion(quatmultiply(qC,quatmultiply(qK,quatconj(qC)))));
            KC = [K1,K2,K3];
            [~,I1,I2,I3] = parts(quaternion(quatmultiply(qEC,quatmultiply(qI,quatconj(qEC)))));
            IEC = [I1,I2,I3];
            [~,J1,J2,J3] = parts(quaternion(quatmultiply(qEC,quatmultiply(qJ,quatconj(qEC)))));
            JEC = [J1,J2,J3];
            [~,K1,K2,K3] = parts(quaternion(quatmultiply(qEC,quatmultiply(qK,quatconj(qEC)))));
            KEC = [K1,K2,K3];
            figure(1)
            hold on
            delete([C1,C2,C3])
            C1 = plot3([2*sp,2*sp+IC(1)],[0,IC(2)],[0,IC(3)],'r');
            C2 = plot3([2*sp,2*sp+JC(1)],[0,JC(2)],[0,JC(3)],'g');
            C3 = plot3([2*sp,2*sp+KC(1)],[0,KC(2)],[0,KC(3)],'b');
            figure(2)
            hold on
            delete([EC1,EC2,EC3,eC1,eC2,eC3,CA1,CA2,CA3,cA1,cA2,cA3])
            EC1 = plot3([2*sp,2*sp+IEC(1)],[0,IEC(2)],[0,IEC(3)],'r'); 
            EC2 = plot3([2*sp,2*sp+JEC(1)],[0,JEC(2)],[0,JEC(3)],'g'); 
            EC3 = plot3([2*sp,2*sp+KEC(1)],[0,KEC(2)],[0,KEC(3)],'b'); 
            eC1 =  text(qI(2),qI(3),qI(4),ec1); eC2 =  text(qJ(2),qJ(3),qJ(4),ec2); eC3 =  text(qK(2),qK(3),qK(4),ec3);
            CA1 = plot3([3*sp,3*sp+ICA(1)],[0,ICA(2)],[0,ICA(3)],'r');  
            CA2 = plot3([3*sp,3*sp+JCA(1)],[0,JCA(2)],[0,JCA(3)],'g');
            CA3 = plot3([3*sp,3*sp+KCA(1)],[0,KCA(2)],[0,KCA(3)],'b');
            cA1 =  text(2*sp+IEC(1),IEC(2),IEC(3),ca1); cA2 =  text(2*sp+JEC(1),JEC(2),JEC(3),ca2); cA3 =  text(2*sp+KEC(1),KEC(2),KEC(3),ca3);
        case 'a'
            qA(1) = str2double(data(2))*m+p;
            qA(2) = str2double(data(3))*m+p;
            qA(3) = str2double(data(4))*m+p;
            qA(4) = str2double(data(5))*m+p;
            qA = quatnormalize(qA);
            qCA = quatmultiply(quatconj(qC),qA);
            eul_ca = quat2eul(qCA,'ZYX')*180/pi;
            ca3 = num2str(eul_ca(1)); ca2 = num2str(eul_ca(2)); ca1 = num2str(eul_ca(3));
            qEA  = quatmultiply(quatconj(qE),qA);
            [~,I1,I2,I3] = parts(quaternion(quatmultiply(qA,quatmultiply(qI,quatconj(qA)))));
            IA = [I1,I2,I3];
            [~,J1,J2,J3] = parts(quaternion(quatmultiply(qA,quatmultiply(qJ,quatconj(qA)))));
            JA = [J1,J2,J3];
            [~,K1,K2,K3] = parts(quaternion(quatmultiply(qA,quatmultiply(qK,quatconj(qA)))));
            KA = [K1,K2,K3];
            [~,I1,I2,I3] = parts(quaternion(quatmultiply(qEA,quatmultiply(qI,quatconj(qEA)))));
            ICA = [I1,I2,I3];
            [~,J1,J2,J3] = parts(quaternion(quatmultiply(qEA,quatmultiply(qJ,quatconj(qEA)))));
            JCA = [J1,J2,J3];
            [~,K1,K2,K3] = parts(quaternion(quatmultiply(qEA,quatmultiply(qK,quatconj(qEA)))));
            KCA = [K1,K2,K3];
            figure(1)
            hold on
            delete([A1,A2,A3])
            A1 = plot3([3*sp,3*sp+IA(1)],[0,IA(2)],[0,IA(3)],'r');  
            A2 = plot3([3*sp,3*sp+JA(1)],[0,JA(2)],[0,JA(3)],'g');
            A3 = plot3([3*sp,3*sp+KA(1)],[0,KA(2)],[0,KA(3)],'b');     
            figure(2)
            hold on
            delete([CA1,CA2,CA3,cA1,cA2,cA3])
            CA1 = plot3([3*sp,3*sp+ICA(1)],[0,ICA(2)],[0,ICA(3)],'r');  
            CA2 = plot3([3*sp,3*sp+JCA(1)],[0,JCA(2)],[0,JCA(3)],'g');
            CA3 = plot3([3*sp,3*sp+KCA(1)],[0,KCA(2)],[0,KCA(3)],'b');
            cA1 =  text(2*sp+IEC(1),IEC(2),IEC(3),ca1); cA2 =  text(2*sp+JEC(1),JEC(2),JEC(3),ca2); cA3 =  text(2*sp+KEC(1),KEC(2),KEC(3),ca3);;
    end 
    end
end



