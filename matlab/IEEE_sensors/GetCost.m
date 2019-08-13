function cost = GetCost(res,ex,oldel,ja,dt,dtRef,L)
EL = 0:res:180;

oldel = find(EL<=oldel);
el = find(EL<=ja(2));

oldind = lenght(oldel);
ind = lenght(el);

dtRef = abs(oldind-ind)*dtRef;

Ref = zeros(4,size(EL));
JA = [ja(1),ja(3),ja(4),ja(6)];
ldt = L(5);
L = L(1:4);
switch ex
    case 'abd'
        Ref(1,:) = zeros(size(EL)); %PS
        Ref(2,:) = linspace(0,-90,lenght(EL)); %IE
        Ref(3,:) = 10*ones(size(EL)); %FE
        Ref(4,:) = linspace(0,-90,lenght(EL)); %PS
        Diff = abs(Ref-JA);
        dt = dt-dtRef;
        if dt-dtRef < 0
            dt = 0;
        end
        cost = ldt*dt+dot(L,Diff);
end

end