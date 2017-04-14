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
  
  
 
  public SocialNetwork(SugarGrid g) {
    
    
      if(g.getWidth() == 0 && g.getHeight() == 0) {
        g = null;
      }
      
      if(grid != null) {
        
        this.grid = g;
      
        this.w = g.getWidth();
      
        this.h = g.getHeight();
      
        this.agents = new ArrayList<Agent>(grid.getAgents());
      
        for(int i = 0; i < agents.size(); i++) {
           SocialNetworkNode node = new SocialNetworkNode(agents.get(i));
           nodes.add(node);
        }
      
        network = new boolean[nodes.size()][nodes.size()];
      
      
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
    
    connected = new ArrayList<Agent>();
    
    int iVision = i.getAgent().getVision();
    
    for(int x = 0; x < w; x++) {
      for(int y = 0; y < h; y++) {
        if(grid.getAgentAt(x, y) == i.getAgent()) {
          for(int a = 1; a < iVision; a++) {
            connected.add(grid.getAgentAt(x + a, y));
            connected.add(grid.getAgentAt(x, y + a));
            connected.add(grid.getAgentAt(x - a, y));
            connected.add(grid.getAgentAt(x, y - a));
          }
          
          if(connected.contains(j.getAgent())) {
            return true;
          }
        }
      }
    }
    
    return false;
  }
  
  
 
 public List<SocialNetworkNode> seenBy(SocialNetworkNode x) {
   
   List<SocialNetworkNode> seenBy = new ArrayList<SocialNetworkNode>();
   
   
   for(int i = 0; i < nodes.size(); i++) {
     
     if(adjacent(nodes.get(i), x)) {
       seenBy.add(nodes.get(i));
     }
    
   }
   
   return seenBy;
 } 
 
 
 
 public List<SocialNetworkNode> sees(SocialNetworkNode y) {
   
   List<SocialNetworkNode> sees = new ArrayList<SocialNetworkNode>();
   
   for(int i = 0; i < nodes.size(); i++) {
     
     if(adjacent(y, nodes.get(i))) {
       sees.add(nodes.get(i));
     }
    
   }
   return sees;
 } 
 
 
 
 public void resetPaint() {
   for(int i = 0; i < nodes.size(); i++) {
     nodes.get(i).unpaint();
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
      if(nodes.get(v).getAgent() == a) {
         return nodes.get(v);
       }
    }
    
    return null;
 }
 
 
 public boolean pathExists(Agent x, Agent y)  {
   //get nodes.
   SocialNetworkNode xNode = getNode(x);
   SocialNetworkNode yNode = getNode(y);
   
   if(xNode == null || yNode == null) {
     return false;
   }
   
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
   
   ArrayList<Agent> listOfAgents = new ArrayList<Agent>();


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
  
  
  
}