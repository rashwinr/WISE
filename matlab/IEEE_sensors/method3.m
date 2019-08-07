clear all, close all, clc

addpath('C:\Users\fabio\Documents\MATLAB\Functions')

instrreset
s = serial('COM11','BaudRate',115200);
s.ReadAsyncMode = 'continuous';

q = [1,0,0,0];
qref = [1,0,0,0];
thref = 0;

qI = [0,1,0,0];
qJ = [0,0,1,0];
qK = [0,0,0,1];

I = [1 0 0]; 
J = [0 1 0]; 
K = [0 0 1]; 

X = [1 0 0]; 
Y = [0 1 0]; 
Z = [0 0 1]; 

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

TXT = text(qI(2),qI(3),qI(4),' ');
THTX = text(qK(2),qK(3),qK(4),' ');
TxR1 = text(qK(2),qK(3),qK(4),' ');
TxR2 = text(qK(2),qK(3),qK(4),' ');
TxR3 = text(qK(2),qK(3),qK(4),' ');
R1 = plot3([0,0],[0,0],[0,0],'c');  
R2 = plot3([0,0],[0,0],[0,0],'c');
R3 = plot3([0,0],[0,0],[0,0],'c');

fopen(s);

WISEmod = 'RF';

switch WISEmod
    case 'LF'
        WISEmod = 'a';
    case 'RF'
        WISEmod = 'b';
    case 'LA'
        WISEmod = 'c';
    case 'RA'
        WISEmod = 'd';
    case 'B'
        WISEmod = 'e';
end
%% catch transf 

while true
    q = ModReceive(s,WISEmod,q);

    [~,I1,I2,I3] = parts(quaternion(quatmultiply(q,quatmultiply(qI,quatconj(q)))));
    I = [I1,I2,I3];
    [~,J1,J2,J3] = parts(quaternion(quatmultiply(q,quatmultiply(qJ,quatconj(q)))));
    J = [J1,J2,J3];
    [~,K1,K2,K3] = parts(quaternion(quatmultiply(q,quatmultiply(qK,quatconj(q)))));
    K = [K1,K2,K3];

    disp(dot(I,X))
    disp(quatconj(q))

    figure(1)
    hold on
    delete([E1,E2,E3,TXT])
    E1 = plot3([0,I(1)],[0,I(2)],[0,I(3)],'r');  
    E2 = plot3([0,J(1)],[0,J(2)],[0,J(3)],'g');
    E3 = plot3([0,K(1)],[0,K(2)],[0,K(3)],'b');
 
end 

%% check transf

delete([E1,E2,E3])

while true
    q = ModReceive(s,WISEmod,q);
    q = box_transf(WISEmod,q);

    [~,I1,I2,I3] = parts(quaternion(quatmultiply(q,quatmultiply(qI,quatconj(q)))));
    I = [I1,I2,I3];
    [~,J1,J2,J3] = parts(quaternion(quatmultiply(q,quatmultiply(qJ,quatconj(q)))));
    J = [J1,J2,J3];
    [~,K1,K2,K3] = parts(quaternion(quatmultiply(q,quatmultiply(qK,quatconj(q)))));
    K = [K1,K2,K3];
    
    disp(dot(K,Z))
    
    figure(1)
    hold on
    delete([E1,E2,E3])
    E1 = plot3([0,I(1)],[0,I(2)],[0,I(3)],'r');  
    E2 = plot3([0,J(1)],[0,J(2)],[0,J(3)],'g');
    E3 = plot3([0,K(1)],[0,K(2)],[0,K(3)],'b');
 
end 

%% find correrction 

delete([E1,E2,E3])

while true
    q = ModReceive(s,WISEmod,q);
    q = box_transf(WISEmod,q);

    [~,I1,I2,I3] = parts(quaternion(quatmultiply(q,quatmultiply(qI,quatconj(q)))));
    I = [I1,I2,I3];
    [~,J1,J2,J3] = parts(quaternion(quatmultiply(q,quatmultiply(qJ,quatconj(q)))));
    J = [J1,J2,J3];
    [~,K1,K2,K3] = parts(quaternion(quatmultiply(q,quatmultiply(qK,quatconj(q)))));
    K = [K1,K2,K3];
    
    disp(real(acosd(dot(I,Z))))
    disp(dot(K,X))

    figure(1)
    hold on
    delete([E1,E2,E3,TXT])
    E1 = plot3([0,I(1)],[0,I(2)],[0,I(3)],'r');  
    E2 = plot3([0,J(1)],[0,J(2)],[0,J(3)],'g');
    E3 = plot3([0,K(1)],[0,K(2)],[0,K(3)],'b');
    TXT = text(Z(1),Z(2),Z(3)+0.5,num2str(real(acosd(dot(I,X)))));
 
end 

%% New Test

    %% Part one
    tel = 0;
    while tel<7 % grab q1
        tic
        q = ModReceive(s,WISEmod,q);
        q1 = box_transf(WISEmod,q);
        disp(q1)
        tel = tel + toc;
    end

    %% Part two
    
     tel = 0;
    while tel<7
        tic
        q = ModReceive(s,WISEmod,q);
        q2 = box_transf(WISEmod,q);
        disp(q2)
        tel = tel + toc;
    end

qRel = quatmultiply(quatconj(q1),q2);
AxAng = quat2axang(qRel);
disp(AxAng(4)*180/pi)
disp(dot(AxAng(1:3),X))

%% test X

delete([E1,E2,E3])

tel = 0;
while tel<1 %pre-listening
    tic
    q = ModReceive(s,WISEmod,q);
    qref = box_transf(WISEmod,q);

    [~,I1,I2,I3] = parts(quaternion(quatmultiply(qref,quatmultiply(qI,quatconj(qref)))));
    Iref = [I1,I2,I3];
    [~,J1,J2,J3] = parts(quaternion(quatmultiply(qref,quatmultiply(qJ,quatconj(qref)))));
    J = [J1,J2,J3];
    [~,K1,K2,K3] = parts(quaternion(quatmultiply(qref,quatmultiply(qK,quatconj(qref)))));
    K = [K1,K2,K3];


    figure(1)
    hold on
    delete([E1,E2,E3])
    E1 = plot3([0,Iref(1)],[0,Iref(2)],[0,Iref(3)],'r--');  
    E2 = plot3([0,J(1)],[0,J(2)],[0,J(3)],'g');
    E3 = plot3([0,K(1)],[0,K(2)],[0,K(3)],'b');

    tel = tel + toc;
 
end 

R1 = plot3([0,Iref(1)],[0,Iref(2)],[0,Iref(3)],'c--'); 
TxR1 = text(Iref(1),Iref(2),Iref(3),'i');
R2 = plot3([0,J(1)],[0,J(2)],[0,J(3)],'c');
TxR2 = text(J(1),J(2),J(3),'j');
R3 = plot3([0,K(1)],[0,K(2)],[0,K(3)],'c');
TxR3 = text(K(1),K(2),K(3),'k');


while true
    q = ModReceive(s,WISEmod,q);
    q = box_transf(WISEmod,q);
    
    AxAng = quat2axang(quatmultiply(quatconj(qref),q));
    ang = AxAng(4);
    
    if dot(X,AxAng(1:3))<0
        ang = -ang;
    end
    
    if abs(ang)>0
        [~,I1,I2,I3] = parts(quaternion(quatmultiply(q,quatmultiply(qI,quatconj(q)))));
        I = [I1,I2,I3];
        [~,J1,J2,J3] = parts(quaternion(quatmultiply(q,quatmultiply(qJ,quatconj(q)))));
        J = [J1,J2,J3];
        [~,K1,K2,K3] = parts(quaternion(quatmultiply(q,quatmultiply(qK,quatconj(q)))));
        K = [K1,K2,K3];
        
        D = dot(I,Iref);
        TH = real(acosd(D));


        figure(1)
        hold on
        delete([E1,E2,E3,TXT])
        E1 = plot3([0,I(1)],[0,I(2)],[0,I(3)],'r--');  
        E2 = plot3([0,J(1)],[0,J(2)],[0,J(3)],'g');
        E3 = plot3([0,K(1)],[0,K(2)],[0,K(3)],'b');
        TXT = text(Iref(1),Iref(2),Iref(3)+0.5,num2str(TH));
    end
 
end 


%% test Y

delete([E1,E2,E3,R1,R2,R3,TXT,TxR1,TxR2,TxR3])

tel = 0;
while tel<1 %pre-listening
    tic
    q = ModReceive(s,WISEmod,q);
    qref = box_transf(WISEmod,q);

    [~,I1,I2,I3] = parts(quaternion(quatmultiply(qref,quatmultiply(qI,quatconj(qref)))));
    I = [I1,I2,I3];
    [~,J1,J2,J3] = parts(quaternion(quatmultiply(qref,quatmultiply(qJ,quatconj(qref)))));
    Jref = [J1,J2,J3];
    [~,K1,K2,K3] = parts(quaternion(quatmultiply(qref,quatmultiply(qK,quatconj(qref)))));
    K = [K1,K2,K3];


    figure(1)
    hold on
    delete([E1,E2,E3])
    E1 = plot3([0,I(1)],[0,I(2)],[0,I(3)],'r');  
    E2 = plot3([0,Jref(1)],[0,Jref(2)],[0,Jref(3)],'g--');
    E3 = plot3([0,K(1)],[0,K(2)],[0,K(3)],'b');

    tel = tel + toc;
 
end 

R1 = plot3([0,I(1)],[0,I(2)],[0,I(3)],'c'); 
TxR1 = text(I(1),I(2),I(3),'i');
R2 = plot3([0,Jref(1)],[0,Jref(2)],[0,Jref(3)],'c--');
TxR2 = text(Jref(1),Jref(2),Jref(3),'j');
R3 = plot3([0,K(1)],[0,K(2)],[0,K(3)],'c');
TxR3 = text(K(1),K(2),K(3),'k');


while true
    q = ModReceive(s,WISEmod,q);
    q = box_transf(WISEmod,q);
    
    AxAng = quat2axang(quatmultiply(quatconj(qref),q));
    ang = AxAng(4);
    
    if dot(Y,AxAng(1:3))<0
        ang = -ang;
    end
    
    if abs(ang)>0
        [~,I1,I2,I3] = parts(quaternion(quatmultiply(q,quatmultiply(qI,quatconj(q)))));
        I = [I1,I2,I3];
        [~,J1,J2,J3] = parts(quaternion(quatmultiply(q,quatmultiply(qJ,quatconj(q)))));
        J = [J1,J2,J3];
        [~,K1,K2,K3] = parts(quaternion(quatmultiply(q,quatmultiply(qK,quatconj(q)))));
        K = [K1,K2,K3];
        
        D = dot(J,Jref);
        TH = real(acosd(D));


        figure(1)
        hold on
        delete([E1,E2,E3,TXT])
        E1 = plot3([0,I(1)],[0,I(2)],[0,I(3)],'r');  
        E2 = plot3([0,J(1)],[0,J(2)],[0,J(3)],'g--');
        E3 = plot3([0,K(1)],[0,K(2)],[0,K(3)],'b');
        TXT = text(Jref(1),Jref(2),Jref(3)-0.5,num2str(TH));
    end
 
end 

%% test Z

delete([E1,E2,E3,R1,R2,R3,TXT,TxR1,TxR2,TxR3])

tel = 0;
while tel<1 %pre-listening
    tic
    q = ModReceive(s,WISEmod,q);
    qref = box_transf(WISEmod,q);

    [~,I1,I2,I3] = parts(quaternion(quatmultiply(qref,quatmultiply(qI,quatconj(qref)))));
    I = [I1,I2,I3];
    [~,J1,J2,J3] = parts(quaternion(quatmultiply(qref,quatmultiply(qJ,quatconj(qref)))));
    J = [J1,J2,J3];
    [~,K1,K2,K3] = parts(quaternion(quatmultiply(qref,quatmultiply(qK,quatconj(qref)))));
    Kref = [K1,K2,K3];


    figure(1)
    hold on
    delete([E1,E2,E3])
    E1 = plot3([0,I(1)],[0,I(2)],[0,I(3)],'r');  
    E2 = plot3([0,J(1)],[0,J(2)],[0,J(3)],'g');
    E3 = plot3([0,K(1)],[0,K(2)],[0,K(3)],'b--');

    tel = tel + toc;
 
end 

R1 = plot3([0,I(1)],[0,I(2)],[0,I(3)],'c'); 
TxR1 = text(I(1),I(2),I(3),'i');
R2 = plot3([0,J(1)],[0,J(2)],[0,J(3)],'c');
TxR2 = text(J(1),J(2),J(3),'j');
R3 = plot3([0,Kref(1)],[0,Kref(2)],[0,Kref(3)],'c--');
TxR3 = text(Kref(1),Kref(2),Kref(3),'k');


while true
    q = ModReceive(s,WISEmod,q);
    q = box_transf(WISEmod,q);
    
    AxAng = quat2axang(quatmultiply(quatconj(qref),q));
    ang = AxAng(4);
    
    if dot(Z,AxAng(1:3))<0
        ang = -ang;
    end
    
    if abs(ang)>0
        [~,I1,I2,I3] = parts(quaternion(quatmultiply(q,quatmultiply(qI,quatconj(q)))));
        I = [I1,I2,I3];
        [~,J1,J2,J3] = parts(quaternion(quatmultiply(q,quatmultiply(qJ,quatconj(q)))));
        J = [J1,J2,J3];
        [~,K1,K2,K3] = parts(quaternion(quatmultiply(q,quatmultiply(qK,quatconj(q)))));
        K = [K1,K2,K3];
        
        D = dot(K,Kref);
        TH = real(acosd(D));

        figure(1)
        hold on
        delete([E1,E2,E3,TXT])
        E1 = plot3([0,I(1)],[0,I(2)],[0,I(3)],'r');  
        E2 = plot3([0,J(1)],[0,J(2)],[0,J(3)],'g');
        E3 = plot3([0,K(1)],[0,K(2)],[0,K(3)],'b--');
        TXT = text(Kref(1),Kref(2),Kref(3)+0.5,num2str(TH));
    end
 
end 


