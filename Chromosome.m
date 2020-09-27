classdef Chromosome
    methods
        function obj = Chromosome()
        end
        
        function obj = replicate(obj)
            obj = Chromosome();
        end
        
        function [string] = toString(obj)
            string = "";
        end
    end
    
end

