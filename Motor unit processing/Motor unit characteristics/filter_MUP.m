function [MUP_Vision, MUP_Sound] = filter_MUP(MUP, CVTimes)
    MUP_Vision = cell(size(MUP));
    MUP_Sound = cell(size(MUP));

    for i = 1:length(MUP)
        unit = MUP{i};
        MUP_Vision{i} = unit(unit > CVTimes(1) & unit < CVTimes(2));
        MUP_Sound{i} = unit(unit > CVTimes(3) & unit < CVTimes(4));
    end

    MUP_Vision = MUP_Vision(~cellfun('isempty', MUP_Vision));
    MUP_Sound = MUP_Sound(~cellfun('isempty', MUP_Sound));
end
