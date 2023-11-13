class Mine {
  float x, y;
  float r;
  boolean exploded = false;

  Mine(float x, float y, float r) {
    this.x = x;
    this.y = y;
    this.r = r;
  }

  void display() {
    fill(255, 0, 0);\
    ellipse(x, y, 2*r, 2*r);
  }

  boolean checkCollision(UserCircle userCircle) {
    if (dist(x, y, userCircle.x, userCircle.y) < r + userCircle.r) {
      return true;
    }
    return false;
  }
}
