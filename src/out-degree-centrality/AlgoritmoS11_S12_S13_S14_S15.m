%AlgoritmoS11_S12_S13_S14_S15

%I calculate the choked price that B is willing to spend
B(i,17,z)=B(i,1,z)*(1-B(i,5,z))-B(i,2,z)/Q(i,z);
%fprintf('B(i,17,z)=%f\n', B(i,17,z));

if B(i,17,z)>0

    
    %I calculate the percentage distribution of B's ??squeeze between S11 S12 S13 S14 S15
    S11(i,18,z)=S11(i,1,z)/B(i,3,z);
    S12(i,18,z)=S12(i,1,z)/B(i,3,z);
    S13(i,18,z)=S13(i,1,z)/B(i,3,z);
    S14(i,18,z)=S14(i,1,z)/B(i,3,z);
    S15(i,18,z)=S15(i,1,z)/B(i,3,z);
	%fprintf('B(i,3,z)=%f, S11(i,1,z)=%f, S11(i,18,z)=%f, S12(i,1,z)=%f, S12(i,18,z)=%f, S13(i,1,z)=%f, S13(i,18,z)=%f, S14(i,1,z)=%f, S14(i,18,z)=%f, S15(i,1,z)=%f, S15(i,18,z)=%f\n', B(i,3,z), S11(i,1,z), S11(i,18,z), S12(i,1,z), S12(i,18,z), S13(i,1,z), S13(i,18,z), S14(i,1,z), S14(i,18,z), S15(i,1,z), S15(i,18,z));
    
     %I calculate the margins of S11 S12 S13 S14 S15 with choked price of B
     S11(i,19,z)=(B(i,17,z)*S11(i,18,z)-S11(i,2,z)/Q(i,z)-S11(i,3,z))/(B(i,17,z)*S11(i,18,z));
     S12(i,19,z)=(B(i,17,z)*S12(i,18,z)-S12(i,2,z)/Q(i,z)-S12(i,3,z))/(B(i,17,z)*S12(i,18,z));
     S13(i,19,z)=(B(i,17,z)*S13(i,18,z)-S13(i,2,z)/Q(i,z)-S13(i,3,z))/(B(i,17,z)*S13(i,18,z));
     S14(i,19,z)=(B(i,17,z)*S14(i,18,z)-S14(i,2,z)/Q(i,z)-S14(i,3,z))/(B(i,17,z)*S14(i,18,z));
     S15(i,19,z)=(B(i,17,z)*S15(i,18,z)-S15(i,2,z)/Q(i,z)-S15(i,3,z))/(B(i,17,z)*S15(i,18,z));
  
	 %just holding the purchase cost before squeeze or not - used of debugging purpose
	 S11(i,48,z)=S11(i,26,z);
	 S12(i,48,z)=S12(i,26,z);
	 S13(i,48,z)=S13(i,26,z);
	 S14(i,48,z)=S14(i,26,z);
	 S15(i,48,z)=S15(i,26,z);
  
     % check if the target margins of S11 S12 S13 S14 S15 are reached with a throttled price
	 % Here S11(i,19,z) is current profit (i.e., PMc or x in Psq equation for learning) 
	 % and S11(i,5,z) is target profit (i.e., PMt or T in Psq equation for learning) 
	 %fprintf('S11(i,19,z)=%f, S11(i,5,z)=%f, S12(i,19,z)=%f, S12(i,5,z)=%f, S13(i,19,z)=%f, S13(i,5,z)=%f, S14(i,19,z)=%f, S14(i,5,z)=%f, S15(i,19,z)=%f, S15(i,5,z)=%f\n', S11(i,19,z), S11(i,5,z), S12(i,19,z), S12(i,5,z), S13(i,19,z), S13(i,5,z), S14(i,19,z), S14(i,5,z), S15(i,19,z), S15(i,5,z));	 
     if S11(i,19,z)>S11(i,5,z) & S12(i,19,z)>S12(i,5,z) & S13(i,19,z)>S13(i,5,z) & S14(i,19,z)>S14(i,5,z) & S15(i,19,z)>S15(i,5,z) 
         
         %S11 S12 S13 S14 S15 both reach the margin and the squeeze is accepted
         B(i,8,z)=1;
         S11(i,6,z)=1;
         S12(i,6,z)=1;
         S13(i,6,z)=1;
         S14(i,6,z)=1;
         S15(i,6,z)=1;
         S11(i,24,z)=B(i,17,z)*S11(i,18,z);
         S12(i,24,z)=B(i,17,z)*S12(i,18,z);
         S13(i,24,z)=B(i,17,z)*S13(i,18,z);
         S14(i,24,z)=B(i,17,z)*S14(i,18,z);
         S15(i,24,z)=B(i,17,z)*S15(i,18,z);
         S11(i,27,z)=S11(i,19,z);
         S12(i,27,z)=S12(i,19,z);
         S13(i,27,z)=S13(i,19,z);
         S14(i,27,z)=S14(i,19,z);
         S15(i,27,z)=S15(i,19,z);
         B(i,26,z)=S11(i,24,z)+S12(i,24,z)+S13(i,24,z)+S14(i,24,z)+S15(i,24,z);
         
     else
         if S11(i,19,z)>S11(i,5,z)
             %if S11 reaches target margin
             S11(i,6,z)=1;
             S11(i,24,z)=B(i,17,z)*S11(i,18,z);
             S11(i,27,z)=S11(i,19,z);
         else
			  %apply learning for propensity to squeeze
			  A43 = S11(i,43,z);
			  if LearningEnabled
				if LearningTechnique == 1
					[A43, A44, A45, A46]=LearnAndUpdate(AgentConfigs, Psq, PsqVariance, S11, 2, i, z);
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
		 
            %if S11 does not reach its margin
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
			  %apply learning for propensity to squeeze
			  A43 = S12(i,43,z);
			  if LearningEnabled
				if LearningTechnique == 1
					[A43, A44, A45, A46]=LearnAndUpdate(AgentConfigs, Psq, PsqVariance, S12, 3, i, z);
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
		 
            %if S12 does not reach its margin
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
         if S13(i,19,z)>S13(i,5,z)
             %if S13 reaches target margin
             S13(i,6,z)=1;
             S13(i,24,z)=B(i,17,z)*S13(i,18,z);
             S13(i,27,z)=S13(i,19,z);             
         else
			  %apply learning for propensity to squeeze
			  A43 = S13(i,43,z);
			  if LearningEnabled
				if LearningTechnique == 1
					[A43, A44, A45, A46]=LearnAndUpdate(AgentConfigs, Psq, PsqVariance, S13, 4, i, z);
					S13(i,43,z) = A43;
					S13(i,44,z) = A44;
					S13(i,45,z) = A45;
					S13(i,46,z) = A46;			
				elseif LearningTechnique == 2
					[A43, A46] = LearnAndUpdateB(AgentConfigs, Psq, PsqVariance, S13, 4, i, z);
					S13(i,46,z) = A46;
				elseif LearningTechnique == 3		
					A43 = GetPropensityPrediction(AgentConfigs, Psq, S13, 4, svmclS13, i, z);	
				end					
			  end
		 
            %if S13 does not reach its margin
			if (SqueezeLogic==2 || SqueezeLogic==3 || SqueezeLogic==4 || rand <= A43)
                 %S13 then attempts the squeeze
                 S13(i,7,z)=1;
				 
				 %if learning is enabled, we are saving the current squeezed probability
				 if LearningEnabled && (LearningTechnique == 2 || LearningTechnique == 3) 
					S13(i,43,z) = A43;
				 end
			else
			   %S13 accepts despite the target margin is not reached 					
			   S13(i,49,z)=1; %holding the current profit accepted without squeezing	
			   %we shall update the value at the end all executions				   				 
            end
         end
         if S14(i,19,z)>S14(i,5,z)
             %if S14 reaches target margin
             S14(i,6,z)=1;
             S14(i,24,z)=B(i,17,z)*S14(i,18,z);
             S14(i,27,z)=S14(i,19,z);             
         else
			  %apply learning for propensity to squeeze
			  A43 = S14(i,43,z);
			  if LearningEnabled
				if LearningTechnique == 1
					[A43, A44, A45, A46]=LearnAndUpdate(AgentConfigs, Psq, PsqVariance, S14, 5, i, z);
					S14(i,43,z) = A43;
					S14(i,44,z) = A44;
					S14(i,45,z) = A45;
					S14(i,46,z) = A46;			
				elseif LearningTechnique == 2
					[A43, A46] = LearnAndUpdateB(AgentConfigs, Psq, PsqVariance, S14, 5, i, z);
					S14(i,46,z) = A46;
				elseif LearningTechnique == 3		
					A43 = GetPropensityPrediction(AgentConfigs, Psq, S14, 5, svmclS14, i, z);	
				end					
			  end

            %if S14 does not reach its margin
			if (SqueezeLogic==2 || SqueezeLogic==3 || SqueezeLogic==4 || rand <= A43)
                 %S14 then attempts the squeeze
                 S14(i,7,z)=1;

				 %if learning is enabled, we are saving the current squeezed probability
				 if LearningEnabled && (LearningTechnique == 2 || LearningTechnique == 3) 
					S14(i,43,z) = A43;
				 end
			else
			   %S14 accepts despite the target margin is not reached 					
			   S14(i,49,z)=1; %holding the current profit accepted without squeezing	
			   %we shall update the value at the end all executions				   				 
            end
         end
         if S15(i,19,z)>S15(i,5,z)
             %if S15 reaches target margin
             S15(i,6,z)=1;
             S15(i,24,z)=B(i,17,z)*S15(i,18,z);
             S15(i,27,z)=S15(i,19,z);
         else
			  %apply learning for propensity to squeeze
			  A43 = S15(i,43,z);
			  if LearningEnabled
				if LearningTechnique == 1
					[A43, A44, A45, A46]=LearnAndUpdate(AgentConfigs, Psq, PsqVariance, S15, 6, i, z);
					S15(i,43,z) = A43;
					S15(i,44,z) = A44;
					S15(i,45,z) = A45;
					S15(i,46,z) = A46;			
				elseif LearningTechnique == 2
					[A43, A46] = LearnAndUpdateB(AgentConfigs, Psq, PsqVariance, S15, 6, i, z);
					S15(i,46,z) = A46;
				elseif LearningTechnique == 3		
					A43 = GetPropensityPrediction(AgentConfigs, Psq, S15, 6, svmclS15, i, z);	
				end					
			  end

            %if S15 does not reach its margin
			if (SqueezeLogic==2 || SqueezeLogic==3 || SqueezeLogic==4 || rand <= A43)
                 %S15 then attempts the squeeze
                 S15(i,7,z)=1;

				 %if learning is enabled, we are saving the current squeezed probability
				 if LearningEnabled && (LearningTechnique == 2 || LearningTechnique == 3) 
					S15(i,43,z) = A43;
				 end
			else
			   %S15 accepts despite the target margin is not reached 					
			   S15(i,49,z)=1; %holding the current profit accepted without squeezing	
			   %we shall update the value at the end all executions				   				 
            end
         end         
         
		 %check if at least one of the suppliers has not reached a margin
         if S11(i,7,z)==1 || S12(i,7,z)==1 || S13(i,7,z)==1 || S14(i,7,z)==1 || S15(i,7,z)==1
             
             AlgoritmoS21_o
             
             if S21(i,35,z)==1
                 %S21 has accepted the squeeze    
                 %you have to check who accepted the squeeze S21
                 
                 if S11(i,8,z)>0 %if the squeeze accepted by S21 is that of S11
                     S11(i,26,z)=S21(i,24,z);   %the purchase cost of S11 is the choked price of S21
                     if S12(i,7,z)==1         %if S12 also attempted the squeeze
                         S12(i,26,z)=S12(i,17,z);
                     else             %otherwise if he had not tried squeeze his initial purchase cost remains
                     end
                     if S13(i,7,z)==1
                         S13(i,26,z)=S13(i,17,z);
                     else
                     end
                     if S14(i,7,z)==1
                         S14(i,26,z)=S14(i,17,z);
                     else
                     end
                     if S15(i,7,z)==1
                         S15(i,26,z)=S15(i,17,z);
                     else
                     end
                     S11(i,24,z)=B(i,17,z)*S11(i,18,z);
                     S12(i,24,z)=B(i,17,z)*S12(i,18,z);
                     S13(i,24,z)=B(i,17,z)*S13(i,18,z);
                     S14(i,24,z)=B(i,17,z)*S14(i,18,z);
                     S15(i,24,z)=B(i,17,z)*S15(i,18,z);
                     B(i,26,z)=S11(i,24,z)+S12(i,24,z)+S13(i,24,z)+S14(i,24,z)+S15(i,24,z);
                 else
                     if S12(i,8,z)>0 
                         S12(i,26,z)=S21(i,24,z);
                         if S11(i,7,z)==1
                             S11(i,26,z)=S11(i,17,z);
                         else
                         end
                         if S13(i,7,z)==1
                             S13(i,26,z)=S13(i,17,z);
                         else
                         end
                         if S14(i,7,z)==1
                             S14(i,26,z)=S14(i,17,z);
                         else
                         end
                         if S15(i,7,z)==1
                             S15(i,26,z)=S15(i,17,z);
                         else
                         end
                         S11(i,24,z)=B(i,17,z)*S11(i,18,z);
                         S12(i,24,z)=B(i,17,z)*S12(i,18,z);
                         S13(i,24,z)=B(i,17,z)*S13(i,18,z);
                         S14(i,24,z)=B(i,17,z)*S14(i,18,z);
                         S15(i,24,z)=B(i,17,z)*S15(i,18,z);
                         B(i,26,z)=S11(i,24,z)+S12(i,24,z)+S13(i,24,z)+S14(i,24,z)+S15(i,24,z);
                         
                     else
                         if S13(i,8,z)>0
                             S13(i,26,z)=S21(i,24,z);
                             if S11(i,7,z)==1
                                 S11(i,26,z)=S11(i,17,z);
                             else
                             end
                             if S12(i,7,z)==1
                                 S12(i,26,z)=S12(i,17,z);
                             else
                             end
                             if S14(i,7,z)==1
                                 S14(i,26,z)=S14(i,17,z);
                             else
                             end
                             if S15(i,7,z)==1
                                 S15(i,26,z)=S15(i,17,z);
                             else
                             end
                             S11(i,24,z)=B(i,17,z)*S11(i,18,z);
                             S12(i,24,z)=B(i,17,z)*S12(i,18,z);
                             S13(i,24,z)=B(i,17,z)*S13(i,18,z);
                             S14(i,24,z)=B(i,17,z)*S14(i,18,z);
                             S15(i,24,z)=B(i,17,z)*S15(i,18,z);
                             B(i,26,z)=S11(i,24,z)+S12(i,24,z)+S13(i,24,z)+S14(i,24,z)+S15(i,24,z);                             
                         else
                             if S14(i,8,z)>0
                                 S14(i,26,z)=S21(i,24,z);
                                 if S11(i,7,z)==1
                                     S11(i,26,z)=S11(i,17,z);
                                 else
                                 end
                                 if S12(i,7,z)==1
                                     S12(i,26,z)=S12(i,17,z);
                                 else
                                 end
                                 if S13(i,7,z)==1
                                     S13(i,26,z)=S13(i,17,z);
                                 else
                                 end
                                 if S15(i,7,z)==1
                                     S15(i,26,z)=S15(i,17,z);
                                 else
                                 end
                                 S11(i,24,z)=B(i,17,z)*S11(i,18,z);
                                 S12(i,24,z)=B(i,17,z)*S12(i,18,z);
                                 S13(i,24,z)=B(i,17,z)*S13(i,18,z);
                                 S14(i,24,z)=B(i,17,z)*S14(i,18,z);
                                 S15(i,24,z)=B(i,17,z)*S15(i,18,z);
                                 B(i,26,z)=S11(i,24,z)+S12(i,24,z)+S13(i,24,z)+S14(i,24,z)+S15(i,24,z);
                                 
                             else
                                 if S15(i,8,z)>0
                                     S15(i,26,z)=S21(i,24,z);
                                     if S11(i,7,z)==1
                                         S11(i,26,z)=S11(i,17,z);
                                     else
                                     end
                                     if S12(i,7,z)==1
                                         S12(i,26,z)=S12(i,17,z);
                                     else
                                     end
                                     if S13(i,7,z)==1
                                         S13(i,26,z)=S13(i,17,z);
                                     else
                                     end
                                     if S14(i,7,z)==1
                                         S14(i,26,z)=S14(i,17,z);
                                     else
                                     end
                                     S11(i,24,z)=B(i,17,z)*S11(i,18,z);
                                     S12(i,24,z)=B(i,17,z)*S12(i,18,z);
                                     S13(i,24,z)=B(i,17,z)*S13(i,18,z);
                                     S14(i,24,z)=B(i,17,z)*S14(i,18,z);
                                     S15(i,24,z)=B(i,17,z)*S15(i,18,z);
                                     B(i,26,z)=S11(i,24,z)+S12(i,24,z)+S13(i,24,z)+S14(i,24,z)+S15(i,24,z);                                     
                                 end
                             end
                         end
                     end
                 end
             else     %otherwise if S21 does not accept the squeeze of its customers
                 
                 if S11(i,9,z)==1              %the squeeze of S11 is not accepted by S21
                     S11(i,26,z)=S21(i,24,z);        %the purchase cost for S11 is the initial price of S21
                 end
                 if S12(i,9,z)==1
                     S12(i,26,z)=S21(i,24,z);
                 end
                 if S13(i,9,z)==1
                     S13(i,26,z)=S21(i,24,z);
                 end
                 if S14(i,9,z)==1
                     S14(i,26,z)=S21(i,24,z);    
                 end
                 if S15(i,9,z)==1
                     S15(i,26,z)=S21(i,24,z);
                 end
                 B(i,8,z)=0;
                 B(i,9,z)=1;     %since S21 has not accepted the squeeze also S11 S12 S13 S14 S15 reject the squeeze
                 
                 %if S11 attempted the squeeze but was not accepted then it compresses fixed costs and quotes                 
                 if S11(i,7,z)==1				 
					 if SqueezeLogic == 2 %cost reduction only without switch
						 S11(i,20,z)=S11(i,2,z)*random(triangolarecosti);
						 S11(i,21,z)=Q(i,z)*(B(i,17,z)*S11(i,18,z)*(1-S11(i,5,z))-S11(i,26,z));
						 if S11(i,20,z)<S11(i,21,z)    %if the compressed fixed costs are those that satisfy price and margin
							 S11(i,22,z)=B(i,17,z)*S11(i,18,z);
							 S11(i,25,z)=S11(i,21,z);
						 else   %otherwise if the compressed fixed costs are those for distribution
							 S11(i,22,z)=(S11(i,26,z)+S11(i,20,z)/Q(i,z))/(1-S11(i,5,z));
							 S11(i,25,z)=S11(i,20,z);
						 end
						 %accept it
						 S11(i,10,z)=1;
						 %need to update 24 indexed value with compresed (self or squeezed) value
						 %this will be used in calculating purchase cost of buyer 															
						 S11(i,24,z)=S11(i,22,z);	% previously, we have updated S11(i,22,z) value based on comparing 20,21 indexed values							 						 
					 elseif SqueezeLogic == 3 %switching without cost reduction	
						 S11(i,22,z)=(S11(i,26,z)+S11(i,2,z)/Q(i,z))/(1-S11(i,5,z)); %the price without cost reduction
						 %B compare quote with market price
						 S11(i,23,z)=(B(i,17,z)*S11(i,18,z))/random(triangolareswitch);
						 if S11(i,22,z)<S11(i,23,z)   %if quote is lower than the market price
							 %accept it
							 S11(i,10,z)=1;
							 %need to update 24 indexed value with compresed (self or squeezed) value
							 %this will be used in calculating purchase cost of buyer 															
							 S11(i,24,z)=S11(i,22,z);	% previously, we have updated S11(i,22,z) value based on comparing 20,21 indexed values							 
						 else
							 %B makes a switch of S11
							 S11(i,24,z)=S11(i,23,z);
							 S11(i,11,z)=1;
							 B(i,15,z)=B(i,15,z)+SW*S11(i,18,z)*B(i,2,z);
						 end 		
					 elseif SqueezeLogic == 4 % position (degree centrality score) and size/bargain power to reject
						S11(i,22,z)=B(i,17,z)*S11(i,18,z);				
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
						 else   %otherwise if the compressed fixed costs are those for distribution
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
							 %need to update 24 indexed value with compresed (self or squeezed) value
							 %this will be used in calculating purchase cost of buyer 				
							 S11(i,24,z)=S11(i,22,z); % previously, we have updated S11(i,22,z) value based on comparing 20,21 indexed values

							 if S11(i,20,z)<S11(i,21,z)    %if the compressed fixed costs are those that satisfy price and margin
								%modified compressed cost is less than squeezed cost of buyer - so accept it
								%B stays with his supplier							 
							 else
								%position (degree centrality score) + size (bargaining power)
								TotalPowerToReject = DegCentralityScores(2);
								if SqueezeLogic4Type == 2
									TotalPowerToReject = TotalPowerToReject + S11(i,14,z);					
								else
									TotalPowerToReject = TotalPowerToReject + AgentSizes(2);					
								end 							
								 if rand > TotalPowerToReject  %I value bargaining power
									%S11 adjusts to the market price and lowers its margin
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
						 else   %otherwise if the compressed fixed costs are those for distribution
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
							 %need to update 24 indexed value with compresed (self or squeezed) value
							 %this will be used in calculating purchase cost of buyer 				
							 S11(i,24,z)=S11(i,22,z); % previously, we have updated S11(i,22,z) value based on comparing 20,21 indexed values

							 if S11(i,20,z)<S11(i,21,z)    %if the compressed fixed costs are those that satisfy price and margin
								%modified compressed cost is less than squeezed cost of buyer - so accept it
								%B stays with his supplier							 
							 else
								 if rand>S11(i,14,z)  %I value bargaining power
									%S11 adjusts to the market price and lowers its margin
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
						 if S12(i,20,z)<S12(i,21,z)    %if the compressed fixed costs are those that satisfy price and margin
							 S12(i,22,z)=B(i,17,z)*S12(i,18,z);
							 S12(i,25,z)=S12(i,21,z);
						 else        %otherwise if the compressed fixed costs are the distribution ones
							 S12(i,22,z)=(S12(i,26,z)+S12(i,20,z)/Q(i,z))/(1-S12(i,5,z));
							 S12(i,25,z)=S12(i,20,z);
						 end
						 %accept it
						 S12(i,10,z)=1;
						 %need to update 24 indexed value with compresed (self or squeezed) value
						 %this will be used in calculating purchase cost of buyer 															
						 S12(i,24,z)=S12(i,22,z);	% previously, we have updated S12(i,22,z) value based on comparing 20,21 indexed values						 
					 elseif SqueezeLogic == 3 %switching without cost reduction	
						 S12(i,22,z)=(S12(i,26,z)+S12(i,2,z)/Q(i,z))/(1-S12(i,5,z)); %the price without cost reduction
						 %B compare quote with market price						 
						 S12(i,23,z)=(B(i,17,z)*S12(i,18,z))/random(triangolareswitch);						 
						 if S12(i,22,z)<S12(i,23,z)     %if quote is lower than the market price
							 %accept it
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
						S12(i,22,z)=B(i,17,z)*S12(i,18,z);				
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
						 if S12(i,20,z)<S12(i,21,z)    %if the compressed fixed costs are those that satisfy price and margin
							 S12(i,22,z)=B(i,17,z)*S12(i,18,z);
							 S12(i,25,z)=S12(i,21,z);
						 else        %otherwise if the compressed fixed costs are the distribution ones
							 S12(i,22,z)=(S12(i,26,z)+S12(i,20,z)/Q(i,z))/(1-S12(i,5,z));
							 S12(i,25,z)=S12(i,20,z);
						 end
						 
						 %B compare quote with market price						 
						 S12(i,23,z)=(B(i,17,z)*S12(i,18,z))/random(triangolareswitch);						 
						 if S12(i,22,z) > S12(i,23,z)     %if quote is greater than the market price
							 %B makes a switch of S12
							 S12(i,24,z)=S12(i,23,z);
							 S12(i,11,z)=1;
							 B(i,15,z)=B(i,15,z)+SW*S12(i,18,z)*B(i,2,z);
						 else      						 
							 %need to update 24 indexed value with compresed (self or squeezed) value
							 %this will be used in calculating purchase cost of buyer 				
							 S12(i,24,z)=S12(i,22,z);	% previously, we have updated S12(i,22,z) value based on comparing 20,21 indexed values

							 %the supplier compares compressed cost with squeezed cost of buyer
							 if S12(i,20,z)<S12(i,21,z)
								%modified compressed cost is less than squeezed cost of buyer - so accept it
								%B stays with his supplier
							 else	
								%position (degree centrality score) + size (bargaining power)
								TotalPowerToReject = DegCentralityScores(3);
								if SqueezeLogic4Type == 2
									TotalPowerToReject = TotalPowerToReject + S12(i,14,z);					
								else
									TotalPowerToReject = TotalPowerToReject + AgentSizes(3);					
								end 
								 if rand > TotalPowerToReject   %I value bargaining power
									 %S12 adjusts to the market price and lowers its margin
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
						 if S12(i,20,z)<S12(i,21,z)    %if the compressed fixed costs are those that satisfy price and margin
							 S12(i,22,z)=B(i,17,z)*S12(i,18,z);
							 S12(i,25,z)=S12(i,21,z);
						 else        %otherwise if the compressed fixed costs are the distribution ones
							 S12(i,22,z)=(S12(i,26,z)+S12(i,20,z)/Q(i,z))/(1-S12(i,5,z));
							 S12(i,25,z)=S12(i,20,z);
						 end
						 
						 %B compare quote with market price						 
						 S12(i,23,z)=(B(i,17,z)*S12(i,18,z))/random(triangolareswitch);						 
						 if S12(i,22,z) > S12(i,23,z)     %if quote is greater than the market price
							 %B makes a switch of S12
							 S12(i,24,z)=S12(i,23,z);
							 S12(i,11,z)=1;
							 B(i,15,z)=B(i,15,z)+SW*S12(i,18,z)*B(i,2,z);
						 else      						 
							 %need to update 24 indexed value with compresed (self or squeezed) value
							 %this will be used in calculating purchase cost of buyer 				
							 S12(i,24,z)=S12(i,22,z);	% previously, we have updated S12(i,22,z) value based on comparing 20,21 indexed values

							 %the supplier compares compressed cost with squeezed cost of buyer
							 if S12(i,20,z)<S12(i,21,z)
								%modified compressed cost is less than squeezed cost of buyer - so accept it
								%B stays with his supplier
							 else	
								 if rand>S12(i,14,z)    %I value bargaining power
									%S12 adjusts to the market price and lowers its margin
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
                 
                 %S13 if attempted the squeeze but was not accepted, it saves costs
                 if S13(i,7,z)==1
					 if SqueezeLogic == 2 %cost reduction only without switch
						 S13(i,20,z)=S13(i,2,z)*random(triangolarecosti);
						 S13(i,21,z)=Q(i,z)*(B(i,17,z)*S13(i,18,z)*(1-S13(i,5,z))-S13(i,26,z));
						 if S13(i,20,z)<S13(i,21,z)     %if the compressed fixed costs are those that satisfy price and margin
							 S13(i,22,z)=B(i,17,z)*S13(i,18,z);
							 S13(i,25,z)=S13(i,21,z);
						 else         %otherwise if the compressed fixed costs are those for distribution
							 S13(i,22,z)=(S13(i,26,z)+S13(i,20,z)/Q(i,z))/(1-S13(i,5,z));
							 S13(i,25,z)=S13(i,20,z);
						 end						 
						 %B stays with his supplier
						 S13(i,10,z)=1;
						 %need to update 24 indexed value with compresed (self or squeezed) value
						 %this will be used in calculating purchase cost of buyer 															
						 S13(i,24,z)=S13(i,22,z); % previously, we have updated S13(i,22,z) value based on comparing 20,21 indexed value							 
					 elseif SqueezeLogic == 3 %switching without cost reduction	
						  S13(i,22,z)=(S13(i,26,z)+S13(i,2,z)/Q(i,z))/(1-S13(i,5,z)); %the price without cost reduction
						  %B compare quote with market price
						  S13(i,23,z)=(B(i,17,z)*S13(i,18,z))/random(triangolareswitch);
						  if S13(i,22,z)<S13(i,23,z)    %if quote is lower than the market price
							 %B stays with his supplier
							 S13(i,10,z)=1;
							 %need to update 24 indexed value with compresed (self or squeezed) value
							 %this will be used in calculating purchase cost of buyer 															
							 S13(i,24,z)=S13(i,22,z); % previously, we have updated S13(i,22,z) value based on comparing 20,21 indexed value							 
						  else
							  %B makes a switch of S13
							  S13(i,24,z)=S13(i,23,z);
							  S13(i,11,z)=1;
							  B(i,15,z)=B(i,15,z)+SW*S13(i,18,z)*B(i,2,z);
						  end 						  
					 elseif SqueezeLogic == 4 % position (degree centrality score) and size/bargain power to reject
						S13(i,22,z)=B(i,17,z)*S13(i,18,z);				
						%position (degree centrality score) + size (bargaining power)
						TotalPowerToReject = DegCentralityScores(4);
						if SqueezeLogic4Type == 2
							TotalPowerToReject = TotalPowerToReject + S13(i,14,z);					
						else
							TotalPowerToReject = TotalPowerToReject + AgentSizes(4);					
						end 							
						if TotalPowerToReject >= rand                     
							%reject the squeezed offer
							S13(i,40,z)=S13(i,22,z);
							B(i,15,z)=B(i,15,z)+S13(i,22,z); % since exit, therefore applying penalty
							S13(i,41,z)=Q(i,z);			
							S13(i,42,z)=1;
							S13(i,50,z)=1;
						else
							%need to update 24 indexed value with squeezed value
							%this will be used in calculating purchase cost of buyer 				
							S13(i,24,z)=S13(i,22,z);				
							%S13 accepts the squeezed price
							S13(i,6,z)=1;
						end 					 
					 elseif SqueezeLogic == 5 % new squeeze logic 2, 3, & 4 all together
						 S13(i,20,z)=S13(i,2,z)*random(triangolarecosti);
						 S13(i,21,z)=Q(i,z)*(B(i,17,z)*S13(i,18,z)*(1-S13(i,5,z))-S13(i,26,z));
						 S13(i,10,z)=1;
						 if S13(i,20,z)<S13(i,21,z)     %if the compressed fixed costs are those that satisfy price and margin
							 S13(i,22,z)=B(i,17,z)*S13(i,18,z);
							 S13(i,25,z)=S13(i,21,z);
						 else         %otherwise if the compressed fixed costs are those for distribution
							 S13(i,22,z)=(S13(i,26,z)+S13(i,20,z)/Q(i,z))/(1-S13(i,5,z));
							 S13(i,25,z)=S13(i,20,z);
						 end
						 
						  %B compare quote with market price
						  S13(i,23,z)=(B(i,17,z)*S13(i,18,z))/random(triangolareswitch);						  
						  if S13(i,22,z) > S13(i,23,z)    %if quote is greater than the market price
							  %B makes a switch of S13
							  S13(i,24,z)=S13(i,23,z);
							  S13(i,11,z)=1;
							  B(i,15,z)=B(i,15,z)+SW*S13(i,18,z)*B(i,2,z);
						  else       
							 %need to update 24 indexed value with compresed (self or squeezed) value
							 %this will be used in calculating purchase cost of buyer 				
							 S13(i,24,z)=S13(i,22,z); % previously, we have updated S13(i,22,z) value based on comparing 20,21 indexed values
						  
							 %the supplier compares compressed cost with squeezed cost of buyer
							 if S13(i,20,z)<S13(i,21,z)     %if the compressed fixed costs are those that satisfy price and margin						  
								%modified compressed cost is less than squeezed cost of buyer - so accept it
								%B stays with his supplier
							 else
								  %position (degree centrality score) + size (bargaining power)
								  TotalPowerToReject = DegCentralityScores(4);
								  if SqueezeLogic4Type == 2
									TotalPowerToReject = TotalPowerToReject + S13(i,14,z);					
								  else
									TotalPowerToReject = TotalPowerToReject + AgentSizes(4);					
								  end 							

								  if rand > TotalPowerToReject     %I value bargaining power
									 %S13 adjusts to the market price and lowers its margin
									 S13(i,16,z)=1;
								  else           
									 %reject the squeezed offer
									 S13(i,40,z)=S13(i,22,z);
									 B(i,15,z)=B(i,15,z)+S13(i,22,z); % since exit, therefore applying penalty
									 S13(i,41,z)=Q(i,z);			
									 S13(i,42,z)=1;
									 S13(i,50,z)=1;									 
								  end
							 end							 
						  end
					 else %all previous logics together 
						 S13(i,20,z)=S13(i,2,z)*random(triangolarecosti);
						 S13(i,21,z)=Q(i,z)*(B(i,17,z)*S13(i,18,z)*(1-S13(i,5,z))-S13(i,26,z));
						 S13(i,10,z)=1;
						 if S13(i,20,z)<S13(i,21,z)     %if the compressed fixed costs are those that satisfy price and margin
							 S13(i,22,z)=B(i,17,z)*S13(i,18,z);
							 S13(i,25,z)=S13(i,21,z);
						 else         %otherwise if the compressed fixed costs are those for distribution
							 S13(i,22,z)=(S13(i,26,z)+S13(i,20,z)/Q(i,z))/(1-S13(i,5,z));
							 S13(i,25,z)=S13(i,20,z);
						 end
						 
						  %B compare quote with market price
						  S13(i,23,z)=(B(i,17,z)*S13(i,18,z))/random(triangolareswitch);						  
						  if S13(i,22,z) > S13(i,23,z)    %if quote is greater than the market price
							  %B makes a switch of S13
							  S13(i,24,z)=S13(i,23,z);
							  S13(i,11,z)=1;
							  B(i,15,z)=B(i,15,z)+SW*S13(i,18,z)*B(i,2,z);
						  else       
							 %need to update 24 indexed value with compresed (self or squeezed) value
							 %this will be used in calculating purchase cost of buyer 				
							 S13(i,24,z)=S13(i,22,z); % previously, we have updated S13(i,22,z) value based on comparing 20,21 indexed values
						  
							 %the supplier compares compressed cost with squeezed cost of buyer
							 if S13(i,20,z)<S13(i,21,z)     %if the compressed fixed costs are those that satisfy price and margin						  
								%modified compressed cost is less than squeezed cost of buyer - so accept it
								%B stays with his supplier
							 else
								  if rand>S13(i,14,z)     %I value bargaining power
									 %S13 adjusts to the market price and lowers its margin
									 S13(i,16,z)=1;
								  else           
									 %reject the squeezed offer
									 S13(i,40,z)=S13(i,22,z);
									 B(i,15,z)=B(i,15,z)+S13(i,22,z); % since exit, therefore applying penalty
									 S13(i,41,z)=Q(i,z);			
									 S13(i,42,z)=1;							
								  end
							 end							 						  
						  end
					 end 
                 else
                 end
                 
                 %S14 if attempted the squeeze but was not accepted it will save costs
                 if S14(i,7,z)==1
					 if SqueezeLogic == 2 %cost reduction only without switch
						  S14(i,20,z)=S14(i,2,z)*random(triangolarecosti);
						  S14(i,21,z)=Q(i,z)*(B(i,17,z)*S14(i,18,z)*(1-S14(i,5,z))-S14(i,26,z));
						  if S14(i,20,z)<S14(i,21,z)     %if the compressed fixed costs are those that satisfy price and margin
							  S14(i,22,z)=B(i,17,z)*S14(i,18,z);
							  S14(i,25,z)=S14(i,21,z);
						  else        %otherwise if the compressed fixed costs are those for distribution
							  S14(i,22,z)=(S14(i,26,z)+S14(i,20,z)/Q(i,z))/(1-S14(i,5,z));
							  S14(i,25,z)=S14(i,20,z);
						  end
						  %accept it
						  S14(i,10,z)=1;
						  %need to update 24 indexed value with compresed (self or squeezed) value
						  %this will be used in calculating purchase cost of buyer 															
						  S14(i,24,z)=S14(i,22,z);	% previously, we have updated S14(i,22,z) value based on comparing 20,21 indexed values
					 elseif SqueezeLogic == 3 %switching without cost reduction	
						  S14(i,22,z)=(S14(i,26,z)+S14(i,2,z)/Q(i,z))/(1-S14(i,5,z)); %the price without cost reduction
						   %B compare quote with market price						   
						   S14(i,23,z)=(B(i,17,z)*S14(i,18,z))/random(triangolareswitch);						   
						   if S14(i,22,z)<S14(i,23,z)      %if quote is lower than the market price
								%accept it
								S14(i,10,z)=1;
								%need to update 24 indexed value with compresed (self or squeezed) value
								%this will be used in calculating purchase cost of buyer 															
								S14(i,24,z)=S14(i,22,z);	% previously, we have updated S14(i,22,z) value based on comparing 20,21 indexed values
						   else
							   %B makes a switch of S14
							   S14(i,24,z)=S14(i,23,z);
							   S14(i,11,z)=1;
							   B(i,15,z)=B(i,15,z)+SW*S14(i,18,z)*B(i,2,z);
						   end 
					 elseif SqueezeLogic == 4 % position (degree centrality score) and size/bargain power to reject
							S14(i,22,z)=B(i,17,z)*S14(i,18,z);				
							%position (degree centrality score) + size (bargaining power)
							TotalPowerToReject = DegCentralityScores(5);
							if SqueezeLogic4Type == 2
								TotalPowerToReject = TotalPowerToReject + S14(i,14,z);					
							else
								TotalPowerToReject = TotalPowerToReject + AgentSizes(5);					
							end 
							if TotalPowerToReject >= rand                     
								%reject the squeezed offer
								S14(i,40,z)=S14(i,22,z);
								B(i,15,z)=B(i,15,z)+S14(i,22,z); % since exit, therefore applying penalty
								S14(i,41,z)=Q(i,z);			
								S14(i,42,z)=1;
								S14(i,50,z)=1;
							else
								%need to update 24 indexed value with squeezed value
								%this will be used in calculating purchase cost of buyer 				
								S14(i,24,z)=S14(i,22,z);				
								%S14 accepts the squeezed price
								S14(i,6,z)=1;
							end 					 
					 elseif SqueezeLogic == 5 % new squeeze logic 2, 3, & 4 all together
						  S14(i,20,z)=S14(i,2,z)*random(triangolarecosti);
						  S14(i,21,z)=Q(i,z)*(B(i,17,z)*S14(i,18,z)*(1-S14(i,5,z))-S14(i,26,z)); 
						  S14(i,10,z)=1;
						  if S14(i,20,z)<S14(i,21,z)     %if the compressed fixed costs are those that satisfy price and margin
							  S14(i,22,z)=B(i,17,z)*S14(i,18,z);
							  S14(i,25,z)=S14(i,21,z);
						  else        %otherwise if the compressed fixed costs are those for distribution
							  S14(i,22,z)=(S14(i,26,z)+S14(i,20,z)/Q(i,z))/(1-S14(i,5,z));
							  S14(i,25,z)=S14(i,20,z);
						  end
						  
						   %B compare quote with market price						   
						   S14(i,23,z)=(B(i,17,z)*S14(i,18,z))/random(triangolareswitch);
						   if S14(i,22,z) > S14(i,23,z)      %if quote is greater than the market price
							   %B makes a switch of S14
							   S14(i,24,z)=S14(i,23,z);
							   S14(i,11,z)=1;
							   B(i,15,z)=B(i,15,z)+SW*S14(i,18,z)*B(i,2,z);
						   else         
								%need to update 24 indexed value with compresed (self or squeezed) value
								%this will be used in calculating purchase cost of buyer 				
								S14(i,24,z)=S14(i,22,z);	% previously, we have updated S14(i,22,z) value based on comparing 20,21 indexed values
								
								%the supplier compares compressed cost with squeezed cost of buyer
								if S14(i,20,z)<S14(i,21,z)     %if the compressed fixed costs are those that satisfy price and margin
								   %modified compressed cost is less than squeezed cost of buyer - so accept it
								   %B stays with his supplier
								else
									%position (degree centrality score) + size (bargaining power)
									TotalPowerToReject = DegCentralityScores(5);
									if SqueezeLogic4Type == 2
										TotalPowerToReject = TotalPowerToReject + S14(i,14,z);					
									else
										TotalPowerToReject = TotalPowerToReject + AgentSizes(5);					
									end 								
								   if rand > TotalPowerToReject     %I value bargaining power
									   %S14 adjusts to the market price and lowers its margin	
									   S14(i,16,z)=1;
								   else        
										%reject the squeezed offer
										S14(i,40,z)=S14(i,22,z);
										B(i,15,z)=B(i,15,z)+S14(i,22,z); % since exit, therefore applying penalty
										S14(i,41,z)=Q(i,z);			
										S14(i,42,z)=1;							
										S14(i,50,z)=1;																	
								   end
							    end 			
							end 
					 else %all previous logics together 
						  S14(i,20,z)=S14(i,2,z)*random(triangolarecosti);
						  S14(i,21,z)=Q(i,z)*(B(i,17,z)*S14(i,18,z)*(1-S14(i,5,z))-S14(i,26,z)); 
						  S14(i,10,z)=1;
						  if S14(i,20,z)<S14(i,21,z)     %if the compressed fixed costs are those that satisfy price and margin
							  S14(i,22,z)=B(i,17,z)*S14(i,18,z);
							  S14(i,25,z)=S14(i,21,z);
						  else        %otherwise if the compressed fixed costs are those for distribution
							  S14(i,22,z)=(S14(i,26,z)+S14(i,20,z)/Q(i,z))/(1-S14(i,5,z));
							  S14(i,25,z)=S14(i,20,z);
						  end
						  
						   %B compare quote with market price						   
						   S14(i,23,z)=(B(i,17,z)*S14(i,18,z))/random(triangolareswitch);
						   if S14(i,22,z) > S14(i,23,z)      %if quote is greater than the market price
							   %B makes a switch of S14
							   S14(i,24,z)=S14(i,23,z);
							   S14(i,11,z)=1;
							   B(i,15,z)=B(i,15,z)+SW*S14(i,18,z)*B(i,2,z);
						   else         
								%need to update 24 indexed value with compresed (self or squeezed) value
								%this will be used in calculating purchase cost of buyer 				
								S14(i,24,z)=S14(i,22,z);	% previously, we have updated S14(i,22,z) value based on comparing 20,21 indexed values
								
								%the supplier compares compressed cost with squeezed cost of buyer
								if S14(i,20,z)<S14(i,21,z)     %if the compressed fixed costs are those that satisfy price and margin
								   %modified compressed cost is less than squeezed cost of buyer - so accept it
								   %B stays with his supplier
								else
								   if rand>S14(i,14,z)     %I value bargaining power
									   %S14 adjusts to the market price and lowers its margin
									   S14(i,16,z)=1;
								   else        
										%reject the squeezed offer
										S14(i,40,z)=S14(i,22,z);
										B(i,15,z)=B(i,15,z)+S14(i,22,z); % since exit, therefore applying penalty
										S14(i,41,z)=Q(i,z);			
										S14(i,42,z)=1;							
								   end
							    end 			
							end 
					 end 	   
                 else
                 end
                 
                 %S15 if attempted the squeeze but was not accepted it will save costs
                 if S15(i,7,z)==1
					 if SqueezeLogic == 2 %cost reduction only without switch
						 S15(i,20,z)=S15(i,2,z)*random(triangolarecosti);
						 S15(i,21,z)=Q(i,z)*(B(i,17,z)*S15(i,18,z)*(1-S15(i,5,z))-S15(i,26,z));
						 if S15(i,20,z)<S15(i,21,z)      %if the compressed fixed costs are those that satisfy price and margin
							 S15(i,22,z)=B(i,17,z)*S15(i,18,z);
							 S15(i,25,z)=S15(i,21,z);
						 else           %otherwise if the compressed fixed costs are the distribution ones
							 S15(i,22,z)=(S15(i,26,z)+S15(i,20,z)/Q(i,z))/(1-S15(i,5,z));
							 S15(i,25,z)=S15(i,20,z);
						 end
						 %accept it
						 S15(i,10,z)=1;
						 %need to update 24 indexed value with compresed (self or squeezed) value
						 %this will be used in calculating purchase cost of buyer 															
						 S15(i,24,z)=S15(i,22,z);	% previously, we have updated S15(i,22,z) value based on comparing 20,21 indexed values 							 
					 elseif SqueezeLogic == 3 %switching without cost reduction	
						 S15(i,22,z)=(S15(i,26,z)+S15(i,2,z)/Q(i,z))/(1-S15(i,5,z)); %the price without cost reduction
						 %B compare quote with market price
						 S15(i,23,z)=(B(i,17,z)*S15(i,18,z))/random(triangolareswitch);						 
						 if S15(i,22,z)<S15(i,23,z)         %if quote is lower than the market price
							%accept it
							S15(i,10,z)=1;
							%need to update 24 indexed value with compresed (self or squeezed) value
							%this will be used in calculating purchase cost of buyer 															
							S15(i,24,z)=S15(i,22,z);	% previously, we have updated S15(i,22,z) value based on comparing 20,21 indexed values 
						 else
							%B makes a switch of S15
							S15(i,24,z)=S15(i,23,z);
							S15(i,11,z)=1;
							B(i,15,z)=B(i,15,z)+SW*S15(i,18,z)*B(i,2,z);
						 end 	
					 elseif SqueezeLogic == 4 % position (degree centrality score) and size/bargain power to reject
						S15(i,22,z)=B(i,17,z)*S15(i,18,z);				
						%position (degree centrality score) + size (bargaining power)
						TotalPowerToReject = DegCentralityScores(6);
						if SqueezeLogic4Type == 2
							TotalPowerToReject = TotalPowerToReject + S15(i,14,z);					
						else
							TotalPowerToReject = TotalPowerToReject + AgentSizes(6);					
						end 
						if TotalPowerToReject >= rand                     
							%reject the squeezed offer
							S15(i,40,z)=S15(i,22,z);
							B(i,15,z)=B(i,15,z)+S15(i,22,z); % since exit, therefore applying penalty
							S15(i,41,z)=Q(i,z);			
							S15(i,42,z)=1;
							S15(i,50,z)=1;
						else
							%need to update 24 indexed value with squeezed value
							%this will be used in calculating purchase cost of buyer 				
							S15(i,24,z)=S15(i,22,z);				
							%S15 accepts the squeezed price
							S15(i,6,z)=1;
						end 
					 elseif SqueezeLogic == 5 % new squeeze logic 2, 3, & 4 all together
						 S15(i,20,z)=S15(i,2,z)*random(triangolarecosti);
						 S15(i,21,z)=Q(i,z)*(B(i,17,z)*S15(i,18,z)*(1-S15(i,5,z))-S15(i,26,z));
						 S15(i,10,z)=1;
						 if S15(i,20,z)<S15(i,21,z)      %if the compressed fixed costs are those that satisfy price and margin
							 S15(i,22,z)=B(i,17,z)*S15(i,18,z);
							 S15(i,25,z)=S15(i,21,z);
						 else           %otherwise if the compressed fixed costs are the distribution ones
							 S15(i,22,z)=(S15(i,26,z)+S15(i,20,z)/Q(i,z))/(1-S15(i,5,z));
							 S15(i,25,z)=S15(i,20,z);
						 end
							 
						 %B compare quote with market price
						 S15(i,23,z)=(B(i,17,z)*S15(i,18,z))/random(triangolareswitch);						 
						 if S15(i,22,z) > S15(i,23,z)         %if quote is greater than the market price
							 %B makes a switch of S15
							 S15(i,24,z)=S15(i,23,z);
							 S15(i,11,z)=1;
							 B(i,15,z)=B(i,15,z)+SW*S15(i,18,z)*B(i,2,z);
						 else        
							 %need to update 24 indexed value with compresed (self or squeezed) value
							 %this will be used in calculating purchase cost of buyer 				
							 S15(i,24,z)=S15(i,22,z); % previously, we have updated S15(i,22,z) value based on comparing 20,21 indexed values
							 
							 %the supplier compares compressed cost with squeezed cost of buyer
							 if S15(i,20,z)<S15(i,21,z)      %if the compressed fixed costs are those that satisfy price and margin
								 %modified compressed cost is less than squeezed cost of buyer - so accept it
								 %B stays with his supplier							 
							 else
								%position (degree centrality score) + size (bargaining power)
								TotalPowerToReject = DegCentralityScores(6);
								if SqueezeLogic4Type == 2
									TotalPowerToReject = TotalPowerToReject + S15(i,14,z);					
								else
									TotalPowerToReject = TotalPowerToReject + AgentSizes(6);					
								end 
								 if rand > TotalPowerToReject     %I value bargaining power
								     %S15 adjusts to the market price and lowers its margin
									 S15(i,16,z)=1;
								 else    
									%reject the squeezed offer
									S15(i,40,z)=S15(i,22,z);
									B(i,15,z)=B(i,15,z)+S15(i,22,z); % since exit, therefore applying penalty
									S15(i,41,z)=Q(i,z);			
									S15(i,42,z)=1;															 
									S15(i,50,z)=1;
								 end							 
							 end 							 							 
						 end
					 else %all previous logics together 
						 S15(i,20,z)=S15(i,2,z)*random(triangolarecosti);
						 S15(i,21,z)=Q(i,z)*(B(i,17,z)*S15(i,18,z)*(1-S15(i,5,z))-S15(i,26,z));
						 S15(i,10,z)=1;
						 if S15(i,20,z)<S15(i,21,z)      %if the compressed fixed costs are those that satisfy price and margin
							 S15(i,22,z)=B(i,17,z)*S15(i,18,z);
							 S15(i,25,z)=S15(i,21,z);
						 else           %otherwise if the compressed fixed costs are the distribution ones
							 S15(i,22,z)=(S15(i,26,z)+S15(i,20,z)/Q(i,z))/(1-S15(i,5,z));
							 S15(i,25,z)=S15(i,20,z);
						 end
							 
						 %B compare quote with market price
						 S15(i,23,z)=(B(i,17,z)*S15(i,18,z))/random(triangolareswitch);						 
						 if S15(i,22,z) > S15(i,23,z)         %if quote is greater than the market price
							 %B makes a switch of S15
							 S15(i,24,z)=S15(i,23,z);
							 S15(i,11,z)=1;
							 B(i,15,z)=B(i,15,z)+SW*S15(i,18,z)*B(i,2,z);
						 else        
							 %need to update 24 indexed value with compresed (self or squeezed) value
							 %this will be used in calculating purchase cost of buyer 				
							 S15(i,24,z)=S15(i,22,z); % previously, we have updated S15(i,22,z) value based on comparing 20,21 indexed values
							 
							 %the supplier compares compressed cost with squeezed cost of buyer
							 if S15(i,20,z)<S15(i,21,z)      %if the compressed fixed costs are those that satisfy price and margin
								 %modified compressed cost is less than squeezed cost of buyer - so accept it
								 %B stays with his supplier							 
							 else
								 if rand>S15(i,14,z)     %I value bargaining power
								     %S15 adjusts to the market price and lowers its margin
									 S15(i,16,z)=1;
								 else    
									%reject the squeezed offer
									S15(i,40,z)=S15(i,22,z);
									B(i,15,z)=B(i,15,z)+S15(i,22,z); % since exit, therefore applying penalty
									S15(i,41,z)=Q(i,z);			
									S15(i,42,z)=1;															 
								 end							 
							 end 							 							 
						 end
					 end 	 
                 else
                 end
                 
                 B(i,26,z)=S11(i,24,z)+S12(i,24,z)+S13(i,24,z)+S14(i,24,z)+S15(i,24,z);
             end
         end
		 
		%following things are updated lastly 
		%as previous if if S11(i,7,z)==1 || S12(i,7,z)==1 || S13(i,7,z)==1 || S14(i,7,z)==1 || S15(i,7,z)==1 are doing some mix works
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
		 
		if S13(i,49,z) == 1
             %S13 accepts despite the target margin is not reached
             S13(i,6,z)=1;
             S13(i,24,z)=B(i,17,z)*S13(i,18,z);
             S13(i,27,z)=S13(i,19,z);
		end 

		if S14(i,49,z) == 1
             %S14 accepts despite the target margin is not reached
             S14(i,6,z)=1;
             S14(i,24,z)=B(i,17,z)*S14(i,18,z);
             S14(i,27,z)=S14(i,19,z);             
		end 			

		if S15(i,49,z) == 1
             %S15 accepts despite the target margin is not reached
             S15(i,6,z)=1;
             S15(i,24,z)=B(i,17,z)*S15(i,18,z);
             S15(i,27,z)=S15(i,19,z);
		end 		 
		 
     end
else
    exit=1;
    S11(i,28,z)=1;
    S12(i,28,z)=1;
    S13(i,28,z)=1;
    S14(i,28,z)=1;
    S15(i,28,z)=1;
end
         
     
                         
                             
                     
                               
                               
                     
                 
                 
                              
                             
                     
                 
                 
                             
                             
                     
                 
                 
                                     
                                     
                             
                         
                         
                     
                     
                     
                     
             
           
    
    
    
    