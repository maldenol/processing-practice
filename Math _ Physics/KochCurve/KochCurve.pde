float r;
float a = 0;

void setup()
{
  fullScreen(JAVA2D);
  frameRate(60);
  
  background(0);
  
  r = min(width, height) * 0.85 / 2;
};

void draw()
{
  background(0);
  
  translate(width/2, height/2);
  
  koch(0, 0, r, a);
  
  a += 0.035;
  if(a > TWO_PI)
    a = 0;
};

void koch(float x, float y, float r, float a)
{
  float ax, ay, bx, by, cx, cy;
  
  ax = x + r*cos(a + radians(30));
  ay = y + r*sin(a + radians(30));
  bx = x + r*cos(a + radians(150));
  by = y + r*sin(a + radians(150));
  cx = x + r*cos(a + radians(270));
  cy = y + r*sin(a + radians(270));
  
  stroke(255);
  fill(255);
  beginShape();
  vertex(ax, ay);
  vertex(bx, by);
  vertex(cx, cy);
  endShape();
  
  float dx, dy, ex, ey, fx, fy;
  
  PVector ab = new PVector(bx - ax, by - ay);
  PVector bc = new PVector(cx - bx, cy - by);
  PVector ca = new PVector(ax - cx, ay - cy);
  if(ay > by) ab.mult(-1);
  if(by > cy) bc.mult(-1);
  if(cy > ay) ca.mult(-1);
  
  dx = ax + ab.x/2;
  dy = ay + ab.y/2;
  ex = bx + bc.x/2;
  ey = by + bc.y/2;
  fx = cx + ca.x/2;
  fy = cy + ca.y/2;
  
  ab = new PVector(-1, ab.x / ab.y);
  bc = new PVector(-1, bc.x / bc.y);
  ca = new PVector(-1, ca.x / ca.y);
  ab.normalize();
  ab.mult(r/sqrt(12));
  bc.normalize();
  bc.mult(r/sqrt(12));
  ca.normalize();
  ca.mult(r/sqrt(12));
  
  dx += ab.x;
  dy += ab.y;
  ex += bc.x;
  ey += bc.y;
  fx += ca.x;
  fy += ca.y;
  
  if(r >= 1)
  {
    koch(dx, dy, r/3, a - 2*radians(30));
    koch(ex, ey, r/3, a - 2*radians(150));
    koch(fx, fy, r/3, a - 2*radians(270));
  }
};
