function leftarm = getleftarm(back,arm)
leftarm = zeros(3,1);
Qi = [0,1,0,0];Qj = [0,0,1,0];Qk = [0,0,0,1];
Vxb = quatmultiply(back,quatmultiply(Qi,quatconj(back)));
Vzb_ = quatmultiply(back,quatmultiply(-Qk,quatconj(back)));
Vyb = quatmultiply(back,quatmultiply(Qj,quatconj(back)));
Vyb_ = quatmultiply(back,quatmultiply(-Qj,quatconj(back)));
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

Za = [dot(Vza(2:4),Vxb(2:4)),dot(Vza(2:4),Vyb(2:4)),dot(Vza(2:4),Vzb(2:4))];
Xa = [dot(Vxa(2:4),Vxb(2:4)),dot(Vxa(2:4),Vyb(2:4)),dot(Vxa(2:4),Vzb(2:4))];
AbsX = abs(Xa);
[~,ind] = max(abs(AbsX));
switch ind
    case 1
        if Xa(1)>0
            leftarm(3,1) = atan2(-Za(3),Za(2));            
        else
            leftarm(3,1) = atan2(-Za(3),-Za(2));
        end
    case 2
        if Xa(2)>0
            leftarm(3,1) = atan2(-Za(1),-Za(3));
        else
            leftarm(3,1) = atan2(-Za(1),Za(3));
        end
    case 3
        if Xa(3)>0
            leftarm(3,1) = atan2(-Za(1),Za(2));
        else
            leftarm(3,1) = atan2(-Za(1),-Za(2));
        end
end

end