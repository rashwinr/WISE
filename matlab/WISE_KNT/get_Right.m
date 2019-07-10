function right = get_Right(back,arm,wrist)
right = zeros(5,1);
Qi = [0,1,0,0];
Qj = [0,0,1,0];
Qk = [0,0,0,1];

Vxb = quatmultiply(back,quatmultiply(Qi,quatconj(back)));
Vyb = quatmultiply(back,quatmultiply(Qj,quatconj(back)));
Vzb = quatmultiply(back,quatmultiply(Qk,quatconj(back)));

Vzb_ = -Vzb;

Vxa = quatmultiply(arm,quatmultiply(Qi,quatconj(arm)));
Vya = quatmultiply(arm,quatmultiply(Qj,quatconj(arm)));
Vza = quatmultiply(arm,quatmultiply(Qk,quatconj(arm)));

Vxw = quatmultiply(wrist,quatmultiply(Qi,quatconj(wrist)));
Vyw = quatmultiply(wrist,quatmultiply(Qj,quatconj(wrist)));
Vzw = quatmultiply(wrist,quatmultiply(Qk,quatconj(wrist)));

JC = Vya(2:4);

IE = Vxb(2:4);
JE = Vyb(2:4);
KE = Vzb_(2:4);

V = [dot(JC,IE) , dot(JC,JE) , dot(JC,KE)];

% shoulder extension flexion
right(1,1) = atan2d(V(3),V(1));
if -180<=right(1,1) && right(1,1)<-90
    right(1,1) = 360 + right(1,1);
end

% shoulder abduction adduction 
right(2,1) = atan2d(V(2),V(1));
if -180<=right(2,1) && right(2,1)<-90
    right(2,1) = 360 + right(2,1);
end

% elbow extension flexion
YW = Vyw(2:4) - dot(Vyw(2:4),Vxa(2:4))*Vxa(2:4);
right(4,1) = acosd(dot(Vya(2:4),YW)/norm(YW));

% elbow pronation supination
Ref = cross(Vxa(2:4),Vyw(2:4));
Ref = [dot(Ref,Vxw(2:4)),dot(Ref,Vyw(2:4)),dot(Ref,Vzw(2:4))];
right(5,1) = atan2d(-Ref(3),Ref(1));

% shoulder internal external rotation 

right(3,1) = 666;

if right(4,1)>=30
    
    Zref = -(Vzb-dot(Vzb,Vya)*Vya);
    Zref = Zref/norm(Zref);
    Yref = Vyb-dot(Vyb,Vya)*Vya;
    Yref = -Yref/norm(Yref);
    right(3,1) = atan2d(dot(Vyw,Yref),dot(Vyw,Zref));
        
end

end