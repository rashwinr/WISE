function leftarm = GetArmLeft(back,arm)
leftarm = zeros(3,1);
Qi = [0,1,0,0];Qj = [0,0,1,0];Qk = [0,0,0,1];
Vxb = quatmultiply(back,quatmultiply(Qi,quatconj(back)));
Vzb = quatmultiply(back,quatmultiply(Qk,quatconj(back)));
Vzb_ = -Vzb;
Vyb = quatmultiply(back,quatmultiply(Qj,quatconj(back)));
Vyb_ = -Vyb;
Vza = quatmultiply(arm,quatmultiply(Qk,quatconj(arm)));
Vya = quatmultiply(arm,quatmultiply(Qj,quatconj(arm)));
Vxa = quatmultiply(arm,quatmultiply(Qi,quatconj(arm)));
Vxa_ = -Vxa;

IC = Vxa_(2:4);
IE = Vxb(2:4);
JE = Vyb_(2:4);
KE = Vzb_(2:4);
V = [dot(IC,IE) , dot(IC,JE) , dot(IC,KE)];

% shoulder extension flexion
leftarm(1,1) = atan2d(V(3),V(1));

% shoulder abduction adduction 
leftarm(2,1) = atan2d(V(2),V(1));

% shoulder internal external rotation 

Xb = [dot(Vxb(2:4),Vxa(2:4)),dot(Vxb(2:4),Vya(2:4)),dot(Vxb(2:4),Vza(2:4))];
Yb = [dot(Vyb(2:4),Vxa(2:4)),dot(Vyb(2:4),Vya(2:4)),dot(Vyb(2:4),Vza(2:4))];
Zb = [dot(Vzb(2:4),Vxa(2:4)),dot(Vzb(2:4),Vya(2:4)),dot(Vzb(2:4),Vza(2:4))];

PP = [Xb(1),Yb(1),Zb(1)];
AbsPP = abs(PP);
[~,ind] = min(AbsPP);
switch ind
    case 1
        Xb = -Xb;
        if Yb(1)>0
            leftarm(3,1) = -atan2d(Xb(2),Xb(3));            
        else
            leftarm(3,1) = -atan2d(Xb(2),Xb(3));
        end
    case 2
        if Xb(1)>0
            leftarm(3,1) = -atan2d(Yb(2),Yb(3));
        else
            Yb = -Yb;
            leftarm(3,1) = -atan2d(Yb(2),Yb(3));
        end
    case 3
        if -Zb(2)>0
            Zb = -Zb;
            leftarm(3,1) = atan2d(Zb(3),Zb(2));
        else
            leftarm(3,1) = atan2d(Zb(3),Zb(2));
        end
end


end