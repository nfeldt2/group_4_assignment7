class Food {
  ArrayList<ArrayList<Boolean>> food;
  int implemented;
  int amount;
  int sizeX;
  int sizeY;
  
  Food(int in_x, int in_y, int total) {
    implemented = 0;
    amount = total;
    sizeX = in_x;
    sizeY = in_y;
    
    food = new ArrayList<ArrayList<Boolean>>();
    
    for (int i = 0; i < sizeX; i++) {
      ArrayList<Boolean> column = new ArrayList<Boolean>();
      
      for (int j = 0; j < sizeY; j++) {
        column.add(false);
      }
      
      food.add(column);
    }
    
   while (amount != implemented) {
     int x = int(random(0, sizeX));
     int y = int(random(0, sizeY));
     
     if (!food.get(x).get(y)){
       food.get(x).set(y, true);
       implemented += 1;
     }
    }
  }
  
  
  void update() {
    while (amount != implemented) {
     int x = int(random(0, sizeX));
     int y = int(random(0, sizeY));
     
     if (!food.get(x).get(y)){
       food.get(x).set(y, true);
       implemented += 1;
     }
    }
  }
}
