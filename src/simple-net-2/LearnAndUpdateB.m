% learning of the previous iteration of setting propensity to squeeze
function [A43, A46] = LearnAndUpdateB(AgentConfigs, Psq, PsqVariance, Agent, AgentNo, i, z)
	A43=Agent(i, 43, z);
	A46=0;
	
	if AgentConfigs.IsIntelligent(AgentNo) %if Agent is intelligent
		first2itrCount = sum(Agent(:,7,z));		
		%forcing first two iterations to be squeezed
		
		if first2itrCount < 2
			A43=1.0;
		else		
			BSqProfit = 0.0;
			BNonSqProfit = 0.0;
		
			for m=1:(z-1)
				for n=1:(i-1)
					if Agent(n,7,m)
						BSqProfit = BSqProfit + Agent(n,13,m);		
					end
					
					if Agent(i,49,z)
						BNonSqProfit = BNonSqProfit + Agent(n,13,m);		
					end
				end 
			end
		
			BSqCount = sum(sum(Agent(:,7,:)));
			BNonSqCount = sum(sum(Agent(:,49,:)));

			BSqProfitAvg = 0.0;
			BNonSqProfitAvg = 0.0;
			if BSqCount > 0 BSqProfitAvg = BSqProfit/BSqCount; end;
			if BNonSqCount > 0 BNonSqProfitAvg = BNonSqProfit/BNonSqCount; end;
			
			if BSqProfitAvg >= BNonSqProfitAvg 
				A46 = 1;
			else	
				A46 = -1;
			end 
			
			if A46 >= 0
				%positive value in squeezed profit(t-1) - squeezed profit(t-2) so propensity increase
				A43 = A43 + PsqVariance;
				if A43 > 1.0 %this is for checking the upper limit 1
					A43 = 1.0;
				end
			else
				%negative value in squeezed profit(t-1) - squeezed profit(t-2) so propensity decrease
				A43 = A43 - PsqVariance;
				if A43 < 0 %this is for checking the lower limit 0
					A43 = 0.0;
				end	
			end
		end 
	end			
end