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
            delta = 0;
            if rand(1) > 0.7
                if rand(1) > 0.5
                    delta = 2;
                else
                    if obj.hiddenNeuronCount > 2
                        delta = -2;
                    end
                end
            end
            newObj = NetworkSize(obj.hiddenNeuronCount + delta);
        end
        
        function [string] = toString(obj)
            string = "NetworkSize: hiddenNeuronCount = " + obj.hiddenNeuronCount;
        end
    end
end

