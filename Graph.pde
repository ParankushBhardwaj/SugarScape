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