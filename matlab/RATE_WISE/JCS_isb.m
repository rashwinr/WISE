function ang = JCS_isb(char,qRef,q)
qK = [0,0,0,1];
qJ = [0,0,1,0];
switch char
    case 'LA'
        Z = quatmultiply(qRef,quatmultiply(-qK,quatconj(qRef)));
        Z = [cos(pi/4),Z(2)*sin(pi/4),Z(3)*sin(pi/4),Z(4)*sin(pi/4)];
        qRef = quatmultiply(Z,qRef);
        
        R = quat2rotm(qRef);
        R = [-R(:,1),R(:,2),-R(:,3)];
        qRef = rotm2quat(R);
        
        R = quat2rotm(q);
        R = [-R(:,1),R(:,2),-R(:,3)];
        q = rotm2quat(R);

        qRel = quatmultiply(quatconj(qRef),q);
        [r1,r2,r3] = quat2angle(qRel,'YZY');
    case 'RA'
        Z = quatmultiply(qRef,quatmultiply(-qK,quatconj(qRef)));
        Z = [cos(pi/4),Z(2)*sin(pi/4),Z(3)*sin(pi/4),Z(4)*sin(pi/4)];
        qRef = quatmultiply(Z,qRef);
        
        R = quat2rotm(qRef);
        R = [-R(:,1),-R(:,2),R(:,3)];
        qRef = rotm2quat(R);
        
        R = quat2rotm(q);
        R = [-R(:,1),-R(:,2),R(:,3)];
        q = rotm2quat(R);
        
        qRel = quatmultiply(quatconj(qRef),q);
        [r1,r2,r3] = quat2angle(qRel,'YZY');
    case 'LF'
        Y = quatmultiply(qRef,quatmultiply(qJ,quatconj(qRef)));
        Y = [cos(pi/4),Y(2)*sin(pi/4),Y(3)*sin(pi/4),Y(4)*sin(pi/4)];
        qRef = quatmultiply(Y,qRef);
        
        R = quat2rotm(qRef);
        R(:,1) = -R(:,1);
        R(:,3) = -R(:,3);
        qRef = rotm2quat(R);
        
        R = quat2rotm(q);
        R(:,1) = -R(:,1);
        R(:,3) = -R(:,3);
        q = rotm2quat(R);
        
        qRel = quatmultiply(quatconj(qRef),q);
        [r1,r2,r3] = quat2angle(qRel,'ZXY');
    case 'RF'
        Y = quatmultiply(qRef,quatmultiply(-qJ,quatconj(qRef)));
        Y = [cos(pi/4),Y(2)*sin(pi/4),Y(3)*sin(pi/4),Y(4)*sin(pi/4)];
        qRef = quatmultiply(Y,qRef);
        
        R = quat2rotm(qRef);
        R(:,1) = -R(:,1);
        R(:,2) = -R(:,2);
        qRef = rotm2quat(R);
        
        R = quat2rotm(q);
        R(:,1) = -R(:,1);
        R(:,2) = -R(:,2);
        q = rotm2quat(R);
        
        qRel = quatmultiply(quatconj(qRef),q);
        [r1,r2,r3] = quat2angle(qRel,'ZXY');
end
ang = [r1,r2,r3];
end

