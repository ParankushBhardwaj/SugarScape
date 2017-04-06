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
  
  SocialNetworkNode[][] network;
  
  LinkedList<Square> connectedAgents;
  

  public SocialNetwork(SugarGrid g) {
      this.g = g;
      
      this.network = new SocialNetworkNode[g.getHeight()][g.getWidth()];
      
      for(int a = 0; a < g.getWidth(); a++) {
        for(int b = 0; b < g.getHeight(); b++) {
           network[a][b] = new SocialNetworkNode(g.getAgentAt(a, b));
        } 
      } 
      
      
      //for every square in the grid
      for(int l = 0; l < g.getWidth(); l++) {
        for(int w = 0; w < g.getHeight(); w++) {
          
            //set the agent in that square to x....
            x = a[l][w].getAgent();
             
            //create a node for that agent.
            SocialNetworkNode netX = network[l][w];
           
            //for every square in the grid
            for(int t = 0; t < g.getWidth(); t++) {
              for(int z = 0; z < g.getHeight(); z++) {
                
                //set the agent in that square to y...
                y = b[t][z].getAgent();
                  
                //create a node for this agent.
                SocialNetworkNode netY = network[t][z];

                //now we are parsing two agents all over the grid.
                  //check if they are connected.                
                if (isConnected(x, y)) {
                  //if they are, add the netY's node to netX's network. 
                  //netX.neighbors.add(netY);
                  netX.addNeighbors(netY);
                }  
              }
           }
        }
      }
  }
  
  
  
  public Square location(Agent x) {
    
    //get the agent's location
    for(int l = 0; l < g.getWidth(); l++) {
      for(int w = 0; w < g.getHeight(); w++) {
          if(s[l][w].getAgent() == x) {
              return s[l][w];
          }
      }
    }
    return null;
  } 
  
  
  public boolean isConnected(Agent x, Agent y) {
    
      //see if x is connected to y.
    
      xVision = x.getVision();
      
      Square locationOfAgentX = location(x);
      
      Square locationOfAgentY = location(y);
      
      
      //connected agents returns all agents in the vision of agent X
      
      connectedAgents = new LinkedList<Square>(g.generateVision(locationOfAgentX.getX(), locationOfAgentX.getY(), xVision));
      
      //this loop checks if agent y is in the list of agents
      for(int i = 0; i < connectedAgents.size(); i++) {
        if(connectedAgents.get(i).getAgent() == locationOfAgentY.getAgent()) {
            return true;
        }
      }
      return false;
  }
  
  
  //Returns true if agent x is adjacent to agent y in this SocialNetwork. 
  public boolean adjacent(SocialNetworkNode x, SocialNetworkNode y)  {
    
    if(x.getAgent() == null || y.getAgent() == null) {
      return false;
    }
   
    int xPosition = location(x.getAgent()).getX();
   
    int yPosition = location(x.getAgent()).getY();
    
    //list of agents
    LinkedList<Square>adjacentAgentsForX = new LinkedList<Square>(g.generateVision(xPosition, yPosition, 1));
    
    //loop through list of agents
     for (int i = 0; i < adjacentAgentsForX.size(); i++) {
           if(adjacentAgentsForX.get(i) == location(y.getAgent())) {
               return true;
           }
      }
     return false;
 }
 
 
 public LinkedList<SocialNetworkNode> seenBy(SocialNetworkNode x)  {
   
       int xPosition = location(x.getAgent()).getX();
   
       int yPosition = location(x.getAgent()).getY();
 
       LinkedList<Square>adjacentAgentsForX = new LinkedList<Square>(g.generateVision(xPosition, yPosition, 1));
       
       //go through the list of nodes within the network
         //find all the nodes that is adjaved to x 
           //return that.
 
       
 }
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  


}