% learning of the previous iteration of setting propensity to squeeze
function [A43, A44, A45, A46] = LearnAndUpdate(AgentConfigs, Psq, PsqVariance, Agent, AgentNo, i, z)
	A43=Agent(i, 43, z);
	%update the last squeezed profit first for the current iteration
	[A44, A45, A46] = UpdateLastSqueezedData(Agent, i, z);
	Agent(i,44,z) = A44;
	Agent(i,45,z) = A45;
	Agent(i,46,z) = A46;
	
	if AgentConfigs.IsIntelligent(AgentNo) %if Agent is intelligent
		first2itrCount = sum(Agent(:,7,z));
		
		%forcing first two iterations to be squeezed	
		if first2itrCount < 2
			A43=1.0;
		else			
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