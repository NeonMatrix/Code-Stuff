void setup()
{
  //size(500,500);
  fullScreen();
  background(0);
  stroke(255);
  strokeWeight(.25);
  pink = color(255, 112, 193);
  blue = color(73, 179, 255);
  img = loadImage("palm_tree.png");
}

float roadMove = 1;
float speed = 0.05;
color pink, blue;
int Y_AXIS = 1;
int X_AXIS = 2;
PImage img;

void draw()
{
  setGradient(0, 0, width, height, blue, pink, Y_AXIS);
  imageMode(CORNERS);
  image(img, width/4, height/2 - 100 , width/4 + 100, height/2 + 8);
  image(img, width - width/4, height/2 - 100, (width - width/4) - 100, height/2 + 8);
  stroke(255);
  int i;
  for (i= 0; i< width/10; i++)
  {
    line(width/2,height/2,i*10,height);
  }
  
  drawRoad();
  /*i=height/2;
  float y = 2;
  while(i<height)
  {
    line(0,i,width,i);
    i = i + int(y);
    y = y*1.25;
  }*/
}

void drawRoad()
{
  int i=height/2;
  float y = 1;
  
  if(roadMove > 2.25)
  {
     roadMove = 1; 
  }
  
  while(i<height)
  {
    line(0,i,width,i);
    i = i + int(y);
    y = y * 1.25 + roadMove;
  }
  
  roadMove += speed;
}



void setGradient(int x, int y, float w, float h, color c1, color c2, int axis )
{
  noFill();

  if (axis == Y_AXIS) {  // Top to bottom gradient
    for (int i = y; i <= y+h; i++) 
    {
      float inter = map(i, y, y+h, 0, 1);
      color c = lerpColor(c1, c2, inter);
      stroke(c);
      line(x, i, x+w, i);
    }
  }  
  else if (axis == X_AXIS) {  // Left to right gradient
    for (int i = x; i <= x+w; i++) 
    {
      float inter = map(i, x, x+w, 0, 1);
      color c = lerpColor(c1, c2, inter);
      stroke(c);
      line(i, y, i, y+h);

    }
  }
}