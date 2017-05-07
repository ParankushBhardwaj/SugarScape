import java.util.*;

class FertilityRule {

  //below maps are used to determine the childbearing age/climacteric age for each sex.

  //ex: the map {'X' -> [12,15], 'Y' ->[12,15]} might be used to indicate that the start 
  //of the childbearing period is between 12 and 15 years (inclusive) for both sexes.
  Map<Character, Integer[]> childbearingOnset;

  //climacteric means the period of decrease in reproductive capacity.
  //this map tells us the age group of each sex for when they no longer 
  //can reproduce.
  Map<Character, Integer[]> climactericOnset;

  //new hashmap
  Map<Agent, int[]> agentMap;

  //holds sugar value
  int currentSugar;

  Random rand = new Random();


  //constructor, initializes all the maps. (see above for map descriptions).
  public FertilityRule(Map<Character, Integer[]> childbearingOnset, Map<Character, Integer[]> climactericOnset) {
    this.childbearingOnset = childbearingOnset;
    this.climactericOnset = climactericOnset;
    this.agentMap = new HashMap<Agent, int[]>();
  }


  //Below method determines whether Agent a is fertile
  public boolean isFertile(Agent a) {
    if (a == null) {
      //null exception error check. 
      return false;
    }

    if (a.isAlive() == false) {
      //remove all records of it from any storage it may be present in
      agentMap.remove(a);
      return false;
    }
    
    

    //if this is the first time agent is being passed this function, 
    //then it dones't have a age group for childbrearing/climacterics.
    //so give it a random one from its predetermined range.
    if (agentMap.containsKey(a) == false) {

      //get the array of integers within the childbearing map.
      Integer[] childbearingPeriod = childbearingOnset.get(a.getSex());

      //now get the age period for climactericOnset
      Integer[] climactericPeriod = climactericOnset.get(a.getSex());

      //now randomly select from both those groups to determine the agent's cb/cl
      int childbearingAge = (int)random(childbearingPeriod[0], childbearingPeriod[1] + 1);

      int climactericAge =  (int)random(climactericPeriod[0], climactericPeriod[1] + 1);
      
      int sugar = a.getSugarLevel();


      //also store sugar level for later retrieval.
      int[] fertilityAgesAndSugar = {childbearingAge, climactericAge, sugar};

      //agent map now holds the agent and its childbearing/climateric age/sugar.
      agentMap.put(a, fertilityAgesAndSugar);

    }


    //array holding fertility ages.
    int[] whenFertile = agentMap.get(a);

    //returns true when the childbearing age is <= a.getAge() 
    //and when a.getAge() < climacteric age.
    //and if 'a' has at least same amount of sugar as first time it passed this function.

    //we check sugar because the book says that to be parents, 
    //agents must have ammased at least the amount of sugar that they 
    //were endowed with at birth.

    if (whenFertile[0] <= a.getAge() && whenFertile[1] >  a.getAge() && whenFertile[2] <= a.getSugarLevel()) {
      return true;
    } else { 
      return false;
    }
  }
  
  

  //this method checks if two agents can breed.
  public boolean canBreed(Agent a, Agent b, LinkedList<Square> local) {

    /*
      TRUE if : 
     a is fertile.
     b is fertile.
     a and b are of different sexes.
     b is on one of the Squares in local.
     At least on of the Squares in local is empty. 
    */
 
    
    boolean squareIsInLocal = false;
    boolean localSquareIsEmpty = false;
    
      //if a and b are fertile and different sexes
      if (isFertile(a) && isFertile(b) && a.getSex() != b.getSex()) {
        for (int i = 0; i < local.size(); i++) {
          
          //and if b is in one of the squares in local
          if (local.get(i).getAgent() != null) {
            if (local.get(i).getAgent().equals(b)) {
              squareIsInLocal = true;
            }
          }
          
          //and at least one square in local is empty
          if (local.get(i).getAgent() == null) {
            localSquareIsEmpty = true;
          }
          
        }
      }
 
     //if all four are true, then return true.
     if(squareIsInLocal == true && localSquareIsEmpty == true) {
       return true;
     }
     else {
      return false;
     }
  }



  //Creates and places a new Agent that is the offspring of a and b
  public Agent breed(Agent a, Agent b, LinkedList<Square> aLocal, LinkedList<Square> bLocal) {

    //If a cannot breed with b and b cannot breed with a, then return null. 
    if (canBreed(a, b, aLocal) == false && canBreed(b, a, bLocal) == false) {
      return null;
    }
    
    
    //Pick one of the parents' metabolisms, uniformly at random.
    int agentMetabolism;

    boolean momsMetabolism = rand.nextBoolean();

    if (momsMetabolism == true) {
      agentMetabolism = a.getMetabolism();
    } else {
      agentMetabolism = b.getMetabolism();
    }



    //Pick one of the parents' visions, uniformly at random.
    int agentVision;

    boolean vision = rand.nextBoolean();

    if (vision == true) {
      agentVision = a.getVision();
    } else {
      agentVision = b.getVision();
    }
    
    

    //get a movement rule for the agent
    MovementRule mr = a.getMovementRule();




    //pick a sex for the agent at random
    char agentSex;

    boolean sex = rand.nextBoolean();

    if (sex == true) {
      agentSex = 'X';
    } else {
      agentSex = 'Y';
    }


    //now create the new baby agent!
    Agent baby = new Agent(agentMetabolism, agentVision, 0, mr, agentSex);
    
    
    //give the baby half sugar from both parents so it doesn't instantly die.
    a.gift(baby,agentMap.get(a)[2]/2);
    b.gift(baby,agentMap.get(b)[2]/2);


    //now give the baby some culture!
    baby.nurture(a, b);
    

    //to place the baby, get a list of possible squares it can go to.
    
    //LinkedList<Square> babySquares = getEmptySquare(aLocal,bLocal);
    LinkedList<Square> babySquares  = new LinkedList<Square>();
    
    for (int i = 0; i < aLocal.size(); i++) {
      if (aLocal.get(i).getAgent() == null) {
        babySquares.add(aLocal.get(i));
      }
    }
    
    for (int i = 0; i < bLocal.size(); i++) {
      if (bLocal.get(i).getAgent() == null) {
        babySquares.add(bLocal.get(i));
      }
    }

    
    //now pick a square randomly.
    Collections.shuffle(babySquares);
    babySquares.get(0).setAgent(baby);

    return baby;
  }
  
  
}