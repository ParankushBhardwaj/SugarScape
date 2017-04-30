class FertilityRule {

  Map<Character, Integer[]> childbearingOnset;

  Map<Character, Integer[]> climactericOnset;


  Map<Agent, int[]> agentMap;

  Random rand = new Random();

  //below array is used for random ages for sex
  int[] randChildClim = new int[2];

  //holds sugar value 
  int currentSugar;




  public FertilityRule(Map<Character, Integer[]> childbearingOnset, Map<Character, Integer[]> climactericOnset) {
    this.childbearingOnset = childbearingOnset;
    this.climactericOnset = climactericOnset;
  }


  public boolean isFertile(Agent a) {
    if (a == null || a.isAlive() == false) {
      //remove all records of it from any storage it may be present in, then return false
      return false;
    }

    // Generate a random number for the onset of childbearing age (c) 

    boolean x = rand.nextBoolean();

    if (x == true) {
      randChildClim[0] = childbearingOnset.get("X")[0];
    } else if (x == false) {
      randChildClim[0] = childbearingOnset.get("X")[1];
    }



    //Generate a random number for the age of the start of a's climacteric (o),        

    boolean y = rand.nextBoolean();

    if (y == true) {
      randChildClim[1] = climactericOnset.get("X")[0];
    } else if (y == false) {
      randChildClim[1] = climactericOnset.get("X")[1];
    }


    //Store those generated numbers in a way that is associated with a for later retrieval.
    agentMap.put(a, randChildClim);

    //Store the current sugar level of a for retrieval as well.
    currentSugar = a.getSugarLevel();


    //c <= a.getAge() < o, using the values of c and o that were stored for this agent earlier.
    //a currently has at least as much sugar as it did the first time we passed it to this function.

    if ( randChildClim[0] <= a.getAge() && a.getSugarLevel() == currentSugar) {
      return true;
    }


    return false;
  }

  public boolean canBreed(Agent a, Agent b, LinkedList<Square> local) {

    boolean nearby = false;
    boolean space = false;
    /*
      TRUE if : 
     a is fertile.
     b is fertile.
     a and b are of different sexes.
     b is on one of the Squares in local.
     At least on of the Squares in local is empty. 
     */

    if (isFertile(a) && isFertile(b) && a.getSex() != b.getSex()) {

      for (int i = 0; i < local.size(); i++) {
        if (local.get(i).getAgent() == b) {
          nearby = true;
        }
        if (local.get(i).getAgent() == null) {
          space = true;
        }
      }

      if (nearby == true && space == true) {
        return true;
      }
    }

    return false;
  }


  public Agent breed(Agent a, Agent b, LinkedList<Square> aLocal, LinkedList<Square> bLocal) {


    //If a cannot breed with b and b cannot breed with a, then return null. 
    if (canBreed(a, b, aLocal) == true && canBreed(b, a, bLocal) == true) {
      return null;
    }


    //Pick one of the parents' metabolisms, uniformly at random.
    int agentMetabolism;

    boolean meta = rand.nextBoolean();

    if (meta) {
      agentMetabolism = a.getMetabolism();
    } else {
      agentMetabolism = b.getMetabolism();
    }


    //Pick one of the parents' visions, uniformly at random.
    int agentVision;

    boolean vision = rand.nextBoolean();

    if (vision) {
      agentVision = a.getVision();
    } else {
      agentVision = b.getVision();
    }


    //create sugar by taking half from each parent.
    int dadSugar = a.getSugarLevel()/2;
    int momSugar = b.getSugarLevel()/2;

    int agentSugar = dadSugar + momSugar;


    //get a movement rule for the agent
    MovementRule mr = a.getMovementRule();


    //pick a sex for the agent at random
    char agentSex;

    boolean sex = rand.nextBoolean();

    if (sex) {
      agentSex = a.getSex();
    } else {
      agentSex = b.getSex();
    }


    //now create the new baby agent!
    Agent baby = new Agent(agentMetabolism, agentVision, agentSugar, mr, agentSex);


    //below boolean function checks to see if the baby was placed somewhere already.
    boolean placed = false;


    //place baby on empty square in either a or b.
    for (int i = 0; i < aLocal.size(); i++) {
      if (aLocal.get(i).getAgent() == null) {
        aLocal.get(i).setAgent(baby);
        placed = true;
      }
    }

    if (placed == false) {
      for (int i = 0; i < bLocal.size(); i++) {
        if (bLocal.get(i).getAgent() == null) {
          bLocal.get(i).setAgent(baby);
          placed = true;
        }
      }
    }

    //now give the baby some culture!
    baby.nurture(a, b);


    return baby;
  }
  
  
}