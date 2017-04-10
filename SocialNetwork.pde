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
  
  LinkedList<SocialNetworkNode> neighbors = new LinkedList<SocialNetworkNode>();


  LinkedList<Agent> allAgents = new LinkedList<Agent>();

 
  public SocialNetwork(SugarGrid g) {
      this.g = g;
      
      this.network = new SocialNetworkNode[g.getHeight()][g.getWidth()];
      
      for(int a = 0; a < g.getWidth(); a++) {
        for(int b = 0; b < g.getHeight(); b++) {
           network[a][b] = new SocialNetworkNode(g.getAgentAt(a, b));
           allAgents.add(network[a][b].getAgent());
        } 
      } 
      
      //for every square in the grid
      for(int l = 0; l < g.getWidth(); l++) {
        for(int w = 0; w < g.getHeight(); w++) {
          
            //x is the agent in that square
            x = a[l][w].getAgent();
             
            //create a node for that agent. (end of loop, every agent will have a node).
            SocialNetworkNode netX = network[l][w];
           
            //for every square in the grid
            for(int t = 0; t < g.getWidth(); t++) {
              for(int z = 0; z < g.getHeight(); z++) {
                
                //y is the agent in that square
                y = b[t][z].getAgent();
                  
                //create a node for this agent too. 
                SocialNetworkNode netY = network[t][z];

                //4 for-loops let us compare two agents all over the grid.
                  
                //check if the agents are connected.
                if (isConnected(x, y)) {
                  //if they are, add the netY's node to netX's network. 
                  //netX.addNeighbors(netY);
                  neighbors.add(netY);
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
    
    //if the node's agents are null, return false.
    if(x.getAgent() == null || y.getAgent() == null) {
      return false;
    }
   
    //x and y are x and y position of the square that agent x is in. 
    int xPosition = location(x.getAgent()).getX();
   
    int yPosition = location(x.getAgent()).getY();
    
    //this list holds all the squares that have agents and are adjacent to (touching) agent x. 
    LinkedList<Square> adjacentAgentsForX = new LinkedList<Square>(g.generateVision(xPosition, yPosition, 1));
    
    //loop through the squares, and see if any of those squares hold agent Y. If one does, return true.
     for (int i = 0; i < adjacentAgentsForX.size(); i++) {
           if(adjacentAgentsForX.get(i) == location(y.getAgent())) {
               return true;
           }
      }
     return false;
 }
 
 
 //Returns a list containing all the nodes that x is adjacent to. Returns null if x is not in the social network.
 public ArrayList<SocialNetworkNode> seenBy(SocialNetworkNode x)  {
   
    //below nested-for loop checks if node y exists within network.
    
    boolean notInNetwork = true;
    //goes through every node in the network...
    for(int a = 0; a < g.getWidth(); a++) {
        for(int b = 0; b < g.getHeight(); b++) {
           if(x == network[a][b]) {
             notInNetwork = false;
           }
        }
     }
    
    //if the node is not in the network, return null.
    if(notInNetwork) {
      return null;
    }
      
    ArrayList<SocialNetworkNode> adjacentNodesForX = new ArrayList<SocialNetworkNode>();

   //go through the entire grid ... 
     //find x's agent.
       //see agent x's connections
         //for every one of x's adjacent connections, add its social network to the list.
   
      for(int l = 0; l < g.getWidth(); l++) {
        for(int w = 0; w < g.getHeight(); w++) {
             if (isConnected(x.getAgent(), network[l][w].getAgent())== true) {
               adjacentNodesForX.add(network[l][w]);
             }
        }
      }
      
      return adjacentNodesForX; 
       
  }
  
  //Returns a list containing all the nodes that are adjacent to y. Returns null if y is not in the social network.
  public List<SocialNetworkNode> sees(SocialNetworkNode y) {
  
    //below nested-for loop checks if node y exists within network.
    
    boolean notInNetwork = true;
    //goes through every node in the network...
    for(int a = 0; a < g.getWidth(); a++) {
        for(int b = 0; b < g.getHeight(); b++) {
           if(y == network[a][b]) {
             notInNetwork = false;
           }
        }
     }
    
    //if the node is not in the network, return null.
    if(notInNetwork) {
      return null;
    }
    
    ArrayList<SocialNetworkNode> adjacentNodesForY = new ArrayList<SocialNetworkNode>();
  
    //go through the entire grid ... 
     //find x's agent.
       //see agent x's connections
         //for every one of x's adjacent connections, add its social network to the list.
   
      for(int l = 0; l < g.getWidth(); l++) {
        for(int w = 0; w < g.getHeight(); w++) {
             if (isConnected(y.getAgent(), network[l][w].getAgent())== true) {
               adjacentNodesForY.add(network[l][w]);
             }
        }
      }
     
     return adjacentNodesForY; 
    
  }
  
  
  //Sets every node in the network to unpainted.
  public void resetPaint() {
    
    //goes through every node in the network and unpaints it.
    for(int a = 0; a < g.getWidth(); a++) {
        for(int b = 0; b < g.getHeight(); b++) {
           network[a][b].unpaint();
        } 
      } 
  
  }
  
  
  //Returns the node containing the passed agent. Returns null if that agent is not represented in this graph.
  public SocialNetworkNode getNode(Agent a) {
    
    //goes through every node in the network...
    for(int x = 0; x < g.getWidth(); x++) {
        for(int y = 0; y < g.getHeight(); y++) {
           //checks if the agent in that node contains the passed agent
           if (network[x][y].getAgent() == a) {
               //if so, returns the node.
               return network[x][y];
           }
        } 
      }
      return null;
  }
  
  
  public boolean pathExists(Agent x, Agent y)  {
    
    //check if the agents are the same
    if (x == y) {
      return true;
    }
    
    //check if x and y are adjacent, if so, then path exists!
    if(adjacent(getNode(x), getNode(y))) {
      return true;
    }
    
    //check if y is painted (reached end) (just in case)
    if(getNode(y).painted) {
      return true;
    }
    
    //paint current node.
    getNode(x).paint();
    
        
    /*
    //make sure all paths are currently unpainted
    for(int a = 0; a < g.getWidth(); a++) {
        for(int b = 0; b < g.getHeight(); b++) {
           network[a][b].unpaint();
        } 
      }
    */
     
     
    //recursively check pathway for all nodes in network
    
    //go through each node, for each one connected to X, call pathExists on it. 
    
    for(int a = 0; a < g.getWidth(); a++) {
        for(int b = 0; b < g.getHeight(); b++) {
           if(adjacent(getNode(x), network[a][b])) {
             if(network[a][b].painted == false) {
               pathExists(network[a][b].getAgent(), y);
           }
         }  
        } 
      } 
      
    return false;
 
  }
  
 public LinkedList<Agent> bacon(Agent x, Agent y) {
  
    for(int a = 0; a < g.getWidth(); a++) {
        for(int b = 0; b < g.getHeight(); b++) {
           network[a][b].unpaint();
        } 
      }
      
    //queue 
    //LinkedList<SocialNetworkNode> queue = new LinkedList<SocialNetworkNode>();
    
    LinkedList<Agent> queue = new LinkedList<Agent>();
    
        
    //used for queue
    SocialNetworkNode n = getNode(x);
    
    //paint current node.
    getNode(x).paint();
  
    Iterator<Agent> listOfAgents;
    
    
    while(queue.size() != 0) {
      
      x = queue.poll();
      
      //Iterator<SocialNetworkNode> i = networkAsList.listIterator();
      
      Iterator<Agent> i = allAgents.listIterator();

      
      while(i.hasNext()) {
        
        if(getNode(y).painted()) {
          return queue;
        }
        
        Agent next = i.next();
        
        if(getNode(next).painted() == false) {
          getNode(next).paint();
          queue.add(next);
        }
      }
      
    }
    return null;
  }
  
}