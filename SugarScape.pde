import java.util.*;

SugarGrid myGrid;
Square[][] s;


GrowthRule sg = new SeasonalGrowbackRule(1, 1, 1, 1, 1);

PollutionMovementRule pr = new PollutionMovementRule();

AgentFactory af = new AgentFactory(1, 10, 1, 1, 20, 50, pr);

SocialNetwork sn = new SocialNetwork(myGrid);

Demo d = new Demo();

ArrayList<Agent> agents = new ArrayList<Agent>();

void setup(){

  size(1000,800);
  
  myGrid = new SugarGrid(100, 100, 20, new GrowbackRule(0));
  sn = new SocialNetwork(myGrid);
  
  
  myGrid.addSugarBlob(10, 20, 3, 20);
  myGrid.addSugarBlob(40, 50, 3, 20); 
  myGrid.addSugarBlob(30, 90, 3, 20);

  for(int i = 0; i < 7; i++) {
    agents.add(af.makeAgent());
    myGrid.addAgentAtRandom(agents.get(i));
  }
  
  sn = new SocialNetwork(myGrid);

  
  
}

void draw(){
  
  frameRate(1);
  background(255);
  d.viz();

  myGrid.update();
  
  print(myGrid.getAgents().size());

  for(int i = 0; i < agents.size(); i++) {
    for(int j = 0; j < agents.size(); j++) {
        //print(sn.listOfAgents.size());
       if(sn.adjacent(sn.getNode(agents.get(i)), sn.getNode(agents.get(j)))) {
       
         println("is connected!");
         
       }
    }
  }
  
  
}