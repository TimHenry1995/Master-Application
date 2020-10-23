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
        
        function [obj, lossTrajectory, a3] = train(obj, X,Y, epochCount)
            % Assumes channels last. rows are instances
            
            [activate, revert] = obj.genotype.activationFunction.call();
            lossTrajectory = nan(1,epochCount);
            alpha = obj.genotype.learningRateCalculator.alpha;
            % Training
            for e = 1:epochCount
                % Forward activation
                a1 = X;
                a2 = activate(a1*obj.phenotype.theta1);
                a3 = activate(a2*obj.phenotype.theta2);

                % Backward propagation 
                % hidden to output layer
                delC_delA3 = (a3-Y);
                lossTrajectory(e) = mean(mean(delC_delA3.^2));
                delA3_delZ3 = revert(a3);
                delZ3_delA2 = obj.phenotype.theta2';
                delZ3_delTheta2 = a2;
                tmp = delC_delA3 .* delA3_delZ3;
                delC_delA2 = tmp*delZ3_delA2; % [instanceCount, hidden_layer_size + 1]
                delC_delTheta2 = tmp'*delZ3_delTheta2; % [output_layer_size, hidden_layer_size + 1]

                % input to hidden layer
                delA2_delZ2 = a2.*(1-a2);
                delZ2_delTheta1 = a1;
                tmp = [delC_delA2 .* delA2_delZ2]';
                delC_delTheta1 = tmp(:,:)*(delZ2_delTheta1); % [hidden_layer_size, output_layer_size + 1]

                % Update the thetas in direction from input to output
                obj.phenotype.theta1 = obj.phenotype.theta1 - alpha * (1/size(X,1)) * (delC_delTheta1' + obj.phenotype.theta1);
                obj.phenotype.theta2 = obj.phenotype.theta2 - alpha * (1/size(X,1)) * (delC_delTheta2' + obj.phenotype.theta2);
                alpha =  obj.genotype.learningRateCalculator.alpha *  obj.genotype.learningRateCalculator.decay;
            end
        end
        
        function [string] = toString(obj)
            string = "Individual: " + obj.genotype.toString() + ", " + obj.phenotype.toString();
        end
    end
end

