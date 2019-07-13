clc;clear all;close all
opts = delimitedTextImportOptions("NumVariables", 5);
opts.DataLines = [2, 97];
opts.Delimiter = "\t";
opts.VariableNames = ["Axis", "IMU", "Angle", "Average", "Var5"];
opts.SelectedVariableNames = ["Axis", "IMU", "Angle", "Average"];
opts.VariableTypes = ["string", "string", "string", "string", "char"];
opts = setvaropts(opts, [1, 2, 3, 4, 5], "WhitespaceRule", "preserve");
opts = setvaropts(opts, [1, 2, 3, 4, 5], "EmptyFieldRule", "auto");
opts.ExtraColumnsRule = "ignore";
opts.EmptyLineRule = "read";
ttpa = readtable("F:\github\wearable-jacket\matlab\IEEE_spmb\data_matched\A,B,C,D\turntablepeaksanalysis.txt", opts);
ttpa = table2array(ttpa);
clear opts
l = length(ttpa);
A = zeros(8,4);
B = zeros(8,4);
C = zeros(8,4);
D = zeros(8,4);
A(:,1) = [-80,-60,-40,-20,20,40,60,80];
B(:,1) = [-80,-60,-40,-20,20,40,60,80];
C(:,1) = [-80,-60,-40,-20,20,40,60,80];
D(:,1) = [-80,-60,-40,-20,20,40,60,80];
for i = 1:l

    switch ttpa(i,2)
        
        case 'A'
            
            switch ttpa(i,1)
                
                case 'X'
                    
                    switch ttpa(i,3)
                        case '-80'
                            A(1,2)=str2double(ttpa(i,4));
                        case '-60'
                            A(2,2)=str2double(ttpa(i,4));
                        case '-40'
                            A(3,2)=str2double(ttpa(i,4));
                        case '-20'
                            A(4,2)=str2double(ttpa(i,4));
                        case '20'
                            A(5,2)=str2double(ttpa(i,4)); 
                        case '40'
                            A(6,2)=str2double(ttpa(i,4));
                        case '60'
                            A(7,2)=str2double(ttpa(i,4));
                        case '80'
                            A(8,2)=str2double(ttpa(i,4));
                    end
         
                case 'Y'
                    
                    switch ttpa(i,3)
                        case '-80'
                            A(1,3)=str2double(ttpa(i,4));
                        case '-60'
                            A(2,3)=str2double(ttpa(i,4));
                        case '-40'
                            A(3,3)=str2double(ttpa(i,4));
                        case '-20'
                            A(4,3)=str2double(ttpa(i,4));
                        case '20'
                            A(5,3)=str2double(ttpa(i,4)); 
                        case '40'
                            A(6,3)=str2double(ttpa(i,4));
                        case '60'
                            A(7,3)=str2double(ttpa(i,4));
                        case '80'
                            A(8,3)=str2double(ttpa(i,4));
                    end
                    
                case 'Z'    
               
                    switch ttpa(i,3)
                        case '-80'
                            A(1,4)=str2double(ttpa(i,4));
                        case '-60'
                            A(2,4)=str2double(ttpa(i,4));
                        case '-40'
                            A(3,4)=str2double(ttpa(i,4));
                        case '-20'
                            A(4,4)=str2double(ttpa(i,4));
                        case '20'
                            A(5,4)=str2double(ttpa(i,4)); 
                        case '40'
                            A(6,4)=str2double(ttpa(i,4));
                        case '60'
                            A(7,4)=str2double(ttpa(i,4));
                        case '80'
                            A(8,4)=str2double(ttpa(i,4));
                    end
            
            end
            
            
        case 'B'
            
            switch ttpa(i,1)
                
                case 'X'
                    
                    switch ttpa(i,3)
                        case '-80'
                            B(1,2)=str2double(ttpa(i,4));
                        case '-60'
                            B(2,2)=str2double(ttpa(i,4));
                        case '-40'
                            B(3,2)=str2double(ttpa(i,4));
                        case '-20'
                            B(4,2)=str2double(ttpa(i,4));
                        case '20'
                            B(5,2)=str2double(ttpa(i,4)); 
                        case '40'
                            B(6,2)=str2double(ttpa(i,4));
                        case '60'
                            B(7,2)=str2double(ttpa(i,4));
                        case '80'
                            B(8,2)=str2double(ttpa(i,4));
                    end
         
                case 'Y'
                    
                    switch ttpa(i,3)
                        case '-80'
                            B(1,3)=str2double(ttpa(i,4));
                        case '-60'
                            B(2,3)=str2double(ttpa(i,4));
                        case '-40'
                            B(3,3)=str2double(ttpa(i,4));
                        case '-20'
                            B(4,3)=str2double(ttpa(i,4));
                        case '20'
                            B(5,3)=str2double(ttpa(i,4)); 
                        case '40'
                            B(6,3)=str2double(ttpa(i,4));
                        case '60'
                            B(7,3)=str2double(ttpa(i,4));
                        case '80'
                            B(8,3)=str2double(ttpa(i,4));
                    end
                    
                case 'Z'    
               
                    switch ttpa(i,3)
                        case '-80'
                            B(1,4)=str2double(ttpa(i,4));
                        case '-60'
                            B(2,4)=str2double(ttpa(i,4));
                        case '-40'
                            B(3,4)=str2double(ttpa(i,4));
                        case '-20'
                            B(4,4)=str2double(ttpa(i,4));
                        case '20'
                            B(5,4)=str2double(ttpa(i,4)); 
                        case '40'
                            B(6,4)=str2double(ttpa(i,4));
                        case '60'
                            B(7,4)=str2double(ttpa(i,4));
                        case '80'
                            B(8,4)=str2double(ttpa(i,4));
                    end
            
            end            
            
            
        case 'C'
            
            switch ttpa(i,1)
                
                case 'X'
                    
                    switch ttpa(i,3)
                        case '-80'
                            C(1,2)=str2double(ttpa(i,4));
                        case '-60'
                            C(2,2)=str2double(ttpa(i,4));
                        case '-40'
                            C(3,2)=str2double(ttpa(i,4));
                        case '-20'
                            C(4,2)=str2double(ttpa(i,4));
                        case '20'
                            C(5,2)=str2double(ttpa(i,4)); 
                        case '40'
                            C(6,2)=str2double(ttpa(i,4));
                        case '60'
                            C(7,2)=str2double(ttpa(i,4));
                        case '80'
                            C(8,2)=str2double(ttpa(i,4));
                    end
         
                case 'Y'
                    
                    switch ttpa(i,3)
                        case '-80'
                            C(1,3)=str2double(ttpa(i,4));
                        case '-60'
                            C(2,3)=str2double(ttpa(i,4));
                        case '-40'
                            C(3,3)=str2double(ttpa(i,4));
                        case '-20'
                            C(4,3)=str2double(ttpa(i,4));
                        case '20'
                            C(5,3)=str2double(ttpa(i,4)); 
                        case '40'
                            C(6,3)=str2double(ttpa(i,4));
                        case '60'
                            C(7,3)=str2double(ttpa(i,4));
                        case '80'
                            C(8,3)=str2double(ttpa(i,4));
                    end
                    
                case 'Z'    
               
                    switch ttpa(i,3)
                        case '-80'
                            C(1,4)=str2double(ttpa(i,4));
                        case '-60'
                            C(2,4)=str2double(ttpa(i,4));
                        case '-40'
                            C(3,4)=str2double(ttpa(i,4));
                        case '-20'
                            C(4,4)=str2double(ttpa(i,4));
                        case '20'
                            C(5,4)=str2double(ttpa(i,4)); 
                        case '40'
                            C(6,4)=str2double(ttpa(i,4));
                        case '60'
                            C(7,4)=str2double(ttpa(i,4));
                        case '80'
                            C(8,4)=str2double(ttpa(i,4));
                    end
            
            end                  
            
            
        case 'D'
            
            switch ttpa(i,1)
                
                case 'X'
                    
                    switch ttpa(i,3)
                        case '-80'
                            D(1,2)=str2double(ttpa(i,4));
                        case '-60'
                            D(2,2)=str2double(ttpa(i,4));
                        case '-40'
                            D(3,2)=str2double(ttpa(i,4));
                        case '-20'
                            D(4,2)=str2double(ttpa(i,4));
                        case '20'
                            D(5,2)=str2double(ttpa(i,4)); 
                        case '40'
                            D(6,2)=str2double(ttpa(i,4));
                        case '60'
                            D(7,2)=str2double(ttpa(i,4));
                        case '80'
                            D(8,2)=str2double(ttpa(i,4));
                    end
         
                case 'Y'
                    
                    switch ttpa(i,3)
                        case '-80'
                            D(1,3)=str2double(ttpa(i,4));
                        case '-60'
                            D(2,3)=str2double(ttpa(i,4));
                        case '-40'
                            D(3,3)=str2double(ttpa(i,4));
                        case '-20'
                            D(4,3)=str2double(ttpa(i,4));
                        case '20'
                            D(5,3)=str2double(ttpa(i,4)); 
                        case '40'
                            D(6,3)=str2double(ttpa(i,4));
                        case '60'
                            D(7,3)=str2double(ttpa(i,4));
                        case '80'
                            D(8,3)=str2double(ttpa(i,4));
                    end
                    
                case 'Z'    
               
                    switch ttpa(i,3)
                        case '-80'
                            D(1,4)=str2double(ttpa(i,4));
                        case '-60'
                            D(2,4)=str2double(ttpa(i,4));
                        case '-40'
                            D(3,4)=str2double(ttpa(i,4));
                        case '-20'
                            D(4,4)=str2double(ttpa(i,4));
                        case '20'
                            D(5,4)=str2double(ttpa(i,4)); 
                        case '40'
                            D(6,4)=str2double(ttpa(i,4));
                        case '60'
                            D(7,4)=str2double(ttpa(i,4));
                        case '80'
                            D(8,4)=str2double(ttpa(i,4));
                    end
            
            end                 
            
            
    end
    
    
    
    
    
end

lm_AX = fitlm(A(:,1),A(:,2));
coeffAX = lm_AX.Coefficients.Estimate;
lm_AY = fitlm(A(:,1),A(:,3));
coeffAY = lm_AY.Coefficients.Estimate;
lm_AZ = fitlm(A(:,1),A(:,4));
coeffAZ = lm_AZ.Coefficients.Estimate;
Afit = [A(:,1), coeffAX(2)*A(:,1)+coeffAX(1), coeffAY(2)*A(:,1)+coeffAY(1), coeffAZ(2)*A(:,1)+coeffAZ(1)]; 


lm_BX = fitlm(B(:,1),B(:,2));
coeffBX = lm_AX.Coefficients.Estimate;
lm_BY = fitlm(B(:,1),B(:,3));
coeffBY = lm_BY.Coefficients.Estimate;
lm_BZ = fitlm(B(:,1),B(:,4));
coeffBZ = lm_BZ.Coefficients.Estimate;
Bfit = [B(:,1), coeffBX(2)*B(:,1)+coeffBX(1), coeffBY(2)*B(:,1)+coeffBY(1), coeffBZ(2)*B(:,1)+coeffBZ(1)]; 


lm_CX = fitlm(C(:,1),C(:,2));
coeffCX = lm_CX.Coefficients.Estimate;
lm_CY = fitlm(C(:,1),C(:,3));
coeffCY = lm_CY.Coefficients.Estimate;
lm_CZ = fitlm(C(:,1),C(:,4));
coeffCZ = lm_CZ.Coefficients.Estimate;
Cfit = [C(:,1), coeffCX(2)*C(:,1)+coeffCX(1), coeffCY(2)*C(:,1)+coeffCY(1), coeffCZ(2)*C(:,1)+coeffCZ(1)]; 

lm_DX = fitlm(D(:,1),D(:,2));
coeffDX = lm_DX.Coefficients.Estimate;
lm_DY = fitlm(D(:,1),D(:,3));
coeffDY = lm_DY.Coefficients.Estimate;
lm_DZ = fitlm(D(:,1),D(:,4));
coeffDZ = lm_DZ.Coefficients.Estimate;
Dfit = [D(:,1), coeffDX(2)*D(:,1)+coeffDX(1), coeffDY(2)*D(:,1)+coeffDY(1), coeffDZ(2)*D(:,1)+coeffDZ(1)]; 

fs = 15;

figure(1)
subplot(2,2,1)
hold on
axis([-90 90 -90 90])
plot(A(:,1),A(:,2),'o','Color',[0.8 0 0],'DisplayName','X axis','MarkerSize',8,'LineWidth',1.25)
plot(Afit(:,1),Afit(:,2),'--','Color',[0.8 0 0],'DisplayName','X axis (fitted)')
xlabel('Applied angle on the goniometer moving arm (degrees)','FontSize',fs)
ylabel('WISE A module (degrees)','FontSize',fs)
plot(A(:,1),A(:,3),'*','Color',[0 0.8 0],'DisplayName','Y axis','MarkerSize',8,'LineWidth',1.25)
plot(Afit(:,1),Afit(:,3),'--','Color',[0 0.8 0],'DisplayName','Y axis (fitted)')
plot(A(:,1),A(:,4),'+','Color',[0 0 0.8],'DisplayName','Z axis','MarkerSize',8,'LineWidth',1.25)
plot(Afit(:,1),Afit(:,4),'--','Color',[0 0 0.8],'DisplayName','Z axis (fitted)')
lg = legend;
lg.Position = [0.4586    0.4924    0.1130    0.0568];
lg.FontSize = fs;
text(-80,80,strcat('RMSE_{X}: ',num2str(lm_AX.RMSE),'^{o}'),'FontSize',fs)
text(-80,60,strcat('RMSE_{Y}: ',num2str(lm_AY.RMSE),'^{o}'),'FontSize',fs)
text(-80,40,strcat('RMSE_{Z}: ',num2str(lm_AZ.RMSE),'^{o}'),'FontSize',fs)
text(50,-40,strcat('R^{2}_{X}: ',num2str(lm_AX.Rsquared.Adjusted)),'FontSize',fs)
text(50,-60,strcat('R^{2}_{Y}: ',num2str(lm_AY.Rsquared.Adjusted)),'FontSize',fs)
text(50,-80,strcat('R^{2}_{Z}: ',num2str(lm_AZ.Rsquared.Adjusted)),'FontSize',fs)
hold off
subplot(2,2,2)
hold on
axis([-90 90 -90 90])
plot(B(:,1),B(:,2),'o','Color',[0.8 0 0],'DisplayName','X axis','MarkerSize',8,'LineWidth',1.25)
plot(Bfit(:,1),Bfit(:,2),'--','Color',[0.8 0 0],'DisplayName','X axis (fitted)')
xlabel('Applied angle on the goniometer moving arm (degrees)','FontSize',fs)
ylabel('WISE B module(degrees)','FontSize',fs)
plot(B(:,1),B(:,3),'g*','DisplayName','Y axis','MarkerSize',8,'LineWidth',1.25)
plot(Bfit(:,1),Bfit(:,3),'g--','DisplayName','Y axis (fitted)')
plot(B(:,1),B(:,4),'+','Color',[0 0 0.8],'DisplayName','Z axis','MarkerSize',8,'LineWidth',1.25)
plot(Bfit(:,1),Bfit(:,4),'--','Color',[0 0 0.8],'DisplayName','Z axis (fitted)')
text(-80,80,strcat('RMSE_{X}: ',num2str(lm_BX.RMSE),'^{o}'),'FontSize',fs)
text(-80,60,strcat('RMSE_{Y}: ',num2str(lm_BY.RMSE),'^{o}'),'FontSize',fs)
text(-80,40,strcat('RMSE_{Z}: ',num2str(lm_BZ.RMSE),'^{o}'),'FontSize',fs)
text(50,-40,strcat('R^{2}_{X}: ',num2str(lm_BX.Rsquared.Adjusted)),'FontSize',fs)
text(50,-60,strcat('R^{2}_{Y}: ',num2str(lm_BY.Rsquared.Adjusted)),'FontSize',fs)
text(50,-80,strcat('R^{2}_{Z}: ',num2str(lm_BZ.Rsquared.Adjusted)),'FontSize',fs)
subplot(2,2,3)
hold on
axis([-90 90 -90 90])
plot(C(:,1),C(:,2),'o','Color',[0.8 0 0],'DisplayName','X axis','MarkerSize',8,'LineWidth',1.25)
plot(Cfit(:,1),Cfit(:,2),'--','Color',[0.8 0 0],'DisplayName','X axis (fitted)')
xlabel('Applied angle on the goniometer moving arm (degrees)','FontSize',fs)
ylabel('WISE C module (degrees)','FontSize',fs)
plot(C(:,1),C(:,3),'*','Color',[0 0.8 0],'DisplayName','Y axis','MarkerSize',8,'LineWidth',1.25)
plot(Cfit(:,1),Cfit(:,3),'--','Color',[0 0.8 0],'DisplayName','Y axis (fitted)')
plot(C(:,1),C(:,4),'+','Color',[0 0 0.8],'DisplayName','Z axis','MarkerSize',8,'LineWidth',1.25)
plot(Cfit(:,1),Cfit(:,4),'--','Color',[0 0 0.8],'DisplayName','Z axis (fitted)')
text(-80,80,strcat('RMSE_{X}: ',num2str(lm_CX.RMSE),'^{o}'),'FontSize',fs)
text(-80,60,strcat('RMSE_{Y}: ',num2str(lm_CY.RMSE),'^{o}'),'FontSize',fs)
text(-80,40,strcat('RMSE_{Z}: ',num2str(lm_CZ.RMSE),'^{o}'),'FontSize',fs)
text(50,-40,strcat('R^{2}_{X}: ',num2str(lm_CX.Rsquared.Adjusted)),'FontSize',fs)
text(50,-60,strcat('R^{2}_{Y}: ',num2str(lm_CY.Rsquared.Adjusted)),'FontSize',fs)
text(50,-80,strcat('R^{2}_{Z}: ',num2str(lm_CZ.Rsquared.Adjusted)),'FontSize',fs)
subplot(2,2,4)
hold on
axis([-90 90 -90 90])
plot(D(:,1),D(:,2),'o','Color',[0.8 0 0],'DisplayName','X axis','MarkerSize',8,'LineWidth',1.25)
plot(Dfit(:,1),Dfit(:,2),'--','Color',[0.8 0 0],'DisplayName','X axis (fitted)')
xlabel('Applied angle on the goniometer moving arm (degrees)','FontSize',fs)
ylabel('WISE D module (degrees)','FontSize',fs)
plot(D(:,1),D(:,3),'*','Color',[0 0.8 0],'DisplayName','Y axis','MarkerSize',8,'LineWidth',1.25)
plot(Dfit(:,1),Dfit(:,3),'--','Color',[0 0.8 0],'DisplayName','Y axis (fitted)')
plot(D(:,1),D(:,4),'+','Color',[0 0 0.8],'DisplayName','Z axis','MarkerSize',8,'LineWidth',1.25)
plot(Dfit(:,1),Dfit(:,4),'--','Color',[0 0 0.8],'DisplayName','Z axis (fitted)')
text(-80,80,strcat('RMSE_{X}: ',num2str(lm_DX.RMSE),'^{o}'),'FontSize',fs)
text(-80,60,strcat('RMSE_{Y}: ',num2str(lm_DY.RMSE),'^{o}'),'FontSize',fs)
text(-80,40,strcat('RMSE_{Z}: ',num2str(lm_DZ.RMSE),'^{o}'),'FontSize',fs)
text(50,-40,strcat('R^{2}_{X}: ',num2str(lm_DX.Rsquared.Adjusted)),'FontSize',fs)
text(50,-60,strcat('R^{2}_{Y}: ',num2str(lm_DY.Rsquared.Adjusted)),'FontSize',fs)
text(50,-80,strcat('R^{2}_{Z}: ',num2str(lm_DZ.Rsquared.Adjusted)),'FontSize',fs)