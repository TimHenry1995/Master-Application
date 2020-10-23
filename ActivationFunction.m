classdef ActivationFunction < Chromosome
    %FORWARDFUNCTION Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        kind;
    end
    
    methods
        function obj = ActivationFunction(kind)
            %FORWARDFUNCTION Construct an instance of this class
            %   Detailed explanation goes here
            obj = obj@Chromosome();
            obj.kind = kind;
        end
        
        function newObj = replicate(obj)
            newObj = ActivationFunction(obj.kind);
        end
        
        function [activate, revert] = call(obj)
            % revert expects the activated x
            if obj.kind == "relu"
                activate = @(x) max(0, x);
                revert = @(x) x./(x+1e-5); % Evaluates to appr. 0 for x = 0 and appr. 1 for x > 0
            elseif obj.kind == "sigmoid"
                activate = @(x) 1./(1+exp(1).^(-x));
                revert = @(x) (1-x).*sqrt(abs(x)); 
            end
        end
        
        function [string] = toString(obj)
            string = "Activation Function: kind = " + obj.kind + ", sclae = " + obj.scale;
        end
    end
end

