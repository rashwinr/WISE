clear all, close all, clc

addpath('C:\Users\fabio\Documents\MATLAB\Functions')

delete(instrfind({'Port'},{'COM11'}))
s = serial('COM11','BaudRate',115200);
s.ReadAsyncMode = 'continuous';
p = -1; %y = m x + p where y(-1 1) x(0 999) from rfduino z(-2^14 2^14)
m = 2/999;

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

wQ1 = [0 0 0];
wRotAx1 = [0 0 0];
wRotAx2 = [0 0 0];

figure(1)
hold on
grid on
axis equal
axis([-1 1 -1 1 -1 1])
view([35,24])
TXT = text(qI(2),qI(3),qI(4),' ');
THTX = text(qK(2),qK(3),qK(4),' ');
TxR1 = text(qK(2),qK(3),qK(4),' ');
TxR2 = text(qK(2),qK(3),qK(4),' ');
TxR3 = text(qK(2),qK(3),qK(4),' ');
R1 = plot3([0,0],[0,0],[0,0],'c');  
R2 = plot3([0,0],[0,0],[0,0],'c');
R3 = plot3([0,0],[0,0],[0,0],'c');
E1 = plot3([0,I(1)],[0,I(2)],[0,I(3)],'r');  
E2 = plot3([0,J(1)],[0,J(2)],[0,J(3)],'g');
E3 = plot3([0,K(1)],[0,K(2)],[0,K(3)],'b');
WQ1 = plot3([0,wQ1(1)],[0,wQ1(2)],[0,wQ1(3)],'k');
WRotAx1 = plot3([0,wRotAx1(1)],[0,wRotAx1(2)],[0,wRotAx1(3)],'k');
WRotAx2 = plot3([0,wRotAx2(1)],[0,wRotAx2(2)],[0,wRotAx2(3)],'k');

fopen(s);

WISEmod = 'd';
%% catch Q1

tel = 0;
while tel<1 %pre-listening
    tic
    qref = ModReceive(s,WISEmod,qref);

    [~,I1,I2,I3] = parts(quaternion(quatmultiply(qref,quatmultiply(qI,quatconj(qref)))));
    I = [I1,I2,I3];
    [~,J1,J2,J3] = parts(quaternion(quatmultiply(qref,quatmultiply(qJ,quatconj(qref)))));
    J = [J1,J2,J3];
    [~,K1,K2,K3] = parts(quaternion(quatmultiply(qref,quatmultiply(qK,quatconj(qref)))));
    K = [K1,K2,K3];


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
R3 = plot3([0,K(1)],[0,K(2)],[0,K(3)],'c');
TxR3 = text(K(1),K(2),K(3),'k');    
   
disp('GO')

listQ1 = [];

j = 1;
while j<360 %rotation capturing

        q = ModReceive(s,WISEmod,q);
        q1 = quatmultiply(quatconj(qref),q);
        Axang = quat2axang(q1);
        rotAx = Axang(1:3);
        th = Axang(4);
        if dot(Z,rotAx)<0
            rotAx = -rotAx;
            th = -th;
        end
        if abs(th-thref)>=1*pi/180 && abs(th)>15*pi/180
            
            th1 = acos(dot(Z,rotAx));
            Q1 = cross(Z,rotAx);
            Q1 = Q1/norm(Q1);
            listQ1(1,j) = th1;
            listQ1(2:4,j) = Q1;

            [~,I1,I2,I3] = parts(quaternion(quatmultiply(q,quatmultiply(qI,quatconj(q)))));
            I = [I1,I2,I3];
            [~,J1,J2,J3] = parts(quaternion(quatmultiply(q,quatmultiply(qJ,quatconj(q)))));
            J = [J1,J2,J3];
            [~,K1,K2,K3] = parts(quaternion(quatmultiply(q,quatmultiply(qK,quatconj(q)))));
            K = [K1,K2,K3];
            [~,w1,w2,w3] = parts(quaternion(quatmultiply(qref,quatmultiply(PureQuat(Q1),quatconj(qref)))));
            wQ1 = [w1,w2,w3];
            [~,w1,w2,w3] = parts(quaternion(quatmultiply(qref,quatmultiply(PureQuat(rotAx),quatconj(qref)))));
            wRotAx1 = [w1,w2,w3];

            figure(1)
            hold on
            delete([E1,E2,E3,WQ1,WRotAx1,THTX])
            E1 = plot3([0,I(1)],[0,I(2)],[0,I(3)],'r');  
            E2 = plot3([0,J(1)],[0,J(2)],[0,J(3)],'g');
            E3 = plot3([0,K(1)],[0,K(2)],[0,K(3)],'b--');
            WQ1 = plot3([0,wQ1(1)],[0,wQ1(2)],[0,wQ1(3)],'k');
            WRotAx1 = plot3([0,wRotAx1(1)],[0,wRotAx1(2)],[0,wRotAx1(3)],'k--');
            THTX = text(qK(2),qK(3),qK(4)+0.5,num2str(th*180/pi));

            thref = th;
            j = j + 1;
        end 
end

figure(1)
delete([WQ1,WRotAx1,R1,R2,R3,THTX,TxR1,TxR2,TxR3])

listQ1(:,1:20) = [];
len = size(listQ1);
listQ1(:,len(2)-20:len(2)) = [];
TH1 = mean(listQ1(1,:));
ind = find(abs(listQ1(1,:)-TH1)<=0.0001);
TH1 = listQ1(1,ind(1));
Q1 = listQ1(2:4,ind(1));
disp(TH1)
disp(Q1')

%% check Q1

tel = 0;
while tel<1 %pre-listening
    tic
    qref = ModReceive(s,WISEmod,qref);
    qref = box_transf(WISEmod,qref);

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
    E3 = plot3([0,Kref(1)],[0,Kref(2)],[0,Kref(3)],'b--');

    tel = tel + toc;
 
end 

R1 = plot3([0,I(1)],[0,I(2)],[0,I(3)],'c'); 
TxR1 = text(I(1),I(2),I(3),'i');
R2 = plot3([0,J(1)],[0,J(2)],[0,J(3)],'c');
TxR2 = text(J(1),J(2),J(3),'j');
R3 = plot3([0,Kref(1)],[0,Kref(2)],[0,Kref(3)],'c');
TxR3 = text(Kref(1),Kref(2),Kref(3),'k');   

   
disp('GO')

listQ1 = [];

j = 1;
while true %rotation capturing

        q = ModReceive(s,WISEmod,q);
        q = box_transf(WISEmod,q);
           
        [~,I1,I2,I3] = parts(quaternion(quatmultiply(q,quatmultiply(qI,quatconj(q)))));
        I = [I1,I2,I3];
        [~,J1,J2,J3] = parts(quaternion(quatmultiply(q,quatmultiply(qJ,quatconj(q)))));
        J = [J1,J2,J3];
        [~,K1,K2,K3] = parts(quaternion(quatmultiply(q,quatmultiply(qK,quatconj(q)))));
        K = [K1,K2,K3];

        figure(1)
        hold on
        delete([E1,E2,E3,TXT])
        E1 = plot3([0,I(1)],[0,I(2)],[0,I(3)],'r');  
        E2 = plot3([0,J(1)],[0,J(2)],[0,J(3)],'g');
        E3 = plot3([0,K(1)],[0,K(2)],[0,K(3)],'b--');
        TXT = text(qI(2)+0.5,qI(3),qI(4),num2str(acosd(dot(Kref,K))));
        
end 


%% catch TH2

figure(1)
delete([TXT,R1,R2,R3,TXT,TxR1,TxR2,TxR3])

tel = 0;
while tel<1 %pre-listening
    tic
    qref = ModReceive(s,WISEmod,qref);
    qref = box_transf(WISEmod,qref);

    [~,I1,I2,I3] = parts(quaternion(quatmultiply(qref,quatmultiply(qI,quatconj(qref)))));
    I = [I1,I2,I3];
    [~,J1,J2,J3] = parts(quaternion(quatmultiply(qref,quatmultiply(qJ,quatconj(qref)))));
    J = [J1,J2,J3];
    [~,K1,K2,K3] = parts(quaternion(quatmultiply(qref,quatmultiply(qK,quatconj(qref)))));
    K = [K1,K2,K3];


    figure(1)
    hold on
    delete([E1,E2,E3])
    E1 = plot3([0,I(1)],[0,I(2)],[0,I(3)],'r--');  
    E2 = plot3([0,J(1)],[0,J(2)],[0,J(3)],'g');
    E3 = plot3([0,K(1)],[0,K(2)],[0,K(3)],'b');

    tel = tel + toc;
 
end 

R1 = plot3([0,I(1)],[0,I(2)],[0,I(3)],'c'); 
TxR1 = text(I(1),I(2),I(3),'i');
R2 = plot3([0,J(1)],[0,J(2)],[0,J(3)],'c');
TxR2 = text(J(1),J(2),J(3),'j');
R3 = plot3([0,K(1)],[0,K(2)],[0,K(3)],'c');
TxR3 = text(K(1),K(2),K(3),'k');    
   
disp('GO')

listTH2 = [];

j = 1;
while j<360 %rotation capturing

        q = ModReceive(s,WISEmod,q);
        q = box_transf(WISEmod,q);
        q2 = quatmultiply(quatconj(qref),q);
        Axang = quat2axang(q2);
        rotAx = Axang(1:3);
        th = Axang(4);
        if dot(X,rotAx)<0
            rotAx = -rotAx;
            th = -th;
        end
        if abs(th-thref)>=1*pi/180 && abs(th)>15*pi/180
            
            th2 = atan2(rotAx(2),rotAx(1));
            listTH2(j) = th2;

            [~,I1,I2,I3] = parts(quaternion(quatmultiply(q,quatmultiply(qI,quatconj(q)))));
            I = [I1,I2,I3];
            [~,J1,J2,J3] = parts(quaternion(quatmultiply(q,quatmultiply(qJ,quatconj(q)))));
            J = [J1,J2,J3];
            [~,K1,K2,K3] = parts(quaternion(quatmultiply(q,quatmultiply(qK,quatconj(q)))));
            K = [K1,K2,K3];
            [~,w1,w2,w3] = parts(quaternion(quatmultiply(qref,quatmultiply(PureQuat(rotAx),quatconj(qref)))));
            wRotAx1 = [w1,w2,w3];

            figure(1)
            hold on
            delete([E1,E2,E3,WQ1,WRotAx1,THTX])
            E1 = plot3([0,I(1)],[0,I(2)],[0,I(3)],'r--');  
            E2 = plot3([0,J(1)],[0,J(2)],[0,J(3)],'g');
            E3 = plot3([0,K(1)],[0,K(2)],[0,K(3)],'b');
            WRotAx1 = plot3([0,wRotAx1(1)],[0,wRotAx1(2)],[0,wRotAx1(3)],'k--');
            THTX = text(qK(2),qK(3),qK(4)+0.5,num2str(th*180/pi));

            thref = th;
            j = j + 1;
        end 
end

figure(1)
delete([WRotAx1,R1,R2,R3,THTX,TxR1,TxR2,TxR3])

listTH2(1:20) = [];
len = size(listTH2);
listTH2(len(2)-20:len(2)) = [];
TH2 = mean(listTH2);
disp(TH2)

delete([WRotAx1])

%% check TH2

tel = 0;
while tel<1 %pre-listening
    tic
    qref = ModReceive(s,WISEmod,qref);
    qref = box_transf(WISEmod,qref);

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

R1 = plot3([0,Iref(1)],[0,Iref(2)],[0,Iref(3)],'c'); 
TxR1 = text(Iref(1),Iref(2),Iref(3),'i');
R2 = plot3([0,J(1)],[0,J(2)],[0,J(3)],'c');
TxR2 = text(J(1),J(2),J(3),'j');
R3 = plot3([0,K(1)],[0,K(2)],[0,K(3)],'c');
TxR3 = text(K(1),K(2),K(3),'k');   

   
disp('GO')

listQ1 = [];

j = 1;
while true %rotation capturing

        q = ModReceive(s,WISEmod,q);
        q = box_transf(WISEmod,q);
           
        [~,I1,I2,I3] = parts(quaternion(quatmultiply(q,quatmultiply(qI,quatconj(q)))));
        I = [I1,I2,I3];
        [~,J1,J2,J3] = parts(quaternion(quatmultiply(q,quatmultiply(qJ,quatconj(q)))));
        J = [J1,J2,J3];
        [~,K1,K2,K3] = parts(quaternion(quatmultiply(q,quatmultiply(qK,quatconj(q)))));
        K = [K1,K2,K3];

        figure(1)
        hold on
        delete([E1,E2,E3,WQ1,TXT])
        E1 = plot3([0,I(1)],[0,I(2)],[0,I(3)],'r--');  
        E2 = plot3([0,J(1)],[0,J(2)],[0,J(3)],'g');
        E3 = plot3([0,K(1)],[0,K(2)],[0,K(3)],'b');
        TXT = text(qI(2)+0.5,qI(3),qI(4),num2str(acosd(dot(Iref,I))));
        
end

%% Check box_tranf 

figure(1)
delete([TXT,R1,R2,R3,TXT,TxR1,TxR2,TxR3])

tel = 0;
while tel<1 %pre-listening
    tic
    qref = ModReceive(s,WISEmod,qref);
    qref = box_transf(WISEmod,qref);

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
R2 = plot3([0,Jref(1)],[0,Jref(2)],[0,Jref(3)],'c');
TxR2 = text(Jref(1),Jref(2),Jref(3),'j');
R3 = plot3([0,K(1)],[0,K(2)],[0,K(3)],'c');
TxR3 = text(K(1),K(2),K(3),'k');   

   
disp('GO')

listQ1 = [];

j = 1;
while true %rotation capturing

        q = ModReceive(s,WISEmod,q);
        q = box_transf(WISEmod,q);
           
        [~,I1,I2,I3] = parts(quaternion(quatmultiply(q,quatmultiply(qI,quatconj(q)))));
        I = [I1,I2,I3];
        [~,J1,J2,J3] = parts(quaternion(quatmultiply(q,quatmultiply(qJ,quatconj(q)))));
        J = [J1,J2,J3];
        [~,K1,K2,K3] = parts(quaternion(quatmultiply(q,quatmultiply(qK,quatconj(q)))));
        K = [K1,K2,K3];

        figure(1)
        hold on
        delete([E1,E2,E3,WQ1,TXT])
        E1 = plot3([0,I(1)],[0,I(2)],[0,I(3)],'r');  
        E2 = plot3([0,J(1)],[0,J(2)],[0,J(3)],'g--');
        E3 = plot3([0,K(1)],[0,K(2)],[0,K(3)],'b');
        TXT = text(qI(2)+0.5,qI(3),qI(4),num2str(acosd(dot(Jref,J))));
        
end