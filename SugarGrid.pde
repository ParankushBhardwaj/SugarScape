import java.util.LinkedList;
import java.util.*;
class SugarGrid {

  int w;
  int h;
  int sideLength;  
  
  int xPos;
  int yPos;
  int radius;
  int max;
  
  Agent a;
  Square[][] s;
  GrowthRule g;
  
  Square center;
  Square current;
  
  FertilityRule fr;
  ReplacementRule replace;
  
  //int max;
  
  public SugarGrid(int w, int h, int sideLength, GrowthRule g){
    
    //store new values to class.
    this.w = w;
    this.h = h;
    this.sideLength = sideLength;
    this.g = g;
      
    //below, we create the grid of squares.
    s = new Square[w][h];

    for (int x = 0; x < w; x++) {
      for (int y = 0; y < h; y++) {
          s[x][y] = new Square(0,0,x,y);
      }
    }
   
  
  }

  
  public int getWidth() {
    return w;
  }
  
  public int getHeight() {
    return h;
  }
  
  public int getSquareSize() {
    return sideLength;
  }
  
  public int getSugarAt(int i, int j) { 
    return s[i][j].getSugar();
  }
  
  public int getMaxSugarAt(int i, int j) {
    return s[i][j].getMaxSugar();
  } 
  
  public void addSugarBlob(int xPos, int yPos, int radius, int max) {
    this.xPos = xPos;
    this.yPos = yPos;
    this.radius = radius;
    this.max = max;

    this.center = s[xPos][yPos];
    
    //if the distance from the center square to surrounding squares == radius, then set their sugar levels to max-1; 
    for (int i = 0; i < w; i++) {
      for (int j = 0; j < h; j++) {
        
        this.current = s[i][j]; 
        double distance = euclidianDistance(center, current);
        //double distance = euclidianDistance(current, center);
        
          if (distance <= radius) { //if the distance from the square to the center is less than or equal to radius
               
               if (distance == 0) {
                 if(current.getMaxSugar() < max) {
                   current.setMaxSugar(max);
                   current.setSugar(max);
                 }
                 else {
                   current.setSugar(center.getMaxSugar());
                 }
               }
               else { //else if not in the center
                 if (current.getMaxSugar() < max-1) {
                     current.setMaxSugar(max-1);
                     current.setSugar(max-1);
                 }
                 else{
                     current.setSugar(center.getMaxSugar());
                 }
               }
          }
          else {
            for(int n = 2; n <= max; n++){
              if (distance <= n*radius && distance > radius*(n-1)) {
                if(current.getMaxSugar() < max-n) {
                   current.setMaxSugar(max-n);
                   current.setSugar(max-n);
                 }
                 else {
                  current.setSugar(current.getMaxSugar());
                 }
              }        
            }
         }
      }
    }
  }
  
  public double euclidianDistance(Square a, Square b){
    
    float distanceX = min(abs(a.getX() - b.getX()), w - (abs(a.getX() - b.getX())));
    
    float distanceY = min(abs(a.getY() - b.getY()), h - (abs(a.getY() - b.getY())));
    
    return Math.sqrt(Math.pow(distanceX, 2) + Math.pow(distanceY, 2));
    
  }
  
  public Agent getAgentAt(int i, int j) {
    return s[i][j].getAgent();
  }
  
  public void placeAgent(Agent a, int xPos, int yPos){
     s[xPos][yPos].setAgent(a);
  }
 
 
  //returns a list of all agents on the SugarGrid at present.
  public ArrayList<Agent> getAgents() {
     
     ArrayList<Agent> allAgents = new ArrayList<Agent>();
     
     //go through each grid
     for (int i = 0; i < w; i++) {
          for (int j = 0; j < h; j++) {
            //add agent to list if there is one
            if(s[i][j].getAgent() != null){
              allAgents.add(s[i][j].getAgent());
            }
          }
      }
      //return list of agents
      return allAgents;
  }
 
 
 // Random rand = new Random(); //used for random location
  
   public void addAgentAtRandom(Agent a) {
     
       //create a list of squares
       LinkedList<Square> gridOfEmptyAgents = new LinkedList<Square>();
       
        for (int i = 0; i < w; i++) {
          for (int j = 0; j < h; j++) {
            if(s[i][j].getAgent() == null){
              gridOfEmptyAgents.add(s[i][j]);
            }
          }
        }

       Collections.shuffle(gridOfEmptyAgents);
       
       float randomNum = random(0, gridOfEmptyAgents.size() - 1);
       
       gridOfEmptyAgents.get((int)randomNum).setAgent(a);
       
   }
  
  public LinkedList<Square> generateVision(int row, int col, int radius) {
    //create a list of squares, length of list determined by radius.
    LinkedList<Square> vision = new LinkedList<Square>();
    
    int offsetX;
    int offsetY;
        
    //if your radius is 0, your vision is (row, col).
    if (radius == 0){
      vision.add(s[row][col]);
      return vision;
    }
    
    
    for (int i = 1; i <= radius; i++){  
        
        //check if vision is legal
        if (row < 0 || col < 0 || row >= w || col >= h || radius < 0) {
            assert(1==0);
        }
        else {
      
            vision.add(s[row][col]); //add current location for vision.
            
            //first check rightwards, including if it goes off the grid.
            if (row + i >= w){  
              offsetX = (row + i) - w;
              vision.add(s[offsetX][col]);  //adds x value if x was greater than length of grid
            }
            else {
              offsetX = row + i;
              vision.add(s[offsetX][col]); //adds x 
            }
      
           //then check leftwards, including if it goess under 0
      
           if (row - i < 0){  
              //first do x-axis
              offsetX = w - abs(row - i);
              vision.add(s[offsetX][col]); //adds x value if x was less than length of grid
            }    
            else {
              offsetX = row - i;
              vision.add(s[offsetX][col]); //adds x 
            }
      
            
            //now check column, including if going down goes off the grid. (then go to top of grid).

            if (col + i >= h) {  
                offsetY = (col + i) - h;
                vision.add(s[row][offsetY]);  //if vision's y value is greater than actual height, look at bottom values.
            } 
            else {
                offsetY = col + i;
                vision.add(s[row][offsetY]);
            }
      
            //now check column going off the grid by moving up (so then it contineus at the bottom of the grid).
      
            if (col - i < 0) {  
                offsetY = h - abs(col - i);
                vision.add(s[row][offsetY]); //if y value is lower than grid, look at the top of the grid.
            }
            else {
                offsetY = col - i;
                //next do y-axis
                vision.add(s[row][offsetY]); 
            }  

       }
    }
   
    return vision;
  }
  
  
  public void killAgent(Agent a) {
    a.deleteSugar();
  }

  
  public void update() { //Updates the grid by one step
    
    //LinkedList<Agent> processedAgents = new LinkedList<Agent>();
    for (int i = 0; i < w; i++) {
      for (int j = 0; j < h; j++) {
        
          //first do growbackrule
          g.growBack(s[i][j]);
          
          //now we generate vision        
          a = s[i][j].getAgent();
          
          if (a != null) {
              //Apply the agent's movement rule to determine where the agent wants to move.
              
              Square bess = a.getMovementRule().move(generateVision(i, j, a.getVision()), this, s[i][j]); //returns perferrable square
              a.move(s[i][j], bess);
      
              placeAgent(a, bess.getX(), bess.getY());
                            
              
              //The agent consumes stored sugar based on its metabolic rate
              a.step();
              
              //If the agent is now dead, mark its current square as unoccupied.
              if (a.isAlive() == false) {
                s[i][j].setAgent(null);
              }
              else {
                a.eat(s[i][j]);
              }
          }
        }
    }
  }

  void display() {
    for (int i = 0; i < w; i++) {
      for (int j = 0; j < h; j++) {
          s[i][j].display(sideLength);
      }
    }
  }
  
} 