function leftwrist = get_Left_Wrist(arm,wrist)
leftwrist = zeros(2,1);
Qi = [0,1,0,0]; Qj = [0,0,1,0]; Qk = [0,0,0,1];

Vxa_ = quatmultiply(arm,quatmultiply(-Qi,quatconj(arm)));
Vya_ = quatmultiply(arm,quatmultiply(-Qj,quatconj(arm)));
Vza = quatmultiply(arm,quatmultiply(Qk,quatconj(arm)));

Vxw = quatmultiply(wrist,quatmultiply(Qi,quatconj(wrist)));
Vzw = quatmultiply(wrist,quatmultiply(Qk,quatconj(wrist)));
Vyw_ = quatmultiply(wrist,quatmultiply(-Qj,quatconj(wrist)));


% elbow extension flexion
YW = Vyw_(2:4) - dot(Vyw_(2:4),Vxa(2:4))*Vxa(2:4);
leftwrist(1,1) = acosd(dot(Vya_(2:4),YW)/norm(YW));

% elbow pronation supination
XWa = [dot(Vxa_(2:4),Vxw_(2:4)),dot(Vxa_(2:4),Vyw_(2:4)),dot(Vxa_(2:4),Vzw(2:4))];
leftwrist(2,1) = atan2d(-XWa(1),XWa(3));

end