%AlgoritmoRM1_RM2_o
S21(i,7,z)=1;
%calcolo il prezzo strozzato che S21 è disposto spendere(i suoi costi variabili)
if Decision(i,1,z)==1
    S21(i,17,z)=(S11(i,17,z)*(1-S21(i,5,z))-S21(i,25,z)/Q(i,z));
end
if Decision(i,1,z)==2
    S21(i,17,z)=(S12(i,17,z)*(1-S21(i,5,z))-S21(i,25,z)/Q(i,z));
end
if Decision(i,1,z)==3
    S21(i,17,z)=(S13(i,17,z)*(1-S21(i,5,z))-S21(i,25,z)/Q(i,z));
end
if Decision(i,1,z)==4
    S21(i,17,z)=(S14(i,17,z)*(1-S21(i,5,z))-S21(i,25,z)/Q(i,z));
end
if Decision(i,1,z)==5
    S21(i,17,z)=(S15(i,17,z)*(1-S21(i,5,z))-S21(i,25,z)/Q(i,z));
end

if S21(i,17,z)>0

    
    %calcolo la ripartizione percentuale dello squeeze su RM1 RM2
    RM1(i,18,z)=RM1(i,1,z)/S21(i,3,z);
    RM2(i,18,z)=RM2(i,1,z)/S21(i,3,z);
    
    %calcolo i margini di profitto in relazione al prezzo strozzato di S21
    RM1(i,19,z)=(S21(i,17,z)*RM1(i,18,z)-RM1(i,2,z)/Q(i,z)-RM1(i,3,z))/(S21(i,17,z)*RM1(i,18,z));
    RM2(i,19,z)=(S21(i,17,z)*RM2(i,18,z)-RM2(i,2,z)/Q(i,z)-RM2(i,3,z))/(S21(i,17,z)*RM2(i,18,z));
    
    %controllo sei margini di profitto target sono raggiunti
    if RM1(i,19,z)>RM1(i,5,z) & RM2(i,19,z)>RM2(i,5,z)
        %la struttura non cambia e lo squeeze viene accettato 
        S21(i,8,z)=1;
        RM1(i,24,z)=S21(i,17,z)*RM1(i,18,z);
        RM2(i,24,z)=S21(i,17,z)*RM2(i,18,z);
        RM1(i,27,z)=RM1(i,19,z);
        RM2(i,27,z)=RM2(i,19,z);
    else
        if RM1(i,19,z)>RM1(i,5,z)
            %RM1 raggiunge il proprio margine ed accetta
           RM1(i,6,z)=1;
           RM1(i,24,z)=S21(i,17,z)*RM1(i,18,z);
           RM1(i,27,z)=RM1(i,19,z);
        else
            S21(i,9,z)=1;            %Lo squeeze non viene accettato completamente
            S21(i,8,z)=0;           %Necessario perchè potrebbe essere stato cambiato prima in 1
			if SqueezeLogic == 2 %cost reduction only without switch
				%RM1 compresses fixed costs and makes a quote				
				RM1(i,20,z)=RM1(i,2,z)*random(triangolarecosti);      %fixed costs of RM1 modified randomly (triangular)
				RM1(i,21,z)=Q(i,z)*(S21(i,17,z)*RM1(i,18,z)*(1-RM1(i,5,z))-RM1(i,26,z));

				if RM1(i,20,z)<RM1(i,21,z)
					RM1(i,22,z)=S21(i,17,z)*RM1(i,18,z);
					RM1(i,25,z)=RM1(i,21,z);
				else
					RM1(i,22,z)=(RM1(i,26,z)+RM1(i,20,z)/Q(i,z))/(1-RM1(i,5,z));
					RM1(i,25,z)=RM1(i,20,z);
				end
				%accept it
				RM1(i,10,z)=1;
				%need to update 24 indexed value with compresed (self or squeezed) value
				%this will be used in calculating purchase cost of buyer 		
				RM1(i,24,z)=RM1(i,22,z); % previously, we have updated RM1(i,22,z) value based on comparing 20,21 indexed values				
			elseif SqueezeLogic == 3 %switching without cost reduction	
				RM1(i,22,z)=(RM1(i,26,z)+RM1(i,2,z)/Q(i,z))/(1-RM1(i,5,z));%the price without cost reduction  
				RM1(i,23,z)=(S21(i,17,z)*RM1(i,18,z))/random(triangolareswitch);
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
					S21(i,15,z)=S21(i,15,z)+SW*RM1(i,18,z)*S21(i,2,z);
				end			
			elseif SqueezeLogic == 4 % position (degree centrality score) and size/bargain power to reject
				RM1(i,22,z)=S21(i,17,z)*RM1(i,18,z);  %the squeezed (by supplier) one (e.g., indexed by 21) 
				%position (degree centrality score) + size (bargaining power)
				TotalPowerToReject = DegCentralityScores(8);
				if SqueezeLogic4Type == 2
					TotalPowerToReject = TotalPowerToReject + RM1(i,14,z);					
				else
					TotalPowerToReject = TotalPowerToReject + AgentSizes(8);					
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
				RM1(i,21,z)=Q(i,z)*(S21(i,17,z)*RM1(i,18,z)*(1-RM1(i,5,z))-RM1(i,26,z));
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
				if RM1(i,22,z) > RM1(i,23,z)            %if quote is greater than market price
					%S21 makes a switch of RM1
					RM1(i,24,z)=RM1(i,23,z);
					RM1(i,11,z)=1;
					S21(i,15,z)=S21(i,15,z)+SW*RM1(i,18,z)*S21(i,2,z);
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
						TotalPowerToReject = DegCentralityScores(8);
						if SqueezeLogic4Type == 2
							TotalPowerToReject = TotalPowerToReject + RM1(i,14,z);					
						else
							TotalPowerToReject = TotalPowerToReject + AgentSizes(8);					
						end 

						if rand > TotalPowerToReject         %I value bargaining power
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
				RM1(i,21,z)=Q(i,z)*(S21(i,17,z)*RM1(i,18,z)*(1-RM1(i,5,z))-RM1(i,26,z));
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
				if RM1(i,22,z) > RM1(i,23,z)            %if quote is greater than market price
					%S21 makes a switch of RM1
					RM1(i,24,z)=RM1(i,23,z);
					RM1(i,11,z)=1;
					S21(i,15,z)=S21(i,15,z)+SW*RM1(i,18,z)*S21(i,2,z);
				else    
					%need to update 24 indexed value with compresed (self or squeezed) value
					%this will be used in calculating purchase cost of buyer 						
					RM1(i,24,z)=RM1(i,22,z); % previously, we have updated RM1(i,22,z) value based on comparing 20,21 indexed values

					%the supplier compares compressed cost with squeezed cost of buyer
					if RM1(i,20,z) < RM1(i,21,z)
						% modified compressed cost is less than squeezed cost of buyer - so accept it
						% The buyer stays with the old supplier
					else
						%S21 stays with the old supplier
						if rand>RM1(i,14,z)         %I value bargaining power
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
             %RM2 raggiunge il proprio margine ed accetta
             RM2(i,6,z)=1;
             RM2(i,24,z)=S21(i,17,z)*RM2(i,18,z);
             RM2(i,27,z)=RM2(i,19,z);
        else 
             S21(i,9,z)=1;            %Lo squeeze non viene accettato completamente
             S21(i,8,z)=0;           %Necessario perchè potrebbe essere stato cambiato prima in 1
			 if SqueezeLogic == 2 %cost reduction only without switch
				 RM2(i,20,z)=RM2(i,2,z)*random(triangolarecosti);      %fixed costs of RM2 modified randomly (triangular)
				 RM2(i,21,z)=Q(i,z)*(S21(i,17,z)*RM2(i,18,z)*(1-RM2(i,5,z))-RM2(i,26,z));    %fixed costs of RM2 to reach the target with the squeezed price
				 if RM2(i,20,z)<RM2(i,21,z)
					 RM2(i,22,z)=S21(i,17,z)*RM2(i,18,z);
					 RM2(i,25,z)=RM2(i,21,z);
				 else
					 RM2(i,22,z)=(RM2(i,26,z)+RM2(i,20,z)/Q(i,z))/(1-RM2(i,5,z));
					 RM2(i,25,z)=RM2(i,20,z);
				 end
				%accept it
				RM2(i,10,z)=1;
				%need to update 24 indexed value with compresed (self or squeezed) value
				%this will be used in calculating purchase cost of buyer 		
				RM2(i,24,z)=RM2(i,22,z); % previously, we have updated RM1(i,22,z) value based on comparing 20,21 indexed values				
			 elseif SqueezeLogic == 3 %switching without cost reduction	
				 RM2(i,22,z)=(RM2(i,26,z)+RM2(i,2,z)/Q(i,z))/(1-RM2(i,5,z)); %the price without cost reduction  
				 %S21 compares the quote with the market price	 
				 RM2(i,23,z)=(S21(i,17,z)*RM2(i,18,z))/random(triangolareswitch);
				 if RM2(i,22,z) <= RM2(i,23,z)
					%accept it
					RM2(i,10,z)=1;
					%need to update 24 indexed value with compresed (self or squeezed) value
					%this will be used in calculating purchase cost of buyer 		
					RM2(i,24,z)=RM2(i,22,z); % previously, we have updated RM2(i,22,z) value based on comparing 20,21 indexed values				
				 else
					%switching to other supplier
					%the Buyer makes a switch of RM2
					RM2(i,24,z)=RM2(i,23,z); 
					RM2(i,11,z)=1;
					S21(i,15,z)=S21(i,15,z)+SW*RM2(i,18,z)*S21(i,2,z);
				 end			
			 elseif SqueezeLogic == 4 % position (degree centrality score) and size/bargain power to reject
				RM2(i,22,z)=S21(i,17,z)*RM2(i,18,z);  %the squeezed (by supplier) one (e.g., indexed by 21) 
				%position (degree centrality score) + size (bargaining power)
				TotalPowerToReject = DegCentralityScores(9);
				if SqueezeLogic4Type == 2
					TotalPowerToReject = TotalPowerToReject + RM2(i,14,z);					
				else
					TotalPowerToReject = TotalPowerToReject + AgentSizes(9);					
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
				 %RM1 compresses fixed costs and makes a quote				 
				 RM2(i,20,z)=RM2(i,2,z)*random(triangolarecosti);      %fixed costs of RM2 modified randomly (triangular)
				 RM2(i,21,z)=Q(i,z)*(S21(i,17,z)*RM2(i,18,z)*(1-RM2(i,5,z))-RM2(i,26,z));    %fixed costs of RM2 to reach the target with the squeezed price
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
				 if RM2(i,22,z) > RM2(i,23,z)  %if quote is lower than market price
					 %switching to other supplier
					 %S21 makes a switch of RM2
					 RM2(i,24,z)=RM2(i,23,z);
					 RM2(i,11,z)=1;
					 S21(i,15,z)=S21(i,15,z)+SW*RM2(i,18,z)*S21(i,2,z);				 
				 else
					 %S21 stays with the old supplier
					 %need to update 24 indexed value with compresed (self or squeezed) value
					 %this will be used in calculating purchase cost of buyer 							 
					 RM2(i,24,z)=RM2(i,22,z); % previously, we have updated RM1(i,22,z) value based on comparing 20,21 indexed values
					 %the supplier compares compressed cost with squeezed cost of buyer
					 if RM2(i,20,z) < RM2(i,21,z)
						% modified compressed cost is less than squeezed cost of buyer - so accept it
						% The buyer stays with the old supplier
					 else
						 %position (degree centrality score) + size (bargaining power)
						 TotalPowerToReject = DegCentralityScores(9);
						 if SqueezeLogic4Type == 2
							TotalPowerToReject = TotalPowerToReject + RM2(i,14,z);					
						 else
							TotalPowerToReject = TotalPowerToReject + AgentSizes(9);					
						 end 				
						 if rand > TotalPowerToReject       %I value bargaining power
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
				 %RM1 compresses fixed costs and makes a quote				 
				 RM2(i,20,z)=RM2(i,2,z)*random(triangolarecosti);      %fixed costs of RM2 modified randomly (triangular)
				 RM2(i,21,z)=Q(i,z)*(S21(i,17,z)*RM2(i,18,z)*(1-RM2(i,5,z))-RM2(i,26,z));    %fixed costs of RM2 to reach the target with the squeezed price
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

				 if RM2(i,22,z) > RM2(i,23,z)  %if quote is lower than market price
					 %switching to other supplier
					 %S21 makes a switch of RM2
					 RM2(i,24,z)=RM2(i,23,z);
					 RM2(i,11,z)=1;
					 S21(i,15,z)=S21(i,15,z)+SW*RM2(i,18,z)*S21(i,2,z);				 
				 else
					 %S21 stays with the old supplier
					 %need to update 24 indexed value with compresed (self or squeezed) value
					 %this will be used in calculating purchase cost of buyer 							 
					 RM2(i,24,z)=RM2(i,22,z); % previously, we have updated RM2(i,22,z) value based on comparing 20,21 indexed values
					 %the supplier compares compressed cost with squeezed cost of buyer
					 if RM2(i,20,z) < RM2(i,21,z)
						% modified compressed cost is less than squeezed cost of buyer - so accept it
						% The buyer stays with the old supplier
					 else
						 if rand>RM2(i,14,z)       %I value bargaining power
							 RM2(i,24,z)=RM2(i,23,z);       %RM2 adjusts to the market price and lowers its margin
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
    end
else
    exit=1;
    RM1(i,28,z)=1;
    RM2(i,28,z)=1;
end

             
             
             
            
                    
                
           
    