import java.util.*;

class SocialNetwork {

  
  SugarGrid g;
      
  Square[][] s;
  
  Square[][] a;
  
  Square[][] b;
  
  Square location;

  Agent x;
  Agent y;
  
  int xVision;
  int yVision;
  
  SugarGrid grid;
  
  ArrayList<SocialNetworkNode> nodes;
    
  LinkedList<Square> connectedAgents;
  
  boolean[][] network;

  ArrayList<Agent> agents;


  ArrayList<Agent> connected;
  
  ArrayList<Agent> adjacent;

  int h; 
  
  int w;
  
  ArrayList<Agent> listOfAgents = new ArrayList<Agent>();

 
  public SocialNetwork(SugarGrid g) {
       
      this.grid = g;
            
      if(grid != null) {
              
        this.w = grid.getWidth();
      
        this.h = grid.getHeight();
      
        this.agents = grid.getAgents();
        
        this.nodes = new ArrayList<SocialNetworkNode>();
      
        for(int i = 0; i < agents.size(); i++) {
           SocialNetworkNode node = new SocialNetworkNode(agents.get(i));
           nodes.add(node);
           network = new boolean[nodes.size()][nodes.size()];
        }
      
          //network = new boolean[nodes.size()][nodes.size()];
      
        for(int i = 0; i < nodes.size(); i++) {
          for(int j = 0; j < nodes.size(); j++) {
              if(adjacent(nodes.get(i), nodes.get(j))) {
                network[i][j] = true;
              }
              else {
                network[i][j] = false;
              }  
          }
        }   
      }
  }


  
  public boolean adjacent(SocialNetworkNode i, SocialNetworkNode j) {
    
    
    if(i == null || j == null) {
      return false;
    }
    
    //get agent at x
    Agent agentX = i.getAgent();
        
    for(int x = 0; x < w; x++) {
      for(int y = 0; y < h; y++) {
        
        //if the agent in the grid is not empty and is equal to the first node...
        //get the agent in node i.
        if(grid.getAgentAt(x, y) != null && grid.getAgentAt(x, y).equals(agentX)) {
          
          
          //create a linked list of squares
          //find the squares that surround agent x (in node i).
          LinkedList<Square> visionForX = grid.generateVision(x, y, agentX.getVision());
          
          //go through the squres in the vision, check if any contain the square in node j.
          for(int a = 0; a < visionForX.size(); a++) {
            
            Agent agentAtSquare = visionForX.get(a).getAgent();
          
            if(agentAtSquare != null && agentAtSquare.equals(j.getAgent())) {
              return true;
            } 
          }
        }
      }
    }
    return false;
  }
  
  
  
  
  
 
 public List<SocialNetworkNode> seenBy(SocialNetworkNode x) {
   
   List<SocialNetworkNode> seenBy = new ArrayList<SocialNetworkNode>();

   if(x == null || x.getAgent() == null) {
       return null;
   }
   
   
   for(int i = 0; i < nodes.size(); i++) {
     if(nodes.get(i).getAgent() != null) {
       if(adjacent(x, nodes.get(i))) {
         seenBy.add(nodes.get(i));
       }
     }
   }
   
   return seenBy;
 } 
 
 
 
 public List<SocialNetworkNode> sees(SocialNetworkNode y) {
   
   List<SocialNetworkNode> sees = new ArrayList<SocialNetworkNode>();
   
   if(y == null || nodes != null || nodes.size() == 0) {
     return null;
   }
   
   for(int i = 0; i < nodes.size(); i++) {
     if(adjacent(y, nodes.get(i))) {
       sees.add(nodes.get(i));
     }
   }
   return sees;
 } 
 
 
 
 public void resetPaint() {
   
   if(nodes != null) {
     for(int i = 0; i < nodes.size(); i++) {
       nodes.get(i).unpaint();
     }
   }
 }
 
 
 
 //Returns the node containing the passed agent. Returns null 
 //if that agent is not represented in this graph.
 public SocialNetworkNode getNode(Agent a) {
   
   //check if agent exists
   if(a == null) {
     return null;
   }
   
   //check if current nodes exist
   if(nodes == null) {
     return null;
   }
   
    for(int v = 0; v < nodes.size(); v++) {
      if(nodes.get(v).getAgent() != null) {
        if(nodes.get(v).getAgent() == a) {
           return nodes.get(v);
         }
      }
    }
    
    return null;
 }
 
 
 public boolean pathExists(Agent x, Agent y)  {
   
   if(x == null || y == null) {
     return false;
   }
   
   if(getNode(x) == null || getNode(y) == null) {
     return false;
   }
   
   
   //get nodes.
   SocialNetworkNode xNode = getNode(x);
   SocialNetworkNode yNode = getNode(y);
   
   
   //list of nodes x can see.
   ArrayList<SocialNetworkNode> xSee = new ArrayList<SocialNetworkNode>(sees(xNode));
   
   
   for(int i = 0; i < xSee.size(); i++) {
     if(xSee.get(i).painted == false) {
       if(adjacent(xSee.get(i), yNode)) {
         return true;
       }
       else {
         pathExists(xSee.get(i).getAgent(), y);
       }
     }
     
   }
   return false;
   
 }
 
 
 public ArrayList<Agent> bacon(Agent x, Agent y) {
   
   ArrayList<SocialNetworkNode> shortestPath = new ArrayList<SocialNetworkNode>();
   
   listOfAgents = new ArrayList<Agent>();

   //check if x = y, or if one of those two are null.
   if(x == null || y == null) {
     return null;
   }
   
   
   if(x == y) {
     listOfAgents.add(x);
     listOfAgents.add(y);
     return listOfAgents;
   }
   
         
   //Add origin to a queue and paint it
   shortestPath.add(getNode(x));
   getNode(x).paint();
    
    do {
       SocialNetworkNode front = shortestPath.get(0); 

       //Add all its unpainted neighbours
       ArrayList<SocialNetworkNode> frontNeighbors = new ArrayList<SocialNetworkNode>(sees(front));
       
       //Remove front node from queue
       shortestPath.remove(0);
       
       for(int a = 0; a < frontNeighbors.size(); a++) {
         if(frontNeighbors.get(a).painted == false) {
           shortestPath.add(frontNeighbors.get(a));
           //paint all of its neigbors
           frontNeighbors.get(a).paint();
           
           //if the neighbor you added in the queue IS agent y, then return the queue!
           if(frontNeighbors.get(a).getAgent() == y) {
      
             //convert shortestPath from list of nodes to a list of agents
             listOfAgents = new ArrayList<Agent>();
             
             for(int i = 0; i < shortestPath.size(); i++) {
               listOfAgents.add(shortestPath.get(i).getAgent());
             }
             return listOfAgents;
           }
  
           
         }
       }
    }
    while(!shortestPath.isEmpty());
   
   //if path from x to y do not exist.
   return null;
  }
  
  
  
  public void display() {
    
    int xCenter = 250;
    int yCenter = 300;
    
    //draw the main circle.
    ellipseMode(CENTER);
    ellipse(xCenter, yCenter, 500, 500);
    
   
    //coords for agents
    int xPos = 100;
    int yPos = 100;
    
    //add agents around the circle.
    for(int i = 0; i < listOfAgents.size(); i++){
      fill(0);
      rect(xCenter, 50, xCenter + 1, 1);
    }
    
    
  }

}