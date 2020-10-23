% Specify courses and their relations as a graph
close all; clc; clear all;
COURSES = {'Action', 'Functional Neuroanatomy', 'Body and Behaviour', 'Learning and Memory', 'Perception',...
    'Systems Biology', 'Introdutction to Bio-Informatics', 'Evolution and Genetics',...
    'Methods of Cognitive Neuroscience','Methods and Techniques', ...
    'Statistics 1,2 & 3', 'Probability', 'Mathematical Simulation',...
    'Mathematical Modelling', 'Calculus', 'Optimization', 'Machine Learning', 'Natural Language Processing','Numerical Mathematics','Linear Algebra'};
NodeTable = table(COURSES','VariableNames',{'Name'});
s = [1 1 1 1 2 2 2 3 3 3 4, 5 4, 6 6 7, 9,  10, 11 11 11 11, 14 14 14 14 14 14 15 15 15 15 15 16 16 16 16 17 17 17 18 18 19];
t = [2 3 4 5 3 4 5 4 5 7 5, 8 17, 7 8 8, 10, 11, 12 13 17 18, 15 16 17 18 19 20 16 17 18 19 20 17 18 19 20 18 19 20 19 20 20];
EdgeTable = table([s' t'], 'VariableNames',{'EndNodes'});
X = eye(numel(COURSES)); 
X = [X;X;X;X;X;X;X;X;X;X;X;X;X;X];
Y = getEdgeMatrix(s,t,numel(COURSES));
Y = [Y;Y;Y;Y;Y;Y;Y;Y;Y;Y;Y;Y;Y;Y];

% Simulate evolution of neural networks
evolution = Evolution.createExampleEvolution(32, numel(COURSES));
tic;
[evolution, fitnessTrajectoryMeanStandardError] = evolution.evolve(10, X, Y, 1e2);
toc;
%G = graph(EdgeTable,NodeTable);
%figure(); 
% h=plot(G,'NodeLabel',G.Nodes.Name); title('Target course graph');
% set(gcf,'WindowButtonDownFcn',@(f,~)edit_graph(f,h))
%Use vectorization obj(1) = Individual(); obj(2) = etc

[~, loss, a3] = evolution.population{1}.train(X, Y, 1e4);
figure(); plot(loss);
figure(); subplot(2,1,1); heatmap(Y(1:numel(COURSES),:)); subplot(2,1,2); heatmap(a3(1:numel(COURSES),:));

function [E] = getEdgeMatrix(s,t,unitCount)
    E = zeros(unitCount);
    for i = 1:numel(s)
        E(s(i),t(i)) = 1; 
        E(t(i),s(i)) = 1; 
    end
end
