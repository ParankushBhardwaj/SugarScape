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

  public void update(SugarGrid g) {

    this.g = g;

    //Draws a white rectangle at coordinates (x,y), with the specified height and width.
    rect(x, y, howWide, howTall);

    stroke(150);
    fill(150);
    rect(this.x, this.y - this.howTall, this.howWide, this.howTall); 
    stroke(0);
    line(this.x, this.y, this.x + this.howWide, this.y);
    line(this.x, this.y, this.x, this.y - this.howTall);
    fill(0);
    text(xLab, this.x, this.y + 15);


    //rotating window to display rotated text
    pushMatrix();
    translate(this.x, this.y);
    rotate(-PI/2.0);
    text(yLab, 0, -5);
    popMatrix();
  }
  
}



abstract class LineGraph extends Graph {

  int updateCalls;
  int[][] b = new int[this.howWide][this.howTall];

  public LineGraph(int x, int y, int howWide, int howTall, String xlab, String ylab) {
    super(x, y, howWide, howTall, xlab, ylab);
    this.updateCalls = 0;
  }  

  public abstract int nextPoint(SugarGrid g);

  public void update(SugarGrid g) {
    if (this.updateCalls == 0) {
      super.update(g);
      updateCalls++;
    } else {
      super.update(g);
      int yco;
      if (nextPoint(g) < this.howTall) {
        yco = nextPoint(g);
      } else yco = this.howTall - 1;
      int xco = this.updateCalls;
      b[xco][yco] = 1;
      int xOff = this.x + xco;
      int yOff = this.y - yco;
      for (int i = 0; i < this.howWide; i++) {
        for (int j = 0; j < this.howTall; j++) {
          if (b[i][j] == 1) {
            fill(75, 0, 170);
            stroke(75, 0, 170);
            rect(i + this.x, this.y - (j-1), 1, 1);
            //rect(xOff, yOff, 1, 1);
          }
        }
      }
      this.updateCalls++;
      if (this.updateCalls >= this.howWide-1) {
        this.updateCalls = 0;
        super.update(g);
        for (int i=0; i < this.howWide; i++) {
          for (int j=0; j < this.howTall; j++) {
            b[i][j] = 0;
          }
        }
      }
    }
  }
}



public class TotalGraph extends LineGraph {

  public TotalGraph(int x, int y, int howWide, int howTall, String xlab, String ylab) {
    super(x, y, howWide, howTall, xlab, ylab);
  }

  public int nextPoint(SugarGrid g) {
    ArrayList<Agent> a = g.getAgents();
    return a.size() / (this.howTall / 20);
  }
  
}


public class AvgSugGraph extends LineGraph {

  public AvgSugGraph(int x, int y, int howWide, int howTall, String xlab, String ylab) {
    super(x, y, howWide, howTall, xlab, ylab);
  }

  public int nextPoint(SugarGrid g) {
    int avg, total = 0;
    ArrayList<Agent> a = g.getAgents();
    for (int i = 0; i < a.size(); i++) {
      Agent current = a.get(i);
      total += current.getSugarLevel ();
    }
    if (a.size() < 2) {
      return total;
    } else {
      avg = total / a.size();
      return avg;
    }
  }
}



public class MetaGraph extends LineGraph {

  public MetaGraph(int x, int y, int howWide, int howTall, String xlab, String ylab) {
    super(x, y, howWide, howTall, xlab, ylab);
  }

  public int nextPoint(SugarGrid g) {
    int avg, total = 0;
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





abstract class totalAgentsGraph extends LineGraph {

  SugarGrid g;

  Graph graph;

  int counterForUpdateCalls = 0;

  int graphWidth; 


  // Passes argument to the super-class constructor, and sets the number of update calls to 0.
  public totalAgentsGraph(int x, int y, int howWide, int howTall, String xLab, String yLab) {

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



abstract public class CDFGraph extends Graph {
  int callsPerValue, numUpdates, numPerCell;

  public CDFGraph(int x, int y, int howWide, int howTall, String xlab, String ylab, int callsPerValue) {
    super(x, y, howWide, howTall, xlab, ylab);
    this.callsPerValue = callsPerValue;
    this.numUpdates = 0;
  }

  public abstract void reset(SugarGrid g);

  public abstract int nextPoint(SugarGrid g);

  public abstract int getTotalCalls(SugarGrid g);

  public void update(SugarGrid g) {
    this.numUpdates = 0;
    super.update(g);
    this.reset(g);
    //this will throw an exception when all agents are dead because getTotalCalls will return zero. this is kind of intended though because this way the program
    //ends when all agents die
    //this.numPerCell = g.getWidth() / this.getTotalCalls(g);
    while (this.numUpdates < this.getTotalCalls(g)) {
      fill(75, 0, 170);
      stroke(75, 0, 170);
      rect(this.numUpdates + this.x + 4, this.nextPoint(g) + (this.y - 5), 1, 1);
      this.numUpdates++;
    }
  }
}

public class WealthCDF extends CDFGraph {
  int totalSugar, sugarSoFar;
  ArrayList<Agent> sugarList = new ArrayList<Agent>();

  public WealthCDF(int x, int y, int howWide, int howTall, String xlab, String ylab, int callsPerValue) {
    super(x, y, howWide, howTall, xlab, ylab, callsPerValue);
  }



  public void reset(SugarGrid g) {
    ArrayList<Agent> temp = g.getAgents();
    //see which sort is most efficient
    this.sugarList.clear();
    this.sugarList.addAll(temp);
    for (Agent current : sugarList) {
      this.totalSugar += current.getSugarLevel();
    }
    this.sugarSoFar = 0;
  }

  public int nextPoint(SugarGrid g) {
    int sugarCounter = 0, avg = 0;
    for (int i = this.numUpdates; i < this.numUpdates + callsPerValue; i++) {
      sugarCounter += sugarList.get(i).getSugarLevel();
    }
    avg = sugarCounter / this.callsPerValue;
    this.sugarSoFar += avg;
    if (sugarList.size() - this.numUpdates > this.callsPerValue) {
      avg = avg / (sugarList.size() - this.numUpdates);
    } else avg = avg / this.callsPerValue;
    this.sugarSoFar += avg;
    int result = this.sugarSoFar / this.totalSugar;
    return result / 10;
  }

  public int getTotalCalls(SugarGrid g) {
    return g.getAgents().size() / this.callsPerValue;
  }
  
  
}