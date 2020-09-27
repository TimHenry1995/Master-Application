classdef SynapseInitializer < Chromosome
    %PARAMETERINITIALIZER Summary of this class goes here
    %   Detailed explanation goes here
   
    properties
        kind;
    end
    
    methods
        function obj = SynapseInitializer(kind)
            %PARAMETERINITIALIZER Construct an instance of this class
            %   Detailed explanation goes here
            obj = obj@Chromosome();
            obj.kind = kind;
        end
        
        function newObj = replicate(obj)
            newObj = SynapseInitializer(obj.kind);
        end
        
        function [A] = call(obj, scale, inputSize, outputSize)
            if obj.kind == "normal"
              A = normrnd(0, scale, inputSize, outputSize);
            elseif obj.kind == "uniform"
              A = scale*rand(inputSize, outputSize) - scale/2;
            end
        end
        
        function [string] = toString(obj)
            string = "SynapseInitializer: kind = " + obj.kind;
        end
    end
end

