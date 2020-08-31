%AlgorithmRM1_RM2_RM3_RM4_RM5
S21(i,7,z)=1;
%I calculate the choked price that S21 is willing to spend (its variable costs)
if Decision(i,1,z)==1
    S21(i,17,z)=(S11(i,17,z)*(1-S21(i,5,z))-S21(i,25,z)/Q(i,z));
end
if Decision(i,1,z)==2
    S21(i,17,z)=(S12(i,17,z)*(1-S21(i,5,z))-S21(i,25,z)/Q(i,z));
end
if S21(i,17,z)>0
    
    %I calculate the percentage distribution of the squeeze on RM1 RM2 RM3 RM4 RM5
    RM1(i,18,z)=RM1(i,1,z)/S21(i,3,z);
    RM2(i,18,z)=RM2(i,1,z)/S21(i,3,z);
    RM3(i,18,z)=RM3(i,1,z)/S21(i,3,z);
    RM4(i,18,z)=RM4(i,1,z)/S21(i,3,z);
    RM5(i,18,z)=RM5(i,1,z)/S21(i,3,z);
    
    %I calculate profit margins in relation to the choked price of S21
    RM1(i,19,z)=(S21(i,17,z)*RM1(i,18,z)-RM1(i,2,z)/Q(i,z)-RM1(i,3,z))/(S21(i,17,z)*RM1(i,18,z));
    RM2(i,19,z)=(S21(i,17,z)*RM2(i,18,z)-RM2(i,2,z)/Q(i,z)-RM2(i,3,z))/(S21(i,17,z)*RM2(i,18,z));
    RM3(i,19,z)=(S21(i,17,z)*RM3(i,18,z)-RM3(i,2,z)/Q(i,z)-RM3(i,3,z))/(S21(i,17,z)*RM3(i,18,z));
    RM4(i,19,z)=(S21(i,17,z)*RM4(i,18,z)-RM4(i,2,z)/Q(i,z)-RM4(i,3,z))/(S21(i,17,z)*RM4(i,18,z));
    RM5(i,19,z)=(S21(i,17,z)*RM5(i,18,z)-RM5(i,2,z)/Q(i,z)-RM5(i,3,z))/(S21(i,17,z)*RM5(i,18,z));
    
    %control six target profit margins are achieved
    if RM1(i,19,z)>RM1(i,5,z) & RM2(i,19,z)>RM2(i,5,z) & RM3(i,19,z)>RM3(i,5,z) & RM4(i,19,z)>RM4(i,5,z) & RM5(i,19,z)>RM5(i,5,z)
        %the structure does not change and the squeeze is accepted
        S21(i,8,z)=1;
        RM1(i,24,z)=S21(i,17,z)*RM1(i,18,z);
        RM2(i,24,z)=S21(i,17,z)*RM2(i,18,z);
        RM3(i,24,z)=S21(i,17,z)*RM3(i,18,z);
        RM4(i,24,z)=S21(i,17,z)*RM4(i,18,z);
        RM5(i,24,z)=S21(i,17,z)*RM5(i,18,z);
        RM1(i,27,z)=RM1(i,19,z);
        RM2(i,27,z)=RM2(i,19,z);
        RM3(i,27,z)=RM3(i,19,z);
        RM4(i,27,z)=RM4(i,19,z);
        RM5(i,27,z)=RM5(i,19,z);
    else
        
        if RM1(i,19,z)>RM1(i,5,z) 
            %RM1 reaches its margin and accepts
            RM1(i,6,z)=1;
            RM1(i,24,z)=S21(i,17,z)*RM1(i,18,z);
            RM1(i,27,z)=RM1(i,19,z);
        else
            S21(i,9,z)=1;            %The squeeze is not fully accepted
            S21(i,8,z)=0;           %Required because it may have been changed to 1 earlier
			
			if SqueezeLogic == 2 %cost reduction only without switch
				%RM1 compresses fixed costs and makes a quote            
				RM1(i,20,z)=RM1(i,2,z)*random(triangolarecosti);      %fixed costs of RM1 modified randomly (triangular)
				RM1(i,21,z)=Q(i,z)*(S21(i,17,z)*RM1(i,18,z)*(1-RM1(i,5,z))-RM1(i,26,z));  %fixed costs of RM1 to reach the target with the squeezed price
				
				if RM1(i,20,z)<RM1(i,21,z)
					RM1(i,22,z)=S21(i,17,z)*RM1(i,18,z);
					RM1(i,25,z)=RM1(i,21,z);
				else
					RM1(i,22,z)=(RM1(i,26,z)+RM1(i,20,z)/Q(i,z))/(1-RM1(i,5,z));
					RM1(i,25,z)=RM1(i,20,z);
				end
				%accept it
				%S21 stays with the old supplier
				RM1(i,10,z)=1;
				%need to update 24 indexed value with compresed (self or squeezed) value
				%this will be used in calculating purchase cost of buyer 							
				RM1(i,24,z)=RM1(i,22,z); % previously, we have updated RM1(i,22,z) value based on comparing 20,21 indexed values			
			elseif SqueezeLogic == 3 %switching without cost reduction	
				RM1(i,22,z)=(RM1(i,26,z)+RM1(i,2,z)/Q(i,z))/(1-RM1(i,5,z)); %the price without cost reduction  
				%S21 compares the quote with the market price
				RM1(i,23,z)=(S21(i,17,z)*RM1(i,18,z))/random(triangolareswitch);
				if RM1(i,22,z)<RM1(i,23,z)         %if quote is lower than market price
					%accept it
					%S21 stays with the old supplier
					RM1(i,10,z)=1;
					%need to update 24 indexed value with compresed (self or squeezed) value
					%this will be used in calculating purchase cost of buyer 							
					RM1(i,24,z)=RM1(i,22,z); % previously, we have updated RM1(i,22,z) value based on comparing 20,21 indexed values			
				else
					%S21 makes a switch of RM1
					RM1(i,24,z)=RM1(i,23,z);
					RM1(i,11,z)=1;
					S21(i,15,z)=S21(i,15,z)+SW*RM1(i,18,z)*S21(i,2,z);
				end 					
			elseif SqueezeLogic == 4 % position (degree centrality score) and size/bargain power to reject
				RM1(i,22,z)=S21(i,17,z)*RM1(i,18,z);  %the squeezed (by supplier) one (e.g., indexed by 21) 
				%position (degree centrality score) + size (bargaining power)
				TotalPowerToReject = DegCentralityScores(5);
				if SqueezeLogic4Type == 2
					TotalPowerToReject = TotalPowerToReject + RM1(i,14,z);					
				else
					TotalPowerToReject = TotalPowerToReject + AgentSizes(5);					
				end 
				if TotalPowerToReject >= rand                      
					%reject the squeezed offer
					RM1(i,40,z)=RM1(i,22,z);
					S21(i,15,z)=S21(i,15,z)+RM1(i,22,z); % since exit, therefore applying penalty
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
			elseif SqueezeLogic == 5 % new squeeze logic 2, 3, & 4 all together
				%RM1 compresses fixed costs and makes a quote            
				RM1(i,20,z)=RM1(i,2,z)*random(triangolarecosti);      %fixed costs of RM1 modified randomly (triangular)
				RM1(i,21,z)=Q(i,z)*(S21(i,17,z)*RM1(i,18,z)*(1-RM1(i,5,z))-RM1(i,26,z));  %fixed costs of RM1 to reach the target with the squeezed price
				RM1(i,10,z)=1;
				if RM1(i,20,z)<RM1(i,21,z)
					RM1(i,22,z)=S21(i,17,z)*RM1(i,18,z);
					RM1(i,25,z)=RM1(i,21,z);
				else
					RM1(i,22,z)=(RM1(i,26,z)+RM1(i,20,z)/Q(i,z))/(1-RM1(i,5,z));
					RM1(i,25,z)=RM1(i,20,z);
				end
				
				%S21 compares the quote with the market price
				 RM1(i,23,z)=(S21(i,17,z)*RM1(i,18,z))/random(triangolareswitch);
				 if RM1(i,22,z) > RM1(i,23,z)         %if quote is greater than market price
					 %S21 makes a switch of RM1
					 RM1(i,24,z)=RM1(i,23,z);
					 RM1(i,11,z)=1;
					 S21(i,15,z)=S21(i,15,z)+SW*RM1(i,18,z)*S21(i,2,z);
				 else 
					 %need to update 24 indexed value with compresed (self or squeezed) value
					 %this will be used in calculating purchase cost of buyer 						
					 RM1(i,24,z)=RM1(i,22,z);  % previously, we have updated RM1(i,22,z) value based on comparing 20,21 indexed values

					 %the supplier compares compressed cost with squeezed cost of buyer
					 if RM1(i,20,z)<RM1(i,21,z)			
						%modified compressed cost is less than squeezed cost of buyer - so accept it					 
						%S21 stays with the old supplier
					 else
						%S21 stays with the old supplier based on bargaining power 
						%position (degree centrality score) + size (bargaining power)
						TotalPowerToReject = DegCentralityScores(5);
						if SqueezeLogic4Type == 2
							TotalPowerToReject = TotalPowerToReject + RM1(i,14,z);					
						else
							TotalPowerToReject = TotalPowerToReject + AgentSizes(5);					
						end 

						 if rand > TotalPowerToReject     %I value bargaining power
							 %RM1 adjusts to the market price and lowers its margin   
							 RM1(i,16,z)=1;						 
						 else
							%reject the squeezed offer
							RM1(i,40,z)=RM1(i,22,z);
							S21(i,15,z)=S21(i,15,z)+RM1(i,22,z); % since exit, therefore applying penalty
							RM1(i,41,z)=Q(i,z);	
							RM1(i,42,z)=1;
							RM1(i,50,z)=1;			
						 end						
					 end 				 
				 end
			else %all previous logics together 
				%RM1 compresses fixed costs and makes a quote            
				RM1(i,20,z)=RM1(i,2,z)*random(triangolarecosti);      %fixed costs of RM1 modified randomly (triangular)
				RM1(i,21,z)=Q(i,z)*(S21(i,17,z)*RM1(i,18,z)*(1-RM1(i,5,z))-RM1(i,26,z));  %fixed costs of RM1 to reach the target with the squeezed price
				RM1(i,10,z)=1;
				if RM1(i,20,z)<RM1(i,21,z)
					RM1(i,22,z)=S21(i,17,z)*RM1(i,18,z);
					RM1(i,25,z)=RM1(i,21,z);
				else
					RM1(i,22,z)=(RM1(i,26,z)+RM1(i,20,z)/Q(i,z))/(1-RM1(i,5,z));
					RM1(i,25,z)=RM1(i,20,z);
				end
				
				%S21 compares the quote with the market price
				 RM1(i,23,z)=(S21(i,17,z)*RM1(i,18,z))/random(triangolareswitch);
				 if RM1(i,22,z) > RM1(i,23,z)         %if quote is greater than market price
					 %S21 makes a switch of RM1
					 RM1(i,24,z)=RM1(i,23,z);
					 RM1(i,11,z)=1;
					 S21(i,15,z)=S21(i,15,z)+SW*RM1(i,18,z)*S21(i,2,z);
				 else 
					 %need to update 24 indexed value with compresed (self or squeezed) value
					 %this will be used in calculating purchase cost of buyer 						
					 RM1(i,24,z)=RM1(i,22,z);  % previously, we have updated RM1(i,22,z) value based on comparing 20,21 indexed values

					 %the supplier compares compressed cost with squeezed cost of buyer
					 if RM1(i,20,z)<RM1(i,21,z)			
						%modified compressed cost is less than squeezed cost of buyer - so accept it					 
						%S21 stays with the old supplier
					 else
						 %S21 stays with the old supplier based on bargaining power 
						 if rand>RM1(i,14,z)     %I value bargaining power
							 %RM1 adjusts to the market price and lowers its margin   
							 RM1(i,16,z)=1;						 
						 else
							%reject the squeezed offer
							RM1(i,40,z)=RM1(i,22,z);
							S21(i,15,z)=S21(i,15,z)+RM1(i,22,z); % since exit, therefore applying penalty
							RM1(i,41,z)=Q(i,z);	
							RM1(i,42,z)=1;															 
						 end						
					 end 				 
				 end
			end 	
        end
        if RM2(i,19,z)>RM2(i,5,z)
            %RM2 reaches its margin and accepts
            RM2(i,6,z)=1;
            RM2(i,24,z)=S21(i,17,z)*RM2(i,18,z);
            RM2(i,27,z)=RM2(i,19,z);
        else
            S21(i,9,z)=1;        %The squeeze is not fully accepted
            S21(i,8,z)=0;        %Required because it may have been changed to 1 earlier

			if SqueezeLogic == 2 %cost reduction only without switch
				%RM2 compresses the fixed costs and makes a quote            
				RM2(i,20,z)=RM2(i,2,z)*random(triangolarecosti);      %fixed costs of RM2 randomly modified (triangular)
				RM2(i,21,z)=Q(i,z)*(S21(i,17,z)*RM2(i,18,z)*(1-RM2(i,5,z))-RM2(i,26,z));   %fixed costs of RM2 to reach the target with the squeezed price
				if RM2(i,20,z)<RM2(i,21,z)
					RM2(i,22,z)=S21(i,17,z)*RM2(i,18,z);
					RM2(i,25,z)=RM2(i,21,z);
				else
					RM2(i,22,z)=(RM2(i,26,z)+RM2(i,20,z)/Q(i,z))/(1-RM2(i,5,z));
					RM2(i,25,z)=RM2(i,20,z);
				end
				%accept it
				%s21 remains with old supplier
				RM2(i,10,z)=1;					
				%need to update 24 indexed value with compresed (self or squeezed) value
				%this will be used in calculating purchase cost of buyer 		
				RM2(i,24,z)=RM2(i,22,z); % previously, we have updated RM1(i,22,z) value based on comparing 20,21 indexed values								
			elseif SqueezeLogic == 3 %switching without cost reduction	
				RM2(i,22,z)=(RM2(i,26,z)+RM2(i,2,z)/Q(i,z))/(1-RM2(i,5,z)); %the price without cost reduction  
				%S21 compares the quote with the market price
				RM2(i,23,z)=(S21(i,17,z)*RM2(i,18,z))/random(triangolareswitch);
				if RM2(i,22,z)<RM2(i,23,z)    %if quote is lower than market price
					%accept it
					%s21 remains with old supplier
					RM2(i,10,z)=1;					
					%need to update 24 indexed value with compresed (self or squeezed) value
					%this will be used in calculating purchase cost of buyer 		
					RM2(i,24,z)=RM2(i,22,z); % previously, we have updated RM1(i,22,z) value based on comparing 20,21 indexed values				
				else
					 %S21 makes a switch of RM2
					 RM2(i,24,z)=RM2(i,23,z);
					 RM2(i,11,z)=1;
					 S21(i,15,z)=S21(i,15,z)+SW*RM2(i,18,z)*S21(i,2,z);
				end 			
			elseif SqueezeLogic == 4 % position (degree centrality score) and size/bargain power to reject
				RM2(i,22,z)=S21(i,17,z)*RM2(i,18,z);  %the squeezed (by supplier) one (e.g., indexed by 21) 
				%position (degree centrality score) + size (bargaining power)
				TotalPowerToReject = DegCentralityScores(6);
				if SqueezeLogic4Type == 2
					TotalPowerToReject = TotalPowerToReject + RM2(i,14,z);					
				else
					TotalPowerToReject = TotalPowerToReject + AgentSizes(6);					
				end 				
				if TotalPowerToReject >= rand                      
					%reject the squeezed offer
					RM2(i,40,z)=RM2(i,22,z);
					S21(i,15,z)=S21(i,15,z)+RM2(i,22,z); % since exit, therefore applying penalty
					RM2(i,41,z)=Q(i,z);			
					RM2(i,42,z)=1;
					RM2(i,50,z)=1;
				else
					%need to update 24 indexed value with squeezed value
					%this will be used in calculating purchase cost of buyer 				
					RM2(i,24,z)=RM2(i,22,z);				
					%RM2 accepts the squeezed price
					RM2(i,6,z)=1;
				end 			
			elseif SqueezeLogic == 5 % new squeeze logic 2, 3, & 4 all together
				%RM2 compresses the fixed costs and makes a quote            
				RM2(i,20,z)=RM2(i,2,z)*random(triangolarecosti);      %fixed costs of RM2 randomly modified (triangular)
				RM2(i,21,z)=Q(i,z)*(S21(i,17,z)*RM2(i,18,z)*(1-RM2(i,5,z))-RM2(i,26,z));   %fixed costs of RM2 to reach the target with the squeezed price
				RM2(i,10,z)=1;
				if RM2(i,20,z)<RM2(i,21,z)
					RM2(i,22,z)=S21(i,17,z)*RM2(i,18,z);
					RM2(i,25,z)=RM2(i,21,z);
				else
					RM2(i,22,z)=(RM2(i,26,z)+RM2(i,20,z)/Q(i,z))/(1-RM2(i,5,z));
					RM2(i,25,z)=RM2(i,20,z);
				end
				
				%S21 compares the quote with the market price
				RM2(i,23,z)=(S21(i,17,z)*RM2(i,18,z))/random(triangolareswitch);
				if RM2(i,22,z) > RM2(i,23,z)    %if quote is greater than market price
					 %S21 makes a switch of RM2
					 RM2(i,24,z)=RM2(i,23,z);
					 RM2(i,11,z)=1;
					 S21(i,15,z)=S21(i,15,z)+SW*RM2(i,18,z)*S21(i,2,z);
				else
					%s21 remains with old supplier
					%need to update 24 indexed value with compresed (self or squeezed) value
					%this will be used in calculating purchase cost of buyer 							 
					RM2(i,24,z)=RM2(i,22,z); % previously, we have updated RM2(i,22,z) value based on comparing 20,21 indexed values
					%the supplier compares compressed cost with squeezed cost of buyer
					if RM2(i,20,z)<RM2(i,21,z)
						%modified compressed cost is less than squeezed cost of buyer - so accept it
						%s21 remains with old supplier					
					else
						%s21 remains with old supplier	based on bargaining power 
						%position (degree centrality score) + size (bargaining power)
						TotalPowerToReject = DegCentralityScores(6);
						if SqueezeLogic4Type == 2
							TotalPowerToReject = TotalPowerToReject + RM2(i,14,z);					
						else
							TotalPowerToReject = TotalPowerToReject + AgentSizes(6);					
						end 				
						if rand > TotalPowerToReject   %I value bargaining power
							%RM2 adjusts to the market price and lowers its margin
							RM2(i,16,z)=1;
						else
							%reject the squeezed offer
							RM2(i,40,z)=RM2(i,22,z);
							S21(i,15,z)=S21(i,15,z)+RM2(i,22,z); % since exit, therefore applying penalty
							RM2(i,41,z)=Q(i,z);	
							RM2(i,42,z)=1;	
							RM2(i,50,z)=1;		
						end					
					end 
				end
			else %all previous logics together 
				%RM2 compresses the fixed costs and makes a quote            
				RM2(i,20,z)=RM2(i,2,z)*random(triangolarecosti);      %fixed costs of RM2 randomly modified (triangular)
				RM2(i,21,z)=Q(i,z)*(S21(i,17,z)*RM2(i,18,z)*(1-RM2(i,5,z))-RM2(i,26,z));   %fixed costs of RM2 to reach the target with the squeezed price
				RM2(i,10,z)=1;
				if RM2(i,20,z)<RM2(i,21,z)
					RM2(i,22,z)=S21(i,17,z)*RM2(i,18,z);
					RM2(i,25,z)=RM2(i,21,z);
				else
					RM2(i,22,z)=(RM2(i,26,z)+RM2(i,20,z)/Q(i,z))/(1-RM2(i,5,z));
					RM2(i,25,z)=RM2(i,20,z);
				end
				
				%S21 compares the quote with the market price
				RM2(i,23,z)=(S21(i,17,z)*RM2(i,18,z))/random(triangolareswitch);
				if RM2(i,22,z) > RM2(i,23,z)    %if quote is greater than market price
					 %S21 makes a switch of RM2
					 RM2(i,24,z)=RM2(i,23,z);
					 RM2(i,11,z)=1;
					 S21(i,15,z)=S21(i,15,z)+SW*RM2(i,18,z)*S21(i,2,z);
				else
					%s21 remains with old supplier
					%need to update 24 indexed value with compresed (self or squeezed) value
					%this will be used in calculating purchase cost of buyer 							 
					RM2(i,24,z)=RM2(i,22,z); % previously, we have updated RM2(i,22,z) value based on comparing 20,21 indexed values
					%the supplier compares compressed cost with squeezed cost of buyer
					if RM2(i,20,z)<RM2(i,21,z)
						%modified compressed cost is less than squeezed cost of buyer - so accept it
						%s21 remains with old supplier					
					else
						%s21 remains with old supplier	based on bargaining power 
						if rand>RM2(i,14,z)    %I value bargaining power
							%RM2 adjusts to the market price and lowers its margin
							RM2(i,16,z)=1;
						else
							%reject the squeezed offer
							RM2(i,40,z)=RM2(i,22,z);
							S21(i,15,z)=S21(i,15,z)+RM2(i,22,z); % since exit, therefore applying penalty
							RM2(i,41,z)=Q(i,z);	
							RM2(i,42,z)=1;						 						
						end					
					end 
				end
			end 	
        end
        if RM3(i,19,z)>RM3(i,5,z)
            %RM3 reaches its margin and accepts
            RM3(i,6,z)=1;
            RM3(i,24,z)=S21(i,17,z)*RM3(i,18,z);
            RM3(i,27,z)=RM3(i,19,z);
        else
            S21(i,9,z)=1;       %The squeeze is not fully accepted
            S21(i,8,z)=0;       %Required because it may have been changed to 1 earlier
			
			if SqueezeLogic == 2 %cost reduction only without switch
				%RM3 compresses fixed costs and makes a quote            
				RM3(i,20,z)=RM3(i,2,z)*random(triangolarecosti);      %fixed costs of RM3 randomly modified (triangular)
				RM3(i,21,z)=Q(i,z)*(S21(i,17,z)*RM3(i,18,z)*(1-RM3(i,5,z))-RM3(i,26,z));    %fixed costs of RM3 to reach the target with the squeezed price
			
				if RM3(i,20,z)<RM3(i,21,z)
					RM3(i,22,z)=S21(i,17,z)*RM3(i,18,z);
					RM3(i,25,z)=RM3(i,21,z);
				else
					RM3(i,22,z)=(RM3(i,26,z)+RM3(i,20,z)/Q(i,z))/(1-RM3(i,5,z));
					RM3(i,25,z)=RM3(i,20,z);
				end
				%s21 remains with old supplier
				RM3(i,10,z)=1;					
				%need to update 24 indexed value with compresed (self or squeezed) value
				%this will be used in calculating purchase cost of buyer 							
				RM3(i,24,z)=RM3(i,22,z); % previously, we have updated RM1(i,22,z) value based on comparing 20,21 indexed values													
			elseif SqueezeLogic == 3 %switching without cost reduction	
				RM3(i,22,z)=(RM3(i,26,z)+RM3(i,2,z)/Q(i,z))/(1-RM3(i,5,z)); %the price without cost reduction  
				%S21 compares the quote with the market price                
                RM3(i,23,z)=(S21(i,17,z)*RM3(i,18,z))/random(triangolareswitch);
                if RM3(i,22,z)<RM3(i,23,z)       %if quote is lower than market price
					%s21 remains with old supplier
					RM3(i,10,z)=1;					
					%need to update 24 indexed value with compresed (self or squeezed) value
					%this will be used in calculating purchase cost of buyer 							
					RM3(i,24,z)=RM3(i,22,z); % previously, we have updated RM1(i,22,z) value based on comparing 20,21 indexed values									
                else
					%S21 makes a switch of RM3
					RM3(i,24,z)=RM3(i,23,z);
					RM3(i,11,z)=1;
					S21(i,15,z)=S21(i,15,z)+SW*RM3(i,18,z)*S21(i,2,z);
				end 				
			elseif SqueezeLogic == 4 % position (degree centrality score) and size/bargain power to reject
				RM3(i,22,z)=S21(i,17,z)*RM3(i,18,z);  %the squeezed (by supplier) one (e.g., indexed by 21) 
				%position (degree centrality score) + size (bargaining power)
				TotalPowerToReject = DegCentralityScores(7);
				if SqueezeLogic4Type == 2
					TotalPowerToReject = TotalPowerToReject + RM3(i,14,z);					
				else
					TotalPowerToReject = TotalPowerToReject + AgentSizes(7);					
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
					%RM3 accepts the squeezed price
					RM3(i,6,z)=1;
				end 			
			elseif SqueezeLogic == 5 % new squeeze logic 2, 3, & 4 all together
				%RM3 compresses fixed costs and makes a quote            
				RM3(i,20,z)=RM3(i,2,z)*random(triangolarecosti);      %fixed costs of RM3 randomly modified (triangular)
				RM3(i,21,z)=Q(i,z)*(S21(i,17,z)*RM3(i,18,z)*(1-RM3(i,5,z))-RM3(i,26,z));    %fixed costs of RM3 to reach the target with the squeezed price
				RM3(i,10,z)=1;
				
				if RM3(i,20,z)<RM3(i,21,z)
					RM3(i,22,z)=S21(i,17,z)*RM3(i,18,z);
					RM3(i,25,z)=RM3(i,21,z);
				else
					RM3(i,22,z)=(RM3(i,26,z)+RM3(i,20,z)/Q(i,z))/(1-RM3(i,5,z));
					RM3(i,25,z)=RM3(i,20,z);
				end
					
				%S21 compares the quote with the market price               
                RM3(i,23,z)=(S21(i,17,z)*RM3(i,18,z))/random(triangolareswitch);
                if RM3(i,22,z) > RM3(i,23,z)       %if quote is greater than market price
					%S21 makes a switch of RM3
					RM3(i,24,z)=RM3(i,23,z);
					RM3(i,11,z)=1;
					S21(i,15,z)=S21(i,15,z)+SW*RM3(i,18,z)*S21(i,2,z);
                else
					%need to update 24 indexed value with compresed (self or squeezed) value
					%this will be used in calculating purchase cost of buyer 							 
					RM3(i,24,z)=RM3(i,22,z); % previously, we have updated RM2(i,22,z) value based on comparing 20,21 indexed values
					%the supplier compares compressed cost with squeezed cost of buyer
					if RM3(i,20,z)<RM3(i,21,z)
						%modified compressed cost is less than squeezed cost of buyer - so accept it
						%s21 remains with old supplier
					else
						%s21 remains with old supplier based on bargaining power
						%position (degree centrality score) + size (bargaining power)
						TotalPowerToReject = DegCentralityScores(7);
						if SqueezeLogic4Type == 2
							TotalPowerToReject = TotalPowerToReject + RM3(i,14,z);					
						else
							TotalPowerToReject = TotalPowerToReject + AgentSizes(7);					
						end 										
						if rand > TotalPowerToReject    %I value bargaining power
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
			else %all previous logics together 
				%RM3 compresses fixed costs and makes a quote            
				RM3(i,20,z)=RM3(i,2,z)*random(triangolarecosti);      %fixed costs of RM3 randomly modified (triangular)
				RM3(i,21,z)=Q(i,z)*(S21(i,17,z)*RM3(i,18,z)*(1-RM3(i,5,z))-RM3(i,26,z));    %fixed costs of RM3 to reach the target with the squeezed price
				RM3(i,10,z)=1;
				
				if RM3(i,20,z)<RM3(i,21,z)
					RM3(i,22,z)=S21(i,17,z)*RM3(i,18,z);
					RM3(i,25,z)=RM3(i,21,z);
				else
					RM3(i,22,z)=(RM3(i,26,z)+RM3(i,20,z)/Q(i,z))/(1-RM3(i,5,z));
					RM3(i,25,z)=RM3(i,20,z);
				end
					
				%S21 compares the quote with the market price               
                RM3(i,23,z)=(S21(i,17,z)*RM3(i,18,z))/random(triangolareswitch);
                if RM3(i,22,z) > RM3(i,23,z)       %if quote is greater than market price
					%S21 makes a switch of RM3
					RM3(i,24,z)=RM3(i,23,z);
					RM3(i,11,z)=1;
					S21(i,15,z)=S21(i,15,z)+SW*RM3(i,18,z)*S21(i,2,z);
                else
					%need to update 24 indexed value with compresed (self or squeezed) value
					%this will be used in calculating purchase cost of buyer 							 
					RM3(i,24,z)=RM3(i,22,z); % previously, we have updated RM2(i,22,z) value based on comparing 20,21 indexed values
					%the supplier compares compressed cost with squeezed cost of buyer
					if RM3(i,20,z)<RM3(i,21,z)
						%modified compressed cost is less than squeezed cost of buyer - so accept it
						%s21 remains with old supplier
					else
						%s21 remains with old supplier based on bargaining power
						if rand>RM3(i,14,z)     %I value bargaining power
							%RM3 adjusts to the market price and lowers its margin
							RM3(i,16,z)=1;
						else
							 %reject the squeezed offer
							 RM3(i,40,z)=RM3(i,22,z);
							 S21(i,15,z)=S21(i,15,z)+RM3(i,22,z); % since exit, therefore applying penalty
							 RM3(i,41,z)=Q(i,z);	
							 RM3(i,42,z)=1;						 						
						end
					end 	
                end
			end 	
         end
		if RM4(i,19,z)>RM4(i,5,z)
			%RM4 reaches its margin and accepts
			RM4(i,6,z)=1;
			RM4(i,24,z)=S21(i,17,z)*RM4(i,18,z);
			RM4(i,27,z)=RM4(i,19,z);
		else
			S21(i,9,z)=1;      %The squeeze is not fully accepted
			S21(i,8,z)=0;       %Required because it may have been changed to 1 earlier

			if SqueezeLogic == 2 %cost reduction only without switch
				%RM4 compresses fixed costs and makes a quote          
				RM4(i,20,z)=RM4(i,2,z)*random(triangolarecosti);      %fixed costs of RM4 modified randomly (triangular)
				RM4(i,21,z)=Q(i,z)*(S21(i,17,z)*RM4(i,18,z)*(1-RM4(i,5,z))-RM4(i,26,z));    %fixed costs of RM4 to reach the target with the squeezed price
				
				if RM4(i,20,z)<RM4(i,21,z)
					RM4(i,22,z)=S21(i,17,z)*RM4(i,18,z);
					RM4(i,25,z)=RM4(i,21,z);
				else
					RM4(i,22,z)=(RM4(i,26,z)+RM4(i,20,z)/Q(i,z))/(1-RM4(i,5,z));
					RM4(i,25,z)=RM4(i,20,z);
				end
				%accept it
				%s21 remains with old supplier
				RM4(i,10,z)=1;
				%need to update 24 indexed value with compresed (self or squeezed) value
				%this will be used in calculating purchase cost of buyer 								
				RM4(i,24,z)=RM4(i,22,z); % previously, we have updated RM1(i,22,z) value based on comparing 20,21 indexed values			
			elseif SqueezeLogic == 3 %switching without cost reduction	
				RM4(i,22,z)=(RM4(i,26,z)+RM4(i,2,z)/Q(i,z))/(1-RM4(i,5,z)); %the price without cost reduction  
				%S21 compares the quote with the market price
				RM4(i,23,z)=(S21(i,17,z)*RM4(i,18,z))/random(triangolareswitch);
				if RM4(i,22,z)<RM4(i,23,z)      %if quote is lower than market price
					%accept it
					%s21 remains with old supplier
					RM4(i,10,z)=1;
					%need to update 24 indexed value with compresed (self or squeezed) value
					%this will be used in calculating purchase cost of buyer 								
					RM4(i,24,z)=RM4(i,22,z); % previously, we have updated RM1(i,22,z) value based on comparing 20,21 indexed values			
				else
					%S21 makes a switch of RM4
					RM4(i,24,z)=RM4(i,23,z);
					RM4(i,11,z)=1;
					S21(i,15,z)=S21(i,15,z)+SW*RM4(i,18,z)*S21(i,2,z);
				end 					
			elseif SqueezeLogic == 4 % position (degree centrality score) and size/bargain power to reject
				RM4(i,22,z)=S21(i,17,z)*RM4(i,18,z);  %the squeezed (by supplier) one (e.g., indexed by 21) 
				%position (degree centrality score) + size (bargaining power)
				TotalPowerToReject = DegCentralityScores(8);
				if SqueezeLogic4Type == 2
					TotalPowerToReject = TotalPowerToReject + RM4(i,14,z);					
				else
					TotalPowerToReject = TotalPowerToReject + AgentSizes(8);					
				end 				
				if TotalPowerToReject >= rand                      
					%reject the squeezed offer
					RM4(i,40,z)=RM4(i,22,z);
					S21(i,15,z)=S21(i,15,z)+RM4(i,22,z); % since exit, therefore applying penalty
					RM4(i,41,z)=Q(i,z);			
					RM4(i,42,z)=1;
					RM4(i,50,z)=1;
				else
					%need to update 24 indexed value with squeezed value
					%this will be used in calculating purchase cost of buyer 				
					RM4(i,24,z)=RM4(i,22,z);				
					%RM4 accepts the squeezed price
					RM4(i,6,z)=1;
				end 
			elseif SqueezeLogic == 5 % new squeeze logic 2, 3, & 4 all together
				%RM4 compresses fixed costs and makes a quote          
				RM4(i,20,z)=RM4(i,2,z)*random(triangolarecosti);      %fixed costs of RM4 modified randomly (triangular)
				RM4(i,21,z)=Q(i,z)*(S21(i,17,z)*RM4(i,18,z)*(1-RM4(i,5,z))-RM4(i,26,z));    %fixed costs of RM4 to reach the target with the squeezed price
				RM4(i,10,z)=1;
				
				if RM4(i,20,z)<RM4(i,21,z)
					RM4(i,22,z)=S21(i,17,z)*RM4(i,18,z);
					RM4(i,25,z)=RM4(i,21,z);
				else
					RM4(i,22,z)=(RM4(i,26,z)+RM4(i,20,z)/Q(i,z))/(1-RM4(i,5,z));
					RM4(i,25,z)=RM4(i,20,z);
				end
				%S21 compares the quote with the market price
				RM4(i,23,z)=(S21(i,17,z)*RM4(i,18,z))/random(triangolareswitch);
				if RM4(i,22,z) > RM4(i,23,z)      %if quote is greater than market price
					%S21 makes a switch of RM4
					RM4(i,24,z)=RM4(i,23,z);
					RM4(i,11,z)=1;
					S21(i,15,z)=S21(i,15,z)+SW*RM4(i,18,z)*S21(i,2,z);
				else
					%s21 remains with old supplier
					%need to update 24 indexed value with compresed (self or squeezed) value
					%this will be used in calculating purchase cost of buyer 							 
					RM4(i,24,z)=RM4(i,22,z); % previously, we have updated RM2(i,22,z) value based on comparing 20,21 indexed values
					
					%the supplier compares compressed cost with squeezed cost of buyer
					if RM4(i,20,z)<RM4(i,21,z)
						%modified compressed cost is less than squeezed cost of buyer - so accept it
						%s21 remains with old supplier
					else	
						%s21 remains with old supplier based on bargaining power
						%position (degree centrality score) + size (bargaining power)
						TotalPowerToReject = DegCentralityScores(8);
						if SqueezeLogic4Type == 2
							TotalPowerToReject = TotalPowerToReject + RM4(i,14,z);					
						else
							TotalPowerToReject = TotalPowerToReject + AgentSizes(8);					
						end 				

						if rand > TotalPowerToReject  %I value bargaining power
							%RM4 adjusts to the market price and lowers its margin
							RM4(i,16,z)=1;
						else
							 %reject the squeezed offer
							 RM4(i,40,z)=RM4(i,22,z);
							 S21(i,15,z)=S21(i,15,z)+RM4(i,22,z); % since exit, therefore applying penalty
							 RM4(i,41,z)=Q(i,z);	
							 RM4(i,42,z)=1;		
							 RM4(i,50,z)=1;				
						end						
					end 						
				end
			else %all previous logics together 
				%RM4 compresses fixed costs and makes a quote          
				RM4(i,20,z)=RM4(i,2,z)*random(triangolarecosti);      %fixed costs of RM4 modified randomly (triangular)
				RM4(i,21,z)=Q(i,z)*(S21(i,17,z)*RM4(i,18,z)*(1-RM4(i,5,z))-RM4(i,26,z));    %fixed costs of RM4 to reach the target with the squeezed price
				RM4(i,10,z)=1;
				
				if RM4(i,20,z)<RM4(i,21,z)
					RM4(i,22,z)=S21(i,17,z)*RM4(i,18,z);
					RM4(i,25,z)=RM4(i,21,z);
				else
					RM4(i,22,z)=(RM4(i,26,z)+RM4(i,20,z)/Q(i,z))/(1-RM4(i,5,z));
					RM4(i,25,z)=RM4(i,20,z);
				end
				%S21 compares the quote with the market price
				RM4(i,23,z)=(S21(i,17,z)*RM4(i,18,z))/random(triangolareswitch);
				if RM4(i,22,z) > RM4(i,23,z)      %if quote is greater than market price
					%S21 makes a switch of RM4
					RM4(i,24,z)=RM4(i,23,z);
					RM4(i,11,z)=1;
					S21(i,15,z)=S21(i,15,z)+SW*RM4(i,18,z)*S21(i,2,z);
				else
					%s21 remains with old supplier
					%need to update 24 indexed value with compresed (self or squeezed) value
					%this will be used in calculating purchase cost of buyer 							 
					RM4(i,24,z)=RM4(i,22,z); % previously, we have updated RM2(i,22,z) value based on comparing 20,21 indexed values
					
					%the supplier compares compressed cost with squeezed cost of buyer
					if RM4(i,20,z)<RM4(i,21,z)
						%modified compressed cost is less than squeezed cost of buyer - so accept it
						%s21 remains with old supplier
					else	
						%s21 remains with old supplier based on bargaining power
						if rand>RM4(i,14,z)   %I value bargaining power
							%RM4 adjusts to the market price and lowers its margin
							RM4(i,16,z)=1;
						else
							 %reject the squeezed offer
							 RM4(i,40,z)=RM4(i,22,z);
							 S21(i,15,z)=S21(i,15,z)+RM4(i,22,z); % since exit, therefore applying penalty
							 RM4(i,41,z)=Q(i,z);	
							 RM4(i,42,z)=1;						 								
						end						
					end 						
				end
			end 	
		end
		if RM5(i,19,z)>RM5(i,5,z)
			%RM5 reaches its margin and accepts
			RM5(i,6,z)=1;
			RM5(i,24,z)=S21(i,17,z)*RM5(i,18,z);
			RM5(i,27,z)=RM5(i,19,z);
		else
			S21(i,9,z)=1;      %The squeeze is not fully accepted
			S21(i,8,z)=0;       %Required because it may have been changed to 1 earlier

			if SqueezeLogic == 2 %cost reduction only without switch
			  %RM5 compresses fixed costs and makes a quote                  
			  RM5(i,20,z)=RM5(i,2,z)*random(triangolarecosti);      %fixed costs of RM5 modified randomly (triangular)
			  RM5(i,21,z)=Q(i,z)*(S21(i,17,z)*RM5(i,18,z)*(1-RM5(i,5,z))-RM5(i,26,z));     %fixed costs of RM5 to reach the target with the squeezed price
			  
			  if RM5(i,20,z)<RM5(i,21,z)
				  RM5(i,22,z)=S21(i,17,z)*RM5(i,18,z);
				  RM5(i,25,z)=RM5(i,21,z);
			  else
				  RM5(i,22,z)=(RM5(i,26,z)+RM5(i,20,z)/Q(i,z))/(1-RM5(i,5,z));
				  RM5(i,25,z)=RM5(i,20,z);
			  end
			  %accept it
			  %s21 remains with old supplier
			  RM5(i,10,z)=1;
			  %need to update 24 indexed value with compresed (self or squeezed) value
			  %this will be used in calculating purchase cost of buyer 		
			  RM5(i,24,z)=RM5(i,22,z);    % previously, we have updated RM1(i,22,z) value based on comparing 20,21 indexed values	              
			elseif SqueezeLogic == 3 %switching without cost reduction	
			  RM5(i,22,z)=(RM5(i,26,z)+RM5(i,2,z)/Q(i,z))/(1-RM5(i,5,z)); %the price without cost reduction  
			  %S21 compares the quote with the market price
			  RM5(i,23,z)=(S21(i,17,z)*RM5(i,18,z))/random(triangolareswitch);
			  if RM5(i,22,z)<RM5(i,23,z)     %if quote is lower than market price
				  %accept it
				  %s21 remains with old supplier
				  RM5(i,10,z)=1;
				  %need to update 24 indexed value with compresed (self or squeezed) value
				  %this will be used in calculating purchase cost of buyer 		
				  RM5(i,24,z)=RM5(i,22,z);    % previously, we have updated RM1(i,22,z) value based on comparing 20,21 indexed values	              
			  else
				  %S21 makes a switch of RM5
				  RM5(i,24,z)=RM5(i,23,z);
				  RM5(i,11,z)=1;
				  S21(i,15,z)=S21(i,15,z)+SW*RM5(i,18,z)*S21(i,2,z);
			  end 					
			elseif SqueezeLogic == 4 % position (degree centrality score) and size/bargain power to reject
				RM5(i,22,z)=S21(i,17,z)*RM5(i,18,z);  %the squeezed (by supplier) one (e.g., indexed by 21) 
				%position (degree centrality score) + size (bargaining power)
				TotalPowerToReject = DegCentralityScores(9);
				if SqueezeLogic4Type == 2
					TotalPowerToReject = TotalPowerToReject + RM5(i,14,z);					
				else
					TotalPowerToReject = TotalPowerToReject + AgentSizes(9);					
				end 				
				if TotalPowerToReject >= rand                      
					%reject the squeezed offer
					RM5(i,40,z)=RM5(i,22,z);
					S21(i,15,z)=S21(i,15,z)+RM5(i,22,z); % since exit, therefore applying penalty
					RM5(i,41,z)=Q(i,z);			
					RM5(i,42,z)=1;
					RM5(i,50,z)=1;
				else
					%need to update 24 indexed value with squeezed value
					%this will be used in calculating purchase cost of buyer 				
					RM5(i,24,z)=RM5(i,22,z);				
					%RM5 accepts the squeezed price
					RM5(i,6,z)=1;
				end 
			elseif SqueezeLogic == 5 % new squeeze logic 2, 3, & 4 all together
				  %RM5 compresses fixed costs and makes a quote                  
				  RM5(i,20,z)=RM5(i,2,z)*random(triangolarecosti);      %fixed costs of RM5 modified randomly (triangular)
				  RM5(i,21,z)=Q(i,z)*(S21(i,17,z)*RM5(i,18,z)*(1-RM5(i,5,z))-RM5(i,26,z));     %fixed costs of RM5 to reach the target with the squeezed price
				  RM5(i,10,z)=1;
				  
				  if RM5(i,20,z)<RM5(i,21,z)
					  RM5(i,22,z)=S21(i,17,z)*RM5(i,18,z);
					  RM5(i,25,z)=RM5(i,21,z);
				  else
					  RM5(i,22,z)=(RM5(i,26,z)+RM5(i,20,z)/Q(i,z))/(1-RM5(i,5,z));
					  RM5(i,25,z)=RM5(i,20,z);
				  end
				  %S21 compares the quote with the market price
				  RM5(i,23,z)=(S21(i,17,z)*RM5(i,18,z))/random(triangolareswitch);
				  if RM5(i,22,z) > RM5(i,23,z)     %if quote is greater than market price
					  %S21 makes a switch of RM5
					  RM5(i,24,z)=RM5(i,23,z);
					  RM5(i,11,z)=1;
					  S21(i,15,z)=S21(i,15,z)+SW*RM5(i,18,z)*S21(i,2,z);
				  else
					  %s21 remains with old supplier
					  %need to update 24 indexed value with compresed (self or squeezed) value
					  %this will be used in calculating purchase cost of buyer 							 
					  RM5(i,24,z)=RM5(i,22,z);  % previously, we have updated RM2(i,22,z) value based on comparing 20,21 indexed values
	
					  if RM5(i,20,z)<RM5(i,21,z)	
						%modified compressed cost is less than squeezed cost of buyer - so accept it
						%s21 remains with old supplier
					  else
						  %s21 remains with old supplier based on bargaining power	
						  %position (degree centrality score) + size (bargaining power)
						  TotalPowerToReject = DegCentralityScores(9);
						  if SqueezeLogic4Type == 2
							TotalPowerToReject = TotalPowerToReject + RM5(i,14,z);					
						  else
							TotalPowerToReject = TotalPowerToReject + AgentSizes(9);					
						  end 				
						  
						  if rand > TotalPowerToReject     %I value bargaining power
							  %RM5 adjusts to the market price and lowers its margin
							  RM5(i,16,z)=1;
						  else
							 %reject the squeezed offer
							 RM5(i,40,z)=RM5(i,22,z);
							 S21(i,15,z)=S21(i,15,z)+RM5(i,22,z); % since exit, therefore applying penalty
							 RM5(i,41,z)=Q(i,z);	
							 RM5(i,42,z)=1;	
							 RM5(i,50,z)=1;				
						  end					  
					  end 				  
				  end
			else %all previous logics together 
				  %RM5 compresses fixed costs and makes a quote                  
				  RM5(i,20,z)=RM5(i,2,z)*random(triangolarecosti);      %fixed costs of RM5 modified randomly (triangular)
				  RM5(i,21,z)=Q(i,z)*(S21(i,17,z)*RM5(i,18,z)*(1-RM5(i,5,z))-RM5(i,26,z));     %fixed costs of RM5 to reach the target with the squeezed price
				  RM5(i,10,z)=1;
				  
				  if RM5(i,20,z)<RM5(i,21,z)
					  RM5(i,22,z)=S21(i,17,z)*RM5(i,18,z);
					  RM5(i,25,z)=RM5(i,21,z);
				  else
					  RM5(i,22,z)=(RM5(i,26,z)+RM5(i,20,z)/Q(i,z))/(1-RM5(i,5,z));
					  RM5(i,25,z)=RM5(i,20,z);
				  end
				  %S21 compares the quote with the market price
				  RM5(i,23,z)=(S21(i,17,z)*RM5(i,18,z))/random(triangolareswitch);
				  if RM5(i,22,z) > RM5(i,23,z)     %if quote is greater than market price
					  %S21 makes a switch of RM5
					  RM5(i,24,z)=RM5(i,23,z);
					  RM5(i,11,z)=1;
					  S21(i,15,z)=S21(i,15,z)+SW*RM5(i,18,z)*S21(i,2,z);
				  else
					  %s21 remains with old supplier
					  %need to update 24 indexed value with compresed (self or squeezed) value
					  %this will be used in calculating purchase cost of buyer 							 
					  RM5(i,24,z)=RM5(i,22,z);  % previously, we have updated RM2(i,22,z) value based on comparing 20,21 indexed values
	
					  if RM5(i,20,z)<RM5(i,21,z)	
						%modified compressed cost is less than squeezed cost of buyer - so accept it
						%s21 remains with old supplier
					  else
						  %s21 remains with old supplier based on bargaining power	
						  if rand>RM5(i,14,z)     %I value bargaining power
							  %RM5 adjusts to the market price and lowers its margin
							  RM5(i,16,z)=1;
						  else
							 %reject the squeezed offer
							 RM5(i,40,z)=RM5(i,22,z);
							 S21(i,15,z)=S21(i,15,z)+RM5(i,22,z); % since exit, therefore applying penalty
							 RM5(i,41,z)=Q(i,z);	
							 RM5(i,42,z)=1;						 						  
						  end					  
					  end 				  
				  end
			end 	
		end
    end
else
    exit=1;
    RM1(i,28,z)=1;
    RM2(i,28,z)=1;
    RM3(i,28,z)=1;
    RM4(i,28,z)=1;
    RM5(i,28,z)=1;
end
    
                  
                  
                
                
                          
                          
                      
                  
                  
                  
                
                
            
                        
                
                
                
                
                
            
            
                    
                 
                
    
        
        
