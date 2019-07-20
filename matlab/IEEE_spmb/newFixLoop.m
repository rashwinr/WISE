clear all, close all, clc

instrreset
s = serial('COM11','BaudRate',115200);
s.ReadAsyncMode = 'continuous';

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
%% V1
while true
    q = ModReceive(s,WISEmod,q);
                     
    [~,I1,I2,I3] = parts(quaternion(quatmultiply(q,quatmultiply(qI,quatconj(q)))));
    I = [I1,I2,I3];
    [~,J1,J2,J3] = parts(quaternion(quatmultiply(q,quatmultiply(qJ,quatconj(q)))));
    J = [J1,J2,J3];
    [~,K1,K2,K3] = parts(quaternion(quatmultiply(q,quatmultiply(qK,quatconj(q)))));
    K = [K1,K2,K3];

    th1 = acos(dot(K,Z))

    v1 = cross(K,Z)/norm(cross(K,Z));

    v1w = v1;

    v1 = [dot(v1,I),dot(v1,J),dot(v1,K)]

    figure(1)
    hold on
    delete([E1,E2,E3,V1])
    E1 = plot3([0,I(1)],[0,I(2)],[0,I(3)],'r');  
    E2 = plot3([0,J(1)],[0,J(2)],[0,J(3)],'g');
    E3 = plot3([0,K(1)],[0,K(2)],[0,K(3)],'b');
    V1 = plot3([0,v1w(1)],[0,v1w(2)],[0,v1w(3)],'k');

 
end 

%% V2
delete([E1,E2,E3,V1])
while true
    q = ModReceive(s,WISEmod,q);
    q = match_frame(WISEmod,q);


    [~,I1,I2,I3] = parts(quaternion(quatmultiply(q,quatmultiply(qI,quatconj(q)))));
    I = [I1,I2,I3];
    [~,J1,J2,J3] = parts(quaternion(quatmultiply(q,quatmultiply(qJ,quatconj(q)))));
    J = [J1,J2,J3];
    [~,K1,K2,K3] = parts(quaternion(quatmultiply(q,quatmultiply(qK,quatconj(q)))));
    K = [K1,K2,K3];

    G = [dot(Z,I),dot(Z,J),dot(Z,K)];
    atan2(G(2),G(1))

    figure(1)
    hold on
    delete([E1,E2,E3,V2])
    E1 = plot3([0,I(1)],[0,I(2)],[0,I(3)],'r');  
    E2 = plot3([0,J(1)],[0,J(2)],[0,J(3)],'g');
    E3 = plot3([0,K(1)],[0,K(2)],[0,K(3)],'b');

           
end 

%% Check match 

delete([E1,E2,E3])

while true
    q = ModReceive(s,WISEmod,q);
    q = match_frame(data(1),q);


    [~,I1,I2,I3] = parts(quaternion(quatmultiply(q,quatmultiply(qI,quatconj(q)))));
    I = [I1,I2,I3];
    [~,J1,J2,J3] = parts(quaternion(quatmultiply(q,quatmultiply(qJ,quatconj(q)))));
    J = [J1,J2,J3];
    [~,K1,K2,K3] = parts(quaternion(quatmultiply(q,quatmultiply(qK,quatconj(q)))));
    K = [K1,K2,K3];


    figure(1)
    hold on
    delete([E1,E2,E3])
    E1 = plot3([0,I(1)],[0,I(2)],[0,I(3)],'r');  
    E2 = plot3([0,J(1)],[0,J(2)],[0,J(3)],'g');
    E3 = plot3([0,K(1)],[0,K(2)],[0,K(3)],'b');


 
end 

