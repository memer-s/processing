int xsize = 50;
int ysize = 50;
int pxs = 20;
int csquare = 3; // Uneven number > 3

int[][] randomize() {
  int arr[][] = new int[ysize][xsize];
  
  for(int i = 0; i < ysize; i++) {
    for(int j = 0; j < xsize; j++) {
      arr[i][j] = floor(random(0,255));
    }
  }
  
  return arr;
}

int[][] loadCustomImage(String path) {
  
  int arr[][] = new int[ysize][xsize];
  PImage img = loadImage(path);
  img.filter(GRAY);
  for(int i = 0; i < ysize; i++) {
    for(int j = 0; j < xsize; j++) {
      arr[i][j] = img.get(i*3,j*3+20);
    }
  }
  
  return arr;
}

void display(int[][] array) {
  clear();
  noStroke();

  for(int i = 0; i < ysize; i++) {
    for(int j = 0; j < xsize; j++) {
      fill(array[i][j]);
      rect(i*pxs,j*pxs,pxs,pxs);
    }
  }
  
  stroke(153);
}

int[][] convolve(int[][] arr, int x, int y) {
  int n = (csquare-1)/2;
  int[][] convolved = new int[csquare][csquare];
  
  noFill();  
  stroke(255,0,0);
  rect((x-n)*pxs,(y-n)*pxs,pxs*csquare,pxs*csquare);
  stroke(0,255,0);
  rect(x*pxs,y*pxs,pxs,pxs);
  fill(122);
  
  for(int i = 0; i < csquare; i++) {
    for(int j = 0; j < csquare; j++) {
      try {
        convolved[i][j] = arr[y+(i-n)][x+(j-n)];
      }
      catch(Exception e) {
        convolved[i][j] = floor(random(0,255));
      }
    }
  }
  
  return convolved;
}

int filter(int[][] con) {
  int sum = 0;
  
  for(int i = 0; i < con.length; i++) {
    for(int j = 0; j < con[0].length; j++) {
      sum += con[i][j];
    }
  }
  
  return sum/(con.length*con.length);
}

float[][] map3 = {
  {1, 0, 0},
  {0, 0, 0},
  {0, 0, 0}
};

int filterMap(int[][] con, int x, int y) {
  int sum = 0;  
  int n = (csquare-1)/2;
  float divisor = 1;
  
  for(int i = 0; i < con.length; i++) {
    for(int j = 0; j < con[0].length; j++) {
      strokeWeight(2);
      stroke(0,floor(255.0*map3[i][j]),0);
      noFill();
      rect((x+j-n)*pxs,(y+i-n)*pxs,pxs,pxs);
      int temp = 0;
      
      try {
        temp += (con[i][j] * map3[i][j]);
      }
      
      catch(Exception e) {
        temp = 0;
        divisor -= map3[i][j];
      }
      
      sum+=temp;
      
    }
  }
  
  return floor(sum/divisor);
}

int[][] array;
int iteration = 0;

void setup() {
  size(1000,1000);
  array = loadCustomImage("image.png");
  frameRate(10000);
}

void draw() {    
  display(array);

  int[][] c = convolve(array, iteration%50,iteration/50);
  array[iteration%50][iteration/50] = filterMap(c, iteration%50, iteration/50);
  
  textSize(60);
  fill(255,100,200);
  //text(Integer.toString(filter(c)), 20,60);
  if(iteration == (50*50)-1) {
    iteration = 0;
  }
  iteration++;
}
