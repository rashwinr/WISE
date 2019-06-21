function [q] = match_coordinateframe(char,Q)

Qj = [0,0,1,0];Qk = [0,0,0,1];

switch char
    case 'a'
        
        Z = quatmultiply(Q,quatmultiply(Qk,quatconj(Q)));
        th = pi/2;
        T = [cos(th/2),Z(2)*sin(th/2),Z(3)*sin(th/2),Z(4)*sin(th/2)];
        q = quatmultiply(T,Q);
        
    case 'b'
        
        Z = quatmultiply(Q,quatmultiply(Qk,quatconj(Q)));
        th = -pi/2;
        T = [cos(th/2),Z(2)*sin(th/2),Z(3)*sin(th/2),Z(4)*sin(th/2)];
        q = quatmultiply(T,Q);
        
    case 'c'
        
        Y = quatmultiply(Q,quatmultiply(Qj,quatconj(Q)));
        th = -pi/2;
        T = [cos(th/2),Y(2)*sin(th/2),Y(3)*sin(th/2),Y(4)*sin(th/2)];
        Q = quatmultiply(T,Q);
        
        Z = quatmultiply(Q,quatmultiply(Qk,quatconj(Q)));
        th = pi/2;
        T = [cos(th/2),Z(2)*sin(th/2),Z(3)*sin(th/2),Z(4)*sin(th/2)];
        q = quatmultiply(T,Q);
        
        
    case 'd'    
        
        Y = quatmultiply(Q,quatmultiply(Qj,quatconj(Q)));
        th = pi/2;
        T = [cos(th/2),Y(2)*sin(th/2),Y(3)*sin(th/2),Y(4)*sin(th/2)];
        Q = quatmultiply(T,Q);
        
        Z = quatmultiply(Q,quatmultiply(Qk,quatconj(Q)));
        th = -pi/2;
        T = [cos(th/2),Z(2)*sin(th/2),Z(3)*sin(th/2),Z(4)*sin(th/2)];
        q = quatmultiply(T,Q);
        

end

