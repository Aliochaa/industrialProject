function [] = HMM_export(name,prior,transmat,mu,mixmat)

delete(name);
fileID = fopen(name,'w');

fprintf(fileID, 'Phoneme P\n\nPriorMatrix:\n');
fprintf(fileID,[repmat('%f\t',1,size(prior,2)) '\n'], prior');

fprintf(fileID, '\nTransMatrix:\n');
fprintf(fileID, [repmat('%f\t',1,size(transmat,2)) '\n'], transmat');

fprintf(fileID, '\nMu:\n');
fprintf(fileID, [repmat('%f\t',1,size(mu,2)) '\n'], mu');

fprintf(fileID, '\nMixmat:\n');
fprintf(fileID, [repmat('%f\t',1,size(mixmat,2)) '\n'], mixmat');

fclose(fileID);

end

