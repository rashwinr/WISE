function leftarm = GetArmLeft(back,arm)
leftarm = zeros(3,1);
Qi = [0,1,0,0];Qj = [0,0,1,0];Qk = [0,0,0,1];
Vxb = quatmultiply(back,quatmultiply(Qi,quatconj(back)));
Vzb = quatmultiply(back,quatmultiply(Qk,quatconj(back)));
Vzb_ = -Vzb;
Vyb = quatmultiply(back,quatmultiply(Qj,quatconj(back)));
Vyb_ = -Vyb;
Vza = quatmultiply(arm,quatmultiply(Qk,quatconj(arm)));
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

Xb = -[dot(Vxb(2:4),Vxa(2:4)),dot(Vxb(2:4),Vya(2:4)),dot(Vxb(2:4),Vza(2:4))];
Yb = [dot(Vyb(2:4),Vxa(2:4)),dot(Vyb(2:4),Vya(2:4)),dot(Vyb(2:4),Vza(2:4))];

Xa = [dot(Vxa(2:4),Vxb(2:4)),dot(Vxa(2:4),Vyb(2:4)),dot(Vxa(2:4),Vzb(2:4))];
AbsX = abs(Xa);
[~,ind] = max(abs(AbsX));
switch ind
    case 1
        if Xa(1)>0
            leftarm(3,1) = -atan2(Yb(2),Yb(3));            
        else
            Yb = -Yb;
            leftarm(3,1) = -atan2(Yb(2),Yb(3));
        end
    case 2
        if Xa(2)>0
            leftarm(3,1) = -atan2(Xb(2),Xb(3));
        else
            leftarm(3,1) = atan2(Xb(2),Xb(3));
        end
    case 3
        if Xa(3)>0
            leftarm(3,1) = -atan2(Xb(2),Xb(3));
        else
            leftarm(3,1) = atan2(Xb(2),Xb(3));
        end
end


end