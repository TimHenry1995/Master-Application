classdef Individual
    %INDIVIDUAL Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        genotype;
        phenotype;
    end
    
    methods
        function obj = Individual(genotype,phenotype)
            %INDIVIDUAL Construct an instance of this class
            %   Detailed explanation goes here
            obj.genotype = genotype;
            obj.phenotype = phenotype;
        end
    end
end

