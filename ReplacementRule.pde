import java.util.*;
class ReplacementRule {
  
  int minAge = 0;
  int maxAge = 0;
  AgentFactory fac;
  
  HashMap<Agent, Integer> agentWithAge;

  public ReplacementRule(int minAge, int maxAge, AgentFactory fac) {
    this.minAge = minAge;
    this.maxAge = maxAge;
    
    this.fac = fac;
    this.agentWithAge = new HashMap<Agent, Integer>();
  }
  

  public boolean replaceThisOne(Agent a) {
    
    //null check
    if(a == null){
      return false;
    }
    
    
    //replace agent if its starved to death.
    if (a.isAlive() == false) {
        return true;
    }
    
 
    //if the agent has never gone through replacement rule, do the bottom stuff...
    if (agentWithAge.containsKey(a) == false) {
      
        //generate a random lifespan for the agent.
        int lifespan = (int)(random(minAge, maxAge + 1));
        
        //set that lifespan to agent's max age.
        this.agentWithAge.put(a, lifespan);
    }  
 
 
    //replace agent if it reached its life expectancy.
    if (a.getAge() > agentWithAge.get(a)) { 
        a.setAge(this.maxAge + 1);
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