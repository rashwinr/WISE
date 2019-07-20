function [angles,Mean,Std] = PolarMean(TH,Err,span)

if isrow(Err)
    Err = Err';
end
if isrow(TH)
    TH = TH';
end

Mean = [];
Std = [];
angles = [];
ind = [];
k = 1;

Points = [TH,Err];
Points = sortrows(Points,1);
P = Points;

while ~isempty(P)
    ind = find(P(:,1)<=P(1,1)+span);
    Mean(1,k) = mean(P(ind,2));
    Std(1,k) = std(P(ind,2));
    angles(1,k) = mean(P(ind,1));
    P(ind,:)=[];
    ind = [];
    k = k+1;
end

end