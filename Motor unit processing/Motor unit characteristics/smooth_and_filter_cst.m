function smoothedCST = smooth_and_filter_cst(normalizedCST, fsamp)
    hann_window = hann(floor(0.4 * fsamp));
    smoothedCST = conv(normalizedCST, hann_window, 'same');
    
    % Design the filters
    [b_high, a_high] = butter(2, 0.5 / (fsamp / 2), 'high');

    % Apply the filters
    smoothedCST = filtfilt(b_high, a_high, smoothedCST);
end
