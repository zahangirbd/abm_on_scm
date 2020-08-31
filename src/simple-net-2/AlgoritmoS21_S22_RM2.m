%Algoritmo S21,S22 e RM2

%calcolo il costo che il S1 sarebbe disposto a spendere
S1(i,17,z)=S1(i,18,z)*B(i,17,z)*(1-S1(i,5,z))-S1(i,25,z)/Q(i,z);
if S1(i,17,z)>0
%calcolo il valore percentuale di S21 , S22 e RM2
S21(i,18,z)=S21(i,1,z)/S1(i,3,z);
S22(i,18,z)=S22(i,1,z)/S1(i,3,z);
RM2(i,18,z)=RM2(i,1,z)/S1(i,3,z);

%ratio of the quantity are allocated for S21 & S22 & RM2 
S21(i,51,z) = S21(i,18,z) * Q(i,z); 
S22(i,51,z) = S22(i,18,z) * Q(i,z); 
RM2(i,51,z) = RM2(i,18,z) * Q(i,z); 

%Calcolo i margini di S21,S22 e RM2 in relazione a PcostsqueezedS1
S21(i,19,z)=(S21(i,18,z)*S1(i,17,z)-S21(i,2,z)/Q(i,z)-S21(i,3,z))/(S21(i,18,z)*S1(i,17,z));
S22(i,19,z)=(S22(i,18,z)*S1(i,17,z)-S22(i,2,z)/Q(i,z)-S22(i,3,z))/(S22(i,18,z)*S1(i,17,z));
RM2(i,19,z)=(RM2(i,18,z)*S1(i,17,z)-RM2(i,2,z)/Q(i,z)-RM2(i,3,z))/(RM2(i,18,z)*S1(i,17,z));

%just holding the purchase cost before squeeze or not - used of debugging purpose
S21(i,48,z)=S21(i,26,z);
S22(i,48,z)=S22(i,26,z);

%Controllo se i margini target di S21,S22 e RM2 sono raggiunti
if S21(i,19,z)>S21(i,5,z) & S22(i,19,z)>S22(i,5,z) & RM2(i,19,z)>RM2(i,5,z)
    %la struttura non cambia e lo squeeze viene accettato da S21, S22 e RM2
    S1(i,8,z)=1;
    S21(i,6,z)=1;
    S22(i,6,z)=1;
    RM2(i,6,z)=1;
    S21(i,24,z)=S21(i,18,z)*S1(i,17,z);
    S22(i,24,z)=S22(i,18,z)*S1(i,17,z);
    RM2(i,24,z)=RM2(i,18,z)*S1(i,17,z);
    S21(i,27,z)=S21(i,19,z);
    S22(i,27,z)=S22(i,19,z);
    RM2(i,27,z)=RM2(i,19,z);
else
    if S21(i,19,z)>S21(i,5,z)
        %S21 raggiunge il proprio margine ed accetta
        S21(i,6,z)=1;
        S21(i,24,z)=S21(i,18,z)*S1(i,17,z);
        S21(i,27,z)=S21(i,19,z);
                                                             
    else
        %S21 non raggiunge il proprio margine
%         PsqS21=1-S21(i,19,z)/S21(i,5,z);
%         if rand<1-S21(i,19,z)/S21(i,5,z);

		  %apply learning for propensity to squeeze
		  A43 = S21(i,43,z);
		  if LearningEnabled
			if LearningTechnique == 1
				[A43, A44, A45, A46]=LearnAndUpdate(AgentConfigs, Psq, PsqVariance, S21, 3, i, z);
				S21(i,43,z) = A43;
				S21(i,44,z) = A44;
				S21(i,45,z) = A45;
				S21(i,46,z) = A46;
			elseif LearningTechnique == 2
				[A43, A46] = LearnAndUpdateB(AgentConfigs, Psq, PsqVariance, S21, 3, i, z);
				S21(i,46,z) = A46;
			elseif LearningTechnique == 3		
				A43 = GetPropensityPrediction(AgentConfigs, Psq, S21, 3, svmclS21, i, z);	
			end								
		  end

		if (SqueezeLogic==2 || SqueezeLogic==3 || SqueezeLogic==4 || SqueezeLogic==6 || SqueezeLogic==7 || rand <= A43)  
			%S21 tenta la squeeze - S21 tries the squeeze
			S21(i,7,z)=1;

%			%if learning is enabled, we are saving the current squeezed probability
			if LearningEnabled && (LearningTechnique == 2 || LearningTechnique == 3) 
				S21(i,43,z) = A43;
			end

			%saving current rng to restore later - used for reproducibility
			%S21rng = rng;
			
			AlgoritmoRM3
			
			%restoring the saved rng - used for reproducibility
			%rng(S21rng);
			
			S21(i,26,z)=RM3(i,24,z);                                               %in seguito all'algoritmoRM3 è cambiato il costo d'acquisto di S21 - following the algorithm RM3 the purchase cost of S21 has changed
            if S21(i,8,z)>0
				S1(i,8,z)=1;                                                   %S21 accetta lo squeeze perchè è stato accettato da RM3 - S21 accepts the squeeze because it has been accepted by RM3
            else
				S1(i,9,z)=1 ;                                                  %Poichè RM3 non ha accettato lo squeeze anche S21 non accetta lo squeeze di S1 - As RM3 did not accept the squeeze also S21 does not accept the squeeze of S1 
				
				if SqueezeLogic == 2 %cost reduction only without switch
					% updating fixed cost with probability for increasing internal performance always
					%S21 comprime i costi e fa un preventivo - S21 compresses the costs and makes a quote
					S21(i,20,z)=S21(i,2,z)*random(triangolarecosti);     %Fcost di S21 modificati in modo random(triangolare) - Fcost of S21 randomly modified (triangular)
					S21(i,21,z)=Q(i,z)*(S21(i,18,z)*S1(i,17,z)*(1-S21(i,5,z))-S21(i,26,z)); %Fcost di S21 per raggiungere il target con il prezzo squeezed - Fcost of S21 to reach the target with the squeezed price
					
					%forming maxium last acceptable price to compare with market
					if S21(i,20,z)<S21(i,21,z)
						S21(i,22,z)=S21(i,18,z)*S1(i,17,z); %the squeezed (by supplier) one (e.g., indexed by 21) 
						S21(i,25,z)=S21(i,21,z);						
					else
						S21(i,22,z)= (S21(i,26,z)+S21(i,20,z)/Q(i,z))/(1-S21(i,5,z)); %the compresed (by self) one (e.g., indexed by 20) 
						S21(i,25,z)=S21(i,20,z);
					end					
					%accept it directly - recommended by Dr. Mei
					S21(i,10,z)=1;
					%need to update 24 indexed value with compresed (self or squeezed) value
					%this will be used in calculating purchase cost of buyer 																
					S21(i,24,z)=S21(i,22,z); % previously, we have updated S1(i,22,z) value based on comparing 20,21 indexed values
				elseif SqueezeLogic == 3 %switching without cost reduction
					S21(i,22,z)= (S21(i,26,z)+S21(i,2,z)/Q(i,z))/(1-S21(i,5,z)); %the price without cost reduction 
					%S1 compares the budget with the market (SWITCHING COSTS?)
					S21(i,23,z)=S21(i,18,z)*S1(i,17,z)/random(triangolareswitch);
					if S21(i,22,z) <= S21(i,23,z)
						%accept it
						S21(i,10,z)=1;
						%need to update 24 indexed value with compresed (self or squeezed) value
						%this will be used in calculating purchase cost of buyer 														
						S21(i,24,z)=S21(i,22,z); % previously, we have updated S1(i,22,z) value based on comparing 20,21 indexed values
					else 
						%S1 makes a switch of S21
						S21(i,24,z)=S21(i,23,z); 
						S21(i,11,z)=1;
						S1(i,15,z)=S1(i,15,z)+SW*S21(i,18,z)*S1(i,2,z);
					end 					
				elseif SqueezeLogic == 4 % position (degree centrality score) and size/bargain power to reject
					S21(i,22,z)=S21(i,18,z)*S1(i,17,z);  %the squeezed (by supplier) one (e.g., indexed by 21) 
					%position (degree centrality score) + size (bargaining power)
					TotalPowerToReject = DegCentralityScores(3);
					if SqueezeLogic4Type == 2
						TotalPowerToReject = TotalPowerToReject + S21(i,14,z);					
					else
						TotalPowerToReject = TotalPowerToReject + AgentSizes(3);					
					end 
					
					if TotalPowerToReject >= rand                      
						%reject the squeezed offer
						S21(i,40,z)=S21(i,22,z);
						S1(i,15,z)=S1(i,15,z)+S21(i,22,z);	% since exit, therefore applying penalty
						S21(i,41,z)=Q(i,z);
						S21(i,42,z)=1;
						S21(i,50,z)=1;
					else
						%need to update 24 indexed value with squeezed value
						%this will be used in calculating purchase cost of buyer 				
						S21(i,24,z)=S21(i,22,z);				
						%S21 accept the squeezed price
						S21(i,6,z)=1;
					end 
				elseif SqueezeLogic == 6 % reject only
					S21(i,22,z)=S21(i,18,z)*S1(i,17,z);  %the squeezed (by supplier) one (e.g., indexed by 21) 					
					%reject the squeezed offer
					S21(i,40,z)=S21(i,22,z);
					S1(i,15,z)=S1(i,15,z)+S21(i,22,z);	% since exit, therefore applying penalty
					S21(i,41,z)=Q(i,z);
					S21(i,42,z)=1;
					S21(i,50,z)=1;
				elseif SqueezeLogic == 7 % accept only
					S21(i,22,z)=S21(i,18,z)*S1(i,17,z);  %the squeezed (by supplier) one (e.g., indexed by 21) 					
					%need to update 24 indexed value with squeezed value
					%this will be used in calculating purchase cost of buyer 				
					S21(i,24,z)=S21(i,22,z);				
					%S21 accept the squeezed price
					S21(i,6,z)=1;
					S21(i,53,z)=1;					
				elseif SqueezeLogic == 5 % new squeeze logic 2, 3, & 4 all together
					% updating fixed cost with probability for increasing internal performance always
					% S21 compresses the costs and makes a quote
					r = xmin+rand*(xmax-xmin); % changing from triangular distribution to uniform distribution using given range 
					if TriangularDistEnabled
						r = random(triangolarecosti);     %Fcost of S1 randomly modified (triangular)
					end 
					S21(i,20,z)=S21(i,2,z)*r;										
					S21(i,21,z)=Q(i,z)*(S21(i,18,z)*S1(i,17,z)*(1-S21(i,5,z))-S21(i,26,z)); %Fcost of S21 to reach the target with the squeezed price
					S21(i,10,z)=1;
					
					%forming maxium last acceptable price to compare with market
					if S21(i,20,z)<S21(i,21,z)
						S21(i,22,z)=S21(i,18,z)*S1(i,17,z); %the squeezed (by supplier) one (e.g., indexed by 21) 
						S21(i,25,z)=S21(i,21,z);						
					else
						S21(i,22,z)= (S21(i,26,z)+S21(i,20,z)/Q(i,z))/(1-S21(i,5,z)); %the compresed (by self) one (e.g., indexed by 20) 
						S21(i,25,z)=S21(i,20,z);
					end
					
					%S1 compares the budget with the market (SWITCHING COSTS?)
					r = xmin+rand*(xmax-xmin); % changing from triangular distribution to uniform distribution using given range 
					if TriangularDistEnabled
						r = random(triangolareswitch);     %Fcost of S1 randomly modified (triangular)
					end 
					S21(i,23,z)=S21(i,18,z)*S1(i,17,z)/r;
					
					if S21(i,22,z) > S21(i,23,z)
						%switching to other supplier	
						%S1 makes a switch of S21
						S21(i,24,z)=S21(i,23,z); 
						S21(i,11,z)=1;
						S1(i,15,z)=S1(i,15,z)+SW*S21(i,18,z)*S1(i,2,z);
					else
						%need to update 24 indexed value with compresed (self or squeezed) value
						%this will be used in calculating purchase cost of buyer 				
						S21(i,24,z)=S21(i,22,z); % previously, we have updated S1(i,22,z) value based on comparing 20,21 indexed values
						
						%the supplier compares compressed cost with squeezed cost of buyer
						if S21(i,20,z)<S21(i,21,z)
							%modified compressed cost is less than squeezed cost of buyer - so accept it
							%S1 stays with the old supplier
						else						
							%position (degree centrality score) + size (bargaining power)
							TotalPowerToReject = DegCentralityScores(3);
							if SqueezeLogic4Type == 2
								TotalPowerToReject = TotalPowerToReject + S21(i,14,z);					
							else
								TotalPowerToReject = TotalPowerToReject + AgentSizes(3);					
							end 
							if rand > TotalPowerToReject                     
								%S21 adjusts to the market price and lowers its margin
								S21(i,16,z)=1;
							else
								%reject the squeezed offer
								S21(i,40,z)=S21(i,22,z);
								S1(i,15,z)=S1(i,15,z)+S21(i,22,z);	% since exit, therefore applying penalty
								S21(i,41,z)=Q(i,z);
								S21(i,42,z)=1;
								S21(i,50,z)=1;
							end
						end 
					end
				else %all logics together 

					% updating fixed cost with probability for increasing internal performance always
					%S21 comprime i costi e fa un preventivo - S21 compresses the costs and makes a quote
					S21(i,20,z)=S21(i,2,z)*random(triangolarecosti);     %Fcost di S21 modificati in modo random(triangolare) - Fcost of S21 randomly modified (triangular)
					S21(i,21,z)=Q(i,z)*(S21(i,18,z)*S1(i,17,z)*(1-S21(i,5,z))-S21(i,26,z)); %Fcost di S21 per raggiungere il target con il prezzo squeezed - Fcost of S21 to reach the target with the squeezed price
					S21(i,10,z)=1;
					
					%forming maxium last acceptable price to compare with market
					if S21(i,20,z)<S21(i,21,z)
						S21(i,22,z)=S21(i,18,z)*S1(i,17,z); %the squeezed (by supplier) one (e.g., indexed by 21) 
						S21(i,25,z)=S21(i,21,z);
						
					else
						S21(i,22,z)= (S21(i,26,z)+S21(i,20,z)/Q(i,z))/(1-S21(i,5,z)); %the compresed (by self) one (e.g., indexed by 20) 
						S21(i,25,z)=S21(i,20,z);
					end
					
					%S1 confronta il preventivo con il mercato (COSTI DI SWITCHING?) - S1 compares the budget with the market (SWITCHING COSTS?)
					S21(i,23,z)=S21(i,18,z)*S1(i,17,z)/random(triangolareswitch);
					if S21(i,22,z) > S21(i,23,z)
						%switching to other supplier	
						%S1 effettua uno switch di S21 - S1 makes a switch of S21
						S21(i,24,z)=S21(i,23,z); 
						S21(i,11,z)=1;
						S1(i,15,z)=S1(i,15,z)+SW*S21(i,18,z)*S1(i,2,z);
					else
						%need to update 24 indexed value with compresed (self or squeezed) value
						%this will be used in calculating purchase cost of buyer 				
						S21(i,24,z)=S21(i,22,z); % previously, we have updated S1(i,22,z) value based on comparing 20,21 indexed values
						
						%the supplier compares compressed cost with squeezed cost of buyer
						if S21(i,20,z)<S21(i,21,z)
							%modified compressed cost is less than squeezed cost of buyer - so accept it
							%S1 rimane con il vecchio fornitore - S1 stays with the old supplier
						else						
							%Valuto il power imbalance
							if rand>S21(i,14,z)                     
								%S21 si adegua al prezzo di mercato e abbassa il suo margine
								S21(i,16,z)=1;
							else
								%reject the squeezed offer
								S21(i,40,z)=S21(i,22,z);
								S1(i,15,z)=S1(i,15,z)+S21(i,22,z);	% since exit, therefore applying penalty
								S21(i,41,z)=Q(i,z);
								S21(i,42,z)=1;
								%fprintf('S21-S22-RM2: S21 - Exit of S21 and Orders= %f\n', Q(i,z));
							end
						end 
					end
				end % end of SqueezeLogic
            end
	   else
			%S21 accetta nonostante il margine target non sia raggiunto
			S21(i,6,z)=1;
			S21(i,24,z)=S21(i,18,z)*S1(i,17,z);
			S21(i,27,z)=S21(i,19,z);
			S21(i,49,z)=1; %holding the current profit accepted without squeezing

        end
	end
    if S22(i,19,z)>S22(i,5,z)
        %S22 raggiunge il proprio margine ed accetta
        S22(i,6,z)=1;
        S22(i,24,z)=S22(i,18,z)*S1(i,17,z);
        S22(i,27,z)=S22(i,19,z);
        
    else
        %S22 non raggiunge il proprio margine
%         PsqS22=1-S22(i,19,z)/S22(i,5,z);
%         if rand<1-S22(i,19,z)/S22(i,5,z);

		  %apply learning for propensity to squeeze
		  A43 = S22(i,43,z);
		  if LearningEnabled
			if LearningTechnique == 1
				[A43, A44, A45, A46]=LearnAndUpdate(AgentConfigs, Psq, PsqVariance, S22, 4, i, z);
				S22(i,43,z) = A43;
				S22(i,44,z) = A44;
				S22(i,45,z) = A45;
				S22(i,46,z) = A46;					
			elseif LearningTechnique == 2
				[A43, A46] = LearnAndUpdateB(AgentConfigs, Psq, PsqVariance, S22, 4, i, z);			
				S22(i,46,z) = A46;					
			elseif LearningTechnique == 3		
				A43 = GetPropensityPrediction(AgentConfigs, Psq, S22, 4, svmclS22, i, z);	
			end								
		  end

		if (SqueezeLogic==2 || SqueezeLogic==3 || SqueezeLogic==4 || SqueezeLogic==6 || SqueezeLogic==7 || rand <= A43)
			%S22 tenta la squeeze - S22 tries the squeeze
			S22(i,7,z)=1;

%			%if learning is enabled, we are saving the current squeezed probability
			if LearningEnabled && (LearningTechnique == 2 || LearningTechnique == 3) 
				S22(i,43,z) = A43;
			end

			%saving current rng to restore later - used for reproducibility
			%S22rng = rng;
		
			AlgoritmoRM4_RM5
			
			%restoring the saved rng - used for reproducibility
			%rng(S22rng);
			
			S22(i,26,z)=RM4(i,24,z)+RM5(i,24,z);                                               %in seguito all'AlgoritmoRM4_RM5.m è cambiato il costo d'acquisto di S22 - following the algorithm RM4_RM5 the purchase cost of S22 has changed
            if S22(i,8,z)>0
				S1(i,8,z)=1;                                                   %S22 accetta lo squeeze perchè è stato accettato da RM4 e RM5 - S22 accepts the squeeze because it has been accepted by RM4 and RM5
            else
				S1(i,9,z)=1 ;                                                  %Poichè RM4 e/o RM5 non ha accettato lo squeeze anche S22 non accetta lo squeeze di S1 - Since RM4 and / or RM5 did not accept the squeeze also S22 does not accept the squeeze of S1
				S1(i,8,z)=0;
            
				if SqueezeLogic == 2 %cost reduction only without switch
					% updating fixed cost with probability for increasing internal performance always
					%S22 comprime i costi fissi e fa un preventivo - S22 compresses the fixed costs and makes a quote
					S22(i,20,z)=S22(i,2,z)*random(triangolarecosti);     %Fcost di S22 modificati in modo random(triangolare)- Fcost of S22 randomly modified (triangular)
					S22(i,21,z)=Q(i,z)*(S22(i,18,z)*S1(i,17,z)*(1-S22(i,5,z))-S22(i,26,z)); %Fcost di S22 per raggiungere il target con il prezzo squeezed - Fcost of S22 to reach the target with the squeezed price

					%forming maxium last acceptable price to compare with market
					if S22(i,20,z)<S22(i,21,z)
						S22(i,22,z)=S22(i,18,z)*S1(i,17,z); %the squeezed (by supplier) one (e.g., indexed by 21) 
						S22(i,25,z)=S22(i,21,z);
					else
						S22(i,22,z)= (S22(i,26,z)+S22(i,20,z)/Q(i,z))/(1-S22(i,5,z)); %the compresed (by self) one (e.g., indexed by 20)
						S22(i,25,z)=S22(i,20,z);
					end 
					%accept it directly - recommended by Dr. Mei
					S22(i,10,z)=1;
					%need to update 24 indexed value with compresed (self or squeezed) value
					%this will be used in calculating purchase cost of buyer 																
					S22(i,24,z)=S22(i,22,z); % previously, we have updated S1(i,22,z) value based on comparing 20,21 indexed values
				elseif SqueezeLogic == 3 %switching without cost reduction
					S22(i,22,z)= (S22(i,26,z)+S22(i,2,z)/Q(i,z))/(1-S22(i,5,z)); %the price without cost reduction 
					%S1 compares the budget with the market (SWITCHING COSTS?)
					S22(i,23,z)=S22(i,18,z)*S1(i,17,z)/random(triangolareswitch);
					if S22(i,22,z) <= S22(i,23,z)
						%accept it
						S22(i,10,z)=1;
						%need to update 24 indexed value with compresed (self or squeezed) value
						%this will be used in calculating purchase cost of buyer 										
						S22(i,24,z)=S22(i,22,z); % previously, we have updated S1(i,22,z) value based on comparing 20,21 indexed values
					else
						%S1 makes a switch of S22
						S22(i,24,z)=S22(i,23,z); 
						S22(i,11,z)=1;
						S1(i,15,z)=S1(i,15,z)+SW*S22(i,18,z)*S1(i,2,z);							
					end 								
				elseif SqueezeLogic == 4 % position (degree centrality score) and size/bargain power to reject
					S22(i,22,z)=S22(i,18,z)*S1(i,17,z);  %the squeezed (by supplier) one (e.g., indexed by 21) 
					%position (degree centrality score) + size (bargaining power)
					TotalPowerToReject = DegCentralityScores(4);
					if SqueezeLogic4Type == 2
						TotalPowerToReject = TotalPowerToReject + S22(i,14,z);					
					else
						TotalPowerToReject = TotalPowerToReject + AgentSizes(4);					
					end 
					if TotalPowerToReject >= rand                      
						%reject the squeezed offer
						S22(i,40,z)=S22(i,22,z);
						S1(i,15,z)=S1(i,15,z)+S22(i,22,z); % since exit, therefore applying penalty			
						S22(i,41,z)=Q(i,z);	
						S22(i,42,z)=1;						
						S22(i,50,z)=1;						
					else
						%need to update 24 indexed value with squeezed value
						%this will be used in calculating purchase cost of buyer 				
						S22(i,24,z)=S22(i,22,z);				
						%S22 accept the squeezed price
						S22(i,6,z)=1;
					end 
				elseif SqueezeLogic == 6 %reject only
					S22(i,22,z)=S22(i,18,z)*S1(i,17,z);  %the squeezed (by supplier) one (e.g., indexed by 21) 
					%reject the squeezed offer
					S22(i,40,z)=S22(i,22,z);
					S1(i,15,z)=S1(i,15,z)+S22(i,22,z); % since exit, therefore applying penalty			
					S22(i,41,z)=Q(i,z);	
					S22(i,42,z)=1;						
					S22(i,50,z)=1;						
				elseif SqueezeLogic == 7 %accept only
					S22(i,22,z)=S22(i,18,z)*S1(i,17,z);  %the squeezed (by supplier) one (e.g., indexed by 21) 
					%need to update 24 indexed value with squeezed value
					%this will be used in calculating purchase cost of buyer 				
					S22(i,24,z)=S22(i,22,z);				
					%S22 accept the squeezed price
					S22(i,6,z)=1;
					S22(i,53,z)=1;
				elseif SqueezeLogic == 5 % new squeeze logic 2, 3, & 4 all together
					% updating fixed cost with probability for increasing internal performance always
					% S22 compresses the fixed costs and makes a quote
					r = xmin+rand*(xmax-xmin); % changing from triangular distribution to uniform distribution using given range 
					if TriangularDistEnabled
						r = random(triangolarecosti);     %Fcost of S1 randomly modified (triangular)
					end 
					S22(i,20,z)=S22(i,2,z)*r;
					S22(i,21,z)=Q(i,z)*(S22(i,18,z)*S1(i,17,z)*(1-S22(i,5,z))-S22(i,26,z)); %Fcost of S22 to reach the target with the squeezed price
					S22(i,10,z)=1;
					
					%forming maxium last acceptable price to compare with market
					if S22(i,20,z)<S22(i,21,z)
						S22(i,22,z)=S22(i,18,z)*S1(i,17,z); %the squeezed (by supplier) one (e.g., indexed by 21) 
						S22(i,25,z)=S22(i,21,z);
					else
						S22(i,22,z)= (S22(i,26,z)+S22(i,20,z)/Q(i,z))/(1-S22(i,5,z)); %the compresed (by self) one (e.g., indexed by 20)
						S22(i,25,z)=S22(i,20,z);
					end 

					%S1 compares the budget with the market (SWITCHING COSTS?)
					r = xmin+rand*(xmax-xmin); % changing from triangular distribution to uniform distribution using given range 
					if TriangularDistEnabled
						r = random(triangolareswitch);     %Fcost of S1 randomly modified (triangular)
					end 
					S22(i,23,z)=S22(i,18,z)*S1(i,17,z)/r;						
					if S22(i,22,z) > S22(i,23,z)
						%switching to other supplier	
						%S1 makes a switch of S22
						S22(i,24,z)=S22(i,23,z); 
						S22(i,11,z)=1;
						S1(i,15,z)=S1(i,15,z)+SW*S22(i,18,z)*S1(i,2,z);		
					else
						%need to update 24 indexed value with compresed (self or squeezed) value
						%this will be used in calculating purchase cost of buyer 				
						S22(i,24,z)=S22(i,22,z); % previously, we have updated S1(i,22,z) value based on comparing 20,21 indexed values
						
						%the supplier compares compressed cost with squeezed cost of buyer
						if S22(i,20,z)<S22(i,21,z)
							%modified compressed cost is less than squeezed cost of buyer - so accept it
							%S1 stays with the old supplie	
						else					   
							%position (degree centrality score) + size (bargaining power)
							TotalPowerToReject = DegCentralityScores(4);
							if SqueezeLogic4Type == 2
								TotalPowerToReject = TotalPowerToReject + S22(i,14,z);					
							else
								TotalPowerToReject = TotalPowerToReject + AgentSizes(4);					
							end 
							if rand > TotalPowerToReject                     
								%S22 adjusts to the market price and lowers its margin
								S22(i,16,z)=1;
							else
								%reject the squeezed offer
								S22(i,40,z)=S22(i,22,z);
								S1(i,15,z)=S1(i,15,z)+S22(i,22,z); % since exit, therefore applying penalty			
								S22(i,41,z)=Q(i,z);	
								S22(i,42,z)=1;
								S22(i,50,z)=1;
							end
						end
					end
				else %all logics together 
					% updating fixed cost with probability for increasing internal performance always
					%S22 comprime i costi fissi e fa un preventivo - S22 compresses the fixed costs and makes a quote
					S22(i,20,z)=S22(i,2,z)*random(triangolarecosti);     %Fcost di S22 modificati in modo random(triangolare)- Fcost of S22 randomly modified (triangular)
					S22(i,21,z)=Q(i,z)*(S22(i,18,z)*S1(i,17,z)*(1-S22(i,5,z))-S22(i,26,z)); %Fcost di S22 per raggiungere il target con il prezzo squeezed - Fcost of S22 to reach the target with the squeezed price
					S22(i,10,z)=1;
					
					%forming maxium last acceptable price to compare with market
					if S22(i,20,z)<S22(i,21,z)
						S22(i,22,z)=S22(i,18,z)*S1(i,17,z); %the squeezed (by supplier) one (e.g., indexed by 21) 
						S22(i,25,z)=S22(i,21,z);
					else
						S22(i,22,z)= (S22(i,26,z)+S22(i,20,z)/Q(i,z))/(1-S22(i,5,z)); %the compresed (by self) one (e.g., indexed by 20)
						S22(i,25,z)=S22(i,20,z);
					end 

					%S1 confronta il preventivo con il mercato (COSTI DI SWITCHING?) - S1 compares the budget with the market (SWITCHING COSTS?)
					S22(i,23,z)=S22(i,18,z)*S1(i,17,z)/random(triangolareswitch);
					if S22(i,22,z) > S22(i,23,z)
						%switching to other supplier	
						%S1 effettua uno switch di S22 - S1 makes a switch of S22
						S22(i,24,z)=S22(i,23,z); 
						S22(i,11,z)=1;
						S1(i,15,z)=S1(i,15,z)+SW*S22(i,18,z)*S1(i,2,z);		
					else
						%need to update 24 indexed value with compresed (self or squeezed) value
						%this will be used in calculating purchase cost of buyer 				
						S22(i,24,z)=S22(i,22,z); % previously, we have updated S1(i,22,z) value based on comparing 20,21 indexed values
						
						%the supplier compares compressed cost with squeezed cost of buyer
						if S22(i,20,z)<S22(i,21,z)
							%modified compressed cost is less than squeezed cost of buyer - so accept it
							%S1 rimane con il vecchio fornitore - S1 stays with the old supplie	
						else					   
							%Valuto il power imbalance - I value the power imbalance
							if rand>S22(i,14,z)                     
								%S22 si adegua al prezzo di mercato e abbassa il suo margine - S22 adjusts to the market price and lowers its margin
								S22(i,16,z)=1;
							else
								%reject the squeezed offer
								S22(i,40,z)=S22(i,22,z);
								S1(i,15,z)=S1(i,15,z)+S22(i,22,z); % since exit, therefore applying penalty			
								S22(i,41,z)=Q(i,z);	
								S22(i,42,z)=1;
								%fprintf('S21-S22-RM2: S22 - Exit of S22 and Orders= %f\n', Q(i,z));					   
							end
						end
					end
				end % end of SqueezeLogic
			end	
        else
			%S22 accetta nonostante il margine target non sia raggiunto
			S22(i,6,z)=1;
			S22(i,24,z)=S22(i,18,z)*S1(i,17,z);
			S22(i,27,z)=S22(i,19,z);
			S22(i,49,z)=1; %holding the current profit accepted without squeezing			
        end
    end
    if RM2(i,19,z)>RM2(i,5,z)
        %RM2 raggiunge il proprio margine ed accetta
         RM2(i,6,z)=1;
         RM2(i,24,z)=RM2(i,18,z)*S1(i,17,z);
         RM2(i,27,z)=RM2(i,19,z);
          
    else
         
		S1(i,9,z)=1;                                                       %Lo squeeze non viene accettato completamente - The squeeze is not accepted completely
		S1(i,8,z)=0;                                                      %Necessario perchè potrebbe essere stato cambiato prima in 1 - Necessary because it may have been changed first in 1
		%RM2 comprime i costi fissi e fa un preventivo
		
		if SqueezeLogic == 2 %cost reduction only without switch
			% updating fixed cost with probability for increasing internal performance always
			RM2(i,20,z)=RM2(i,2,z)*random(triangolarecosti);     %Fcost di RM2 modificati in modo random(triangolare) - Fcost of RM2 randomly modified (triangular)
			RM2(i,21,z)=Q(i,z)*(RM2(i,18,z)*S1(i,17,z)*(1-RM2(i,5,z))-RM2(i,26,z)); %Fcost di RM2 per raggiungere il target con il prezzo squeezed - Fcost of RM2 to reach the target with the squeezed price
			
			%forming maxium last acceptable price to compare with market
			if RM2(i,20,z)<RM2(i,21,z)
				RM2(i,22,z)=RM2(i,18,z)*S1(i,17,z); %the squeezed (by supplier) one (e.g., indexed by 21) 
				RM2(i,25,z)=RM2(i,21,z);
			else
				RM2(i,22,z)=(RM2(i,26,z)+RM2(i,20,z)/Q(i,z))/(1-RM2(i,5,z)); %the compresed (by self) one (e.g., indexed by 20)
				RM2(i,25,z)=RM2(i,20,z);
			end
			%accept it directly - recommended by Dr. Mei
			RM2(i,10,z)=1;
			%need to update 24 indexed value with compresed (self or squeezed) value
			%this will be used in calculating purchase cost of buyer 
			RM2(i,24,z)=RM2(i,22,z); % previously, we have updated RM1(i,22,z) value based on comparing 20,21 indexed values
		elseif SqueezeLogic == 3 %switching without cost reduction
			RM2(i,22,z)=(RM2(i,26,z)+RM2(i,2,z)/Q(i,z))/(1-RM2(i,5,z)); %the price without cost reduction 
			%the Buyer compares the budget with the market (SWITCHING COSTS?)
			RM2(i,23,z)=RM2(i,18,z)*S1(i,17,z)/random(triangolareswitch);
			if RM2(i,22,z) <= RM2(i,23,z)
				%accept it
				RM2(i,10,z)=1;
				%need to update 24 indexed value with compresed (self or squeezed) value
				%this will be used in calculating purchase cost of buyer 
				RM2(i,24,z)=RM2(i,22,z); % previously, we have updated RM1(i,22,z) value based on comparing 20,21 indexed values
			else
				%switching to other supplier
				%the Buyer makes a switch of RM1
				RM2(i,24,z)=RM2(i,23,z); 
				RM2(i,11,z)=1;
				S1(i,15,z)=S1(i,15,z)+SW*RM2(i,18,z)*S1(i,2,z);
			end 			
		elseif SqueezeLogic == 4 % position (degree centrality score) and size/bargain power to reject
			RM2(i,22,z)=RM2(i,18,z)*S1(i,17,z);  %the squeezed (by supplier) one (e.g., indexed by 21) 
			%position (degree centrality score) + size (bargaining power)
			TotalPowerToReject = DegCentralityScores(7);
			if SqueezeLogic4Type == 2
				TotalPowerToReject = TotalPowerToReject + RM2(i,14,z);					
			else
				TotalPowerToReject = TotalPowerToReject + AgentSizes(7);					
			end 
			if TotalPowerToReject >= rand                     
				%reject the squeezed offer
				RM2(i,40,z)=RM2(i,22,z);
				S1(i,15,z)=S1(i,15,z)+RM2(i,22,z);	% since exit, therefore applying penalty	
				RM2(i,41,z)=Q(i,z);
				RM2(i,42,z)=1;
			else
				%need to update 24 indexed value with squeezed value
				%this will be used in calculating purchase cost of buyer 				
				RM2(i,24,z)=RM2(i,22,z);				
				%RM2 accept the squeezed price
				RM2(i,6,z)=1;
			end 
		elseif SqueezeLogic == 6 % reject only
			RM2(i,22,z)=RM2(i,18,z)*S1(i,17,z);  %the squeezed (by supplier) one (e.g., indexed by 21) 
			%reject the squeezed offer
			RM2(i,40,z)=RM2(i,22,z);
			S1(i,15,z)=S1(i,15,z)+RM2(i,22,z);	% since exit, therefore applying penalty	
			RM2(i,41,z)=Q(i,z);
			RM2(i,42,z)=1;
		elseif SqueezeLogic == 7 % accept only
			RM2(i,22,z)=RM2(i,18,z)*S1(i,17,z);  %the squeezed (by supplier) one (e.g., indexed by 21) 
			%need to update 24 indexed value with squeezed value
			%this will be used in calculating purchase cost of buyer 				
			RM2(i,24,z)=RM2(i,22,z);				
			%RM2 accept the squeezed price
			RM2(i,6,z)=1;
			RM2(i,53,z)=1;			
		elseif SqueezeLogic == 5 % new squeeze logic 2, 3, & 4 all together
			% updating fixed cost with probability for increasing internal performance always
			r = xmin+rand*(xmax-xmin); % changing from triangular distribution to uniform distribution using given range 
			if TriangularDistEnabled
				r = random(triangolarecosti);     
			end 			
			RM2(i,20,z)=RM2(i,2,z)*r;     %Fcost of RM2 randomly modified (triangular)
			RM2(i,21,z)=Q(i,z)*(RM2(i,18,z)*S1(i,17,z)*(1-RM2(i,5,z))-RM2(i,26,z)); %Fcost of RM2 to reach the target with the squeezed price
			RM2(i,10,z)=1;
			
			%forming maxium last acceptable price to compare with market
			if RM2(i,20,z)<RM2(i,21,z)
				RM2(i,22,z)=RM2(i,18,z)*S1(i,17,z); %the squeezed (by supplier) one (e.g., indexed by 21) 
				RM2(i,25,z)=RM2(i,21,z);
			else
				RM2(i,22,z)=(RM2(i,26,z)+RM2(i,20,z)/Q(i,z))/(1-RM2(i,5,z)); %the compresed (by self) one (e.g., indexed by 20)
				RM2(i,25,z)=RM2(i,20,z);
			end

			%the Buyer compares the budget with the market (SWITCHING COSTS?)
			r = xmin+rand*(xmax-xmin); % changing from triangular distribution to uniform distribution using given range 
			if TriangularDistEnabled
				r = random(triangolareswitch);     
			end 			
			RM2(i,23,z)=RM2(i,18,z)*S1(i,17,z)/r;
			if RM2(i,22,z) > RM2(i,23,z)
				%switching to other supplier
				%the Buyer makes a switch of RM1
				RM2(i,24,z)=RM2(i,23,z); 
				RM2(i,11,z)=1;
				S1(i,15,z)=S1(i,15,z)+SW*RM2(i,18,z)*S1(i,2,z);
			else 
				%need to update 24 indexed value with compresed (self or squeezed) value
				%this will be used in calculating purchase cost of buyer 
				RM2(i,24,z)=RM2(i,22,z); % previously, we have updated RM1(i,22,z) value based on comparing 20,21 indexed values
				
				%the supplier compares compressed cost with squeezed cost of buyer
				if RM2(i,20,z)<RM2(i,21,z)
					% modified compressed cost is less than squeezed cost of buyer - so accept it
					% The buyer stays with the old supplier
				else				
					%position (degree centrality score) + size (bargaining power)
					TotalPowerToReject = DegCentralityScores(7);
					if SqueezeLogic4Type == 2
						TotalPowerToReject = TotalPowerToReject + RM2(i,14,z);					
					else
						TotalPowerToReject = TotalPowerToReject + AgentSizes(7);					
					end 
					if rand > TotalPowerToReject                                                        
						%RM2 adjusts to the market price and lowers its margin
						RM2(i,16,z)=1;
					else
						%reject the squeezed offer
						RM2(i,40,z)=RM2(i,22,z);
						S1(i,15,z)=S1(i,15,z)+RM2(i,22,z);	% since exit, therefore applying penalty	
						RM2(i,41,z)=Q(i,z);
						RM2(i,42,z)=1;
						RM2(i,50,z)=1;
					end
				end		
			end 		
		else %all logics together  
			% updating fixed cost with probability for increasing internal performance always
			RM2(i,20,z)=RM2(i,2,z)*random(triangolarecosti);     %Fcost di RM2 modificati in modo random(triangolare) - Fcost of RM2 randomly modified (triangular)
			RM2(i,21,z)=Q(i,z)*(RM2(i,18,z)*S1(i,17,z)*(1-RM2(i,5,z))-RM2(i,26,z)); %Fcost di RM2 per raggiungere il target con il prezzo squeezed - Fcost of RM2 to reach the target with the squeezed price
			RM2(i,10,z)=1;
			
			%forming maxium last acceptable price to compare with market
			if RM2(i,20,z)<RM2(i,21,z)
				RM2(i,22,z)=RM2(i,18,z)*S1(i,17,z); %the squeezed (by supplier) one (e.g., indexed by 21) 
				RM2(i,25,z)=RM2(i,21,z);
			else
				RM2(i,22,z)=(RM2(i,26,z)+RM2(i,20,z)/Q(i,z))/(1-RM2(i,5,z)); %the compresed (by self) one (e.g., indexed by 20)
				RM2(i,25,z)=RM2(i,20,z);
			end

			%S1 confronta il preventivo con il mercato (COSTI DI SWITCHING?) - the Buyer compares the budget with the market (SWITCHING COSTS?)
			RM2(i,23,z)=RM2(i,18,z)*S1(i,17,z)/random(triangolareswitch);
			if RM2(i,22,z) > RM2(i,23,z)
				%switching to other supplier
				%S1 effettua uno switch di RM2 - the Buyer makes a switch of RM1
				RM2(i,24,z)=RM2(i,23,z); 
				RM2(i,11,z)=1;
				S1(i,15,z)=S1(i,15,z)+SW*RM2(i,18,z)*S1(i,2,z);
			else 
				%need to update 24 indexed value with compresed (self or squeezed) value
				%this will be used in calculating purchase cost of buyer 
				RM2(i,24,z)=RM2(i,22,z); % previously, we have updated RM1(i,22,z) value based on comparing 20,21 indexed values
				
				%the supplier compares compressed cost with squeezed cost of buyer
				if RM2(i,20,z)<RM2(i,21,z)
					% modified compressed cost is less than squeezed cost of buyer - so accept it
					%S1 rimane con il vecchio fornitore - The buyer stays with the old supplier
				else				
					%considero l'effetto del power imbalance - I consider the power imbalance effect
					if rand>RM2(i,14,z)                                                        
						%RM2 si adegua al prezzo di mercato e abbassa il suo margine - RM2 adjusts to the market price and lowers its margin
						RM2(i,16,z)=1;
					else
						%reject the squeezed offer
						RM2(i,40,z)=RM2(i,22,z);
						S1(i,15,z)=S1(i,15,z)+RM2(i,22,z);	% since exit, therefore applying penalty	
						RM2(i,41,z)=Q(i,z);
						RM2(i,42,z)=1;
						%fprintf('S21-S22-RM2: RM2 - Exit of RM2 and Orders= %f\n', Q(i,z));
					end
				end		
			end 		
		end %end of SqueezeLogic		
    end

end
else
    exit=1;
    S21(i,28,z)=1;
    S22(i,28,z)=1;
    RM2(i,28,z)=1;
end