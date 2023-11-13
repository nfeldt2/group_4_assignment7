class Circle {
  float x, y;      
  float r;         
  float vx, vy;    
  float baseSpeed; 
  float circleSize;
  float inceptionTime;
  boolean canSplit;

  Circle(float x, float y, float r) {
    this.x = x;
    this.y = y;
    this.r = r;
    this.inceptionTime = millis();
    this.circleSize = PI * pow(r, 2);
    this.baseSpeed = 2 * pow(.99, circleSize/50); 
    float angle = random(TWO_PI);
    this.vx = this.baseSpeed * cos(angle);
    this.vy = this.baseSpeed * sin(angle);
    this.canSplit = false;
  }

  void move() {
    float speedCurrent = lerp(this.baseSpeed, 6 * pow(.99, circleSize/50), 0.01);
    float ratio = this.baseSpeed/speedCurrent;
    x += vx * ratio;
    y += vy * ratio;

    
    if (x - r <= 0 || x + r >= width) {
      vx = -vx;
      // addresses scenarios when food is picked up by border causing it to permenently oscillate
      if (x - r <= 0){
        x = r;
      } else {
        x = width - r;
      }
    }
    if (y - r <= 0 || y + r >= height) {
      vy = -vy;
      if (y - r <= 0) {
        y = r;
      } else {
        y = height -r;
      }
    }
    
  }

  void growOnTouchingFood(Food food) {
    for (int i = 0; i < sizeX; i++) {
      for (int j = 0; j < sizeY; j++) {
        // circle must engulf the center of the food
        if (food.food.get(i).get(j) && dist(x, y, i * (width / sizeX) + 2.5 , j * (height / sizeY) + 2.5) <= r) {
          r = sqrt((circleSize + 50)/PI);
          circleSize = PI * r * r;
          food.food.get(i).set(j, false);
          food.implemented -= 1; 

          
          baseSpeed *= 0.99;
          float speedCurrent = sqrt(vx*vx + vy*vy);
          float ratio = baseSpeed / speedCurrent;
          vx *= ratio;
          vy *= ratio;
        }
      }
    }
  }
  
  void engulf(float otherSize) {
    r = sqrt((circleSize + otherSize)/PI);
    circleSize = PI * r * r;
    baseSpeed *= pow(.99, 50/otherSize); // adjust speed based on size engulfed
    float speedCurrent = sqrt(vx*vx + vy*vy);
    float ratio = baseSpeed / speedCurrent;
    vx *= ratio;
    vy *= ratio;
  }
    
  void display() {
    fill(150);
    ellipse(x, y, 2*r, 2*r);
  }
}
