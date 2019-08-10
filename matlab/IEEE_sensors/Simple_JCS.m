function ang = Simple_JCS(char,qRef,q)
        qRel = quatmultiply(quatconj(qRef),q);
switch char
    case 'X'
        [~,~,ang] = quat2angle(qRel,'ZYX');
%         ang1 = quat2axang(qRel);
%         ang = ang1(4);
%         ang = ang1+ang2;
    case 'Y'
        [~,~,ang] = quat2angle(qRel,'XZY');
    case 'Z'
        [~,~,ang] = quat2angle(qRel,'XYZ');
end
ang = ang*180/pi;
end

