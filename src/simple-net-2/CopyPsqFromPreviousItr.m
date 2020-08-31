% learning of the previous iteration of setting propensity to squeeze
function PsqFromPreviousItr = CopyPsqFromPreviousItr(Psq, Agent, i, z)
	if sum(Agent(:,7,z)) <= 2 && Agent(i-1,43,z) == 1.0 %for the two iterations 1.0 is forcefully set, therefore we need to set original
		PsqFromPreviousItr = Psq;
	else
		PsqFromPreviousItr = Agent(i-1,43,z);
	end

end
