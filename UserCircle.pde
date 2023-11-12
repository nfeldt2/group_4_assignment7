class UserCircle extends Circle{
    
    UserCircle(float x, float y, float r) {
      super(x, y, r);
    }
    boolean timer() {
      if (inceptionTime + 2000 > millis() && !canSplit) {
        canSplit = false;
      } else {
        canSplit = true;
      }
      
      return canSplit;
    }
    
    void move() {
      
      float targetX = mouseX;
      float targetY = mouseY;
      
      
      float dirX = targetX - x;
      float dirY = targetY - y;
      float magnitude = sqrt(dirX*dirX + dirY*dirY);
      
      // normalize each dir between -1 and 1
      if (magnitude != 0) {
        dirX /= magnitude;
        dirY /= magnitude;
      }
       
      vx = lerp(vx, dirX * baseSpeed, 0.025);
      vy = lerp(vy, dirY * baseSpeed, 0.025);
      
      
      if (x - r <= 0 || x + r >= width) {
      // addresses scenarios when food is picked up by border causing it to permenently oscillate
        if (x - r <= 0){
          x = r;
        } else {
          x = width - r;
        }
      }
      if (y - r <= 0 || y + r >= height) {
        if (y - r <= 0) {
          y = r;
        } else {
          y = height -r;
        }
      }
      
      x += vx;
      y += vy;
    
    // Abraham functionality
  }
  
   float[] split() {
    float newRadius = this.r / sqrt(2); 
    this.r = newRadius;
    this.circleSize = PI * pow(r, 2);
    this.baseSpeed = 6 * pow(.99, circleSize/50);
    
    float dirX = mouseX - x;
    float dirY = mouseY - y;
    float magnitude = sqrt(dirX*dirX + dirY*dirY);
    if (magnitude != 0) {
      dirX /= magnitude;
      dirY /= magnitude;
    }
    
    float initialSpeed = baseSpeed * 4;
    float temp_vx = initialSpeed * dirX;
    float temp_vy = initialSpeed * dirY;
    
    this.canSplit = false;
    
    return new float[]{x + (temp_vx * 4), y + (temp_vy * 4), newRadius, temp_vx, temp_vy};
     
  }
}
  
