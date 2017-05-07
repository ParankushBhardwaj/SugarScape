class PollutionRule {

  int gatheringPollution;
  int eatingPollution;
  
  public PollutionRule(int gatheringPollution, int eatingPollution) {
      this.gatheringPollution = gatheringPollution;
      this.eatingPollution = eatingPollution;
  }


  public void pollute(Square s) {

      if (s.getAgent() == null) {
        return;
      }
      else {      
         //pollution level of s is increased by eatingPollution points for every point of metabolism agent a has
         s.setPollution((s.getPollution() + (s.getAgent().getMetabolism() * eatingPollution)) + (s.getSugar() * gatheringPollution));        
      }
  }
}