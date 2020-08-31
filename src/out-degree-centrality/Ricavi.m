%Revenue Algorithm

%update the actual quantity if there is an exit
B(i,47,z) = UpdateActualQuantityOnExit(i, z, B, Quantity(i,z));
S11(i,47,z) = UpdateActualQuantityOnExit(i, z, S11, Quantity(i,z));
S12(i,47,z) = UpdateActualQuantityOnExit(i, z, S12, Quantity(i,z));
S13(i,47,z) = UpdateActualQuantityOnExit(i, z, S13, Quantity(i,z));
S14(i,47,z) = UpdateActualQuantityOnExit(i, z, S14, Quantity(i,z));
S15(i,47,z) = UpdateActualQuantityOnExit(i, z, S15, Quantity(i,z));
S21(i,47,z) = UpdateActualQuantityOnExit(i, z, S21, Quantity(i,z));
RM1(i,47,z) = UpdateActualQuantityOnExit(i, z, RM1, Quantity(i,z)); 
RM2(i,47,z) = UpdateActualQuantityOnExit(i, z, RM2, Quantity(i,z));  

%I update the post-squeeze margins
B(i,27,z)=(B(i,1,z)-B(i,2,z)/Quantity(i,z)-B(i,26,z)-B(i,15,z)/Quantity(i,z))/B(i,1,z);
S11(i,27,z)=(S11(i,24,z)-S11(i,25,z)/Quantity(i,z)-S11(i,26,z)-S11(i,15,z)/Quantity(i,z))/S11(i,24,z);
S12(i,27,z)=(S12(i,24,z)-S12(i,25,z)/Quantity(i,z)-S12(i,26,z)-S12(i,15,z)/Quantity(i,z))/S12(i,24,z);
S13(i,27,z)=(S13(i,24,z)-S13(i,25,z)/Quantity(i,z)-S13(i,26,z)-S13(i,15,z)/Quantity(i,z))/S13(i,24,z);
S14(i,27,z)=(S14(i,24,z)-S14(i,25,z)/Quantity(i,z)-S14(i,26,z)-S14(i,15,z)/Quantity(i,z))/S14(i,24,z);
S15(i,27,z)=(S15(i,24,z)-S15(i,25,z)/Quantity(i,z)-S15(i,26,z)-S15(i,15,z)/Quantity(i,z))/S15(i,24,z);
S21(i,27,z)=(S21(i,24,z)-S21(i,25,z)/Quantity(i,z)-S21(i,26,z)-S21(i,15,z)/Quantity(i,z))/S21(i,24,z);
RM1(i,27,z)=(RM1(i,24,z)-RM1(i,25,z)/Quantity(i,z)-RM1(i,26,z)-RM1(i,15,z)/Quantity(i,z))/RM1(i,24,z);
RM2(i,27,z)=(RM2(i,24,z)-RM2(i,25,z)/Quantity(i,z)-RM2(i,26,z)-RM2(i,15,z)/Quantity(i,z))/RM2(i,24,z);

%I calculate the revenues of each agent
B(i,12,z)=B(i,24,z)*Quantity(i,z);
S11(i,12,z)=S11(i,24,z)*Quantity(i,z);
S12(i,12,z)=S12(i,24,z)*Quantity(i,z);
S13(i,12,z)=S13(i,24,z)*Quantity(i,z);
S14(i,12,z)=S14(i,24,z)*Quantity(i,z);
S15(i,12,z)=S15(i,24,z)*Quantity(i,z);
S21(i,12,z)=S21(i,24,z)*Quantity(i,z);
RM1(i,12,z)=RM1(i,24,z)*Quantity(i,z);
RM2(i,12,z)=RM2(i,24,z)*Quantity(i,z);

%I calculate the profits of each agent
%Note: added by Zahangir - Profit margins for NewS11, NewS12 etc. is wrong here. It only works for switching only. Need to fix it later.
B(i,13,z)=B(i,12,z)-B(i,2,z)-B(i,26,z)*Quantity(i,z)-B(i,15,z);

if S11(i,11,z)>0 | S11(i,42,z) > 0         %if the supplier has undergone switching or there is an exit 
	S11(i,12,z) = 0; % Either it exits by self or there is a switching, no revenue, therefore profit is negative	
    S11(i,13,z)=-S11(i,25,z);
else
    S11(i,13,z)=S11(i,24,z)*Quantity(i,z)-S11(i,25,z)-S11(i,26,z)*Quantity(i,z)-S11(i,15,z);
end
if S11(i,11,z)>0         %if the supplier has undergone switching - only for new relationship
    NewS11(i,1,z)=S11(i,24,z)*Quantity(i,z)-S11(i,25,z)-S11(i,26,z)*Quantity(i,z)-S11(i,15,z);      %profits of the new supplier
else
    NewS11(i,1,z)=0;
end

if S12(i,11,z)>0 | S12(i,42,z) > 0         %if the supplier has undergone switching or there is an exit 
	S12(i,12,z) = 0; % Either it exits by self or there is a switching, no revenue, therefore profit is negative	
    S12(i,13,z)=-S12(i,25,z);
else
    S12(i,13,z)=S12(i,24,z)*Quantity(i,z)-S12(i,25,z)-S12(i,26,z)*Quantity(i,z)-S12(i,15,z);
end
if S12(i,11,z)>0       %if the supplier has undergone switching - only for new relationship
    NewS12(i,1,z)=S12(i,24,z)*Quantity(i,z)-S12(i,25,z)-S12(i,26,z)*Quantity(i,z)-S12(i,15,z);       %profits of the new supplier
else
    NewS12(i,1,z)=0;
end

if S13(i,11,z)>0 | S13(i,42,z) > 0         %if the supplier has undergone switching or there is an exit 
	S13(i,12,z) = 0; % Either it exits by self or there is a switching, no revenue, therefore profit is negative	
    S13(i,13,z)=-S13(i,25,z);
else
    S13(i,13,z)=S13(i,24,z)*Quantity(i,z)-S13(i,25,z)-S13(i,26,z)*Quantity(i,z)-S13(i,15,z);
end
if S13(i,11,z)>0        %if the supplier has undergone switching - only for new relationship 
    NewS13(i,1,z)=S13(i,24,z)*Quantity(i,z)-S13(i,25,z)-S13(i,26,z)*Quantity(i,z)-S13(i,15,z);       %profits of the new supplier
else
    NewS13(i,1,z)=0;
end

if S14(i,11,z)>0 | S14(i,42,z) > 0         %if the supplier has undergone switching or there is an exit 
	S14(i,12,z) = 0; % Either it exits by self or there is a switching, no revenue, therefore profit is negative	
    S14(i,13,z)=-S14(i,25,z);
else
    S14(i,13,z)=S14(i,24,z)*Quantity(i,z)-S14(i,25,z)-S14(i,26,z)*Quantity(i,z)-S14(i,15,z);
end
if S14(i,11,z)>0        %if the supplier has undergone switching - only for new relationship
    NewS14(i,1,z)=S14(i,24,z)*Quantity(i,z)-S14(i,25,z)-S14(i,26,z)*Quantity(i,z)-S14(i,15,z);      %profits of the new supplier
else
    NewS14(i,1,z)=0;
end

if S15(i,11,z)>0 | S15(i,42,z) > 0         %if the supplier has undergone switching or there is an exit 
	S15(i,12,z) = 0; % Either it exits by self or there is a switching, no revenue, therefore profit is negative	
    S15(i,13,z)=-S15(i,25,z);
else
    S15(i,13,z)=S15(i,24,z)*Quantity(i,z)-S15(i,25,z)-S15(i,26,z)*Quantity(i,z)-S15(i,15,z);
end
if S15(i,11,z)>0        %if the supplier has undergone switching - only for new relationship
    NewS15(i,1,z)=S15(i,24,z)*Quantity(i,z)-S15(i,25,z)-S15(i,26,z)*Quantity(i,z)-S15(i,15,z);       %profits of the new supplier
else
    NewS15(i,1,z)=0;
end

if S21(i,11,z)>0 | S21(i,42,z) > 0         %if the supplier has undergone switching or there is an exit 
 	S21(i,12,z) = 0; % Either it exits by self or there is a switching, no revenue, therefore profit is negative	
    S21(i,13,z)=-S21(i,25,z);
else
    S21(i,13,z)=S21(i,24,z)*Quantity(i,z)-S21(i,25,z)-S21(i,26,z)*Quantity(i,z)-S21(i,15,z);
end
if S21(i,11,z)>0        %if the supplier has undergone switching - only for new relationship
    NewS21(i,1,z)=S21(i,24,z)*Quantity(i,z)-S21(i,25,z)-S21(i,26,z)*Quantity(i,z)-S21(i,15,z);        %profits of the new supplier
else
    NewS21(i,1,z)=0;
end

if RM1(i,11,z)>0 | RM1(i,42,z) > 0         %if the supplier has undergone switching or there is an exit 
	RM1(i,12,z) = 0; % Either it exits by self or there is a switching, no revenue, therefore profit is negative	
    RM1(i,13,z)=-RM1(i,25,z);
else
    RM1(i,13,z)=RM1(i,24,z)*Quantity(i,z)-RM1(i,25,z)-RM1(i,26,z)*Quantity(i,z)-RM1(i,15,z);
end
if RM1(i,11,z)>0         %if the supplier has undergone switching - only for new relationship
    NewRM1(i,1,z)=RM1(i,24,z)*Quantity(i,z)-RM1(i,25,z)-RM1(i,26,z)*Quantity(i,z)-RM1(i,15,z);        %profits of the new supplier
else
    NewRM1(i,1,z)=0;
end

if RM2(i,11,z)>0 | RM2(i,42,z) > 0          %if the supplier has undergone switching or there is an exit 
	RM2(i,12,z) = 0; % Either it exits by self or there is a switching, no revenue, therefore profit is negative	
    RM2(i,13,z)=-RM2(i,25,z);
else
    RM2(i,13,z)=RM2(i,24,z)*Quantity(i,z)-RM2(i,25,z)-RM2(i,26,z)*Quantity(i,z)-RM2(i,15,z);
end
if RM2(i,11,z)>0        %if the supplier has undergone switching - only for new relationship
    NewRM2(i,1,z)=RM2(i,24,z)*Quantity(i,z)-RM2(i,25,z)-RM2(i,26,z)*Quantity(i,z)-RM2(i,15,z);        %profits of the new supplier
else
    NewRM2(i,1,z)=0;
end



