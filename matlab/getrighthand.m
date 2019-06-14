function righthand = getrighthand(back,arm,wrist)
righthand = zeros(5,1);
Qi = [0,1,0,0];Qj = [0,0,1,0];Qk = [0,0,0,1];

Vzb_ = quatmultiply(back,quatmultiply(-Qk,quatconj(back)));
Vxb = quatmultiply(back,quatmultiply(Qi,quatconj(back)));
Vxb_ = -Vxb;
Vyb = quatmultiply(back,quatmultiply(Qj,quatconj(back)));
Vza = quatmultiply(arm,quatmultiply(Qk,quatconj(arm)));
Vxa = quatmultiply(arm,quatmultiply(Qi,quatconj(arm)));
Vxa_ = -Vxa;
Vzw = quatmultiply(wrist,quatmultiply(Qk,quatconj(wrist)));
Vxw = quatmultiply(wrist,quatmultiply(Qi,quatconj(wrist)));

IC = Vxa(2:4);
IE = Vxb(2:4);
JE = Vyb(2:4);
KE = Vzb_(2:4);
V = [dot(IC,IE) , dot(IC,JE) , dot(IC,KE)];

% shoulder extension flexion
righthand(1,1) = atan2d(V(3),V(1));

% shoulder abduction adduction
righthand(2,1) = atan2d(V(2),V(1));

% shoulder internal external rotation
A1 = Vza(2:4);
A2 = Vxb_(2:4) - dot(Vxb_(2:4),Vxa(2:4))*Vxa(2:4);
righthand(3,1) = acosd(dot(A1,A2)/norm(A2)); 
if dot(Vxa(2:4),Vxb(2:4)) > 0.9
    A2 = Vyb(2:4) - dot(Vyb(2:4),Vxa(2:4))*Vxa(2:4);
    righthand(3,1) = acosd(dot(A1,A2)/norm(A2));
end

% elbow extension flexion
XW = Vxw(2:4) - dot(Vxw(2:4),Vza(2:4))*Vza(2:4);
righthand(4,1) = acosd(dot(Vxa(2:4),XW)/norm(XW));
% righthand(4,1) = acosd(dot(Vxa(2:4),Vxw(2:4)));

% elbow pronation supination
ZWa = Vza(2:4) - dot(Vza(2:4),Vxw(2:4))*Vxw(2:4);
Ref = cross(Vza(2:4),Vxw(2:4));
righthand(5,1) = atan2d(dot(Vzw(2:4),Ref),dot(Vzw(2:4),ZWa));



end