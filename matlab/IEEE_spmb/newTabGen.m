clear all, close all, clc

instrreset
s = serial('COM11','BaudRate',115200);
s.ReadAsyncMode = 'continuous';
p = -1; %y = m x + p where y(-1 1) x(0 999) from rfduino z(-2^14 2^14)
m = 2/999;

j = 0;
ang = [];

q = [1,0,0,0];
qfE = [1,0,0,0];

qI = [0,1,0,0];
qJ = [0,0,1,0];
qK = [0,0,0,1];

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
V1 = plot3([0,v1(1)],[0,v1(2)],[0,v1(3)],'k');
V2 = plot3([0,v2(1)],[0,v2(2)],[0,v2(3)],'k');
WISEmod = 'b';
fopen(s);
%% tab
j = 1;
while true
    q = ModReceive(s,WISEmod,q);
    q = match_frame(WISEmod,q);


    [~,I1,I2,I3] = parts(quaternion(quatmultiply(q,quatmultiply(qI,quatconj(q)))));
    I = [I1,I2,I3];
    [~,J1,J2,J3] = parts(quaternion(quatmultiply(q,quatmultiply(qJ,quatconj(q)))));
    J = [J1,J2,J3];
    [~,K1,K2,K3] = parts(quaternion(quatmultiply(q,quatmultiply(qK,quatconj(q)))));
    K = [K1,K2,K3];

    th1 = acosd(dot(J,-Z));
    ang(j)=th1


    figure(1)
    hold on
    delete([E1,E2,E3,V1])
    E1 = plot3([0,I(1)],[0,I(2)],[0,I(3)],'r');  
    E2 = plot3([0,J(1)],[0,J(2)],[0,J(3)],'g');
    E3 = plot3([0,K(1)],[0,K(2)],[0,K(3)],'b');
    
    j = j+1;

 
end 