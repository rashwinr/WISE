function [ef,bd,ie] = JCS_Ra(back,arm)
Qk = [0,0,0,1];
Vzb = quatmultiply(back,quatmultiply(Qk,quatconj(back)));
th = -pi/2;
Qz = [cos(th/2),Vzb(2)*sin(th/2),Vzb(3)*sin(th/2),Vzb(4)*sin(th/2)];
Qback = quatmultiply(Qz,back);
Qr = quatmultiply(quatconj(Qback),arm);
R = quat2rotm(Qr);
bd = atan2(R(2,1),R(2,2));
ie = -atan2(R(1,3),R(3,3));
ef = atan2(-R(2,3),R(2,2)/cos(bd));
end