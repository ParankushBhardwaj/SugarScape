class FertilityRule {
  
 Map<Character, Integer[]> childbearingOnset;
 
 Map<Character,Integer[]> climactericOnset;

 public FertilityRule(Map<Character, Integer[]> childbearingOnset, Map<Character,Integer[]> climactericOnset)  {
   this.childbearingOnset = childbearingOnset;
   this.climactericOnset = climactericOnset;
 
 }


  public boolean isFertile(Agent a)  {
    return false;
  }

  public boolean canBreed(Agent a, Agent b, LinkedList<Square> local) {
    return false;
  }


  public Agent breed(Agent a, Agent b, LinkedList<Square> aLocal, LinkedList<Square> bLocal)  {
  
    return a;
  }

}