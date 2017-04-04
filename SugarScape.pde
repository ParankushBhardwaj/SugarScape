import java.util.*;

SugarGrid myGrid;

Square[][] s;

GrowthRule sg = new SeasonalGrowbackRule(0, 0, 0, 0, 0);

Graph g = new Graph(5, 5, 500, 500, "x-axis", "y-axis");



//ArrayList<Agent> agents = new ArrayList<Agent>();

Agent a = new Agent(1, 1, 1, new PollutionMovementRule());
Agent b = new Agent(1, 1, 2, new PollutionMovementRule());
Agent c = new Agent(1, 1, 3, new PollutionMovementRule());
Agent d = new Agent(1, 1, 4, new PollutionMovementRule());
Agent e = new Agent(1, 1, 5, new PollutionMovementRule());
Agent f = new Agent(1, 1, 6, new PollutionMovementRule());
Agent gq = new Agent(1, 1, 7, new PollutionMovementRule());



BubbleSorter bubble;




void setup(){

  size(1000,800);
  
        /*Tester for algorithms.
          
        QuickSorter sorter = new QuickSorter();

        ArrayList<Agent> input = new ArrayList<Agent>();
  
        Agent a1 = new Agent(1, 1, 7, new PollutionMovementRule());
        Agent b = new Agent(1, 1, 4, new PollutionMovementRule());
        Agent c = new Agent(1, 1, 9, new PollutionMovementRule());
        Agent d = new Agent(1, 1, 4, new PollutionMovementRule());
        Agent e = new Agent(1, 1, 2, new PollutionMovementRule());
        Agent f = new Agent(1, 1, 2, new PollutionMovementRule());
        Agent gq = new Agent(1, 1, 1, new PollutionMovementRule());
              
         input.add(a1);
         input.add(b);
         input.add(c);
         input.add(d);
         input.add(e);
         input.add(f);
         input.add(gq);
                
        sorter.sort(input);
        
        for(Agent i:input){
            System.out.print(i.getSugarLevel());
            System.out.print(", ");
        }
  
        */
  myGrid = new SugarGrid(100,100,20, sg);
  
    
  //myGrid.addSugarBlob(15,15,2,5);
  //myGrid.addSugarBlob(10,10,1,10);
  //myGrid.addSugarBlob(30,20,1,15);
  myGrid.addSugarBlob(25,15,1,10);
  //myGrid.addSugarBlob(20,20,1,10);
  
  Agent ag = new Agent(1, 1, 1, new PollutionMovementRule());

  /*
  for (int i = 0; i < 1; i++){
     Agent ag = new Agent(1, 1, 4, new PollutionMovementRule());
     myGrid.addAgentAtRandom(ag);
  }
  */
    
  myGrid.placeAgent(ag,25,15);
  
  //myGrid.addAgentAtRandom(ag);
  myGrid.display();
  frameRate(100);

}

void draw(){
  myGrid.update();
  background(255);
  myGrid.display();
}