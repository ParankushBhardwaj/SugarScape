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

abstract class CDFGraph extends Graph {
  int callsPerValue;
  int numUpdates;
  int numberOfCallsPerValue;
  
  /* Passes various values to the superclass constructor, and stores callsPerValue for its own use. 
  `  Also sets an internal counter (numUpdates) to zero, and an internal variable storing the number of calls per value.
  */
  public CDFGraph(int x, int y, int howWide, int howTall, String xlab, String ylab, int callsPerValue) {
      super(x, y, howWide, howTall, xlab, ylab);
      this.callsPerValue = callsPerValue;
      
      //Also sets an internal counter (numUpdates) to zero
      numUpdates = 0;
      
      // an internal variable storing the number of calls per value.
      numberOfCallsPerValue = callsPerValue;
  }
  
  
  public abstract void reset(SugarGrid g);
  
  
  public abstract int nextPoint(SugarGrid g);
  
  
  public abstract int getTotalCalls(SugarGrid g); 
  
  
  public void update(SugarGrid g) {
    //Sets a field numUpdates to 0. 
    int numUpdates = 0;
    
    //Call the update method of the superclass.
    super.update(g);
    
    //Call the reset method of the subclass, which resets any internal state.
    reset(g);
    
    //Compute the number of objects to average for each cell in the graph. 
    //should be equal to the with of the graph divided by whatever is returned by getTotalCalls() in the subclass.
    int numPerCell = super.howWide / getTotalCalls(g);
    
    
    //While numUpdates is less than getTotalCalls() in the subclass, 
    while(numUpdates < getTotalCalls(g)) {
      //Draw a rectangle numPerCell wide, 1 pixel tall, starting at (numUpdates, nextPoint()).
      rect(numUpdates, nextPoint(g), numPerCell, nextPoint(g)+1);
      
      //Increase numUpdates by 1.
      numUpdates++;
    }
  }
  
}
  
 
 class  WealthCDF extends CDFGraph {
   
    ArrayList<Agent> agents = new ArrayList<Agent>();
    
    int sugarSoFar = 0;
    
    int totalSugar = 0;
    
    public WealthCDF(int x, int y, int howWide, int howTall, String xlab, String ylab, int callsPerValue) {
      super(x, y, howWide, howTall, xlab, ylab, callsPerValue);
    }
    
    public void reset(SugarGrid g) {
      
      //Stores in a field of this class an ArrayList<Agent> sorted by sugar levels
      agents = g.getAgents();
      
      //You may use any sort from Question 3 or 4 above.
      QuickSorter quickSort = new QuickSorter();
      quickSort.sort(agents);
      
      // Stores in another field of this class the total sugar owned by all agents.
      totalSugar = 0;
      for (int i = 0; i < agents.size(); i ++){
        totalSugar += agents.get(i).getSugarLevel();
      }
      
      //Also sets a counter sugarSoFar to 0.
      sugarSoFar = 0;
 
    }
  
  
   public int nextPoint(SugarGrid g)  {
     
       //used to compute sugar average level
       int totalSugar = 0;
     
       //Uses the numUpdates stored in the superclass to compute the number of Agents that have been graphed so far
       int graphedSoFar = numUpdates;
       
       //Gets the next callsPerValue agents out of the list that was created by reset() above.
       ArrayList<Agent> nextAgents = new ArrayList<Agent>();
       
       for(int i = callsPerValue; i < agents.size(); i++) {
         nextAgents.add(agents.get(i));    
       }
       
       //Computes the average sugar level of those agents, and adds it to sugarSoFar.
       for(int i = 0; i < nextAgents.size(); i++) {
           totalSugar += nextAgents.get(i).getSugarLevel();
       }
       
       //compute average/
       int averageSugarLevel = totalSugar/nextAgents.size();
       
       //add Sugar level 
       sugarSoFar += averageSugarLevel;
       
       //Returns the fraction sugarSoFar/totalSugar
       int returnValue = sugarSoFar/totalSugar;
       
       //If fewer than callsPerValue agents remain that have not yet been graphed, 
       //graph the average of all remaining agents instead.
       
       return returnValue;
   }

   public int getTotalCalls(SugarGrid g) {
     //returns the total number of agents in g, divided by callsPerValue.
     return g.getAgents().size() / callsPerValue;
   }
 }
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  