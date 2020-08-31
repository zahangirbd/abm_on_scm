%AlgorithmS11_S12_i

%I calculate the purchase cost that the buyer is willing to spend
B(i,17,z)=B(i,1,z)*(1-B(i,5,z))-B(i,2,z)/Q(i,z);
if B(i,17,z)>0
    	
    %I calculate the percentage distribution of the squeeze between S11 and S12
    S11(i,18,z)=S11(i,1,z)/B(i,3,z);
    S12(i,18,z)=S12(i,1,z)/B(i,3,z);
    
    %I calculate the margins of S11 and S12 with a throttled price of B
    S11(i,19,z)=(B(i,17,z)*S11(i,18,z)-S11(i,2,z)/Q(i,z)-S11(i,3,z))/(B(i,17,z)*S11(i,18,z));
    S12(i,19,z)=(B(i,17,z)*S12(i,18,z)-S12(i,2,z)/Q(i,z)-S12(i,3,z))/(B(i,17,z)*S12(i,18,z));
    %check if the target margins are reached with a throttled price
    if S11(i,19,z)>S11(i,5,z) & S12(i,19,z)>S12(i,5,z)
       %S11 and S12 both reach the margin and the squeeze is accepted
       B(i,8,z)=1;
       S11(i,6,z)=1;
       S12(i,6,z)=1;
       S11(i,24,z)=B(i,17,z)*S11(i,18,z);
       S12(i,24,z)=B(i,17,z)*S12(i,18,z);
       S11(i,27,z)=S11(i,19,z);
       S12(i,27,z)=S12(i,19,z);
       B(i,26,z)=S11(i,24,z)+S12(i,24,z);
       
        else
            if S11(i,19,z)>S11(i,5,z)
               %if S11 reaches target margin
               S11(i,6,z)=1;
               S11(i,24,z)=B(i,17,z)*S11(i,18,z);
               S11(i,27,z)=S11(i,19,z);               
            else
                %if S11 does not reach its margin				
				%adding the learning related stuffs
				A43 = S11(i,43,z);
				if LearningEnabled		
					if LearningTechnique == 1
						[A43, A44, A45, A46] = LearnAndUpdate(AgentConfigs, Psq, PsqVariance, S11, 2, i, z);
						S11(i,43,z) = A43;
						S11(i,44,z) = A44;
						S11(i,45,z) = A45;
						S11(i,46,z) = A46;			
					elseif LearningTechnique == 2
						[A43, A46] = LearnAndUpdateB(AgentConfigs, Psq, PsqVariance, S11, 2, i, z);		
						S11(i,46,z) = A46;		
					elseif LearningTechnique == 3		
						A43 = GetPropensityPrediction(AgentConfigs, Psq, S11, 2, svmclS11, i, z);	
					end			
				end
				
				%if SqueezeLogic is cost reduction only or switching only, then we always tries to squeeze
				%SqueezeLogic is all together then it depends on Psq/A43 here
				if (SqueezeLogic==2 || SqueezeLogic==3 || SqueezeLogic==4 || rand <= A43)	  
					%S11 then attempts the squeeze
					S11(i,7,z)=1;
					
					%if learning is enabled, we are saving the current squeezed probability
					if LearningEnabled && (LearningTechnique == 2 || LearningTechnique == 3) 
						S11(i,43,z) = A43;
					end
				else
				   %S11 accepts despite the target margin is not reached 	 	
				   S11(i,49,z)=1; %holding the current profit accepted without squeezing				
				   %we shall update the value at the end all executions
                end
            end
            if S12(i,19,z)>S12(i,5,z)
               %if S12 reaches target margin
               S12(i,6,z)=1;
               S12(i,24,z)=B(i,17,z)*S12(i,18,z);
               S12(i,27,z)=S12(i,19,z);              
            else
                %if S12 does not reach its margin
				%adding the learning related stuffs
				A43 = S12(i,43,z);
				if LearningEnabled		
					if LearningTechnique == 1
						[A43, A44, A45, A46] = LearnAndUpdate(AgentConfigs, Psq, PsqVariance, S12, 3, i, z);
						S12(i,43,z) = A43;
						S12(i,44,z) = A44;
						S12(i,45,z) = A45;
						S12(i,46,z) = A46;			
					elseif LearningTechnique == 2
						[A43, A46] = LearnAndUpdateB(AgentConfigs, Psq, PsqVariance, S12, 3, i, z);		
						S12(i,46,z) = A46;		
					elseif LearningTechnique == 3		
						A43 = GetPropensityPrediction(AgentConfigs, Psq, S12, 3, svmclS12, i, z);	
					end			
				end
				
				%if SqueezeLogic is cost reduction only or switching only, then we always tries to squeeze
				%SqueezeLogic is all together then it depends on Psq/A43 here
				if (SqueezeLogic==2 || SqueezeLogic==3 || SqueezeLogic==4 || rand <= A43)	  
                    %S12 then attempts the squeeze
                    S12(i,7,z)=1;
					
					%if learning is enabled, we are saving the current squeezed probability
					if LearningEnabled && (LearningTechnique == 2 || LearningTechnique == 3) 
						S12(i,43,z) = A43;
					end				   					
                else
				   %S12 accepts despite the target margin is not reached 					
				   S12(i,49,z)=1; %holding the current profit accepted without squeezing	
				   %we shall update the value at the end all executions				   
				end
            end
            
			%check if at least one of the suppliers does not reach a margin
            if S11(i,7,z)==1 || S12(i,7,z)==1
                
                AlgoritmoS21_i
                            
                if S21(i,31,z)==1
                    
			    %S21 has accepted the squeeze
			    %you have to check who accepted the squeeze
       
                if S11(i,8,z)>0  %if the squeeze accepted by S21 is that of S11
                    S11(i,26,z)=S21(i,24,z);   %the purchase cost of S11 is the choked price of S21
                    if S12(i,7,z)==1     %if S12 also attempted the squeeze
                        S12(i,26,z)=S12(i,17,z);  %the purchase cost of S12 is equal to the throttled price imposed on S21
                    else
                    end
                    S11(i,24,z)=B(i,17,z)*S11(i,18,z);
                    S12(i,24,z)=B(i,17,z)*S12(i,18,z);
                    B(i,26,z)=S11(i,24,z)+S12(i,24,z);                   
                else                    
                    if S12(i,8,z)>0  %if the squeeze accepted by S21 is that of S12
                        S12(i,26,z)=S21(i,24,z);  %the purchase cost of S12 is the choked price of S21
                        if S11(i,7,z)==1        %if S11 also attempted the squeeze
                            S11(i,26,z)=S11(i,17,z);   %the purchase cost of S11 is = at the throttled price imposed on S21
                        else
                        end
                        S11(i,24,z)=B(i,17,z)*S11(i,18,z);
                        S12(i,24,z)=B(i,17,z)*S12(i,18,z);
                        B(i,26,z)=S11(i,24,z)+S12(i,24,z);
                    end
                end
                else  %otherwise if S21 does not accept the squeeze of its customers                    
                    if S11(i,9,z)==1     %the squeeze of S11 is not accepted by S21
                        S11(i,26,z)=S21(i,24,z);   %the purchase cost for S11 is the initial price of S21
                    end
                    if S12(i,9,z)==1
                        S12(i,26,z)=S21(i,24,z);
                    end
                    B(i,8,z)=0;
                    B(i,9,z)=1;   %since S21 has not accepted the squeeze, S11 and S12 also reject the squeeze
                    
                    %S11 if he tried the squeeze but was not accepted then he compresses fixed costs and makes a quote
                    if S11(i,7,z)==1 
						if SqueezeLogic == 2 %cost reduction only without switch
							S11(i,20,z)=S11(i,2,z)*random(triangolarecosti);
							S11(i,21,z)=Q(i,z)*(B(i,17,z)*S11(i,18,z)*(1-S11(i,5,z))-S11(i,26,z));
							
							if S11(i,20,z)<S11(i,21,z)    %if the compressed fixed costs are those that satisfy price and margin
								S11(i,22,z)=B(i,17,z)*S11(i,18,z);
								S11(i,25,z)=S11(i,21,z);
							else        %otherwise if the compressed fixed costs are those for distribution
								S11(i,22,z)=(S11(i,26,z)+S11(i,20,z)/Q(i,z))/(1-S11(i,5,z));
								S11(i,25,z)=S11(i,20,z);
							end
							%accept it
							%B stays with his supplier
							S11(i,10,z)=1;	
							%need to update 24 indexed value with compresed (self or squeezed) value
							%this will be used in calculating purchase cost of buyer 		
							S11(i,24,z)=S11(i,22,z); % previously, we have updated RM1(i,22,z) value based on comparing 20,21 indexed values		                                                           
						elseif SqueezeLogic == 3 %switching without cost reduction	
							S11(i,22,z)=(S11(i,26,z)+S11(i,2,z)/Q(i,z))/(1-S11(i,5,z)); %the price without cost reduction  
                            %B compare quote with market price
                            S11(i,23,z)=(B(i,17,z)*S11(i,18,z))/random(triangolareswitch);                            
                            if S11(i,22,z)<S11(i,23,z)   %if quote is lower than the market price
                                %accept it
								%B stays with his supplier
								S11(i,10,z)=1;	
								%need to update 24 indexed value with compresed (self or squeezed) value
								%this will be used in calculating purchase cost of buyer 		
                                S11(i,24,z)=S11(i,22,z); % previously, we have updated S11(i,22,z) value based on comparing 20,21 indexed values		                               
                            else                                    
								%B makes a switch of S11
								S11(i,24,z)=S11(i,23,z);
								S11(i,11,z)=1;
								B(i,15,z)=B(i,15,z)+SW*S11(i,18,z)*B(i,2,z);
							end 							
						elseif SqueezeLogic == 4 % position (degree centrality score) and size/bargain power to reject
							S11(i,22,z)=B(i,17,z)*S11(i,18,z);  %the squeezed (by supplier) one (e.g., indexed by 21) 
							%position (degree centrality score) + size (bargaining power)
							TotalPowerToReject = DegCentralityScores(2);
							if SqueezeLogic4Type == 2
								TotalPowerToReject = TotalPowerToReject + S11(i,14,z);					
							else
								TotalPowerToReject = TotalPowerToReject + AgentSizes(2);					
							end 
							if TotalPowerToReject >= rand                      
								%reject the squeezed offer
								S11(i,40,z)=S11(i,22,z);
								B(i,15,z)=B(i,15,z)+S11(i,22,z); % since exit, therefore applying penalty
								S11(i,41,z)=Q(i,z);	
								S11(i,42,z)=1;			
								S11(i,50,z)=1;
							else
								%need to update 24 indexed value with squeezed value
								%this will be used in calculating purchase cost of buyer 				
								S11(i,24,z)=S11(i,22,z);				
								%S11 accepts the squeezed price
								S11(i,6,z)=1;
							end 				
						elseif SqueezeLogic == 5 % new squeeze logic 2, 3, & 4 all together
							S11(i,20,z)=S11(i,2,z)*random(triangolarecosti);
							S11(i,21,z)=Q(i,z)*(B(i,17,z)*S11(i,18,z)*(1-S11(i,5,z))-S11(i,26,z));
							S11(i,10,z)=1;
							if S11(i,20,z)<S11(i,21,z)    %if the compressed fixed costs are those that satisfy price and margin
								S11(i,22,z)=B(i,17,z)*S11(i,18,z);
								S11(i,25,z)=S11(i,21,z);
							else        %otherwise if the compressed fixed costs are those for distribution
								S11(i,22,z)=(S11(i,26,z)+S11(i,20,z)/Q(i,z))/(1-S11(i,5,z));
								S11(i,25,z)=S11(i,20,z);
							end
                            
                            %B compare quote with market price
                            S11(i,23,z)=(B(i,17,z)*S11(i,18,z))/random(triangolareswitch);                            
                            if S11(i,22,z) > S11(i,23,z)   %if quote is greater than the market price
								%B makes a switch of S11
								S11(i,24,z)=S11(i,23,z);
								S11(i,11,z)=1;
								B(i,15,z)=B(i,15,z)+SW*S11(i,18,z)*B(i,2,z);
                            else      
                                %B stays with his supplier                               
								%need to update 24 indexed value with compresed (self or squeezed) value
								%this will be used in calculating purchase cost of buyer 						
								S11(i,24,z)=S11(i,22,z); % previously, we have updated S11(i,22,z) value based on comparing 20,21 indexed values

								%the supplier compares compressed cost with squeezed cost of buyer
								if S11(i,20,z)<S11(i,21,z)    %if the compressed fixed costs are those that satisfy price and margin
									%modified compressed cost is less than squeezed cost of buyer - so accept it
									%B stays with his supplier              
								else
									%B stays with his supplier based on bargaining power
									%position (degree centrality score) + size (bargaining power)
									TotalPowerToReject = DegCentralityScores(2);
									if SqueezeLogic4Type == 2
										TotalPowerToReject = TotalPowerToReject + S11(i,14,z);					
									else
										TotalPowerToReject = TotalPowerToReject + AgentSizes(2);					
									end 
									if rand > TotalPowerToReject  %I value bargaining power
										%S11 adjusts to market price										
										S11(i,16,z)=1;  
									else 
										%reject the squeezed offer
										S11(i,40,z)=S11(i,22,z);
										B(i,15,z)=B(i,15,z)+S11(i,22,z); % since exit, therefore applying penalty
										S11(i,41,z)=Q(i,z);	
										S11(i,42,z)=1;	
										S11(i,50,z)=1;		
									end								
								end 									
                            end						
						else %all previous logics together 
							S11(i,20,z)=S11(i,2,z)*random(triangolarecosti);
							S11(i,21,z)=Q(i,z)*(B(i,17,z)*S11(i,18,z)*(1-S11(i,5,z))-S11(i,26,z));
							S11(i,10,z)=1;
							if S11(i,20,z)<S11(i,21,z)    %if the compressed fixed costs are those that satisfy price and margin
								S11(i,22,z)=B(i,17,z)*S11(i,18,z);
								S11(i,25,z)=S11(i,21,z);
							else        %otherwise if the compressed fixed costs are those for distribution
								S11(i,22,z)=(S11(i,26,z)+S11(i,20,z)/Q(i,z))/(1-S11(i,5,z));
								S11(i,25,z)=S11(i,20,z);
							end
                            
                            %B compare quote with market price
                            S11(i,23,z)=(B(i,17,z)*S11(i,18,z))/random(triangolareswitch);                            
                            if S11(i,22,z) > S11(i,23,z)   %if quote is greater than the market price
								%B makes a switch of S11
								S11(i,24,z)=S11(i,23,z);
								S11(i,11,z)=1;
								B(i,15,z)=B(i,15,z)+SW*S11(i,18,z)*B(i,2,z);
                            else      
                                %B stays with his supplier                               
								%need to update 24 indexed value with compresed (self or squeezed) value
								%this will be used in calculating purchase cost of buyer 						
								S11(i,24,z)=S11(i,22,z); % previously, we have updated S11(i,22,z) value based on comparing 20,21 indexed values

								%the supplier compares compressed cost with squeezed cost of buyer
								if S11(i,20,z)<S11(i,21,z)    %if the compressed fixed costs are those that satisfy price and margin
									%modified compressed cost is less than squeezed cost of buyer - so accept it
									%B stays with his supplier              
								else
									%B stays with his supplier based on bargaining power
									if rand>S11(i,14,z)   %I value bargaining power
										%S11 adjusts to market price										
										S11(i,16,z)=1;  
									else 
										%reject the squeezed offer
										S11(i,40,z)=S11(i,22,z);
										B(i,15,z)=B(i,15,z)+S11(i,22,z); % since exit, therefore applying penalty
										S11(i,41,z)=Q(i,z);	
										S11(i,42,z)=1;									
									end								
								end 									
                            end						
						end 						
                    else
                    end
                    
					%S12 if attempted the squeeze but was not accepted it will save costs
                    if S12(i,7,z)==1
						if SqueezeLogic == 2 %cost reduction only without switch
							S12(i,20,z)=S12(i,2,z)*random(triangolarecosti);
							S12(i,21,z)=Q(i,z)*(B(i,17,z)*S12(i,18,z)*(1-S12(i,5,z))-S12(i,26,z));
							
							if S12(i,20,z)<S12(i,21,z)   %if the compressed fixed costs are those that satisfy price and margin
								S12(i,22,z)=B(i,17,z)*S12(i,18,z);
								S12(i,25,z)=S12(i,21,z);
							else     %otherwise if the compressed fixed costs are the distribution ones
								S12(i,22,z)=(S12(i,26,z)+S12(i,20,z)/Q(i,z))/(1-S12(i,5,z));
								S12(i,25,z)=S12(i,20,z);
							end
							%accept it
							%B stays with his supplier
							S12(i,10,z)=1;		
							%need to update 24 indexed value with compresed (self or squeezed) value
							%this will be used in calculating purchase cost of buyer 										
							S12(i,24,z)=S12(i,22,z);	% previously, we have updated S12(i,22,z) value based on comparing 20,21 indexed values									
						elseif SqueezeLogic == 3 %switching without cost reduction	
							S12(i,22,z)=(S12(i,26,z)+S12(i,2,z)/Q(i,z))/(1-S12(i,5,z)); %the price without cost reduction  
							%B compare quote with market price							
							S12(i,23,z)=(B(i,17,z)*S12(i,18,z))/random(triangolareswitch);
							if S12(i,22,z)<S12(i,23,z)   %if quote is lower than the market price
								%accept it
								%B stays with his supplier
								S12(i,10,z)=1;		
								%need to update 24 indexed value with compresed (self or squeezed) value
								%this will be used in calculating purchase cost of buyer 										
								S12(i,24,z)=S12(i,22,z);	% previously, we have updated S12(i,22,z) value based on comparing 20,21 indexed values			
							else    							
								%B makes a switch of S12
								S12(i,24,z)=S12(i,23,z);
								S12(i,11,z)=1;
								B(i,15,z)=B(i,15,z)+SW*S12(i,18,z)*B(i,2,z);
							end 							
						elseif SqueezeLogic == 4 % position (degree centrality score) and size/bargain power to reject
							S12(i,22,z)=B(i,17,z)*S12(i,18,z);  %the squeezed (by supplier) one (e.g., indexed by 21) 
							%position (degree centrality score) + size (bargaining power)
							TotalPowerToReject = DegCentralityScores(3);
							if SqueezeLogic4Type == 2
								TotalPowerToReject = TotalPowerToReject + S12(i,14,z);					
							else
								TotalPowerToReject = TotalPowerToReject + AgentSizes(3);					
							end 
							if TotalPowerToReject >= rand                      
								%reject the squeezed offer
								S12(i,40,z)=S12(i,22,z);
								B(i,15,z)=B(i,15,z)+S12(i,22,z); % since exit, therefore applying penalty
								S12(i,41,z)=Q(i,z);	
								S12(i,42,z)=1;			
								S12(i,50,z)=1;
							else
								%need to update 24 indexed value with squeezed value
								%this will be used in calculating purchase cost of buyer 				
								S12(i,24,z)=S12(i,22,z);				
								%S12 accepts the squeezed price
								S12(i,6,z)=1;
							end 				
						elseif SqueezeLogic == 5 % new squeeze logic 2, 3, & 4 all together
							S12(i,20,z)=S12(i,2,z)*random(triangolarecosti);
							S12(i,21,z)=Q(i,z)*(B(i,17,z)*S12(i,18,z)*(1-S12(i,5,z))-S12(i,26,z));
							S12(i,10,z)=1;
							if S12(i,20,z)<S12(i,21,z)   %if the compressed fixed costs are those that satisfy price and margin
								S12(i,22,z)=B(i,17,z)*S12(i,18,z);
								S12(i,25,z)=S12(i,21,z);
							else     %otherwise if the compressed fixed costs are the distribution ones
								S12(i,22,z)=(S12(i,26,z)+S12(i,20,z)/Q(i,z))/(1-S12(i,5,z));
								S12(i,25,z)=S12(i,20,z);
							end
							
							%B compare quote with market price							
							S12(i,23,z)=(B(i,17,z)*S12(i,18,z))/random(triangolareswitch);
							if S12(i,22,z) > S12(i,23,z)   %if quote is greater than the market price
								%B makes a switch of S12
								S12(i,24,z)=S12(i,23,z);
								S12(i,11,z)=1;
								B(i,15,z)=B(i,15,z)+SW*S12(i,18,z)*B(i,2,z);
							else    							
								%B stays with his supplier	
								%need to update 24 indexed value with compresed (self or squeezed) value
								%this will be used in calculating purchase cost of buyer 						
								S12(i,24,z)=S12(i,22,z); % previously, we have updated RM1(i,22,z) value based on comparing 20,21 indexed values

								%the supplier compares compressed cost with squeezed cost of buyer
								if S12(i,20,z)<S12(i,21,z)   %if the compressed fixed costs are those that satisfy price and margin
									%modified compressed cost is less than squeezed cost of buyer - so accept it
									%B stays with his supplier	
								else
									%B stays with his supplier based on bargaining power 	
									%position (degree centrality score) + size (bargaining power)
									TotalPowerToReject = DegCentralityScores(3);
									if SqueezeLogic4Type == 2
										TotalPowerToReject = TotalPowerToReject + S12(i,14,z);					
									else
										TotalPowerToReject = TotalPowerToReject + AgentSizes(3);					
									end 
									if rand > TotalPowerToReject   %I value bargaining power
										%S12 adjusts to market price
										S12(i,16,z)=1;
									else       
										%reject the squeezed offer
										S12(i,40,z)=S12(i,22,z);
										B(i,15,z)=B(i,15,z)+S12(i,22,z); % since exit, therefore applying penalty
										S12(i,41,z)=Q(i,z);	
										S12(i,42,z)=1;
										S12(i,50,z)=1;			
									end									
								end 							
							end
						else %all previous logics together 
							S12(i,20,z)=S12(i,2,z)*random(triangolarecosti);
							S12(i,21,z)=Q(i,z)*(B(i,17,z)*S12(i,18,z)*(1-S12(i,5,z))-S12(i,26,z));
							S12(i,10,z)=1;
							if S12(i,20,z)<S12(i,21,z)   %if the compressed fixed costs are those that satisfy price and margin
								S12(i,22,z)=B(i,17,z)*S12(i,18,z);
								S12(i,25,z)=S12(i,21,z);
							else     %otherwise if the compressed fixed costs are the distribution ones
								S12(i,22,z)=(S12(i,26,z)+S12(i,20,z)/Q(i,z))/(1-S12(i,5,z));
								S12(i,25,z)=S12(i,20,z);
							end
							
							%B compare quote with market price							
							S12(i,23,z)=(B(i,17,z)*S12(i,18,z))/random(triangolareswitch);
							if S12(i,22,z) > S12(i,23,z)   %if quote is greater than the market price
								%B makes a switch of S12
								S12(i,24,z)=S12(i,23,z);
								S12(i,11,z)=1;
								B(i,15,z)=B(i,15,z)+SW*S12(i,18,z)*B(i,2,z);
							else    							
								%B stays with his supplier	
								%need to update 24 indexed value with compresed (self or squeezed) value
								%this will be used in calculating purchase cost of buyer 						
								S12(i,24,z)=S12(i,22,z); % previously, we have updated RM1(i,22,z) value based on comparing 20,21 indexed values

								%the supplier compares compressed cost with squeezed cost of buyer
								if S12(i,20,z)<S12(i,21,z)   %if the compressed fixed costs are those that satisfy price and margin
									%modified compressed cost is less than squeezed cost of buyer - so accept it
									%B stays with his supplier	
								else
									%B stays with his supplier based on bargaining power 	
									if rand>S12(i,14,z)    %I value bargaining power
										%S12 adjusts to market price
										S12(i,16,z)=1;
									else       
										%reject the squeezed offer
										S12(i,40,z)=S12(i,22,z);
										B(i,15,z)=B(i,15,z)+S12(i,22,z); % since exit, therefore applying penalty
										S12(i,41,z)=Q(i,z);	
										S12(i,42,z)=1;									
									end									
								end 							
							end
						end 	
                    else
                    end
                    B(i,26,z)=S11(i,24,z)+S12(i,24,z);
                end
            end
			
			%following things are updated lastly 
			%as previous if S11(i,7,z)==1 || S12(i,7,z)==1 are doing some mix works
			%therefore, update other values when the current profit accepted without squeezing		
			if S11(i,49,z) == 1
			   %S11 accepts despite the target margin is not reached	
			   S11(i,6,z)=1;
			   S11(i,24,z)=B(i,17,z)*S11(i,18,z);
			   S11(i,27,z)=S11(i,19,z);
			end 

			if S12(i,49,z) == 1
			   %S12 accepts despite the target margin is not reached		
			   S12(i,6,z)=1;
			   S12(i,24,z)=B(i,17,z)*S12(i,18,z);
			   S12(i,27,z)=S12(i,19,z);
			end 			
	
	end
else
    exit=1;
    S11(i,28,z)=1;
    S12(i,28,z)=1;
end
    
            
   
        
        
    
    
                
                                
                            
                        
                        
                  
                        
                       
                            
                                    
                            
                            
                            
                            
                            
                    
                    
                
                
     
                    
               
          
               
              
           
       
       
       