void setup() {
  fullScreen(JAVA2D);
  colorMode(RGB, 1);

  background(0);
};

void draw() {
  float w = 5;
  float h = (w * height) / width;

  float xmin = -w/2;
  float ymin = -h/2;

  loadPixels();

  int maxiterations = 100;

  float xmax = xmin + w;
  float ymax = ymin + h;

  float dx = (xmax - xmin) / width;
  float dy = (ymax - ymin) / height;

  float y = ymin;
  for (int j = 0; j < height; j++)
  {
    float x = xmin;
    for (int i = 0; i < width; i++)
    {
      float a = x;
      float b = y;
      int n = 0;

      while (n < maxiterations)
      {
        float aa = a * a;
        float bb = b * b;
        float twoab = 2.0 * a * b;
        a = aa - bb + x;
        b = twoab + y;
        if (a*a + b*b > 16.0)
          break;
        n++;
      }

      if (n == maxiterations)
        pixels[i+j*width] = color(0);
      else
        pixels[i+j*width] = color(sqrt(float(n) / maxiterations));

      x += dx;
    }
    y += dy;
  }

  updatePixels();
};
