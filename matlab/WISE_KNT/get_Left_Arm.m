function leftarm = get_Left_Arm(back,arm)
leftarm = zeros(3,1);
Qi = [0,1,0,0];
Qj = [0,0,1,0];
Qk = [0,0,0,1];

Vxb = quatmultiply(back,quatmultiply(Qi,quatconj(back)));
Vyb = quatmultiply(back,quatmultiply(Qj,quatconj(back)));
Vzb = quatmultiply(back,quatmultiply(Qk,quatconj(back)));

Vyb_ = -Vyb;
Vzb_ = -Vzb;

Vxa = quatmultiply(arm,quatmultiply(Qi,quatconj(arm)));
Vya = quatmultiply(arm,quatmultiply(Qj,quatconj(arm)));
Vza = quatmultiply(arm,quatmultiply(Qk,quatconj(arm)));

Ja = Vya(2:4);

IE = Vxb(2:4);
JE = Vyb_(2:4);
KE = Vzb_(2:4);

V = [dot(Ja,IE) , dot(Ja,JE) , dot(Ja,KE)];

% shoulder extension flexion
leftarm(1,1) = atan2d(V(3),V(1));

% shoulder abduction adduction 
leftarm(2,1) = atan2d(V(2),V(1));

% shoulder internal external rotation 

Xb = [dot(Vxb(2:4),Vxa(2:4)),dot(Vxb(2:4),Vya(2:4)),dot(Vxb(2:4),Vza(2:4))];
Yb = [dot(Vyb(2:4),Vxa(2:4)),dot(Vyb(2:4),Vya(2:4)),dot(Vyb(2:4),Vza(2:4))];
Zb = [dot(Vzb(2:4),Vxa(2:4)),dot(Vzb(2:4),Vya(2:4)),dot(Vzb(2:4),Vza(2:4))];

PP = [Xb(2),Yb(2),Zb(2)];
AbsPP = abs(PP);
[~,ind] = min(AbsPP);
switch ind
    case 1
        Xb = -Xb;
        leftarm(3,1) = atan2d(Xb(3),Xb(1));
    case 2
        Yb = -Yb;
        leftarm(3,1) = atan2d(Yb(3),Yb(1));
    case 3
        leftarm(3,1) = atan2d(-Zb(1),Zb(3));
end

end