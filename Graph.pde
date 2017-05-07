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
  public Graph(int x, int y, int howWide, int howTall, String xLab, String yLab) {
    this.x = x;
    this.y = y;
    this.howWide = howWide;
    this.howTall = howTall;
    this.xLab = xLab;
    this.yLab = yLab;
  }

  public void update(SugarGrid g){
   
    //white rectangle
    fill(255);
    rect(x, y, howWide, howTall);
    
    //borders for rectangle
    stroke(0);
    line(x, y + howTall, x + howWide, y + howTall);
    line(x, y + howTall, x, y);
    
//min(howWide, howTall)
    //labels for axis.
    fill(0);
    text(xLab, x + (howWide/2.5), (y + howTall) + howTall / 10);
    pushMatrix();
    translate(x,y);
    rotate(-PI/2.0);
    text(yLab, -howTall + 50, -10);
    popMatrix();
  }
}



abstract class LineGraph extends Graph {

  int updateCalls;

  public LineGraph(int x, int y, int howWide, int howTall, String xlab, String ylab) {
    super(x, y, howWide, howTall, xlab, ylab);
    this.updateCalls = 0;
  }  

  public abstract int nextPoint(SugarGrid g);

  public void update(SugarGrid g) {
    if (updateCalls == 0) {
      super.update(g);
    }

    stroke(0);
    point(x + updateCalls, y + howTall - nextPoint(g));
    updateCalls++;

    if (updateCalls > howWide) {
      updateCalls = 0;
    }
  }
}



//shows avg. sugar 
public class SugarGraph extends LineGraph {

  public SugarGraph (int x, int y, int howWide, int howTall, String xlab, String ylab) {
    super(x, y, howWide, howTall, xlab, ylab);
  }

  public int nextPoint(SugarGrid g) {
    int total = 0;
    ArrayList<Agent> a = g.getAgents();
    
    for (int i = 0; i < a.size(); i++) {
      total += a.get(i).getSugarLevel ();
    }
    
    if(a.size() > 0) {
      return (int)(total/a.size());
    }
    else {
      return 0;
    }
   
  }
}




//shows avg. age
public class AgeGraph extends LineGraph {
  public AgeGraph(int x, int y, int howWide, int howTall, String xlab, String ylab) {
    super(x,y,howWide,howTall,xlab,ylab);
  }
  public int nextPoint(SugarGrid g) {
    ArrayList<Agent> agents = g.getAgents();
    
    int totalAge = 0;
    
    for(int i = 0; i < agents.size(); i++) {
      totalAge = totalAge + agents.get(i).getAge();
    }      
    
    if(agents.size() > 0) {
      return (4 * totalAge)/agents.size();
    }
    else {
      return 0;
    }
    
  }
  
  public void update(SugarGrid g) {
    super.update(g);
  }
}



//shows percent in culture A.
public class CultureGraph extends LineGraph {
  public CultureGraph(int x, int y, int howWide, int howTall, String xlab, String ylab) {
    super(x,y,howWide,howTall,xlab,ylab);
  }
  
  public int nextPoint(SugarGrid g) {
    
    ArrayList<Agent> agents = g.getAgents();
    
    int percentTrue = 0;
        
    for (int i = 0; i < agents.size(); i++) {
      if (agents.get(i).getTribe() == true) {
        percentTrue = percentTrue + 1;
      }
    }
    
    
   if(agents.size() > 0) {
      return (int) (howTall * (percentTrue / (1.0 * agents.size())));
    }
    else{
      return 0;
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