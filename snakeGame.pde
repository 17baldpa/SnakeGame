// adapted from Daniel Shiffman
// https://youtu.be/AaGK-fj-BAM

Snake s;
int scl = 20;
String status = "";
PVector food;
boolean gotFood;
boolean alive;
int finalScore;
int frame = 14;


void setup() {
  size(600, 600);
  s = new Snake();
  alive = true;
  frameRate(frame);
  setFoodLocation();
}

void draw() {
  background(51);

  // Changes the direction of the Snake
  if (alive) {

    if (keyPressed) {
      if (keyCode == UP && ((s.xspeed != 0 && s.yspeed != 1) || s.total == 0)) {
        s.dir(0, -1);
      }
      if (keyCode == RIGHT && (( s.xspeed != -1 && s.yspeed != 0) || s.total == 0)) {
        s.dir(1, 0);
      }
      if (keyCode == LEFT && (( s.xspeed != 1 && s.yspeed != 0) || s.total == 0)) {
        s.dir(-1, 0);
      }
      if (keyCode == DOWN &&  (( s.xspeed != 0 && s.yspeed != -1) || s.total == 0)) {
        s.dir(0, 1);
      }
    }


    s.checkForPulse();
    s.update();
    s.show();

    gotFood = s.eat(food);

    // Replaces the food that was eaten with a new piece of food

    if (gotFood) {
      setFoodLocation();
    }

    fill(255, 0, 100);
    rect(food.x, food.y, scl, scl);

    status = "length: " + s.total;

    // Displays the length of the snake

    text("Score:  " + s.total, 520, 50);
  } else {
    textSize(20);
    text("You Died!", 230, 280);
    text("Score:  " + finalScore, 230, 300);
    text("Press X to restart", 230, 320);

    if (keyPressed == true && key == 'x') {
      alive = true;  
      s = new Snake();
    }
  }

  // TODO: Extensions...
  //       1. add a cheat. if mousePressed is true,
  //          increase "s.total" (without the quotes) by one.
  //       2. check if the snake is dead. If it is,
  //          tell the user that the game is over!
  //       3. after you do #2, give the user an option to
  //          restart the game (keyPress?)
  //       4. change any other parameters in the game (speed, size, colors, etc)
  //            - first tinker on your own
  //            - then ask a colleague if you need help or ideas
  //       Then replace this comment with one of your own.
}


void setFoodLocation() {
  int cols = width/scl;
  int rows = height/scl;
  food = new PVector(floor(random(cols)), floor(random(rows)));
  food.mult(scl);
}


class Snake {
  float x = 0;
  float y = (int)random(0, 30) * 20;
  float xspeed = 1;
  float yspeed = 0;
  int total = 0;
  ArrayList<PVector> tail = new ArrayList<PVector>();

  Snake() {
  }

  boolean eat(PVector pos) {
    float d = dist(x, y, pos.x, pos.y);
    if (d < 1) {
      total++;
      return true;
    } else {
      return false;
    }
  }

  void dir(float x, float y) {
    xspeed = x;
    yspeed = y;
  }

  void checkForPulse() {
    for (int i = 0; i < tail.size(); i++) {
      PVector pos = tail.get(i);
      float d = dist(x, y, pos.x, pos.y);
      if (d < 1) {
        finalScore = total;
        total = 0;
        alive = false;
        tail.clear();
      }
    }
  }

  void update() {
    if (total > 0) {
      if (total == tail.size() && !tail.isEmpty()) {
        tail.remove(0);
      }
      tail.add(new PVector(x, y));
    }

    x = x + xspeed*scl;
    y = y + yspeed*scl;
    // If you hold the space key when the snake is going towards the edge it goes through and comes out the opposite side, but the speed goes up by 2
    if (keyPressed == true && key == ' ') {
      if ( x > width-scl) {
        x = 0;
        frame = frame + 2;
        frameRate(frame);
      }
      if (x < 0) {
        x = 600;
        frame = frame + 2;
        frameRate(frame);
      }
      if ( y > height-scl) {
        y = 0;
        frame = frame + 2;
        frameRate(frame);
      }
      if ( y < 0) {
        y = 600; 
        frame = frame + 2;
        frameRate(frame);
      }
    } else { 
      x = constrain(x, 0, width-scl);
      y = constrain(y, 0, height-scl);
    }
  }

  void show() {
    fill(255);
    for (PVector v : tail) {
      rect(v.x, v.y, scl, scl);
    }
    rect(x, y, scl, scl);
  }

  int getTotal() {
    return total;
  }
}