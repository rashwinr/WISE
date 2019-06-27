%% Initialization section
delete(instrfind({'Port'},{'COM15'}))
clear all; close all;clc;
ser = serial('COM15','BaudRate',115200,'InputBufferSize',100);
ser.ReadAsyncMode = 'continuous';
fopen(ser);k=[];

%%
close all, clc
q = [1,0,0,0];
qfE = [1,0,0,0];

G = [0,0,-1];
qI = [0,1,0,0];
qJ = [0,0,1,0];
qK = [0,0,0,1];

thl_old = 0;
thg_old = 0;

qC = [1,0,0,0];qD = [1,0,0,0];qA = [1,0,0,0];qB = [1,0,0,0];qE = [1,0,0,0];

I = [1 0 0]; 
J = [0 1 0]; 
K = [0 0 1]; 

X = [1 0 0]; 
Y = [0 1 0]; 
Z = [0 0 1]; 

v1 = [0 0 0];
v2 = [0 0 0];

figure(1)
hold on
grid on
axis equal
axis([-1 2 -1 2 -1 2])
view([35,24])
plot3([0,qI(2)],[0,qI(3)],[0,qI(4)],'k');
text(qI(2),qI(3),qI(4),'i');
plot3([0,qJ(2)],[0,qJ(3)],[0,qJ(4)],'k');
text(qJ(2),qJ(3),qJ(4),'j');
plot3([0,qK(2)],[0,qK(3)],[0,qK(4)],'k');
text(qK(2),qK(3),qK(4),'k');
E1 = plot3([0,I(1)],[0,I(2)],[0,I(3)],'r');  
E2 = plot3([0,J(1)],[0,J(2)],[0,J(3)],'g');
E3 = plot3([0,K(1)],[0,K(2)],[0,K(3)],'b');

%%

lc = 1;

while lc
    if ser.BytesAvailable
       [qA,qB,qC,qD,qE] = DataReceive(ser,qA,qB,qC,qD,qE,0,0);
       
       qX = quatmultiply(qE,quatmultiply(qI,quatconj(qE)));
       qY = quatmultiply(qE,quatmultiply(qJ,quatconj(qE)));
       
       thg = atan2(dot(G,qY(2:4)),dot(G,qX(2:4)));
       disp(strcat('Mounting offset: ',num2str(thg*180/pi)))
       
       [qA,qB,qC,qD,qE] = DataReceive(ser,qA,qB,qC,qD,qE,thg,0);
       qX = quatmultiply(qE,quatmultiply(qI,quatconj(qE)));
       qZ = quatmultiply(qE,quatmultiply(qK,quatconj(qE)));
       
       thl = atan2(dot(G,qZ(2:4)),dot(G,qX(2:4)));
       disp(strcat('Lumbar spine: ',num2str(thl*180/pi)))
       
       
       [~,I1,I2,I3] = parts(quaternion(quatmultiply(qE,quatmultiply(qI,quatconj(qE)))));
       I = [I1,I2,I3];
       [~,J1,J2,J3] = parts(quaternion(quatmultiply(qE,quatmultiply(qJ,quatconj(qE)))));
       J = [J1,J2,J3];
       [~,K1,K2,K3] = parts(quaternion(quatmultiply(qE,quatmultiply(qK,quatconj(qE)))));
       K = [K1,K2,K3];
       
       figure(1)
       hold on
       delete([E1,E2,E3])
       E1 = plot3([0,I(1)],[0,I(2)],[0,I(3)],'r');  
       E2 = plot3([0,J(1)],[0,J(2)],[0,J(3)],'g');
       E3 = plot3([0,K(1)],[0,K(2)],[0,K(3)],'b');
       
       if thl_old == thl && thg_old == thg
           lc = 0;
       else 
           thl_old = thl;
           thg_old = thg;
       end
    end
end

%%
TXT = text(-1,0,'initial');
while true
    if ser.BytesAvailable
       [qA,qB,qC,qD,qE] = DataReceive(ser,qA,qB,qC,qD,qE,0,0);
           
       [~,I1,I2,I3] = parts(quaternion(quatmultiply(qE,quatmultiply(qI,quatconj(qE)))));
       I = [I1,I2,I3];
       [~,J1,J2,J3] = parts(quaternion(quatmultiply(qE,quatmultiply(qJ,quatconj(qE)))));
       J = [J1,J2,J3];
       [~,K1,K2,K3] = parts(quaternion(quatmultiply(qE,quatmultiply(qK,quatconj(qE)))));
       K = [K1,K2,K3];
       
       figure(1)
       hold on
       delete([E1,E2,E3,TXT])
       E1 = plot3([0,I(1)],[0,I(2)],[0,I(3)],'r');  
       E2 = plot3([0,J(1)],[0,J(2)],[0,J(3)],'g');
       E3 = plot3([0,K(1)],[0,K(2)],[0,K(3)],'b');
       TXT = text(-1,0,'initial');
       
       pause(1)
       qE = [0,0,0,0];
       
       [qA,qB,qC,qD,qE] = DataReceive(ser,qA,qB,qC,qD,qE,thg,0);
           
       [~,I1,I2,I3] = parts(quaternion(quatmultiply(qE,quatmultiply(qI,quatconj(qE)))));
       I = [I1,I2,I3];
       [~,J1,J2,J3] = parts(quaternion(quatmultiply(qE,quatmultiply(qJ,quatconj(qE)))));
       J = [J1,J2,J3];
       [~,K1,K2,K3] = parts(quaternion(quatmultiply(qE,quatmultiply(qK,quatconj(qE)))));
       K = [K1,K2,K3];
       
       
       figure(1)
       hold on
       delete([E1,E2,E3,TXT])
       E1 = plot3([0,I(1)],[0,I(2)],[0,I(3)],'r');  
       E2 = plot3([0,J(1)],[0,J(2)],[0,J(3)],'g');
       E3 = plot3([0,K(1)],[0,K(2)],[0,K(3)],'b');
       TXT = text(-1,0,num2str(dot(G,J)));
       
    end
    pause(1)
    qE = [0,0,0,0];
end

%%
TXT = text(-1,0,'initial');
while true
    if ser.BytesAvailable
       [qA,qB,qC,qD,qE] = DataReceive(ser,qA,qB,qC,qD,qE,thg,0);
           
       [~,I1,I2,I3] = parts(quaternion(quatmultiply(qE,quatmultiply(qI,quatconj(qE)))));
       I = [I1,I2,I3];
       [~,J1,J2,J3] = parts(quaternion(quatmultiply(qE,quatmultiply(qJ,quatconj(qE)))));
       J = [J1,J2,J3];
       [~,K1,K2,K3] = parts(quaternion(quatmultiply(qE,quatmultiply(qK,quatconj(qE)))));
       K = [K1,K2,K3];
       
       figure(1)
       hold on
       delete([E1,E2,E3,TXT])
       E1 = plot3([0,I(1)],[0,I(2)],[0,I(3)],'r');  
       E2 = plot3([0,J(1)],[0,J(2)],[0,J(3)],'g');
       E3 = plot3([0,K(1)],[0,K(2)],[0,K(3)],'b');
       TXT = text(-1,0,'initial');
       
       pause(1)
       qE = [0,0,0,0];
       
       [qA,qB,qC,qD,qE] = DataReceive(ser,qA,qB,qC,qD,qE,thg,thl);
           
       [~,I1,I2,I3] = parts(quaternion(quatmultiply(qE,quatmultiply(qI,quatconj(qE)))));
       I = [I1,I2,I3];
       [~,J1,J2,J3] = parts(quaternion(quatmultiply(qE,quatmultiply(qJ,quatconj(qE)))));
       J = [J1,J2,J3];
       [~,K1,K2,K3] = parts(quaternion(quatmultiply(qE,quatmultiply(qK,quatconj(qE)))));
       K = [K1,K2,K3];
       
       
       figure(1)
       hold on
       delete([E1,E2,E3,TXT])
       E1 = plot3([0,I(1)],[0,I(2)],[0,I(3)],'r');  
       E2 = plot3([0,J(1)],[0,J(2)],[0,J(3)],'g');
       E3 = plot3([0,K(1)],[0,K(2)],[0,K(3)],'b');
       TXT = text(-1,0,num2str(dot(G,J)));
       
    end
    pause(1)
    qE = [0,0,0,0];
end


%%

while true
    if ser.BytesAvailable
       [qA,qB,qC,qD,qE] = DataReceive(ser,qA,qB,qC,qD,qE,0,0);
           
       [~,I1,I2,I3] = parts(quaternion(quatmultiply(qE,quatmultiply(qI,quatconj(qE)))));
       I = [I1,I2,I3];
       [~,J1,J2,J3] = parts(quaternion(quatmultiply(qE,quatmultiply(qJ,quatconj(qE)))));
       J = [J1,J2,J3];
       [~,K1,K2,K3] = parts(quaternion(quatmultiply(qE,quatmultiply(qK,quatconj(qE)))));
       K = [K1,K2,K3];
       
       figure(1)
       hold on
       delete([E1,E2,E3])
       E1 = plot3([0,I(1)],[0,I(2)],[0,I(3)],'r');  
       E2 = plot3([0,J(1)],[0,J(2)],[0,J(3)],'g');
       E3 = plot3([0,K(1)],[0,K(2)],[0,K(3)],'b');
    end
end

%%
TXT = text(-1,0,'initial');
while true
    if ser.BytesAvailable
       [qA,qB,qC,qD,qE] = DataReceive(ser,qA,qB,qC,qD,qE,0,0);
           
       [~,I1,I2,I3] = parts(quaternion(quatmultiply(qE,quatmultiply(qI,quatconj(qE)))));
       I = [I1,I2,I3];
       [~,J1,J2,J3] = parts(quaternion(quatmultiply(qE,quatmultiply(qJ,quatconj(qE)))));
       J = [J1,J2,J3];
       [~,K1,K2,K3] = parts(quaternion(quatmultiply(qE,quatmultiply(qK,quatconj(qE)))));
       K = [K1,K2,K3];
       
       figure(1)
       hold on
       delete([E1,E2,E3,TXT])
       E1 = plot3([0,I(1)],[0,I(2)],[0,I(3)],'r');  
       E2 = plot3([0,J(1)],[0,J(2)],[0,J(3)],'g');
       E3 = plot3([0,K(1)],[0,K(2)],[0,K(3)],'b');
       TXT = text(-1,0,'initial');
       
       pause(1)
       qE = [0,0,0,0];
       
       [qA,qB,qC,qD,qE] = DataReceive(ser,qA,qB,qC,qD,qE,thg,0);
           
       [~,I1,I2,I3] = parts(quaternion(quatmultiply(qE,quatmultiply(qI,quatconj(qE)))));
       I = [I1,I2,I3];
       [~,J1,J2,J3] = parts(quaternion(quatmultiply(qE,quatmultiply(qJ,quatconj(qE)))));
       J = [J1,J2,J3];
       [~,K1,K2,K3] = parts(quaternion(quatmultiply(qE,quatmultiply(qK,quatconj(qE)))));
       K = [K1,K2,K3];
       
       
       figure(1)
       hold on
       delete([E1,E2,E3,TXT])
       E1 = plot3([0,I(1)],[0,I(2)],[0,I(3)],'r');  
       E2 = plot3([0,J(1)],[0,J(2)],[0,J(3)],'g');
       E3 = plot3([0,K(1)],[0,K(2)],[0,K(3)],'b');
       TXT = text(-1,0,num2str(dot(G,J)));
       
    end
    pause(1)
    qE = [0,0,0,0];
end

%%
thg = 1.2777*pi/180;
thl = 0.43898*pi/180;

TXT = text(-1,0,'initial');
while true
    if ser.BytesAvailable
       [qA,qB,qC,qD,qE] = DataReceive(ser,qA,qB,qC,qD,qE,thg,0);
           
       [~,I1,I2,I3] = parts(quaternion(quatmultiply(qE,quatmultiply(qI,quatconj(qE)))));
       I = [I1,I2,I3];
       [~,J1,J2,J3] = parts(quaternion(quatmultiply(qE,quatmultiply(qJ,quatconj(qE)))));
       J = [J1,J2,J3];
       [~,K1,K2,K3] = parts(quaternion(quatmultiply(qE,quatmultiply(qK,quatconj(qE)))));
       K = [K1,K2,K3];
       
       figure(1)
       hold on
       delete([E1,E2,E3,TXT])
       E1 = plot3([0,I(1)],[0,I(2)],[0,I(3)],'r');  
       E2 = plot3([0,J(1)],[0,J(2)],[0,J(3)],'g');
       E3 = plot3([0,K(1)],[0,K(2)],[0,K(3)],'b');
       TXT = text(-1,0,'initial');
       
       pause(1)
       qE = [0,0,0,0];
       
       [qA,qB,qC,qD,qE] = DataReceive(ser,qA,qB,qC,qD,qE,thg,thl);
           
       [~,I1,I2,I3] = parts(quaternion(quatmultiply(qE,quatmultiply(qI,quatconj(qE)))));
       I = [I1,I2,I3];
       [~,J1,J2,J3] = parts(quaternion(quatmultiply(qE,quatmultiply(qJ,quatconj(qE)))));
       J = [J1,J2,J3];
       [~,K1,K2,K3] = parts(quaternion(quatmultiply(qE,quatmultiply(qK,quatconj(qE)))));
       K = [K1,K2,K3];
       
       
       figure(1)
       hold on
       delete([E1,E2,E3,TXT])
       E1 = plot3([0,I(1)],[0,I(2)],[0,I(3)],'r');  
       E2 = plot3([0,J(1)],[0,J(2)],[0,J(3)],'g');
       E3 = plot3([0,K(1)],[0,K(2)],[0,K(3)],'b');
       TXT = text(-1,0,num2str(dot(G,J)));
       
    end
    pause(1)
    qE = [0,0,0,0];
end
