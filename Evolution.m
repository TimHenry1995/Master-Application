classdef Evolution
    %EVOLUTION Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        population;
    end
    
    methods
        function obj = Evolution(population)
            %EVOLUTION Construct an instance of this class
            %   Detailed explanation goes here
            obj.population = population;
        end
        
        function [eliminationCount] = eliminate(obj, fitnessScores, competitionSetSize)
            %METHOD1 Summary of this method goes here
            %   Assumes that population size is an integer multiple of competitionSetSize
            %   Mutates the obj.population array such that some Individuals
            %   are replaced with the empty vector.

            % Partition the population into arbitrary tuples of competitionSetSize and delete the least fit indivdual
            eliminationCount = 0;
            for c = 1:(floor(numel(obj.population)/competitionSetSize)-1)
              subset = fitnessScores(c*competitionSetSize: (c+1)*competitionSetSize-1);
              minIndices = find(subset == min(subset));
              obj.population{c*competitionSetSize + minIndices(1)} = [];
              eliminationCount = eliminationCount + 1;
            end
        end
        
        function [offspringGenotype, offspringPhenoType] = mate(mother, father)
            % Flip a coin to determine which allele is copied from the father and which one from the mother
            offspringChromosomes = nan(1,numel(father.genotype.chromosomes));
            for c = 1:numel(offspringChromosomes)
              if rand(1) < 0.5
                offspringChromosomes(c) = father.genotype.chromosomes(c).replicate();
              else
                offspringChromosomes(c) = mother.genotype.chromosomes(c).replicate();
              end
            end
            offspringGenotype = Genotype(offspringChromosomes);
            offspringPhenoType = Phenotype(offspringGenotype);
        end
        
        function overallFitness = generate(obj, fitnessScores, competitionSetSize)
            overallFitness = sum(fitnessScores);
            % Eliminate the least fit individuals
            eliminationCount = obj.eliminate(fitnessScores, competitionSetSize);

            % Mate among the fittest to replenish the population.
            offspring = Individual.empty(0,eliminationCount);
            o = 1; f = 1; m = 2; % count for offspring, fathers and mothers
            while o < eliminationCount
              % Advance counters
              while numel(obj.population{f}) == 1 % Cell is non-empty
                  f = f + 1;
              end
              while m == f || numel(obj.population{m}) == 1  % Cell is non-empty and not yet used by father
                  m = m+1;
              end
              % Replenish population
              offspring{o} = Evolution.mate(obj.population{m}, self.population{f});
              o = o + 1;
            end

            % Replace the previous generation by the current one
            o = 1;
            for i = 1:numel(obj.population)
              if numel(obj.population{i}) == 0 % An empty cell is found
                  obj.population{i} = offspring(o);
              end
              o = o+1;
            end

            % Introduce some mutations

        end
    end
    
    methods(Static)
        function [] = demonstrate()
            networkSizes = [NetworkSize(1), NetworkSize(2), NetworkSize(3)];
            initializers = [SynapseInitializer("uniform"), SynapseInitializer("normal")];
            activationFunctions = [ActivationFunction("sigmoid", 3), ActivationFunction("sigmoid", 1), ActivationFunction("relu", 3), ActivationFunction("relu", 1)];
            learningRateCalculators = [LearningRateCalculator(0.05, 0.9999), LearningRateCalculator(0.01, 0.999999)];
            
            % Set up the populaiton
            populationSize = 8;
            population = cell.empty(0,populationSize);
            inputOutputNeuronCount = 10;
            for i = 1:populationSize
                chromosomes = {randsample(networkSizes, 1), randsample(initializers, 1), randsample(activationFunctions, 1), randsample(learningRateCalculators, 1)};
                genotype = Genotype(chromosomes);
                population{i} = Individual(genotype, Phenotype(genotype, inputOutputNeuronCount));
            end

            evolution = Evolution(population);
            fitnessScores = [2,6,8,4,6,4,7,2];
            overallFitness = evolution.generate(fitnessScores, 4);
            sprintf("Average fitness of first generation: %d", overallFitness)
        end
    end
end