// by MalDenOl

final float[][] matrix = new float[][]{
  {0, 0, 0, 0.16, 0, 0, 0.01, 0, 0},
  {0.85, 0.04, -0.04, 0.85, 0, 1.6, 0.85, 0, 0},
  {0.20, -0.26, 0.23, 0.22, 0, 1.6, 0.07, 0, 0},
  {-0.15, 0.28, 0.26, 0.24, 0, 0.44, 0.07, 0, 0},
};

/*
  Fern Barnsley

  f(x) = ax + by + e
  f(y) = cx + dy + f

  ---------------------------------------------------------
  | i      0      1      2      3      4      5      6    |
  |-------------------------------------------------------|
  | f      a      b      c      d      e      f      p    |
  |-------------------------------------------------------|
  | f1     0.00   0.00   0.00   0.16   0.00   0.00   0.01 |
  | f2     0.85   0.04  -0.04   0.85   0.00   1.60   0.85 |
  | f3     0.20  -0.26   0.23   0.22   0.00   1.60   0.07 |
  | f4    -0.15   0.28   0.26   0.24   0.00   0.44   0.07 |
  ---------------------------------------------------------
*/

float x = 0, y = 0, xp = 0, yp = 0;
float border;
float rm = 127, gm = 255, bm = 63;
float smooth = 10;

PImage screen;

void setup()
{
  fullScreen(JAVA2D);
  noCursor();

  background(0);

  border = min(width, height);

  screen = get();

  float percent = 0;
  for(float[] line : matrix)
  {
    line[8] = percent + line[6];
    percent += line[6];
    line[7] = line[8] - line[6];
  }
};

void draw()
{
  image(screen, 0, 0);
  translate(width/2, height/50);
  scale(0.9);

  for(int i = 0; i < 1000; i++)
  {
    int rand = (int)random(100);

    float xt = x;
    float yt = y;

    for(float[] line : matrix)
      if(rand >= line[7]*100 && rand < line[8]*100)
      {
        x = line[0]*xp + line[1]*yp + line[4];
        y = line[2]*xp + line[3]*yp + line[5];
        break;
      }

    xp = xt;
    yp = yt;

    float r = noise(x*smooth, y*smooth) * rm;
    float g = noise(x*smooth, y*smooth) * gm;
    float b = noise(x*smooth, y*smooth) * bm;
    stroke(r, g, b);
    point(x*border/10, y*border/10);
  }

  screen = get();
};

void mouseReleased()
{
  int mode = (int)map(mouseX, -1, width, 1, 5);
  float val = map(mouseY, 0, height - 1, 255, 0);

  switch(mode)
  {
    case 1:
      rm = val;
      break;
    case 2:
      gm = val;
      break;
    case 3:
      bm = val;
      break;
    case 4:
      smooth = map(val, 0, 255, 0, 10);
      break;
  }

  setup();
};

void mouseDragged()
{
  int mode = (int)map(mouseX, -1, width, 1, 5);
  float col = map(mouseY, 0, height - 1, 255, 0);

  switch(mode)
  {
    case 1:
      stroke(col, 0, 0);
      fill(col, 0, 0);
      break;
    case 2:
      stroke(0, col, 0);
      fill(0, col, 0);
      break;
    case 3:
      stroke(0, 0, col);
      fill(0, 0, col);
      break;
    case 4:
      stroke(col);
      fill(col);
      break;
  }

  float x = mouseX - width/2, y = mouseY - height/50;
  ellipse(x, y, 15, 15);
};
