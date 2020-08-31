%Buyer algorithm (actual price) alternative price variability 

clear all;
clc;

% following values are based on FC/VC = 1.7	and previous sigma values 
Bmu=563.5008;
PrezzialtoB=makedist('Normal','mu',Bmu,'sigma',2.7); 
PrezzialtoS1=makedist('Normal','mu',152.928,'sigma',1.45);
PrezzialtoS21=makedist('Normal','mu',12.96,'sigma',0.6);
PrezzialtoS22=makedist('Normal','mu',25.92,'sigma',1.061); 
PrezzialtoRM=makedist('Normal','mu',3.6,'sigma',0.3); 

xmin = 0.8;
xmax = 1.0;
triangolareswitch=makedist('triangular',0.8,1,1); %distribuzione triangolare switch caso commodity - triangular distribution of commodity case switches
triangolarecosti=makedist('triangular',0.8,1,1);    %distribuzione triangolare costi - triangular distribution of costs

% configuration to use triangular dist 
TriangularDistEnabled = 1; %1=enabled, 0=uniform distribution

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
%	6 = reject only without any consideration of the squeezed offer
%	7 = accept only the squeezed offer either loss/profit  
%	5 = new squeeze logic 2, 3, & 4 all together    
SqueezeLogic = 5;
SqueezeLogic4Type=1; %1=general random size or fixed size, 2=bargain power based on cumulative exits
ExitPropagationToB=0; % any exit of the supplier is to propagate to B, by setting 1, it implements unfulfilled order calculation propagation - v2.4   

%global varilable for squeezing probability
Psq = 0.5; % squeezing probability
PsqVariance = 0.05;

SW=0.1;                                         
C=1.001;
A=1;

%size of the agent randomly distributed among agents 
% B, S1, S21, S22, RM1, RM2, RM3, RM4, RM5
%rand = Uniformly distributed random numbers and arrays = The rand function generates arrays of random numbers whose elements are uniformly distributed in the interval (0,1). 
%AgentSizes=[rand rand rand rand rand rand rand rand rand rand]; %although S3 removed but some places it's calculation exits. Therefore, we keep this configuration enable
AgentSizes=[0.5 0.5 0.5 0.5 0.5 0.5 0.5 0.5 0.5 0.5]; %although S3 removed but some places it's calculation exits. Therefore, we keep this configuration enable

%position probability(degree centrality)
% B, S1, S21, S22, RM1, RM2, RM3, RM4, RM5
%out degree =  Score/(Network-1) = 1/(9-1)=1/8 for all as they have 1 outgoing to upper layer 
DegCentralityScores=[0.125 0.125 0.125 0.125 0.125 0.125 0.125 0.125 0.125 0.125]; %although S3 removed but some places it's calculation exits. Therefore, we keep this configuration enable 

%Number of simulation
SimNum = 100;
%Total number of iteration
ItrTot = 1000;

z=0;
for z=1:SimNum
	disp(z)

	%inizializzo exit - initialize exit
	B(1,28,z)=0;
	S1(1,28,z)=0;
	S21(1,28,z)=0;
	S22(1,28,z)=0;
	S3(1,28,z)=0;
	RM1(1,28,z)=0;
	RM2(1,28,z)=0;
	RM3(1,28,z)=0;
	RM4(1,28,z)=0;
	RM5(1,28,z)=0;

	%inizializzo SI - I start up YES
	B(1,14,z)=0.5;
	S1(1,14,z)=0.5;
	S21(1,14,z)=0.5;
	S22(1,14,z)=0.5;
	S3(1,14,z)=0.5;
	RM1(1,14,z)=0.5;
	RM2(1,14,z)=0.5;
	RM3(1,14,z)=0.5;
	RM4(1,14,z)=0.5;
	RM5(1,14,z)=0.5;
	
	%inizializzo Costi di Switching - Initialize Switching Costs
	B(1,15,z)=0;
	S1(1,15,z)=0;
	S21(1,15,z)=0;
	S22(1,15,z)=0;
	S3(1,15,z)=0;
	RM1(1,15,z)=0;
	RM2(1,15,z)=0;
	RM3(1,15,z)=0;
	RM4(1,15,z)=0;
	RM5(1,15,z)=0;
		
	%initialization of some variables used in the lasted version
	%added by Zahangir Alam
	for j=40:55
		B(1, j, z) = 0;
		S1(1, j, z) = 0;
		S21(1, j, z) = 0;
		S22(1, j, z) = 0;
		S3(1, j, z) = 0;
		RM1(1, j, z) = 0;
		RM2(1, j, z) = 0;
		RM3(1, j, z) = 0;
		RM4(1, j, z) = 0;
		RM5(1, j, z) = 0;
	end 

	exit=0;
	i=0;
		while i<ItrTot
			if exit > 0
				% we need to empty the result as we are not counting this iteration because of programming exit
				B(i,:,z)=0;
				S1(i,:,z)=0;
				S21(i,:,z)=0;
				S22(i,:,z)=0;
				S3(i,:,z)=0;
				RM1(i,:,z)=0;
				RM2(i,:,z)=0;
				RM3(i,:,z)=0;
				RM4(i,:,z)=0;
				RM5(i,:,z)=0;	
				% continue the loop without increasing the value of i again as need a valid iteration
				
			else		
				% there is no program validation exit, so increasing iteration
				i=i+1;		
			end

		exit=0; 
			
		%Inizializzo prezzi random - Initialize random prices
		B(i,1,z)=random(PrezzialtoB);
		S1(i,1,z)=random(PrezzialtoS1);
		S21(i,1,z)=random(PrezzialtoS21);
		S22(i,1,z)=random(PrezzialtoS22);
		S3(i,1,z)=random(PrezzialtoS21);
		RM1(i,1,z)=random(PrezzialtoRM);
		RM2(i,1,z)=random(PrezzialtoRM);
		RM3(i,1,z)=random(PrezzialtoRM);
		RM4(i,1,z)=random(PrezzialtoRM);
		RM5(i,1,z)=random(PrezzialtoRM);

		B(i,24,z)=B(i,1,z);
		S1(i,24,z)=S1(i,1,z);
		S21(i,24,z)=S21(i,1,z);
		S22(i,24,z)=S22(i,1,z);
		S3(i,24,z)=S3(i,1,z);
		RM1(i,24,z)=RM1(i,1,z);
		RM2(i,24,z)=RM2(i,1,z);
		RM3(i,24,z)=RM3(i,1,z);
		RM4(i,24,z)=RM4(i,1,z);
		RM5(i,24,z)=RM5(i,1,z);

		%quantità scambiata variabile al variare del prezzo(domanda elastica) - variable quantity exchanged according to the price (elastic demand)
		Q(i,z)=100+(100*((B(i,1,z)-Bmu)/Bmu)*(-5));

		%Inizializzo Costi Fissi random - Initialize random fixed costs
		% following values are based on FC/VC = 1.7 
		B(i,2,z)=26609.76;
		S1(i,2,z)=7221.6;
		S21(i,2,z)=612;
		S22(i,2,z)=1224;
		S3(i,2,z)=612;
		RM1(i,2,z)=170;
		RM2(i,2,z)=170;
		RM3(i,2,z)=170;
		RM4(i,2,z)=170;
		RM5(i,2,z)=170;

		B(i,25,z)=B(i,2,z);
		S1(i,25,z)=S1(i,2,z);
		S21(i,25,z)=S21(i,2,z);
		S22(i,25,z)=S22(i,2,z);
		S3(i,25,z)=S3(i,2,z);
		RM1(i,25,z)=RM1(i,2,z);
		RM2(i,25,z)=RM2(i,2,z);
		RM3(i,25,z)=RM3(i,2,z);
		RM4(i,25,z)=RM4(i,2,z);
		RM5(i,25,z)=RM5(i,2,z);

		%Iinizializzo costi d'acquisto (RM random) - Initialize purchase costs (RM random)
		RM1(i,3,z)=1;
		RM2(i,3,z)=1;
		RM3(i,3,z)=1;
		RM4(i,3,z)=1;
		RM5(i,3,z)=1;
		S3(i,3,z)=RM4(i,1,z);
		S21(i,3,z)=RM3(i,1,z);
		S22(i,3,z)=RM4(i,1,z)+RM5(i,1,z);
		S1(i,3,z)=S21(i,1,z)+S22(i,1,z)+RM2(i,1,z);
		B(i,3,z)=S1(i,1,z)+RM1(i,1,z);

		B(i,26,z)=B(i,3,z);
		S1(i,26,z)=S1(i,3,z);
		S21(i,26,z)=S21(i,3,z);
		S22(i,26,z)=S22(i,3,z);
		S3(i,26,z)=S3(i,3,z);
		RM1(i,26,z)=RM1(i,3,z);
		RM2(i,26,z)=RM2(i,3,z);
		RM3(i,26,z)=RM3(i,3,z);
		RM4(i,26,z)=RM4(i,3,z);
		RM5(i,26,z)=RM5(i,3,z);

		%inizializzo la variabile size of squeeze - I initialize the variable size of squeeze
		B(i,36,z)=0;
		S1(i,36,z)=0;
		S21(i,36,z)=0;
		S22(i,36,z)=0;
		S3(i,36,z)=0;
		RM1(i,36,z)=0;
		RM2(i,36,z)=0;
		RM3(i,36,z)=0;
		RM4(i,36,z)=0;
		RM5(i,36,z)=0;

		%Inizializzo i margini - I start the margins/profit
		B(i,4,z)=(B(i,1,z)-B(i,2,z)/Q(i,z)-B(i,3,z))/B(i,1,z);
		S1(i,4,z)=(S1(i,1,z)-S1(i,2,z)/Q(i,z)-S1(i,3,z))/S1(i,1,z);
		S21(i,4,z)=(S21(i,1,z)-S21(i,2,z)/Q(i,z)-S21(i,3,z))/S21(i,1,z);
		S22(i,4,z)=(S22(i,1,z)-S22(i,2,z)/Q(i,z)-S22(i,3,z))/S22(i,1,z);
		S3(i,4,z)=(S3(i,1,z)-S3(i,2,z)/Q(i,z)-S3(i,3,z))/S3(i,1,z);
		RM1(i,4,z)=(RM1(i,1,z)-RM1(i,2,z)/Q(i,z)-RM1(i,3,z))/RM1(i,1,z);
		RM2(i,4,z)=(RM2(i,1,z)-RM2(i,2,z)/Q(i,z)-RM2(i,3,z))/RM2(i,1,z);
		RM3(i,4,z)=(RM3(i,1,z)-RM3(i,2,z)/Q(i,z)-RM3(i,3,z))/RM3(i,1,z);
		RM4(i,4,z)=(RM4(i,1,z)-RM4(i,2,z)/Q(i,z)-RM4(i,3,z))/RM4(i,1,z);
		RM5(i,4,z)=(RM5(i,1,z)-RM5(i,2,z)/Q(i,z)-RM5(i,3,z))/RM5(i,1,z);

		%Inizializzo i margini target - Initialize the target margins/profit
		B(i,5,z)=0.25;
		S1(i,5,z)=0.25;
		S21(i,5,z)=0.25;
		S22(i,5,z)=0.25;
		S3(i,5,z)=0.25;
		RM1(i,5,z)=0.25;
		RM2(i,5,z)=0.25;
		RM3(i,5,z)=0.25;
		RM4(i,5,z)=0.25;
		RM5(i,5,z)=0.25;

		%inizializzo Forced - I start up Forced
		B(i,16,z)=0;
		S1(i,16,z)=0;
		S21(i,16,z)=0;
		S22(i,16,z)=0;
		S3(i,16,z)=0;
		RM1(i,16,z)=0;
		RM2(i,16,z)=0;
		RM3(i,16,z)=0;
		RM4(i,16,z)=0;
		RM5(i,16,z)=0;

		%default squeeze probability
		B(i,43,z) = Psq;
		S1(i,43,z) = Psq;
		S21(i,43,z) = Psq;
		S22(i,43,z) = Psq;
		S3(i,43,z) = Psq;
		RM1(i,43,z) = Psq;
		RM2(i,43,z) = Psq;
		RM3(i,43,z) = Psq;
		RM4(i,43,z) = Psq;
		RM5(i,43,z) = Psq;

		%Calcolo SI aggiornato - Updated SI calculation
		if i>0
			if (SqueezeLogic == 4 || SqueezeLogic == 5) && SqueezeLogic4Type == 2 
				B(i,14,z)=0.5*((0.5/exp(sum(B(:,50,z))))+1-0.5/C^(i-sum(B(:,50,z))));
				S1(i,14,z)=0.5*((0.5/exp(sum(S1(:,50,z))))+1-0.5/C^(i-sum(S1(:,50,z))));
				S21(i,14,z)=0.5*((0.5/exp(sum(S21(:,50,z))))+1-0.5/C^(i-sum(S21(:,50,z))));
				S22(i,14,z)=0.5*((0.5/exp(sum(S22(:,50,z))))+1-0.5/C^(i-sum(S22(:,50,z))));
				S3(i,14,z)=0.5*((0.5/exp(sum(S3(:,50,z))))+1-0.5/C^(i-sum(S3(:,50,z))));
				RM1(i,14,z)=0.5*((0.5/exp(sum(RM1(:,50,z))))+1-0.5/C^(i-sum(RM1(:,50,z))));
				RM2(i,14,z)=0.5*((0.5/exp(sum(RM2(:,50,z))))+1-0.5/C^(i-sum(RM2(:,50,z))));
				RM3(i,14,z)=0.5*((0.5/exp(sum(RM3(:,50,z))))+1-0.5/C^(i-sum(RM3(:,50,z))));
				RM4(i,14,z)=0.5*((0.5/exp(sum(RM4(:,50,z))))+1-0.5/C^(i-sum(RM4(:,50,z))));
				RM5(i,14,z)=0.5*((0.5/exp(sum(RM5(:,50,z))))+1-0.5/C^(i-sum(RM5(:,50,z))));
			else 
				B(i,14,z)=0.5*((0.5/exp(sum(B(:,11,z))))+1-0.5/C^(i-sum(B(:,11,z))));
				S1(i,14,z)=0.5*((0.5/exp(sum(S1(:,11,z))))+1-0.5/C^(i-sum(S1(:,11,z))));
				S21(i,14,z)=0.5*((0.5/exp(sum(S21(:,11,z))))+1-0.5/C^(i-sum(S21(:,11,z))));
				S22(i,14,z)=0.5*((0.5/exp(sum(S22(:,11,z))))+1-0.5/C^(i-sum(S22(:,11,z))));
				S3(i,14,z)=0.5*((0.5/exp(sum(S3(:,11,z))))+1-0.5/C^(i-sum(S3(:,11,z))));
				RM1(i,14,z)=0.5*((0.5/exp(sum(RM1(:,11,z))))+1-0.5/C^(i-sum(RM1(:,11,z))));
				RM2(i,14,z)=0.5*((0.5/exp(sum(RM2(:,11,z))))+1-0.5/C^(i-sum(RM2(:,11,z))));
				RM3(i,14,z)=0.5*((0.5/exp(sum(RM3(:,11,z))))+1-0.5/C^(i-sum(RM3(:,11,z))));
				RM4(i,14,z)=0.5*((0.5/exp(sum(RM4(:,11,z))))+1-0.5/C^(i-sum(RM4(:,11,z))));
				RM5(i,14,z)=0.5*((0.5/exp(sum(RM5(:,11,z))))+1-0.5/C^(i-sum(RM5(:,11,z))));
			end 
		end
		%lancia lo squeeze se necessario - launch the squeeze if necessary
		B(i,4,z)=(B(i,1,z)-B(i,2,z)/Q(i,z)-B(i,3,z))/B(i,1,z);        %profitto attuale % di B - current profit% of B

		%copy the last (t-1) squeezed probabilty for this current (t) iteration.	
		% it is used for learning perspective
		if LearningEnabled && i > 1
			B(i,43,z) = CopyPsqFromPreviousItr(Psq, B, i, z);    
			S1(i,43,z) = CopyPsqFromPreviousItr(Psq, S1, i, z);
			S21(i,43,z) = CopyPsqFromPreviousItr(Psq, S21, i, z);
			S22(i,43,z) = CopyPsqFromPreviousItr(Psq, S22, i, z);
			S3(i,43,z) = CopyPsqFromPreviousItr(Psq, S3, i, z);
		end

		%just holding the purchase cost before squeeze or not - used of debugging purpose
		B(i,48,z)=B(i,26,z);
			
		% if the current profit is greater than target profit then no change in the structure
		% Here B(i,4,z) is current profit (i.e., PMc or x in Psq equation for learning) 
		% and B(i,5,z) is target profit (i.e., PMt or T in Psq equation for learning)                     
		if B(i,4,z)>= B(i,5,z)
			%la struttura non cambia - the structure does not change
			B(i,6,z)=1;
		else
			  %apply learning for propensity to squeeze
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
			  %	SqueezeLogic is all together then it depends on Psq/A43 here
			  if (SqueezeLogic==2 || SqueezeLogic==3 || SqueezeLogic==4 || SqueezeLogic==6 || SqueezeLogic==7 || rand <= A43)	  
				%Buyer tenta lo squeeze - Buyer tries to squeeze
				B(i,7,z)=1;
				
				%if learning is enabled, we are saving the current squeezed probability
				if LearningEnabled && (LearningTechnique == 2 || LearningTechnique == 3)  
					B(i,43,z) = A43;			
				end
				
				AlgoritmoS1_RM1
						
				B(i,26,z)=S1(i,24,z)+RM1(i,24,z);                                   %in seguito all'algoritmoS1_RM1 è cambiato il costo d'acquisto di B - following the algorithm S1_RM1 the purchase cost of B has changed

			else
				%la struttura non cambia - the structure does not change
				B(i,6,z)=1;
				B(i,49,z)=1; %holding the current profit accepted without squeezing
			end
		end

		%calcolo la size of squeeze degli agenti del network - I calculate the size of squeeze of network agents
		B(i,36,z)=(B(i,3,z)-B(i,26,z))/B(i,3,z);
		S1(i,36,z)=(S1(i,3,z)-S1(i,26,z))/S1(i,3,z);
		S21(i,36,z)=(S21(i,3,z)-S21(i,26,z))/S21(i,3,z);
		S22(i,36,z)=(S22(i,3,z)-S22(i,26,z))/S22(i,3,z);
		S3(i,36,z)=(S3(i,3,z)-S3(i,26,z))/S3(i,3,z);

		%calcolo la quantità venduta realmente per effetto della compressione dei costi (Parametro A=]1:infinito[)
		InizialFixedCost(i,z)=S1(i,2,z)+S21(i,2,z)+S22(i,2,z)+S3(i,2,z)+RM1(i,2,z)+RM2(i,2,z)+RM3(i,2,z)+RM4(i,25,z)+RM5(i,2,z);
		CompressedCost(i,z)=S1(i,25,z)+S21(i,25,z)+S22(i,25,z)+S3(i,25,z)+RM1(i,25,z)+RM2(i,25,z)+RM3(i,25,z)+RM4(i,25,z)+RM5(i,25,z);

		Rapportocosti(i,z)=CompressedCost(i,z)/InizialFixedCost(i,z);
		%The quantity actually sold by each supplier is calculated as follows
		Quantity(i,z)=Q(i,z)*(0.5+0.5/A^(100*(1-Rapportocosti(i,z))));
		Ricavi
	end

end

%now analysis
Analisidati
