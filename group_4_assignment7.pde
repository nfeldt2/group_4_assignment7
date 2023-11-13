Food myFood;
int sizeX;
int sizeY;
ArrayList<Circle> circles;

void setup() {
  size(1500, 1000);
  myFood = new Food(width/5, height/5, 350);
  sizeX = width/5;
  sizeY = height/5;
  for (int i = 0; i < sizeX; i++) {
    for (int j = 0; j < sizeY; j++) {
      if (myFood.food.get(i).get(j)) {
        fill(0);
        rect(i * (width / sizeX), j * (height / sizeY), width / sizeX, height / sizeY);
      }
    }
  }
  circles = new ArrayList<Circle>();
  for (int i = 0; i < 30; i++) { 
    circles.add(new Circle(random(width), random(height), random(5, 20)));
  }
  circles.add(new UserCircle(width/2, height/2, 10));
}

void draw() {
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
   } else {
     c.move();
     c.display();
   }
 }
 
 checkForEngulfing();
}

void reDrawFood(){
  myFood.update();
  for (int i = 0; i < sizeX; i++) {
    for (int j = 0; j < sizeY; j++) {
      if (myFood.food.get(i).get(j)) {
        fill(0);
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
            UserCircle temp = new UserCircle(params[0], params[1], params[2]);
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
