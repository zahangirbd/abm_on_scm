%Buyer algorithm (high normal price) high variability Nexus Supplier with High IN-DEGREE CENTRALITY
%A=1
clear all;
clc;

Bmu = 1679.616;
PrezzialtoB=makedist('Normal','mu',Bmu,'sigma',6.08);
PrezzialtoS1=makedist('Normal','mu',233.280,'sigma',1.7);
PrezzialtoS2=makedist('Normal','mu',64.80,'sigma',1.18);
PrezzialtoRM=makedist('Normal','mu',3.6,'sigma',0.3);
%Gaussian distributions for low price variability
triangolareswitch=makedist('triangular',0.8,1,1);  %triangular distribution switch supplier case commodity
triangolarecosti=makedist('triangular',0.8,1,1);   %triangular distribution reduction of fixed costs

%reading the agent configuration
%Note that, order is strictly followed. For example, 1st row is for B, last row for RM5 etc.
AgentConfigFileName = 'agentconfig.csv';
AgentConfigs = readtable(AgentConfigFileName);

%holding if learning need to apply or not.
LearningEnabled = 0;
%1=LastSqueezed, 2=Cumulative avg checking, 3=machine learning SVM
LearningTechnique = 2;
% if LearningTechnique = 3 then load these models
%svmclB = loadLearnerForCoder('svmclB.mat');
%svmclS1 = loadLearnerForCoder('svmclS1.mat');
%svmclS21 = loadLearnerForCoder('svmclS21.mat');
%svmclS22 = loadLearnerForCoder('svmclS22.mat');
%svmclS3 = loadLearnerForCoder('svmclS3.mat');
debug = 0;

%logic setting 
%	1 = previous all logic together, 
%	2 = cost reduction only without switching, 
%	3 = switching only without cost reduction,
%	4 = position (degree centrality) & size/bargain power only
%	5 = new squeeze logic 2, 3, & 4 all together    
SqueezeLogic = 5;
SqueezeLogic4Type=1; %1=general random size or fixed size, 2=bargain power based on cumulative exits

%global varilable for squeezing probability
Psq = 0.5; % squeezing probability
PsqVariance = 0.05;

SW=0.1;
C=1.001;
A=1;

%size of the agent randomly distributed among agents 
% B, S11, S12, S21, RM1, RM2, RM3, RM4, RM5
AgentSizes=[rand rand rand rand rand rand rand rand rand];
%AgentSizes=[0.5 0.5 0.5 0.5 0.5 0.5 0.5 0.5 0.5];

%position probability(degree centrality)
% B, S11, S12, S21, RM1, RM2, RM3, RM4, RM5
DegCentralityScores=[0 0.125 0.125 0.25 0.125 0.125 0.125 0.125 0.125];

%Number of simulation
SimNum = 100;
%Total number of iteration
ItrTot = 1000;

%Iterations on Z
z=0;
for z=1:SimNum
%Iteration over time
 disp(z)
%initialize variable exit
    B(1,28,z)=0;
    S11(1,28,z)=0;
    S12(1,28,z)=0;
    S21(1,28,z)=0;
    RM1(1,28,z)=0;
    RM2(1,28,z)=0;
    RM3(1,28,z)=0;
    RM4(1,28,z)=0;
    RM5(1,28,z)=0;
    
%I initialize contruttal power
    B(1,14,z)=0.5;
    S11(1,14,z)=0.5;
    S12(1,14,z)=0.5;
    S21(1,14,z)=0.5;
    RM1(1,14,z)=0.5;
    RM2(1,14,z)=0.5;
    RM3(1,14,z)=0.5;
    RM4(1,14,z)=0.5;
    RM5(1,14,z)=0.5;
    
%I initiate switching costs
    B(1,15,z)=0;
    S11(1,15,z)=0;
    S12(1,15,z)=0;
    S21(1,15,z)=0;
    RM1(1,15,z)=0;
    RM2(1,15,z)=0;
    RM3(1,15,z)=0;
    RM4(1,15,z)=0;
    RM5(1,15,z)=0;
    
	%initialization of some variables used in the lasted version
	%added by Zahangir Alam
	for j=40:50
		B(1, j, z) = 0;
		S11(1, j, z) = 0;
		S12(1, j, z) = 0;
		S21(1, j, z) = 0;		
		RM1(1, j, z) = 0;
		RM2(1, j, z) = 0;
		RM3(1, j, z) = 0;
		RM4(1, j, z) = 0;
		RM5(1, j, z) = 0;
	end 
    
  exit=0;
  i=0;
  while i<ItrTot
      if exit>0
			% we need to empty the result as we are not counting this iteration because of programming exit
			%fprintf('current (%d) itr exit = %d, so continue for another iteration.\n', i, exit);
            B(i,:,z)=0;
            S11(i,:,z)=0;
            S12(i,:,z)=0;
            S21(i,:,z)=0;
            RM1(i,:,z)=0;
            RM2(i,:,z)=0;
            RM3(i,:,z)=0;
            RM4(i,:,z)=0;
            RM5(i,:,z)=0;
			% continue the loop without increasing the value of i again as need a valid iteration            
      else
		  % previous iteration has valid value (no programming exit), so increasing iteration count now 	
          i=i+1;
      end
      
      exit=0;
      
      
      %I initialize random prices
        B(i,1,z)=random(PrezzialtoB);
        S11(i,1,z)=random(PrezzialtoS1);
        S12(i,1,z)=random(PrezzialtoS1);
        S21(i,1,z)=random(PrezzialtoS2);
        RM1(i,1,z)=random(PrezzialtoRM);
        RM2(i,1,z)=random(PrezzialtoRM);
        RM3(i,1,z)=random(PrezzialtoRM);
        RM4(i,1,z)=random(PrezzialtoRM);
        RM5(i,1,z)=random(PrezzialtoRM);
        
        
        B(i,24,z)=B(i,1,z);
        S11(i,24,z)=S11(i,1,z);
        S12(i,24,z)=S12(i,1,z);
        S21(i,24,z)=S21(i,1,z);
        RM1(i,24,z)=RM1(i,1,z);
        RM2(i,24,z)=RM2(i,1,z);
        RM3(i,24,z)=RM3(i,1,z);
        RM4(i,24,z)=RM4(i,1,z);
        RM5(i,24,z)=RM5(i,1,z);
        
        %quantity exchanged variable as the price changes (elastic demand)     
        Q(i,z)=100+(100*((B(i,1,z)-Bmu)/Bmu)*(-5));
        
        
        %additional variables for multiple squeeze       
        S21(i,31,z)=0;
       
        Decision(i,1,z)=0;
        
        
        %I initialize the fixed costs      
        B(i,2,z)=79315.20;
        S11(i,2,z)=11016.0;
        S12(i,2,z)=11016.0;
        S21(i,2,z)=3060;
        RM1(i,2,z)=170;
        RM2(i,2,z)=170;
        RM3(i,2,z)=170;
        RM4(i,2,z)=170;
        RM5(i,2,z)=170;
        
        
        B(i,25,z)=B(i,2,z);
        S11(i,25,z)=S11(i,2,z);
        S12(i,25,z)=S12(i,2,z);
        S21(i,25,z)=S21(i,2,z);
        RM1(i,25,z)=RM1(i,2,z);
        RM2(i,25,z)=RM2(i,2,z);
        RM3(i,25,z)=RM3(i,2,z);
        RM4(i,25,z)=RM4(i,2,z);
        RM5(i,25,z)=RM5(i,2,z);
        
        
        %I initiate the purchase costs (variable)       
        RM1(i,3,z)=1;
        RM2(i,3,z)=1;
        RM3(i,3,z)=1;
        RM4(i,3,z)=1;
        RM5(i,3,z)=1;
        S21(i,3,z)=RM1(i,1,z)+RM2(i,1,z)+RM3(i,1,z)+RM4(i,1,z)+RM5(i,1,z);
        S11(i,3,z)=S21(i,1,z);
        S12(i,3,z)=S21(i,1,z);
        B(i,3,z)=S11(i,1,z)+S12(i,1,z);
        
        B(i,26,z)=B(i,3,z);
        S11(i,26,z)=S11(i,3,z);
        S12(i,26,z)=S12(i,3,z);
        S21(i,26,z)=S21(i,3,z);
        RM1(i,26,z)=RM1(i,3,z);
        RM2(i,26,z)=RM2(i,3,z);
        RM3(i,26,z)=RM3(i,3,z);
        RM4(i,26,z)=RM4(i,3,z);
        RM5(i,26,z)=RM5(i,3,z);
        
        
        %I initialize the profit margins       
        B(i,4,z)=(B(i,1,z)-B(i,2,z)/Q(i,z)-B(i,3,z))/B(i,1,z);
        S11(i,4,z)=(S11(i,1,z)-S11(i,2,z)/Q(i,z)-S11(i,3,z))/S11(i,1,z);
        S12(i,4,z)=(S12(i,1,z)-S12(i,2,z)/Q(i,z)-S12(i,3,z))/S12(i,1,z);
        S21(i,4,z)=(S21(i,1,z)-S21(i,2,z)/Q(i,z)-S21(i,3,z))/S21(i,1,z);
        RM1(i,4,z)=(RM1(i,1,z)-RM1(i,2,z)/Q(i,z)-RM1(i,3,z))/RM1(i,1,z);
        RM2(i,4,z)=(RM2(i,1,z)-RM2(i,2,z)/Q(i,z)-RM2(i,3,z))/RM2(i,1,z);
        RM3(i,4,z)=(RM3(i,1,z)-RM3(i,2,z)/Q(i,z)-RM3(i,3,z))/RM3(i,1,z);
        RM4(i,4,z)=(RM4(i,1,z)-RM4(i,2,z)/Q(i,z)-RM4(i,3,z))/RM4(i,1,z);
        RM5(i,4,z)=(RM5(i,1,z)-RM5(i,2,z)/Q(i,z)-RM5(i,3,z))/RM5(i,1,z);
        
        %I initialize the target profit margins     
        B(i,5,z)=0.25;
        S11(i,5,z)=0.25;
        S12(i,5,z)=0.25;
        S21(i,5,z)=0.25;
        RM1(i,5,z)=0.25;
        RM2(i,5,z)=0.25;
        RM3(i,5,z)=0.25;
        RM4(i,5,z)=0.25;
        RM5(i,5,z)=0.25;
        
        %I initialize the size of squeeze variable
        B(i,36,z)=0;
        S11(i,36,z)=0;
        S12(i,36,z)=0;
        S21(i,36,z)=0;
        RM1(i,36,z)=0;
        RM2(i,36,z)=0;
        RM3(i,36,z)=0;
        RM4(i,36,z)=0;
        RM5(i,36,z)=0;
        
        %vendor forcing variable initialization with bargaining power
        
        B(i,16,z)=0;
        S11(i,16,z)=0;
        S12(i,16,z)=0;
        S21(i,16,z)=0;
        RM1(i,16,z)=0;
        RM2(i,16,z)=0;
        RM3(i,16,z)=0;
        RM4(i,16,z)=0;
        RM5(i,16,z)=0;

		 %default squeeze probability
		 B(i,43,z) = Psq;
		 S11(i,43,z) = Psq;
		 S12(i,43,z) = Psq;
         S21(i,43,z) = Psq;
		 RM1(i,43,z) = Psq;
		 RM2(i,43,z) = Psq;
		 RM3(i,43,z) = Psq;
		 RM4(i,43,z) = Psq;
		 RM5(i,43,z) = Psq;
        
        %contractual power calculation YES        
        if i>0
			if (SqueezeLogic == 4 || SqueezeLogic == 5) && SqueezeLogic4Type == 2 
				B(i,14,z)=0.5*((0.5/exp(sum(B(:,50,z))))+1-0.5/C^(i-sum(B(:,50,z))));
				S11(i,14,z)=0.5*((0.5/exp(sum(S11(:,50,z))))+1-0.5/C^(i-sum(S11(:,50,z))));
				S12(i,14,z)=0.5*((0.5/exp(sum(S12(:,50,z))))+1-0.5/C^(i-sum(S12(:,50,z))));
				S21(i,14,z)=0.5*((0.5/exp(sum(S21(:,50,z))))+1-0.5/C^(i-sum(S21(:,50,z))));
				RM1(i,14,z)=0.5*((0.5/exp(sum(RM1(:,50,z))))+1-0.5/C^(i-sum(RM1(:,50,z))));
				RM2(i,14,z)=0.5*((0.5/exp(sum(RM2(:,50,z))))+1-0.5/C^(i-sum(RM2(:,50,z))));
				RM3(i,14,z)=0.5*((0.5/exp(sum(RM3(:,50,z))))+1-0.5/C^(i-sum(RM3(:,50,z))));
				RM4(i,14,z)=0.5*((0.5/exp(sum(RM4(:,50,z))))+1-0.5/C^(i-sum(RM4(:,50,z))));
				RM5(i,14,z)=0.5*((0.5/exp(sum(RM5(:,50,z))))+1-0.5/C^(i-sum(RM5(:,50,z))));
			else
				B(i,14,z)=0.5*((0.5/exp(sum(B(:,11,z))))+1-0.5/C^(i-sum(B(:,11,z))));
				S11(i,14,z)=0.5*((0.5/exp(sum(S11(:,11,z))))+1-0.5/C^(i-sum(S11(:,11,z))));
				S12(i,14,z)=0.5*((0.5/exp(sum(S12(:,11,z))))+1-0.5/C^(i-sum(S12(:,11,z))));
				S21(i,14,z)=0.5*((0.5/exp(sum(S21(:,11,z))))+1-0.5/C^(i-sum(S21(:,11,z))));
				RM1(i,14,z)=0.5*((0.5/exp(sum(RM1(:,11,z))))+1-0.5/C^(i-sum(RM1(:,11,z))));
				RM2(i,14,z)=0.5*((0.5/exp(sum(RM2(:,11,z))))+1-0.5/C^(i-sum(RM2(:,11,z))));
				RM3(i,14,z)=0.5*((0.5/exp(sum(RM3(:,11,z))))+1-0.5/C^(i-sum(RM3(:,11,z))));
				RM4(i,14,z)=0.5*((0.5/exp(sum(RM4(:,11,z))))+1-0.5/C^(i-sum(RM4(:,11,z))));
				RM5(i,14,z)=0.5*((0.5/exp(sum(RM5(:,11,z))))+1-0.5/C^(i-sum(RM5(:,11,z))));
            end 
        else
        end
        
        %launch the squeeze if necessary
        B(i,4,z)=(B(i,1,z)-B(i,2,z)/Q(i,z)-B(i,3,z))/B(i,1,z);   %B's current profit margin
        
        if B(i,4,z)>=B(i,5,z)
            %no squeeze is performed
            B(i,6,z)=1;
            
        else         %otherwise if the margin is less than the target

			A43 = B(i,43,z);
			if LearningEnabled		
				if LearningTechnique == 1
					[A43, A44, A45, A46] = LearnAndUpdate(AgentConfigs, Psq, PsqVariance, B, 1, i, z);
					B(i,43,z) = A43;
					B(i,44,z) = A44;
					B(i,45,z) = A45;
					B(i,46,z) = A46;			
				elseif LearningTechnique == 2
					[A43, A46] = LearnAndUpdateB(AgentConfigs, Psq, PsqVariance, B, 1, i, z);		
					B(i,46,z) = A46;		
				elseif LearningTechnique == 3		
					A43 = GetPropensityPrediction(AgentConfigs, Psq, B, 1, svmclB, i, z);	
				end			
			end
            
		    %if SqueezeLogic is cost reduction only or switching only, then we always tries to squeeze
		    %SqueezeLogic is all together then it depends on Psq/A43 here
		    if (SqueezeLogic==2 || SqueezeLogic==3 || SqueezeLogic==4 || rand <= A43)	  
                %Buyer tries the squeeze
                B(i,7,z)=1;

				%if learning is enabled, we are saving the current squeezed probability
				if LearningEnabled && (LearningTechnique == 2 || LearningTechnique == 3)  
					B(i,43,z) = A43;			
				end
                
                AlgoritmoS11_S12_i  
				
            else
                B(i,6,z)=1;        %the structure does not change
				B(i,49,z)=1; %holding the current profit accepted without squeezing
            end
        end
        
            %I calculate the size of squeeze of agents
            B(i,36,z)=(B(i,3,z)-B(i,26,z))/B(i,3,z);
            S11(i,36,z)=(S11(i,3,z)-S11(i,26,z))/S11(i,3,z);
            S12(i,36,z)=(S12(i,3,z)-S12(i,26,z))/S12(i,3,z);
            S21(i,36,z)=(S21(i,3,z)-S21(i,26,z))/S21(i,3,z);
            
    %I calculate the quantity actually sold due to the cost compression (Parameter A =] 1: infinite [)    
    InizialFixedCost(i,z)=S11(i,2,z)+S12(i,2,z)+S21(i,2,z)+RM1(i,2,z)+RM2(i,2,z)+RM3(i,2,z)+RM4(i,2,z)+RM5(i,2,z);
    CompressedCost(i,z)=S11(i,25,z)+S12(i,25,z)+S21(i,25,z)+RM1(i,25,z)+RM2(i,25,z)+RM3(i,25,z)+RM4(i,25,z)+RM5(i,25,z);
    
    RapportoCosti(i,z)=CompressedCost(i,z)/InizialFixedCost(i,z);
	%The quantity actually sold by each supplier is calculated as follows
    Quantity(i,z)=Q(i,z)*(0.5+0.5/A^(100*(1-RapportoCosti(i,z))));
    Ricavi
	%DebugAtEndOfItr
  end
  
end

Analisidati
        
                
            
        
        
            
        
      
      
          
          
          
      
        
        

        
        
       
       
    
 
 
    
  
    

    

