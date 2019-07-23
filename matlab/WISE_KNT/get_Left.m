function left = get_Left(back,arm,wrist)
left = zeros(5,1);
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

Vxw = quatmultiply(wrist,quatmultiply(Qi,quatconj(wrist)));
Vyw = quatmultiply(wrist,quatmultiply(Qj,quatconj(wrist)));
Vzw = quatmultiply(wrist,quatmultiply(Qk,quatconj(wrist)));

Ja = Vya(2:4);

IE = Vxb(2:4);
JE = Vyb_(2:4);
KE = Vzb_(2:4);

V = [dot(Ja,IE) , dot(Ja,JE) , dot(Ja,KE)];

% shoulder extension flexion
left(1,1) = atan2d(V(3),V(1));
if -180<=left(1,1) && left(1,1)<-90
    left(1,1) = 360 + left(1,1);
end

% shoulder abduction adduction 
left(2,1) = atan2d(V(2),V(1));
if -180<=left(2,1) && left(2,1)<-90
    left(2,1) = 360 + left(2,1);
end

% elbow extension flexion
YW = Vyw(2:4) - dot(Vyw(2:4),Vxa(2:4))*Vxa(2:4);
left(4,1) = real(acosd(dot(Vya(2:4),YW)/norm(YW)));

% elbow pronation supination
Ref = cross(Vxa(2:4),Vyw(2:4));
Ref = [dot(Ref,Vxw(2:4)),dot(Ref,Vyw(2:4)),dot(Ref,Vzw(2:4))];
left(5,1) = atan2d(-Ref(3),-Ref(1));

% shoulder internal external rotation 

left(3,1) = 666;

if left(4,1)>=30
    
    Zref = Vzb_-dot(Vzb_,Vya)*Vya;
    Zref = Zref/norm(Zref);
    Yref = Vyb-dot(Vyb,Vya)*Vya;
    Yref = Yref/norm(Yref);
    Vyw = Vyw -dot(Vyw,Vya)*Vya;
    left(3,1) = atan2d(dot(Vyw,Yref),dot(Vyw,Zref));

end


end