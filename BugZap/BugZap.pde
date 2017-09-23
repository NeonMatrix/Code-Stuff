import ddf.minim.*;
AudioPlayer music, zap, hiss, gameover;
Minim minim;
//import processing.sound.*;
//SoundFile music, zap, hiss, gameover;

void setup()
{
  size(500, 500);
  //fullScreen();
  //noCursor();
  Score = 0;
  GameOver = false;
  GameMenu = true;
  BugAlive = false;
  PlayerAlive = false;
  //music = new SoundFile(this, "Creo_Sphere.mp3");
  minim = new Minim(this);
  music = minim.loadFile("Creo_Sphere.mp3");
  //zap = new SoundFile(this, "Zap.mp3");
  zap = minim.loadFile("Zap.mp3");
  //hiss = new SoundFile(this, "Hiss.wav");
  hiss = minim.loadFile("Hiss.mp3");
  //gameover = new SoundFile(this, "GameOver.wav");
  gameover = minim.loadFile("GameOver.mp3");
  music.loop(); 
}

boolean BugAlive;
boolean PlayerAlive;
boolean GameOver;
boolean GameMenu;
int Score;
float PlayerX;
float PlayerY;
float BugX;
float BugY;
float BugSize;
float MovementDirX;
float MovementDirY;
float CollisionRange;

void draw()
{
  
  if(GameMenu)
  { 
    background(0);
    textSize(50);
    textAlign(CENTER);
    text("BUG ZAP", width/2 , height/3);
    textSize(30);
    text("Press Space To Play", width/2 , height - (height/2.5));
    BugX = width/2;
    BugY = height/6;
    DrawBug();
    
    PlayerX = width/2 - 15;
    PlayerY = height - height/6;
    DrawPlayer();
    
    if(keyPressed)
    {
      if(key ==' ')
      {
        GameMenu = false;
        GameOver = false;
        println("Space was pressed");
      }
    }
  }
  
  if(GameOver == false && GameMenu == false)
  {
     background(0);
     fill(255);
     textSize(20);
     textAlign(LEFT);
     text("Score: ", width/25, height/20);
     text(Score, width/25 + 70 , height/20);
     
     // Player Movement and Spawn
     if(PlayerAlive == false)
     {
       SpawnPlayer();
       PlayerAlive = true;
     }
     MovePlayer();
      
     // Bug Movement and Spawn
     if(BugAlive == false)
     {
       NewBug();
       BugAlive = true;
     }
     MoveBug();
  }
  
  if(GameOver)
  {
    background(0);
    fill(255);
    textSize(30);
    textAlign(CENTER);
    text("GAME OVER", width/2 , height/3);
    text("Score: " + Score, width/2, height/2);
    
    if(frameCount % 300 == 0)
    {
      GameMenu = true;
      GameOver = false;
      println("Framecount was triggered, gameover should be false");
    }
  }
}

void SpawnPlayer()
{
  PlayerX = width/2;
  PlayerY = height - (height/15);
  DrawPlayer();
}

void MovePlayer()
{
  if(PlayerX < (width - width/25) && PlayerX > width/25)
  {
    if (keyPressed)
    {
      if (keyCode == LEFT)
      {
        PlayerX = PlayerX - 5;
      }
      if (keyCode == RIGHT)
      {
        PlayerX = PlayerX + 5; 
      }
      if(keyCode == UP)
      {
        DrawLaser();
        CheckCollision();
      }
    }
  }
  
  if(PlayerX <= width/25)
  {
    PlayerX = PlayerX + 5;
  }
  
  if(PlayerX + 30 >= (width - width/25))
  {
    PlayerX = PlayerX - 5;
  }
 
 DrawPlayer();
}

void DrawPlayer()
{
  stroke(255);
  
  line(PlayerX, PlayerY, PlayerX + 30, PlayerY);
  line(PlayerX + 30, PlayerY, PlayerX + 30, PlayerY - 10); 
  line(PlayerX, PlayerY, PlayerX, PlayerY - 10);
  line(PlayerX, PlayerY - 10, PlayerX + 5, PlayerY - 15);
  line(PlayerX + 30, PlayerY - 10, PlayerX + 25, PlayerY - 15);
  line(PlayerX + 5, PlayerY - 15, PlayerX + 25, PlayerY - 15);
  line(PlayerX + 14, PlayerY - 15, PlayerX + 14, PlayerY - 20);
  line(PlayerX + 16, PlayerY - 15, PlayerX + 16, PlayerY - 20);
  line(PlayerX + 14, PlayerY - 20, PlayerX + 16, PlayerY - 20);
}

void NewBug()
{
    BugX = random(0, width);
    BugY = (height/20);
    
    noStroke();
    DrawBug();
    BugAlive = true;
}

void MoveBug()
{
     // check if it's at the right border
    if(BugX >= width - (width/25))
    {
      MovementDirX = -2;
    }
    // check if it's at the left border
    if(BugX <= width/25)
    {
      MovementDirX = +2;
    }
    
    if(BugY > PlayerY)
    {
      GameOver = true;
      BugAlive = false;
      PlayerAlive = false;
      gameover.rewind();
      gameover.play();
      println("BugY: " + BugY + "  PlayerY: " + PlayerY);
      println("Game Over");
    }
      
    if (frameCount % 30 == 0)
    {     
      MovementDirX = (int)random(-4, 4);
      MovementDirY = 1;
      println("Movement X: " + MovementDirX + "  Movement Y: " + MovementDirY);
      
    }
    
    noStroke();
    BugX = BugX + MovementDirX;
    BugY = BugY + MovementDirY;
    DrawBug();
}

void DrawBug()
{
  BugSize = 10;
  ellipseMode(CENTER);
  ellipse(BugX , BugY, BugSize, BugSize + 10);
  stroke(255);
  
  // spider leg 1
  line(BugX, BugY + 6, BugX - 15, BugY + 10);
  line(BugX - 15, BugY + 10, BugX - 25, BugY + 25);
  
  // spider leg 2
  line(BugX, BugY + 3, BugX - 20, BugY);
  line(BugX - 20, BugY, BugX - 33, BugY + 10);
  
  // spider leg 3
  line(BugX, BugY, BugX - 20, BugY - 10);
  line(BugX - 20, BugY - 10, BugX - 35, BugY - 5);
  
  // spider leg 4
  line(BugX, BugY - 6, BugX - 15, BugY - 20);
  line(BugX - 15, BugY - 20, BugX - 30, BugY - 15);
  
  // spider leg 5
  line(BugX, BugY + 6, BugX + 15, BugY + 10);
  line(BugX + 15, BugY + 10, BugX + 25, BugY + 25);
  
  // spider leg 6
  line(BugX, BugY + 3, BugX + 20, BugY);
  line(BugX + 20, BugY, BugX + 33, BugY + 10);
  
  // spider leg 7
  line(BugX, BugY, BugX + 20, BugY - 10);
  line(BugX + 20, BugY - 10, BugX + 35, BugY - 5);
  
  // spider leg 8
  line(BugX, BugY - 6, BugX + 15, BugY - 20);
  line(BugX + 15, BugY - 20, BugX + 30, BugY - 15);
  
  println("Bug X: " + BugX + "  Bug Y: " + BugY + "   Bug size: " + BugSize); 
}

void DrawLaser()
{
  zap.rewind();
  zap.play();
  stroke(255);
  line(PlayerX + 15, PlayerY - 15, PlayerX + 15, 0);
  println("LASER");
}

void CheckCollision()
{
  CollisionRange = (PlayerX + 15) - BugX;
  CollisionRange = abs(CollisionRange);
  
  if(CollisionRange <= BugSize)
  {
    hiss.rewind();
    hiss.play();
    BugAlive = false;
    Score++;
  }
}
    