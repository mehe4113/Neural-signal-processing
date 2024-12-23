function cumulativeSpikeTrain = aggregate_spike_trains(MUP_list, totalPoints)
    cumulativeSpikeTrain = zeros(1, totalPoints);

    for i = 1:length(MUP_list)
        binarySpikeTrain = generate_spike_train(MUP_list{i}, totalPoints);
        cumulativeSpikeTrain = cumulativeSpikeTrain + binarySpikeTrain;
    end
end
