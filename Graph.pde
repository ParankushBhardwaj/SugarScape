class Graph {

  int x;
  int y;
  int howWide;
  int howTall;
  String xLab;
  String yLab;
  
  SugarGrid g;
  
  //initializes a new graph to be drawn with its upper left corner at coordinates (x,y), 
  //with the specified width and height, and the specified axis labels.
  public Graph(int x, int y, int howWide, int howTall, String xLab, String yLab)  {
    this.x = x;
    this.y = y;
    this.howWide = howWide;
    this.howTall = howTall;
    this.xLab = xLab;
    this.yLab = yLab;
  }
  
  public void update(SugarGrid g) {
    
   this.g = g;
   
   //Draws a white rectangle at coordinates (x,y), with the specified height and width.
   rect(x, y, howWide, howTall);
   
   //draws a black line along the bottom of the rectangle for the x-axis
   line(x, howTall, howWide, howTall); 
   
   //a black line along the left side for the y-axis.
   line(x, y, x, howTall);
   
   //Uses the text() method to write xlab underneath the graph
   text(xLab,x, howTall);
   
   //ylab to the left of the graph. 
   pushMatrix();
   translate(x, y);
   rotate(-PI/2.0);
   text(yLab, 0, 0 );
   popMatrix();
   
  }  
  
}



abstract class LineGraph extends Graph {
  
  SugarGrid g;
  
  Graph graph;
  
  int counterForUpdateCalls = 0;
  
  int graphWidth; 
  
  
  // Passes argument to the super-class constructor, and sets the number of update calls to 0.
  public LineGraph(int x, int y, int howWide, int howTall, String xLab, String yLab) {
    
      super(x, y, howWide, howTall, xLab, yLab);
      
      graph = new Graph(x, y, howWide, howTall, xLab, yLab);
      counterForUpdateCalls = 0;
      
      graphWidth = y;
  }
  
  //An abstract method.
  public abstract int nextPoint(SugarGrid g);
  
  
  //Overrides the superclass update method.
  public void update(SugarGrid g) {
    
    //If the number of update class is 0, calls the superclass update method. 
    if (counterForUpdateCalls == 0) {
      graph.update(g);
    }
     //Otherwise, calls nextPoint(g) to get the y-coordinate of the next point in the line.
    else {
      int yCoord = nextPoint(g);
      
      //Draws a 1x1 square at the point that would be at (number of updates, nextpoint(g)) in the graph that is being plotted. 
      rect(counterForUpdateCalls, yCoord, counterForUpdateCalls + 1, yCoord + 1);
      
      //Increases the number of updates by 1
      counterForUpdateCalls = counterForUpdateCalls + 1;
      
      //if the number of updates exceeds the width of the graph, set the number of updates back to 0 
      if (counterForUpdateCalls > graphWidth) {
        counterForUpdateCalls = 0;
      }
    }
  }
  
  
}