% Specify courses and their relations as a graph
COURSES = {'Graph Theory', 'Discrete Mathematics', 'Theoretical Computerscience', 'Perception', 'Learning and Memory', 'Action'};
NodeTable = table(COURSES','VariableNames',{'Name'});
s = [1 1 1 2 3];
t = [2 5 6 3 4];
EdgeTable = table([s' t'], 'VariableNames',{'EndNodes'});
G = graph(EdgeTable,NodeTable);
figure(); 
plot(G,'NodeLabel',G.Nodes.Name); title('Target course graph');

%Use vectorization obj(1) = Individual(); obj(2) = etc
%%
clc; clear; close all;
Evolution.testGenerate();
%Evolution.demonstrate();
%%
clc;
courseCount = 10;
X = rand([courseCount-3,courseCount]);
Y = X;
train(X,Y);

function [loss, a3] = train(X,Y)
    % Assumes channels last. rows are instances
    
    % Choosing hyper paramters
    alpha = 0.07;
    lambdaValue = 3;
    inputLayerSize = size(X,2);
    hiddenLayerSize = 25;
    outputLayerSize = size(Y,2);
    epochCount = 3;
    activate = @(x) 1./(1+exp(1).^(-x));
    
    % Training
    epsilon = sqrt(6)/sqrt(inputLayerSize + hiddenLayerSize); % Glorot Uniform initialization
    Theta1 = (2 * rand([hiddenLayerSize, inputLayerSize + 1]) - 1) * epsilon;
    epsilon = sqrt(6)/sqrt(hiddenLayerSize + outputLayerSize);
    Theta2 = (2 * rand([outputLayerSize, hiddenLayerSize + 1]) - 1) * epsilon;

    for i = 1:epochCount
        % Forward activation
        bias = ones([size(X,1),1]);
        a1 = [X, bias];
        a2 = [activate(a1*Theta1'), bias];
        a3 = activate(a2*Theta2');

        % Backward propagation 
        % hidden to output layer
        delC_delA3 = (a3 - Y);
        delA3_delZ3 = a3.*(1-a3);
        delZ3_delA2 = Theta2;
        delZ3_delTheta2 = a2;

        delC_delA2 = (delC_delA3 .* delA3_delZ3)*(delZ3_delA2); % [instanceCount, input_layer_size + 1]
        delC_delTheta2 = (delC_delA3 .* delA3_delZ3)'*(delZ3_delTheta2); % [output_layer_size, input_layer_size + 1]

        % input to hidden layer
        delA2_delZ2 = a2.*(1-a2);
        delZ2_delTheta1 = a1;
        tmp = [delC_delA2 .* delA2_delZ2]';
        delC_delTheta1 = tmp(1:end,:)*(delZ2_delTheta1); % [output_layer_size, input_layer_size + 1]

        % Update the thetas in direction from input to output
        Theta1 = Theta1 - alpha * (1/size(X,1)) * (delC_delTheta1 + lambdaValue .* Theta1);
        Theta2 = Theta2 - alpha * (1/size(X,1)) * (delC_delTheta2 + lambdaValue .* Theta2);
    end
    loss = delC_delA3;
end
  
    




