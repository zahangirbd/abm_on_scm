%PropensityPrediction using svm model

function CurPsq = GetPropensityPrediction(AgentConfigs, Psq, Agent, AgentNo, Model, i, z)
	CurPsq = Psq;
	if AgentConfigs.IsIntelligent(AgentNo) %if Agent is intelligent
		if i > 1		
			%we are expecting no exits and no unfulfilled orders for the current iteration
			%AgentMean = [mean(Agent(:,1,z)) mean(Agent(:,2,z)) mean(Agent(:,26,z)) mean(Agent(:,15,z)) mean(Agent(:,12,z)) mean(Agent(:,13,z)) 0 0];
			%fprintf('B1=%f,B2=%f,B26=%f,B15=%f,B12=%f,B13=%f\n',mean(Agent(:,1,z)), mean(Agent(:,2,z)), mean(Agent(:,26,z)), mean(Agent(:,15,z)), mean(Agent(:,12,z)), mean(Agent(:,13,z)));
            
            Agent1 = 0.0;
			Agent2 = 0.0;
            Agent26 = 0.0;
            Agent15 = 0.0;
            Agent12 = 0.0;
            Agent13 = 0.0;
            
            SqCount = 0;
            for n=1:(i-1)
                if Agent(n,7,z) || Agent(n,49,z) 
                    Agent1 = Agent1 + Agent(n,1,z);
                    Agent2 = Agent2 + Agent(n,2,z);
                    Agent26 = Agent26 + Agent(n,26,z);
                    Agent15 = Agent15 + Agent(n,15,z);
                    Agent12 = Agent12 + Agent(n,12,z);
                    Agent13 = Agent13 + Agent(n,13,z);
                    SqCount = SqCount + 1;
                end
            end 
            
            %just for valid denominator
            if SqCount == 0
                SqCount = 1;
            end
            
            Agent1 = Agent1/SqCount;
            Agent2 = Agent2/SqCount;
            Agent26 = Agent26/SqCount;
            Agent15 = Agent15/SqCount;
            Agent12 = Agent12/SqCount;
            Agent13 = Agent13/SqCount;
            
            AgentMean = [ Agent1 Agent2 Agent26 Agent15 Agent12 Agent13 0 0];
            %fprintf('B1=%f,B2=%f,B26=%f,B15=%f,B12=%f,B13=%f\n', Agent1, Agent2, Agent26, Agent15, Agent12, Agent13); 
            
            [labels,scores] = predict(Model,AgentMean);

			if labels(1) == 1
				CurPsq = 1.0;
			else
				CurPsq = Psq;	
			end
		end 	
	end
end

