function [t1,t2] = anglerad2degreesLFRF(theta1,theta2,char,char2,fid)

if(str2double(char)>0)

theta1 = theta1-min(theta1);
theta2 = theta2-min(theta2);


tp1 = findpeaks(theta1,'MinPeakHeight',0.8*str2double(char),'MinPeakProminence',0.75*str2double(char));
tp2 = findpeaks(theta2,'MinPeakHeight',0.8*str2double(char),'MinPeakProminence',0.75*str2double(char));

                                 

switch char2
    
    case 'X'
        switch char
            case '20'
                fprintf(fid,'X, Angle: 20,LF,%.2f\n',tp1);
                fprintf(fid,'X, Angle: 20,RF,%.2f\n',tp2);
            case '40'
                fprintf(fid,'X, Angle: 40,LF,%.2f\n',tp1);
                fprintf(fid,'X, Angle: 40,RF,%.2f\n',tp2);

            case '60'
                fprintf(fid,'X, Angle: 60,LF,%.2f\n',tp1);
                fprintf(fid,'X, Angle: 60,RF,%.2f\n',tp2);

            case '80'
                fprintf(fid,'X, Angle: 80,LF,%.2f\n',tp1);
                fprintf(fid,'X, Angle: 80,RF,%.2f\n',tp2);

        end
    case 'Y'
        switch char
            case '20'
                fprintf(fid,'Y, Angle: 20,LF,%.2f\n',tp1);
                fprintf(fid,'Y, Angle: 20,RF,%.2f\n',tp2);

            case '40'
                fprintf(fid,'Y, Angle: 40,LF,%.2f\n',tp1);
                fprintf(fid,'Y, Angle: 40,RF,%.2f\n',tp2);

            case '60'
                fprintf(fid,'Y, Angle: 60,LF,%.2f\n',tp1);
                fprintf(fid,'Y, Angle: 60,RF,%.2f\n',tp2);

            case '80'
                fprintf(fid,'Y, Angle: 80,LF,%.2f\n',tp1);
                fprintf(fid,'Y, Angle: 80,RF,%.2f\n',tp2);

        end
    case 'Z'
        switch char
            case '20'
                fprintf(fid,'Z, Angle: 20,LF,%.2f\n',tp1);
                fprintf(fid,'Z, Angle: 20,RF,%.2f\n',tp2);

            case '40'
                fprintf(fid,'Z, Angle: 40,LF,%.2f\n',tp1);
                fprintf(fid,'Z, Angle: 40,RF,%.2f\n',tp2);

            case '60'
                fprintf(fid,'Z, Angle: 60,LF,%.2f\n',tp1);
                fprintf(fid,'Z, Angle: 60,RF,%.2f\n',tp2);

            case '80'
                fprintf(fid,'Z, Angle: 80,LF,%.2f\n',tp1);
                fprintf(fid,'Z, Angle: 80,RF,%.2f\n',tp2);

        end
end

end

if(str2double(char)<=0)

theta1 = theta1-max(theta1);
theta2 = theta2-max(theta2);


tw1 = findpeaks(-1*theta1,'MinPeakHeight',-0.8*str2double(char),'MinPeakProminence',-0.75*str2double(char));
tw2 = findpeaks(-1*theta2,'MinPeakHeight',-0.8*str2double(char),'MinPeakProminence',-0.75*str2double(char));


switch char2
    
    case 'X'
        switch char
            case '-20'
                fprintf(fid,'X, Angle: -20,LF,%.2f\n',-1*tw1);
                fprintf(fid,'X, Angle: -20,RF,%.2f\n',-1*tw2);

            case '-40'
                fprintf(fid,'X, Angle: -40,LF,%.2f\n',-1*tw1);
                fprintf(fid,'X, Angle: -40,RF,%.2f\n',-1*tw2);

            case '-60'
                fprintf(fid,'X, Angle: -60,LF,%.2f\n',-1*tw1);
                fprintf(fid,'X, Angle: -60,RF,%.2f\n',-1*tw2);

            case '-80'
                fprintf(fid,'X, Angle: -80,LF,%.2f\n',-1*tw1);
                fprintf(fid,'X, Angle: -80,RF,%.2f\n',-1*tw2);

        end
    case 'Y'
        switch char
            case '-20'
                fprintf(fid,'Y, Angle: -20,LF,%.2f\n',-1*tw1);
                fprintf(fid,'Y, Angle: -20,RF,%.2f\n',-1*tw2);

            case '-40'
                fprintf(fid,'Y, Angle: -40,LF,%.2f\n',-1*tw1);
                fprintf(fid,'Y, Angle: -40,RF,%.2f\n',-1*tw2);

            case '-60'
                fprintf(fid,'Y, Angle: -60,LF,%.2f\n',-1*tw1);
                fprintf(fid,'Y, Angle: -60,RF,%.2f\n',-1*tw2);

            case '-80'
                fprintf(fid,'Y, Angle: -80,LF,%.2f\n',-1*tw1);
                fprintf(fid,'Y, Angle: -80,RF,%.2f\n',-1*tw2);

        end
    case 'Z'
        switch char
            case '-20'
                fprintf(fid,'Z, Angle: -20,LF,%.2f\n',-1*tw1);
                fprintf(fid,'Z, Angle: -20,RF,%.2f\n',-1*tw2);

            case '-40'
                fprintf(fid,'Z, Angle: -40,LF,%.2f\n',-1*tw1);
                fprintf(fid,'Z, Angle: -40,RF,%.2f\n',-1*tw2);

            case '-60'
                fprintf(fid,'Z, Angle: -60,LF,%.2f\n',-1*tw1);
                fprintf(fid,'Z, Angle: -60,RF,%.2f\n',-1*tw2);

            case '-80'
                fprintf(fid,'Z, Angle: -80,LF,%.2f\n',-1*tw1);
                fprintf(fid,'Z, Angle: -80,RF,%.2f\n',-1*tw2);

        end
end

end
t1 = theta1;
t2 = theta2;

end

