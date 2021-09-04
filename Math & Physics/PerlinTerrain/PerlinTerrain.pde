final int fps = 60;

float size = 32;
float smooth = 500;

int lastPress = 0;

void setup()
{
  fullScreen(JAVA2D);
  frameRate(fps);

  background(0);
};

float sx = 0, sy = 0;
float vx = 0, vy = 0;

void draw()
{
  background(0);

  for(float y = vy; y < height + vy; y += size)
    for(float x = vx; x < width + vx; x += size)
    {
      float h = noise(x/smooth, y/smooth);
      float r = map(h, 0, 1, 0, 255);
      float g = map(h, 0, 0.5, 0, 96) + map(h, 0.5, 1, 96, 0);
      float b = map(h, 0, 1, 255, 0);

      stroke(r, g, b);
      fill(r, g, b);
      rect(x - vx, y - vy, x - vx + size - 1, y - vy + size - 1);
    }

  vx -= sx;
  vy -= sy;

  control();
};

void control()
{
  if(keyPressed && frameCount - lastPress >= frameRate * 0.1)
  {
    lastPress = frameCount;
    switch(key)
    {
      case 'w':
      case 'W':
        size *= 1.05;
        break;
      case 's':
      case 'S':
        size /= 1.05;
        break;
      case 'd':
      case 'D':
        size *= 1.05;
        break;
      case 'a':
      case 'A':
        size /= 1.05;
        break;
      case 'c':
      case 'C':
        vx = 0;
        vy = 0;
        break;
      case 'v':
      case 'V':
        size = 32;
        smooth = 500;
        break;
    }
  }

  sx = map(mouseX, 0, width - 1, -35, 35);
  sy = map(mouseY, 0, height - 1, -35, 35);
};
