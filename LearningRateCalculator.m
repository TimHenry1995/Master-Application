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
            newObj = LearningRateCalculator(obj.alpha, obj.decay);
        end
        
        function [obj] = call(obj)
            %METHOD1 Summary of this method goes here
            %   Detailed explanation goes here
            obj.alpha = obj.alpha * obj.decay;
        end
        
        
        function [string] = toString(obj)
            string = "LearningRateCalculator: alpha = " + obj.alpha + ", decay = " + obj.decay;
        end
    end
end

