
qA = axang2quat([1 0 0 pi/2]);
qB = axang2quat([1 0 0 pi/4]);
AqB = quatmultiply(qB,quatconj(qA));
BqA = quatconj(AqB);
IA = [1 0 0]; IB = [1 0 0]; IC = [1 0 0]; ID = [1 0 0]; IE = [1 0 0];
JA = [0 1 0]; JB = [0 1 0]; JC = [0 1 0]; JD = [0 1 0]; JE = [0 1 0];
KA = [0 0 1]; KB = [0 0 1]; KC = [0 0 1]; KD = [0 0 1]; KE = [0 0 1];
qI = [0,1,0,0];
qJ = [0,0,1,0];
qK = [0,0,0,1];
sp = 1.5;

E1 = plot3([0,IE(1)],[0,IE(2)],[0,IE(3)],'r');  
E2 = plot3([0,JE(1)],[0,JE(2)],[0,JE(3)],'g');
E3 = plot3([0,KE(1)],[0,KE(2)],[0,KE(3)],'b');
RA = RC -[sp,0,0];
A1 = plot3([RA(1),RA(1)+IA(1)],[RA(2),RA(2)+IA(2)],[RA(3),RA(3)+IA(3)],'r');  
A2 = plot3([RA(1),RA(1)+JA(1)],[RA(2),RA(2)+JA(2)],[RA(3),RA(3)+JA(3)],'g');
A3 = plot3([RA(1),RA(1)+KA(1)],[RA(2),RA(2)+KA(2)],[RA(3),RA(3)+KA(3)],'b');

        [~,IA(1),IA(2),IA(3)] = parts(quaternion(quatmultiply(qA,quatmultiply(qI,quatconj(qA)))));
        [~,JA(1),JA(2),JA(3)] = parts(quaternion(quatmultiply(qA,quatmultiply(qJ,quatconj(qA)))));
        [~,KA(1),KA(2),KA(3)] = parts(quaternion(quatmultiply(qA,quatmultiply(qK,quatconj(qA)))));
        
        [~,IE(1),IE(2),IE(3)] = parts(quaternion(quatmultiply(qB,quatmultiply(qI,quatconj(qB)))));
        [~,JE(1),JE(2),JE(3)] = parts(quaternion(quatmultiply(qB,quatmultiply(qJ,quatconj(qB)))));
        [~,KE(1),KE(2),KE(3)] = parts(quaternion(quatmultiply(qB,quatmultiply(qK,quatconj(qB)))));
        
        figure(1)
        hold on
        grid on
        axis equal
        view([35,24])
        axis([-6 6 -1 1 -1 1])
        delete([A1,A2,A3,E1,E2,E3])
        E1 = plot3([0,IE(1)],[0,IE(2)],[0,IE(3)],'r');  
        E2 = plot3([0,JE(1)],[0,JE(2)],[0,JE(3)],'g');
        E3 = plot3([0,KE(1)],[0,KE(2)],[0,KE(3)],'b');
        Ta = text(RA(1),RA(2),RA(3),'A');
        A1 = plot3([RA(1),RA(1)+IA(1)],[RA(2),RA(2)+IA(2)],[RA(3),RA(3)+IA(3)],'r');  
        A2 = plot3([RA(1),RA(1)+JA(1)],[RA(2),RA(2)+JA(2)],[RA(3),RA(3)+JA(3)],'g');
        A3 = plot3([RA(1),RA(1)+KA(1)],[RA(2),RA(2)+KA(2)],[RA(3),RA(3)+KA(3)],'b');
        Te = text(0,0,0,'B');
        
        V1 = [0,JA(1),JA(2),JA(3)]
        V2 = quaternion(quatmultiply(AqB,quatmultiply(V1,quatconj(AqB))))
        
%%


