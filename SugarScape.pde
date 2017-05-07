import java.util.*;

SugarGrid myGrid;
LinkedList<Graph> toPlot;

//below booleans are used for display.
boolean culture = true;
boolean fertility = false;
boolean sex = false;

void setup() {

  size(1300, 800);

  //below methods set up the rules for agents to follow.
  //MovementRule movementRule = new PollutionMovementRule();
  MovementRule movementRule = new SugarSeekingMovementRule();
  //MovementRule movementRule = new CombatMovementRule(20);
  AgentFactory agentFactory = new AgentFactory(1,4,1,6,50,100, movementRule); 
  ReplacementRule replacementRule = new ReplacementRule(60, 80, agentFactory);
  GrowthRule growthrule = new GrowbackRule(1);

  //below variables are used to create the parameters for the fertility rule.
  
  
  HashMap<Character, Integer[]> childBearingOnset = new HashMap<Character, Integer[]>();
  childBearingOnset.put('X', new Integer[] {25, 25});
  childBearingOnset.put('Y', new Integer[] {25, 25});
  
  
  HashMap<Character, Integer[]> climactericOnset = new HashMap<Character, Integer[]>();
  climactericOnset.put('X', new Integer[] {50, 50});
  climactericOnset.put('Y', new Integer[] {50, 50});
  
  

  FertilityRule fertilityrule =  new FertilityRule(childBearingOnset, climactericOnset);


  myGrid = new SugarGrid(40, 40, 20, growthrule, fertilityrule, replacementRule);
  myGrid.addSugarBlob(15, 15, 5, 5);
  myGrid.addSugarBlob(30, 30, 5, 5);

  for (int i = 0; i < 100; i++) {
    Agent ag = new Agent(1, 1, 25, new SugarSeekingMovementRule());
    myGrid.addAgentAtRandom(ag);
  }


  toPlot = new LinkedList<Graph>();

  toPlot.add(new SugarGraph(  850, 50, 400,200,"Time", "Average Sugar"));
  toPlot.add(new AgeGraph(    850,300,400,200,"Time","Average Age"));
  toPlot.add(new CultureGraph(850,550,400,200,"Time","True Culture %"));

  frameRate(10);
  
  textSize(30);
  fill(0, 102, 153);
  text("SugarScape", 950, 25);
  
  textSize(12);
  fill(0);
  text("Type 'f' to see fertility, 'c' to see culture, or 's' to see sex.", 880, 45);

}

void draw() {

  myGrid.update();
  myGrid.display(culture, fertility, sex);
  
  for(int i = 0; i < toPlot.size(); i++) {
    toPlot.get(i).update(myGrid);
  }
  
  fill(255);
  
}


void keyPressed() {

  if (key == 'c') {
    culture = true;
    fertility = false;
    sex = false;

  }
  else if (key == 'f') {
    fertility = true;
    culture = false;
    sex = false;

  }
  else if (key == 's') {
    sex = true;
    culture = false;
    fertility = false;

  }
  else{
    sex = false;
    culture = true;
    fertility = false;
    text(" ", 850, 35);

  }
}