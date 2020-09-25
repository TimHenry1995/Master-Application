classdef NetworkSize < Chromosome
    %NETWORKSIZE A Chromosome that describes the size of the hidden layer
    %of a phenotypical neural network.
    %   Detailed explanation goes here
    
    properties
        hiddenNeuronCount;
    end

    methods
        function obj = NetworkSize(hiddenNeuronCount)
            %NETWORKSIZE Construct an instance of this class
            %   hiddenNeuronCount: integer
            obj = obj@Chromosome();
            obj.hiddenNeuronCount = hiddenNeuronCount;
        end
        
        function newObj = replicate(obj)
            newObj = replicate@Chromosome(obj);
            newObj.hiddenNeuronCount = obj.hiddenNeuronCount;
        end
    end
end

