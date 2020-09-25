classdef ForwardFunction < Chromosome
    %FORWARDFUNCTION Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        kind;
        scale;
    end
    
    methods
        function obj = ForwardFunction(kind, scale)
            %FORWARDFUNCTION Construct an instance of this class
            %   Detailed explanation goes here
            obj = obj@Chromosome();
            obj.kind = kind; obj.scale = scale;
        end
        
        function newObj = replicate(obj)
            newObj = replicate@Chromosome(obj);
            newObj.kind = obj.kind; newObj.scale = obj.scale;
        end
        
        function [f] = call(obj)
            if obj.kind == "relu"
                f = max(0, obj.scale*x);
            elseif obj.kind == "sigmoid"
                f = @(x) 1/(1+e.^x);
            end
        end
    end
end

