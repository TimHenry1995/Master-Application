classdef Genotype
    %GENOTYPE Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        networkSize;
        parameterInitializer;
        forwardFunction;
        learningRateCalculator;
        chromosomes;
    end
    
    methods
        function obj = Genotype(chromosomes)
            %GENOTYPE Construct an instance of this class
            %   Detailed explanation goes here
            obj.networkSize = chromosomes(1);
            obj.parameterInitializer = chromosomes(2);
            obj.forwardFunction = chromosomes(3);
            obj.learningRateCalculator = chromosomes(4);
            obj.chromosomes = {networkSize, parameterInitializer, forwardFunction, learningRateCalculator};
        end
    end
end

