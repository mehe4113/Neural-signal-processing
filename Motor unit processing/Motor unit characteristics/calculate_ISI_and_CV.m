function [ISI_Vision, ISI_Sound, CV_Vision, CV_Sound] = calculate_ISI_and_CV(MUP_Vision, MUP_Sound)
    ISI_Vision = cell(size(MUP_Vision));
    ISI_Sound = cell(size(MUP_Sound));

    for i = 1:length(MUP_Vision)
        unit = MUP_Vision{i};
        if length(unit) > 1
            isiValues = diff(unit) * 1000 / 2000; % Calculate ISI and convert to milliseconds
            ISI_Vision{i} = isiValues(isiValues >= 50 & isiValues <= 200);
        end
    end

    for i = 1:length(MUP_Sound)
        unit = MUP_Sound{i};
        if length(unit) > 1
            isiValues = diff(unit) * 1000 / 2000; % Calculate ISI and convert to milliseconds
            ISI_Sound{i} = isiValues(isiValues >= 50 & isiValues <= 200);
        end
    end

    ISI_Vision = ISI_Vision(~cellfun('isempty', ISI_Vision));
    ISI_Sound = ISI_Sound(~cellfun('isempty', ISI_Sound));

    % Calculate the CV vector
    CV_Vision = cellfun(@(isi) std(isi) / mean(isi), ISI_Vision);
    CV_Sound = cellfun(@(isi) std(isi) / mean(isi), ISI_Sound);
end
