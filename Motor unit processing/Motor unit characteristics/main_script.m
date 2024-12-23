clear all;

basePath = "C:\Users\";
files = {'01VS.mat', '01S.mat', '01V.mat'};
fsamp = 2000;  % Sampling frequency

% Load data
[VSData, SData, VData, MUP, SampleV, SampleS] = load_data(basePath, files);

% Determine the total points of the full length MUP
totalPoints = SampleV + SampleS;

% Prompt for bad units for ISI and DR calculations
cellNums = input('Any bad unit? Insert number/numbers. Leave empty if nothing (separated by spaces) or enter "stop" to exit: ', 's');
if check_stop(cellNums), disp('Process terminated by user.'); return; end
if ~isempty(cellNums)
    MUP_filtered = MUP;  % Keep a separate MUP with bad units removed
    MUP_filtered(str2double(strsplit(cellNums))) = [];
else
    MUP_filtered = MUP;
end

% Prompt for CVTimes and delays
numbers = input('Please enter four numbers separated by spaces: Start and end of steady V and S in order, or enter "stop" to exit: ', 's');
if check_stop(numbers), disp('Process terminated by user.'); return; end

numbers2 = input('Please enter delays for V and S, or enter "stop" to exit: ', 's');
if check_stop(numbers2), disp('Process terminated by user.'); return; end

% Calculate CVTimes
Delays = str2double(strsplit(numbers2));
CVTimes = str2double(strsplit(numbers));
CVTimes(1:2) = CVTimes(1:2) - Delays(1);
CVTimes(3:4) = CVTimes(3:4) - Delays(2) + SampleV;

% Normalize the cumulative spike train
normalizedCST = normalize_cst(MUP, totalPoints, fsamp);

% Smooth and filter the normalized CST
smoothedCST = smooth_and_filter_cst(normalizedCST, fsamp);

% Ensure the length of smoothedCST matches the original signal length
smoothedCST = smoothedCST(1:totalPoints);

% Trim the smoothed CST to the desired intervals
SmoothedCSTVision = trim_signal(smoothedCST, CVTimes(1), CVTimes(2));
SmoothedCSTSound = trim_signal(smoothedCST, CVTimes(3), CVTimes(4));

% Calculate standard deviation of the Smoothed CSTs
stdSmoothedCSTVision = std(SmoothedCSTVision);
stdSmoothedCSTSound = std(SmoothedCSTSound);

% Filter MUP based on CVTimes for ISI and DR calculations
[MUP_Vision, MUP_Sound] = filter_MUP(MUP_filtered, CVTimes);

% Calculate ISIs and CV
[ISI_Vision, ISI_Sound, CV_Vision, CV_Sound] = calculate_ISI_and_CV(MUP_Vision, MUP_Sound);

% Calculate DR
[DR_Vision, DR_Sound] = calculate_DR(ISI_Vision, ISI_Sound);

% Determine the file name prefix
namePrefix = files{1}(1:4);

% Append CV to the table
append_to_table(fullfile(basePath, 'results_CV.csv'), namePrefix, 'Vision', CV_Vision);
append_to_table(fullfile(basePath, 'results_CV.csv'), namePrefix, 'Sound', CV_Sound);

% Append DR to the table
append_to_table(fullfile(basePath, 'results_DR.csv'), namePrefix, 'Vision', DR_Vision);
append_to_table(fullfile(basePath, 'results_DR.csv'), namePrefix, 'Sound', DR_Sound);

% Append standard deviation of Smoothed CST to the table
append_to_table(fullfile(basePath, 'results_STD_CST.csv'), namePrefix, 'Vision', stdSmoothedCSTVision);
append_to_table(fullfile(basePath, 'results_STD_CST.csv'), namePrefix, 'Sound', stdSmoothedCSTSound);

