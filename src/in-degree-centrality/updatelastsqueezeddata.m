%update the last squeezed profit for the current iteration

function [A44, A45, A46] = UpdateLastSqueezedData(Agent, i, z)
%fprintf('UpdateLastSqueezedData-current sim(%d), itr(%d)\n', z, i);	
%44 index is used for holding 1st squeezed profit from the last 
A44=0;

%45 index is used for holding 2nd squeezed profit from the last 
A45=0;

%46 index is used for holding the difference of the profit(t-1) - profit(t-2) 
A46=0;

%omit the first iteration
%finding the 1st and 2nd squeezed profit from last/back
if i > 1 
	
	%profit(t-1) 
	for k=(i-1):-1:1
		if Agent(k,7,z)
			A44 = Agent(k,13,z);
			break;
		end 
	end
	
	%profit(t-2) 
	BSqueezedCount = 0;
	for k=(i-1):-1:1
		if Agent(k,7,z)
			BSqueezedCount = BSqueezedCount + 1;
			if BSqueezedCount == 2 
				A45 = Agent(k,13,z);
				A46 = A44 - A45;
				break;
			end 
		end 
	end
	
end

end


