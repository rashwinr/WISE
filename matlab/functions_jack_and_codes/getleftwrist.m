function leftwrist = getleftwrist(arm,wrist)
leftwrist = zeros(2,1);
Qi = [0,1,0,0]; Qk = [0,0,0,1];
Vza = quatmultiply(arm,quatmultiply(Qk,quatconj(arm)));
Vxa_ = quatmultiply(arm,quatmultiply(-Qi,quatconj(arm)));
Vzw = quatmultiply(wrist,quatmultiply(Qk,quatconj(wrist)));
Vxw_ = quatmultiply(wrist,quatmultiply(-Qi,quatconj(wrist)));


% elbow extension flexion
XW = Vxw_(2:4) - dot(Vxw_(2:4),Vza(2:4))*Vza(2:4);
leftwrist(1,1) = acosd(dot(Vxa_(2:4),XW)/norm(XW));

% elbow pronation supination
ZWa = Vza(2:4) - dot(Vza(2:4),Vxw_(2:4))*Vxw_(2:4);
Ref = cross(Vxw_(2:4),Vza(2:4));
leftwrist(2,1) = atan2d(dot(Vzw(2:4),Ref),dot(Vzw(2:4),ZWa));

end