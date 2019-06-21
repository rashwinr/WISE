function leftwrist = get_Left_Wrist(arm,wrist)
leftwrist = zeros(2,1);
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
leftwrist(1,1) = acosd(dot(Vya(2:4),YW)/norm(YW));

% elbow pronation supination
XWa = [dot(Vxa(2:4),Vxw(2:4)),dot(Vxa(2:4),Vyw(2:4)),dot(Vxa(2:4),Vzw(2:4))];
leftwrist(2,1) = atan2d(-XWa(1),XWa(3));

end