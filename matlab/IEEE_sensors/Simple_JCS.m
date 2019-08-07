function ang = Simple_JCS(char,qRef,q)

switch char
    case 'X'
        qRel = quatmultiply(quatconj(qRef),q);
        [ang,~,~] = quat2angle(qRel,'XZY');
    case 'Y'
        qRel = quatmultiply(quatconj(qRef),q);
        [ang,~,~] = quat2angle(qRel,'YZX');
    case 'Z'
        qRel = quatmultiply(quatconj(qRef),q);
        [ang,~,~] = quat2angle(qRel,'ZYX');
end

end

