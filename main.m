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



