%Algoritmo S1 e RM1 - Algorithm S1 and RM1

%calcolo il costo che il Buyer sarebbe disposto a spendere - I calculate the cost that the Buyer would be willing to spend
B(i,17,z)=B(i,1,z)*(1-B(i,5,z))-B(i,2,z)/Q(i,z);

if B(i,17,z)>0
%calcolo il valore percentuale di S1 e RM1 - calculation of the percentage value of S1 and RM1

S1(i,18,z)=S1(i,1,z)/B(i,3,z);
RM1(i,18,z)=RM1(i,1,z)/B(i,3,z);

%ratio of the quantity are allocated for S1 & RM1 
S1(i,51,z) = S1(i,18,z) * Q(i,z); 
RM1(i,51,z) = RM1(i,18,z) * Q(i,z); 

%Calcolo i margini di S1 e RM1 in relazione a PcostsqueezedB - Calculate the profit margins of S1 and RM1 in relation to PcostsqueezedB
S1(i,19,z)=(S1(i,18,z)*B(i,17,z)-S1(i,2,z)/Q(i,z)-S1(i,3,z))/(S1(i,18,z)*B(i,17,z));
RM1(i,19,z)=(RM1(i,18,z)*B(i,17,z)-RM1(i,2,z)/Q(i,z)-RM1(i,3,z))/(RM1(i,18,z)*B(i,17,z));

%just holding the purchase cost before squeeze or not - used of debugging purpose
S1(i,48,z)=S1(i,26,z);

%Controllo se i margini target di S1 e RM1 sono raggiunti - Check if the target margins of S1 and RM1 are reached
% Here S1(i,19,z) is current profit (i.e., PMc or x in Psq equation for learning) 
% and S1(i,5,z) is target profit (i.e., PMt or T in Psq equation for learning) 
if S1(i,19,z)>S1(i,5,z) & RM1(i,19,z)>RM1(i,5,z)
    %la struttura non cambia e lo squeeze viene accettato da S1 e RM1 - the structure does not change and the squeeze is accepted by S1 and RM1
    B(i,8,z)=1;
    S1(i,6,z)=1;
    RM1(i,6,z)=1;
    S1(i,24,z)=S1(i,18,z)*B(i,17,z);
    RM1(i,24,z)=RM1(i,18,z)*B(i,17,z);
    S1(i,27,z)=S1(i,19,z);
    RM1(i,27,z)=RM1(i,19,z);
else
    if S1(i,19,z)>S1(i,5,z)
        %S1 raggiunge il proprio margine ed accetta - S1 reaches its margin and accepts

        S1(i,6,z)=1;
        S1(i,24,z)=S1(i,18,z)*B(i,17,z);
        S1(i,27,z)=S1(i,19,z);
        
    else
	  %apply learning for propensity to squeeze
	  A43 = S1(i,43,z);
	  if LearningEnabled
		if LearningTechnique == 1
			[A43, A44, A45, A46]=LearnAndUpdate(AgentConfigs, Psq, PsqVariance, S1, 2, i, z);
			S1(i,43,z) = A43;
			S1(i,44,z) = A44;
			S1(i,45,z) = A45;
			S1(i,46,z) = A46;			
		elseif LearningTechnique == 2
			[A43, A46] = LearnAndUpdateB(AgentConfigs, Psq, PsqVariance, S1, 2, i, z);
			S1(i,46,z) = A46;
		elseif LearningTechnique == 3		
			A43 = GetPropensityPrediction(AgentConfigs, Psq, S1, 2, svmclS1, i, z);	
		end					
	  end

		if (SqueezeLogic==2 || SqueezeLogic==3 || SqueezeLogic==4 || SqueezeLogic==6 || SqueezeLogic==7 || rand <= A43)
			%S1 tenta la squeeze - S1 tries the squeeze
			S1(i,7,z)=1;
			
			%if learning is enabled, we are saving the current squeezed probability
			if LearningEnabled && (LearningTechnique == 2 || LearningTechnique == 3) 
				S1(i,43,z) = A43;
			end
			
			AlgoritmoS21_S22_RM2
						
			S1(i,26,z)=S21(i,24,z)+S22(i,24,z)+RM2(i,24,z);                                   %in seguito all'algoritmoS21_S22_RM2 è cambiato il costo d'acquisto di S1 - following the algorithm S21_S22_RM2 the purchase cost of S1 has changed
            if S1(i,8,z)>0  
				B(i,8,z)=1;                                                   %S1 accetta lo squeeze perchè è stato accettato da S21 S22 e RM2 - S1 accepts the squeeze because it has been accepted by S21 S22 and RM2
            else						
				B(i,9,z)=1 ;                                                  %Poichè S21 e/o S22 e/o RM2 non ha accettato lo squeeze anche S1 non accetta lo squeeze di B - Since S21 and / or S22 and / or RM2 did not accept the squeeze also S1 does not accept the squeeze of B
   
				if SqueezeLogic == 2 %cost reduction only without switch
					triangolarecosti=makedist('triangular',0.8,1,1);    %triangular distribution of costs
					S1(i,20,z)=S1(i,2,z)*random(triangolarecosti);     %Fcost of S1 randomly modified (triangular)
					S1(i,21,z)=Q(i,z)*(S1(i,18,z)*B(i,17,z)*(1-S1(i,5,z))-S1(i,26,z)); %Fcost of S1 to reach the target with the squeezed price 
				
					%forming maxium last acceptable price to compare with market
					if S1(i,20,z)<S1(i,21,z)
						S1(i,22,z)=S1(i,18,z)*B(i,17,z); %the squeezed (by supplier) one (e.g., indexed by 21)
						S1(i,25,z)=S1(i,21,z);	
					else
						S1(i,22,z)=(S1(i,26,z)+S1(i,20,z)/Q(i,z))/(1-S1(i,5,z)); %the compresed (by self) one (e.g., indexed by 20)
						S1(i,25,z)=S1(i,20,z);	
					end
					%accept it directly - recommended by Dr. Mei
					S1(i,10,z)=1;
					%need to update 24 indexed value with compresed (self or squeezed) value
					%this will be used in calculating purchase cost of buyer 															
					S1(i,24,z)=S1(i,22,z);	% previously, we have updated S1(i,22,z) value based on comparing 20,21 indexed values
				elseif SqueezeLogic == 3 %switching without cost reduction
					S1(i,22,z)=(S1(i,26,z)+S1(i,2,z)/Q(i,z))/(1-S1(i,5,z)); %the price without cost reduction
					%B compares the budget with the market (SWITCHING COSTS?)
					S1(i,23,z)=S1(i,18,z)*B(i,17,z)/random(triangolareswitch);
					if S1(i,22,z) <= S1(i,23,z)
						%accept it
						S1(i,10,z)=1;
						%need to update 24 indexed value with compresed (self or squeezed) value
						%this will be used in calculating purchase cost of buyer 																
						S1(i,24,z)=S1(i,22,z);	% previously, we have updated S1(i,22,z) value based on comparing 20,21 indexed values
					else
						%B makes a switch of S1
						S1(i,24,z)=S1(i,23,z); 
						S1(i,11,z)=1;
						B(i,15,z)=B(i,15,z)+SW*S1(i,18,z)*B(i,2,z);						
					end										
				elseif SqueezeLogic == 4 % position (degree centrality score) and size/bargain power to reject
					S1(i,22,z)=S1(i,18,z)*B(i,17,z);				
					%position (degree centrality score) + size (bargaining power)
					TotalPowerToReject = DegCentralityScores(2);
					if SqueezeLogic4Type == 2
						TotalPowerToReject = TotalPowerToReject + S1(i,14,z);					
					else
						TotalPowerToReject = TotalPowerToReject + AgentSizes(2);					
					end 
						
					if TotalPowerToReject >= rand                     
						%reject the squeezed offer
						S1(i,40,z)=S1(i,22,z);
						B(i,15,z)=B(i,15,z)+S1(i,22,z); % since exit, therefore applying penalty
						S1(i,41,z)=Q(i,z);			
						S1(i,42,z)=1;
						S1(i,50,z)=1;
					else
						%need to update 24 indexed value with squeezed value
						%this will be used in calculating purchase cost of buyer 				
						S1(i,24,z)=S1(i,22,z);				
						%S1 accepts the squeezed price
						S1(i,6,z)=1;
					end 
				elseif SqueezeLogic == 6 % reject only
					S1(i,22,z)=S1(i,18,z)*B(i,17,z);				
					%reject the squeezed offer
					S1(i,40,z)=S1(i,22,z);
					B(i,15,z)=B(i,15,z)+S1(i,22,z); % since exit, therefore applying penalty
					S1(i,41,z)=Q(i,z);			
					S1(i,42,z)=1;
					S1(i,50,z)=1;
				elseif SqueezeLogic == 7 % accept only
					S1(i,22,z)=S1(i,18,z)*B(i,17,z);				
					%need to update 24 indexed value with squeezed value
					%this will be used in calculating purchase cost of buyer 				
					S1(i,24,z)=S1(i,22,z);				
					%S1 accepts the squeezed price
					S1(i,6,z)=1;
					S1(i,53,z)=1;
				elseif SqueezeLogic == 5 % new squeeze logic 2, 3, & 4 all together
					% updating fixed cost with probability for increasing internal performance always
					% S1 compresses the fixed costs and makes a quote
					r = xmin+rand*(xmax-xmin); % changing from triangular distribution to uniform distribution using given range 
					if TriangularDistEnabled
						r = random(triangolarecosti);     %Fcost of S1 randomly modified (triangular)
					end 												
					S1(i,20,z)=S1(i,2,z)*r;
					S1(i,21,z)=Q(i,z)*(S1(i,18,z)*B(i,17,z)*(1-S1(i,5,z))-S1(i,26,z)); %Fcost of S1 to reach the target with the squeezed price
					S1(i,10,z)=1;
					%forming maxium last acceptable price to compare with market
					if S1(i,20,z)<S1(i,21,z)
						S1(i,22,z)=S1(i,18,z)*B(i,17,z); %the squeezed (by supplier) one (e.g., indexed by 21)
						S1(i,25,z)=S1(i,21,z);	
					else
						S1(i,22,z)=(S1(i,26,z)+S1(i,20,z)/Q(i,z))/(1-S1(i,5,z)); %the compresed (by self) one (e.g., indexed by 20)
						S1(i,25,z)=S1(i,20,z);	
					end					
					%B compares the budget with the market (SWITCHING COSTS?)
					r = xmin+rand*(xmax-xmin); % changing from triangular distribution to uniform distribution using given range 
					if TriangularDistEnabled
						r = random(triangolareswitch);     %Fcost of S1 randomly modified (triangular)
					end 												
					S1(i,23,z)=S1(i,18,z)*B(i,17,z)/r;					
					if S1(i,22,z) > S1(i,23,z)
						%switching to other supplier	
						%B makes a switch of S1
						S1(i,24,z)=S1(i,23,z); 
						S1(i,11,z)=1;
						B(i,15,z)=B(i,15,z)+SW*S1(i,18,z)*B(i,2,z);
					else
						%need to update 24 indexed value with compresed (self or squeezed) value
						%this will be used in calculating purchase cost of buyer 				
						S1(i,24,z)=S1(i,22,z);	% previously, we have updated S1(i,22,z) value based on comparing 20,21 indexed values
						
						%the supplier compares compressed cost with squeezed cost of buyer
						if S1(i,20,z)<S1(i,21,z)
							% modified compressed cost is less than squeezed cost of buyer - so accept it
							% B remains with the old supplier		
						else						
							%position (degree centrality score) + size (bargaining power)
							TotalPowerToReject = DegCentralityScores(2);
							if SqueezeLogic4Type == 2
								TotalPowerToReject = TotalPowerToReject + S1(i,14,z);					
							else
								TotalPowerToReject = TotalPowerToReject + AgentSizes(2);					
							end 
							if rand > TotalPowerToReject
								%S1 adjusts to the market price and lowers its margin
								S1(i,16,z)=1;
							else
								%reject the squeezed offer
								S1(i,40,z)=S1(i,22,z);
								B(i,15,z)=B(i,15,z)+S1(i,22,z); % since exit, therefore applying penalty
								S1(i,41,z)=Q(i,z);			
								S1(i,42,z)=1;
								S1(i,50,z)=1;								
							end 
						end
					end
				else %all logics together 
				
					% updating fixed cost with probability for increasing internal performance always
					%S1 comprime i costi fissi e fa un preventivo - S1 compresses the fixed costs and makes a quote
					triangolarecosti=makedist('triangular',0.8,1,1);    %distribuzione triangolare costi - triangular distribution of costs
					S1(i,20,z)=S1(i,2,z)*random(triangolarecosti);     %Fcost di S1 modificati in modo random(triangolare) - Fcost of S1 randomly modified (triangular)
					S1(i,21,z)=Q(i,z)*(S1(i,18,z)*B(i,17,z)*(1-S1(i,5,z))-S1(i,26,z)); %Fcost di S1 per raggiungere il target con il prezzo squeezed - Fcost of S1 to reach the target with the squeezed price
					S1(i,10,z)=1;
					
					S1Tmp1=0;
					%forming maxium last acceptable price to compare with market
					if S1(i,20,z)<S1(i,21,z)
						S1(i,22,z)=S1(i,18,z)*B(i,17,z); %the squeezed (by supplier) one (e.g., indexed by 21)
						S1(i,25,z)=S1(i,21,z);	
					else
						S1(i,22,z)=(S1(i,26,z)+S1(i,20,z)/Q(i,z))/(1-S1(i,5,z)); %the compresed (by self) one (e.g., indexed by 20)
						S1Tmp1 = (S1(i,26,z)+S1(i,20,z)/Q(i,z))/(1-S1(i,5,z)); %the compresed (by self) one (e.g., indexed by 20)					
						S1(i,25,z)=S1(i,20,z);	
					end
					
					%B confronta il preventivo con il mercato (COSTI DI SWITCHING?) - B compares the budget with the market (SWITCHING COSTS?)
					S1(i,23,z)=S1(i,18,z)*B(i,17,z)/random(triangolareswitch);
					if S1(i,22,z) > S1(i,23,z)
						%switching to other supplier	
						%B effettua uno switch di S1 - B makes a switch of S1
						S1(i,24,z)=S1(i,23,z); 
						S1(i,11,z)=1;
						B(i,15,z)=B(i,15,z)+SW*S1(i,18,z)*B(i,2,z);
					else
						%need to update 24 indexed value with compresed (self or squeezed) value
						%this will be used in calculating purchase cost of buyer 				
						S1(i,24,z)=S1(i,22,z);	% previously, we have updated S1(i,22,z) value based on comparing 20,21 indexed values
						
						%the supplier compares compressed cost with squeezed cost of buyer
						if S1(i,20,z)<S1(i,21,z)
							% modified compressed cost is less than squeezed cost of buyer - so accept it
							%B rimane con il vecchio fornitore - B remains with the old supplier		
						else						
							%Valuto il power imbalance - I value the power imbalance
							if rand>S1(i,14,z)                      
								%S1 si adegua al prezzo di mercato e abbassa il suo margine - S1 adjusts to the market price and lowers its margin
								S1(i,16,z)=1;
							else
								%reject the squeezed offer
								S1(i,40,z)=S1(i,22,z);
								B(i,15,z)=B(i,15,z)+S1(i,22,z); % since exit, therefore applying penalty
								S1(i,41,z)=Q(i,z);			
								S1(i,42,z)=1;							
							end 
						end
					end
				end
				
			end % end of SqueezeLogic		
		
		else
			%S1 accetta nonostante il margine target non sia raggiunto - S1 accepts despite the target margin is not reached
			S1(i,6,z)=1;
			S1(i,24,z)=S1(i,18,z)*B(i,17,z);
			S1(i,27,z)=S1(i,19,z);
			S1(i,49,z)=1; %holding the current profit accepted without squeezing
        end	
	end
    if RM1(i,19,z)>RM1(i,5,z)
        %RM1 raggiunge il proprio margine ed accetta - RM1 reaches its margin and accepts
         RM1(i,6,z)=1;
         RM1(i,24,z)=RM1(i,18,z)*B(i,17,z);
         RM1(i,27,z)=RM1(i,19,z);
         
    else	
		% Changes by Zahangir Alam on Dec 16, 2019
		% This brach of code has been modified based on the flow chart
		% by making the esence of the existing implementation of the 2nd version  
		% Verified that every branch works by testing with multiple executions.
		
        B(i,9,z)=1;                                                         %Lo squeeze non viene accettato completamente - The squeeze is not accepted completely
        B(i,8,z)=0;
		%RM1 comprime i costi fissi e fa un preventivo - RM1 compresses the fixed costs and makes an estimate

		if SqueezeLogic == 2 %cost reduction only without switch
			% updating fixed cost with probability for increasing internal performance always
			RM1(i,20,z)=RM1(i,2,z)*random(triangolarecosti);     %Fcost di RM1 modificati in modo random(triangolare) - Fcost of RM1 randomly modified (triangular)
			RM1(i,21,z)=Q(i,z)*(RM1(i,18,z)*B(i,17,z)*(1-RM1(i,5,z))-RM1(i,26,z)); %Fcost di RM1 per raggiungere il target con il prezzo squeezed - Fcost of RM1 to reach the target with the squeezed price

			%forming maxium last acceptable price to compare with market
			if RM1(i,20,z) < RM1(i,21,z)
				RM1(i,22,z)=RM1(i,18,z)*B(i,17,z);  %the squeezed (by supplier) one (e.g., indexed by 21) 
				RM1(i,25,z)=RM1(i,21,z);
			else	
				RM1(i,22,z)=(RM1(i,26,z)+RM1(i,20,z)/Q(i,z))/(1-RM1(i,5,z)); %the compresed (by self) one (e.g., indexed by 20) 
				RM1(i,25,z)=RM1(i,20,z);			   
			end 
			%accept it directly - recommended by Dr. Mei
			RM1(i,10,z)=1;
			%need to update 24 indexed value with compresed (self or squeezed) value
			%this will be used in calculating purchase cost of buyer 		
			RM1(i,24,z)=RM1(i,22,z); % previously, we have updated RM1(i,22,z) value based on comparing 20,21 indexed values				
		elseif SqueezeLogic == 3 %switching without cost reduction
			RM1(i,22,z)=(RM1(i,26,z)+RM1(i,2,z)/Q(i,z))/(1-RM1(i,5,z)); %the price without cost reduction  
			RM1(i,23,z)=RM1(i,18,z)*B(i,17,z)/random(triangolareswitch);			
			if RM1(i,22,z) <= RM1(i,23,z)
				%accept it
				RM1(i,10,z)=1;
				%need to update 24 indexed value with compresed (self or squeezed) value
				%this will be used in calculating purchase cost of buyer 		
				RM1(i,24,z)=RM1(i,22,z); % previously, we have updated RM1(i,22,z) value based on comparing 20,21 indexed values				
			else
				%switching to other supplier
				%the Buyer makes a switch of RM1
				RM1(i,24,z)=RM1(i,23,z); 
				RM1(i,11,z)=1;
				B(i,15,z)=B(i,15,z)+SW*RM1(i,18,z)*B(i,2,z);
			end			
		elseif SqueezeLogic == 4 % position (degree centrality score) and size/bargain power to reject
			RM1(i,22,z)=RM1(i,18,z)*B(i,17,z);  %the squeezed (by supplier) one (e.g., indexed by 21) 
			%position (degree centrality score) + size (bargaining power)
			TotalPowerToReject = DegCentralityScores(6);
			if SqueezeLogic4Type == 2
				TotalPowerToReject = TotalPowerToReject + RM1(i,14,z);					
			else
				TotalPowerToReject = TotalPowerToReject + AgentSizes(6);					
			end 
			
			if TotalPowerToReject >= rand                      
				%reject the squeezed offer
				RM1(i,40,z)=RM1(i,22,z);
				B(i,15,z)=B(i,15,z)+RM1(i,22,z); % since exit, therefore applying penalty
				RM1(i,41,z)=Q(i,z);			
				RM1(i,42,z)=1;
				RM1(i,50,z)=1;
			else
				%need to update 24 indexed value with squeezed value
				%this will be used in calculating purchase cost of buyer 				
				RM1(i,24,z)=RM1(i,22,z);				
				%RM1 accepts the squeezed price
				RM1(i,6,z)=1;
			end 
		elseif SqueezeLogic == 6 % reject only
			RM1(i,22,z)=RM1(i,18,z)*B(i,17,z);  %the squeezed (by supplier) one (e.g., indexed by 21) 
			%reject the squeezed offer
			RM1(i,40,z)=RM1(i,22,z);
			B(i,15,z)=B(i,15,z)+RM1(i,22,z); % since exit, therefore applying penalty
			RM1(i,41,z)=Q(i,z);			
			RM1(i,42,z)=1;
			RM1(i,50,z)=1;
		elseif SqueezeLogic == 7 % accept only
			RM1(i,22,z)=RM1(i,18,z)*B(i,17,z);  %the squeezed (by supplier) one (e.g., indexed by 21) 
			%need to update 24 indexed value with squeezed value
			%this will be used in calculating purchase cost of buyer 				
			RM1(i,24,z)=RM1(i,22,z);				
			%RM1 accepts the squeezed price
			RM1(i,6,z)=1;
			RM1(i,53,z)=1;
		elseif SqueezeLogic == 5 % new squeeze logic 2, 3, & 4 all together
			% updating fixed cost with probability for increasing internal performance always
			r = xmin+rand*(xmax-xmin); % changing from triangular distribution to uniform distribution using given range 
			if TriangularDistEnabled
				r = random(triangolarecosti);     %Fcost of S1 randomly modified (triangular)
			end 	
			RM1(i,20,z)=RM1(i,2,z)*r;				
			RM1(i,21,z)=Q(i,z)*(RM1(i,18,z)*B(i,17,z)*(1-RM1(i,5,z))-RM1(i,26,z)); %Fcost of RM1 to reach the target with the squeezed price
			RM1(i,10,z)=1;
			
			%forming maxium last acceptable price to compare with market
			if RM1(i,20,z) < RM1(i,21,z)
				RM1(i,22,z)=RM1(i,18,z)*B(i,17,z);  %the squeezed (by supplier) one (e.g., indexed by 21) 
				RM1(i,25,z)=RM1(i,21,z);
			else	
				RM1(i,22,z)=(RM1(i,26,z)+RM1(i,20,z)/Q(i,z))/(1-RM1(i,5,z)); %the compresed (by self) one (e.g., indexed by 20) 
				RM1(i,25,z)=RM1(i,20,z);			   
			end 			
			%the Buyer compares the budget with the market (SWITCHING COSTS?)
			r = xmin+rand*(xmax-xmin); % changing from triangular distribution to uniform distribution using given range 
			if TriangularDistEnabled
				r = random(triangolareswitch);     %Fcost of S1 randomly modified (triangular)
			end 
			RM1(i,23,z)=RM1(i,18,z)*B(i,17,z)/r;	
			if RM1(i,22,z) > RM1(i,23,z)
				%switching to other supplier
				%the Buyer makes a switch of RM1
				RM1(i,24,z)=RM1(i,23,z); 
				RM1(i,11,z)=1;
				B(i,15,z)=B(i,15,z)+SW*RM1(i,18,z)*B(i,2,z);
			else
				%need to update 24 indexed value with compresed (self or squeezed) value
				%this will be used in calculating purchase cost of buyer 		
				RM1(i,24,z)=RM1(i,22,z); % previously, we have updated RM1(i,22,z) value based on comparing 20,21 indexed values
				
				%the supplier compares compressed cost with squeezed cost of buyer
				if RM1(i,20,z) < RM1(i,21,z)
					% modified compressed cost is less than squeezed cost of buyer - so accept it
					% The buyer stays with the old supplier
				else
					%position (degree centrality score) + size (bargaining power)
					TotalPowerToReject = DegCentralityScores(6);
					if SqueezeLogic4Type == 2
						TotalPowerToReject = TotalPowerToReject + RM1(i,14,z);					
					else
						TotalPowerToReject = TotalPowerToReject + AgentSizes(6);					
					end 
					if rand > TotalPowerToReject
						% RM1 adjusts to the market price and lowers its margin
						RM1(i,16,z)=1;
					else 
						%reject the squeezed offer
						RM1(i,40,z)=RM1(i,22,z);
						B(i,15,z)=B(i,15,z)+RM1(i,22,z); % since exit, therefore applying penalty
						RM1(i,41,z)=Q(i,z);	
						RM1(i,42,z)=1;
						RM1(i,50,z)=1;
					end	
				end	
			end	
		else %all logics together  	
			% updating fixed cost with probability for increasing internal performance always
			RM1(i,20,z)=RM1(i,2,z)*random(triangolarecosti);     %Fcost di RM1 modificati in modo random(triangolare) - Fcost of RM1 randomly modified (triangular)
			RM1(i,21,z)=Q(i,z)*(RM1(i,18,z)*B(i,17,z)*(1-RM1(i,5,z))-RM1(i,26,z)); %Fcost di RM1 per raggiungere il target con il prezzo squeezed - Fcost of RM1 to reach the target with the squeezed price
			RM1(i,10,z)=1;
			
			RM1Tmp1 = 0;
			%forming maxium last acceptable price to compare with market
			if RM1(i,20,z) < RM1(i,21,z)
				RM1(i,22,z)=RM1(i,18,z)*B(i,17,z);  %the squeezed (by supplier) one (e.g., indexed by 21) 
				RM1(i,25,z)=RM1(i,21,z);
			else	
				RM1(i,22,z)=(RM1(i,26,z)+RM1(i,20,z)/Q(i,z))/(1-RM1(i,5,z)); %the compresed (by self) one (e.g., indexed by 20) 
				RM1Tmp1 = (RM1(i,26,z)+RM1(i,20,z)/Q(i,z))/(1-RM1(i,5,z)); %the compresed (by self) one (e.g., indexed by 20)  
				RM1(i,25,z)=RM1(i,20,z);			   
			end 
			
			%il Buyer confronta il preventivo con il mercato (COSTI DI SWITCHING?) - the Buyer compares the budget with the market (SWITCHING COSTS?)
			RM1(i,23,z)=RM1(i,18,z)*B(i,17,z)/random(triangolareswitch);
			if RM1(i,22,z) > RM1(i,23,z)
				%switching to other supplier
				%il Buyer effettua uno switch di RM1 - the Buyer makes a switch of RM1
				RM1(i,24,z)=RM1(i,23,z); 
				RM1(i,11,z)=1;
				B(i,15,z)=B(i,15,z)+SW*RM1(i,18,z)*B(i,2,z);
			else
				%need to update 24 indexed value with compresed (self or squeezed) value
				%this will be used in calculating purchase cost of buyer 		
				RM1(i,24,z)=RM1(i,22,z); % previously, we have updated RM1(i,22,z) value based on comparing 20,21 indexed values
				
				%the supplier compares compressed cost with squeezed cost of buyer
				if RM1(i,20,z) < RM1(i,21,z)
					% modified compressed cost is less than squeezed cost of buyer - so accept it
					%Il buyer rimane con il vecchio fornitore - The buyer stays with the old supplier
				else
					%Valuto il power imbalance - I value the power imbalance
					if rand > RM1(i,14,z)
						%RM1 si adegua al prezzo di mercato e abbassa il suo margine - RM1 adjusts to the market price and lowers its margin
						RM1(i,16,z)=1;
					else 
						%reject the squeezed offer
						RM1(i,40,z)=RM1(i,22,z);
						B(i,15,z)=B(i,15,z)+RM1(i,22,z); % since exit, therefore applying penalty
						RM1(i,41,z)=Q(i,z);	
						RM1(i,42,z)=1;
					end	
				end	
			end	
		end % end of SqueezeLogic	
	end	
end
else
    exit=1;
    S1(i,28,z)=1;	
    RM1(i,28,z)=1;
end 
        