% Specify courses and their relations as a graph
COURSES = {'Graph Theory', 'Discrete Mathematics', 'Theoretical Computerscience', 'Perception', 'Learning and Memory', 'Action'};
NodeTable = table(COURSES','VariableNames',{'Name'});
s = [1 1 1 2 3];
t = [2 5 6 3 4];
EdgeTable = table([s' t'], 'VariableNames',{'EndNodes'});
G = graph(EdgeTable,NodeTable);
figure(); 
plot(G,'NodeLabel',G.Nodes.Name); title('Target course graph');

Use vectorization obj(1) = Individual(); obj(2) = etc

class Initializer(Chromosome):
  def __init__(self, kind):
    super(Initializer, self).__init__()
    self.kind = kind

  def __call__(self, scale, inputSize, outputSize):
    if self.kind == "normal": 
      return np.random.normal(scale=scale, size=(inputSize, outputSize))
    elif self.kind == "uniform":
      return np.random.uniform(low=-scale/2, high=scale/2, size=(inputSize, outputSize))

class WeightActivationFunction(Chromosome):
  def __init__(self, kind, scale):
    super(WeightActivationFunction, self).__init__()
    self.scale = scale; self.kind = kind

  def __call__(self):
    if self.kind == "relu":
      return np.max(0, self.scale*x)
    elif self.kind == "sigmoid":
      return 1/(1+ np.exp(-self.scale*x))

class LearningRateCalculator(Chromosome):
  def __init__(self, alpha, decay):
    self.alpha = alpha; self.decay = decay
  
  def __call__(self):
    self.alpha = self.alpha * self.decay;
    return self.alpha 

class Genotype():
  def __init__(self, chromosomes):
    self.chromosomes = chromosomes

class Phenotype():
  def __init__(self, genotype):
    pass
    #self.Theta1 = genotype.initializer(genotype.weightActivationFunction.scale, len(INDEX_TO_COURSE), genotype.networkSize.hiddenNeuronCount)
    #self.Theta2 = genotype.initializer(genotype.weightActivationFunction.scale, genotype.networkSize.hiddenNeuronCount, len(INDEX_TO_COURSE))

class Evolution():
  def __init__(self, population):
    self.population = population

  def eliminate(self, fitnessScores, competitionSetSize):
    # Assumes that population size is an integer multiple of competitionSetSize

    # Partition the population into arbitrary tuples of competitionSetSize and delete the least fit indivdual
    eliminationCount = 0
    for c in range(len(self.population)//competitionSetSize -1):
      subset = fitnessScores[c*competitionSetSize: (c+1)*competitionSetSize]
      self.population[c*competitionSetSize + np.argmin(subset)] = None
      eliminationCount += 1

    return eliminationCount

  @staticmethod
  def mate(father, mother):
    # Flip a coin to determine which allele is copied from the father and which one from the mother
    offspringChromosomes = [None] * len(father.genotype.chromosomes)
    for c in range(len(offspringChromosomes)):
      if bool(rnd.getrandbits(1)):
        offspringChromosomes[c] = father.genotype.chromosomes[c]
      else: 
        offspringChromosomes[c] = mother.genotype.chromosomes[c]
    offspringGenotype = Genotype(offspringChromosomes)

    return (offspringGenotype, Phenotype(offspringGenotype))

  def generate(self, fitnessScores, competitionSetSize=4):
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