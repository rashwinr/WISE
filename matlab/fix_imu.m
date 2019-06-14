function Q = fix_imu(id,q,Offsets)
switch id
    case 'a'
        Q = quatmultiply(quatconj(Offsets(1,:)),q);
    case 'b'
        Q = quatmultiply(quatconj(Offsets(2,:)),q);
    case 'c'
        Q = quatmultiply(quatconj(Offsets(3,:)),q);
    case 'd'
        Q = quatmultiply(quatconj(Offsets(4,:)),q);
    case 'e'
        Q = quatmultiply(quatconj(Offsets(5,:)),q);
end