import java.util.*;

public interface GrowthRule {
  public void growBack(Square s);
}



//this class updates the sugar level based on the alpha rate.
class GrowbackRule implements GrowthRule {

  private int rate;

  //Initializes a new GrowbackRule with the specified growth rate.
  public GrowbackRule(int rate) {
    this.rate = rate;
  }

  // Increases the sugar in Square s by the growth rate, up to the maximum value that can be stored in s.
  public void growBack(Square s) {
    s.setSugar(s.getSugar() + rate);
  }
  
}



//this class makes it so that the grid has differnet growth rules in different areas.
//this resembles how earth has different seasons in different sides, affecting world productivity.
class SeasonalGrowbackRule implements GrowthRule {

  int alpha;
  int beta;
  int gamma;
  int equator;
  int numSquares;

 
  boolean isNorth = true;



  int counterForTrackingTheSeason = 0;


  public SeasonalGrowbackRule(int alpha, int beta, int gamma, int equator, int numSquares) {
    this.alpha = alpha;
    this.beta = beta;
    this.gamma = gamma;
    this.equator = equator;
    this.numSquares = numSquares;
  }


  public void growBack(Square s) {

    //now we change sugar levels depending on the square's y-location and the season.
    if (s.getY() <= equator && isNorth == true) {
      s.setSugar(s.getSugar() + alpha);
    } else if (s.getY() > equator && isNorth == false) {
      s.setSugar(s.getSugar() + alpha);
    } else if (s.getY() <= equator && isNorth == false) {
      s.setSugar(s.getSugar() + beta);
    } else if (s.getY() > equator && isNorth == true) {
      s.setSugar(s.getSugar() + beta);
    }

    //below we first determine if the season has changed, it changes after grow back is called a certain # of times
    counterForTrackingTheSeason = counterForTrackingTheSeason + 1; //this counter is used to determine when we need to change the season

    //when you need to change seasons, just look at the array of seasons and set the season equal to the next element in the array.
    if (counterForTrackingTheSeason >= (gamma*numSquares)) {   

      if (isNorth == true) {
        isNorth = false;
      } else if (isNorth == false) {
        isNorth = true;
      }  

      //reset the counter to 0 so it start all over.
      counterForTrackingTheSeason = 0;
    }
  }


  public boolean isNorthSummer() {
    if (isNorth == true) {
      return true;
    } else {
      return false;
    }
  }
  
}