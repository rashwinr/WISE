clear all, close all, clc

addpath('C:\Users\fabio\Documents\MATLAB\Functions')

delete(instrfind({'Port'},{'COM12'}))
s = serial('COM12','BaudRate',115200);
s.ReadAsyncMode = 'continuous';
p = -1; %y = m x + p where y(-1 1) x(0 999) from rfduino z(-2^14 2^14)
m = 2/999;

q = [1,0,0,0];
qfE = [1,0,0,0];

qI = [0,1,0,0];
qJ = [0,0,1,0];
qK = [0,0,0,1];

I = [1 0 0]; 
J = [0 1 0]; 
K = [0 0 1]; 

X = [1 0 0]; 
Y = [0 1 0]; 
Z = [0 0 1]; 

v1 = [0 0 0];
v2 = [0 0 0];

figure(1)
hold on
grid on
axis equal
axis([-1 2 -1 2 -1 2])
view([35,24])
plot3([0,qI(2)],[0,qI(3)],[0,qI(4)],'k');
text(qI(2),qI(3),qI(4),'i');
plot3([0,qJ(2)],[0,qJ(3)],[0,qJ(4)],'k');
text(qJ(2),qJ(3),qJ(4),'j');
plot3([0,qK(2)],[0,qK(3)],[0,qK(4)],'k');
text(qK(2),qK(3),qK(4),'k');
E1 = plot3([0,I(1)],[0,I(2)],[0,I(3)],'r');  
E2 = plot3([0,J(1)],[0,J(2)],[0,J(3)],'g');
E3 = plot3([0,K(1)],[0,K(2)],[0,K(3)],'b');
V1 = plot3([0,v1(1)],[0,v1(2)],[0,v1(3)],'k');
V2 = plot3([0,v2(1)],[0,v2(2)],[0,v2(3)],'k');

fopen(s);
%% V1
while true
    flushinput(s);
    line = fscanf(s);   % get data if there exists data in the next line
    data = strsplit(string(line),',');
    if(length(data) == 5 || length(data) == 6)
    switch data(1)
        case 'cal'
            switch data(2)
                case 'e'
                    E_mag = str2double(data(3));
                    E_acc = str2double(data(4));
                    E_gyr = str2double(data(5));
                    E_sys = str2double(data(6));  
                    Cal_E = [E_mag E_acc E_gyr E_sys]
                case 'c'
                    C_mag = str2double(data(3));
                    C_acc = str2double(data(4));
                    C_gyr = str2double(data(5));
                    C_sys = str2double(data(6));  
                    Cal_C = [C_mag C_acc C_gyr C_sys]
                case 'a'
                    A_mag = str2double(data(3));
                    A_acc = str2double(data(4));
                    A_gyr = str2double(data(5));
                    A_sys = str2double(data(6));      
                    Cal_A = [A_mag A_acc A_gyr A_sys]
            end  
        case 'd'
            q(1) = str2double(data(2))*m+p;
            q(2) = str2double(data(3))*m+p;
            q(3) = str2double(data(4))*m+p;
            q(4) = str2double(data(5))*m+p;
            q = quatnormalize(q);
            
                
            [~,I1,I2,I3] = parts(quaternion(quatmultiply(q,quatmultiply(qI,quatconj(q)))));
            I = [I1,I2,I3];
            [~,J1,J2,J3] = parts(quaternion(quatmultiply(q,quatmultiply(qJ,quatconj(q)))));
            J = [J1,J2,J3];
            [~,K1,K2,K3] = parts(quaternion(quatmultiply(q,quatmultiply(qK,quatconj(q)))));
            K = [K1,K2,K3];
            
            th1 = acos(dot(K,Z))
            
            v1 = cross(K,Z)/norm(cross(K,Z));
            
            v1w = v1;
            
            v1 = [dot(v1,I),dot(v1,J),dot(v1,K)]

            figure(1)
            hold on
            delete([E1,E2,E3,V1])
            E1 = plot3([0,I(1)],[0,I(2)],[0,I(3)],'r');  
            E2 = plot3([0,J(1)],[0,J(2)],[0,J(3)],'g');
            E3 = plot3([0,K(1)],[0,K(2)],[0,K(3)],'b');
            V1 = plot3([0,v1w(1)],[0,v1w(2)],[0,v1w(3)],'k');

 
    end 
    end
    
end

%% V2
delete([E1,E2,E3,V1])
while true
    flushinput(s);
    line = fscanf(s);   % get data if there exists data in the next line
    data = strsplit(string(line),',');
    if(length(data) == 5 || length(data) == 6)
    switch data(1)
        case 'cal'
            switch data(2)
                case 'e'
                    E_mag = str2double(data(3));
                    E_acc = str2double(data(4));
                    E_gyr = str2double(data(5));
                    E_sys = str2double(data(6));  
                    Cal_E = [E_mag E_acc E_gyr E_sys]
                case 'c'
                    C_mag = str2double(data(3));
                    C_acc = str2double(data(4));
                    C_gyr = str2double(data(5));
                    C_sys = str2double(data(6));  
                    Cal_C = [C_mag C_acc C_gyr C_sys]
                case 'a'
                    A_mag = str2double(data(3));
                    A_acc = str2double(data(4));
                    A_gyr = str2double(data(5));
                    A_sys = str2double(data(6));      
                    Cal_A = [A_mag A_acc A_gyr A_sys]
            end  
        case 'd'
            q(1) = str2double(data(2))*m+p;
            q(2) = str2double(data(3))*m+p;
            q(3) = str2double(data(4))*m+p;
            q(4) = str2double(data(5))*m+p;
            q = quatnormalize(q);
            q = match_frame(data(1),q);
            
                
            [~,I1,I2,I3] = parts(quaternion(quatmultiply(q,quatmultiply(qI,quatconj(q)))));
            I = [I1,I2,I3];
            [~,J1,J2,J3] = parts(quaternion(quatmultiply(q,quatmultiply(qJ,quatconj(q)))));
            J = [J1,J2,J3];
            [~,K1,K2,K3] = parts(quaternion(quatmultiply(q,quatmultiply(qK,quatconj(q)))));
            K = [K1,K2,K3];
            
            acos(dot(I,Z))

            figure(1)
            hold on
            delete([E1,E2,E3,V2])
            E1 = plot3([0,I(1)],[0,I(2)],[0,I(3)],'r');  
            E2 = plot3([0,J(1)],[0,J(2)],[0,J(3)],'g');
            E3 = plot3([0,K(1)],[0,K(2)],[0,K(3)],'b');

            


           
    end 
    end
    
end

%% Check match 

delete([E1,E2,E3])

while true
    flushinput(s);
    line = fscanf(s);   % get data if there exists data in the next line
    data = strsplit(string(line),',');
    if(length(data) == 5 || length(data) == 6)
    switch data(1)
        case 'cal'
            switch data(2)
                case 'e'
                    E_mag = str2double(data(3));
                    E_acc = str2double(data(4));
                    E_gyr = str2double(data(5));
                    E_sys = str2double(data(6));  
                    Cal_E = [E_mag E_acc E_gyr E_sys]
                case 'c'
                    C_mag = str2double(data(3));
                    C_acc = str2double(data(4));
                    C_gyr = str2double(data(5));
                    C_sys = str2double(data(6));  
                    Cal_C = [C_mag C_acc C_gyr C_sys]
                case 'a'
                    A_mag = str2double(data(3));
                    A_acc = str2double(data(4));
                    A_gyr = str2double(data(5));
                    A_sys = str2double(data(6));      
                    Cal_A = [A_mag A_acc A_gyr A_sys]
            end  
        case 'd'
            q(1) = str2double(data(2))*m+p;
            q(2) = str2double(data(3))*m+p;
            q(3) = str2double(data(4))*m+p;
            q(4) = str2double(data(5))*m+p;
            q = quatnormalize(q);
            q = match_frame(data(1),q);
            
                
            [~,I1,I2,I3] = parts(quaternion(quatmultiply(q,quatmultiply(qI,quatconj(q)))));
            I = [I1,I2,I3];
            [~,J1,J2,J3] = parts(quaternion(quatmultiply(q,quatmultiply(qJ,quatconj(q)))));
            J = [J1,J2,J3];
            [~,K1,K2,K3] = parts(quaternion(quatmultiply(q,quatmultiply(qK,quatconj(q)))));
            K = [K1,K2,K3];
            
            
            figure(1)
            hold on
            delete([E1,E2,E3])
            E1 = plot3([0,I(1)],[0,I(2)],[0,I(3)],'r');  
            E2 = plot3([0,J(1)],[0,J(2)],[0,J(3)],'g');
            E3 = plot3([0,K(1)],[0,K(2)],[0,K(3)],'b');


 
    end 
    end
    
end
