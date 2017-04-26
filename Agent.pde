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
  
  Random rand = new Random();


  public Agent(int metabolism, int vision, int initialSugar, MovementRule m) {
    this.metabolism = metabolism;
    this.vision = vision;
    this.initialSugar = initialSugar;
    this.m = m;
    
    age = 0;
    
    int  numbForSex = rand.nextInt(100) + 1;
    
    if(numbForSex < 50) {
      this.sex = 'X';
    }
    else {
      this.sex = 'Y';
    }

  }
  
  public Agent(int metabolism, int vision, int initialSugar, MovementRule mr, char sex) {
     this.metabolism = metabolism;
    this.vision = vision;
    this.initialSugar = initialSugar;
    this.m = mr;
    
    if(sex == 'X' || sex == 'Y') {
      this.sex = sex;
    }
    else {
      assert(1==0);
    }
  
  }
  
  
  public char getSex() {
    return sex;
  }
  
  
  public void gift(Agent other, int amount) {
  
      //Provided that this agent has at least amount sugar, 
      if(initialSugar >= amount) {
           //transfers that amount from this agent to the other agent. 
           other.setSugarLevel(initialSugar);
           initialSugar = initialSugar - initialSugar;
      }
      else {
          assert(1==0);
      }
  }
  

  public int getMetabolism() {
    return metabolism;
  }
  
  public int getVision() {
    return vision;
  }

  public int getSugarLevel() {
    return initialSugar;
  }
  
  public void setSugarLevel(int x) {
    initialSugar = initialSugar + x;
  }
  
  
  public MovementRule getMovementRule() {
    return m;
  }

  public void move(Square source, Square dest) {
    
    if (source.getAgent() != null) {     
      if (dest.getAgent() == null) {
        dest.setAgent(source.getAgent());
      }
      source.setAgent(null);
    }
    
  }
  
 
   
  public void step(){
    
    //increment the age of the agent
    age++;
    
    // Reduces the agent's stored sugar level by its metabolic rate...
    initialSugar = initialSugar - metabolism;
    
    //...to a minimum value of 0.
    if (initialSugar < 0) {
      initialSugar = 0;
    }
  }
  
  
  public int getAge() {
    return age;
  }
  
   public void setAge(int howOld) {   
     if (howOld >= 0) {
       age = howOld;
     } 
     else {
      assert(1==0);
     }
   }
   
   
   
   public void setMaxAge(int maxAge) {
     if (maxAge >= 0) {
       this.maxAge = maxAge;
     } 
     else {
      assert(1==0);
     }
   }
  
  public int getMaxAge(){
    return maxAge;
  }
  
  
  public boolean isAlive() {
    if (initialSugar > 0) {
      return true;
    }
    else  {
      return false;
    }
  }
  
  
  
  
  public void eat(Square s) {
    initialSugar = initialSugar + s.getSugar();
    s.setSugar(0);
  }
  
  public void display(float x, float y, int scale){
    fill(0);
    ellipse(x, y, 3*scale/4, 3*scale/4);
  }
  
  
}