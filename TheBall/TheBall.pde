import java.util.Iterator;

int fps = 60;
int framesLeftSet = 0;
int gravMode = 0, tailMode = 0, fone = 0;
float secondsSet = 1.5;
boolean update = true;

class Ball
{
  String author = "MalDenOl21112003";
  private float x, y;
  private float grav = 4 / frameRate;
  private float diam = width * height / 10000;
  private PVector vector = new PVector(0, 0);
  private int duplicates = 5;
  
  Ball(float x, float y)
  {
    this.x = x;
    this.y = y;
  }
  
  void setVector(float x, float y, float speed)
  {
    this.vector = new PVector(x, y);
    this.vector.normalize();
    this.vector.mult(speed);
  }
  
  void setVector(float x, float y)
  {
    this.vector = new PVector(x, y);
  }
  
  void reflect()
  {
    if(this.x < this.diam / 2)
    {
      this.x = this.diam / 2;
      this.vector.x = -this.vector.x;
    }
    else if(this.x > width - 1 - this.diam / 2)
    {
      this.x = width - 1 - this.diam / 2;
      this.vector.x = -this.vector.x;
    }
    if(this.y < this.diam / 2)
    {
      this.y = this.diam / 2;
      this.vector.y = -this.vector.y;
    }
    else if(this.y > height - 1 - this.diam / 2)
    {
      this.y = height - 1 - this.diam / 2;
      this.vector.y = -this.vector.y;
    }
  }
  
  void gravity(float dstX, float dstY)
  {
    PVector temp = new PVector(dstX - this.x, dstY - this.y);
    temp.normalize();
    temp.mult(this.grav);
    this.vector.add(temp);
  }
  
  void gravity(float dstX, float dstY, int dependence, float gravK)
  {
    PVector temp = new PVector(dstX - this.x, dstY - this.y);
    temp.normalize();
    temp.mult(this.grav * gravK);
    temp.div(pow(this.distance(dstX, dstY), dependence));
    this.vector.add(temp);
  }
  
  void go()
  {
    this.reflect();
    x += this.vector.x;
    y += this.vector.y;
  }
  
  void show()
  {
    strokeWeight(3);
    stroke(255);
    fill(0);
    ellipse(this.x, this.y, diam, diam);
    noFill();
  }
  
  void duplicate(ArrayList<Ball> balls)
  {
    for(int i = 0; i < duplicates; i++)
    {
      Ball temp = new Ball(this.x, this.y);
      temp.setVector(random(-1, 1), random(-1, 1), random(1, 10));
      balls.add(temp);
    }
  }
  
  void delete(ArrayList<Ball> balls)
  {
    Iterator<Ball> iter = balls.iterator();
    while(balls.size() > 1 && iter.hasNext())
      iter.remove();
  }
  
  void setGrav(float grav)
  {
    this.grav = grav;
  }
  
  void setDiam(float diam)
  {
    this.diam = diam;
  }
  
  float getX()
  {
    return this.x;
  }
  
  float getY()
  {
    return this.y;
  }
  
  float getDiam()
  {
    return this.diam;
  }
  
  float distance(float x, float y)
  {
    return sqrt(pow(x - this.x, 2) + pow(y - this.y, 2));
  }
}

ArrayList<Ball> balls = new ArrayList<Ball>();

void setup()
{
  fullScreen();
  noCursor();
  frameRate(fps);
  
  balls.add(new Ball(width / 2, height / 2));
  balls.get(0).setDiam(width * height / 10000);
}

void draw()
{
  Iterator<Ball> iter = balls.iterator();
  while(iter.hasNext() == true)
  {
    Ball ball = iter.next();
    logic(ball);
  }
  if(mousePressed == true)
      point(mouseX, mouseY);
}

void keyPressed()
{
  if(key == 'F' || key == 'f')
      fone++;
  if(key == 'G' || key == 'g')
      gravMode++;
  if(key == 'T' || key == 't')
      tailMode++;
}

void mousePressed()
{
  if(mouseX <= width / 5 && mouseY <= height / 5 || mouseX >= width - width / 5 && mouseY >= height - height / 5 || mouseX <= width / 5 && mouseY >= height - height / 5 || mouseX >= width - width / 5 && mouseY <= height / 5)
    framesLeftSet = frameCount;
}

void mouseReleased()
{
  if(frameCount - framesLeftSet >= fps * secondsSet && framesLeftSet == 0)
  {
    if(mouseX <= width / 5 && mouseY <= height / 5)
      fone++;
    else if(mouseX >= width - width / 5 && mouseY >= height - height / 5)
      gravMode++;
    else if(mouseX <= width / 5 && mouseY >= height - height / 5)
      tailMode++;
  }
  framesLeftSet = 0;
}

void logic(Ball ball)
{
  switch(tailMode)
  {
    case 0:
      update = true;
      break;
    case 1:
      update = false;
      break;
    default:
      tailMode = 0;
      break;
  }
  
  if(update == true)
    switch(fone)
    {
      case 0:
        background(map(ball.getX() + ball.getY(), 0, width + height - 2, 0, 255), map(ball.getX(), 0, width - 1, 0, 255), map(ball.getY(), 0, height - 1, 0, 255));
        break;
      case 1:
        background(map(ball.getX(), 0, width - 1, 0, 255), map(ball.getX() + ball.getY(), 0, width + height - 2, 0, 255), map(ball.getY(), 0, height - 1, 0, 255));
        break;
      case 2:
        background(map(ball.getY(), 0, height - 1, 0, 255), map(ball.getX(), 0, width - 1, 0, 255), map(ball.getX() + ball.getY(), 0, width + height - 2, 0, 255));
        break;
      case 3:
        background(0);
        break;
      case 4:
        background(255);
        break;
      case 5:
        background(random(0, 255), random(0, 255), random(0, 255));
        break;
      default:
        fone = 0;
        break;
    }
  
  switch(gravMode)
  {
    case 0:
      if(mousePressed == true && framesLeftSet == 0)
      {
        ball.gravity(mouseX, mouseY);
        if(ball.distance(mouseX, mouseY) <= ball.getDiam() / 2)
          ball.setVector(mouseX - ball.getX(), mouseY - ball.getY());
      }
      break;
    case 1:
      if(mousePressed == true && framesLeftSet == 0)
      {
        ball.gravity(mouseX, mouseY, 2, 1000);
        if(ball.distance(mouseX, mouseY) <= ball.getDiam() / 2)
          ball.setVector(mouseX - ball.getX(), mouseY - ball.getY());
      }
      break;
    case 2:
      if(mousePressed == true && framesLeftSet == 0)
        ball.gravity(mouseX, mouseY, 2, 1000);
      break;
    /*FUCKING
    case 3:
      if(mousePressed == true && ball.distance(mouseX, mouseY) <= ball.getDiam() / 2 && framesLeftSet == 0)
        ball.duplicate(balls);
      break;
    case 4:
      balls.get(0).delete(balls);
      return;
    SHIT*/
    default:
      gravMode = 0;
      break;
  }
    
    ball.go();
    ball.show();
}
