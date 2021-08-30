float r;
int angles = 3;

ArrayList<Point> points;
Point dot;

class Point
{
  private float x, y;
  private float r = 255, g = 255, b = 255;
  
  public Point(float x, float y)
  {
    this.x = x;
    this.y = y;
    point(x, y);
  }
  
  public Point(Point dot)
  {
    this.x = dot.x;
    this.y = dot.y;
  }
  
  public void go(Point dot, float part)
  {
    x += (dot.x - x) / part;
    y += (dot.y - y) / part;
    setColor(dot.r, dot.g, dot.b);
    stroke(r, g, b);
    ellipse(x, y, 1, 1);
  }
  
  public void setColor(float r, float g, float b)
  {
    this.r = r;
    this.g = g;
    this.b = b;
  }
};

void setup()
{
  fullScreen(JAVA2D);
  
  background(0);
  
  points = new ArrayList<Point>();
  
  r = min(width, height) * 0.85 / 2;
  
  angles = (int)random(2, 10);
  generate(angles);
};

void draw()
{
  translate(width / 2, height / 2);
  
  for(int i = 0; i < 1000; i++)
    dot.go(points.get((int)random(0, points.size() - 1)), 2);
};

void generate(int a)
{
  a++;
  for(int i = 1; i <= a; i++)
  {
    float degr = map(i, 1, a, 0, TWO_PI);
    Point point = new Point(r * cos(degr), r * sin(degr));
    point.setColor(random(128, 255), random(128, 255), random(128, 255));
    points.add(point);
  }
  
  dot = new Point(points.get(0));
};

void mouseReleased()
{
  background(0);
  
  if(mouseButton == RIGHT)
    setup();
  
  generate(angles);
};
