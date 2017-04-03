abstract class Sorter {
  
  //sorts al so that the Agents are ordered from least Sugar (index 0) to most Sugar (last element of the list).
  public abstract void sort(ArrayList<Agent> al);
  
  //Returns true if and only if Agent a has less sugar than Agent b.
  public boolean lessThan(Agent a, Agent b) {
    
    if(a.getSugarLevel() < b.getSugarLevel()) {
      return true;
    }
    else {
      return false;
    }
  }
}

/*
check important edge cases like an empty list, a list with only 1 element, 
a backwards list, and lists with both even and odd numbers of elements. 
*/


class BubbleSorter extends Sorter {

  //until there are no more swaps taking place
    //walk through entire list
      //compare a[i] and a[i+1]
      //if a[i]>a[i+1], swap them.
  
 
  public void sort(ArrayList<Agent> al) {
    
    boolean swapped = true;
    int counterForSwap = 0;
    //placeholder for swap
    Agent agentPlaceHolder;
    
    //until there are no more swaps taking place
    while(swapped){
      //walk through the entire list
      for (int i = 0; i < al.size(); i++) {
        
        //only compare a[i] and a[i+1] if both are not null
        if (al.get(i) != null && al.get(i+1) != null) {
        
          //if a[i]>a[i+1], swap them.
          if (al.get(i).getSugarLevel() > al.get(i+1).getSugarLevel()) {
            
              //placeholder for swap
              agentPlaceHolder = al.get(i);
              
              //remove i-th one, now i+1 is already in i-th position
              al.remove(i);
              
              //add i-th one to i+1
              al.add(i+1, agentPlaceHolder);
              
              //counter checks if swaps took place.
              counterForSwap++;
            }
        }
      }
      //check if swaps took place
      if (counterForSwap > 0){
        swapped = true;
        counterForSwap = 0;
      }
      else {
        swapped = false;
      }
    }
  }
}


class InsertionSorter {
  
}

class MergeSorter {
    
    ArrayList<Agent> firstHalf;
    ArrayList<Agent> secondHalf;
   
    public void sort(ArrayList<Agent> al) {
        //split into 2 lists.
        
        int divider = 2;
        
        for (int i = 0; i < al.size(); i++) {
          if(i < al.size()/divider) {
            firstHalf.add(i, al.get(i));
          }
          else {
            secondHalf.add(i, al.get(i));
          }
        }
      
        //divide, check sort/do sort.
    }
}

class QuickSorter {
  
  public void sort(ArrayList<Agent> al) {
     int randomNumber = (int)(Math.random() * al.size() + 0);

     for (int i = 0; i < al.size(); i ++) {
       if (i < randomNumber) {
         ArrayList<Agent> smallerAgents = new ArrayList<Agent>();
         smallerAgents.add(al.get(i));
       }
       else if (i == randomNumber) {
         ArrayList<Agent> sameAgents = new ArrayList<Agent>();
         sameAgents.add(al.get(i));
       }
       else if (i > randomNumber) {
         ArrayList<Agent> largerAgents = new ArrayList<Agent>();
         largerAgents.add(al.get(i));
       }
     }
  }
  
  
}