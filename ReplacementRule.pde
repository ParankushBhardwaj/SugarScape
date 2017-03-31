class ReplacementRule {
  
  int minAge = 0;
  int maxAge = 0;
  AgentFactory fac;
  
  //SugarSeekingMovementRule mr;
  //LinkedList<Square> neighbourhood
  
  LinkedList<Agent> agents;
  
  LinkedList<Integer> ages;
  


  public ReplacementRule(int minAge, int maxAge, AgentFactory fac) {
    this.minAge = minAge;
    this.maxAge = maxAge;
    
    this.fac = fac;
  }


  public boolean replaceThisOne(Agent a) {
    
    //if the agent has never gone through replacement rule, do the bottom stuff...
    
    if (a.getMaxAge() == 0) {
      
        //generate a random lifespan for the agent.
        int lifespan = (int)(random(minAge, maxAge + 1));
        
        //set that lifespan to agent's max age.
        a.setMaxAge(lifespan);

    }  
    
    //replace agent if its starved to death.
    if (a.isAlive() == false) {
        return true;
    }
    
    //replace agent if it reached its life expectancy.
    
    if (a.getAge() > a.getMaxAge()) { 
      
        a.setAge(a.getMaxAge() + 1);
        return true;
    }
    else {
      return false;
    }
  }
  
  
  
  public Agent replace(Agent a, List<Agent> others){
    return fac.makeAgent(); 
  }  
  
  

}