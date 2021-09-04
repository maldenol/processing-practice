import java.util.Iterator;

final int fps = 30;
final float minW = 1, maxW = 10, minH = 50, maxH = 150, minZ = -10, maxZ = 10;
final float changeSpeed = 50;
int conc;
int count = 0;
int fone = 0, mode = 0, rdColor = 0, change = 0;
Integer form = new Integer(0);
int framesLeft = 0, seconds = 1;
float fr = 0, fg = 0, fb = 0;
float zoom = 1, size = 1;

class RainDrop {
  String author = "MalDenOl21112003";
  private float x, y, z;
  private float thick, len;
  private float r = 0, g = 0, b = 255;
  private float speed = 0.3;
  final private float depth = 0.9;
  private float px, py;
  private float size = 1;

  RainDrop(float x, float z, float thick, float len) {
    this.x = x;
    this.y = -len;
    this.z = z;
    this.thick = thick;
    this.len = len;
  };

  void go() {
    px = x;
    py = y;
    y += speed * pow(depth, z);
  };

  void go(float speedX, float speedY, float speedZ) {
    px = x;
    py = y;
    x += speed * speedX * pow(depth, z);
    y += speed * speedY * pow(depth, z);
    z += speed * speedZ * pow(depth, z);
  };

  Integer show(Integer form) {
    stroke(r, g, b);
    fill(r, g, b);

    float wdth = thick * pow(depth, z) * size;
    float hght = len * pow(depth, z) * size;
    float mid = (wdth + hght) / 2;

    float vectl, vectx, vecty;

    switch(form)
    {
      case 0:
        strokeWeight(wdth);
        line(x, y, x, y + hght);
        break;
      case 1:
        strokeWeight(wdth);
        line(x, y, x + hght, y);
        break;
      case 2:
        strokeWeight(wdth);
        vectx = x - px;
        vecty = y - py;
        vectl = sqrt(vectx * vectx + vecty * vecty);
        vectx *= hght / vectl;
        vecty *= hght / vectl;
        line(px, py, px + vectx, py + vecty);
        break;
      case 3:
        strokeWeight(wdth);
        vectx = x - px;
        vecty = y - py;
        vectl = sqrt(vectx * vectx + vecty * vecty);
        vectx *= hght / vectl;
        vecty *= hght / vectl;
        line(px, py, px + vecty, py + vectx);
        break;
      case 4:
        ellipse(x, y, wdth, hght);
        break;
      case 5:
        strokeWeight(mid);
        point(x, y);
        break;
      case 6:
        strokeWeight(map(mid, 0, (maxW + maxH) / 2, 0, 5));
        float cosinus = cos(radians(45));
        float sinus = sin(radians(45));
        line(x - mid / 2, y, x + mid / 2, y);
        line(x, y - mid / 2, x, y + mid / 2);
        line(x - mid / 2 * cosinus, y - mid / 2 * sinus, x + mid / 2 * cosinus, y + mid / 2 * sinus);
        line(x - mid / 2 * cosinus, y + mid / 2 * sinus, x + mid / 2 * cosinus, y - mid / 2 * sinus);
        noFill();
        strokeWeight(1);
        ellipse(x, y, mid / 4 * 3, mid / 4 * 3);
        ellipse(x, y, mid / 2, mid / 2);
        ellipse(x, y, mid / 4, mid / 4);
        break;
      default:
        form = new Integer(0);
        break;
    };
    noFill();
    return form;
  };

  void setColor(float r, float g, float b) {
    this.r = r;
    this.g = g;
    this.b = b;
  };

  void setSize(float size) {
    this.size = size;
  };

  float getX() {
    return x;
  };

  float getY() {
    return y;
  };

  float getZ() {
    return z;
  };

  float getSpeed() {
    return speed;
  };

  float getSize() {
    return size;
  };
};

ArrayList<RainDrop> drops = new ArrayList<RainDrop>();

void setup() {
  fullScreen();
  noCursor();
  frameRate(fps);

  conc = width * height / 10000;
};

void draw() {
  scale(zoom);
  custom();

  for(; count < conc / zoom; count++)
  {
    RainDrop drop = new RainDrop(random(0, (width - 1) / zoom), random(-maxZ / 10, maxZ), random(minW, maxW), random(minH, maxH));
    switch(rdColor)
    {
      case 0:
        drop.setColor(0, 0, 255);
        break;
      case 1:
        drop.setColor(random(0, 255), random(0, 255), random(0, 255));
        break;
      case 2:
        drop.setColor(0, 0, 0);
        break;
      case 3:
        drop.setColor(255, 255, 255);
        break;
      case 4:
      case 5:
      case 6:
      case 7:
      case 8:
        break;
      default:
        rdColor = 0;
        break;
    };
    drop.setSize(size);
    drops.add(drop);
  };

  for(Iterator<RainDrop> iter = drops.iterator(); iter.hasNext();)
  {
    RainDrop drop = iter.next();
    if(drop.getY() > (height - 1) / zoom || drop.getX() < 0 || drop.getX() > (width - 1) / zoom || drop.getZ() < minZ || drop.getZ() > maxZ)
    {
      iter.remove();
      count--;
    }
    tick();
    form = drop.show(form);
  };
};

void keyPressed() {
  if(key == 'B' || key == 'b')
    fone++;
  else if(key == 'M' || key == 'm')
    mode++;
  else if(key == 'C' || key == 'c')
    rdColor++;
  else if(key == 'F' || key == 'f')
    form++;
  else if(key == 'H' || key == 'h')
    change++;
};

void mousePressed() {
  if(mouseX <= width / 5 && mouseY <= height / 5
  || mouseX <= width / 5 && mouseY >= height - height / 5
  || mouseX >= width - width / 5 && mouseY <= height / 5
  || mouseX >= width - width / 5 && mouseY >= height - height / 5)
    framesLeft = frameCount;
};

void mouseReleased() {
  if(frameCount - framesLeft >= fps * seconds)
  {
    if(mouseX <= width / 5 && mouseY <= height / 5)
      fone++;
    else if(mouseX <= width / 5 && mouseY >= height - height / 5)
      mode++;
    else if(mouseX >= width - width / 5 && mouseY <= height / 5)
      rdColor++;
    else if(mouseX >= width - width / 5 && mouseY >= height - height / 5)
      form++;
  }
  framesLeft = 0;
};

void custom() {
  float a, b, c;

  switch(fone)
  {
    case 0:
      background(0);
      break;
    case 1:
      background(255);
      break;
    case 2:
      a = map(mouseX + mouseY, 0, width + height - 2, 0, 255);
      c = map(mouseX, 0, width - 1, 0, 255);
      b = map(mouseY, 0, height - 1, 0, 255);
      background(a, b, c);
      break;
    case 3:
      a = map(mouseX, 0, width - 1, 0, 255);
      c = map(mouseX + mouseY, 0, width + height - 2, 0, 255);
      b = map(mouseY, 0, height - 1, 0, 255);
      background(a, b, c);
      break;
    case 4:
      a = map(mouseY, 0, height - 1, 0, 255);
      c = map(mouseX, 0, width - 1, 0, 255);
      b = map(mouseX + mouseY, 0, width + height - 2, 0, 255);
      background(a, b, c);
      break;
    case 5:
      break;
    default:
      fone = 0;
      break;
  };

  switch(rdColor)
  {
    case 0:
    case 1:
    case 2:
    case 3:
      break;
    case 4:
      for(RainDrop drop : drops)
      {
        a = map(mouseX + mouseY, 0, width + height - 2, 0, 255);
        b = map(mouseX, 0, width - 1, 0, 255);
        c = map(mouseY, 0, height - 1, 0, 255);
        drop.setColor(a, b, c);
      }
      break;
    case 5:
      for(RainDrop drop : drops)
      {
        a = map(mouseX, 0, width - 1, 0, 255);
        b = map(mouseY, 0, height - 1, 0, 255);
        c = map(mouseX + mouseY, 0, width + height - 2, 0, 255);
        drop.setColor(a, b, c);
      }
      break;
    case 6:
      for(RainDrop drop : drops)
      {
        a = map(mouseX, 0, width - 1, 0, 255);
        b = map(mouseX + mouseY, 0, width + height - 2, 0, 255);
        c = map(mouseY, 0, height - 1, 0, 255);
        drop.setColor(a, b, c);
      }
      break;
    case 7:
      for(RainDrop drop : drops)
      {
        a = map(drop.getX(), 0, (width - 1) / zoom, 0, 255);
        b = map(drop.getY(), 0, (height - 1) / zoom, 0, 255);
        c = map(drop.getZ(), minZ, maxZ, 0, 255);
        drop.setColor(a, b, c);
      }
      break;
    case 8:
      for(RainDrop drop : drops)
        drop.setColor(random(0, 255), random(0, 255), random(0, 255));
      break;
    default:
      rdColor = 0;
      break;
  };
};

void tick() {
  float a, b, c, speed;

  for(RainDrop drop : drops)
    switch(mode)
    {
      case 0:
        drop.go();
        break;
      case 1:
        a = random(-1, 1);
        b = random(-1, 2);
        c = random(-1, 1) / 10;
        drop.go(a, b, c);
        break;
      case 2:
        a = map(mouseX - width / 2, -width / 2, width - 1, -1, 1);
        b = map(mouseY, 0, width - 1, 0, 2);
        c = random(-1, 1) / 10;
        drop.go(a, b, c);
        break;
      case 3:
        a = map(mouseX - drop.getX(), 0, width - 1, 0, 1);
        b = map(mouseY - drop.getY(), 0, height - 1, 0, 2);
        c = map(drop.getZ(), minZ, maxZ, -1, 1) / 100;
        drop.go(a, b, c);
        break;
      case 4:
        speed = drop.getSpeed();
        c = drop.getZ();
        b = map(mouseY, 0, width - 1, speed, speed * 5);
        speed *= b * 5;
        a = map(c, minZ, maxZ, map(mouseX, 0, width - 1, -speed * 2, speed * 2), map(mouseX, width - 1, 0, -speed, speed));
        c = map(c, minZ, maxZ, -1, 1) / 100;
        drop.go(a, b, c);
        break;
      default:
        mode = 0;
        break;
    };
};

void mouseWheel(MouseEvent event) {
  float count = event.getCount();
  switch(change)
  {
    case 0:
      zoom += count * zoom / 50;
      if(zoom <= 0 || zoom >= 20)
        zoom = 1;
      break;
    case 1:
      size = size + count * size / 10;
      if(size <= 0 || size >= 100)
        size = 1;
      for(RainDrop drop : drops)
        drop.setSize(size);
      break;
    default:
      change = 0;
      break;
  };
};
