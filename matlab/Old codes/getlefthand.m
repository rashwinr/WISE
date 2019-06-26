function lefthand = getlefthand(back,arm,wrist)
lefthand = zeros(5,1);
Qi = [0,1,0,0];Qj = [0,0,1,0];Qk = [0,0,0,1];
Vxb = quatmultiply(back,quatmultiply(Qi,quatconj(back)));
Vzb_ = quatmultiply(back,quatmultiply(-Qk,quatconj(back)));
Vxb_ = -Vxb;
Vyb_ = quatmultiply(back,quatmultiply(-Qj,quatconj(back)));
Vza = quatmultiply(arm,quatmultiply(Qk,quatconj(arm)));
Vxa_ = quatmultiply(arm,quatmultiply(-Qi,quatconj(arm)));
Vzw = quatmultiply(wrist,quatmultiply(Qk,quatconj(wrist)));
Vxw_ = quatmultiply(wrist,quatmultiply(-Qi,quatconj(wrist)));

IC = Vxa_(2:4);
IE = Vxb(2:4);
JE = Vyb_(2:4);
KE = Vzb_(2:4);
V = [dot(IC,IE) , dot(IC,JE) , dot(IC,KE)];

% shoulder extension flexion
lefthand(1,1) = atan2d(V(3),V(1));

% shoulder abduction adduction 
lefthand(2,1) = atan2d(V(2),V(1));

% shoulder internal external rotation 
A1 = Vza(2:4);
A2 = Vxb_(2:4) - dot(Vxb_(2:4),Vxa_(2:4))*Vxa_(2:4);
lefthand(3,1) = acosd(dot(A1,A2)/norm(A2)); 
if dot(Vxa_(2:4),Vxb(2:4)) > 0.9
    A2 = Vyb_(2:4) - dot(Vyb_(2:4),Vxa_(2:4))*Vxa_(2:4);
    lefthand(3,1) = acosd(dot(A1,A2)/norm(A2));
end

% elbow extension flexion
XW = Vxw_(2:4) - dot(Vxw_(2:4),Vza(2:4))*Vza(2:4);
lefthand(4,1) = acosd(dot(Vxa_(2:4),XW)/norm(XW));

% elbow pronation supination
ZWa = Vza(2:4) - dot(Vza(2:4),Vxw_(2:4))*Vxw_(2:4);
Ref = cross(Vxw_(2:4),Vza(2:4));
lefthand(5,1) = atan2d(dot(Vzw(2:4),Ref),dot(Vzw(2:4),ZWa));

end