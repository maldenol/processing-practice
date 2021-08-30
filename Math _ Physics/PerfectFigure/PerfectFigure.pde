final int fps = 60;
int a = 5, r;
float st = 0;

ArrayList<Point> points;

class Point
{
  float x, y;
  
  public Point(float x, float y)
  {
    this.x = x;
    this.y = y;
  }
  
  public void show(Point p)
  {
    stroke(255);
    line(x, y, p.x, p.y);
  }
};

void setup()
{
  fullScreen(JAVA2D);
  frameRate(fps);
  
  background(0);
  
  r = (int)(min(width, height) * 0.85 / 2);
  
  points = new ArrayList<Point>();
};

void draw()
{
  background(0);
  translate(width/2, height/2);
  
  points.clear();
  
  a = (int)map(mouseX, 0, width - 1, 1, 25);
  st += TWO_PI / fps * map(mouseY, 0, height - 1, 0, 1);
  if(st > TWO_PI)
    st = 0;
  
  for(int i = 0; i <= a; i++)
  {
    float ar = map(i, 0, a, 0 + st, TWO_PI + st);
    float x = r * cos(ar);
    float y = r * sin(ar);
    points.add(new Point(x, y));
  }
  
  int len = points.size();
  for(int i = 0; i < len; i++)
    for(int j = i; j < len; j++)
      points.get(i).show(points.get(j));
  
  noFill();
  ellipse(0, 0, r * 2, r * 2);
};