import java.util.*;

class Agent {

  Square dest;
  int metabolism;
  int vision;
  int initialSugar;

  int age = 0;

  int maxAge = 0;

  char sex;

  MovementRule m;

  Random random = new Random();


  boolean[] culture = new boolean[11];


  public Agent(int metabolism, int vision, int initialSugar, MovementRule m) {

    //when making a new agent, initiazlie their vars 
    this.metabolism = metabolism;
    this.vision = vision;
    this.initialSugar = initialSugar;
    this.m = m;
    this.age = 0;

    //in this constructor, sex is randomly determined.
    //use a random boolean function to determine sex.
    boolean isMale = random.nextBoolean();

    if (isMale == true) {
      this.sex = 'X';
    } else {
      this.sex = 'Y';
    }

    //initialze 'culture' with 11 cultural characteristics.
    culture = new boolean[11];

    //each cell of the array in cultures is set to a value 
    //selected uniformly at random.
    for (int i = 0; i < culture.length; i++) {
      culture[i] = random.nextBoolean();
    }
  }



  //this second constructor is used to create agents who have a predetermined sex
  //when two normal agents reproduce, the baby agen will use this consturctor, thier
  //sex will be determiend by their parent's genes.
  public Agent(int metabolism, int vision, int initialSugar, MovementRule mr, char sex) {
    this.metabolism = metabolism;
    this.vision = vision;
    this.initialSugar = initialSugar;
    this.m = mr;

    if (sex == 'X' || sex == 'Y') {
      this.sex = sex;
    } else {
      //if sex is not X or Y, then the consturctor was created improperly.
      print("Enter either X or Y for sex.");
      assert(1==0);
    }


    //init culture
    culture = new boolean[11];

    //each cell of the array is set to a value selected uniformly at random in all constructors. 
    for (int i = 0; i < culture.length; i++) {
      culture[i] = random.nextBoolean();
    }
  }







  //MARK: Below are basic getter methods for agent descriptions.

  public int getMetabolism() {
    return metabolism;
  }

  public int getVision() {
    return vision;
  }

  public int getSugarLevel() {
    return initialSugar;
  }

  public MovementRule getMovementRule() {
    return m;
  }








  //MARK: below are all the agent's basic actions (moving and eating, updates.)

  /*
  Moves the agent from source to destination. If the destination is already occupied, 
   the program should crash with an assertion error instead, unless the destination is the 
   same as the source.
   */
  public void move(Square source, Square dest) {

    //if the destination is same place as source, do nothing.
    if (dest.getAgent() != null && dest.equals(source) == true) {
      //nothing.
    }
    //if the destination is occupied, crash program. Agets shouldn't be planning
    //to move to a filled location.
    else if (dest.getAgent() != null && dest.equals(source) == false) {
      println("Agents are moving to squares that already have agents.");
      assert(1==0);
    }
    //if dest has no agent, move the agent there, set source's agent to null.
    else {
      source.setAgent(null);
      dest.setAgent(this);
    }
  }


  public void eat(Square s) {
    initialSugar = initialSugar + s.getSugar();
    s.setSugar(0);
  }



  //this method is called for each frame of the program. 
  public void step() {

    //increment the age of the agent (they grow up so fast).
    age++;

    // Reduces the agent's stored sugar level by its metabolic rate...
    initialSugar = initialSugar - metabolism;

    //...to a minimum value of 0.
    if (initialSugar < 0) {
      initialSugar = 0;
    }
  }









  //MARK: Below methods are for sexual reproduction/fertility.


  //this method returns the sex of the agent.
  public char getSex() {
    return sex;
  }

  //this method is used for agents to give sugar to their offspring.
  public void gift(Agent other, int amount) {

    //Provided that this agent has at least amount sugar, 
    if (initialSugar >= amount) {
      //transfers that amount from this agent to the other agent. 
      other.initialSugar =  other.initialSugar + amount;
      this.initialSugar = initialSugar - amount;
    } else {
      //throw an error if there wasn't enough sugar because
      //reproduction should only happen if there was enough sugar.
      print("Agents are reproducing despite having too low sugar.");
      assert(1==0);
    }
  }







  //MARK: Below methods are used primarily for the replacement rule, 
  //to replace agents after a specific time. 


  public int getAge() {
    return age;
  }


  public void setAge(int howOld) {   
    if (howOld >= 0) {
      age = howOld;
    } else {
      //if your setting an age that's negative, 
      //your doing something wrong. 
      print("Your making an agent less than 0 years old.");
      assert(1==0);
    }
  }


  public boolean isAlive() {
    if (initialSugar > 0) {
      return true;
    } else {
      return false;
    }
  }








  //MARK: below methods are used to handle the agent's culture.


  //this method is used to change another agent's culture (just one element though)
  public void influence(Agent other) {

    //picks a random trait from the 11 to influence.
    int  specificCulturalTrait = random.nextInt(11);

    //If other's culture does not match this Agent's culture in the selected 
    //cultural attribute, then mutate other's culture to match the culture of this agent.
    if (other.culture[specificCulturalTrait] != this.culture[specificCulturalTrait]) {
      other.culture[specificCulturalTrait] = this.culture[specificCulturalTrait];
    }
  }


  /*For each of the 11 dimensions of culture, nurture sets this Agent's value for that 
    dimension to be one of the two parent values, selected uniformly at random. 
  */
  public void nurture(Agent parent1, Agent parent2) {

    for (int i = 0; i < culture.length; i++) {

      boolean x = random.nextBoolean();

      if (x == true) { 
        culture[i] = parent1.culture[i];
      } else {
        culture[i] = parent2.culture[i];
      }
    }
  }


  //this is used for determining which of the two cultures the agent is in, 
  //if of the 11 traits, more than half are true, it's in culture group A. 
  //if there are more falses than trues, it's in culture group B.
  public boolean getTribe() {

    int numberOfTrues = 0;
    int numberOfFalses = 0; //a.k.a. number of alternative trues.

    //count the trues/falses of the agent's cultural traits.
    for (int i = 0; i < culture.length; i++) {
      if (culture[i] == true) {
        numberOfTrues++;
      } else {
        numberOfFalses++;
      }
    }

    //now determine which ones greater.
    if (numberOfTrues > numberOfFalses) {
      return true;
    } else {
      return false;
    }
  }
  
  
  public void display(int x, int y, int scale) {
    
    stroke(0);
    fill(0);
    ellipse(x,y,(3*scale)/4,(3*scale)/4);
  }
  
   
   public void display(int x, int y, int scale, boolean culture, boolean fertility, boolean sex, FertilityRule FertRule) {
    
     if (culture == true) {
      if (this.getTribe()) {
        fill(255,0,0);
      }
      else {
        fill(0,0,255);
      }
    }
    else if (fertility == true){
      if (FertRule.isFertile(this)) {
        fill(15, 215, 15);
      }
      else {
        fill(134, 85, 45);
      }
    }
    else if (sex == true){
      if (this.getSex() == 'X') {
        fill(93, 173, 255);
      }
      else {
        fill(255, 105, 180);
      }
    }
    stroke(0);
    ellipse(x,y,(3*scale)/4,(3*scale)/4);
    fill(0);
  }
}