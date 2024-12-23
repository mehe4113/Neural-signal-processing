function trimmedSignal = trim_signal(signal, startTime, endTime)
    % Ensure startTime and endTime are within the valid range
    startTime = max(1, startTime);
    endTime = min(length(signal), endTime);
    trimmedSignal = signal(startTime:endTime);
end
