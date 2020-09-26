classdef Genotype
    %GENOTYPE Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        networkSize;
        synapseInitializer;
        activationFunction;
        learningRateCalculator;
        chromosomes;
    end
    
    methods
        function obj = Genotype(chromosomes)
            %GENOTYPE Construct an instance of this class
            %   It is expected that chromosomes is an array of chromosome
            %   subclasses networkSize, synapseInitializer,
            %   activationFunction, learningRateCalculator, chromosomes in
            %   this order.
            obj.networkSize = chromosomes{1};
            obj.synapseInitializer = chromosomes{2};
            obj.activationFunction = chromosomes{3};
            obj.learningRateCalculator = chromosomes{4};
            obj.chromosomes = {obj.networkSize, obj.synapseInitializer, obj.activationFunction, obj.learningRateCalculator};
        end
    end
end

