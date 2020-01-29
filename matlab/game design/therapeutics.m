clc;
clear all;
close all;

A = importJCS4therapy('F:\github\wearable-jacket\matlab\game design\data\BI_abdadd.txt');
B = table2array(A);
time = round(B(:,1),2);
lsp = round(B(:,2),2);
lse = round(B(:,3),2);
lie = round(B(:,4),2);
lelbfe = round(B(:,5),2);
lca = round(B(:,6),2);
lps = round(B(:,7),2);
rsp = round(B(:,8),2);
rse = round(B(:,9),2);
rie = round(B(:,10),2);
relbfe = round(B(:,11),2);
rca = round(B(:,12),2);
rps = round(B(:,13),2);
clearvars A B

% Plotting the data
% figure(1)
% subplot(2,2,1)
% plot(time,lsp);
% hold on
% plot(time,lse);
% plot(time,lie);
% subplot(2,2,2)
% plot(time,rsp);
% hold on
% plot(time,rse);
% plot(time,rie);
% subplot(2,2,3)
% plot(time,lelbfe);
% hold on
% plot(time,lca);
% plot(time,lps);
% subplot(2,2,4)
% plot(time,relbfe);
% hold on
% plot(time,rca);
% plot(time,rps);

[poly_abdadd_lsp,~] = polyfit(lse,lsp,4);
[poly_abdadd_lie,~] = polyfit(lse,lie,4);
[poly_abdadd_lelbfe,~] = polyfit(lse,lelbfe,2);
[poly_abdadd_lps,~] = polyfit(lse,lps,2);

lse_created = -10:1:180;
abdadd_lsp = polyval(poly_abdadd_lsp,lse_created);
abdadd_lie = polyval(poly_abdadd_lie,lse_created);
abdadd_lelbfe = polyval(poly_abdadd_lelbfe,lse_created);
abdadd_lps = polyval(poly_abdadd_lps,lse_created);

% Plotting the fitted models
figure(2)
subplot(2,1,1)
plot(lse_created,abdadd_lsp);
hold on
plot(lse_created,abdadd_lie);

subplot(2,1,2)
plot(lse_created,abdadd_lelbfe);
hold on
plot(lse_created,abdadd_lps);


Z = [lse_created;abdadd_lsp;abdadd_lie;abdadd_lelbfe;abdadd_lps];
J_abd = zeros(length(time),5);
for i = 1:length(time)
   J_abd(i,1) =  abs(abdadd_lsp(find(lse_created==round(lse(i))))-lsp(i));
   J_abd(i,2) =  abs(abdadd_lie(find(lse_created==round(lse(i))))-lie(i));
   J_abd(i,3) =  abs(abdadd_lelbfe(find(lse_created==round(lse(i))))-lelbfe(i));
   J_abd(i,4) =  abs(abdadd_lps(find(lse_created==round(lse(i))))-lps(i)); 
   J_abd(i,5) = J_abd(i,1)+J_abd(i,2)+J_abd(i,3)+J_abd(i,4);
end


J_abd(:,1) = J_abd(:,1);
J_abd(:,2) = J_abd(:,2);
J_abd(:,3) = J_abd(:,3);
J_abd(:,4) = J_abd(:,3);
J_abd(:,5) = J_abd(:,5);

Jsum_abd = [sum(J_abd(:,1))/sum(J_abd(:,5)) sum(J_abd(:,2))/sum(J_abd(:,5)) sum(J_abd(:,3))/sum(J_abd(:,5)) sum(J_abd(:,4))/sum(J_abd(:,5)) sum(J_abd(:,5))/sum(J_abd(:,5))];


figure(3)
subplot(2,1,1)
plot(time,J_abd(:,1));
hold on
plot(time,J_abd(:,2));

subplot(2,1,2)
plot(time,J_abd(:,3));
hold on
plot(time,J_abd(:,4));

clearvars lps lsp lse lie lca lelbfe rps rsp rse rie rca relbfe 


%%



A = importJCS4therapy('F:\github\wearable-jacket\matlab\game design\data\BI_fe.txt');
B = table2array(A);
time = round(B(:,1),2);
lsp = round(B(:,2),2);
lse = round(B(:,3),2);
lie = round(B(:,4),2);
lelbfe = round(B(:,5),2);
lca = round(B(:,6),2);
lps = round(B(:,7),2);
rsp = round(B(:,8),2);
rse = round(B(:,9),2);
rie = round(B(:,10),2);
relbfe = round(B(:,11),2);
rca = round(B(:,12),2);
rps = round(B(:,13),2);
clearvars A B

% Plotting the data
% figure(1)
% subplot(2,2,1)
% plot(time,lsp);
% hold on
% plot(time,lse);
% plot(time,lie);
% subplot(2,2,2)
% plot(time,rsp);
% hold on
% plot(time,rse);
% plot(time,rie);
% subplot(2,2,3)
% plot(time,lelbfe);
% hold on
% plot(time,lca);
% plot(time,lps);
% subplot(2,2,4)
% plot(time,relbfe);
% hold on
% plot(time,rca);
% plot(time,rps);

[poly_fe_lsp,~] = polyfit(lse,lsp,4);
[poly_fe_lie,~] = polyfit(lse,lie,3);
[poly_fe_lelbfe,~] = polyfit(lse,lelbfe,1);
[poly_fe_lps,~] = polyfit(lse,lps,1);

lse_created = -10:1:180;
fe_lsp = polyval(poly_fe_lsp,lse_created);
fe_lie = polyval(poly_fe_lie,lse_created);
fe_lelbfe = polyval(poly_fe_lelbfe,lse_created);
fe_lps = polyval(poly_fe_lps,lse_created);

% Plotting the fitted models

% figure(2)
% subplot(2,1,1)
% plot(lse_created,fe_lsp);
% hold on
% plot(lse_created,fe_lie);
% hold off
% subplot(2,1,2)
% plot(lse_created,fe_lelbfe);
% hold on
% plot(lse_created,fe_lps);
% hold off

Z = [lse_created;fe_lsp;fe_lie;fe_lelbfe;fe_lps];
J_fe = zeros(length(time),5);
for i = 1:length(time)
   J_fe(i,1) =  abs(fe_lsp(find(lse_created==round(lse(i))))-lsp(i));
   J_fe(i,2) =  abs(fe_lie(find(lse_created==round(lse(i))))-lie(i));
   J_fe(i,3) =  abs(fe_lelbfe(find(lse_created==round(lse(i))))-lelbfe(i));
   J_fe(i,4) =  abs(fe_lps(find(lse_created==round(lse(i))))-lps(i)); 
   J_fe(i,5) = J_fe(i,1)+J_fe(i,2)+J_fe(i,3)+J_fe(i,4);
end


J_fe(:,1) = J_fe(:,1);
J_fe(:,2) = J_fe(:,2);
J_fe(:,3) = J_fe(:,3);
J_fe(:,4) = J_fe(:,3);
J_fe(:,5) = J_fe(:,5);

Jsum_fe = [sum(J_fe(:,1))/sum(J_fe(:,5)) sum(J_fe(:,2))/sum(J_fe(:,5)) sum(J_fe(:,3))/sum(J_fe(:,5)) sum(J_fe(:,4))/sum(J_fe(:,5)) sum(J_fe(:,5))/sum(J_fe(:,5))];


figure(3)
subplot(2,1,1)
plot(time,J_fe(:,1));
hold on
plot(time,J_fe(:,2));

subplot(2,1,2)
plot(time,J_fe(:,3));
hold on
plot(time,J_fe(:,4));

clearvars lps lsp lse lie lca lelbfe rps rsp rse rie rca relbfe 

%%