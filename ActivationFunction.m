classdef ActivationFunction < Chromosome
    %FORWARDFUNCTION Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        kind;
        scale;
    end
    
    methods
        function obj = ActivationFunction(kind, scale)
            %FORWARDFUNCTION Construct an instance of this class
            %   Detailed explanation goes here
            obj = obj@Chromosome();
            obj.kind = kind; obj.scale = scale;
        end
        
        function newObj = replicate(obj)
            newObj = ActivationFunction(obj.kind, obj.scale);
        end
        
        function [activate, revert] = call(obj)
            if obj.kind == "relu"
                activate = @(x) max(0, obj.scale*x);
                revert = @(x) 1;
            elseif obj.kind == "sigmoid"
                activate = @(x) 1/(1+e.^x);
                revert = @(x) x.*(1-x);
            end
        end
        
        function [string] = toString(obj)
            string = "Activation Function: kind = " + obj.kind + ", sclae = " + obj.scale;
        end
    end
end

