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

class BubbleSorter extends Sorter {
  
  public void sort(ArrayList<Agent> al) {
  
  //counter used to check if more sorts have to be done.
  int hasBeenSorted = 0;
  
  //allows counter to be 0 for first run.
  boolean firstTimeRunning = true;
  
  int counter = 0;
  
  //keep looping through the list if it either just got sorted or is the first time running.
 // while(hasBeenSorted != 0 || firstTimeRunning) {
  while(counter < al.size()) {
    //no longer first time running.
    firstTimeRunning = false;
    
    //reset the times sorted to 0 for incoming try
    hasBeenSorted = 0;
    
    //increment through the list.
    for(int i = 0; i < al.size() - 1; i++) {
         Agent first = al.get(i);
         Agent second = al.get(i+1);
         
         
         //if the first element is less than the second one..
         if (lessThan(second, first) == false) {
           //good! 
         }
         
         if(first.getSugarLevel() > second.getSugarLevel()) {
           //swap the first and second ones.
           //Collections.swap(al, i, i+1);
           Agent placeholder = al.get(i);
           al.set(i, second);
           al.set(i+1, placeholder);


           //increment sorter counter.
           hasBeenSorted++;
         }
      }
      counter++;

    }
  }
  
}


class InsertionSorter extends Sorter {
      
  public void sort(ArrayList<Agent> list) {
  
  //counter used to check if more sorts have to be done.
  int hasBeenSorted = 0;
  
  //allows counter to be 0 for first run.
  boolean firstTimeRunning = true;
  
  int counter = 0;
  
  //keep looping through the list if it either just got sorted or is the first time running.
  while(counter < list.size()) {
  
    //no longer first time running.
    firstTimeRunning = false;
    
    //reset the times sorted to 0 for incoming try
    hasBeenSorted = 0;
    
    //increment through the list.
    for(int i = 0; i < list.size() - 1; i++) {
         Agent first = list.get(i);
         Agent second = list.get(i+1);
         
        
         //if the first element is less than the second one..
         if (lessThan(first, second) == true) {
           //good! 
         }
         //else if the first one is larger than the second one...
         else if (lessThan(first, second) == false) {
           
           //variables used for better code readability.
           int a = i;  
           int b = i+1;
           
           //swap the first and second ones.
           Collections.swap(list, a, b);
           
           //now check if b can be swapped with others.
           //e is the index before a, keeps decrementing until it hits 0.
           for(int e = i-1; e >= 0; e--) {
             if (lessThan(list.get(e), list.get(b)) == true) {
               //good! exit for-loop so that we don't waste money decrementing all the way to 0.
               break;
             }
             else if (lessThan(list.get(e), list.get(b)) == false) {
               //swap. Continue for-loop.
               Collections.swap(list, e, b);
             }
           }
           
           //increment sorter counter.
           hasBeenSorted++;
         }
      }
      counter++;
    }
  }
   
   
}



class MergeSorter extends Sorter {
   
    ArrayList<Agent> list;
  
    int sizeOfList; 
  
    //first, recursively split the arays.
    public void sort(ArrayList<Agent> al) {
        this.list = al;
        this.sizeOfList = al.size();
        
        //check if list is long enough for split
        if(sizeOfList < 2) {
          return;
        }
        
        //create first half of the list.
        ArrayList<Agent> firstHalf = new ArrayList<Agent>();
        
        for(int i = 0; i < sizeOfList/2; i++) {
           firstHalf.add(al.get(i));
        }
        
        //create secondhalf of the list.
        ArrayList<Agent> secondHalf = new ArrayList<Agent>();
        
        for(int i = sizeOfList/2; i < sizeOfList; i++) {
           secondHalf.add(al.get(i));
        }
        
        //recursively keep splitting the list to new lists.
        sort(firstHalf);
        sort(secondHalf);
        
        //after each element is in its own list, merge them in ascending order
        merge(firstHalf, secondHalf, al);
    }
    
    private void merge(ArrayList<Agent> firstHalf, ArrayList<Agent> secondHalf, ArrayList<Agent> sortedList) {
        
      //create counters and size of each half of the list.
      int sizeOfFirst = firstHalf.size();
      int counterForFirst = 0;

      int sizeOfSecond = secondHalf.size();
      int counterForSecond = 0;
      
      //create list and coutner for final list
      int counter = 0;
      
      while(counterForFirst < sizeOfFirst && counterForSecond < sizeOfSecond) {
        if (lessThan(firstHalf.get(counterForFirst), secondHalf.get(counterForSecond)) == true) {
            sortedList.set(counter, firstHalf.get(counterForFirst));
            counterForFirst++;
            counter++;
        }
        else if (lessThan(firstHalf.get(counterForFirst), secondHalf.get(counterForSecond)) == false) {
            sortedList.set(counter, secondHalf.get(counterForSecond));
            counterForSecond++;
            counter++;
        }
      }
      
      while(counterForFirst< sizeOfFirst){
        sortedList.set(counter, firstHalf.get(counterForFirst));
        counterForFirst++;
        counter++;
      }
      
      while(counterForSecond< sizeOfSecond){
        sortedList.set(counter, secondHalf.get(counterForSecond));
        counterForSecond++;
        counter++;
      }
    
    }
  
}


class QuickSorter extends Sorter {
    
   public void sort(ArrayList<Agent> al) {
        
      //create 2 lists, B.P and A.P. (before pivot and after pivot).
      ArrayList<Agent> beforePivot = null;
      ArrayList<Agent> afterPivot = null;
      
      Agent pivot;
      
      //store the size of both lists
      int sizeOfBeforePivot = 0;
      int sizeOfAfterPivot = 0;
      
      //print statements for checking.
      /*
      System.out.println();
      System.out.print("Input = ");
      
      for (int i = 0; i < al.size(); i++) {
        System.out.print(al.get(i).getSugarLevel() + " ");
      }
      */
      
      //check to see if list is long enough to be sorted
      if (al.size() <= 1) {
       //System.out.println("Done.");
       return;
      }
     
     //make pivot the rightmost element.
     pivot = al.get(al.size() - 1);
     
     //System.out.println();
     //System.out.print("Pivot = " + pivot.getSugarLevel());
      
     
     //find size of before and after pivot lists
     for (int i = 0; i < al.size()-1; i++) { 
         if (al.get(i).getSugarLevel() <= pivot.getSugarLevel()) {
           sizeOfBeforePivot++;
         }
         else {
            sizeOfAfterPivot++;
         }
     }
     
     
     beforePivot = new ArrayList<Agent>(sizeOfBeforePivot);
     //initialize size of the arraylists
     for (int i = 0; i < sizeOfBeforePivot; i++) {
        beforePivot.add(al.get(i));
     }
     
     afterPivot = new ArrayList<Agent>(sizeOfAfterPivot);
     //initialize size of the arraylists
     for (int i = 0; i < sizeOfAfterPivot; i++) {
        afterPivot.add(al.get(i));
     }
     
     
     //split al list
     int beforeCounter = 0;
     int afterCounter = 0;
     
     
     for (int q = 0; q < al.size() - 1; q++) {
         
         if(al.get(q).getSugarLevel() <= pivot.getSugarLevel()) {
             beforePivot.set(beforeCounter, al.get(q));
             beforeCounter++;
         }
         else {
             afterPivot.set(afterCounter, al.get(q));
             afterCounter++;
         }
         
     }
     
     /* print statements for checking
     System.out.println();   
     System.out.print("left side: ");
     for (int i = 0; i < sizeOfBeforePivot; i++) {
        System.out.print(beforePivot.get(i).getSugarLevel() + " ");
      }
     
     System.out.println();
     System.out.print("right side: ");
     for (int i = 0; i < sizeOfAfterPivot; i++) {
        System.out.print(afterPivot.get(i).getSugarLevel() + " ");
      }
     
     */
     
     
     //recursively sort each one
     sort(beforePivot);
     sort(afterPivot);
     
     
     /*print statements for checking
     System.out.println();   
     System.out.print("Sorted left side: ");
     for (int i = 0; i < sizeOfBeforePivot; i++) {
        System.out.print(beforePivot.get(i).getSugarLevel() + " ");
      }
     
     System.out.println();
     System.out.print("Sorted right side: ");
     for (int i = 0; i < sizeOfAfterPivot; i++) {
        System.out.print(afterPivot.get(i).getSugarLevel() + " ");
      }
      */
      
      
     
     //now merge them back!
     int counter = 0;
     
     //add left list to al's left side
     for(int i = 0; i < beforePivot.size(); i++) {
        al.set(counter, beforePivot.get(i));
        counter++;
     }
     
     //add pivot to al
     al.set(counter, pivot);
     counter++;
     
     //add right side
     for(int y = 0; y < afterPivot.size(); y++) {
        al.set(counter, afterPivot.get(y));
        counter++;
     }
     
   }
   
  
}