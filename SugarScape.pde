import java.util.*;

SugarGrid myGrid;

Square[][] s;

GrowthRule sg = new SeasonalGrowbackRule(0, 0, 0, 0, 0);

Graph g = new Graph(5, 5, 500, 500, "x-axis", "y-axis");


void setup(){

  size(1000,800);
  
  myGrid = new SugarGrid(100,100,20, sg);
  
    
  //myGrid.addSugarBlob(15,15,2,5);
  //myGrid.addSugarBlob(10,10,1,10);
  //myGrid.addSugarBlob(30,20,1,15);
  myGrid.addSugarBlob(25,15,1,10);
  //myGrid.addSugarBlob(20,20,1,10);
  
  Agent ag = new Agent(1, 1, 4, new PollutionMovementRule());

  /*
  for (int i = 0; i < 1; i++){
     Agent ag = new Agent(1, 1, 4, new PollutionMovementRule());
     myGrid.addAgentAtRandom(ag);
  }
  */
  
  g.update(myGrid);

    
  myGrid.placeAgent(ag,25,15);
  
  //myGrid.addAgentAtRandom(ag);
  myGrid.display();
  frameRate(100);

}

void draw(){
  myGrid.update();
  background(255);
  g.update(myGrid);
  myGrid.display();
}