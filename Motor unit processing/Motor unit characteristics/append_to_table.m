function append_to_table(outputFileName, namePrefix, condition, data)
    if exist(outputFileName, 'file')
        existingTable = readtable(outputFileName);
        maxDataLength = max(size(existingTable, 2) - 2, length(data));
        
        newRow = [{namePrefix}, {condition}, num2cell([data, NaN(1, maxDataLength - length(data))])];
        
        for row = 1:height(existingTable)
            existingTable{row, end+1:maxDataLength+2} = {NaN};
        end
        
        newTable = [existingTable; newRow];
        newVarNames = [{'Name'}, {'Condition'}, strcat('Data', arrayfun(@num2str, 1:maxDataLength, 'UniformOutput', false))];
        newTable.Properties.VariableNames = newVarNames;
    else
        newRow = [{namePrefix}, {condition}, num2cell(data)];
        newTable = cell2table(newRow);
        newTable.Properties.VariableNames = [{'Name'}, {'Condition'}, strcat('Data', arrayfun(@num2str, 1:length(data), 'UniformOutput', false))];
    end

    % Write the table to a CSV file
    writetable(newTable, outputFileName);
end
