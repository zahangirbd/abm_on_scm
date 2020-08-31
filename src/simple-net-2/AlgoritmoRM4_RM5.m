%Algoritmo RM4 e RM5

%calcolo il costo che S22 sarebbe disposto a spendere
S22(i,17,z)=S22(i,18,z)*S1(i,17,z)*(1-S22(i,5,z))-S22(i,25,z)/Q(i,z);

if S22(i,17,z)>0
%calcolo il valore percentuale di RM4 e RM5
RM4(i,18,z)=RM4(i,1,z)/S22(i,3,z);
RM5(i,18,z)=RM5(i,1,z)/S22(i,3,z);

%ratio of the quantity are allocated for RM4 & RM5 
RM4(i,51,z) = RM4(i,18,z) * Q(i,z); 
RM5(i,51,z) = RM5(i,18,z) * Q(i,z); 

%Calcolo i margini di RM4 e RM5 in relazione a PcostsqueezedS22
RM4(i,19,z)=(RM4(i,18,z)*S22(i,17,z)-RM4(i,2,z)/Q(i,z)-RM4(i,3,z))/(RM4(i,18,z)*S22(i,17,z));
RM5(i,19,z)=(RM5(i,18,z)*S22(i,17,z)-RM5(i,2,z)/Q(i,z)-RM5(i,3,z))/(RM5(i,18,z)*S22(i,17,z));

%Controllo se i margini target di RM4 e RM5 sono raggiunti
if RM4(i,19,z)>RM4(i,5,z) & RM5(i,19,z)>RM5(i,5,z)
    %la struttura non cambia e lo squeeze viene accettato da RM4 e RM5
    S22(i,8,z)=1;
    RM4(i,6,z)=1;
    RM5(i,6,z)=1;
    RM4(i,24,z)=RM4(i,18,z)*S22(i,17,z);
    RM5(i,24,z)=RM5(i,18,z)*S22(i,17,z);
    RM4(i,27,z)=RM4(i,19,z);
    RM5(i,27,z)=RM5(i,19,z);
else
    if RM4(i,19,z)>RM4(i,5,z)
        %RM4 raggiunge il proprio margine ed accetta
        RM4(i,6,z)=1;
        RM4(i,24,z)=RM4(i,18,z)*S22(i,17,z);
        RM4(i,27,z)=RM4(i,19,z);
    else	
		S22(i,9,z)=1;                                                      %Lo squeeze non viene accettato completamente -The squeeze is not accepted completely
		S22(i,8,z)=0;                                                      %Necessario perchè potrebbe essere stato cambiato prima in 1 - Necessary because it may have been changed first in 1

		if SqueezeLogic == 2 %cost reduction only without switch
			% updating fixed cost with probability for increasing internal performance always
			RM4(i,20,z)=RM4(i,2,z)*random(triangolarecosti);     %Fcost di RM4 modificati in modo random(triangolare)
			RM4(i,21,z)=Q(i,z)*(RM4(i,18,z)*S22(i,17,z)*(1-RM4(i,5,z))-RM4(i,26,z)); %Fcost di RM4 per raggiungere il target con il prezzo squeezed
		
			%forming maxium last acceptable price to compare with market
			if RM4(i,20,z) < RM4(i,21,z)
				RM4(i,22,z)=RM4(i,18,z)*S22(i,17,z); %the squeezed (by supplier) one (e.g., indexed by 21) 
				RM4(i,25,z)=RM4(i,21,z);
			else	
				RM4(i,22,z)= (RM4(i,26,z)+RM4(i,20,z)/Q(i,z))/(1-RM4(i,5,z)); %the compresed (by self) one (e.g., indexed by 20) 
				RM4(i,25,z)=RM4(i,20,z);
			end 		
			%accept it directly - recommended by Dr. Mei
			RM4(i,10,z)=1;
			%need to update 24 indexed value with compresed (self or squeezed) value
			%this will be used in calculating purchase cost of buyer 		
			RM4(i,24,z)=RM4(i,22,z); % previously, we have updated RM1(i,22,z) value based on comparing 20,21 indexed values
		elseif SqueezeLogic == 3 %switching without cost reduction
			RM4(i,22,z)=(RM4(i,26,z)+RM4(i,2,z)/Q(i,z))/(1-RM4(i,5,z)); %the price without cost reduction  
			%the Buyer compares the budget with the market (SWITCHING COSTS?)
			RM4(i,23,z)=RM4(i,18,z)*S22(i,17,z)/random(triangolareswitch);
			if RM4(i,22,z) <= RM4(i,23,z)
				%accept it
				RM4(i,10,z)=1;
				%need to update 24 indexed value with compresed (self or squeezed) value
				%this will be used in calculating purchase cost of buyer 		
				RM4(i,24,z)=RM4(i,22,z); % previously, we have updated RM1(i,22,z) value based on comparing 20,21 indexed values
			else
				%switching to other supplier
				%the Buyer makes a switch of RM4
				RM4(i,24,z)=RM4(i,23,z); 
				RM4(i,11,z)=1;
				S22(i,15,z)=S22(i,15,z)+SW*RM4(i,18,z)*S22(i,2,z);
			end 				
		elseif SqueezeLogic == 4 % position (degree centrality score) and size/bargain power to reject
			RM4(i,22,z)=RM4(i,18,z)*S22(i,17,z);  %the squeezed (by supplier) one (e.g., indexed by 21) 
			%position (degree centrality score) + size (bargaining power)
			TotalPowerToReject = DegCentralityScores(10);
			if SqueezeLogic4Type == 2
				TotalPowerToReject = TotalPowerToReject + RM4(i,14,z);					
			else
				TotalPowerToReject = TotalPowerToReject + AgentSizes(10);					
			end 
			if TotalPowerToReject >= rand                    
				%reject the squeezed offer
				RM4(i,40,z)=RM4(i,22,z);
				S22(i,15,z)=S22(i,15,z)+RM4(i,22,z);% since exit, therefore applying penalty	
				RM4(i,41,z)=Q(i,z);
				RM4(i,42,z)=1;			
			else
				%need to update 24 indexed value with squeezed value
				%this will be used in calculating purchase cost of buyer 				
				RM4(i,24,z)=RM4(i,22,z);				
				%RM4 accept the squeezed price
				RM4(i,6,z)=1;
			end 
		elseif SqueezeLogic == 6 % reject only 
			RM4(i,22,z)=RM4(i,18,z)*S22(i,17,z);  %the squeezed (by supplier) one (e.g., indexed by 21) 
			%reject the squeezed offer
			RM4(i,40,z)=RM4(i,22,z);
			S22(i,15,z)=S22(i,15,z)+RM4(i,22,z);% since exit, therefore applying penalty	
			RM4(i,41,z)=Q(i,z);
			RM4(i,42,z)=1;			
		elseif SqueezeLogic == 7 % accept only 
			RM4(i,22,z)=RM4(i,18,z)*S22(i,17,z);  %the squeezed (by supplier) one (e.g., indexed by 21) 
			%need to update 24 indexed value with squeezed value
			%this will be used in calculating purchase cost of buyer 				
			RM4(i,24,z)=RM4(i,22,z);				
			%RM4 accept the squeezed price
			RM4(i,6,z)=1;
			RM4(i,53,z)=1;
		elseif SqueezeLogic == 5 % new squeeze logic 2, 3, & 4 all together
			% updating fixed cost with probability for increasing internal performance always
			r = xmin+rand*(xmax-xmin); % changing from triangular distribution to uniform distribution using given range 
			if TriangularDistEnabled
				r = random(triangolarecosti);     
			end 			
			RM4(i,20,z)=RM4(i,2,z)*r;     %Randomly modified (triangular) RM4 fcost
			RM4(i,21,z)=Q(i,z)*(RM4(i,18,z)*S22(i,17,z)*(1-RM4(i,5,z))-RM4(i,26,z)); %RM4 cost to reach the target with the squeezed price
			RM4(i,10,z)=1;
		
			%forming maxium last acceptable price to compare with market
			if RM4(i,20,z) < RM4(i,21,z)
				RM4(i,22,z)=RM4(i,18,z)*S22(i,17,z); %the squeezed (by supplier) one (e.g., indexed by 21) 
				RM4(i,25,z)=RM4(i,21,z);
			else	
				RM4(i,22,z)= (RM4(i,26,z)+RM4(i,20,z)/Q(i,z))/(1-RM4(i,5,z)); %the compresed (by self) one (e.g., indexed by 20) 
				RM4(i,25,z)=RM4(i,20,z);
			end 
		
			%the Buyer compares the budget with the market (SWITCHING COSTS?)
			r = xmin+rand*(xmax-xmin); % changing from triangular distribution to uniform distribution using given range 
			if TriangularDistEnabled
				r = random(triangolareswitch);     
			end 			
			RM4(i,23,z)=RM4(i,18,z)*S22(i,17,z)/r;
			if RM4(i,22,z) > RM4(i,23,z)
				%switching to other supplier
				%the Buyer makes a switch of RM4
				RM4(i,24,z)=RM4(i,23,z); 
				RM4(i,11,z)=1;
				S22(i,15,z)=S22(i,15,z)+SW*RM4(i,18,z)*S22(i,2,z);
			else
				%need to update 24 indexed value with compresed (self or squeezed) value
				%this will be used in calculating purchase cost of buyer 		
				RM4(i,24,z)=RM4(i,22,z); % previously, we have updated RM1(i,22,z) value based on comparing 20,21 indexed values
				
				%the supplier compares compressed cost with squeezed cost of buyer
				if RM4(i,20,z) < RM4(i,21,z)
					% modified compressed cost is less than squeezed cost of buyer - so accept it
					% The buyer stays with the old supplier
				else
					%position (degree centrality score) + size (bargaining power)
					TotalPowerToReject = DegCentralityScores(10);
					if SqueezeLogic4Type == 2
						TotalPowerToReject = TotalPowerToReject + RM4(i,14,z);					
					else
						TotalPowerToReject = TotalPowerToReject + AgentSizes(10);					
					end 
					if rand > TotalPowerToReject
						%RM4 adjusts to the market price and lowers its margin
						RM4(i,16,z)=1;
					else				
						%reject the squeezed offer
						RM4(i,40,z)=RM4(i,22,z);
						S22(i,15,z)=S22(i,15,z)+RM4(i,22,z);% since exit, therefore applying penalty	
						RM4(i,41,z)=Q(i,z);
						RM4(i,42,z)=1;
						RM4(i,50,z)=1;
					end 
				end 
			end 
		else %all logics together 
			% updating fixed cost with probability for increasing internal performance always
			RM4(i,20,z)=RM4(i,2,z)*random(triangolarecosti);     %Fcost di RM4 modificati in modo random(triangolare)
			RM4(i,21,z)=Q(i,z)*(RM4(i,18,z)*S22(i,17,z)*(1-RM4(i,5,z))-RM4(i,26,z)); %Fcost di RM4 per raggiungere il target con il prezzo squeezed
			RM4(i,10,z)=1;
		
			%forming maxium last acceptable price to compare with market
			if RM4(i,20,z) < RM4(i,21,z)
				RM4(i,22,z)=RM4(i,18,z)*S22(i,17,z); %the squeezed (by supplier) one (e.g., indexed by 21) 
				RM4(i,25,z)=RM4(i,21,z);
			else	
				RM4(i,22,z)= (RM4(i,26,z)+RM4(i,20,z)/Q(i,z))/(1-RM4(i,5,z)); %the compresed (by self) one (e.g., indexed by 20) 
				RM4(i,25,z)=RM4(i,20,z);
			end 
		
			%S22 confronta il preventivo con il mercato (COSTI DI SWITCHING?) - the Buyer compares the budget with the market (SWITCHING COSTS?)
			RM4(i,23,z)=RM4(i,18,z)*S22(i,17,z)/random(triangolareswitch);
			if RM4(i,22,z) > RM4(i,23,z)
				%switching to other supplier
				%S22 effettua uno switch di RM4 - the Buyer makes a switch of RM4
				RM4(i,24,z)=RM4(i,23,z); 
				RM4(i,11,z)=1;
				S22(i,15,z)=S22(i,15,z)+SW*RM4(i,18,z)*S22(i,2,z);
			else
				%need to update 24 indexed value with compresed (self or squeezed) value
				%this will be used in calculating purchase cost of buyer 		
				RM4(i,24,z)=RM4(i,22,z); % previously, we have updated RM1(i,22,z) value based on comparing 20,21 indexed values
				
				%the supplier compares compressed cost with squeezed cost of buyer
				if RM4(i,20,z) < RM4(i,21,z)
					% modified compressed cost is less than squeezed cost of buyer - so accept it
					%S22 rimane con il vecchio fornitore - The buyer stays with the old supplier
				else
					%Valuto il power imbalance - I value the power imbalance
					if rand>RM4(i,14,z)
						%RM4 si adegua al prezzo di mercato e abbassa il suo margine - RM4 adjusts to the market price and lowers its margin
						RM4(i,16,z)=1;
					else				
						%reject the squeezed offer
						RM4(i,40,z)=RM4(i,22,z);
						S22(i,15,z)=S22(i,15,z)+RM4(i,22,z);% since exit, therefore applying penalty	
						RM4(i,41,z)=Q(i,z);
						RM4(i,42,z)=1;
						%fprintf('RM4-RM4: RM4 - Exit of RM4 and Orders= %f\n', Q(i,z));
					end 
				end 
			end 
		end % end of SqueezeLogic				
    end
	
    if RM5(i,19,z)>RM5(i,5,z)
        %RM5 raggiunge il proprio margine ed accetta
         RM5(i,6,z)=1;
         RM5(i,24,z)=RM5(i,18,z)*S22(i,17,z);
         RM5(i,27,z)=RM5(i,19,z);
    else
		S22(i,9,z)=1;                                                      %Lo squeeze non viene accettato completamente -The squeeze is not accepted completely
		S22(i,8,z)=0;                                                      %Necessario perchè potrebbe essere stato cambiato prima in 1 - Necessary because it may have been changed first in 1
		%RM5 comprime i costi fissi e fa un preventivo - RM5 compresses the fixed costs and makes an estimate

		if SqueezeLogic == 2 %cost reduction only without switch
			% updating fixed cost with probability for increasing internal performance always
			RM5(i,20,z)=RM5(i,2,z)*random(triangolarecosti);     %Fcost di RM5 modificati in modo random(triangolare)
			RM5(i,21,z)=Q(i,z)*(RM5(i,18,z)*S22(i,17,z)*(1-RM5(i,5,z))-RM5(i,26,z)); %Fcost di RM5 per raggiungere il target con il prezzo squeezed
		
			%forming maxium last acceptable price to compare with market
			if RM5(i,20,z) < RM5(i,21,z)
				RM5(i,22,z)=RM5(i,18,z)*S22(i,17,z); %the squeezed (by supplier) one (e.g., indexed by 21) 
				RM5(i,25,z)=RM5(i,21,z);
			else	
				RM5(i,22,z)= (RM5(i,26,z)+RM5(i,20,z)/Q(i,z))/(1-RM5(i,5,z)); %the compresed (by self) one (e.g., indexed by 20) 
				RM5(i,25,z)=RM5(i,20,z);
			end 		
			%accept it directly - recommended by Dr. Mei
			RM5(i,10,z)=1;
			%need to update 24 indexed value with compresed (self or squeezed) value
			%this will be used in calculating purchase cost of buyer 		
			RM5(i,24,z)=RM5(i,22,z); % previously, we have updated RM1(i,22,z) value based on comparing 20,21 indexed values
		elseif SqueezeLogic == 3 %switching without cost reduction
			RM5(i,22,z)=(RM5(i,26,z)+RM5(i,2,z)/Q(i,z))/(1-RM5(i,5,z)); %the price without cost reduction  
			%the Buyer compares the budget with the market (SWITCHING COSTS?)
			RM5(i,23,z)=RM5(i,18,z)*S22(i,17,z)/random(triangolareswitch);
			if RM5(i,22,z) <= RM5(i,23,z)
				%accept it
				RM5(i,10,z)=1;
				%need to update 24 indexed value with compresed (self or squeezed) value
				%this will be used in calculating purchase cost of buyer 		
				RM5(i,24,z)=RM5(i,22,z); % previously, we have updated RM1(i,22,z) value based on comparing 20,21 indexed values
			else
				%switching to other supplier
				%the Buyer makes a switch of RM5
				RM5(i,24,z)=RM5(i,23,z); 
				RM5(i,11,z)=1;
				S22(i,15,z)=S22(i,15,z)+SW*RM5(i,18,z)*S22(i,2,z);
			end 				
		elseif SqueezeLogic == 4 % position (degree centrality score) and size/bargain power to reject
			RM5(i,22,z)=RM5(i,18,z)*S22(i,17,z);  %the squeezed (by supplier) one (e.g., indexed by 21) 
			%position (degree centrality score) + size (bargaining power)
			TotalPowerToReject = DegCentralityScores(10);
			if SqueezeLogic4Type == 2
				TotalPowerToReject = TotalPowerToReject + RM5(i,14,z);					
			else
				TotalPowerToReject = TotalPowerToReject + AgentSizes(10);					
			end 
			if TotalPowerToReject >= rand                    
				%reject the squeezed offer
				RM5(i,40,z)=RM5(i,22,z);
				S22(i,15,z)=S22(i,15,z)+RM5(i,22,z);% since exit, therefore applying penalty	
				RM5(i,41,z)=Q(i,z);
				RM5(i,42,z)=1;			
			else
				%need to update 24 indexed value with squeezed value
				%this will be used in calculating purchase cost of buyer 				
				RM5(i,24,z)=RM5(i,22,z);				
				%RM5 accept the squeezed price
				RM5(i,6,z)=1;
			end 
		elseif SqueezeLogic == 6 % reject only
			RM5(i,22,z)=RM5(i,18,z)*S22(i,17,z);  %the squeezed (by supplier) one (e.g., indexed by 21) 
			%reject the squeezed offer
			RM5(i,40,z)=RM5(i,22,z);
			S22(i,15,z)=S22(i,15,z)+RM5(i,22,z);% since exit, therefore applying penalty	
			RM5(i,41,z)=Q(i,z);
			RM5(i,42,z)=1;			
		elseif SqueezeLogic == 7 % accept only
			RM5(i,22,z)=RM5(i,18,z)*S22(i,17,z);  %the squeezed (by supplier) one (e.g., indexed by 21) 
			%need to update 24 indexed value with squeezed value
			%this will be used in calculating purchase cost of buyer 				
			RM5(i,24,z)=RM5(i,22,z);				
			%RM5 accept the squeezed price
			RM5(i,6,z)=1;
			RM5(i,53,z)=1;
		elseif SqueezeLogic == 5 % new squeeze logic 2, 3, & 4 all together
			% updating fixed cost with probability for increasing internal performance always
			r = xmin+rand*(xmax-xmin); % changing from triangular distribution to uniform distribution using given range 
			if TriangularDistEnabled
				r = random(triangolarecosti);     
			end 			
			RM5(i,20,z)=RM5(i,2,z)*r;     %Randomly modified (triangular) RM5 fcost
			RM5(i,21,z)=Q(i,z)*(RM5(i,18,z)*S22(i,17,z)*(1-RM5(i,5,z))-RM5(i,26,z)); %RM5 cost to reach the target with the squeezed price
			RM5(i,10,z)=1;
		
			%forming maxium last acceptable price to compare with market
			if RM5(i,20,z) < RM5(i,21,z)
				RM5(i,22,z)=RM5(i,18,z)*S22(i,17,z); %the squeezed (by supplier) one (e.g., indexed by 21) 
				RM5(i,25,z)=RM5(i,21,z);
			else	
				RM5(i,22,z)= (RM5(i,26,z)+RM5(i,20,z)/Q(i,z))/(1-RM5(i,5,z)); %the compresed (by self) one (e.g., indexed by 20) 
				RM5(i,25,z)=RM5(i,20,z);
			end 
		
			%the Buyer compares the budget with the market (SWITCHING COSTS?)
			r = xmin+rand*(xmax-xmin); % changing from triangular distribution to uniform distribution using given range 
			if TriangularDistEnabled
				r = random(triangolareswitch);     
			end 			
			RM5(i,23,z)=RM5(i,18,z)*S22(i,17,z)/r;
			if RM5(i,22,z) > RM5(i,23,z)
				%switching to other supplier
				%the Buyer makes a switch of RM5
				RM5(i,24,z)=RM5(i,23,z); 
				RM5(i,11,z)=1;
				S22(i,15,z)=S22(i,15,z)+SW*RM5(i,18,z)*S22(i,2,z);
			else
				%need to update 24 indexed value with compresed (self or squeezed) value
				%this will be used in calculating purchase cost of buyer 		
				RM5(i,24,z)=RM5(i,22,z); % previously, we have updated RM1(i,22,z) value based on comparing 20,21 indexed values
				
				%the supplier compares compressed cost with squeezed cost of buyer
				if RM5(i,20,z) < RM5(i,21,z)
					% modified compressed cost is less than squeezed cost of buyer - so accept it
					% The buyer stays with the old supplier
				else
					%position (degree centrality score) + size (bargaining power)
					TotalPowerToReject = DegCentralityScores(10);
					if SqueezeLogic4Type == 2
						TotalPowerToReject = TotalPowerToReject + RM5(i,14,z);					
					else
						TotalPowerToReject = TotalPowerToReject + AgentSizes(10);					
					end 
					if rand > TotalPowerToReject
						%RM5 adjusts to the market price and lowers its margin
						RM5(i,16,z)=1;
					else				
						%reject the squeezed offer
						RM5(i,40,z)=RM5(i,22,z);
						S22(i,15,z)=S22(i,15,z)+RM5(i,22,z);% since exit, therefore applying penalty	
						RM5(i,41,z)=Q(i,z);
						RM5(i,42,z)=1;
						RM5(i,50,z)=1;
					end 
				end 
			end 
		else %all logics together 
			% updating fixed cost with probability for increasing internal performance always
			RM5(i,20,z)=RM5(i,2,z)*random(triangolarecosti);     %Fcost di RM5 modificati in modo random(triangolare)
			RM5(i,21,z)=Q(i,z)*(RM5(i,18,z)*S22(i,17,z)*(1-RM5(i,5,z))-RM5(i,26,z)); %Fcost di RM5 per raggiungere il target con il prezzo squeezed
			RM5(i,10,z)=1;
		
			%forming maxium last acceptable price to compare with market
			if RM5(i,20,z) < RM5(i,21,z)
				RM5(i,22,z)=RM5(i,18,z)*S22(i,17,z); %the squeezed (by supplier) one (e.g., indexed by 21) 
				RM5(i,25,z)=RM5(i,21,z);
			else	
				RM5(i,22,z)= (RM5(i,26,z)+RM5(i,20,z)/Q(i,z))/(1-RM5(i,5,z)); %the compresed (by self) one (e.g., indexed by 20) 
				RM5(i,25,z)=RM5(i,20,z);
			end 
		
			%S22 confronta il preventivo con il mercato (COSTI DI SWITCHING?) - the Buyer compares the budget with the market (SWITCHING COSTS?)
			RM5(i,23,z)=RM5(i,18,z)*S22(i,17,z)/random(triangolareswitch);
			if RM5(i,22,z) > RM5(i,23,z)
				%switching to other supplier
				%S22 effettua uno switch di RM5 - the Buyer makes a switch of RM5
				RM5(i,24,z)=RM5(i,23,z); 
				RM5(i,11,z)=1;
				S22(i,15,z)=S22(i,15,z)+SW*RM5(i,18,z)*S22(i,2,z);
			else
				%need to update 24 indexed value with compresed (self or squeezed) value
				%this will be used in calculating purchase cost of buyer 		
				RM5(i,24,z)=RM5(i,22,z); % previously, we have updated RM1(i,22,z) value based on comparing 20,21 indexed values
				
				%the supplier compares compressed cost with squeezed cost of buyer
				if RM5(i,20,z) < RM5(i,21,z)
					% modified compressed cost is less than squeezed cost of buyer - so accept it
					%S22 rimane con il vecchio fornitore - The buyer stays with the old supplier
				else
					%Valuto il power imbalance - I value the power imbalance
					if rand>RM5(i,14,z)
						%RM5 si adegua al prezzo di mercato e abbassa il suo margine - RM5 adjusts to the market price and lowers its margin
						RM5(i,16,z)=1;
					else				
						%reject the squeezed offer
						RM5(i,40,z)=RM5(i,22,z);
						S22(i,15,z)=S22(i,15,z)+RM5(i,22,z);% since exit, therefore applying penalty	
						RM5(i,41,z)=Q(i,z);
						RM5(i,42,z)=1;
						%fprintf('RM4-RM5: RM5 - Exit of RM5 and Orders= %f\n', Q(i,z));
					end 
				end 
			end 
		end % end of SqueezeLogic	
    end


end
else
    exit=1;
    RM4(i,28,z)=1;
    RM5(i,28,z)=1;
end       
    
    