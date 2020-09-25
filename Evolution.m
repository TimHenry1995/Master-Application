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
        
        function generate(self, fitnessScores, competitionSetSize=4):
    # Eliminate the least fit individuals
    eliminationCount = self.eliminate(fitnessScores, competitionSetSize)

    # Mate among the fittest to replenish the population.
    f = 0; m = 1
    offspring = [None] * eliminationCount
    c = 0
    while c < eliminationCount:
      # Advance counters
      while self.population[f] == None: f+=1
      while m == f or self.population[m] == None: m+=1
      # Replenish population
      offspring[c] = Evolution.mate(self.population[m], self.population[f])
      c+= 1

    c = 0;
    # Replace the previous generation by the current one
    for i in range(len(self.population)):
      if self.population[i] == None: self.population[i] = offspring[c]
      c += 1

    # Introduce some mutations

    # Return an aggragate of the overall fittness of the population 
    return np.mean(fitnessScores)
    end
end

  def 

def demonstrateEvolution(populationSize):
  networkSizes = [NetworkSize(hiddenNeuronCount=1), NetworkSize(hiddenNeuronCount=2), NetworkSize(hiddenNeuronCount=3)]
  initializers = [Initializer(kind="uniform"), Initializer(kind="normal")]
  weightActivationFunctions = [WeightActivationFunction(kind="sigmoid", scale=3), WeightActivationFunction(kind="sigmoid", scale=1), WeightActivationFunction(kind="relu", scale=3), WeightActivationFunction(kind="relu", scale=1)]
  learningRateCalculators = [LearningRateCalculator(alpha=0.05, decay=0.9999), LearningRateCalculator(alpha=0.01, decay=0.999999)]
  
  population = [None] * populationSize
  for i in range(populationSize):
    genotype = Genotype(chromosomes = [rnd.choice(networkSizes), rnd.choice(initializers), rnd.choice(weightActivationFunctions), rnd.choice(learningRateCalculators)])
    phenotype = Phenotype(genotype)
    population[i] = (genotype, phenotype)

  evolution = Evolution(population)
  print("Average fitness of first generation: " + str(evolution.generate(fitnessScores=[2,6,8,4])))

  return population

pop = demonstrateEvolution(4)

