

%GENERAL FLOW to generate two CSTs from the Dischargetimes up to n number of combinations,
%then average all permutations (pooled coherence), finally make the
%z-transform to make the data more normal and get the confidence level.

%Coherence between the two CSTs was calculated using Welch's periodogram with
%1 s windows and 95% overlap.
%Average z-scores from the band 250-500Hz was calculated to set the confidence level.

%This analysis has to be performed on two equally sized CSTs as the level
%of coherence depends on the number of included MUs.

%Below references were taken into consideration when writing this script.
%Note that they slightly differ in their methodology.
%Cabral et al., 2024; DOI: 10.1523/ENEURO.0043-24.2024
%Cabral et al., 2024; DOI: 10.1113/JP286078
%Del Vecchio et al., 2019; DOI: 10.1113/JP279111
%Rossato et al., 2022; DOI: 10.1152/jn.00453.2021


SR                          = fsamp;
BeginSignal                 = 72554; %beginning of the window (remember to change for each file)
EndSignal                   = 115006; %BeginSignal + 20000; %add 10 s
for i = 1:numel(MUPulses)
    data = MUPulses{i};
    selectedData = data(data >= BeginSignal & data <= EndSignal);
    MUPulses{i} = selectedData;
end

discharge_times             = MUPulses;
numSamples                  = EndSignal - BeginSignal;
time                        = (0:numSamples-1)/SR;
numCells                    = numel(MUPulses);


numPermutations             = 100; %number of permutations
windowLength                = SR;
all_coherence_values        = zeros(numPermutations, 10*floor(windowLength/2)+1);
noverlap                    = floor(0.95 * windowLength);  %95% overlap
resolution                  = SR*10; % coherence resolution

StepSize                    = windowLength - noverlap;
NSegments                   = floor((numSamples - noverlap) / StepSize) + 1;
factor                      = sqrt(2*NSegments);

% Calculate MU spike trains
spiketrains                 = zeros(numCells, numSamples);
for i = 1:numCells
    spiketrains(i, discharge_times{i}) = 1;
end

for p = 1:numPermutations
    randomIndices           = randperm(numCells);
    halfNumCells            = floor(numCells / 2);
    
    firstHalfIndices        = randomIndices(1:halfNumCells);
    if mod(numCells, 2) == 0
        secondHalfIndices   = randomIndices(halfNumCells+1:end);
    else
        secondHalfIndices   = randomIndices(halfNumCells+1:end-1);
    end

    CST1                    = sum(spiketrains(firstHalfIndices, :));
    CST2                    = sum(spiketrains(secondHalfIndices, :));

    [coherence, freq]       = mscohere(detrend(CST1, 0), detrend(CST2, 0), hanning(windowLength), noverlap, resolution, SR);
    
    all_coherence_values(p, :) = coherence;
end

pooled_coherence            = mean(all_coherence_values, 1);
z_transformed_coherence     = atanh(sqrt(pooled_coherence));
confidenceintforzscore      = mean(z_transformed_coherence(freq>250 & freq<500))


figure('Units', 'normalized', 'Position', [0 0 .4 .3]);
plot(freq, z_transformed_coherence, 'k','LineWidth', 1.5);
xlabel('Frequency (Hz)');
ylabel('z-coherence');
xlim([0 60]);
ylim([0 7]);
hold on;
yline(confidenceintforzscore, '--', 'Color', 'g', 'LineWidth', 1);

AverageCohDelta             = mean(z_transformed_coherence((freq >= 1) & (freq <= 5)))
AverageCohAlpha             = mean(z_transformed_coherence((freq >= 5) & (freq <= 15)))
AverageCohBeta              = mean(z_transformed_coherence((freq >= 15) & (freq <= 35)))

