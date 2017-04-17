import java.util.*;

class Square {
  
  int sugarLevel;
  int sugarLevelMax;
  int x;
  int y;
  
  int size;
  
  int pollution = 0;
  
  int scale;
   
  Agent a = null;

  public Square(int sugarLevel, int sugarLevelMax, int x, int y) {
    this.sugarLevel = sugarLevel;
    this.sugarLevelMax = sugarLevelMax;
    this.x = x;
    this.y = y;
    
    this.pollution = 0;
  }
  
  public int getX(){
    return x;
  }
  
  public int getY(){
    return y;
  }
  
  public int getSugar(){
    return sugarLevel;
  }
  
  public int getMaxSugar(){
    return sugarLevelMax;
  }
  
  
  public int getPollution(){
    return pollution;
  }
  
   public void setPollution(int level){
    pollution = level;
  }
  
  void setSugar(int desiredAmount) {
    //account for desiredAmount > 0
    if (desiredAmount < 0) {
      sugarLevel = 0;
    }
    else if (desiredAmount > sugarLevelMax) {
      sugarLevel = sugarLevelMax;
    }
    else  {
      sugarLevel = desiredAmount;
    }
  }
  
  
  void setMaxSugar(int desiredAmount) {
    if (desiredAmount < 0) {
      sugarLevelMax = 0;
      sugarLevel = 0;
    }
    else {
      sugarLevelMax = desiredAmount;
    }
    
    //in case the new max is smaller than the current sugar level ... 
    if (sugarLevel > sugarLevelMax){
      sugarLevel = desiredAmount;
    }
    
  }
  
  public Agent getAgent() {
   return a;
  }
  
  public void setAgent(Agent a) { //this.a == current, a = specified.
  
    this.a = a;
    
    if (this.a == null) {
      this.a = a;
    }
    else if (this.a != null){
      if (this.a == a) {
        this.a = a;
      }
      else if (a == null) {
        this.a = a;
      }     
      else {
        //assert(1==0);
      }
    }
  }
  
  public void display(int size) {
    this.size = size;
    stroke(255);
    strokeWeight(4);
    
    fill(255, 255, 255 - sugarLevel/6.0*255);
    rect(size*x, size*y, size, size);
    
    if (a != null) {
      a.display(size*x + size/2, size*y + size/2, size);
    }
  }
  
}