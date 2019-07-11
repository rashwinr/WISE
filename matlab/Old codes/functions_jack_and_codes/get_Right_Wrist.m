function rightwrist = get_Right_Wrist(arm,wrist)
rightwrist = zeros(2,1);
Qi = [0,1,0,0]; 
Qj = [0,0,1,0]; 
Qk = [0,0,0,1];

Vxa = quatmultiply(arm,quatmultiply(Qi,quatconj(arm)));
Vya = quatmultiply(arm,quatmultiply(Qj,quatconj(arm)));

Vxw = quatmultiply(wrist,quatmultiply(Qi,quatconj(wrist)));
Vyw = quatmultiply(wrist,quatmultiply(Qj,quatconj(wrist)));
Vzw = quatmultiply(wrist,quatmultiply(Qk,quatconj(wrist)));

% elbow extension flexion
YW = Vyw(2:4) - dot(Vyw(2:4),Vxa(2:4))*Vxa(2:4);
rightwrist(1,1) = acosd(dot(Vya(2:4),YW)/norm(YW));

% elbow pronation supination
Ref = cross(Vxa(2:4),Vyw(2:4));
Ref = [dot(Ref,Vxw(2:4)),dot(Ref,Vyw(2:4)),dot(Ref,Vzw(2:4))];
rightwrist(2,1) = atan2d(-Ref(3),Ref(1));

end