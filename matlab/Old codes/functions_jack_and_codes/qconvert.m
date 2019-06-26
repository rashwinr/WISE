function resultmult = qconvert(a)
p = -1; %y = m x + p where y(-1 1) x(0 999) from rfduino z(-2^14 2^14)
m = 2/999;
resultmult(1) = str2double(a(2))*m+p;
resultmult(2) = str2double(a(3))*m+p;
resultmult(3) = str2double(a(4))*m+p;
resultmult(4) = str2double(a(5))*m+p;
resultmult = quatnormalize(resultmult);
end