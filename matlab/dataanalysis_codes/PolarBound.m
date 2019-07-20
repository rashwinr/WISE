function [th, ro] = PolarBound(TH,RO)

if isrow(RO)
    RO = RO';
end
if isrow(TH)
    TH = TH';
end

th = [];
ro = [];
ind = [];
k = 1;

Points = [TH,RO];
Points = sortrows(Points,1);
P = Points;

while ~isempty(P)
    ind = P(:,1)==P(1,1);
    th(k,1) = P(1,1);
    ro(k,1) = max(P(ind,2));
    P(ind,:)=[];
    ind = [];
    k = k+1;
end

end