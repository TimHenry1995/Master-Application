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

            % Partition the population into arbitrary tuples of competitionSetSize and delete the least fit indivdual
            eliminationCount = 0;
            for c = 1:(numel(floor(obj.population)/competitionSetSize) -1)
              subset = fitnessScores(c*competitionSetSize: (c+1)*competitionSetSize);
              obj.population(c*competitionSetSize + np.argmin(subset)) = nan;
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
            eliminationCount = obj.eliminate(fitnessScores, competitionSetSize)

            % Mate among the fittest to replenish the population.
            offspring = nan(1,eliminationCount);
            o = 0; f = 0; m = 1; % count for offspring, fathers and mothers
            while o < eliminationCount
              % Advance counters
              while isnan(obj.population(f))
                  f = f + 1;
              end
              while m == f || isnan(self.population(m))
                  m = m+1;
              end
              % Replenish population
              offspring(c) = Evolution.mate(obj.population(m), self.population(f))
              o = o + 1;
            end

            % Replace the previous generation by the current one
            o = 0;
            for i = 1:numel(obj.population)
              if isnan(obj.population(i))
                  obj.population(i) = offspring(o);
              end
              o = o+1;
            end

            % Introduce some mutations

        end
    end
    
    methods(Static)
        function [] = demonstrate()
            networkSizes = [NetworkSize(1), NetworkSize(2), NetworkSize(3)];
            initializers = [Initializer("uniform"), Initializer("normal")];
            weightActivationFunctions = [WeightActivationFunction("sigmoid", 3), WeightActivationFunction("sigmoid", 1), WeightActivationFunction("relu", 3), WeightActivationFunction("relu", 1)];
            learningRateCalculators = [LearningRateCalculator(0.05, 0.9999), LearningRateCalculator(0.01, 0.999999)];
            
            % Set up the populaiton
            populationSize = 8;
            population = nan(1,populationSize);
            for i = 1:populationSize
                chromosomes = [randsample(networkSizes, 1), randsample(initializers, 1), randsample(weightActivationFunctions, 1), randsample(learningRateCalculators, 1)];
                population(i).genotype = Genotype(chromosomes);
                population(i).phenotype = Phenotype(genotype);
            end

            evolution = Evolution(population);
            fitnessScores = [2,6,8,4];
            overallFitness = evolution.generate(fitnessScores);
            print("Average fitness of first generation: " + str(overallFitness));
        end
    end
end