classdef LearningRateCalculator < Chromosome
    %LEARNINGRATECALCULATOR Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        alpha;
        decay;
    end
    
    methods
        function obj = LearningRateCalculator(alpha, decay)
            %LEARNINGRATECALCULATOR Construct an instance of this class
            %   Detailed explanation goes here
            obj = obj@Chromosome();
            obj.alpha = alpha; obj.decay = decay;
        end
        
        function newObj = replicate(obj)
            newObj = replicate@Chromosome(obj);
            newObj.alpha = obj.alpha; newObj.decay = obj.decay;
        end
        
        function [] = call(obj)
            %METHOD1 Summary of this method goes here
            %   Detailed explanation goes here
            obj.alpha = obj.alpha * obj.decay;
        end
    end
end

