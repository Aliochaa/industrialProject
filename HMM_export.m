function [] = HMM_export(name,prior,transmat)

delete(name);
fileID = fopen(name,'w');

fprintf(fileID, 'Phoneme P\nPriorMatrix:\n');
fprintf(fileID,[repmat('%f\t',1,size(prior,2)) '\n'], prior');

fprintf(fileID, 'TransMatrix:\n');
fprintf(fileID, [repmat('%f\t',1,size(transmat,2)) '\n'], transmat');

fclose(fileID);

end

