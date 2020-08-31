%Algoritmo RM3

%calcolo il costo che S21 sarebbe disposto a spendere 
%I calculate the cost that S21 would be willing to spend
S21(i,17,z)=S21(i,18,z)*S1(i,17,z)*(1-S21(i,5,z))-S21(i,25,z)/Q(i,z);
if S21(i,17,z)>0
%calcolo il valore percentuale di RM3
%calculating the percentage value of RM3
RM3(i,18,z)=RM3(i,1,z)/S21(i,3,z);                  %PercRM3 obviously is equal to 1 - PercRM3 ovviamente è uguale ad 1

%Calcolo il margine di RM3 in relazione a PcostsqueezedS21
%Calculate the margin of RM3 in relation to PcostsqueezedS21
RM3(i,19,z)=(RM3(i,18,z)*S21(i,17,z)-RM3(i,2,z)/Q(i,z)-RM3(i,3,z))/(RM3(i,18,z)*S21(i,17,z));

%Controllo se il margine target di RM3 è raggiunto
%Check if the target margin of RM3 is reached
if RM3(i,19,z)>RM3(i,5,z)
    %la struttura non cambia e lo squeeze viene accettato da  RM3
	%the structure does not change and the squeeze is accepted by RM3
    S21(i,8,z)=1;
    RM3(i,6,z)=1;
    RM3(i,24,z)=RM3(i,18,z)*S21(i,17,z);
    RM3(i,27,z)=RM3(i,19,z);
else
    S21(i,9,z)=1;                                                           %Lo squeeze non viene accettato completamente - The squeeze is not accepted completely
    %RM3 comprime i costi fissi e fa un preventivo - - RM3 compresses the fixed costs and makes an estimate
	if SqueezeLogic == 2 %cost reduction only without switch
		% updating fixed cost with probability for increasing internal performance always
		RM3(i,20,z)=RM3(i,2,z)*random(triangolarecosti);     %Fcost di RM3 modificati in modo random(triangolare) - Fcost of RM3 randomly modified (triangular)
		RM3(i,21,z)=Q(i,z)*(RM3(i,18,z)*S21(i,17,z)*(1-RM3(i,5,z))-RM3(i,26,z)); %Fcost di RM3 per raggiungere il target con il prezzo squeezed - Fcost of RM3 to reach the target with the squeezed price

		%forming maxium last acceptable price to compare with market
		if RM3(i,20,z)<RM3(i,21,z)
			RM3(i,22,z)=RM3(i,18,z)*S21(i,17,z); %the squeezed (by supplier) one (e.g., indexed by 21) 
			RM3(i,25,z)=RM3(i,21,z);
		else
			RM3(i,22,z)=(RM3(i,26,z)+RM3(i,20,z)/Q(i,z))/(1-RM3(i,5,z)); %the compresed (by self) one (e.g., indexed by 20) 
			RM3(i,25,z)=RM3(i,20,z);
		end
		%accept it directly - recommended by Dr. Mei
		RM3(i,10,z)=1;
		%need to update 24 indexed value with compresed (self or squeezed) value
		%this will be used in calculating purchase cost of buyer 	
		RM3(i,24,z)=RM3(i,22,z); % previously, we have updated RM1(i,22,z) value based on comparing 20,21 indexed values
	elseif SqueezeLogic == 3 %switching without cost reduction	
		RM3(i,22,z)=(RM3(i,26,z)+RM3(i,2,z)/Q(i,z))/(1-RM3(i,5,z)); %the price without cost reduction 	
		%the Buyer compares the budget with the market (SWITCHING COSTS?)
		RM3(i,23,z)=RM3(i,18,z)*S21(i,17,z)/random(triangolareswitch);
		if RM3(i,22,z) <= RM3(i,23,z)
			%accept it 
			RM3(i,10,z)=1;
			%need to update 24 indexed value with compresed (self or squeezed) value
			%this will be used in calculating purchase cost of buyer 	
			RM3(i,24,z)=RM3(i,22,z); % previously, we have updated RM1(i,22,z) value based on comparing 20,21 indexed values
		else
			%switching to other supplier
			RM3(i,24,z)=RM3(i,23,z); 
			RM3(i,11,z)=1;
			S21(i,15,z)=S21(i,15,z)+SW*RM3(i,18,z)*S21(i,2,z);		
		end		
	elseif SqueezeLogic == 4 % position (degree centrality score) and size/bargain power to reject
		RM3(i,22,z)=RM3(i,18,z)*S21(i,17,z);  %the squeezed (by supplier) one (e.g., indexed by 21) 
		%position (degree centrality score) + size (bargaining power)
		TotalPowerToReject = DegCentralityScores(8);
		if SqueezeLogic4Type == 2
			TotalPowerToReject = TotalPowerToReject + RM3(i,14,z);					
		else
			TotalPowerToReject = TotalPowerToReject + AgentSizes(8);					
		end 
		if TotalPowerToReject >= rand                      
			%reject the squeezed offer
			RM3(i,40,z)=RM3(i,22,z);
			S21(i,15,z)=S21(i,15,z)+RM3(i,22,z); % since exit, therefore applying penalty
			RM3(i,41,z)=Q(i,z);
			RM3(i,42,z)=1;	
			RM3(i,50,z)=1;				
		else
			%need to update 24 indexed value with squeezed value
			%this will be used in calculating purchase cost of buyer 				
			RM3(i,24,z)=RM3(i,22,z);				
			%RM3 accept the squeezed price
			RM3(i,6,z)=1;
		end 
	elseif SqueezeLogic == 6 % reject only
		RM3(i,22,z)=RM3(i,18,z)*S21(i,17,z);  %the squeezed (by supplier) one (e.g., indexed by 21) 
		%reject the squeezed offer
		RM3(i,40,z)=RM3(i,22,z);
		S21(i,15,z)=S21(i,15,z)+RM3(i,22,z); % since exit, therefore applying penalty
		RM3(i,41,z)=Q(i,z);
		RM3(i,42,z)=1;	
		RM3(i,50,z)=1;				
	elseif SqueezeLogic == 7 % accept only
		RM3(i,22,z)=RM3(i,18,z)*S21(i,17,z);  %the squeezed (by supplier) one (e.g., indexed by 21) 
		%need to update 24 indexed value with squeezed value
		%this will be used in calculating purchase cost of buyer 				
		RM3(i,24,z)=RM3(i,22,z);				
		%RM3 accept the squeezed price
		RM3(i,6,z)=1;
		RM3(i,53,z)=1;
	elseif SqueezeLogic == 5 % new squeeze logic 2, 3, & 4 all together
		% updating fixed cost with probability for increasing internal performance always
		r = xmin+rand*(xmax-xmin); % changing from triangular distribution to uniform distribution using given range 
		if TriangularDistEnabled
			r = random(triangolarecosti);     
		end 			
		RM3(i,20,z)=RM3(i,2,z)*r;     %Fcost of RM3 randomly modified (triangular)
		RM3(i,21,z)=Q(i,z)*(RM3(i,18,z)*S21(i,17,z)*(1-RM3(i,5,z))-RM3(i,26,z)); %Fcost of RM3 to reach the target with the squeezed price
		RM3(i,10,z)=1;

		%forming maxium last acceptable price to compare with market
		if RM3(i,20,z)<RM3(i,21,z)
			RM3(i,22,z)=RM3(i,18,z)*S21(i,17,z); %the squeezed (by supplier) one (e.g., indexed by 21) 
			RM3(i,25,z)=RM3(i,21,z);			
		else
			RM3(i,22,z)=(RM3(i,26,z)+RM3(i,20,z)/Q(i,z))/(1-RM3(i,5,z)); %the compresed (by self) one (e.g., indexed by 20) 
			RM3(i,25,z)=RM3(i,20,z);
		end

		%S21 compares the quote with the market (SWITCHING COSTS?)
		r = xmin+rand*(xmax-xmin); % changing from triangular distribution to uniform distribution using given range 
		if TriangularDistEnabled
			r = random(triangolareswitch);     
		end 			
		RM3(i,23,z)=RM3(i,18,z)*S21(i,17,z)/r;
		if RM3(i,22,z) > RM3(i,23,z)
			%switching to other supplier
			RM3(i,24,z)=RM3(i,23,z); 
			RM3(i,11,z)=1;
			S21(i,15,z)=S21(i,15,z)+SW*RM3(i,18,z)*S21(i,2,z);
		else
			%need to update 24 indexed value with compresed (self or squeezed) value
			%this will be used in calculating purchase cost of buyer 	
			RM3(i,24,z)=RM3(i,22,z); % previously, we have updated RM1(i,22,z) value based on comparing 20,21 indexed values
			
			%the supplier compares compressed cost with squeezed cost of buyer
			if RM3(i,20,z)<RM3(i,21,z)
				% modified compressed cost is less than squeezed cost of buyer - so accept it
				% The buyer stays with the old supplier
			else			
				%position (degree centrality score) + size (bargaining power)
				TotalPowerToReject = DegCentralityScores(8);
				if SqueezeLogic4Type == 2
					TotalPowerToReject = TotalPowerToReject + RM3(i,14,z);					
				else
					TotalPowerToReject = TotalPowerToReject + AgentSizes(8);					
				end 
				if rand > TotalPowerToReject
					%RM3 adjusts to the market price and lowers its margin
					RM3(i,16,z)=1;
				else			
					%reject the squeezed offer
					RM3(i,40,z)=RM3(i,22,z);
					S21(i,15,z)=S21(i,15,z)+RM3(i,22,z); % since exit, therefore applying penalty
					RM3(i,41,z)=Q(i,z);
					RM3(i,42,z)=1;
					RM3(i,50,z)=1;
				end
			end
		end
	else %all logics together
		% updating fixed cost with probability for increasing internal performance always
		RM3(i,20,z)=RM3(i,2,z)*random(triangolarecosti);     %Fcost di RM3 modificati in modo random(triangolare) - Fcost of RM3 randomly modified (triangular)
		RM3(i,21,z)=Q(i,z)*(RM3(i,18,z)*S21(i,17,z)*(1-RM3(i,5,z))-RM3(i,26,z)); %Fcost di RM3 per raggiungere il target con il prezzo squeezed - Fcost of RM3 to reach the target with the squeezed price
		RM3(i,10,z)=1;

		%forming maxium last acceptable price to compare with market
		if RM3(i,20,z)<RM3(i,21,z)
			RM3(i,22,z)=RM3(i,18,z)*S21(i,17,z); %the squeezed (by supplier) one (e.g., indexed by 21) 
			RM3(i,25,z)=RM3(i,21,z);			
		else
			RM3(i,22,z)=(RM3(i,26,z)+RM3(i,20,z)/Q(i,z))/(1-RM3(i,5,z)); %the compresed (by self) one (e.g., indexed by 20) 
			RM3(i,25,z)=RM3(i,20,z);
		end

		%S21 confronta il preventivo con il mercato (COSTI DI SWITCHING?) - the Buyer compares the budget with the market (SWITCHING COSTS?)
		RM3(i,23,z)=RM3(i,18,z)*S21(i,17,z)/random(triangolareswitch);
		if RM3(i,22,z) > RM3(i,23,z)
			%switching to other supplier
			RM3(i,24,z)=RM3(i,23,z); 
			RM3(i,11,z)=1;
			S21(i,15,z)=S21(i,15,z)+SW*RM3(i,18,z)*S21(i,2,z);
		else
			%need to update 24 indexed value with compresed (self or squeezed) value
			%this will be used in calculating purchase cost of buyer 	
			RM3(i,24,z)=RM3(i,22,z); % previously, we have updated RM1(i,22,z) value based on comparing 20,21 indexed values
			
			%the supplier compares compressed cost with squeezed cost of buyer
			if RM3(i,20,z)<RM3(i,21,z)
				% modified compressed cost is less than squeezed cost of buyer - so accept it
				%Il buyer rimane con il vecchio fornitore - The buyer stays with the old supplier
			else			
				%Valuto il power imbalance - I value the power imbalance
				if rand>RM3(i,14,z)
					%RM3 si adegua al prezzo di mercato e abbassa il suo margine - RM3 adjusts to the market price and lowers its margin
					RM3(i,16,z)=1;
				else			
					%reject the squeezed offer
					RM3(i,40,z)=RM3(i,22,z);
					S21(i,15,z)=S21(i,15,z)+RM3(i,22,z); % since exit, therefore applying penalty
					RM3(i,41,z)=Q(i,z);
					RM3(i,42,z)=1;
					%fprintf('RM3: - Exit of RM3 and Orders= %f\n', Q(i,z));
				end
			end
		end
	end % end of SqueezeLogic		
end


else
    exit=1;
    RM3(i,28,z)=1;
end