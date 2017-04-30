class Demo {


  void viz() {

    int x = 500;

    int y = 400;

    int radius = 200;

    AgentFactory af = new AgentFactory(1, 10, 1, 1, 20, 50, new SugarSeekingMovementRule());

    ArrayList<Agent> agents = new ArrayList<Agent>();

    int totalCircles = 8;

    for (int i = 0; i < totalCircles; i++) {
      agents.add(af.makeAgent());
    }



    int xOffset = 141;
    int yOffset = 141;

    noFill();
    ellipse(x, y, 400, 400);


    for (int a = 0; a < agents.size(); a++) {
      if (a == 0) {
        agents.get(a).display(x, y - radius, 30);
      } else if (a == 1) {
        agents.get(a).display((x - xOffset) + (radius * (sq(2/4))), (y - (radius * sq(2/4))) + yOffset, 30);
      } else if (a == 2) {
        agents.get(a).display(x + radius, y, 30);
      } else if (a == 3) {
        agents.get(a).display((x  - xOffset)+ radius*(sq(2/4)), y + radius*(sq(2/4)) - yOffset, 30);
        //line((x  - xOffset)+ radius*(sq(2/4)), y + radius*(sq(2/4)) - yOffset, x, y + radius);
      } else if (a == 4) {
        agents.get(a).display(x, y + radius, 30);
      } else if (a == 5) {
        agents.get(a).display(x - (radius * (sq(2/4))) + xOffset, (y + (radius * sq(2/4))) - yOffset, 30);
      } else if (a == 6) {
        agents.get(a).display(x - radius, y, 30);
      } else if (a == 7) {
        agents.get(a).display(x - radius*(sq(2/4)) + xOffset, y - radius*(sq(2/4)) + yOffset, 30);
        //line(x - radius*(sq(2/4)) + xOffset, y - radius*(sq(2/4)) + yOffset, x, y + radius);
      }
    }
  }
}