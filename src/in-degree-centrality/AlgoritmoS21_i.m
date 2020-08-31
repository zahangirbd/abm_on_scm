%AlgorithmS21_i
%controllo chi ha effettuato lo squeeze tra i clienti di S21
if S11(i,7,z)==1      %if S11 attempted the S21 squeeze
    
    %I calculate the throttled price of S11 to S21   
    S11(i,17,z)=B(i,17,z)*S11(i,18,z)*(1-S11(i,5,z))-S11(i,25,z)/Q(i,z);
    
    if S11(i,17,z)>0
        %I calculate the profit margin of S21       
        S21(i,29,z)=(S11(i,17,z)-S21(i,2,z)/Q(i,z)-S21(i,3,z))/S11(i,17,z);  %margin that S21 obtains with a choked price of S11
    else
        exit=1;
        S21(i,28,z)= S21(i,28,z) + 1;
    end
else
    S21(i,29,z)=1;
    S11(i,6,z)=1;
end

if S12(i,7,z)==1     %if S12 attempted to squeeze S21
 
	%I calculate the throttled price of S12 to S21    
    S12(i,17,z)=B(i,17,z)*S12(i,18,z)*(1-S12(i,5,z))-S12(i,25,z)/Q(i,z);
    
    if S12(i,17,z)>0        
         %I calculate the profit margin of S21         
         S21(i,30,z)=(S12(i,17,z)-S21(i,2,z)/Q(i,z)-S21(i,3,z))/S12(i,17,z);   %margin that S21 obtains with a choked price of S12        
    else
        exit=1;
        S21(i,28,z)= S21(i,28,z) + 1;
    end
else
    S21(i,30,z)=1;
    S12(i,6,z)=1;
end

%fprintf('S21(29)=%f, S21(30)=%f, S21(5)=%f, \n', S21(i,29,z), S21(i,30,z), S21(i,5,z));

%I check who between S11 and S12 asked for the greatest margin reduction
if S21(i,29,z)<S21(i,30,z)       %if the major reduction comes from S11
    
    if S21(i,29,z)>S21(i,5,z)    %if the price margin of S11 is greater than the target margin
        S21(i,6,z)=1;              
        S11(i,8,z)=1;
        S21(i,31,z)=1;
        S21(i,24,z)=S11(i,17,z);
    else
		%if S21 does not reach its margin
		%adding the learning related stuffs
		A43 = S21(i,43,z);
		if LearningEnabled		
			if LearningTechnique == 1
				[A43, A44, A45, A46] = LearnAndUpdate(AgentConfigs, Psq, PsqVariance, S21, 4, i, z);
				S21(i,43,z) = A43;
				S21(i,44,z) = A44;
				S21(i,45,z) = A45;
				S21(i,46,z) = A46;			
			elseif LearningTechnique == 2
				[A43, A46] = LearnAndUpdateB(AgentConfigs, Psq, PsqVariance, S21, 4, i, z);		
				S21(i,46,z) = A46;		
			elseif LearningTechnique == 3		
				A43 = GetPropensityPrediction(AgentConfigs, Psq, S21, 4, svmclS12, i, z);	
			end			
		end
		
		%if SqueezeLogic is cost reduction only or switching only, then we always tries to squeeze
		%SqueezeLogic is all together then it depends on Psq/A43 here
		if (SqueezeLogic==2 || SqueezeLogic==3 || SqueezeLogic==4 || rand <= A43)	  
			%S21 then attempts the squeeze
			Decision(i,1,z)=1;
			S21(i,7,z) = 1;

			%if learning is enabled, we are saving the current squeezed probability
			if LearningEnabled && (LearningTechnique == 2 || LearningTechnique == 3) 
				S21(i,43,z) = A43;
			end
			
			AlgoritmoRM1_RM2_RM3_RM4_RM5
		
			S21(i,26,z)=RM1(i,24,z)+RM2(i,24,z)+RM3(i,24,z)+RM4(i,24,z)+RM5(i,24,z);    %following the algorithm RM1_RM2_RM3_RM4_RM5 the purchase cost of S21 has changed
			if S21(i,8,z)>0
				S21(i,24,z)=S11(i,17,z);
				S21(i,31,z)=1;
				S11(i,8,z)=1;            %S21 accepts the squeeze of S11 because it has been accepted by RM1 RM2 RM3 RM4 RM5
			else
				S11(i,9,z)=1;              %Since RM1 and / or RM2 and / or RM3 and / or RM4 and / or RM5 did not accept the squeeze also S21 does not accept the squeeze of S11 S12 S13 S14

				if SqueezeLogic == 2 %cost reduction only without switch
					%S21 compresses fixed costs and makes a quote
					S21(i,20,z)=S21(i,2,z)*random(triangolarecosti);    %fixed costs of S21 modified randomly (triangular)
					S21(i,21,z)=Q(i,z)*(S11(i,17,z)*(1-S21(i,5,z))-S21(i,26,z));   %fixed costs of S21 to reach the target with the squeezed price
			
					if S21(i,20,z)<S21(i,21,z)
						S21(i,22,z)=S11(i,17,z);
						S21(i,25,z)=S21(i,21,z);
					else 
						S21(i,22,z)=(S21(i,26,z)+S21(i,20,z)/Q(i,z))/(1-S21(i,5,z));
						S21(i,25,z)=S21(i,20,z);
					end
					%accept it
					%S11 stays with the old supplier
					S21(i,10,z)=1;
					%need to update 24 indexed value with compresed (self or squeezed) value
					%this will be used in calculating purchase cost of buyer 						
					S21(i,24,z)=S21(i,22,z); % previously, we have updated RM1(i,22,z) value based on comparing 20,21 indexed values		   									
				elseif SqueezeLogic == 3 %switching without cost reduction	
					S21(i,22,z)=(S21(i,26,z)+S21(i,2,z)/Q(i,z))/(1-S21(i,5,z)); %the price without cost reduction  
					%S11 compares the quote with the market price
					S21(i,23,z)=S11(i,17,z)/random(triangolareswitch);
					if S21(i,22,z)<S21(i,23,z)     %if quote is lower than market price
						%accept it
						%S11 stays with the old supplier
						S21(i,10,z)=1;
						%need to update 24 indexed value with compresed (self or squeezed) value
						%this will be used in calculating purchase cost of buyer 						
						S21(i,24,z)=S21(i,22,z); % previously, we have updated RM1(i,22,z) value based on comparing 20,21 indexed values		   				
					else
						%S11 makes a switch of S21
						S21(i,24,z)=S21(i,23,z);
						S21(i,11,z)=1;
						S11(i,15,z)=S11(i,15,z)+SW*S11(i,2,z);
					end 
				elseif SqueezeLogic == 4 % position (degree centrality score) and size/bargain power to reject
					S21(i,22,z)=S11(i,17,z);  %the squeezed (by supplier) one (e.g., indexed by 21) 
					%position (degree centrality score) + size (bargaining power)
					TotalPowerToReject = DegCentralityScores(4);
					if SqueezeLogic4Type == 2
						TotalPowerToReject = TotalPowerToReject + S21(i,14,z);					
					else
						TotalPowerToReject = TotalPowerToReject + AgentSizes(4);					
					end 
					if TotalPowerToReject >= rand                      
						%reject the squeezed offer
						S21(i,40,z)=S21(i,22,z);
						S11(i,15,z)=S11(i,15,z)+S21(i,22,z); % since exit, therefore applying penalty
						S21(i,41,z)=Q(i,z);	
						S21(i,42,z)=1;			
						S21(i,50,z)=1;
					else
						%need to update 24 indexed value with squeezed value
						%this will be used in calculating purchase cost of buyer 				
						S21(i,24,z)=S21(i,22,z);				
						%S21 accepts the squeezed price
						S21(i,6,z)=1;
					end 				
				elseif SqueezeLogic == 5 % new squeeze logic 2, 3, & 4 all together
					%S21 compresses fixed costs and makes a quote
					S21(i,20,z)=S21(i,2,z)*random(triangolarecosti);    %fixed costs of S21 modified randomly (triangular)
					S21(i,21,z)=Q(i,z)*(S11(i,17,z)*(1-S21(i,5,z))-S21(i,26,z));   %fixed costs of S21 to reach the target with the squeezed price
					S21(i,10,z)=1;
					if S21(i,20,z)<S21(i,21,z)
						S21(i,22,z)=S11(i,17,z);
						S21(i,25,z)=S21(i,21,z);
					else 
						S21(i,22,z)=(S21(i,26,z)+S21(i,20,z)/Q(i,z))/(1-S21(i,5,z));
						S21(i,25,z)=S21(i,20,z);
					end
					
					%S11 compares the quote with the market price
					S21(i,23,z)=S11(i,17,z)/random(triangolareswitch);
					if S21(i,22,z) > S21(i,23,z)     %if quote is greater than market price
						%S11 makes a switch of S21
						S21(i,24,z)=S21(i,23,z);
						S21(i,11,z)=1;
						S11(i,15,z)=S11(i,15,z)+SW*S11(i,2,z);				
					else				
						%S11 stays with the old supplier			   
						%need to update 24 indexed value with compresed (self or squeezed) value
						%this will be used in calculating purchase cost of buyer 						
						S21(i,24,z)=S21(i,22,z); % previously, we have updated S21(i,22,z) value based on comparing 20,21 indexed values

						%the supplier compares compressed cost with squeezed cost of buyer
						if S21(i,20,z)<S21(i,21,z)
							%modified compressed cost is less than squeezed cost of buyer - so accept it
							%S11 stays with the old supplier
						else
							%S11 stays with the old supplier based on bargaining power
							%position (degree centrality score) + size (bargaining power)
							TotalPowerToReject = DegCentralityScores(4);
							if SqueezeLogic4Type == 2
								TotalPowerToReject = TotalPowerToReject + S21(i,14,z);					
							else
								TotalPowerToReject = TotalPowerToReject + AgentSizes(4);					
							end 
							if rand > TotalPowerToReject     %I value bargaining power
								%S21 adjusts to the market price and lowers its margin
								S21(i,16,z)=1;
							else 
								%reject the squeezed offer
								S21(i,40,z)=S21(i,22,z);
								S21(i,15,z)=S21(i,15,z)+S21(i,22,z); % since exit, therefore applying penalty
								S21(i,41,z)=Q(i,z);	
								S21(i,42,z)=1;	
								S21(i,50,z)=1;					 	
							end				
						end 
					end
				else %all previous logics together 
					%S21 compresses fixed costs and makes a quote
					S21(i,20,z)=S21(i,2,z)*random(triangolarecosti);    %fixed costs of S21 modified randomly (triangular)
					S21(i,21,z)=Q(i,z)*(S11(i,17,z)*(1-S21(i,5,z))-S21(i,26,z));   %fixed costs of S21 to reach the target with the squeezed price
					S21(i,10,z)=1;
					if S21(i,20,z)<S21(i,21,z)
						S21(i,22,z)=S11(i,17,z);
						S21(i,25,z)=S21(i,21,z);
					else 
						S21(i,22,z)=(S21(i,26,z)+S21(i,20,z)/Q(i,z))/(1-S21(i,5,z));
						S21(i,25,z)=S21(i,20,z);
					end
					
					%S11 compares the quote with the market price
					S21(i,23,z)=S11(i,17,z)/random(triangolareswitch);
					if S21(i,22,z) > S21(i,23,z)     %if quote is greater than market price
						%S11 makes a switch of S21
						S21(i,24,z)=S21(i,23,z);
						S21(i,11,z)=1;
						S11(i,15,z)=S11(i,15,z)+SW*S11(i,2,z);				
					else				
						%S11 stays with the old supplier			   
						%need to update 24 indexed value with compresed (self or squeezed) value
						%this will be used in calculating purchase cost of buyer 						
						S21(i,24,z)=S21(i,22,z); % previously, we have updated S21(i,22,z) value based on comparing 20,21 indexed values

						%the supplier compares compressed cost with squeezed cost of buyer
						if S21(i,20,z)<S21(i,21,z)
							%modified compressed cost is less than squeezed cost of buyer - so accept it
							%S11 stays with the old supplier
						else
							%S11 stays with the old supplier based on bargaining power
							if rand>S21(i,14,z)     %I value bargaining power
								%S21 adjusts to the market price and lowers its margin
								S21(i,16,z)=1;
							else 
								%reject the squeezed offer
								S21(i,40,z)=S21(i,22,z);
								S21(i,15,z)=S21(i,15,z)+S21(i,22,z); % since exit, therefore applying penalty
								S21(i,41,z)=Q(i,z);	
								S21(i,42,z)=1;					
							end				
						end 
					end
				end 	
			end
		else
			%S21 accepts despite the target margin is not reached
			S21(i,6,z)=1;              
			S11(i,8,z)=1;
			S21(i,31,z)=1;
			S21(i,24,z)=S11(i,17,z);
			S21(i,49,z)=1; %holding the current profit accepted without squeezing
		end 
	end
else         %otherwise if the heaviest squeeze comes from S12
    
    if S21(i,30,z)>S21(i,5,z)       %if the price margin of S12 is greater than the target margin
        S21(i,6,z)=1;                %S21 accepts and does not squeeze in turn
        S12(i,8,z)=1;
        S21(i,31,z)=1;
        S21(i,24,z)=S12(i,17,z);
    else
		%if S21 does not reach its margin
		%adding the learning related stuffs
		A43 = S21(i,43,z);
		if LearningEnabled		
			if LearningTechnique == 1
				[A43, A44, A45, A46] = LearnAndUpdate(AgentConfigs, Psq, PsqVariance, S21, 4, i, z);
				S21(i,43,z) = A43;
				S21(i,44,z) = A44;
				S21(i,45,z) = A45;
				S21(i,46,z) = A46;			
			elseif LearningTechnique == 2
				[A43, A46] = LearnAndUpdateB(AgentConfigs, Psq, PsqVariance, S21, 4, i, z);		
				S21(i,46,z) = A46;		
			elseif LearningTechnique == 3		
				A43 = GetPropensityPrediction(AgentConfigs, Psq, S21, 4, svmclS12, i, z);	
			end			
		end
		
		%if SqueezeLogic is cost reduction only or switching only, then we always tries to squeeze
		%SqueezeLogic is all together then it depends on Psq/A43 here
		if (SqueezeLogic==2 || SqueezeLogic==3 || SqueezeLogic==4 || rand <= A43)	  
			%S21 then attempts the squeeze
			Decision(i,1,z)=2;
			S21(i,7,z) = 1;

			%if learning is enabled, we are saving the current squeezed probability
			if LearningEnabled && (LearningTechnique == 2 || LearningTechnique == 3) 
				S21(i,43,z) = A43;
			end
			
			AlgoritmoRM1_RM2_RM3_RM4_RM5
			
			S21(i,26,z)=RM1(i,24,z)+RM2(i,24,z)+RM3(i,24,z)+RM4(i,24,z)+RM5(i,24,z);    %following the algorithm RM1_RM2_RM3_RM4_RM5 the purchase cost of S21 has changed
			if S21(i,8,z)>0
				S21(i,24,z)=S12(i,17,z);
				S21(i,31,z)=1;
				S12(i,8,z)=1;             %S21 accepts the S12 squeeze because it has been accepted by RM1 RM2 RM3 RM4 RM5
			else
				S12(i,9,z)=1;

				if SqueezeLogic == 2 %cost reduction only without switch
					%S21 compresses fixed costs and makes a quote
					S21(i,20,z)=S21(i,2,z)*random(triangolarecosti);    %fixed costs of S21 modified randomly (triangular)
					S21(i,21,z)=Q(i,z)*(S12(i,17,z)*(1-S21(i,5,z))-S21(i,26,z));   %fixed costs of S21 to reach the target with the squeezed price
					
					if S21(i,20,z)<S21(i,21,z)
						S21(i,22,z)=S12(i,17,z);
						S21(i,25,z)=S21(i,21,z);
					else
						S21(i,22,z)=(S21(i,26,z)+S21(i,20,z)/Q(i,z))/(1-S21(i,5,z));
						S21(i,25,z)=S21(i,20,z);
					end
					%accept it	
					%S12 stays with the old supplier
					S21(i,10,z)=1;									
					%need to update 24 indexed value with compresed (self or squeezed) value
					%this will be used in calculating purchase cost of buyer 		
					S21(i,24,z)=S21(i,22,z); % previously, we have updated RM1(i,22,z) value based on comparing 20,21 indexed values						
				elseif SqueezeLogic == 3 %switching without cost reduction	
					 S21(i,22,z)=(S21(i,26,z)+S21(i,2,z)/Q(i,z))/(1-S21(i,5,z)); %the price without cost reduction  
					 %S12 compares the quote with the market price
					 S21(i,23,z)=S12(i,17,z)/random(triangolareswitch);
					 if S21(i,22,z)<S21(i,23,z)   %if quote is lower than market price
						%accept it	
						%S12 stays with the old supplier
						S21(i,10,z)=1;									
						%need to update 24 indexed value with compresed (self or squeezed) value
						%this will be used in calculating purchase cost of buyer 		
						S21(i,24,z)=S21(i,22,z); % previously, we have updated S21(i,22,z) value based on comparing 20,21 indexed values	
					 else
						 %S12 makes a switch of S21	
						 S21(i,24,z)=S21(i,23,z);
						 S21(i,11,z)=1;
						 S12(i,15,z)=S12(i,15,z)+SW*S12(i,2,z);
					 end 					
				elseif SqueezeLogic == 4 % position (degree centrality score) and size/bargain power to reject
					S21(i,22,z)=S12(i,17,z);  %the squeezed (by supplier) one (e.g., indexed by 21) 
					%position (degree centrality score) + size (bargaining power)
					TotalPowerToReject = DegCentralityScores(4);
					if SqueezeLogic4Type == 2
						TotalPowerToReject = TotalPowerToReject + S21(i,14,z);					
					else
						TotalPowerToReject = TotalPowerToReject + AgentSizes(4);					
					end 
					if TotalPowerToReject >= rand                      
						%reject the squeezed offer
						S21(i,40,z)=S21(i,22,z);
						S12(i,15,z)=S12(i,15,z)+S21(i,22,z); % since exit, therefore applying penalty
						S21(i,41,z)=Q(i,z);	
						S21(i,42,z)=1;			
						S21(i,50,z)=1;
					else
						%need to update 24 indexed value with squeezed value
						%this will be used in calculating purchase cost of buyer 				
						S21(i,24,z)=S21(i,22,z);				
						%S21 accepts the squeezed price
						S21(i,6,z)=1;
					end 							
				elseif SqueezeLogic == 5 % new squeeze logic 2, 3, & 4 all together
					%S21 compresses fixed costs and makes a quote
					S21(i,20,z)=S21(i,2,z)*random(triangolarecosti);    %fixed costs of S21 modified randomly (triangular)
					S21(i,21,z)=Q(i,z)*(S12(i,17,z)*(1-S21(i,5,z))-S21(i,26,z));   %fixed costs of S21 to reach the target with the squeezed price
					S21(i,10,z)=1;
					if S21(i,20,z)<S21(i,21,z)
						S21(i,22,z)=S12(i,17,z);
						S21(i,25,z)=S21(i,21,z);
					else
						S21(i,22,z)=(S21(i,26,z)+S21(i,20,z)/Q(i,z))/(1-S21(i,5,z));
						S21(i,25,z)=S21(i,20,z);
					end
					
					 %S12 compares the quote with the market price
					 S21(i,23,z)=S12(i,17,z)/random(triangolareswitch);
					 if S21(i,22,z) > S21(i,23,z)   %if quote is greater than market price
						 %S12 makes a switch of S21
						 S21(i,24,z)=S21(i,23,z);
						 S21(i,11,z)=1;
						 S12(i,15,z)=S12(i,15,z)+SW*S12(i,2,z); 
					 else
						 %S12 stays with the old supplier					                   
						 %need to update 24 indexed value with compresed (self or squeezed) value
						 %this will be used in calculating purchase cost of buyer 						
						 S21(i,24,z)=S21(i,22,z);	% previously, we have updated S21(i,22,z) value based on comparing 20,21 indexed values

						 %the supplier compares compressed cost with squeezed cost of buyer
						 if S21(i,20,z)<S21(i,21,z)
							%modified compressed cost is less than squeezed cost of buyer - so accept it
							%S12 stays with the old supplier	
						 else
							 %S12 stays with the old supplier based on bargaining power 	
							 %position (degree centrality score) + size (bargaining power)
							 TotalPowerToReject = DegCentralityScores(4);
							 if SqueezeLogic4Type == 2
								TotalPowerToReject = TotalPowerToReject + S21(i,14,z);					
							 else
								TotalPowerToReject = TotalPowerToReject + AgentSizes(4);					
							 end 
							 if rand > TotalPowerToReject    %I value bargaining power
								%S21 adjusts to the market price and lowers its margin
								S21(i,16,z)=1;
							 else   
								%reject the squeezed offer
								S21(i,40,z)=S21(i,22,z);
								S12(i,15,z)=S12(i,15,z)+S21(i,22,z); % since exit, therefore applying penalty
								S21(i,41,z)=Q(i,z);	
								S21(i,42,z)=1;
								S21(i,50,z)=1;									
							 end					 
						 end 
					 end
				else %all previous logics together 
					%S21 compresses fixed costs and makes a quote
					S21(i,20,z)=S21(i,2,z)*random(triangolarecosti);    %fixed costs of S21 modified randomly (triangular)
					S21(i,21,z)=Q(i,z)*(S12(i,17,z)*(1-S21(i,5,z))-S21(i,26,z));   %fixed costs of S21 to reach the target with the squeezed price
					S21(i,10,z)=1;
					if S21(i,20,z)<S21(i,21,z)
						S21(i,22,z)=S12(i,17,z);
						S21(i,25,z)=S21(i,21,z);
					else
						S21(i,22,z)=(S21(i,26,z)+S21(i,20,z)/Q(i,z))/(1-S21(i,5,z));
						S21(i,25,z)=S21(i,20,z);
					end
					
					 %S12 compares the quote with the market price
					 S21(i,23,z)=S12(i,17,z)/random(triangolareswitch);
					 if S21(i,22,z) > S21(i,23,z)   %if quote is greater than market price
						 %S12 makes a switch of S21
						 S21(i,24,z)=S21(i,23,z);
						 S21(i,11,z)=1;
						 S12(i,15,z)=S12(i,15,z)+SW*S12(i,2,z); 
					 else
						 %S12 stays with the old supplier					                   
						 %need to update 24 indexed value with compresed (self or squeezed) value
						 %this will be used in calculating purchase cost of buyer 						
						 S21(i,24,z)=S21(i,22,z);	% previously, we have updated S21(i,22,z) value based on comparing 20,21 indexed values

						 %the supplier compares compressed cost with squeezed cost of buyer
						 if S21(i,20,z)<S21(i,21,z)
							%modified compressed cost is less than squeezed cost of buyer - so accept it
							%S12 stays with the old supplier	
						 else
							 %S12 stays with the old supplier based on bargaining power 	
							 if rand>S21(i,14,z)    %I value bargaining power
								%S21 adjusts to the market price and lowers its margin
								S21(i,16,z)=1;
							 else   
								%reject the squeezed offer
								S21(i,40,z)=S21(i,22,z);
								S12(i,15,z)=S12(i,15,z)+S21(i,22,z); % since exit, therefore applying penalty
								S21(i,41,z)=Q(i,z);	
								S21(i,42,z)=1;						 
							 end					 
						 end 
					 end
				end 	
			end
		else
			%S21 accepts despite the target margin is not reached
			S21(i,6,z)=1;                
			S12(i,8,z)=1;
			S21(i,31,z)=1;
			S21(i,24,z)=S12(i,17,z);
			S21(i,49,z)=1; %holding the current profit accepted without squeezing
		end         
    end
end
                        
                         
                     
                
            
        
            
        
        
    
        
    
    
    
        
        
         
        
    
    
    
        
    
    