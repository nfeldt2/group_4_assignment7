Food myFood;
int sizeX;
int sizeY;
ArrayList<Circle> circles;
ArrayList<Mine> mines;
float gameTimer;
float gameStart;

boolean inMenu = true;
int userCircleColor = color(0, 0, 255);

void setup() {
  size(1500, 1000);
  gameStart = millis();
  myFood = new Food(width/5, height/5, 350);
  sizeX = width/5;
  sizeY = height/5;
  for (int i = 0; i < sizeX; i++) {
    for (int j = 0; j < sizeY; j++) {
      if (myFood.food.get(i).get(j)) {
        fill(0, 255, 0);
        rect(i * (width / sizeX), j * (height / sizeY), width / sizeX, height / sizeY);
      }
    }
  }
  circles = new ArrayList<Circle>();
  for (int i = 0; i < 30; i++) { 
    circles.add(new Circle(random(width), random(height), random(5, 20)));
  }
  circles.add(new UserCircle(width/2, height/2, 10, userCircleColor));

  mines = new ArrayList<Mine>();
  for (int i = 0; i < 5; i++) {
    float mineX = random(width);
    float mineY = random(height);
    mines.add(new Mine(mineX, mineY, 15));
  }
}

void draw() {
  if (inMenu) {
    drawMenu();
  } else {
    background(255);
    reDrawFood();
    for (int i = 0; i < circles.size(); i++) {
      Circle c;
      c = circles.get(i);
      c.growOnTouchingFood(myFood);
      if (c instanceof UserCircle) {
        UserCircle temp = (UserCircle) c;
        temp.move();
        temp.display();
        gameTimer = (millis() - gameStart)/100;
        fill(0);
        textSize(64);
        text("Current Radius: " + round(temp.r), 30, 50);
        text("Time Alive: " + gameTimer, 950, 50);
      } else {
        c.move();
        c.display();
      }
    }
   
    checkForEngulfing();
  
    for (Mine mine : mines) {
      mine.display();
      for (Circle circle : circles) {
        if (circle instanceof UserCircle && mine.checkCollision(circle)) {
          mine.explode();
          circle.r *= 0.8;
        }
      }
  
      for (Circle fragment : mine.explodedCircles) {
        fragment.move();
        fragment.display();
      }
    }
  }
}

void drawMenu() {
  background(200);
  textSize(32);
  fill(0);
  text("Click to Change User Circle Color", width / 2 - 150, height / 2 - 50);

  int[] colors = {color(255, 255, 0), color(0, 255, 0), color(0, 0, 255)};
  for (int i = 0; i < colors.length; i++) {
    fill(colors[i]);
    ellipse(100 + 100 * i, height / 2, 50, 50);
  }
}

void mousePressed() {
  if (inMenu) {
    for (int i = 0; i < 3; i++) {
      if (dist(mouseX, mouseY, 100 + 100 * i, height / 2) < 25) {
        if (i == 0) userCircleColor = color(255, 255, 0);
        if (i == 1) userCircleColor = color(0, 255, 0);
        if (i == 2) userCircleColor = color(0, 0, 255);

        inMenu = false;
        setup();
      }
    }
  }
}

void reDrawFood(){
  myFood.update();
  for (int i = 0; i < sizeX; i++) {
    for (int j = 0; j < sizeY; j++) {
      if (myFood.food.get(i).get(j)) {
        fill(0, 255, 0);
        rect(i * (width / sizeX), j * (height / sizeY), width / sizeX, height / sizeY);
      }
    }
  }
}

void checkForEngulfing() {
  int[] toRemove={};
  int iterations = circles.size();
  boolean userCircle = true;
  for (int i = iterations - 1; i >= 0; i--) {
    
    Circle c1;
    if (circles.get(i) instanceof UserCircle) {
      c1 = (UserCircle) circles.get(i);
      
      if (userCircle) {
        if (keyPressed && key == 's') {
          boolean allowSplit = ((UserCircle) c1).timer();
          if (allowSplit) {
            float[] params = ((UserCircle) c1).split();
            UserCircle temp = new UserCircle(params[0], params[1], params[2], userCircleColor);
            temp.vx = params[3];
            temp.vy = params[4];
            temp.canSplit = false;
            circles.add(temp);
        }
      }
      }
      userCircle = false;
      
    } else {
      c1 = circles.get(i);
    }
    
    for (int j = iterations - 1; j >= 0; j--) {
      if (i == j) continue;
      
      Circle c2 = circles.get(j);

      float d = dist(c1.x, c1.y, c2.x, c2.y);
      
      if (c1.r > 1.1 * c2.r && d < 0.9 * c1.r) {
        toRemove = append(toRemove, j);
        c1.engulf(c2.circleSize);
      }
    }
  }
  for (int index : toRemove) {
    circles.remove(index);
  }
}
