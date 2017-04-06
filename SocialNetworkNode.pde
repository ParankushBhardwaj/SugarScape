class SocialNetworkNode {
  
  Agent a;
  
  Boolean painted = false; 
  LinkedList<SocialNetworkNode> neighbors = new LinkedList<SocialNetworkNode>();
  
  //initializes a new SocialNetworkNode storing the passed agent. The node is unpainted initially.
  public SocialNetworkNode(Agent a){
    
    this.a = a;
    painted = false;
    
  }
  
  //returns true if this node has been painted.
  public boolean painted() {
    return painted;
  }
  
  
  //Sets the node to painted.
  public void paint() {
    painted = true;
  }
  
  
  // Sets the node to unpainted.
  public void unpaint(){
    painted = false;
  }
  
  
  
  
  
  //Returns the agent stored at this node.
  public Agent getAgent() {
    return a;
  }
  
  
  public void addNeighbors(SocialNetworkNode node){
    
      neighbors.add(node);
      
      
  }
  
  
  
  
}