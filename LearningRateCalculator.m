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
            alphaDelta = 0; decayDelta = 0;
            if rand(1) > 0.7
                if rand(1) > 0.5
                    alphaDelta = 0.01;
                else
                    alphaDelta = -0.01;
                end
            end
            if rand(1) > 0.7
                if rand(1) > 0.5
                    decayDelta = 0.01;
                else
                    decayDelta = -0.01;
                end
            end
            newObj = LearningRateCalculator(obj.alpha+alphaDelta, obj.decay+decayDelta);
        end
        
        function [string] = toString(obj)
            string = "LearningRateCalculator: alpha = " + obj.alpha + ", decay = " + obj.decay;
        end
    end
end

