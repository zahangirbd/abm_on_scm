%Analisi dati - Data analysis

%numero switch - switch number, n means number, for example, nswitch means number of switch
for j=1:z
nswitch(j,1)=sum(B(:,11,j));
nswitch(j,2)=sum(S1(:,11,j));
nswitch(j,3)=sum(S21(:,11,j));
nswitch(j,4)=sum(S22(:,11,j));
nswitch(j,5)=sum(S3(:,11,j));
nswitch(j,6)=sum(RM1(:,11,j));
nswitch(j,7)=sum(RM2(:,11,j));
nswitch(j,8)=sum(RM3(:,11,j));
nswitch(j,9)=sum(RM4(:,11,j));
nswitch(j,10)=sum(RM5(:,11,j));
j=j+1;
end
for t=1:10
nswitchmedio(1,t)=sum(nswitch(:,t))/z; %medio-average
nswitchmedio(2,t)=std(nswitch(:,t));
end
%numero forced - forced number
for j=1:z
nforced(j,1)=sum(B(:,16,j));
nforced(j,2)=sum(S1(:,16,j));
nforced(j,3)=sum(S21(:,16,j));
nforced(j,4)=sum(S22(:,16,j));
nforced(j,5)=sum(S3(:,16,j));
nforced(j,6)=sum(RM1(:,16,j));
nforced(j,7)=sum(RM2(:,16,j));
nforced(j,8)=sum(RM3(:,16,j));
nforced(j,9)=sum(RM4(:,16,j));
nforced(j,10)=sum(RM5(:,16,j));
j=j+1;
end
for t=1:10
nforcemedio(1,t)=sum(nforced(:,t))/z;
nforcemedio(2,t)=std(nforced(:,t));
end
%ricavi - revenues
% t=0;
% j=0;
% for j=1:z
% MediaRicavi(j,1)=sum(B(:,12,j))/(i);
% MediaRicavi(j,2)=sum(S1(:,12,j))/(i);
% MediaRicavi(j,3)=sum(S21(:,12,j))/(i);
% MediaRicavi(j,4)=sum(S22(:,12,j))/(i);
% MediaRicavi(j,5)=sum(S3(:,12,j))/(i);
% MediaRicavi(j,6)=sum(RM1(:,12,j))/(i);
% MediaRicavi(j,7)=sum(RM2(:,12,j))/(i);
% MediaRicavi(j,8)=sum(RM3(:,12,j))/(i);
% MediaRicavi(j,9)=sum(RM4(:,12,j))/(i);
% MediaRicavi(j,10)=sum(RM5(:,12,j))/(i);
% j=j+1;
% end
% for t=1:10
% Ricavimedio(1,t)=sum(MediaRicavi(:,t))/z;
% end
j=0;
t=0;
for j=1:i
    RicaviTempo(j,1)=mean(B(j,12,:));
    RicaviTempo(j,2)=mean(S1(j,12,:));
    RicaviTempo(j,3)=mean(S21(j,12,:));
    RicaviTempo(j,4)=mean(S22(j,12,:));
    RicaviTempo(j,5)=mean(S3(j,12,:));
    RicaviTempo(j,6)=mean(RM1(j,12,:));
    RicaviTempo(j,7)=mean(RM2(j,12,:));
    RicaviTempo(j,8)=mean(RM3(j,12,:));
    RicaviTempo(j,9)=mean(RM4(j,12,:));
    RicaviTempo(j,10)=mean(RM5(j,12,:));
    j=j+1;
end
for t=1:10
RicaviTotali(1,t)=sum(RicaviTempo(:,t));
end
j=0;
t=0;
for j=1:i
    RicaviStd(j,1)=std(B(j,12,:),0,3);
    RicaviStd(j,2)=std(S1(j,12,:),0,3);
    RicaviStd(j,3)=std(S21(j,12,:),0,3);
    RicaviStd(j,4)=std(S22(j,12,:),0,3);
    RicaviStd(j,5)=std(S3(j,12,:),0,3);
    RicaviStd(j,6)=std(RM1(j,12,:),0,3);
    RicaviStd(j,7)=std(RM2(j,12,:),0,3);
    RicaviStd(j,8)=std(RM3(j,12,:),0,3);
    RicaviStd(j,9)=std(RM4(j,12,:),0,3);
    RicaviStd(j,10)=std(RM5(j,12,:),0,3);
    j=j+1;
end
j=0;
t=0;
%profitti - profits
% t=0;
% j=0;
% for j=1:z
% MediaProfitto(j,1)=sum(B(:,13,j))/(i);
% MediaProfitto(j,2)=sum(S1(:,13,j))/(i);
% MediaProfitto(j,3)=sum(S21(:,13,j))/(i);
% MediaProfitto(j,4)=sum(S22(:,13,j))/(i);
% MediaProfitto(j,5)=sum(S3(:,13,j))/(i);
% MediaProfitto(j,6)=sum(RM1(:,13,j))/(i);
% MediaProfitto(j,7)=sum(RM2(:,13,j))/(i);
% MediaProfitto(j,8)=sum(RM3(:,13,j))/(i);
% MediaProfitto(j,9)=sum(RM4(:,13,j))/(i);
% MediaProfitto(j,10)=sum(RM5(:,13,j))/(i);
% j=j+1;
% end
% for t=1:10
% Profittomedio(1,t)=sum(MediaProfitto(:,t))/z;
% end
j=0;
t=0;
for j=1:i
    ProfittoTempo(j,1)=mean(B(j,13,:));
    ProfittoTempo(j,2)=mean(S1(j,13,:));
    ProfittoTempo(j,3)=mean(S21(j,13,:));
    ProfittoTempo(j,4)=mean(S22(j,13,:));
    ProfittoTempo(j,5)=mean(S3(j,13,:));
    ProfittoTempo(j,6)=mean(RM1(j,13,:));
    ProfittoTempo(j,7)=mean(RM2(j,13,:));
    ProfittoTempo(j,8)=mean(RM3(j,13,:));
    ProfittoTempo(j,9)=mean(RM4(j,13,:));
    ProfittoTempo(j,10)=mean(RM5(j,13,:));
    j=j+1;
end

j=0;
t=0;
for j=1:i
    ProfittoStd(j,1)=std(B(j,13,:),0,3);
    ProfittoStd(j,2)=std(S1(j,13,:),0,3);
    ProfittoStd(j,3)=std(S21(j,13,:),0,3);
    ProfittoStd(j,4)=std(S22(j,13,:),0,3);
    ProfittoStd(j,5)=std(S3(j,13,:),0,3);
    ProfittoStd(j,6)=std(RM1(j,13,:),0,3);
    ProfittoStd(j,7)=std(RM2(j,13,:),0,3);
    ProfittoStd(j,8)=std(RM3(j,13,:),0,3);
    ProfittoStd(j,9)=std(RM4(j,13,:),0,3);
    ProfittoStd(j,10)=std(RM5(j,13,:),0,3);
    j=j+1;
end
% j=0;
% t=0;
% for t=1:10
% ProfittoTotale(1,t)=sum(ProfittoTempo(:,t));
% ProfittoTotale(2,t)=sum(ProfittoStd(:,t));
% end
j=0;
t=0;
for j=1:z
    ProfittoTotale(1,1,j)=sum(B(:,13,j));
    ProfittoTotale(1,2,j)=sum(S1(:,13,j));
    ProfittoTotale(1,3,j)=sum(S21(:,13,j));
    ProfittoTotale(1,4,j)=sum(S22(:,13,j));
    ProfittoTotale(1,5,j)=sum(S3(:,13,j));
    ProfittoTotale(1,6,j)=sum(RM1(:,13,j));
    ProfittoTotale(1,7,j)=sum(RM2(:,13,j));
    ProfittoTotale(1,8,j)=sum(RM3(:,13,j));
    ProfittoTotale(1,9,j)=sum(RM4(:,13,j));
    ProfittoTotale(1,10,j)=sum(RM5(:,13,j));
    j=j+1;
end

%Power Imbalance
t=0;
j=0;
% for j=1:z
% MediaPower(j,1)=sum(B(:,14,j))/(i);
% MediaPower(j,2)=sum(S1(:,14,j))/(i);
% MediaPower(j,3)=sum(S21(:,14,j))/(i);
% MediaPower(j,4)=sum(S22(:,14,j))/(i);
% MediaPower(j,5)=sum(S3(:,14,j))/(i);
% MediaPower(j,6)=sum(RM1(:,14,j))/(i);
% MediaPower(j,7)=sum(RM2(:,14,j))/(i);
% MediaPower(j,8)=sum(RM3(:,14,j))/(i);
% MediaPower(j,9)=sum(RM4(:,14,j))/(i);
% MediaPower(j,10)=sum(RM5(:,14,j))/(i);
% j=j+1;
% end
% j=0;
% for t=1:10
% Poweromedio(1,t)=sum(MediaPower(:,t))/z;
% end
for j=1:i
    PowerTempo(j,1)=mean(B(j,14,:));
    PowerTempo(j,2)=mean(S1(j,14,:));
    PowerTempo(j,3)=mean(S21(j,14,:));
    PowerTempo(j,4)=mean(S22(j,14,:));
    PowerTempo(j,5)=mean(S3(j,14,:));
    PowerTempo(j,6)=mean(RM1(j,14,:));
    PowerTempo(j,7)=mean(RM2(j,14,:));
    PowerTempo(j,8)=mean(RM3(j,14,:));
    PowerTempo(j,9)=mean(RM4(j,14,:));
    PowerTempo(j,10)=mean(RM5(j,14,:));
    j=j+1;
end

j=0;
t=0;
for j=1:i
    PowerStd(j,1)=std(B(j,14,:),0,3);
    PowerStd(j,2)=std(S1(j,14,:),0,3);
    PowerStd(j,3)=std(S21(j,14,:),0,3);
    PowerStd(j,4)=std(S22(j,14,:),0,3);
    PowerStd(j,5)=std(S3(j,14,:),0,3);
    PowerStd(j,6)=std(RM1(j,14,:),0,3);
    PowerStd(j,7)=std(RM2(j,14,:),0,3);
    PowerStd(j,8)=std(RM3(j,14,:),0,3);
    PowerStd(j,9)=std(RM4(j,14,:),0,3);
    PowerStd(j,10)=std(RM5(j,14,:),0,3);
    j=j+1;
end
j=0;
t=0;
for j=1:z;
nsqueezed(j,1)=sum(B(:,7,j));
nsqueezed(j,2)=sum(S1(:,7,j));
nsqueezed(j,3)=sum(S21(:,7,j));
nsqueezed(j,4)=sum(S22(:,7,j));
nsqueezed(j,5)=sum(S3(:,7,j));
end
for t=1:5;
nsqueezemedio(1,t)=mean(nsqueezed(:,t));
nsqueezemedio(2,t)=std(nsqueezed(:,t));
end
j=0;
t=0;
for j=1:z;
ncost(j,1)=sum(S1(:,10,j));
ncost(j,2)=sum(S21(:,10,j));
ncost(j,3)=sum(S22(:,10,j));
ncost(j,4)=sum(S3(:,10,j));
ncost(j,5)=sum(RM1(:,10,j));
ncost(j,6)=sum(RM2(:,10,j));
ncost(j,7)=sum(RM3(:,10,j));
ncost(j,8)=sum(RM4(:,10,j));
ncost(j,9)=sum(RM5(:,10,j));
end
for t=1:9;
ncostmedio(1,t)=mean(ncost(:,t));
ncostmedio(2,t)=std(ncost(:,t));
end
j=0;
for j=1:z;
createdvalue(1,j)=sum(Quantity(:,j));
createdvalueteorico(1,j)=sum(Q(:,j));
end
createdvaluemedio(1,1)=(mean(createdvalue(1,:))/mean(createdvalueteorico(1,:)));
createdvaluemedio(1,2)=std(createdvalue(1,:)/createdvalueteorico(1,:));
j=0;
for j=1:z;
    exit(1,j)=sum(B(:,28,j));
end
exitmedio=mean(exit(1,:));
j=0;
t=0;
for j=1:z;
    for t=1:1000;
    capturedvalueteorico(t,1,j)=B(t,1,j)*Q(t,j)-B(t,2,j)-B(t,3,j)*Q(t,j);
    capturedvalueteorico(t,2,j)=S1(t,1,j)*Q(t,j)-S1(t,2,j)-S1(t,3,j)*Q(t,j);
    capturedvalueteorico(t,3,j)=S21(t,1,j)*Q(t,j)-S21(t,2,j)-S21(t,3,j)*Q(t,j);
    capturedvalueteorico(t,4,j)=S22(t,1,j)*Q(t,j)-S22(t,2,j)-S22(t,3,j)*Q(t,j);
    capturedvalueteorico(t,5,j)=S3(t,1,j)*Q(t,j)-S3(t,2,j)-S3(t,3,j)*Q(t,j);
    capturedvalueteorico(t,6,j)=RM1(t,1,j)*Q(t,j)-RM1(t,2,j)-RM1(t,3,j)*Q(t,j);
    capturedvalueteorico(t,7,j)=RM2(t,1,j)*Q(t,j)-RM2(t,2,j)-RM2(t,3,j)*Q(t,j);
    capturedvalueteorico(t,8,j)=RM3(t,1,j)*Q(t,j)-RM3(t,2,j)-RM3(t,3,j)*Q(t,j);
    capturedvalueteorico(t,9,j)=RM4(t,1,j)*Q(t,j)-RM4(t,2,j)-RM4(t,3,j)*Q(t,j);
    capturedvalueteorico(t,10,j)=RM5(t,1,j)*Q(t,j)-RM5(t,2,j)-RM5(t,3,j)*Q(t,j);
    end
end
j=0;
t=0;
for j=1:z
    capturedvaluetempo(1,1,j)=sum(capturedvalueteorico(:,1,j));
    capturedvaluetempo(1,2,j)=sum(capturedvalueteorico(:,2,j));
    capturedvaluetempo(1,3,j)=sum(capturedvalueteorico(:,3,j));
    capturedvaluetempo(1,4,j)=sum(capturedvalueteorico(:,4,j));
    capturedvaluetempo(1,5,j)=sum(capturedvalueteorico(:,5,j));
    capturedvaluetempo(1,6,j)=sum(capturedvalueteorico(:,6,j));
    capturedvaluetempo(1,7,j)=sum(capturedvalueteorico(:,7,j));
    capturedvaluetempo(1,8,j)=sum(capturedvalueteorico(:,8,j));
    capturedvaluetempo(1,9,j)=sum(capturedvalueteorico(:,9,j));
    capturedvaluetempo(1,10,j)=sum(capturedvalueteorico(:,10,j));
%     j=j+1;
end
j=0;
t=0;
for j=1:z;
    for t=1:10;
        valorecatturato(1,t,j)=ProfittoTotale(1,t,j)/capturedvaluetempo(1,t,j);
    end
end
for t=1:10
    capturedvalueperc(1,t)=mean(valorecatturato(1,t,:));
    capturedvalueperc(2,t)=std(valorecatturato(1,t,:));
end
% j=0;
% for j=1:i
%     capturedvaluetempo(j,1)=mean(capturedvalueteorico(j,1,:));
%     capturedvaluetempo(j,2)=mean(capturedvalueteorico(j,2,:));
%     capturedvaluetempo(j,3)=mean(capturedvalueteorico(j,3,:));
%     capturedvaluetempo(j,4)=mean(capturedvalueteorico(j,4,:));
%     capturedvaluetempo(j,5)=mean(capturedvalueteorico(j,5,:));
%     capturedvaluetempo(j,6)=mean(capturedvalueteorico(j,6,:));
%     capturedvaluetempo(j,7)=mean(capturedvalueteorico(j,7,:));
%     capturedvaluetempo(j,8)=mean(capturedvalueteorico(j,8,:));
%     capturedvaluetempo(j,9)=mean(capturedvalueteorico(j,9,:));
%     capturedvaluetempo(j,10)=mean(capturedvalueteorico(j,10,:));
%     j=j+1;
% end
% j=0;
% for j=1:i
%     capturedvaluetempostd(j,1)=std(capturedvalueteorico(j,1,:));
%     capturedvaluetempostd(j,2)=std(capturedvalueteorico(j,2,:));
%     capturedvaluetempostd(j,3)=std(capturedvalueteorico(j,3,:));
%     capturedvaluetempostd(j,4)=std(capturedvalueteorico(j,4,:));
%     capturedvaluetempostd(j,5)=std(capturedvalueteorico(j,5,:));
%     capturedvaluetempostd(j,6)=std(capturedvalueteorico(j,6,:));
%     capturedvaluetempostd(j,7)=std(capturedvalueteorico(j,7,:));
%     capturedvaluetempostd(j,8)=std(capturedvalueteorico(j,8,:));
%     capturedvaluetempostd(j,9)=std(capturedvalueteorico(j,9,:));
%     capturedvaluetempostd(j,10)=std(capturedvalueteorico(j,10,:));
%     j=j+1;
% end
% t=0;
% for t=1:10
% capturedvalueteoricototale(1,t)=sum(capturedvaluetempo(:,t));
% capturedvalueteoricototale(2,t)=sum(capturedvaluetempostd(:,t));
% end
% t=0;
% for t=1:10;
% capturedvalueperc(1,t)=ProfittoTotale(1,t)/capturedvalueteoricototale(1,t);
% capturedvalueperc(2,t)=ProfittoTotale(2,t)/capturedvalueteoricototale(2,t);
% end

j=0;
for j=1:z;
    rapportocostimedio(1,j)=mean(Rapportocosti(:,j));
end
compressionecostimedio=mean(rapportocostimedio(1,:));

j=0;
t=0;

for j=1:z
    squeezesize(1,1,j)=sum(B(:,36,j))/nnz(B(:,36,j));
    squeezesize(1,2,j)=sum(S1(:,36,j))/nnz(S1(:,36,j));
    squeezesize(1,3,j)=sum(S21(:,36,j))/nnz(S21(:,36,j));
    squeezesize(1,4,j)=sum(S22(:,36,j))/nnz(S22(:,36,j));
    squeezesize(1,5,j)=sum(S3(:,36,j))/nnz(S3(:,36,j));
end

%per gli attori che possono valor medio e dev std della size of squeeze che effettuano

for t=1:5
    squeezesizemedio(1,t)=mean(squeezesize(1,t,:));
    squeezesizemedio(2,t)=std(squeezesize(1,t,:));
end

%following codes are used to analysis the result of B
%for j=1:z
%	cprofit1(j) = sum(B(:,13,j));
%end 
%cprofit2 = sum(cprofit1);
%fprintf('Cumulative profit of B = %f,\n', cprofit2);

%number of exits calculation
newRelS1=sum(sum(S1(:,11,:)));
newRelS21=sum(sum(S21(:,11,:)));
newRelS22=sum(sum(S22(:,11,:)));
newRelS3=sum(sum(S3(:,11,:)));
newRelRM1=sum(sum(RM1(:,11,:)));
newRelRM2=sum(sum(RM2(:,11,:)));
newRelRM3=sum(sum(RM3(:,11,:)));
newRelRM4=sum(sum(RM4(:,11,:)));
newRelRM5=sum(sum(RM5(:,11,:)));

% when ther is an switching then exit from current one and entering into new relation.
% Therefore, they need to be summed up.
exitS1=sum(sum(S1(:,42,:))) + newRelS1;
exitS21=sum(sum(S21(:,42,:))) + newRelS21;
exitS22=sum(sum(S22(:,42,:))) + newRelS22;
exitS3=sum(sum(S3(:,42,:))) + newRelS3;
exitRM1=sum(sum(RM1(:,42,:))) + newRelRM1;
exitRM2=sum(sum(RM2(:,42,:))) + newRelRM2;
exitRM3=sum(sum(RM3(:,42,:))) + newRelRM3;
exitRM4=sum(sum(RM4(:,42,:))) + newRelRM4;
exitRM5=sum(sum(RM5(:,42,:))) + newRelRM5;

%% calculate the unfulfilled orders
Qtot = sum(sum(Q));
unfulfilledOrderBTot = sum(sum(B(:,41,:)));
unfulfilledOrderBTot2 = sum(sum(B(:,47,:)));
unfulfilledOrderBTot_u = unfulfilledOrderBTot/Qtot; 
unfulfilledOrderS1Tot = sum(sum(S1(:,41,:)));
unfulfilledOrderS1Tot2 = sum(sum(S1(:,47,:)));
unfulfilledOrderS1Tot_u = unfulfilledOrderS1Tot/Qtot;
unfulfilledOrderS21Tot = sum(sum(S21(:,41,:)));
unfulfilledOrderS21Tot2 = sum(sum(S21(:,47,:)));
unfulfilledOrderS21Tot_u = unfulfilledOrderS21Tot/Qtot;
unfulfilledOrderS22Tot = sum(sum(S22(:,41,:)));
unfulfilledOrderS22Tot2 = sum(sum(S22(:,47,:)));
unfulfilledOrderS22Tot_u = unfulfilledOrderS22Tot/Qtot;
unfulfilledOrderS3Tot = sum(sum(S3(:,41,:)));
unfulfilledOrderS3Tot2 = sum(sum(S3(:,47,:)));
unfulfilledOrderS3Tot_u = unfulfilledOrderS3Tot/Qtot;
unfulfilledOrderRM1Tot = sum(sum(RM1(:,41,:)));
unfulfilledOrderRM1Tot2 = sum(sum(RM1(:,47,:)));
unfulfilledOrderRM1Tot_u = unfulfilledOrderRM1Tot/Qtot; 
unfulfilledOrderRM2Tot = sum(sum(RM2(:,41,:)));
unfulfilledOrderRM2Tot2 = sum(sum(RM2(:,47,:)));
unfulfilledOrderRM2Tot_u = unfulfilledOrderRM2Tot/Qtot; 
unfulfilledOrderRM3Tot = sum(sum(RM3(:,41,:)));
unfulfilledOrderRM3Tot2 = sum(sum(RM3(:,47,:)));
unfulfilledOrderRM3Tot_u = unfulfilledOrderRM3Tot/Qtot; 
unfulfilledOrderRM4Tot = sum(sum(RM4(:,41,:)));
unfulfilledOrderRM4Tot2 = sum(sum(RM4(:,47,:)));
unfulfilledOrderRM4Tot_u = unfulfilledOrderRM4Tot/Qtot; 
unfulfilledOrderRM5Tot = sum(sum(RM5(:,41,:)));
unfulfilledOrderRM5Tot2 = sum(sum(RM5(:,47,:)));
unfulfilledOrderRM5Tot_u = unfulfilledOrderRM5Tot/Qtot; 

% xlswrite('Result.xlsx',Ricavimedio,'ValoriMedi','B2');
% xlswrite('Result.xlsx',Profittomedio,'ValoriMedi','B3');
% xlswrite('Result.xlsx',nswitchmedio,'ValoriMedi','B4');
% xlswrite('Result.xlsx',Poweromedio,'ValoriMedi','B5');
% 
% xlswrite('Result.xlsx',RicaviTotali,'Result','B2');
% xlswrite('Result.xlsx','RicaviTotali','Result','A2:A2');
% xlswrite('Result.xlsx',ProfittoTotale,'Result','B3');
% xlswrite('Result.xlsx','ProfittoTotale','Result','A3:A3');
xlswrite('Result.xlsx',nsqueezemedio,'Result','B4');
% xlswrite('Result.xlsx','nsqueezedmedio','Result','A4:A4');
xlswrite('Result.xlsx',ncostmedio,'Result','C6');
% xlswrite('Result.xlsx','ncostmedio','Result','A5:A5');
xlswrite('Result.xlsx',nswitchmedio,'Result','B8');
% xlswrite('Result.xlsx','nswitchmedio','Result','A7:A7');
xlswrite('Result.xlsx',nforcemedio,'Result','B11');
% xlswrite('Result.xlsx','nforcemedio','Result','A11:A11');
xlswrite('Result.xlsx',PowerTempo(i,:),'Result','B14');

xlswrite('Result.xlsx',squeezesizemedio,'Result','B17');
% xlswrite('Result.xlsx','PowerFinale','Result','A14:A14');
% xlswrite('Result.xlsx','Createdvalue','Result','A15:A15');
xlswrite('Result.xlsx',createdvaluemedio,'Result','B19');
% xlswrite('Result.xlsx','Capturedvalue','Result','A16:A16');
xlswrite('Result.xlsx',capturedvalueperc,'Result','B21');
xlswrite('Result.xlsx',{'B', 'S1', 'S21', 'S22', 'S3', 'RM1', 'RM2', 'RM3', 'RM4', 'RM5'},'RevenueMean','B1');
xlswrite('Result.xlsx',RicaviTempo,'RevenueMean','B2');
xlswrite('Result.xlsx',{'B', 'S1', 'S21', 'S22', 'S3', 'RM1', 'RM2', 'RM3', 'RM4', 'RM5'},'RevenueStd','B1');
xlswrite('Result.xlsx',RicaviStd,'RevenueStd','B2');
xlswrite('Result.xlsx',{'B', 'S1', 'S21', 'S22', 'S3', 'RM1', 'RM2', 'RM3', 'RM4', 'RM5'},'ProfitMean','B1');
xlswrite('Result.xlsx',ProfittoTempo,'ProfitMean','B2');
xlswrite('Result.xlsx',{'B', 'S1', 'S21', 'S22', 'S3', 'RM1', 'RM2', 'RM3', 'RM4', 'RM5'},'ProfitStd','B1');
xlswrite('Result.xlsx',ProfittoStd,'ProfitStd','B2');
xlswrite('Result.xlsx',{'B', 'S1', 'S21', 'S22', 'S3', 'RM1', 'RM2', 'RM3', 'RM4', 'RM5'},'PowerMean','B1');
xlswrite('Result.xlsx',PowerTempo,'PowerMean','B2');
xlswrite('Result.xlsx',{'B', 'S1', 'S21', 'S22', 'S3', 'RM1', 'RM2', 'RM3', 'RM4', 'RM5'},'PowerStd','B1');
xlswrite('Result.xlsx',PowerStd,'PowerStd','B2');
xlswrite('Result.xlsx',exitmedio,'Result','B20');

xlswrite('Result.xlsx',{'S1'},'Result','M4');
xlswrite('Result.xlsx',{'S21-S22'},'Result','M5');
xlswrite('Result.xlsx',{'S3'},'Result','M6');
xlswrite('Result.xlsx',{'RM1 to RM5'},'Result','M7');
xlswrite('Result.xlsx',{'Num of Exits (Tier-wise)'},'Result','N3');
xlswrite('Result.xlsx',exitS1,'Result','N4');
xlswrite('Result.xlsx',(exitS21+exitS22),'Result','N5');
xlswrite('Result.xlsx',exitS3,'Result','N6');
xlswrite('Result.xlsx',(exitRM1+exitRM2+exitRM3+exitRM4+exitRM5),'Result','N7');

xlswrite('Result.xlsx',{'Num of New Rel(Tier-wise)'},'Result','O3');
xlswrite('Result.xlsx',newRelS1,'Result','O4');
xlswrite('Result.xlsx',(newRelS21+newRelS22),'Result','O5');
xlswrite('Result.xlsx',newRelS3,'Result','O6');
xlswrite('Result.xlsx',(newRelRM1+newRelRM2+newRelRM3+newRelRM4+newRelRM5),'Result','O7');

xlswrite('Result.xlsx',{'B'},'Result','P4');
xlswrite('Result.xlsx',{'S1'},'Result','P5');
xlswrite('Result.xlsx',{'S21'},'Result','P6');
xlswrite('Result.xlsx',{'S22'},'Result','P7');
xlswrite('Result.xlsx',{'S3'},'Result','P8');
xlswrite('Result.xlsx',{'RM1'},'Result','P9');
xlswrite('Result.xlsx',{'RM2'},'Result','P10');
xlswrite('Result.xlsx',{'RM3'},'Result','P11');
xlswrite('Result.xlsx',{'RM4'},'Result','P12');
xlswrite('Result.xlsx',{'RM5'},'Result','P13');

xlswrite('Result.xlsx',{'Exits'},'Result','Q3');
xlswrite('Result.xlsx',exitS1,'Result','Q5');
xlswrite('Result.xlsx',exitS21,'Result','Q6');
xlswrite('Result.xlsx',exitS22,'Result','Q7');
xlswrite('Result.xlsx',exitS3,'Result','Q8');
xlswrite('Result.xlsx',exitRM1,'Result','Q9');
xlswrite('Result.xlsx',exitRM2,'Result','Q10');
xlswrite('Result.xlsx',exitRM3,'Result','Q11');
xlswrite('Result.xlsx',exitRM4,'Result','Q12');
xlswrite('Result.xlsx',exitRM5,'Result','Q13');

xlswrite('Result.xlsx',{'NewR'},'Result','R3');
xlswrite('Result.xlsx',newRelS1,'Result','R5');
xlswrite('Result.xlsx',newRelS21,'Result','R6');
xlswrite('Result.xlsx',newRelS22,'Result','R7');
xlswrite('Result.xlsx',newRelS3,'Result','R8');
xlswrite('Result.xlsx',newRelRM1,'Result','R9');
xlswrite('Result.xlsx',newRelRM2,'Result','R10');
xlswrite('Result.xlsx',newRelRM3,'Result','R11');
xlswrite('Result.xlsx',newRelRM4,'Result','R12');
xlswrite('Result.xlsx',newRelRM5,'Result','R13');

xlswrite('Result.xlsx',{'Unfulfilled Orders'},'Result','S3');
xlswrite('Result.xlsx',unfulfilledOrderBTot,'Result','S4');
xlswrite('Result.xlsx',unfulfilledOrderS1Tot,'Result','S5');
xlswrite('Result.xlsx',unfulfilledOrderS21Tot,'Result','S6');
xlswrite('Result.xlsx',unfulfilledOrderS22Tot,'Result','S7');
xlswrite('Result.xlsx',unfulfilledOrderS3Tot,'Result','S8');
xlswrite('Result.xlsx',unfulfilledOrderRM1Tot,'Result','S9');
xlswrite('Result.xlsx',unfulfilledOrderRM2Tot,'Result','S10');
xlswrite('Result.xlsx',unfulfilledOrderRM3Tot,'Result','S11');
xlswrite('Result.xlsx',unfulfilledOrderRM4Tot,'Result','S12');
xlswrite('Result.xlsx',unfulfilledOrderRM5Tot,'Result','S13');

xlswrite('Result.xlsx',{'Unfulfilled Order Ratio'},'Result','T3');
xlswrite('Result.xlsx',unfulfilledOrderBTot_u,'Result','T4');
xlswrite('Result.xlsx',unfulfilledOrderS1Tot_u,'Result','T5');
xlswrite('Result.xlsx',unfulfilledOrderS21Tot_u,'Result','T6');
xlswrite('Result.xlsx',unfulfilledOrderS22Tot_u,'Result','T7');
xlswrite('Result.xlsx',unfulfilledOrderS3Tot_u,'Result','T8');
xlswrite('Result.xlsx',unfulfilledOrderRM1Tot_u,'Result','T9');
xlswrite('Result.xlsx',unfulfilledOrderRM2Tot_u,'Result','T10');
xlswrite('Result.xlsx',unfulfilledOrderRM3Tot_u,'Result','T11');
xlswrite('Result.xlsx',unfulfilledOrderRM4Tot_u,'Result','T12');
xlswrite('Result.xlsx',unfulfilledOrderRM5Tot_u,'Result','T13');

xlswrite('Result.xlsx',{'Actual Unfulfilled Orders'},'Result','U3');
xlswrite('Result.xlsx',unfulfilledOrderBTot2,'Result','U4');
xlswrite('Result.xlsx',unfulfilledOrderS1Tot2,'Result','U5');
xlswrite('Result.xlsx',unfulfilledOrderS21Tot2,'Result','U6');
xlswrite('Result.xlsx',unfulfilledOrderS22Tot2,'Result','U7');
xlswrite('Result.xlsx',unfulfilledOrderS3Tot2,'Result','U8');
xlswrite('Result.xlsx',unfulfilledOrderRM1Tot2,'Result','U9');
xlswrite('Result.xlsx',unfulfilledOrderRM2Tot2,'Result','U10');
xlswrite('Result.xlsx',unfulfilledOrderRM3Tot2,'Result','U11');
xlswrite('Result.xlsx',unfulfilledOrderRM4Tot2,'Result','U12');
xlswrite('Result.xlsx',unfulfilledOrderRM5Tot2,'Result','U13');
