function rightarm = get_Right_Arm(back,arm)
rightarm = zeros(3,1);
Qi = [0,1,0,0];Qj = [0,0,1,0];Qk = [0,0,0,1];

Vxb = quatmultiply(back,quatmultiply(Qi,quatconj(back)));
Vyb = quatmultiply(back,quatmultiply(Qj,quatconj(back)));
Vzb = quatmultiply(back,quatmultiply(Qk,quatconj(back)));

Vzb_ = -Vzb;

Vxa_ = quatmultiply(arm,quatmultiply(-Qi,quatconj(arm)));
Vya_ = quatmultiply(arm,quatmultiply(-Qj,quatconj(arm)));
Vza = quatmultiply(arm,quatmultiply(Qk,quatconj(arm)));

JC = Vya_(2:4);

IE = Vxb(2:4);
JE = Vyb(2:4);
KE = Vzb_(2:4);

V = [dot(JC,IE) , dot(JC,JE) , dot(JC,KE)];

% shoulder extension flexion
rightarm(1,1) = atan2d(V(3),V(1));

% shoulder abduction adduction 
rightarm(2,1) = atan2d(V(2),V(1));

% shoulder internal external rotation 

Xb = [dot(Vxb(2:4),Vxa(2:4)),dot(Vxb(2:4),Vya_(2:4)),dot(Vxb(2:4),Vza(2:4))];
Yb = [dot(Vyb(2:4),Vxa(2:4)),dot(Vyb(2:4),Vya_(2:4)),dot(Vyb(2:4),Vza(2:4))];
Zb = [dot(Vzb(2:4),Vxa(2:4)),dot(Vzb(2:4),Vya_(2:4)),dot(Vzb(2:4),Vza(2:4))];

PP = [Xb(2),Yb(2),Zb(2)];
AbsPP = abs(PP);
[~,ind] = min(AbsPP);
switch ind
    case 1
        Xb = -Xb;
        rightarm(3,1) = atan2d(Xb(3),Xb(1));
    case 2
        if Xb(2)>0
            rightarm(3,1) = atan2d(Yb(3),Yb(1));
        else
            rightarm(3,1) = atan2d(-Yb(3),Yb(1));
        end
    case 3
        if Yb(2)>0
            Zb = -Zb;
            rightarm(3,1) = atan2d(-Zb(1),Zb(3));
        else
            rightarm(3,1) = atan2d(-Zb(1),Zb(3));
        end
end



end