
class AgentFactory {

  int minMetabolism;
  int maxMetabolism;
  int minVision;
  int maxVision;
  int minInitialSugar;
  int maxInitialSugar;
  MovementRule m;

  Agent a;

  public AgentFactory(int minMetabolism, int maxMetabolism, int minVision, int maxVision, int minInitialSugar, int maxInitialSugar, MovementRule m) {
    this.minMetabolism = minMetabolism;
    this.maxMetabolism = maxMetabolism;
    this.minVision = minVision;
    this.maxVision = maxVision;
    this.minInitialSugar = minInitialSugar;
    this.maxInitialSugar = maxInitialSugar;
    this.m = m;
  }


  //given the parameters for all the agent's attribtues, makes bunch of divers 
  //agents very quickly.
  public Agent makeAgent() {

    //generate the metaboism, vision, and sugar for the agent by randomly selecting between min and max values
    int metabolism = (int)(random(minMetabolism, maxMetabolism + 1));

    int vision = (int)(random(minVision, maxVision + 1));

    int initialSugar = (int)(random(minInitialSugar, maxInitialSugar + 1));

    a = new Agent(metabolism, vision, initialSugar, m);


    return a;
  }
}