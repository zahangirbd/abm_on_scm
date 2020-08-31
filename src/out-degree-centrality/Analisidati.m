%Data analysis algorithm

%just making dummy for S16 so that cumulative result can be generated without any changes
for z=1:SimNum
	for i=1:ItrTot
		for j=1:55
			S16(i,j,z) = 0;
		end 
	end 
end 

%analysis of the number of switches suffered by the agents
for j=1:z
    nswitch(j,1)=sum(B(:,11,j));
    nswitch(j,2)=sum(S11(:,11,j));
    nswitch(j,3)=sum(S12(:,11,j));
    nswitch(j,4)=sum(S13(:,11,j));
    nswitch(j,5)=sum(S14(:,11,j));
    nswitch(j,6)=sum(S15(:,11,j));
    nswitch(j,7)=sum(S16(:,11,j));
    nswitch(j,8)=sum(S21(:,11,j));
    nswitch(j,9)=sum(RM1(:,11,j));
    nswitch(j,10)=sum(RM2(:,11,j));
    j=j+1;
end

for t=1:10
    nswitchmedio(1,t)=sum(nswitch(:,t))/z;
    nswitchmedio(2,t)=std(nswitch(:,t));
end

%forcing analysis with contractual power
for j=1:z
    nforced(j,1)=sum(B(:,16,j));
    nforced(j,2)=sum(S11(:,16,j));
    nforced(j,3)=sum(S12(:,16,j));
    nforced(j,4)=sum(S13(:,16,j));
    nforced(j,5)=sum(S14(:,16,j));
    nforced(j,6)=sum(S15(:,16,j));
    nforced(j,7)=sum(S16(:,16,j));
    nforced(j,8)=sum(S21(:,16,j));
    nforced(j,9)=sum(RM1(:,16,j));
    nforced(j,10)=sum(RM2(:,16,j));
    j=j+1;
end

for t=1:10
    nforcedmedio(1,t)=sum(nforced(:,t))/z;
    nforcedmedio(2,t)=std(nforced(:,t));
end

j=0;
t=0;
%analysis on the average value on the 100 iterations of the revenues recorded by the actors at each instant of time (1000 instants)
for j=1:i
    RicaviTempo(j,1)=mean(B(j,12,:));
    RicaviTempo(j,2)=mean(S11(j,12,:));
    RicaviTempo(j,3)=mean(S12(j,12,:));
    RicaviTempo(j,4)=mean(S13(j,12,:));
    RicaviTempo(j,5)=mean(S14(j,12,:));
    RicaviTempo(j,6)=mean(S15(j,12,:));
    RicaviTempo(j,7)=mean(S16(j,12,:));
    RicaviTempo(j,8)=mean(S21(j,12,:));
    RicaviTempo(j,9)=mean(RM1(j,12,:));
    RicaviTempo(j,10)=mean(RM1(j,12,:));
    j=j+1;
end

for t=1:10
    RicaviTotali(1,t)=sum(RicaviTempo(:,t));
end

j=0;
t=0;
%analysis on dev. std on the 100 iterations of revenues recorded by the actors at each instant of time (1000 instants)
for j=1:i
    RicaviStd(j,1)=std(B(j,12,:),0,3);
    RicaviStd(j,2)=std(S11(j,12,:),0,3);
    RicaviStd(j,3)=std(S12(j,12,:),0,3);
    RicaviStd(j,4)=std(S13(j,12,:),0,3);
    RicaviStd(j,5)=std(S14(j,12,:),0,3);
    RicaviStd(j,6)=std(S15(j,12,:),0,3);
    RicaviStd(j,7)=std(S16(j,12,:),0,3);
    RicaviStd(j,8)=std(S21(j,12,:),0,3);
    RicaviStd(j,9)=std(RM1(j,12,:),0,3);
    RicaviStd(j,10)=std(RM2(j,12,:),0,3);
    j=j+1;
end

j=0;
t=0;
 %analysis on the average value, on the 100 iterations, of the profits recorded by each actor at each instant of time (1000 instants)
for j=1:i
    ProfittoTempo(j,1)=mean(B(j,13,:));
    ProfittoTempo(j,2)=mean(S11(j,13,:));
    ProfittoTempo(j,3)=mean(S12(j,13,:));
    ProfittoTempo(j,4)=mean(S13(j,13,:));
    ProfittoTempo(j,5)=mean(S14(j,13,:));
    ProfittoTempo(j,6)=mean(S15(j,13,:));
    ProfittoTempo(j,7)=mean(S16(j,13,:));
    ProfittoTempo(j,8)=mean(S21(j,13,:));
    ProfittoTempo(j,9)=mean(RM1(j,13,:));
    ProfittoTempo(j,10)=mean(RM2(j,13,:));
    j=j+1;
end

j=0;
t=0;
 %analysis on dev std, on the 100 iterations, of the profits recorded by each actor at each instant of time (1000 instants)
for j=1:i
     ProfittoStd(j,1)=std(B(j,13,:),0,3);
     ProfittoStd(j,2)=std(S11(j,13,:),0,3);
     ProfittoStd(j,3)=std(S12(j,13,:),0,3);
     ProfittoStd(j,4)=std(S13(j,13,:),0,3);
     ProfittoStd(j,5)=std(S14(j,13,:),0,3);
     ProfittoStd(j,6)=std(S15(j,13,:),0,3);
     ProfittoStd(j,7)=std(S16(j,13,:),0,3);
     ProfittoStd(j,8)=std(S21(j,13,:),0,3);
     ProfittoStd(j,9)=std(RM1(j,13,:),0,3);
     ProfittoStd(j,10)=std(RM2(j,13,:),0,3);
     j=j+1;
end

j=0;
t=0;
   %summary analysis of the total profit recorded by the actors in the 1000 instants (repeated operation over 100 iterations)
for j=1:z
    ProfittoTotale(1,1,j)=sum(B(:,13,j));
    ProfittoTotale(1,2,j)=sum(S11(:,13,j));
    ProfittoTotale(1,3,j)=sum(S12(:,13,j));
    ProfittoTotale(1,4,j)=sum(S13(:,13,j));
    ProfittoTotale(1,5,j)=sum(S14(:,13,j));
    ProfittoTotale(1,6,j)=sum(S15(:,13,j));
    ProfittoTotale(1,7,j)=sum(S16(:,13,j));
    ProfittoTotale(1,8,j)=sum(S21(:,13,j));
    ProfittoTotale(1,9,j)=sum(RM1(:,13,j));
    ProfittoTotale(1,10,j)=sum(RM2(:,13,j));
    j=j+1;
end

j=0;
t=0;
%analysis on the performance of the bargaining power over time instants (value at each instant obtained from the average over 100 iterations)
for j=1:i
    PowerTempo(j,1)=mean(B(j,14,:));
    PowerTempo(j,2)=mean(S11(j,14,:));
    PowerTempo(j,3)=mean(S12(j,14,:));
    PowerTempo(j,4)=mean(S13(j,14,:));
    PowerTempo(j,5)=mean(S14(j,14,:));
    PowerTempo(j,6)=mean(S15(j,14,:));
    PowerTempo(j,7)=mean(S16(j,14,:));
    PowerTempo(j,8)=mean(S21(j,14,:));
    PowerTempo(j,9)=mean(RM1(j,14,:));
    PowerTempo(j,10)=mean(RM1(j,14,:));
    j=j+1;
end

j=0;
t=0;
%analysis on dev std of the data sample (100 values ??/ iterations) of the contractual power at each instant of time
for j=1:i
    PowerStd(j,1)=std(B(j,14,:),0,3);
    PowerStd(j,2)=std(S11(j,14,:),0,3);
    PowerStd(j,3)=std(S12(j,14,:),0,3);
    PowerStd(j,4)=std(S13(j,14,:),0,3);
    PowerStd(j,5)=std(S14(j,14,:),0,3);
    PowerStd(j,6)=std(S15(j,14,:),0,3);
    PowerStd(j,7)=std(S16(j,14,:),0,3);
    PowerStd(j,8)=std(S21(j,14,:),0,3);
    PowerStd(j,9)=std(RM1(j,14,:),0,3);
    PowerStd(j,10)=std(RM2(j,14,:),0,3);
    j=j+1;
end

j=0;
t=0;
%analysis on the number of squeeze performed / attempted by each actor at each system iteration
for j=1:z
    nsqueezed(j,1)=sum(B(:,7,j));
    nsqueezed(j,2)=sum(S11(:,7,j));
    nsqueezed(j,3)=sum(S12(:,7,j));
    nsqueezed(j,4)=sum(S13(:,7,j));
    nsqueezed(j,5)=sum(S14(:,7,j));
    nsqueezed(j,6)=sum(S15(:,7,j));
    nsqueezed(j,7)=sum(S16(:,7,j));
    nsqueezed(j,8)=sum(S21(:,7,j));
end

%average value and dev std analysis of the squeeze performed / attempted by each actor
for t=1:8
    nsqueezemedio(1,t)=mean(nsqueezed(:,t));
    nsqueezemedio(2,t)=std(nsqueezed(:,t));
end

j=0;
t=0;
%analysis on the num. of times in which the actors have compressed fixed costs (value calculated at each iteration)
for j=1:z
    ncost(j,1)=sum(S11(:,10,j));
    ncost(j,2)=sum(S12(:,10,j));
    ncost(j,3)=sum(S13(:,10,j));
    ncost(j,4)=sum(S14(:,10,j));
    ncost(j,5)=sum(S15(:,10,j));
    ncost(j,6)=sum(S16(:,10,j));
    ncost(j,7)=sum(S21(:,10,j));
    ncost(j,8)=sum(RM1(:,10,j));
    ncost(j,9)=sum(RM2(:,10,j));
end

%analysis on average value and dev std of the num. of times when the actors have compressed fixed costs
for t=1:9
    ncostmedio(1,t)=mean(ncost(:,t));
    ncostmedio(2,t)=std(ncost(:,t));
end

j=0;
%I calculate the sum (cumulative) of the quantity exchanged in the network in 1000 instants (100 values ??for the 100 iterations)
for j=1:z
    createdvalue(1,j)=sum(Quantity(:,j));
    createdvalueteorico(1,j)=sum(Q(:,j));
end
createdvaluemedio(1,1)=(mean(createdvalue(1,:))/mean(createdvalueteorico(1,:)));
createdvaluemedio(1,2)=std(createdvalue(1,:)/createdvalueteorico(1,:));

j=0;
%analysis on the num. of times the simulation stopped at each iteration
for j=1:z    
    exit(1,j)=sum(B(:,28,j));
end
exitmedio=mean(exit(1,:));

j=0;
t=0;
for j=1:z
    for t=1:1000
        capturedvalueteorico(t,1,j)=B(t,1,j)*Q(t,j)-B(t,2,j)-B(t,3,j)*Q(t,j);
        capturedvalueteorico(t,2,j)=S11(t,1,j)*Q(t,j)-S11(t,2,j)-S11(t,3,j)*Q(t,j);
        capturedvalueteorico(t,3,j)=S12(t,1,j)*Q(t,j)-S12(t,2,j)-S12(t,3,j)*Q(t,j);
        capturedvalueteorico(t,4,j)=S13(t,1,j)*Q(t,j)-S13(t,2,j)-S13(t,3,j)*Q(t,j);
        capturedvalueteorico(t,5,j)=S14(t,1,j)*Q(t,j)-S14(t,2,j)-S14(t,3,j)*Q(t,j);
        capturedvalueteorico(t,6,j)=S15(t,1,j)*Q(t,j)-S15(t,2,j)-S15(t,3,j)*Q(t,j);
        capturedvalueteorico(t,7,j)=S16(t,1,j)*Q(t,j)-S16(t,2,j)-S16(t,3,j)*Q(t,j);
        capturedvalueteorico(t,8,j)=S21(t,1,j)*Q(t,j)-S21(t,2,j)-S21(t,3,j)*Q(t,j);
        capturedvalueteorico(t,9,j)=RM1(t,1,j)*Q(t,j)-RM1(t,2,j)-RM1(t,3,j)*Q(t,j);
        capturedvalueteorico(t,10,j)=RM2(t,1,j)*Q(t,j)-RM2(t,2,j)-RM2(t,3,j)*Q(t,j);
    end
end

j=0;
t=0;
%calculation of the theoretical cumulative profits of the actors at each iteration of the system (100 values)
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
end

j=0;
t=0;
%for each iteration I calculate the value captured by each agent (100 values)

for j=1:z
    for t=1:10
        valorecatturato(1,t,j)=ProfittoTotale(1,t,j)/capturedvaluetempo(1,t,j);
    end
end

%for each agent I calculate the mean value and dev std of the captured value
for t=1:10
    capturedvalueperc(1,t)=mean(valorecatturato(1,t,:));
    capturedvalueperc(2,t)=std(valorecatturato(1,t,:));
end

j=0;
for j=1:z
    rapportocostimedio(1,j)=mean(RapportoCosti(:,j));
end
compressionecostimedio=mean(rapportocostimedio(1,:));

j=0;
t=0;
%analysis on the size of squeeze performed by the actors
for j=1:z
    squeezesize(1,1,j)=sum(B(:,36,j))/nnz(B(:,36,j));
    squeezesize(1,2,j)=sum(S11(:,36,j))/nnz(S11(:,36,j));
    squeezesize(1,3,j)=sum(S12(:,36,j))/nnz(S12(:,36,j));
    squeezesize(1,4,j)=sum(S13(:,36,j))/nnz(S13(:,36,j));
    squeezesize(1,5,j)=sum(S14(:,36,j))/nnz(S14(:,36,j));
    squeezesize(1,6,j)=sum(S15(:,36,j))/nnz(S15(:,36,j));
    squeezesize(1,7,j)=sum(S16(:,36,j))/nnz(S16(:,36,j));
    squeezesize(1,8,j)=sum(S21(:,36,j))/nnz(S21(:,36,j));
end

%for actors who can average value and dev std of the size of squeeze they perform

for t=1:8
    squeezesizemedio(1,t)=mean(squeezesize(1,t,:));
    squeezesizemedio(2,t)=std(squeezesize(1,t,:));
end

%number of exits calculation
newRelS11=sum(sum(S11(:,11,:)));
newRelS12=sum(sum(S12(:,11,:)));
newRelS13=sum(sum(S13(:,11,:)));
newRelS14=sum(sum(S14(:,11,:)));
newRelS15=sum(sum(S15(:,11,:)));
newRelS16=sum(sum(S16(:,11,:)));
newRelS21=sum(sum(S21(:,11,:)));
newRelRM1=sum(sum(RM1(:,11,:)));
newRelRM2=sum(sum(RM2(:,11,:)));

% when ther is an switching then exit from current one and entering into new relation.
% Therefore, they need to be summed up.
exitS11=sum(sum(S11(:,42,:))) + newRelS11;
exitS12=sum(sum(S12(:,42,:))) + newRelS12;
exitS13=sum(sum(S13(:,42,:))) + newRelS13;
exitS14=sum(sum(S14(:,42,:))) + newRelS14;
exitS15=sum(sum(S15(:,42,:))) + newRelS15;
exitS16=sum(sum(S16(:,42,:))) + newRelS16;
exitS21=sum(sum(S21(:,42,:))) + newRelS21;
exitRM1=sum(sum(RM1(:,42,:))) + newRelRM1;
exitRM2=sum(sum(RM2(:,42,:))) + newRelRM2;

%% calculate the unfulfilled orders
Qtot = sum(sum(Q));
unfulfilledOrderBTot = sum(sum(B(:,41,:)));
unfulfilledOrderBTot2 = sum(sum(B(:,47,:)));
unfulfilledOrderBTot_u = unfulfilledOrderBTot/Qtot; 
unfulfilledOrderS11Tot = sum(sum(S11(:,41,:)));
unfulfilledOrderS11Tot2 = sum(sum(S11(:,47,:)));
unfulfilledOrderS11Tot_u = unfulfilledOrderS11Tot/Qtot;
unfulfilledOrderS12Tot = sum(sum(S12(:,41,:)));
unfulfilledOrderS12Tot2 = sum(sum(S12(:,47,:)));
unfulfilledOrderS12Tot_u = unfulfilledOrderS12Tot/Qtot;
unfulfilledOrderS13Tot = sum(sum(S13(:,41,:)));
unfulfilledOrderS13Tot2 = sum(sum(S13(:,47,:)));
unfulfilledOrderS13Tot_u = unfulfilledOrderS13Tot/Qtot;
unfulfilledOrderS14Tot = sum(sum(S14(:,41,:)));
unfulfilledOrderS14Tot2 = sum(sum(S14(:,47,:)));
unfulfilledOrderS14Tot_u = unfulfilledOrderS14Tot/Qtot;
unfulfilledOrderS15Tot = sum(sum(S15(:,41,:)));
unfulfilledOrderS15Tot2 = sum(sum(S15(:,47,:)));
unfulfilledOrderS15Tot_u = unfulfilledOrderS15Tot/Qtot;
unfulfilledOrderS16Tot = sum(sum(S16(:,41,:)));
unfulfilledOrderS16Tot2 = sum(sum(S16(:,47,:)));
unfulfilledOrderS16Tot_u = unfulfilledOrderS16Tot/Qtot;
unfulfilledOrderS21Tot = sum(sum(S21(:,41,:)));
unfulfilledOrderS21Tot2 = sum(sum(S21(:,47,:)));
unfulfilledOrderS21Tot_u = unfulfilledOrderS21Tot/Qtot;
unfulfilledOrderRM1Tot = sum(sum(RM1(:,41,:)));
unfulfilledOrderRM1Tot2 = sum(sum(RM1(:,47,:)));
unfulfilledOrderRM1Tot_u = unfulfilledOrderRM1Tot/Qtot; 
unfulfilledOrderRM2Tot = sum(sum(RM2(:,41,:)));
unfulfilledOrderRM2Tot2 = sum(sum(RM2(:,47,:)));
unfulfilledOrderRM2Tot_u = unfulfilledOrderRM2Tot/Qtot; 


xlswrite('Result.xlsx',nsqueezemedio,'Result','B4');

xlswrite('Result.xlsx',ncostmedio,'Result','C6');

xlswrite('Result.xlsx',nswitchmedio,'Result','B8');

xlswrite('Result.xlsx',nforcedmedio,'Result','B11');

xlswrite('Result.xlsx',PowerTempo(i,:),'Result','B14');

xlswrite('Result.xlsx',squeezesizemedio,'Result','B17');

xlswrite('Result.xlsx',createdvaluemedio,'Result','B19');

xlswrite('Result.xlsx',capturedvalueperc,'Result','B21');

xlswrite('Result.xlsx',{'B', 'S11', 'S12', 'S13', 'S14', 'S15', 'S16', 'S21', 'RM1', 'RM2'},'RevenueMean','B1');
xlswrite('Result.xlsx',RicaviTempo,'RevenueMean','B2');
xlswrite('Result.xlsx',{'B', 'S11', 'S12', 'S13', 'S14', 'S15', 'S16', 'S21', 'RM1', 'RM2'},'RevenueStd','B1');
xlswrite('Result.xlsx',RicaviStd,'RevenueStd','B2');

xlswrite('Result.xlsx',{'B', 'S11', 'S12', 'S13', 'S14', 'S15', 'S16', 'S21', 'RM1', 'RM2'},'ProfitMean','B1');
xlswrite('Result.xlsx',ProfittoTempo,'ProfitMean','B2');
xlswrite('Result.xlsx',{'B', 'S11', 'S12', 'S13', 'S14', 'S15', 'S16', 'S21', 'RM1', 'RM2'},'ProfitStd','B1');
xlswrite('Result.xlsx',ProfittoStd,'ProfitStd','B2');

xlswrite('Result.xlsx',{'B', 'S11', 'S12', 'S13', 'S14', 'S15', 'S16', 'S21', 'RM1', 'RM2'},'PowerMean','B1');
xlswrite('Result.xlsx',PowerTempo,'PowerMean','B2');
xlswrite('Result.xlsx',{'B', 'S11', 'S12', 'S13', 'S14', 'S15', 'S16', 'S21', 'RM1', 'RM2'},'PowerStd','B1');
xlswrite('Result.xlsx',PowerStd,'PowerStd','B2');


xlswrite('Result.xlsx',{'B'},'Result','P4');
xlswrite('Result.xlsx',{'S11'},'Result','P5');
xlswrite('Result.xlsx',{'S12'},'Result','P6');
xlswrite('Result.xlsx',{'S13'},'Result','P7');
xlswrite('Result.xlsx',{'S14'},'Result','P8');
xlswrite('Result.xlsx',{'S15'},'Result','P9');
xlswrite('Result.xlsx',{'S16'},'Result','P10');
xlswrite('Result.xlsx',{'S21'},'Result','P11');
xlswrite('Result.xlsx',{'RM1'},'Result','P12');
xlswrite('Result.xlsx',{'RM2'},'Result','P13');

xlswrite('Result.xlsx',{'Exits'},'Result','Q3');
xlswrite('Result.xlsx',exitS11,'Result','Q5');
xlswrite('Result.xlsx',exitS12,'Result','Q6');
xlswrite('Result.xlsx',exitS13,'Result','Q7');
xlswrite('Result.xlsx',exitS14,'Result','Q8');
xlswrite('Result.xlsx',exitS15,'Result','Q9');
xlswrite('Result.xlsx',exitS16,'Result','Q10');
xlswrite('Result.xlsx',exitS21,'Result','Q11');
xlswrite('Result.xlsx',exitRM1,'Result','Q12');
xlswrite('Result.xlsx',exitRM2,'Result','Q13');

xlswrite('Result.xlsx',{'NewR'},'Result','R3');
xlswrite('Result.xlsx',newRelS11,'Result','R5');
xlswrite('Result.xlsx',newRelS12,'Result','R6');
xlswrite('Result.xlsx',newRelS13,'Result','R7');
xlswrite('Result.xlsx',newRelS14,'Result','R8');
xlswrite('Result.xlsx',newRelS15,'Result','R9');
xlswrite('Result.xlsx',newRelS16,'Result','R10');
xlswrite('Result.xlsx',newRelS21,'Result','R11');
xlswrite('Result.xlsx',newRelRM1,'Result','R12');
xlswrite('Result.xlsx',newRelRM2,'Result','R13');

xlswrite('Result.xlsx',{'Unfulfilled Orders'},'Result','S3');
xlswrite('Result.xlsx',unfulfilledOrderBTot,'Result','S4');
xlswrite('Result.xlsx',unfulfilledOrderS11Tot,'Result','S5');
xlswrite('Result.xlsx',unfulfilledOrderS12Tot,'Result','S6');
xlswrite('Result.xlsx',unfulfilledOrderS13Tot,'Result','S7');
xlswrite('Result.xlsx',unfulfilledOrderS14Tot,'Result','S8');
xlswrite('Result.xlsx',unfulfilledOrderS15Tot,'Result','S9');
xlswrite('Result.xlsx',unfulfilledOrderS16Tot,'Result','S10');
xlswrite('Result.xlsx',unfulfilledOrderS21Tot,'Result','S11');
xlswrite('Result.xlsx',unfulfilledOrderRM1Tot,'Result','S12');
xlswrite('Result.xlsx',unfulfilledOrderRM2Tot,'Result','S13');

xlswrite('Result.xlsx',{'Unfulfilled Order Ratio'},'Result','T3');
xlswrite('Result.xlsx',unfulfilledOrderBTot_u,'Result','T4');
xlswrite('Result.xlsx',unfulfilledOrderS11Tot_u,'Result','T5');
xlswrite('Result.xlsx',unfulfilledOrderS12Tot_u,'Result','T6');
xlswrite('Result.xlsx',unfulfilledOrderS13Tot_u,'Result','T7');
xlswrite('Result.xlsx',unfulfilledOrderS14Tot_u,'Result','T8');
xlswrite('Result.xlsx',unfulfilledOrderS15Tot_u,'Result','T9');
xlswrite('Result.xlsx',unfulfilledOrderS16Tot_u,'Result','T10');
xlswrite('Result.xlsx',unfulfilledOrderS21Tot_u,'Result','T11');
xlswrite('Result.xlsx',unfulfilledOrderRM1Tot_u,'Result','T12');
xlswrite('Result.xlsx',unfulfilledOrderRM2Tot_u,'Result','T13');

xlswrite('Result.xlsx',{'Actual Unfulfilled Orders'},'Result','U3');
xlswrite('Result.xlsx',unfulfilledOrderBTot2,'Result','U4');
xlswrite('Result.xlsx',unfulfilledOrderS11Tot2,'Result','U5');
xlswrite('Result.xlsx',unfulfilledOrderS12Tot2,'Result','U6');
xlswrite('Result.xlsx',unfulfilledOrderS13Tot2,'Result','U7');
xlswrite('Result.xlsx',unfulfilledOrderS14Tot2,'Result','U8');
xlswrite('Result.xlsx',unfulfilledOrderS15Tot2,'Result','U9');
xlswrite('Result.xlsx',unfulfilledOrderS16Tot2,'Result','U10');
xlswrite('Result.xlsx',unfulfilledOrderS21Tot2,'Result','U11');
xlswrite('Result.xlsx',unfulfilledOrderRM1Tot2,'Result','U12');
xlswrite('Result.xlsx',unfulfilledOrderRM2Tot2,'Result','U13');

    