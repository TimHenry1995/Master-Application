classdef Phenotype
    %PHENOTYPE Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        inputOutputNeuronCount;
        theta1;
        theta2;
    end
    
    methods
        function obj = Phenotype(genotype, inputOutputNeuronCount)
            %PHENOTYPE Construct an instance of this class
            %   Detailed explanation goes here
            obj.inputOutputNeuronCount = inputOutputNeuronCount;
            obj.theta1 = genotype.synapseInitializer.call(inputOutputNeuronCount, genotype.networkSize.hiddenNeuronCount);
            obj.theta2 = genotype.synapseInitializer.call(genotype.networkSize.hiddenNeuronCount, inputOutputNeuronCount);
        end
        
        function [string] = toString(obj)
            string = "Phenotype: inputOutputNeuronCount = " + obj.inputOutputNeuronCount;
        end
    end
end