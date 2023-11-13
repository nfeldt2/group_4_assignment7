class Mine {
  float x, y;
  float r;
  ArrayList<Circle> explodedCircles;

  Mine(float x, float y, float r) {
    this.x = x;
    this.y = y;
    this.r = r;
    explodedCircles = new ArrayList<Circle>();
  }

  void display() {
    fill(255, 0, 0);
    ellipse(x, y, 2 * r, 2 * r);
  }

  boolean checkCollision(Circle circle) {
    float distance = dist(x, y, circle.x, circle.y);
    return distance < r + circle.r;
  }

  void explode() {
    int numSmallerCircles = 8;
    float smallerRadius = r / 4;

    for (int i = 0; i < numSmallerCircles; i++) {
      float angle = TWO_PI / numSmallerCircles * i;
      float offsetX = smallerRadius * cos(angle);
      float offsetY = smallerRadius * sin(angle);
      float smallerX = x + offsetX;
      float smallerY = y + offsetY;
      float smallerVX = 2 * cos(angle);
      float smallerVY = 2 * sin(angle);

      Circle smallerCircle = new Circle(smallerX, smallerY, smallerRadius);
      smallerCircle.vx = smallerVX;
      smallerCircle.vy = smallerVY;
      explodedCircles.add(smallerCircle);
    }
  }
}
