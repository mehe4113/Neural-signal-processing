function [VSData, SData, VData, MUP, SampleV, SampleS] = load_data(basePath, files)
    VSData = load(fullfile(basePath, files{1}));
    SData = load(fullfile(basePath, files{2}));
    VData = load(fullfile(basePath, files{3}));

    dataFieldNames = fieldnames(VSData);
    MUP = VSData.(dataFieldNames{1});
    SampleV = length(VData.(dataFieldNames{6}));
    SampleS = length(SData.(dataFieldNames{6}));
end
