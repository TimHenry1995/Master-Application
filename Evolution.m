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
        
        function [obj, eliminationCount] = eliminate(obj, fitnessScores, competitionSetSize)
            %METHOD1 Summary of this method goes here
            %   Assumes that population size is an integer multiple of competitionSetSize
            %   Mutates the obj.population array such that some Individuals
            %   are replaced with the empty vector.

            % Partition the population into arbitrary tuples of competitionSetSize and delete the least fit indivdual
            eliminationCount = 0;
            for c = 0:(floor(numel(obj.population)/competitionSetSize)-1)
              subset = fitnessScores(c*competitionSetSize+1: (c+1)*competitionSetSize);
              minIndices = find(subset == min(subset));
              obj.population{c*competitionSetSize + minIndices(1)} = [];
              eliminationCount = eliminationCount + 1;
            end
        end
        
        function [obj, overallFitness] = generate(obj, fitnessScores, competitionSetSize)
            overallFitness = sum(fitnessScores);
            % Eliminate the least fit individuals
            [obj, eliminationCount] = obj.eliminate(fitnessScores, competitionSetSize);

            % Mate among the fittest to replenish the population.
            offspring = Individual.empty(0,eliminationCount);
            o = 0; f = 1; m = 2; % count for offspring, fathers and mothers
            while o < eliminationCount
              % Advance counters
              while numel(obj.population{f}) == 0 % Cell is non-empty
                  f = f + 1;
              end
              while m == f || numel(obj.population{m}) == 0  % Cell is non-empty and not yet used by father
                  m = m+1;
              end
              % Replenish population
              offspring{o+1} = Evolution.mate(obj.population{m}, obj.population{f});
              o = o + 1;
            end

            % Replace the previous generation by the current one
            o = 1;
            for i = 1:numel(obj.population)
              if numel(obj.population{i}) == 0 % An empty cell is found
                  obj.population{i} = offspring{o};
                  o = o+1;
              end
            end

            % Introduce some mutations

        end
    end
    
    methods(Static)
        function [individual] = mate(mother, father)
            % Flip a coin to determine which allele is copied from the father and which one from the mother
            offspringChromosomes = Chromosome.empty(0,numel(father.genotype.chromosomes));
            for c = 1:numel(father.genotype.chromosomes)
              if rand(1) < 0.5
                offspringChromosomes{c} = father.genotype.chromosomes{c}.replicate();
              else
                offspringChromosomes{c} = mother.genotype.chromosomes{c}.replicate();
              end
            end
            offspringGenotype = Genotype(offspringChromosomes);
            offspringPhenoType = Phenotype(offspringGenotype, father.phenotype.inputOutputNeuronCount);
            individual = Individual(offspringGenotype, offspringPhenoType);
        end
        
        function [] = testGenerate()
            % Tests the generate method by checking whether it cultivates a
            % population with where most individuals have a genotype
            % encoding a unfiorm synapse initializer for neurons when 
            % starting out with an even split between uniform and normal 
            % initializers.
            populationSizeSmall = 10; populationSizeMedium=100; populationSizeLarge=1000;
            evolutionSmall = Evolution.createExampleEvolution(populationSizeSmall);
            evolutionMedium = Evolution.createExampleEvolution(populationSizeMedium);
            evolutionLarge = Evolution.createExampleEvolution(populationSizeLarge);
            
            generationCount = 10;
            favourCountsSmall = zeros(1,generationCount);
            favourCountsMedium = zeros(1,generationCount);
            favourCountsLarge = zeros(1,generationCount);
            
            for g = 1:generationCount
                fitnessSmall = Evolution.getTestFitness(evolutionSmall.population);
                favourCountsSmall(g) = sum(fitnessSmall);
                [evolutionSmall, ~] = evolutionSmall.generate(fitnessSmall, 4);
                
                fitnessMedium = Evolution.getTestFitness(evolutionMedium.population);
                favourCountsMedium(g) = sum(fitnessMedium);
                [evolutionMedium, ~] = evolutionMedium.generate(fitnessMedium, 4);
                
                fitnessLarge = Evolution.getTestFitness(evolutionLarge.population);
                favourCountsLarge(g) = sum(fitnessLarge);
                [evolutionLarge, ~] = evolutionLarge.generate(fitnessLarge, 4);
            end
            
            figure; hold on; plot(favourCountsSmall/populationSizeSmall); plot(favourCountsMedium/populationSizeMedium); plot(favourCountsLarge/populationSizeLarge); 
            title('Demonstration of Natural Selection'); xlabel('Generation'); ylabel('Count of favoured individuals');
            legend(join([num2str(populationSizeSmall),' Individuals']),...
                join([num2str(populationSizeMedium),' Individuals']),...
                join([num2str(populationSizeLarge),' Individuals']));
        end
        
        function [fitness] = getTestFitness(population)
            fitness = zeros(1,numel(population));
            for i = 1:numel(population)
                if population{i}.genotype.synapseInitializer.kind == "uniform"
                    fitness(i) = fitness(i) + 1;
                end
                if population{i}.genotype.learningRateCalculator.alpha == 0.05
                    fitness(i) = fitness(i) + 1;
                end
                if population{i}.genotype.activationFunction.kind == "relu"
                    fitness(i) = fitness(i) + 1;
                end
            end
        end
        
        function [evolution] = createExampleEvolution(populationSize)
            networkSizes = [NetworkSize(1), NetworkSize(2), NetworkSize(3)];
            initializers = [SynapseInitializer("uniform"), SynapseInitializer("normal")];
            activationFunctions = [ActivationFunction("sigmoid", 3), ActivationFunction("sigmoid", 1), ActivationFunction("relu", 3), ActivationFunction("relu", 1)];
            learningRateCalculators = [LearningRateCalculator(0.05, 0.9999), LearningRateCalculator(0.01, 0.999999)];

            % Set up the populaiton
            population = cell.empty(0,populationSize);
            inputOutputNeuronCount = 10;
            for i = 1:populationSize
                chromosomes = {randsample(networkSizes, 1), randsample(initializers, 1), randsample(activationFunctions, 1), randsample(learningRateCalculators, 1)};
                genotype = Genotype(chromosomes);
                population{i} = Individual(genotype, Phenotype(genotype, inputOutputNeuronCount));
            end
            evolution = Evolution(population);
        end
        
        function [] = demonstrate()
            evolution = Evolution.createExampleEvolution(8);
            fitnessScores = [2,6,8,4,6,4,7,2];
            [~, overallFitness] = evolution.generate(fitnessScores, 4);
            fprintf("Average fitness of first generation: %d", overallFitness);
        end
    end
end