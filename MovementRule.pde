import java.util.*;


public interface MovementRule {
     public Square move(LinkedList<Square> neighbourhood, SugarGrid g, Square middle);
}

class SugarSeekingMovementRule implements MovementRule {

  public Square move(LinkedList<Square> neighbourhood, SugarGrid g, Square middle) {
    
    Collections.shuffle(neighbourhood); // squares are randomized.
    
    Square s = neighbourhood.getFirst();
    
    for (int i = 0; i < neighbourhood.size(); i++){      
      if (neighbourhood.get(i).getSugar() > s.getSugar()) {
          s = neighbourhood.get(i);
      }
      else if (neighbourhood.get(i).getSugar() == s.getSugar()) {
        //use euc distance to find distance between both squares from middle
        //whichever one is closer to the middle becomes the new s.
        if (g.euclidianDistance(s, middle) > g.euclidianDistance(neighbourhood.get(i), middle)) {
          s = neighbourhood.get(i);
        }
      }
    }
    return s;
  }
}




class PollutionMovementRule implements MovementRule {

  public Square move(LinkedList<Square> neighbourhood, SugarGrid g, Square middle) {
    
      Collections.shuffle(neighbourhood); // squares are randomized.
      
      //Square s = neighbourhood.getFirst();
            
      Square bestSquare = neighbourhood.getFirst();
      float bestRatio;
      
      Square currentSquare;
      float currentRatio;
      
      //init the ratio of best square
      
      if(bestSquare.getSugar() != 0){
        bestRatio = bestSquare.getPollution() / bestSquare.getSugar();
      }
      else {
        bestRatio = bestSquare.getPollution();
      }
      
            
      for (int i = 0; i < neighbourhood.size(); i++) { 
        
        //ratio = pollution: sugar. 
        currentSquare = neighbourhood.get(i);
        
        if(currentSquare.getSugar() != 0){
          currentRatio = currentSquare.getPollution() / currentSquare.getSugar();
        }
        else {
          currentRatio = currentSquare.getPollution();
        }
        
        //now that ratios are good, compare them.
        
        if (bestRatio == 0 && currentRatio == 0) {
          if (currentSquare.getSugar() > bestSquare.getSugar()) {
            bestSquare = currentSquare;
            bestRatio = currentRatio;
          }
          else if (currentSquare.getSugar() < bestSquare.getSugar()) {
            bestSquare = bestSquare;
          }
          else if (currentSquare.getSugar() == bestSquare.getSugar()) {
            if (g.euclidianDistance(currentSquare, middle) < g.euclidianDistance(bestSquare, middle)){
              bestSquare = currentSquare;
              bestRatio = currentRatio;
            }
            else {
              bestSquare = bestSquare;
            }
          }
        }
        else if (bestRatio == currentRatio && bestRatio != 0){
             if (g.euclidianDistance(currentSquare, middle) < g.euclidianDistance(bestSquare, middle)){
              bestSquare = currentSquare;
              bestRatio = currentRatio;
            }
            else {
              bestSquare = bestSquare;
            }
        }
        else if (bestRatio > currentRatio){ //if the current ratio has less pollution for ever sugar then the best square so far ...
            bestRatio = currentRatio;
            bestSquare = currentSquare;
        }
        
      }
      
      return bestSquare;
  }
}   