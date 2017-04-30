import java.util.*;

SugarGrid myGrid;

void setup() {

  size(1300, 800);
  myGrid = new SugarGrid(40, 40, 20, new GrowbackRule(10));
  myGrid.addSugarBlob(15, 15, 5, 5);
  myGrid.addSugarBlob(30, 30, 5, 5);

  for (int i = 0; i < 100; i++) {
    Agent ag = new Agent(1, 1, 50, new CombatMovementRule(10));
    myGrid.addAgentAtRandom(ag);
  }

  myGrid.display();

  LinkedList<Graph> toPlot = new LinkedList<Graph>();

  toPlot.add(new MetaGraph(850, 0, 400, 200, "Time", "# of Agents"));
  toPlot.add(new AvgSugGraph(850, 250, 400, 200, "Time", "Avg. Sugar"));
  toPlot.add(new WealthCDF(850, 250, 400, 200, "Time", "Wealth", 256));

  frameRate(200);
}

void draw() {

  myGrid.update();

  fill(255);

  myGrid.display();
}