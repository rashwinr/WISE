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

    figure(2)

subplot(3,2,1)
hold on
title('theta 1')
anTH1 = animatedline('Color','k');

subplot(3,2,3)
hold on
title('direction of q1')
anDIR1 = animatedline('Color','k');

subplot(3,2,5)
hold on
title('rotation angle')
anTH = animatedline('Color','k');

subplot(3,2,2)
hold on
title('theta 2')
anTH2 = animatedline('Color','k');

subplot(3,2,6)
hold on
title('theta 2')
SanTH = animatedline('Color','k');

    figure(3)

subplot(2,3,1)
hold on
title('gamma validation')
angam = animatedline('Color','b');

subplot(2,3,4)
hold on
title('rotation angle')
gamth = animatedline('Color','k');

subplot(2,3,2)
hold on
title('alpha validation')
analp = animatedline('Color','b');

subplot(2,3,5)
hold on
title('rotation angle')
alpth = animatedline('Color','k');

subplot(2,3,3)
hold on
title('beta validation')
anbet = animatedline('Color','b');

subplot(2,3,6)
hold on
title('rotation angle')
betth = animatedline('Color','k');

fopen(s);

WISEmod = 'b';
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
%% start the motor for Q1

pause(2)

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
        if abs(th-thref)>=1*pi/180 && abs(th)>45*pi/180% && abs(th)>45*pi/180 && abs(th)<135*pi/180
            
            th1 = acos(dot(Z,rotAx));
            Q1 = cross(Z,rotAx);
            Q1 = Q1/norm(Q1);
            listQ1(1,j) = th1;
            listQ1(2:4,j) = Q1;
            
            dirQ1(j) = atan2(listQ1(3,j),listQ1(2,j));
            

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
            
            addpoints(anTH1,j,listQ1(1,j)*180/pi);
            drawnow
            
            addpoints(anDIR1,j,dirQ1(j)*180/pi);
            drawnow
            
            pth = th*180/pi;
            if pth < 0
                pth = 360+pth;
            end

            addpoints(anTH,j,pth);
            drawnow

            thref = th;
            j = j + 1;
        end 
end

figure(1)
delete([WQ1,WRotAx1,R1,R2,R3,THTX,TxR1,TxR2,TxR3])

TH1 = mean(listQ1(1,:));
DIR = mean(dirQ1);

disp(TH1)
disp(DIR)

%% check Q1

tel = 0;
while tel<1 %pre-listening
    tic
    qref = ModReceive(s,WISEmod,qref);
    qref = box_frame(WISEmod,qref);

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
%% start the motor to check Q1
pause(2)

gamV = [];
gamTH = [];

disp('GO')

thref = 0;
j = 1;
while true %rotation capturing

        q = ModReceive(s,WISEmod,q);
        q = box_frame(WISEmod,q);
        
        q1 = quatmultiply(quatconj(qref),q);
        Axang = quat2axang(q1);
        rotAx = Axang(1:3);
        th = Axang(4);
        
        if abs(th-thref)>1*pi/180
            
            thref = th;
            gamTH(j) = th;

            [~,I1,I2,I3] = parts(quaternion(quatmultiply(q,quatmultiply(qI,quatconj(q)))));
            I = [I1,I2,I3];
            [~,J1,J2,J3] = parts(quaternion(quatmultiply(q,quatmultiply(qJ,quatconj(q)))));
            J = [J1,J2,J3];
            [~,K1,K2,K3] = parts(quaternion(quatmultiply(q,quatmultiply(qK,quatconj(q)))));
            K = [K1,K2,K3];

            D = dot(Kref,K);
            gamV(j) = acos(D);

            figure(1)
            hold on
            delete([E1,E2,E3,TXT])
            E1 = plot3([0,I(1)],[0,I(2)],[0,I(3)],'r');  
            E2 = plot3([0,J(1)],[0,J(2)],[0,J(3)],'g');
            E3 = plot3([0,K(1)],[0,K(2)],[0,K(3)],'b--');
            TXT = text(qI(2)+0.5,qI(3),qI(4),num2str(gamV(j)*180/pi));

            addpoints(angam,j,gamV(j)*180/pi);
            drawnow
            
            pth = gamTH(j)*180/pi;
            if pth < 0
                pth = 360+pth;
            end

            addpoints(gamth,j,pth);
            drawnow

            j = j+1;
        end
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
%% start the motor for TH2
pause(2)

listTH2 = [];
TH2th = [];

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
        if abs(th-thref)>=1*pi/180 && abs(th)>45*pi/180 && abs(th)<135*pi/180
            
            TH2th(j) = th;
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
            
            pth = TH2th(j)*180/pi;
            if pth < 0
                pth = 360+pth;
            end
            
            addpoints(anTH2,j,listTH2(j)*180*pi);
            
            addpoints(SanTH,j,pth);

            thref = th;
            j = j + 1;
        end 
end

figure(1)
delete([WRotAx1,R1,R2,R3,THTX,TxR1,TxR2,TxR3])

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

alpV = [];
alpTH = [];

disp('GO')
%% start the motor to check TH2
pause(2)

thref = 0;
j = 1;
while true %rotation capturing

        q = ModReceive(s,WISEmod,q);
        q = box_transf(WISEmod,q);
        
        q2 = quatmultiply(quatconj(qref),q);
        Axang = quat2axang(q2);
        rotAx = Axang(1:3);
        th = Axang(4);
        
        if abs(th-thref)>1*pi/180
            
            alpTH(j) = th;
           
            [~,I1,I2,I3] = parts(quaternion(quatmultiply(q,quatmultiply(qI,quatconj(q)))));
            I = [I1,I2,I3];
            [~,J1,J2,J3] = parts(quaternion(quatmultiply(q,quatmultiply(qJ,quatconj(q)))));
            J = [J1,J2,J3];
            [~,K1,K2,K3] = parts(quaternion(quatmultiply(q,quatmultiply(qK,quatconj(q)))));
            K = [K1,K2,K3];
            
            D = dot(Iref,I);
            alpV(j) = real(acos(D));

            figure(1)
            hold on
            delete([E1,E2,E3,WQ1,TXT])
            E1 = plot3([0,I(1)],[0,I(2)],[0,I(3)],'r--');  
            E2 = plot3([0,J(1)],[0,J(2)],[0,J(3)],'g');
            E3 = plot3([0,K(1)],[0,K(2)],[0,K(3)],'b');
            TXT = text(qI(2)+0.5,qI(3),qI(4),num2str(alpV(j)*180*pi));

            addpoints(analp,j,alpV(j)*180/pi);
            drawnow

            pth = alpTH(j)*180/pi;
            if pth < 0
                pth = 360+pth;
            end

            addpoints(alpth,j,pth);
            drawnow
            
            thref = th;
            j = j+1;
        end
end

%% Check box_tranf 

figure(1)
delete([TXT,R1,R2,R3,TXT,TxR1,TxR2,TxR3])

betV = [];
betTH = [];

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
%% start the motor for final validation
pause(2)

listQ1 = [];

j = 1;
while true %rotation capturing

        q = ModReceive(s,WISEmod,q);
        q = box_transf(WISEmod,q);
        
        qx = quatmultiply(quatconj(qref),q);
        Axang = quat2axang(qx);
        rotAx = Axang(1:3);
        th = Axang(4);
        
        if abs(th-thref)<1*180/pi
            betTH(j) = th;
           
            [~,I1,I2,I3] = parts(quaternion(quatmultiply(q,quatmultiply(qI,quatconj(q)))));
            I = [I1,I2,I3];
            [~,J1,J2,J3] = parts(quaternion(quatmultiply(q,quatmultiply(qJ,quatconj(q)))));
            J = [J1,J2,J3];
            [~,K1,K2,K3] = parts(quaternion(quatmultiply(q,quatmultiply(qK,quatconj(q)))));
            K = [K1,K2,K3];
            
            D = dot(Jref,J);
            betV(j) = acos(D);

            figure(1)
            hold on
            delete([E1,E2,E3,WQ1,TXT])
            E1 = plot3([0,I(1)],[0,I(2)],[0,I(3)],'r');  
            E2 = plot3([0,J(1)],[0,J(2)],[0,J(3)],'g--');
            E3 = plot3([0,K(1)],[0,K(2)],[0,K(3)],'b');
            TXT = text(qI(2)+0.5,qI(3),qI(4),num2str(betV(j)*180/pi));

            addpoints(anbet,j,betV(j)*180/pi);
            drawnow

            pth = betTH(j)*180/pi;
            if pth < 0
                pth = 360+pth;
            end

            addpoints(betth,j,pth);
            drawnow
            
            thref = th;
            j = j+1;
        end
        
end