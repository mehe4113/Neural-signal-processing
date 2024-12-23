function normalizedCST = normalize_cst(MUP, totalPoints, fsamp)
    win = 0.25 * fsamp; % 250 ms window
    numWindows = ceil(totalPoints / win);
    normalizingVector = zeros(1, totalPoints);

    for i = 1:numWindows
        startIdx = (i - 1) * win + 1;
        endIdx = min(i * win, totalPoints);
        activeUnits = 0;
        
        for j = 1:length(MUP)
            unit = MUP{j};
            if any(unit >= startIdx & unit <= endIdx)
                activeUnits = activeUnits + 1;
            end
        end
        
        normalizingVector(startIdx:endIdx) = activeUnits;
    end

    % Generate cumulative spike trains (CST)
    cumulativeSpikeTrain = aggregate_spike_trains(MUP, totalPoints);

    % Normalize the cumulative spike train
    normalizedCST = cumulativeSpikeTrain ./ normalizingVector;
    normalizedCST(isnan(normalizedCST)) = 0; % Replace NaNs with 0
end
