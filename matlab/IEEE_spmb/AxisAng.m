function [Vq,thq] = AxisAng(q)
thq = acos(q(1))*2;
Vq = [q(2)/sin(thq/2),q(3)/sin(thq/2),q(4)/sin(thq/2)];
if thq < 0
    thq = -thq;
    Vq = -Vq;
end
end