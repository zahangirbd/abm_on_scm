%AlgorithmS21_o
%control who squeezed between S21 customers
if S11(i,7,z)==1      %if S11 attempted the S21 squeeze
    %I calculate the throttled price of S11 to S21
    S11(i,17,z)=B(i,17,z)*S11(i,18,z)*(1-S11(i,5,z))-S11(i,25,z)/Q(i,z);
    
    if S11(i,17,z)>0
        %I calculate the profit margin of S21
        S21(i,29,z)=(S11(i,17,z)-S21(i,2,z)/Q(i,z)-S21(i,3,z))/S11(i,17,z);    %margin that S21 obtains with a choked price of S11
    else
        exit=1;
        S21(i,28,z)=1;
    end
else
    S21(i,29,z)=1;
    S11(i,6,z)=1;
end

if S12(i,7,z)==1;    %if S12 attempted to squeeze S21
    %I calculate the throttled price of S12 to S21
    S12(i,17,z)=B(i,17,z)*S12(i,18,z)*(1-S12(i,5,z))-S12(i,25,z)/Q(i,z);
    
    if S12(i,17,z)>0 
        %I calculate the profit margin of S21
        S21(i,30,z)=(S12(i,17,z)-S21(i,2,z)/Q(i,z)-S21(i,3,z))/S12(i,17,z);    %margin that S21 obtains with a choked price of S12
    else
        exit=1;
        S21(i,28,z)=1;
    end
else
    S21(i,30,z)=1;
    S12(i,6,z)=1;
end

if S13(i,7,z)==1     %if S13 attempted the squeeze of S21
    %I calculate the throttled price of S13 to S21    
    S13(i,17,z)=B(i,17,z)*S13(i,18,z)*(1-S13(i,5,z))-S13(i,25,z)/Q(i,z);
    
    if S13(i,17,z)>0
        %I calculate the profit margin of S21
        S21(i,31,z)=(S13(i,17,z)-S21(i,2,z)/Q(i,z)-S21(i,3,z))/S13(i,17,z);   %margin that S21 obtains with a choked price of S13
    else
        exit=1;
        S21(i,28,z)=1;
    end
else
    S21(i,31,z)=1;
    S13(i,6,z)=1;
end

if S14(i,7,z)==1    %if S14 attempted the squeeze of S21
    %I calculate the throttled price of S14 to S21
    S14(i,17,z)=B(i,17,z)*S14(i,18,z)*(1-S14(i,5,z))-S14(i,25,z)/Q(i,z);
    
    if S14(i,17,z)>0
        %I calculate the profit margin of S21
        S21(i,32,z)=(S14(i,17,z)-S21(i,2,z)/Q(i,z)-S21(i,3,z))/S14(i,17,z);   %margin that S21 obtains with a choked price of S14
    else
        exit=1;
        S21(i,28,z)=1;
    end
else
    S21(i,32,z)=1;
    S14(i,6,z)=1;
end

if S15(i,7,z)==1    %if S15 has attempted the S21 squeeze
    %I calculate the throttled price of S15 to S21
    S15(i,17,z)=B(i,17,z)*S15(i,18,z)*(1-S15(i,5,z))-S15(i,25,z)/Q(i,z);
    
    if S15(i,17,z)>0
        %I calculate the profit margin of S21
        S21(i,33,z)=(S15(i,17,z)-S21(i,2,z)/Q(i,z)-S21(i,3,z))/S15(i,17,z);   %margin that S21 obtains with a choked price of S15
    else
        exit=1;
        S21(i,28,z)=1;
    end
else
    S21(i,33,z)=1;
    S15(i,6,z)=1;
end

%I check who among S11 S12 S13 S14 S15 has asked for the greatest reduction in margins 

if S21(i,29,z)<=S21(i,30,z) & S21(i,29,z)<=S21(i,31,z) & S21(i,29,z)<=S21(i,32,z) & S21(i,29,z)<=S21(i,33,z) %& S21(i,29,z)<=S21(i,34,z)
    %if the major reduction comes from S11
    if S21(i,29,z)>S21(i,5,z)        %if the price margin of S11 is greater than the target margin
        S21(i,6,z)=1;
        S11(i,8,z)=1;
        S21(i,35,z)=1;
        S21(i,24,z)=S11(i,17,z);
    else
		  %apply learning for propensity to squeeze
		  A43 = S21(i,43,z);
		  if LearningEnabled
			if LearningTechnique == 1
				[A43, A44, A45, A46]=LearnAndUpdate(AgentConfigs, Psq, PsqVariance, S21, 8, i, z);
				S21(i,43,z) = A43;
				S21(i,44,z) = A44;
				S21(i,45,z) = A45;
				S21(i,46,z) = A46;			
			elseif LearningTechnique == 2
				[A43, A46] = LearnAndUpdateB(AgentConfigs, Psq, PsqVariance, S21, 8, i, z);
				S21(i,46,z) = A46;
			elseif LearningTechnique == 3		
				A43 = GetPropensityPrediction(AgentConfigs, Psq, S21, 8, svmclS21, i, z);	
			end					
		  end

		  %just holding the purchase cost before squeeze or not - used of debugging purpose
		  S21(i,48,z)=S21(i,26,z);

		  if (SqueezeLogic==2 || SqueezeLogic==3 || SqueezeLogic==4 || rand <= A43)
			
			%if learning is enabled, we are saving the current squeezed probability
			if LearningEnabled && (LearningTechnique == 2 || LearningTechnique == 3) 
				S21(i,43,z) = A43;
			end
			
			S21(i,7,z) = 1;
			Decision(i,1,z)=1;
			
			AlgoritmoRM1_RM2_o
			
			S21(i,26,z)=RM1(i,24,z)+RM2(i,24,z);     %following the Algorithm RM1_RM2_o the purchase cost of S21 has changed
			if S21(i,8,z)>0 
				S21(i,24,z)=S11(i,17,z);
				S21(i,35,z)=1;
				S11(i,8,z)=1;          %S21 accepts the squeeze of S11 because it has been accepted by RM1 RM2
			else
				S11(i,9,z)=1;       %Since RM1 and / or RM2 did not accept the squeeze also S21 does not accept the squeeze of S11 S12 S13 S14
				if SqueezeLogic == 2 %cost reduction only without switch
					%S21 saves costs and quotes
					S21(i,20,z)=S21(i,2,z)*random(triangolarecosti);
					S21(i,21,z)=Q(i,z)*(S11(i,17,z)*(1-S21(i,5,z))-S21(i,26,z));
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
					S21(i,24,z)=S21(i,22,z); % previously, we have updated S21(i,22,z) value based on comparing 20,21 indexed values   					
				elseif SqueezeLogic == 3 %switching without cost reduction	
					S21(i,22,z)=(S21(i,26,z)+S21(i,2,z)/Q(i,z))/(1-S21(i,5,z)); %the price without cost reduction
					%S11 compares the quote with the market price
					S21(i,23,z)=S11(i,17,z)/random(triangolareswitch);					
					if S21(i,22,z)<=S21(i,23,z)    %if quote is lower than market price
						%accept it
						%S11 stays with the old supplier
						S21(i,10,z)=1;
						%need to update 24 indexed value with compresed (self or squeezed) value
						%this will be used in calculating purchase cost of buyer 															
						S21(i,24,z)=S21(i,22,z); % previously, we have updated S21(i,22,z) value based on comparing 20,21 indexed values   
					else
						%S11 makes a switch of S21
						S21(i,24,z)=S21(i,23,z);
						S21(i,11,z)=1;
						S11(i,15,z)=S11(i,15,z)+SW*S11(i,2,z);
					end 				
				elseif SqueezeLogic == 4 % position (degree centrality score) and size/bargain power to reject
					S21(i,23,z)=S11(i,17,z);
					%position (degree centrality score) + size (bargaining power)
					TotalPowerToReject = DegCentralityScores(7);
					if SqueezeLogic4Type == 2
						TotalPowerToReject = TotalPowerToReject + S21(i,14,z);					
					else
						TotalPowerToReject = TotalPowerToReject + AgentSizes(7);					
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
						S21(i,24,z)=S21(i,22,z); % previously, we have updated S21(i,22,z) value based on comparing 20,21 indexed values   
						%S21 accepts the squeezed price
						S21(i,6,z)=1;						
					end	
				elseif SqueezeLogic == 5 % new squeeze logic 2, 3, & 4 all together
					%S21 saves costs and quotes
					S21(i,20,z)=S21(i,2,z)*random(triangolarecosti);
					S21(i,21,z)=Q(i,z)*(S11(i,17,z)*(1-S21(i,5,z))-S21(i,26,z));
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
					if S21(i,22,z)>S21(i,23,z)    %if quote is greater than market price
						%S11 makes a switch of S21
						S21(i,24,z)=S21(i,23,z);
						S21(i,11,z)=1;
						S11(i,15,z)=S11(i,15,z)+SW*S11(i,2,z);
					else
						%need to update 24 indexed value with compresed (self or squeezed) value
						%this will be used in calculating purchase cost of buyer 									
						S21(i,24,z)=S21(i,22,z);   
						%the supplier compares compressed cost with squeezed cost of buyer
						if S21(i,20,z)<S21(i,21,z)
							% modified compressed cost is less than squeezed cost of buyer - so accept it
							% S11 stays with the old supplier
						else	
							%position (degree centrality score) + size (bargaining power)
							TotalPowerToReject = DegCentralityScores(7);
							if SqueezeLogic4Type == 2
								TotalPowerToReject = TotalPowerToReject + S21(i,14,z);					
							else
								TotalPowerToReject = TotalPowerToReject + AgentSizes(7);					
							end 
							if rand > TotalPowerToReject    %I value bargaining power
								%S21 adjusts to the market price and lowers its margin
								S21(i,16,z)=1;
							else
								%reject the squeezed offer
								S21(i,40,z)=S21(i,22,z);
								S11(i,15,z)=S11(i,15,z)+S21(i,22,z); % since exit, therefore applying penalty
								S21(i,41,z)=Q(i,z);			
								S21(i,42,z)=1;
								S21(i,50,z)=1;										
							end						
						end 
					end
				else %all previous logics together 				
					%S21 saves costs and quotes
					S21(i,20,z)=S21(i,2,z)*random(triangolarecosti);
					S21(i,21,z)=Q(i,z)*(S11(i,17,z)*(1-S21(i,5,z))-S21(i,26,z));
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
					if S21(i,22,z)>S21(i,23,z)    %if quote is greater than market price
						%S11 makes a switch of S21
						S21(i,24,z)=S21(i,23,z);
						S21(i,11,z)=1;
						S11(i,15,z)=S11(i,15,z)+SW*S11(i,2,z);
					else
						%need to update 24 indexed value with compresed (self or squeezed) value
						%this will be used in calculating purchase cost of buyer 									
						S21(i,24,z)=S21(i,22,z);   
						%the supplier compares compressed cost with squeezed cost of buyer
						if S21(i,20,z)<S21(i,21,z)
							% modified compressed cost is less than squeezed cost of buyer - so accept it
							% S11 stays with the old supplier
						else	
							if rand>S21(i,14,z)    %I value bargaining power
								%S21 adjusts to the market price and lowers its margin
								S21(i,16,z)=1;
							else
								%reject the squeezed offer
								S21(i,40,z)=S21(i,22,z);
								S11(i,15,z)=S11(i,15,z)+S21(i,22,z); % since exit, therefore applying penalty
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
			S21(i,35,z)=1;
			S21(i,24,z)=S11(i,17,z);			
			S21(i,49,z)=1; %holding the current profit accepted without squeezing
		  end 
	end
else
    if S21(i,30,z)<=S21(i,29,z) & S21(i,30,z)<=S21(i,31,z) & S21(i,30,z)<=S21(i,32,z) & S21(i,30,z)<=S21(i,33,z) & S21(i,30,z)<=S21(i,34,z)
        %if the major reduction comes from S12
        if S21(i,30,z)>S21(i,5,z)
            S21(i,6,z)=1;
            S12(i,8,z)=1;
            S21(i,35,z)=1;
            S21(i,24,z)=S12(i,17,z);
        else
			%apply learning for propensity to squeeze
			A43 = S21(i,43,z);
			if LearningEnabled
				if LearningTechnique == 1
					[A43, A44, A45, A46]=LearnAndUpdate(AgentConfigs, Psq, PsqVariance, S21, 8, i, z);
					S21(i,43,z) = A43;
					S21(i,44,z) = A44;
					S21(i,45,z) = A45;
					S21(i,46,z) = A46;			
				elseif LearningTechnique == 2
					[A43, A46] = LearnAndUpdateB(AgentConfigs, Psq, PsqVariance, S21, 8, i, z);
					S21(i,46,z) = A46;
				elseif LearningTechnique == 3		
					A43 = GetPropensityPrediction(AgentConfigs, Psq, S21, 8, svmclS21, i, z);	
				end					
			  end

			%just holding the purchase cost before squeeze or not - used of debugging purpose
			S21(i,48,z)=S21(i,26,z);

			if (SqueezeLogic==2 || SqueezeLogic==3 || SqueezeLogic==4 || rand <= A43)	
				%if learning is enabled, we are saving the current squeezed probability
				if LearningEnabled && (LearningTechnique == 2 || LearningTechnique == 3) 
					S21(i,43,z) = A43;
				end

				S21(i,7,z) = 1;
				Decision(i,1,z)=2;
				
				AlgoritmoRM1_RM2_o
			
				S21(i,26,z)=RM1(i,24,z)+RM2(i,24,z);     %following the AlgoritmoRM1_RM2_o the purchase cost of S21 has changed
				if S21(i,8,z)>0
					S21(i,24,z)=S12(i,17,z);
					S21(i,35,z)=1;
					S12(i,8,z)=1;       %S21 accepts the squeeze of S12 because it has been accepted by RM1 RM2
				else 
					S12(i,9,z)=1;
					
					if SqueezeLogic == 2 %cost reduction only without switch
						%S21 compresses fixed costs and quotes
						S21(i,20,z)=S21(i,2,z)*random(triangolarecosti);    %fixed costs reduced randomly
						S21(i,21,z)=Q(i,z)*(S12(i,17,z)*(1-S21(i,5,z))-S21(i,26,z));   %reduced fixed costs guarantee price and margin
						if S21(i,20,z)<S21(i,21,z)
							S21(i,22,z)=S12(i,17,z);
							S21(i,25,z)=S21(i,21,z);
						else
							S21(i,22,z)=(S21(i,26,z)+S21(i,20,z)/Q(i,z))/(1-S21(i,5,z));
							S21(i,25,z)=S21(i,20,z);
						end
						%accept it
						S21(i,10,z)=1;
						%need to update 24 indexed value with compresed (self or squeezed) value
						%this will be used in calculating purchase cost of buyer 															
						S21(i,24,z)=S21(i,22,z);	% previously, we have updated S21(i,22,z) value based on comparing 20,21 indexed values							
					elseif SqueezeLogic == 3 %switching without cost reduction	
						S21(i,22,z)=(S21(i,26,z)+S21(i,2,z)/Q(i,z))/(1-S21(i,5,z));
						%S12 compares the quote with the market price
						S21(i,23,z)=S12(i,17,z)/random(triangolareswitch);
						if S21(i,22,z) <= S21(i,23,z)
							%accept it
							S21(i,10,z)=1;
							%need to update 24 indexed value with compresed (self or squeezed) value
							%this will be used in calculating purchase cost of buyer 																
							S21(i,24,z)=S21(i,22,z);	% previously, we have updated S21(i,22,z) value based on comparing 20,21 indexed values
						else
							%S12 makes a switch of S21
							S21(i,24,z)=S21(i,23,z); 
							S21(i,11,z)=1;
							S12(i,15,z)=S12(i,15,z)+SW*S12(i,2,z);						
						end																
					elseif SqueezeLogic == 4 % position (degree centrality score) and size/bargain power to reject
						S21(i,22,z)=S12(i,17,z);
						%position (degree centrality score) + size (bargaining power)
						TotalPowerToReject = DegCentralityScores(7);
						if SqueezeLogic4Type == 2
							TotalPowerToReject = TotalPowerToReject + S21(i,14,z);					
						else
							TotalPowerToReject = TotalPowerToReject + AgentSizes(7);					
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
						%S21 compresses fixed costs and quotes
						S21(i,20,z)=S21(i,2,z)*random(triangolarecosti);    %fixed costs reduced randomly
						S21(i,21,z)=Q(i,z)*(S12(i,17,z)*(1-S21(i,5,z))-S21(i,26,z));   %reduced fixed costs guarantee price and margin
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
						if S21(i,22,z) > S21(i,23,z)    %if quote is greater than market price
							%S12 makes a switch of S21
							S21(i,24,z)=S21(i,23,z);
							S21(i,11,z)=1;
							S12(i,15,z)=S12(i,15,z)+SW*S12(i,2,z);
						else 
							%need to update 24 indexed value with compresed (self or squeezed) value
							%this will be used in calculating purchase cost of buyer 				
							S21(i,24,z)=S21(i,22,z);	% previously, we have updated S21(i,22,z) value based on comparing 20,21 indexed values
							%the supplier compares compressed cost with squeezed cost of buyer
							if S21(i,20,z)<S21(i,21,z)
								% modified compressed cost is less than squeezed cost of buyer - so accept it
								% S12 remains with old supplier		
							else						
								%position (degree centrality score) + size (bargaining power)
								TotalPowerToReject = DegCentralityScores(7);
								if SqueezeLogic4Type == 2
									TotalPowerToReject = TotalPowerToReject + S21(i,14,z);					
								else
									TotalPowerToReject = TotalPowerToReject + AgentSizes(7);					
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
						%S21 compresses fixed costs and quotes
						S21(i,20,z)=S21(i,2,z)*random(triangolarecosti);    %fixed costs reduced randomly
						S21(i,21,z)=Q(i,z)*(S12(i,17,z)*(1-S21(i,5,z))-S21(i,26,z));   %reduced fixed costs guarantee price and margin
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
						if S21(i,22,z) > S21(i,23,z)    %if quote is greater than market price
							%S12 makes a switch of S21
							S21(i,24,z)=S21(i,23,z);
							S21(i,11,z)=1;
							S12(i,15,z)=S12(i,15,z)+SW*S12(i,2,z);
						else 
							%need to update 24 indexed value with compresed (self or squeezed) value
							%this will be used in calculating purchase cost of buyer 				
							S21(i,24,z)=S21(i,22,z);	% previously, we have updated S21(i,22,z) value based on comparing 20,21 indexed values
							%the supplier compares compressed cost with squeezed cost of buyer
							if S21(i,20,z)<S21(i,21,z)
								% modified compressed cost is less than squeezed cost of buyer - so accept it
								% S12 remains with old supplier		
							else						
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
				S21(i,35,z)=1;
				S21(i,24,z)=S12(i,17,z);			
				S21(i,49,z)=1; %holding the current profit accepted without squeezing
			end	
		end
	else
        if S21(i,31,z)<=S21(i,29,z) & S21(i,31,z)<=S21(i,30,z) & S21(i,31,z)<=S21(i,32,z) & S21(i,31,z)<=S21(i,33,z) & S21(i,31,z)<=S21(i,34,z)
            %se la riduzione maggiore proviene da S13
            if S21(i,31,z)>S21(i,5,z)
                S21(i,6,z)=1;
                S13(i,8,z)=1;
                S21(i,35,z)=1;
                S21(i,24,z)=S13(i,17,z);
            else
				%apply learning for propensity to squeeze
				A43 = S21(i,43,z);
				if LearningEnabled
					if LearningTechnique == 1
						[A43, A44, A45, A46]=LearnAndUpdate(AgentConfigs, Psq, PsqVariance, S21, 8, i, z);
						S21(i,43,z) = A43;
						S21(i,44,z) = A44;
						S21(i,45,z) = A45;
						S21(i,46,z) = A46;			
					elseif LearningTechnique == 2
						[A43, A46] = LearnAndUpdateB(AgentConfigs, Psq, PsqVariance, S21, 8, i, z);
						S21(i,46,z) = A46;
					elseif LearningTechnique == 3		
						A43 = GetPropensityPrediction(AgentConfigs, Psq, S21, 8, svmclS21, i, z);	
					end					
				end

				%just holding the purchase cost before squeeze or not - used of debugging purpose
				S21(i,48,z)=S21(i,26,z);

				if (SqueezeLogic==2 || SqueezeLogic==3 || SqueezeLogic==4 || rand <= A43)	
					%if learning is enabled, we are saving the current squeezed probability
					if LearningEnabled && (LearningTechnique == 2 || LearningTechnique == 3) 
						S21(i,43,z) = A43;
					end

					S21(i,7,z) = 1;
					Decision(i,1,z)=3;
					
					AlgoritmoRM1_RM2_o
					
					S21(i,26,z)=RM1(i,24,z)+RM2(i,24,z);       %in seguito all'AlgoritmoRM1_RM2_o è cambiato il costo d'acquisto di S21
					if S21(i,8,z)>0
						S21(i,24,z)=S13(i,17,z);
						S21(i,35,z)=1;
						S13(i,8,z)=1;       %S21 accetta lo squeeze di S13 perchè è stato accettato da RM1 RM2
					else
						S13(i,9,z)=1;
						if SqueezeLogic == 2 %cost reduction only without switch
							%S21 compresses fixed costs and quotes
							S21(i,20,z)=S21(i,2,z)*random(triangolarecosti);
							S21(i,21,z)=Q(i,z)*(S13(i,17,z)*(1-S21(i,5,z))-S21(i,26,z));
							if S21(i,20,z)<S21(i,21,z)
								S21(i,22,z)=S13(i,17,z);
								S21(i,25,z)=S21(i,21,z);
							else
								S21(i,22,z)=(S21(i,26,z)+S21(i,20,z)/Q(i,z))/(1-S21(i,5,z));
								S21(i,25,z)=S21(i,20,z);
							end

							 %S13 compares the quote with the market price
							 S21(i,23,z)=S13(i,17,z)/random(triangolareswitch);							 
							 if S21(i,22,z)<=S21(i,23,z)          %if quote is less than market price
								%accept it
								S21(i,10,z)=1;
								%need to update 24 indexed value with compresed (self or squeezed) value
								%this will be used in calculating purchase cost of buyer 															
								S21(i,24,z)=S21(i,22,z);	% previously, we have updated S21(i,22,z) value based on comparing 20,21 indexed values								
							 else
								%reject the squeezed offer
								S21(i,40,z)=S21(i,22,z);
								S13(i,15,z)=S13(i,15,z)+S21(i,22,z); % since exit, therefore applying penalty
								S21(i,41,z)=Q(i,z);			
								S21(i,42,z)=1;																				 
							 end 
						elseif SqueezeLogic == 3 %switching without cost reduction	
							 S21(i,22,z)=(S21(i,26,z)+S21(i,2,z)/Q(i,z))/(1-S21(i,5,z)); %the price without cost reduction
							 %S13 compares the quote with the market price
							 S21(i,23,z)=S13(i,17,z)/random(triangolareswitch);							 
							 if S21(i,22,z)<=S21(i,23,z)          %if quote is less than market price
								%accept it
								S21(i,10,z)=1;
								%need to update 24 indexed value with compresed (self or squeezed) value
								%this will be used in calculating purchase cost of buyer 															
								S21(i,24,z)=S21(i,22,z);	% previously, we have updated S21(i,22,z) value based on comparing 20,21 indexed values								
							 else
								 %S13 makes a switch of S21
								 S21(i,24,z)=S21(i,23,z);
								 S21(i,11,z)=1;
								 S13(i,15,z)=S13(i,15,z)+SW*S13(i,2,z);
							 end 
						elseif SqueezeLogic == 4 % position (degree centrality score) and size/bargain power to reject
							S21(i,22,z)=S13(i,17,z);				
							%position (degree centrality score) + size (bargaining power)
							TotalPowerToReject = DegCentralityScores(7);
							if SqueezeLogic4Type == 2
								TotalPowerToReject = TotalPowerToReject + S21(i,14,z);					
							else
								TotalPowerToReject = TotalPowerToReject + AgentSizes(7);					
							end 
							if TotalPowerToReject >= rand                     
								%reject the squeezed offer
								S21(i,40,z)=S21(i,22,z);
								S13(i,15,z)=S13(i,15,z)+S21(i,22,z); % since exit, therefore applying penalty
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
							%S21 compresses fixed costs and quotes
							S21(i,20,z)=S21(i,2,z)*random(triangolarecosti);
							S21(i,21,z)=Q(i,z)*(S13(i,17,z)*(1-S21(i,5,z))-S21(i,26,z));
							S21(i,10,z)=1;
							if S21(i,20,z)<S21(i,21,z)
								S21(i,22,z)=S13(i,17,z);
								S21(i,25,z)=S21(i,21,z);
							else
								S21(i,22,z)=(S21(i,26,z)+S21(i,20,z)/Q(i,z))/(1-S21(i,5,z));
								S21(i,25,z)=S21(i,20,z);
							end
							
							%S13 compares the quote with the market price
							S21(i,23,z)=S13(i,17,z)/random(triangolareswitch);							 
							if S21(i,22,z) > S21(i,23,z)          %if quote is greater than market price
								%switching to other supplier	
								%S13 makes a switch of S21		
								S21(i,24,z)=S21(i,23,z);
								S21(i,11,z)=1;
								S13(i,15,z)=S13(i,15,z)+SW*S13(i,2,z);							  
							else
								%need to update 24 indexed value with compresed (self or squeezed) value
								%this will be used in calculating purchase cost of buyer 											    
								S21(i,24,z)=S21(i,22,z); % previously, we have updated S21(i,22,z) value based on comparing 20,21 indexed values
								
								%the supplier compares compressed cost with squeezed cost of buyer								
								if S21(i,20,z)<S21(i,21,z)
									%modified compressed cost is less than squeezed cost of buyer - so accept it
									%S13 remains with old supplier
								else
									%position (degree centrality score) + size (bargaining power)
									TotalPowerToReject = DegCentralityScores(7);
									if SqueezeLogic4Type == 2
										TotalPowerToReject = TotalPowerToReject + S21(i,14,z);					
									else
										TotalPowerToReject = TotalPowerToReject + AgentSizes(7);					
									end 
									if rand > TotalPowerToReject        %I value bargaining power
										%S21 adjusts to the market price and lowers its margin
										S21(i,16,z)=1;
									else 
										%reject the squeezed offer
										S21(i,40,z)=S21(i,22,z);
										S13(i,15,z)=S13(i,15,z)+S21(i,22,z); % since exit, therefore applying penalty
										S21(i,41,z)=Q(i,z);			
										S21(i,42,z)=1;
										S21(i,50,z)=1;																		
									end
								end 
							end
						else %all previous logics together 										
							%S21 compresses fixed costs and quotes
							S21(i,20,z)=S21(i,2,z)*random(triangolarecosti);							
							S21(i,21,z)=Q(i,z)*(S13(i,17,z)*(1-S21(i,5,z))-S21(i,26,z));
							S21(i,10,z)=1;
							if S21(i,20,z)<S21(i,21,z)
								S21(i,22,z)=S13(i,17,z);
								S21(i,25,z)=S21(i,21,z);
							else
								S21(i,22,z)=(S21(i,26,z)+S21(i,20,z)/Q(i,z))/(1-S21(i,5,z));
								S21(i,25,z)=S21(i,20,z);
							end
							
							%S13 compares the quote with the market price
							S21(i,23,z)=S13(i,17,z)/random(triangolareswitch);							 
							if S21(i,22,z) > S21(i,23,z)          %if quote is greater than market price
								%switching to other supplier	
								%S13 makes a switch of S21		
								S21(i,24,z)=S21(i,23,z);
								S21(i,11,z)=1;
								S13(i,15,z)=S13(i,15,z)+SW*S13(i,2,z);							  
							else
								%need to update 24 indexed value with compresed (self or squeezed) value
								%this will be used in calculating purchase cost of buyer 											    
								S21(i,24,z)=S21(i,22,z); % previously, we have updated S21(i,22,z) value based on comparing 20,21 indexed values
								
								%the supplier compares compressed cost with squeezed cost of buyer								
								if S21(i,20,z)<S21(i,21,z)
									%modified compressed cost is less than squeezed cost of buyer - so accept it
									%S13 remains with old supplier
								else
									if rand>S21(i,14,z)        %I value bargaining power
										%S21 adjusts to the market price and lowers its margin
										S21(i,16,z)=1;
									else 
										%reject the squeezed offer
										S21(i,40,z)=S21(i,22,z);
										S13(i,15,z)=S13(i,15,z)+S21(i,22,z); % since exit, therefore applying penalty
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
					S13(i,8,z)=1;
					S21(i,35,z)=1;
					S21(i,24,z)=S13(i,17,z);
					S21(i,49,z)=1; %holding the current profit accepted without squeezing
				end 
			end
        else
            if S21(i,32,z)<=S21(i,29,z) & S21(i,32,z)<=S21(i,30,z) & S21(i,32,z)<=S21(i,31,z) & S21(i,32,z)<=S21(i,33,z) & S21(i,32,z)<=S21(i,34,z)
                %se la riduzione maggiore proviene da S14
                if S21(i,32,z)>S21(i,5,z)
                    S21(i,6,z)=1;
                    S14(i,8,z)=1;
                    S21(i,35,z)=1;
                    S21(i,24,z)=S14(i,17,z);
                else
					%apply learning for propensity to squeeze
					A43 = S21(i,43,z);
					if LearningEnabled
						if LearningTechnique == 1
							[A43, A44, A45, A46]=LearnAndUpdate(AgentConfigs, Psq, PsqVariance, S21, 8, i, z);
							S21(i,43,z) = A43;
							S21(i,44,z) = A44;
							S21(i,45,z) = A45;
							S21(i,46,z) = A46;			
						elseif LearningTechnique == 2
							[A43, A46] = LearnAndUpdateB(AgentConfigs, Psq, PsqVariance, S21, 8, i, z);
							S21(i,46,z) = A46;
						elseif LearningTechnique == 3		
							A43 = GetPropensityPrediction(AgentConfigs, Psq, S21, 8, svmclS21, i, z);	
						end					
					end

					%just holding the purchase cost before squeeze or not - used of debugging purpose
					S21(i,48,z)=S21(i,26,z);

					if (SqueezeLogic==2 || SqueezeLogic==3 || SqueezeLogic==4 || rand <= A43)	
						%if learning is enabled, we are saving the current squeezed probability
						if LearningEnabled && (LearningTechnique == 2 || LearningTechnique == 3) 
							S21(i,43,z) = A43;
						end
						
						S21(i,7,z) = 1;
						Decision(i,1,z)=4;
						
						AlgoritmoRM1_RM2_o
						
						S21(i,26,z)=RM1(i,24,z)+RM2(i,24,z);       %in seguito all'AlgoritmoRM1_RM2_o è cambiato il costo d'acquisto di S21
						if S21(i,8,z)>0
							S21(i,24,z)=S14(i,17,z);
							S21(i,35,z)=1;
							S14(i,8,z)=1;                    %S21 accetta lo squeeze di S14 perchè è stato accettato da RM1 RM2
						else
							S14(i,9,z)=1;
							if SqueezeLogic == 2 %cost reduction only without switch
								%S21 compresses fixed costs and quotes
								S21(i,20,z)=S21(i,2,z)*random(triangolarecosti);
								S21(i,21,z)=Q(i,z)*(S14(i,17,z)*(1-S21(i,5,z))-S21(i,26,z));
								if S21(i,20,z)<S21(i,21,z)
									S21(i,22,z)=S14(i,17,z);
									S21(i,25,z)=S21(i,21,z);
								else
									S21(i,22,z)=(S21(i,26,z)+S21(i,20,z)/Q(i,z))/(1-S21(i,5,z));
									S21(i,25,z)=S21(i,20,z);
								end
								
								%S14 compares the quote with the market price
								S21(i,23,z)=S14(i,17,z)/random(triangolareswitch);								
								if S21(i,22,z)<S21(i,23,z)        %if quote is lower than market price
									%accept it
									S21(i,10,z)=1;	
									%need to update 24 indexed value with compresed (self or squeezed) value
									%this will be used in calculating purchase cost of buyer 															
									S21(i,24,z)=S21(i,22,z);	% previously, we have updated S21(i,22,z) value based on comparing 20,21 indexed values									
								else
									%reject the squeezed offer
									S21(i,40,z)=S21(i,22,z);
									S14(i,15,z)=S14(i,15,z)+S21(i,22,z); % since exit, therefore applying penalty
									S21(i,41,z)=Q(i,z);			
									S21(i,42,z)=1;																					
								end 
							elseif SqueezeLogic == 3 %switching without cost reduction	
								S21(i,22,z)=(S21(i,26,z)+S21(i,2,z)/Q(i,z))/(1-S21(i,5,z)); %the price without cost reduction
								%S14 compares the quote with the market price
								S21(i,23,z)=S14(i,17,z)/random(triangolareswitch);								
								if S21(i,22,z)<S21(i,23,z)        %if quote is lower than market price
									%accept it
									S21(i,10,z)=1;	
									%need to update 24 indexed value with compresed (self or squeezed) value
									%this will be used in calculating purchase cost of buyer 															
									S21(i,24,z)=S21(i,22,z);	% previously, we have updated S21(i,22,z) value based on comparing 20,21 indexed values									
								else
									%S14 makes a switch of S21
									S21(i,24,z)=S21(i,23,z);
									S21(i,11,z)=1;
									S14(i,15,z)=S14(i,15,z)+SW*S14(i,2,z);
								end 
							elseif SqueezeLogic == 4 % position (degree centrality score) and size/bargain power to reject
								S21(i,22,z)=S14(i,17,z);				
								%position (degree centrality score) + size (bargaining power)
								TotalPowerToReject = DegCentralityScores(7);
								if SqueezeLogic4Type == 2
									TotalPowerToReject = TotalPowerToReject + S21(i,14,z);					
								else
									TotalPowerToReject = TotalPowerToReject + AgentSizes(7);					
								end 
									
								if TotalPowerToReject >= rand                     
									%reject the squeezed offer
									S21(i,40,z)=S21(i,22,z);
									S14(i,15,z)=S14(i,15,z)+S21(i,22,z); % since exit, therefore applying penalty
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
								%S21 compresses fixed costs and quotes
								S21(i,20,z)=S21(i,2,z)*random(triangolarecosti);
								S21(i,21,z)=Q(i,z)*(S14(i,17,z)*(1-S21(i,5,z))-S21(i,26,z));
								S21(i,10,z)=1;
								if S21(i,20,z)<S21(i,21,z)
									S21(i,22,z)=S14(i,17,z);
									S21(i,25,z)=S21(i,21,z);
								else
									S21(i,22,z)=(S21(i,26,z)+S21(i,20,z)/Q(i,z))/(1-S21(i,5,z));
									S21(i,25,z)=S21(i,20,z);
								end
								
								%S14 compares the quote with the market price
								S21(i,23,z)=S14(i,17,z)/random(triangolareswitch);								
								if S21(i,22,z) > S21(i,23,z)        %if quote is greater than market price
									%S14 makes a switch of S21
									S21(i,24,z)=S21(i,23,z);
									S21(i,11,z)=1;
									S14(i,15,z)=S14(i,15,z)+SW*S14(i,2,z);
								else 
									%need to update 24 indexed value with compresed (self or squeezed) value
									%this will be used in calculating purchase cost of buyer 				
									S21(i,24,z)=S21(i,22,z); % previously, we have updated S21(i,22,z) value based on comparing 20,21 indexed values
									
									%the supplier compares compressed cost with squeezed cost of buyer
									if S21(i,20,z)<S21(i,21,z)
										%modified compressed cost is less than squeezed cost of buyer - so accept it
										%S14 remains with old supplier
									else
										%position (degree centrality score) + size (bargaining power)
										TotalPowerToReject = DegCentralityScores(7);
										if SqueezeLogic4Type == 2
											TotalPowerToReject = TotalPowerToReject + S21(i,14,z);					
										else
											TotalPowerToReject = TotalPowerToReject + AgentSizes(7);					
										end 
										if rand > TotalPowerToReject         %I value bargaining power
											%S21 adjusts to the market price and lowers its margin
											S21(i,16,z)=1;
										else         
											%reject the squeezed offer
											S21(i,40,z)=S21(i,22,z);
											S14(i,15,z)=S14(i,15,z)+S21(i,22,z); % since exit, therefore applying penalty
											S21(i,41,z)=Q(i,z);			
											S21(i,42,z)=1;
											S21(i,50,z)=1;								
										end
									end
								end
							else %all previous logics together 											
								%S21 compresses fixed costs and quotes
								S21(i,20,z)=S21(i,2,z)*random(triangolarecosti);
								S21(i,21,z)=Q(i,z)*(S14(i,17,z)*(1-S21(i,5,z))-S21(i,26,z));
								S21(i,10,z)=1;
								if S21(i,20,z)<S21(i,21,z)
									S21(i,22,z)=S14(i,17,z);
									S21(i,25,z)=S21(i,21,z);
								else
									S21(i,22,z)=(S21(i,26,z)+S21(i,20,z)/Q(i,z))/(1-S21(i,5,z));
									S21(i,25,z)=S21(i,20,z);
								end
								
								%S14 compares the quote with the market price
								S21(i,23,z)=S14(i,17,z)/random(triangolareswitch);								
								if S21(i,22,z) > S21(i,23,z)        %if quote is greater than market price
									%S14 makes a switch of S21
									S21(i,24,z)=S21(i,23,z);
									S21(i,11,z)=1;
									S14(i,15,z)=S14(i,15,z)+SW*S14(i,2,z);
								else 
									%need to update 24 indexed value with compresed (self or squeezed) value
									%this will be used in calculating purchase cost of buyer 				
									S21(i,24,z)=S21(i,22,z); % previously, we have updated S21(i,22,z) value based on comparing 20,21 indexed values
									
									%the supplier compares compressed cost with squeezed cost of buyer
									if S21(i,20,z)<S21(i,21,z)
										%modified compressed cost is less than squeezed cost of buyer - so accept it
										%S14 remains with old supplier
									else
										if rand>S21(i,14,z)           %I value bargaining power
											%S21 adjusts to the market price and lowers its margin
											S21(i,16,z)=1;
										else         
											%reject the squeezed offer
											S21(i,40,z)=S21(i,22,z);
											S14(i,15,z)=S14(i,15,z)+S21(i,22,z); % since exit, therefore applying penalty
											S21(i,41,z)=Q(i,z);			
											S21(i,42,z)=1;
											S21(i,50,z)=1;								
										end
									end
								end
							end
						end
					else
						%S21 accepts despite the target margin is not reached
						S21(i,6,z)=1;
						S14(i,8,z)=1;
						S21(i,35,z)=1;
						S21(i,24,z)=S14(i,17,z);					
						S21(i,49,z)=1; %holding the current profit accepted without squeezing
					end 
                end
            else
                if S21(i,33,z)<=S21(i,29,z) & S21(i,33,z)<=S21(i,30,z) & S21(i,33,z)<=S21(i,31,z) & S21(i,33,z)<=S21(i,32,z) & S21(i,33,z)<=S21(i,34,z)
                    %se la riduzione maggiore proviene da S15
                    if S21(i,33,z)>S21(i,5,z)
                        S21(i,6,z)=1;
                        S15(i,8,z)=1;
                        S21(i,35,z)=1;
                        S21(i,24,z)=S15(i,17,z);
                    else 
						%apply learning for propensity to squeeze
						A43 = S21(i,43,z);
						if LearningEnabled
							if LearningTechnique == 1
								[A43, A44, A45, A46]=LearnAndUpdate(AgentConfigs, Psq, PsqVariance, S21, 8, i, z);
								S21(i,43,z) = A43;
								S21(i,44,z) = A44;
								S21(i,45,z) = A45;
								S21(i,46,z) = A46;			
							elseif LearningTechnique == 2
								[A43, A46] = LearnAndUpdateB(AgentConfigs, Psq, PsqVariance, S21, 8, i, z);
								S21(i,46,z) = A46;
							elseif LearningTechnique == 3		
								A43 = GetPropensityPrediction(AgentConfigs, Psq, S21, 8, svmclS21, i, z);	
							end					
						end

						%just holding the purchase cost before squeeze or not - used of debugging purpose
						S21(i,48,z)=S21(i,26,z);
						if (SqueezeLogic==2 || SqueezeLogic==3 || SqueezeLogic==4 || rand <= A43)	
							%if learning is enabled, we are saving the current squeezed probability
							if LearningEnabled && (LearningTechnique == 2 || LearningTechnique == 3) 
								S21(i,43,z) = A43;
							end

							S21(i,7,z) = 1;
							Decision(i,1,z)=5;
							
							AlgoritmoRM1_RM2_o
						
							S21(i,26,z)=RM1(i,24,z)+RM2(i,24,z);       %in seguito all'AlgoritmoRM1_RM2_o è cambiato il costo d'acquisto di S21
							if S21(i,8,z)>0
								S21(i,24,z)=S15(i,17,z);
								S21(i,35,z)=1;
								S15(i,8,z)=1;
							else
								S15(i,9,z)=1;
								if SqueezeLogic == 2 %cost reduction only without switch
									%S21 compresses fixed costs and quotes
									S21(i,20,z)=S21(i,2,z)*random(triangolarecosti);
									S21(i,21,z)=Q(i,z)*(S15(i,17,z)*(1-S21(i,5,z))-S21(i,26,z));
									if S21(i,20,z)<S21(i,21,z)
										S21(i,22,z)=S15(i,17,z);
										S21(i,25,z)=S21(i,21,z);
									else
										S21(i,22,z)=(S21(i,26,z)+S21(i,20,z)/Q(i,z))/(1-S21(i,5,z));
										S21(i,25,z)=S21(i,20,z);
									end

									%S15 compares the quote with the market price
									S21(i,23,z)=S15(i,17,z)/random(triangolareswitch);									
									if S21(i,22,z)<S21(i,23,z)          %if quote is lower than market price
										%accept it
										S21(i,10,z)=1;
										%need to update 24 indexed value with compresed (self or squeezed) value
										%this will be used in calculating purchase cost of buyer 															
										S21(i,24,z)=S21(i,22,z);	% previously, we have updated S21(i,22,z) value based on comparing 20,21 indexed values									
									else
										%reject the squeezed offer
										S21(i,40,z)=S21(i,22,z);
										S15(i,15,z)=S15(i,15,z)+S21(i,22,z); % since exit, therefore applying penalty
										S21(i,41,z)=Q(i,z);			
										S21(i,42,z)=1;																						
									end 
								elseif SqueezeLogic == 3 %switching without cost reduction	
									S21(i,22,z)=(S21(i,26,z)+S21(i,2,z)/Q(i,z))/(1-S21(i,5,z)); %the price without cost reduction
									%S15 compares the quote with the market price
									S21(i,23,z)=S15(i,17,z)/random(triangolareswitch);									
									if S21(i,22,z)<S21(i,23,z)          %if quote is lower than market price
										%accept it
										S21(i,10,z)=1;
										%need to update 24 indexed value with compresed (self or squeezed) value
										%this will be used in calculating purchase cost of buyer 															
										S21(i,24,z)=S21(i,22,z);	% previously, we have updated S21(i,22,z) value based on comparing 20,21 indexed values									
									else
										%S15 makes a switch of S21
										S21(i,24,z)=S21(i,23,z);
										S21(i,11,z)=1;
										S15(i,15,z)=S15(i,15,z)+SW*S15(i,2,z);
									end 								
								elseif SqueezeLogic == 4 % position (degree centrality score) and size/bargain power to reject
									S21(i,22,z)=S15(i,17,z);				
									%position (degree centrality score) + size (bargaining power)
									TotalPowerToReject = DegCentralityScores(7);
									if SqueezeLogic4Type == 2
										TotalPowerToReject = TotalPowerToReject + S21(i,14,z);					
									else
										TotalPowerToReject = TotalPowerToReject + AgentSizes(7);					
									end 
									if TotalPowerToReject >= rand                     
										%reject the squeezed offer
										S21(i,40,z)=S21(i,22,z);
										S15(i,15,z)=S15(i,15,z)+S21(i,22,z); % since exit, therefore applying penalty
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
									%S21 compresses fixed costs and quotes
									S21(i,20,z)=S21(i,2,z)*random(triangolarecosti);
									S21(i,21,z)=Q(i,z)*(S15(i,17,z)*(1-S21(i,5,z))-S21(i,26,z));
									S21(i,10,z)=1;
									if S21(i,20,z)<S21(i,21,z)
										S21(i,22,z)=S15(i,17,z);
										S21(i,25,z)=S21(i,21,z);
									else
										S21(i,22,z)=(S21(i,26,z)+S21(i,20,z)/Q(i,z))/(1-S21(i,5,z));
										S21(i,25,z)=S21(i,20,z);
									end

									%S15 compares the quote with the market price
									S21(i,23,z)=S15(i,17,z)/random(triangolareswitch);									
									if S21(i,22,z) > S21(i,23,z)          %if quote is greater than market price
										%S15 makes a switch of S21
										S21(i,24,z)=S21(i,23,z);
										S21(i,11,z)=1;
										S15(i,15,z)=S15(i,15,z)+SW*S15(i,2,z);
									else
										%need to update 24 indexed value with compresed (self or squeezed) value
										%this will be used in calculating purchase cost of buyer 				
										S21(i,24,z)=S21(i,22,z); % previously, we have updated S21(i,22,z) value based on comparing 20,21 indexed values
										 
										%the supplier compares compressed cost with squeezed cost of buyer 
										if S21(i,20,z)<S21(i,21,z)
											%modified compressed cost is less than squeezed cost of buyer - so accept it										
											%S15 stays with old supplier										
										else
											%position (degree centrality score) + size (bargaining power)
											TotalPowerToReject = DegCentralityScores(7);
											if SqueezeLogic4Type == 2
												TotalPowerToReject = TotalPowerToReject + S21(i,14,z);					
											else
												TotalPowerToReject = TotalPowerToReject + AgentSizes(7);					
											end 
											if rand > TotalPowerToReject    %I value bargaining power
												%S21 adjusts to the market price and lowers its margin
												S21(i,16,z)=1;
											else          
												%reject the squeezed offer
												S21(i,40,z)=S21(i,22,z);
												S15(i,15,z)=S15(i,15,z)+S21(i,22,z); % since exit, therefore applying penalty
												S21(i,41,z)=Q(i,z);			
												S21(i,42,z)=1;
												S21(i,50,z)=1;														
											end										
										end 
									end
								else %all previous logics together 												
									%S21 compresses fixed costs and quotes
									S21(i,20,z)=S21(i,2,z)*random(triangolarecosti);
									S21(i,21,z)=Q(i,z)*(S15(i,17,z)*(1-S21(i,5,z))-S21(i,26,z));
									S21(i,10,z)=1;
									if S21(i,20,z)<S21(i,21,z)
										S21(i,22,z)=S15(i,17,z);
										S21(i,25,z)=S21(i,21,z);
									else
										S21(i,22,z)=(S21(i,26,z)+S21(i,20,z)/Q(i,z))/(1-S21(i,5,z));
										S21(i,25,z)=S21(i,20,z);
									end

									%S15 compares the quote with the market price
									S21(i,23,z)=S15(i,17,z)/random(triangolareswitch);									
									if S21(i,22,z) > S21(i,23,z)          %if quote is greater than market price
										%S15 makes a switch of S21
										S21(i,24,z)=S21(i,23,z);
										S21(i,11,z)=1;
										S15(i,15,z)=S15(i,15,z)+SW*S15(i,2,z);
									else
										%need to update 24 indexed value with compresed (self or squeezed) value
										%this will be used in calculating purchase cost of buyer 				
										S21(i,24,z)=S21(i,22,z); % previously, we have updated S21(i,22,z) value based on comparing 20,21 indexed values
										 
										%the supplier compares compressed cost with squeezed cost of buyer 
										if S21(i,20,z)<S21(i,21,z)
											%modified compressed cost is less than squeezed cost of buyer - so accept it										
											%S15 stays with old supplier										
										else
											if rand>S21(i,14,z)     %I value bargaining power
												%S21 adjusts to the market price and lowers its margin
												S21(i,16,z)=1;
											else          
												%reject the squeezed offer
												S21(i,40,z)=S21(i,22,z);
												S15(i,15,z)=S15(i,15,z)+S21(i,22,z); % since exit, therefore applying penalty
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
							S15(i,8,z)=1;
							S21(i,35,z)=1;
							S21(i,24,z)=S15(i,17,z);						
							S21(i,49,z)=1; %holding the current profit accepted without squeezing
						end 
                    end
                end
            end
        end
    end
end
        
            
                
                                 
                                     
                                 
                                 
                            
                        
                            
                                
                            
                        
                        
                    
                             
                         
                    
                    
                
                
                
                
            
            
                        
                    
                    
                
            
            
            
            
            


        
    
        
    
        
    