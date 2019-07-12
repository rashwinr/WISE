function [t1,t2,t3,t4] = anglerad2degrees(theta1,theta2,theta3,theta4,char,char2,fid)

if(str2double(char)>0)
theta1 = theta1*180/pi;
theta2 = theta2*180/pi;
theta3 = theta3*180/pi;
theta4 = theta4*180/pi;
theta1 = theta1-min(theta1);
theta2 = theta2-min(theta2);
theta3 = theta3-min(theta3);
theta4 = theta4-min(theta4);

tp1 = findpeaks(theta1,'MinPeakHeight',0.8*str2double(char),'MinPeakProminence',0.75*str2double(char));
tp2 = findpeaks(theta2,'MinPeakHeight',0.8*str2double(char),'MinPeakProminence',0.75*str2double(char));
tp3 = findpeaks(theta3,'MinPeakHeight',0.8*str2double(char),'MinPeakProminence',0.75*str2double(char));
tp4 = findpeaks(theta4,'MinPeakHeight',0.8*str2double(char),'MinPeakProminence',0.75*str2double(char));
                                 

switch char2
    
    case 'X'
        switch char
            case '20'
                fprintf(fid,'X, Angle: 20,A,%.2f\n',tp1);
                fprintf(fid,'X, Angle: 20,B,%.2f\n',tp2);
                fprintf(fid,'X, Angle: 20,C,%.2f\n',tp3);
                fprintf(fid,'X, Angle: 20,D,%.2f\n',tp3);
            case '40'
                fprintf(fid,'X, Angle: 40,A,%.2f\n',tp1);
                fprintf(fid,'X, Angle: 40,B,%.2f\n',tp2);
                fprintf(fid,'X, Angle: 40,C,%.2f\n',tp3);
                fprintf(fid,'X, Angle: 40,D,%.2f\n',tp4);
            case '60'
                fprintf(fid,'X, Angle: 60,A,%.2f\n',tp1);
                fprintf(fid,'X, Angle: 60,B,%.2f\n',tp2);
                fprintf(fid,'X, Angle: 60,C,%.2f\n',tp3);
                fprintf(fid,'X, Angle: 60,D,%.2f\n',tp4);
            case '80'
                fprintf(fid,'X, Angle: 80,A,%.2f\n',tp1);
                fprintf(fid,'X, Angle: 80,B,%.2f\n',tp2);
                fprintf(fid,'X, Angle: 80,C,%.2f\n',tp3);
                fprintf(fid,'X, Angle: 80,D,%.2f\n',tp4);
        end
    case 'Y'
        switch char
            case '20'
                fprintf(fid,'Y, Angle: 20,A,%.2f\n',tp1);
                fprintf(fid,'Y, Angle: 20,B,%.2f\n',tp2);
                fprintf(fid,'Y, Angle: 20,C,%.2f\n',tp3);
                fprintf(fid,'Y, Angle: 20,D,%.2f\n',tp4);
            case '40'
                fprintf(fid,'Y, Angle: 40,A,%.2f\n',tp1);
                fprintf(fid,'Y, Angle: 40,B,%.2f\n',tp2);
                fprintf(fid,'Y, Angle: 40,C,%.2f\n',tp3);
                fprintf(fid,'Y, Angle: 40,D,%.2f\n',tp4);
            case '60'
                fprintf(fid,'Y, Angle: 60,A,%.2f\n',tp1);
                fprintf(fid,'Y, Angle: 60,B,%.2f\n',tp2);
                fprintf(fid,'Y, Angle: 60,C,%.2f\n',tp3);
                fprintf(fid,'Y, Angle: 60,D,%.2f\n',tp4);
            case '80'
                fprintf(fid,'Y, Angle: 80,A,%.2f\n',tp1);
                fprintf(fid,'Y, Angle: 80,B,%.2f\n',tp2);
                fprintf(fid,'Y, Angle: 80,C,%.2f\n',tp3);
                fprintf(fid,'Y, Angle: 80,D,%.2f\n',tp4);
        end
    case 'Z'
        switch char
            case '20'
                fprintf(fid,'Z, Angle: 20,A,%.2f\n',tp1);
                fprintf(fid,'Z, Angle: 20,B,%.2f\n',tp2);
                fprintf(fid,'Z, Angle: 20,C,%.2f\n',tp3);
                fprintf(fid,'Z, Angle: 20,D,%.2f\n',tp4);
            case '40'
                fprintf(fid,'Z, Angle: 40,A,%.2f\n',tp1);
                fprintf(fid,'Z, Angle: 40,B,%.2f\n',tp2);
                fprintf(fid,'Z, Angle: 40,C,%.2f\n',tp3);
                fprintf(fid,'Z, Angle: 40,D,%.2f\n',tp4);
            case '60'
                fprintf(fid,'Z, Angle: 60,A,%.2f\n',tp1);
                fprintf(fid,'Z, Angle: 60,B,%.2f\n',tp2);
                fprintf(fid,'Z, Angle: 60,C,%.2f\n',tp3);
                fprintf(fid,'Z, Angle: 60,D,%.2f\n',tp4);
            case '80'
                fprintf(fid,'Z, Angle: 80,A,%.2f\n',tp1);
                fprintf(fid,'Z, Angle: 80,B,%.2f\n',tp2);
                fprintf(fid,'Z, Angle: 80,C,%.2f\n',tp3);
                fprintf(fid,'Z, Angle: 80,D,%.2f\n',tp4);
        end
end

end

if(str2double(char)<=0)
theta1 = theta1*180/pi;
theta2 = theta2*180/pi;
theta3 = theta3*180/pi;
theta4 = theta4*180/pi;
theta1 = theta1-max(theta1);
theta2 = theta2-max(theta2);
theta3 = theta3-max(theta3);
theta4 = theta4-max(theta4);

tw1 = findpeaks(-1*theta1,'MinPeakHeight',-0.8*str2double(char),'MinPeakProminence',-0.75*str2double(char));
tw2 = findpeaks(-1*theta2,'MinPeakHeight',-0.8*str2double(char),'MinPeakProminence',-0.75*str2double(char));
tw3 = findpeaks(-1*theta3,'MinPeakHeight',-0.8*str2double(char),'MinPeakProminence',-0.75*str2double(char));
tw4 = findpeaks(-1*theta4,'MinPeakHeight',-0.8*str2double(char),'MinPeakProminence',-0.75*str2double(char));

switch char2
    
    case 'X'
        switch char
            case '-20'
                fprintf(fid,'X, Angle: -20,A,%.2f\n',-1*tw1);
                fprintf(fid,'X, Angle: -20,B,%.2f\n',-1*tw2);
                fprintf(fid,'X, Angle: -20,C,%.2f\n',-1*tw3);
                fprintf(fid,'X, Angle: -20,D,%.2f\n',-1*tw4);
            case '-40'
                fprintf(fid,'X, Angle: -40,A,%.2f\n',-1*tw1);
                fprintf(fid,'X, Angle: -40,B,%.2f\n',-1*tw2);
                fprintf(fid,'X, Angle: -40,C,%.2f\n',-1*tw3);
                fprintf(fid,'X, Angle: -40,D,%.2f\n',-1*tw4);
            case '-60'
                fprintf(fid,'X, Angle: -60,A,%.2f\n',-1*tw1);
                fprintf(fid,'X, Angle: -60,B,%.2f\n',-1*tw2);
                fprintf(fid,'X, Angle: -60,C,%.2f\n',-1*tw3);
                fprintf(fid,'X, Angle: -60,D,%.2f\n',-1*tw4);
            case '-80'
                fprintf(fid,'X, Angle: -80,A,%.2f\n',-1*tw1);
                fprintf(fid,'X, Angle: -80,B,%.2f\n',-1*tw2);
                fprintf(fid,'X, Angle: -80,C,%.2f\n',-1*tw3);
                fprintf(fid,'X, Angle: -80,D,%.2f\n',-1*tw4);
        end
    case 'Y'
        switch char
            case '-20'
                fprintf(fid,'Y, Angle: -20,A,%.2f\n',-1*tw1);
                fprintf(fid,'Y, Angle: -20,B,%.2f\n',-1*tw2);
                fprintf(fid,'Y, Angle: -20,C,%.2f\n',-1*tw3);
                fprintf(fid,'Y, Angle: -20,D,%.2f\n',-1*tw4);
            case '-40'
                fprintf(fid,'Y, Angle: -40,A,%.2f\n',-1*tw1);
                fprintf(fid,'Y, Angle: -40,B,%.2f\n',-1*tw2);
                fprintf(fid,'Y, Angle: -40,C,%.2f\n',-1*tw3);
                fprintf(fid,'Y, Angle: -40,D,%.2f\n',-1*tw4);
            case '-60'
                fprintf(fid,'Y, Angle: -60,A,%.2f\n',-1*tw1);
                fprintf(fid,'Y, Angle: -60,B,%.2f\n',-1*tw2);
                fprintf(fid,'Y, Angle: -60,C,%.2f\n',-1*tw3);
                fprintf(fid,'Y, Angle: -60,D,%.2f\n',-1*tw4);
            case '-80'
                fprintf(fid,'Y, Angle: -80,A,%.2f\n',-1*tw1);
                fprintf(fid,'Y, Angle: -80,B,%.2f\n',-1*tw2);
                fprintf(fid,'Y, Angle: -80,C,%.2f\n',-1*tw3);
                fprintf(fid,'Y, Angle: -80,D,%.2f\n',-1*tw4);
        end
    case 'Z'
        switch char
            case '-20'
                fprintf(fid,'Z, Angle: -20,A,%.2f\n',-1*tw1);
                fprintf(fid,'Z, Angle: -20,B,%.2f\n',-1*tw2);
                fprintf(fid,'Z, Angle: -20,C,%.2f\n',-1*tw3);
                fprintf(fid,'Z, Angle: -20,D,%.2f\n',-1*tw4);
            case '-40'
                fprintf(fid,'Z, Angle: -40,A,%.2f\n',-1*tw1);
                fprintf(fid,'Z, Angle: -40,B,%.2f\n',-1*tw2);
                fprintf(fid,'Z, Angle: -40,C,%.2f\n',-1*tw3);
                fprintf(fid,'Z, Angle: -40,D,%.2f\n',-1*tw4);
            case '-60'
                fprintf(fid,'Z, Angle: -60,A,%.2f\n',-1*tw1);
                fprintf(fid,'Z, Angle: -60,B,%.2f\n',-1*tw2);
                fprintf(fid,'Z, Angle: -60,C,%.2f\n',-1*tw3);
                fprintf(fid,'Z, Angle: -60,D,%.2f\n',-1*tw4);
            case '-80'
                fprintf(fid,'Z, Angle: -80,A,%.2f\n',-1*tw1);
                fprintf(fid,'Z, Angle: -80,B,%.2f\n',-1*tw2);
                fprintf(fid,'Z, Angle: -80,C,%.2f\n',-1*tw3);
                fprintf(fid,'Z, Angle: -80,D,%.2f\n',-1*tw4);
        end
end

end
t1 = theta1;
t2 = theta2;
t3 = theta3;
t4 = theta4;






end

