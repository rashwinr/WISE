clear all, close all, clc

instrreset
ser = serial('COM15','BaudRate',115200);
ser.ReadAsyncMode = 'continuous';
fopen(ser);

sp = 1.5;

thg = -1.4099*pi/180;
thl = 0.59416*pi/180;

qI = [0,1,0,0];
qJ = [0,0,1,0];
qK = [0,0,0,1];

qA = [1,0,0,0];
qB = [1,0,0,0];
qC = [1,0,0,0];
qD = [1,0,0,0];
qE = [1,0,0,0];

IA = [1 0 0]; IB = [1 0 0]; IC = [1 0 0]; ID = [1 0 0]; IE = [1 0 0];
JA = [0 1 0]; JB = [0 1 0]; JC = [0 1 0]; JD = [0 1 0]; JE = [0 1 0];
KA = [0 0 1]; KB = [0 0 1]; KC = [0 0 1]; KD = [0 0 1]; KE = [0 0 1];

figure(1)
hold on
grid on
axis equal
view([35,24])
axis([-6 6 -1 1 -1 1])

Te = text(0,0,0,'E');

E1 = plot3([0,IE(1)],[0,IE(2)],[0,IE(3)],'r');  
E2 = plot3([0,JE(1)],[0,JE(2)],[0,JE(3)],'g');
E3 = plot3([0,KE(1)],[0,KE(2)],[0,KE(3)],'b');

RC = -[sp,0,0];
Tc = text(RC(1),RC(2),RC(3),'C');

C1 = plot3([RC(1),RC(1)+IC(1)],[RC(2),RC(2)+IC(2)],[RC(3),RC(3)+IC(3)],'r');  
C2 = plot3([RC(1),RC(1)+JC(1)],[RC(2),RC(2)+JC(2)],[RC(3),RC(3)+JC(3)],'g');
C3 = plot3([RC(1),RC(1)+KC(1)],[RC(2),RC(2)+KC(2)],[RC(3),RC(3)+KC(3)],'b');

RA = RC -[sp,0,0];
Ta = text(RA(1),RA(2),RA(3),'A');

A1 = plot3([RA(1),RA(1)+IA(1)],[RA(2),RA(2)+IA(2)],[RA(3),RA(3)+IA(3)],'r');  
A2 = plot3([RA(1),RA(1)+JA(1)],[RA(2),RA(2)+JA(2)],[RA(3),RA(3)+JA(3)],'g');
A3 = plot3([RA(1),RA(1)+KA(1)],[RA(2),RA(2)+KA(2)],[RA(3),RA(3)+KA(3)],'b');

RD = [sp,0,0];
Td = text(RD(1),RD(2),RD(3),'D');

D1 = plot3([RD(1),RD(1)+ID(1)],[RD(2),RD(2)+ID(2)],[RD(3),RD(3)+ID(3)],'r');  
D2 = plot3([RD(1),RD(1)+JD(1)],[RD(2),RD(2)+JD(2)],[RD(3),RD(3)+JD(3)],'g');
D3 = plot3([RD(1),RD(1)+KD(1)],[RD(2),RD(2)+KD(2)],[RD(3),RD(3)+KD(3)],'b');

RB = RD + [sp,0,0];
Tb = text(RB(1),RB(2),RB(3),'B');

B1 = plot3([RB(1),RB(1)+IB(1)],[RB(2),RB(2)+IB(2)],[RB(3),RB(3)+IB(3)],'r');  
B2 = plot3([RB(1),RB(1)+JB(1)],[RB(2),RB(2)+JB(2)],[RB(3),RB(3)+JB(3)],'g');
B3 = plot3([RB(1),RB(1)+KB(1)],[RB(2),RB(2)+KB(2)],[RB(3),RB(3)+KB(3)],'b');

%% plot

while true
    if ser.BytesAvailable
        [qA,qB,qC,qD,qE] = TransfDataReceive(ser,qA,qB,qC,qD,qE);
        
        [~,IA(1),IA(2),IA(3)] = parts(quaternion(quatmultiply(qA,quatmultiply(qI,quatconj(qA)))));
        [~,JA(1),JA(2),JA(3)] = parts(quaternion(quatmultiply(qA,quatmultiply(qJ,quatconj(qA)))));
        [~,KA(1),KA(2),KA(3)] = parts(quaternion(quatmultiply(qA,quatmultiply(qK,quatconj(qA)))));
        
        [~,IB(1),IB(2),IB(3)] = parts(quaternion(quatmultiply(qB,quatmultiply(qI,quatconj(qB)))));
        [~,JB(1),JB(2),JB(3)] = parts(quaternion(quatmultiply(qB,quatmultiply(qJ,quatconj(qB)))));
        [~,KB(1),KB(2),KB(3)] = parts(quaternion(quatmultiply(qB,quatmultiply(qK,quatconj(qB)))));
        
        [~,IC(1),IC(2),IC(3)] = parts(quaternion(quatmultiply(qC,quatmultiply(qI,quatconj(qC)))));
        [~,JC(1),JC(2),JC(3)] = parts(quaternion(quatmultiply(qC,quatmultiply(qJ,quatconj(qC)))));
        [~,KC(1),KC(2),KC(3)] = parts(quaternion(quatmultiply(qC,quatmultiply(qK,quatconj(qC)))));
        
        [~,ID(1),ID(2),ID(3)] = parts(quaternion(quatmultiply(qD,quatmultiply(qI,quatconj(qD)))));
        [~,JD(1),JD(2),JD(3)] = parts(quaternion(quatmultiply(qD,quatmultiply(qJ,quatconj(qD)))));
        [~,KD(1),KD(2),KD(3)] = parts(quaternion(quatmultiply(qD,quatmultiply(qK,quatconj(qD)))));
        
        [~,IE(1),IE(2),IE(3)] = parts(quaternion(quatmultiply(qE,quatmultiply(qI,quatconj(qE)))));
        [~,JE(1),JE(2),JE(3)] = parts(quaternion(quatmultiply(qE,quatmultiply(qJ,quatconj(qE)))));
        [~,KE(1),KE(2),KE(3)] = parts(quaternion(quatmultiply(qE,quatmultiply(qK,quatconj(qE)))));
        
        figure(1)
        hold on
        delete([A1,A2,A3,B1,B2,B3,C1,C2,C3,D1,D2,D3,E1,E2,E3])
        

        E1 = plot3([0,IE(1)],[0,IE(2)],[0,IE(3)],'r');  
        E2 = plot3([0,JE(1)],[0,JE(2)],[0,JE(3)],'g');
        E3 = plot3([0,KE(1)],[0,KE(2)],[0,KE(3)],'b');

        C1 = plot3([RC(1),RC(1)+IC(1)],[RC(2),RC(2)+IC(2)],[RC(3),RC(3)+IC(3)],'r');  
        C2 = plot3([RC(1),RC(1)+JC(1)],[RC(2),RC(2)+JC(2)],[RC(3),RC(3)+JC(3)],'g');
        C3 = plot3([RC(1),RC(1)+KC(1)],[RC(2),RC(2)+KC(2)],[RC(3),RC(3)+KC(3)],'b');

        A1 = plot3([RA(1),RA(1)+IA(1)],[RA(2),RA(2)+IA(2)],[RA(3),RA(3)+IA(3)],'r');  
        A2 = plot3([RA(1),RA(1)+JA(1)],[RA(2),RA(2)+JA(2)],[RA(3),RA(3)+JA(3)],'g');
        A3 = plot3([RA(1),RA(1)+KA(1)],[RA(2),RA(2)+KA(2)],[RA(3),RA(3)+KA(3)],'b');

        D1 = plot3([RD(1),RD(1)+ID(1)],[RD(2),RD(2)+ID(2)],[RD(3),RD(3)+ID(3)],'r');  
        D2 = plot3([RD(1),RD(1)+JD(1)],[RD(2),RD(2)+JD(2)],[RD(3),RD(3)+JD(3)],'g');
        D3 = plot3([RD(1),RD(1)+KD(1)],[RD(2),RD(2)+KD(2)],[RD(3),RD(3)+KD(3)],'b');

        B1 = plot3([RB(1),RB(1)+IB(1)],[RB(2),RB(2)+IB(2)],[RB(3),RB(3)+IB(3)],'r');  
        B2 = plot3([RB(1),RB(1)+JB(1)],[RB(2),RB(2)+JB(2)],[RB(3),RB(3)+JB(3)],'g');
        B3 = plot3([RB(1),RB(1)+KB(1)],[RB(2),RB(2)+KB(2)],[RB(3),RB(3)+KB(3)],'b');

        
    end
    
end





