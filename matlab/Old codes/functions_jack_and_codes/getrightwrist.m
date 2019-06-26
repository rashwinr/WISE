function rightwrist = getrightwrist(arm,wrist)
rightwrist = zeros(2,1);
Qi = [0,1,0,0];Qk = [0,0,0,1];

Vza = quatmultiply(arm,quatmultiply(Qk,quatconj(arm)));
Vxa = quatmultiply(arm,quatmultiply(Qi,quatconj(arm)));
Vzw = quatmultiply(wrist,quatmultiply(Qk,quatconj(wrist)));
Vxw = quatmultiply(wrist,quatmultiply(Qi,quatconj(wrist)));

% elbow extension flexion
XW = Vxw(2:4) - dot(Vxw(2:4),Vza(2:4))*Vza(2:4);
rightwrist(1,1) = acosd(dot(Vxa(2:4),XW)/norm(XW));

% elbow pronation supination
ZWa = Vza(2:4) - dot(Vza(2:4),Vxw(2:4))*Vxw(2:4);
Ref = cross(Vza(2:4),Vxw(2:4));
rightwrist(2,1) = atan2d(dot(Vzw(2:4),Ref),dot(Vzw(2:4),ZWa));



end