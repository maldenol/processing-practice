final int fps = 60;
float r, a, step;

void setup()
{
  fullScreen(JAVA2D);
  frameRate(fps);

  background(0);

  r = min(width, height) / 2;
  a = 0;
  step = TWO_PI / fps;
};

void draw()
{
  background(0);
  translate(width / 2, height / 2);

  fractal(-r*cos(a), -r*sin(a), r*cos(a), r*sin(a), 10);

  a += step;
  if(a >= TWO_PI)
    a = 0;
};

void fractal(float ax, float ay, float bx, float by, int it)
{
  float cx, cy, dx, dy, ex, ey;

  PVector main = new PVector(bx - ax, by - ay);

  cx = ax + main.x/2;
  cy = ay + main.y/2;

  float mlen = sqrt(main.x*main.x + main.y*main.y);

  PVector branch = new PVector(-1, main.x / main.y);
  branch.normalize();
  branch.mult(mlen/2);

  dx = cx + branch.x;
  dy = cy + branch.y;
  ex = cx - branch.x;
  ey = cy - branch.y;

  stroke(255);
  noFill();
  ellipse(cx, cy, mlen, mlen);
  line(ax, ay, bx, by);

  if(it >= 1 && mlen >= 2)
  {
    fractal(cx, cy, dx, dy, it - 1);
    fractal(cx, cy, ex, ey, it - 1);
  }
}
