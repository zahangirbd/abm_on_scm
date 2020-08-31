%update the actual quantity if there is an exit

function A47 = UpdateActualQuantityOnExit(i, z, Agent, aq)
	A47 = 0;
	if Agent(i,42,z) > 0
		A47 = aq;
	end		
end


