int fps = 60;
int w, h;
float speed = 150;
float scale = 200, smooth = 0.09, limit = 750;
float terrain[][];
float xOff, yOff, totalOff = 0, speedOff = speed / scale / fps;
float borderMult = 10;

void setup()
{
  fullScreen(P3D);
  frameRate(fps);
  noCursor();

  w = (int)(width / scale * borderMult);
  h = (int)(height / scale * borderMult);

  terrain = new float[h][w];

  stroke(255);
}
void draw()
{
  float r = map(mouseY, 0, height - 1, 64, 194);
  float g = map(mouseY, 0, height - 1, 0, 32);
  float b = map(mouseY, 0, height - 1, 255, 0);
  background(r, g, b);

  float rotX = map(mouseY, 0, height - 1, PI / 2.5, 0);
  float rotY = map(mouseX, 0, width - 1, -PI / 2.5, PI / 2.5);

  translate(width / 2, height / 2);
  rotateY(rotY);
  rotateX(rotX);

  translate(-width / 2 * borderMult, -height / 2 * borderMult, -limit);

  yOff = totalOff;
  for(int y = 0; y < h; y++)
  {
    xOff = 0;
    for(int x = 0; x < w; x++)
    {
      terrain[y][x] = map(noise(xOff, yOff), 0, 1, -limit, limit);
      xOff += smooth;
    }
    yOff += smooth;
  }
  totalOff -= speedOff;

  for(int y = 0; y < h - 1; y++)
  {
    lights();
    beginShape(TRIANGLE_STRIP);
    for(int x = 0; x < w; x++)
    {
      fill(
        map((terrain[y][x] >= 0 ? terrain[y][x] : 0), 0, limit, 0, 255),
        map((terrain[y][x] <= 0 ? terrain[y][x] : 0), -limit, 0, 0, 64) + map((terrain[y][x] >= 0 ? terrain[y][x] : 0), 0, limit, 64, 0),
        map((terrain[y][x] <= 0 ? terrain[y][x] : 0), -limit, 0, 255, 0)
      );
      vertex(x * scale, y * scale, terrain[y][x]);
      fill(
        map((terrain[y + 1][x] >= 0 ? terrain[y + 1][x] : 0), 0, limit, 0, 255),
        map((terrain[y + 1][x] <= 0 ? terrain[y + 1][x] : 0), -limit, 0, 0, 64) + map((terrain[y + 1][x] >= 0 ? terrain[y + 1][x] : 0), 0, limit, 64, 0),
        map((terrain[y + 1][x] <= 0 ? terrain[y + 1][x] : 0), -limit, 0, 255, 0)
      );
      vertex(x * scale, (y + 1) * scale, terrain[y + 1][x]);
    }
    endShape();
  }
  noFill();
}
