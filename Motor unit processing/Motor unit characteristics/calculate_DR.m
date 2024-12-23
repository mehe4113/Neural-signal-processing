function [DR_Vision, DR_Sound] = calculate_DR(ISI_Vision, ISI_Sound)
    % Calculate the average discharge rate (DR)
    DR_Vision = cellfun(@(isi) mean(1 ./ (isi / 1000)), ISI_Vision); % Convert ISI to seconds
    DR_Sound = cellfun(@(isi) mean(1 ./ (isi / 1000)), ISI_Sound); % Convert ISI to seconds
end
