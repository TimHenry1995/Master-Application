%% Data preparation
% Specify courses and their relations as a graph
close all; clc; clear all;
COURSES = {'Action', 'Functional Neuroanatomy', 'Body and Behaviour', 'Learning and Memory', 'Perception',...
    'Systems Biology', 'Introdutction to Bio-Informatics', 'Evolution and Genetics',...
    'Methods of Cognitive Neuroscience','Methods and Techniques', ...
    'Statistics 1,2 & 3', 'Probability', 'Mathematical Simulation',...
    'Mathematical Modelling', 'Calculus', 'Optimization', 'Machine Learning', 'Natural Language Processing','Numerical Mathematics','Linear Algebra',...
    'Foundations of Agents','Intelligent Search & Games','Autonomous Robotic Systems', 'Computer Vision','Deep Learning', 'Computational Statistics', 'Advanced Natural Language Processing'};
NodeTable = table(COURSES','VariableNames',{'Name'});
s = [1 1 1 1 2 2 2 3 3 3 4, 5 4,  6 6 7, 9,  9, 9, 10, 11 11 11 11, 14 14 14 14 14 14 15 15 15 15 15 16 16 16 16 17 17 17 18 18 19];
t = [2 3 4 5 3 4 5 4 5 7 5, 8 17, 7 8 8, 10, 2, 5, 11, 12 13 17 18, 15 16 17 18 19 20 16 17 18 19 20 17 18 19 20 18 19 20 19 20 20];
EdgeTable = table([s' t'], 'VariableNames',{'EndNodes'});

% Obtain an edge matrix and broadcast it to encourage parallelization
X = eye(numel(COURSES)); 
X = [X;X;X;X;X;X;X;X;X;X;X;X;X;X];
Y = getEdgeMatrix(s,t,numel(COURSES));
Y = [Y;Y;Y;Y;Y;Y;Y;Y;Y;Y;Y;Y;Y;Y];

%% Simulate evolution of neural networks
evolution = Evolution.createExampleEvolution(32, numel(COURSES));
tic;
[evolution, fitnessTrajectoryMeanStandardError] = evolution.evolve(10, X, Y, 1e2);
toc;

%% Train an individual from the final generation
[~, loss, YHat] = evolution.population{1}.train(X, Y, 1e4);
YHat = YHat(1:numel(COURSES),:);
YHat(logical(eye(numel(COURSES)))) = 0; % Removing reflexive relations to avoid clutter during visualization 
%% Visualize Results
% Loss trajectory 
figure();
plot(loss); xlabel('Epoch'); ylabel('Cross Entropy Loss');
title('Calibration Trajectory of Final Neural Network');
 
% Edge matrices
figure(); suptitle('Edge Matrix of Course Graph');
subplot(2,1,2); heatmap(Y(1:numel(COURSES),:)); xlabel('courses'); ylabel('courses'); title('Final Neural Network Output(Top), Target (Bottom)');
subplot(2,1,1); heatmap(YHat); xlabel('courses'); ylabel('courses');

% Graph
predictedEdgeTable = getEdgeTable(YHat);
G = graph(predictedEdgeTable,NodeTable);
figure(); 
h=plot(G,'NodeLabel',G.Nodes.Name); 
set(gcf,'WindowButtonDownFcn',@(f,~)edit_graph(f,h));
title('Course Graph Predicted by Final Neural Network');

%% Convenience functions
function [E] = getEdgeMatrix(s,t,unitCount)
    E = zeros(unitCount);
    for i = 1:numel(s)
        E(s(i),t(i)) = 1; 
        E(t(i),s(i)) = 1; 
    end
end

function [E] = getEdgeTable(edgeMatrix)
    s = []; t = [];
    threshold = 0.25*max(edgeMatrix);
    for i = 1:size(edgeMatrix,1)
        for j = i:size(edgeMatrix,1)
            if edgeMatrix(i,j) > threshold
                s = [s,i]; t = [t,j];
            end
        end
    end
    E = table([s' t'], 'VariableNames',{'EndNodes'});
end
