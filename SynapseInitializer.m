classdef SynapseInitializer < Chromosome
    %PARAMETERINITIALIZER Summary of this class goes here
    %   Detailed explanation goes here
   
    properties
        kind;
        scale;
    end
    
    methods
        function obj = SynapseInitializer(kind, scale)
            %PARAMETERINITIALIZER Construct an instance of this class
            %   Detailed explanation goes here
            obj = obj@Chromosome();
            obj.kind = kind;
            obj.scale = scale;
        end
        
        function newObj = replicate(obj)
            newObj = SynapseInitializer(obj.kind, obj.scale);
        end
        
        function [A] = call(obj, inputSize, outputSize)
            if obj.kind == "normal"
              A = normrnd(0, obj.scale, inputSize, outputSize);
            elseif obj.kind == "uniform"
              A = obj.scale*rand(inputSize, outputSize) - obj.scale/2;
            end
        end
        
        function [string] = toString(obj)
            string = "SynapseInitializer: kind = " + obj.kind;
        end
    end
end

