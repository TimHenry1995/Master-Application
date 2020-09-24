classdef NetworkSize < Chromosome
    %NETWORKSIZE A Chromosome that describes the size of the hidden layer
    %of a phenotypical neural network.
    %   Detailed explanation goes here

    methods
        function obj = NetworkSize(hiddenNeuronCount)
            %NETWORKSIZE Construct an instance of this class
            %   hiddenNeuronCount: an integer
            obj = obj@Chromosome();
            obj.hiddenNeuronCount = hiddenNeuronCount;
        end
        
        function outputArg = method1(obj,inputArg)
            %METHOD1 Summary of this method goes here
            %   Detailed explanation goes here
            outputArg = obj.Property1 + inputArg;
        end
    end
end

