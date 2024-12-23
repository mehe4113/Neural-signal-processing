function binarySpikeTrain = generate_spike_train(MUP, totalPoints)
    binarySpikeTrain = zeros(1, totalPoints);

    for i = 1:length(MUP)
        if MUP(i) > 0 && MUP(i) <= totalPoints
            binarySpikeTrain(MUP(i)) = 1;
        end
    end
end
