import java.util.*;


public interface MovementRule {
  
  public Square move(LinkedList<Square> neighbourhood, SugarGrid g, Square middle);
  }

class SugarSeekingMovementRule implements MovementRule {
  
  Square s;

  public Square move(LinkedList<Square> neighbourhood, SugarGrid g, Square middle) {

    // squares are randomized so you can pick a random place.
    Collections.shuffle(neighbourhood); 
    s = neighbourhood.get(0);


    for(int i = 0; i < neighbourhood.size(); i++) {
      if(neighbourhood.get(i).getSugar() > s.getSugar()) {
          s = neighbourhood.get(i);
      }
      else if (neighbourhood.get(i).getSugar() == s.getSugar()){
        if (g.euclidianDistance(middle, neighbourhood.get(i)) < g.euclidianDistance(middle, s)) {
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

    if (bestSquare.getSugar() != 0) {
      bestRatio = bestSquare.getPollution() / bestSquare.getSugar();
    } else {
      bestRatio = bestSquare.getPollution();
    }


    for (int i = 0; i < neighbourhood.size(); i++) { 

      //ratio = pollution: sugar. 
      currentSquare = neighbourhood.get(i);

      if (currentSquare.getSugar() != 0) {
        currentRatio = currentSquare.getPollution() / currentSquare.getSugar();
      } else {
        currentRatio = currentSquare.getPollution();
      }

      //now that ratios are good, compare them.

      if (bestRatio == 0 && currentRatio == 0) {
        if (currentSquare.getSugar() > bestSquare.getSugar()) {
          bestSquare = currentSquare;
          bestRatio = currentRatio;
        } else if (currentSquare.getSugar() < bestSquare.getSugar()) {
          //bestSquare = bestSquare;
        } else if (currentSquare.getSugar() == bestSquare.getSugar()) {
          if (g.euclidianDistance(currentSquare, middle) < g.euclidianDistance(bestSquare, middle)) {
            bestSquare = currentSquare;
            bestRatio = currentRatio;
          } else {
            //bestSquare = bestSquare;
          }
        }
      } else if (bestRatio == currentRatio && bestRatio != 0) {
        if (g.euclidianDistance(currentSquare, middle) < g.euclidianDistance(bestSquare, middle)) {
          bestSquare = currentSquare;
          bestRatio = currentRatio;
        } else {
          //bestSquare = bestSquare;
        }
      } else if (bestRatio > currentRatio) { //if the current ratio has less pollution for ever sugar then the best square so far ...
        bestRatio = currentRatio;
        bestSquare = currentSquare;
      }
    }

    return bestSquare;
  }
}   



class CombatMovementRule extends SugarSeekingMovementRule {

  int alpha;

  //ArrayList<LinkedList<Square>> listOfVisions = new ArrayList<LinkedList<Square>>();
  LinkedList<Square> newNeighbors = new LinkedList<Square>();


  Square target;

  Agent casualty;

  public CombatMovementRule(int alpha) {

    this.alpha = alpha;
  }

  public Square move(LinkedList<Square> neighbourhood, SugarGrid g, Square middle) {


    //this list will be updated by the method below.
    LinkedList<Square> updatedList = neighbourhood;

    //remove any square from neighborhood that contains a agent of the same tribe as the middle square.
    for (int i = 0; i < neighbourhood.size(); i++) {  
      if (neighbourhood.get(i).getAgent() == null) {
        //do nothing.
      } else if (neighbourhood.get(i).getAgent().getTribe() == middle.getAgent().getTribe()) {
        //neighbourhood.remove(i);
        updatedList.remove(i);
      } else {
        //also remove any agent square that has a agent with more sugar
        //if (neighbourhood.get(i).getAgent() != null) {
        if (neighbourhood.get(i).getAgent().getSugarLevel() >= middle.getAgent().getSugarLevel()) {
          //neighbourhood.remove(i);
          updatedList.remove(i);
        }
      }
    }
    

    neighbourhood = updatedList;

    //use updatedList for removal again. 
    updatedList = neighbourhood;
    
    //now for the remaining squares, get the vision agent middle would have for each one.
    for (int a = 0; a < neighbourhood.size(); a++) { 
      LinkedList<Square> visions = g.generateVision(neighbourhood.get(a).getX(), neighbourhood.get(a).getY(), middle.getAgent().getVision());

      for (int b = 0; b < visions.size(); b++) {
        if (visions.get(b).getAgent() == null) {
          //do nothing, just a quick null check 
         } 
         
         // If the vision contains any Agent with more sugar than the Agent on middle,...
         else if (visions.get(b).getAgent().getSugarLevel() > middle.getAgent().getSugarLevel()) {

          //...and the opposite tribe, 
          if (visions.get(b).getAgent().getTribe() != middle.getAgent().getTribe()) {

            //then move that entire square rom the neighbourhood.
            updatedList.remove(a);
            break;
          }
        }
      }
    }

    neighbourhood = updatedList;



    //Replace each Square in neighbourhood that still has an Agent with a new Square that has the same x and y coordinates,
    //but a Sugar and MaximumSugar level that are increased by the minimum of alpha and the sugar level of the occupying agent.
    for (int c = 0; c < neighbourhood.size(); c++) {

      if (neighbourhood.get(c).getAgent() != null) {

        int newSugar = neighbourhood.get(c).getSugar() + alpha;

        int newMaxSugar = neighbourhood.get(c).getMaxSugar() + neighbourhood.get(c).getAgent().getSugarLevel();

        newNeighbors.add(new Square(neighbourhood.get(c).getX(), neighbourhood.get(c).getY(), newSugar, newMaxSugar));
      }
    }    
    


    //call super classes movement method, should return best square.
    //move(LinkedList<Square> neighbourhood, SugarGrid g, Square middle)
    Square newTarget = super.move(newNeighbors, g, middle);


    //now find the square from neighbourhood that has same x and y values as newTarget.
    for (int d = 0; d < neighbourhood.size(); d++) {

      if (newTarget == null) {
        //do nothing
      }
      //if the square has the same x and y coords
      else if (neighbourhood.get(d).getX() == newTarget.getX() && neighbourhood.get(d).getY() == newTarget.getY()) {
        target = neighbourhood.get(d);
      }
    }

    if (target != null && target.getAgent() != null) {      
      casualty = target.getAgent();

      //remove caualty from square
      target.setAgent(null);

      //increase wealth of middle's agent by causalty's sugar level and alpha
      middle.getAgent().initialSugar = (casualty.getSugarLevel() + alpha);

      g.killAgent(casualty);

      return target;
    }

    return null;
  }
}