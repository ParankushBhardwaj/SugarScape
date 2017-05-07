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
    strokeWeight(5);
    stroke(255);
    fill(255);
    rect(x, y, howWide, howTall);
    stroke(0);
    textSize(min(howWide, howTall) / 12);
    line(x, y + howTall, x + howWide, y + howTall);
    line(x, y + howTall, x, y);
    
    //sideways text.
    fill(0);
    text(xLab, x + (howWide/3), y + howTall + min(howWide,howTall) / 12);
    pushMatrix();
    translate(x,y);
    rotate(-PI/2.0);
    text(yLab, -howTall, -10);
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



//shows total agents.
public class PopulationGraph extends LineGraph {

  public PopulationGraph(int x, int y, int howWide, int howTall, String xlab, String ylab) {
    super(x, y, howWide, howTall, xlab, ylab);
  }

  public int nextPoint(SugarGrid g) {
    ArrayList<Agent> agents = g.getAgents();
    return (int)(agents.size() / 2);
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


//shows avg metabolism 
public class MetabolismGraph extends LineGraph {

  public MetabolismGraph(int x, int y, int howWide, int howTall, String xlab, String ylab) {
    super(x, y, howWide, howTall, xlab, ylab);
  }

  public int nextPoint(SugarGrid g) {
    int avg = 0;
    int total = 0;
    
    ArrayList<Agent> a = g.getAgents();
    
    for (int i = 0; i < a.size(); i++) {
      Agent current = a.get(i);
      total += (current.getMetabolism() * 5);
    }
    
    if (a.size() < 2) {
      return total;
    } else {
      avg = total / a.size();
      return avg;
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
    
    if(agents.size() > 1) {
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