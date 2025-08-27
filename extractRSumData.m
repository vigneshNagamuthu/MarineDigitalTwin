function rsumData = extractRSumData(directory)
    % Function to process WiPSA simulation data from files in a given directory.
    %
    % Inputs:
    %   directory - The directory to search for '.p2m' files.
    %
    % Outputs:
    %   dataWI - A table containing the processed data with relevant columns.

    % Initialize a cell array to store the data
    data = {};

    % Get a list of all files in the directory and subdirectories
    files = dir(fullfile(directory, '**', '*.p2m'));

    % Loop through each file
    for k = 1:length(files)
        file = files(k);
        if contains(lower(file.name), 'rsum')  % Check if file name contains 'rsum'
            found_file_path = fullfile(file.folder, file.name);
            fprintf('Found file: %s\n', found_file_path);

            % Open and read the contents of the file
            try
                fileID = fopen(found_file_path, 'r');
                content = textscan(fileID, '%s', 'Delimiter', '\n');
                fclose(fileID);

                % Process each line looking for valid data
                for i = 1:length(content{1})
                    line = strtrim(content{1}{i});
                    if startsWith(line, '#') || isempty(line)
                        continue;  % Skip lines starting with '#' or empty lines
                    end

                    % Split the line into values
                    values = strsplit(line);
                    data(end + 1, :) = values;  % Append to data
                end

            catch ME
                fprintf('Could not read file %s: %s\n', found_file_path, ME.message);
            end
        end
    end

    % Convert the data into a table with appropriate column names
    rsumData = cell2table(data, 'VariableNames', {'Index', 'X', 'Y', 'Z', 'Distance', 'StrongestPower_dBm', 'TotalPower_dBm', 'TotalPowerWithPhase_dBm', 'BestSINR_dB', 'RSSI_dBm'});
    
    % Display a message indicating the function has finished processing
    disp('Data processing complete.');
end
