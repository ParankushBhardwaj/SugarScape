import java.util.*;

class Square {

  int sugarLevel;
  int sugarLevelMax;
  int x;
  int y;
  int size;
  int pollution;
  int scale;
  boolean hasAgent;
  Agent a = null;

  public Square(int sugarLevel, int sugarLevelMax, int x, int y) {
    this.sugarLevel = sugarLevel;
    this.sugarLevelMax = sugarLevelMax;
    this.x = x;
    this.y = y;
    this.size = 0;
    this.pollution = 0;
    this.scale = 0;
    this.hasAgent = false;
    this.a = null;
  }

  public int getX() {
    return x;
  }

  public int getY() {
    return y;
  }

  public int getSugar() {
    return sugarLevel;
  }

  public int getMaxSugar() {
    return sugarLevelMax;
  }


  public int getPollution() {
    return pollution;
  }

  public void setPollution(int level) {
    pollution = level;
  }

  void setSugar(int desiredAmount) {
    //account for desiredAmount > 0

    if (desiredAmount < 0) {
      sugarLevel = 0;
    } else if (desiredAmount > sugarLevelMax) {
      sugarLevel = sugarLevelMax;
    } else {
      sugarLevel = desiredAmount;
    }
  }


  void setMaxSugar(int desiredAmount) {
    if (desiredAmount < 0) {
      sugarLevelMax = 0;
      sugarLevel = 0;
    } else {
      sugarLevelMax = desiredAmount;
    }

    //in case the new max is smaller than the current sugar level ... 
    if (sugarLevel > sugarLevelMax) {
      sugarLevel = desiredAmount;
    }
  }


  public Agent getAgent() {
    return a;
  }


  public void setAgent(Agent agent) { 

    //null checkpoint
    if (agent != null && this.hasAgent == true && this.a.equals(agent) == false) {
      //error if there is a existing agent that isn't equal to the given agent.
      assert(1 == 0);
    } else if (agent == null) {
      hasAgent = false;
      this.a = null;
    } else {
      hasAgent = true;
      this.a = agent;
    }
  }
  
  
  public void display(int size) {
    
    stroke(255);
    strokeWeight(4);

    fill(255, 255 , 255 - (this.sugarLevel/4.0)*255);
    rect(size * x, size * y, size, size);
    
    if (a != null) {
      a.display((size * x) + (size/2),(size * y) + (size/2), size);
    }
  }


  
  public void display(int size, boolean culture, boolean fertility, boolean sex, FertilityRule FertRule) {
    
    stroke(255);
    strokeWeight(4);

    fill(255, 255 , 255 - (this.sugarLevel/4.0)*255);
    rect(size * x, size * y, size, size);
    
    if (a != null) {
      a.display((size * x) + (size/2),(size * y) + (size/2), size, culture, fertility, sex, FertRule);
    }
  }
  
}