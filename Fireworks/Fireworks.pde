import java.util.Iterator;
import java.lang.Math.*;

final int fps = 60;
ArrayList<Charge> charges;
float userX, userY;
float g = 0.1;

PImage last;

class Charge {
  private float x, y;
  private float mass;
  private float rad;
  private float glows = 1, exp = 10, force = 10;
  private float vectx = 0, vecty = 0;
  private float r = 255, g = 255, b = 255;

  public Charge(float x, float y, float mass) {
    this.x = x;
    this.y = y;
    this.mass = mass;
    this.rad = (float)Math.cbrt(3F / 4F / PI * this.mass);
  };

  public Charge(float x, float y) {
    this(x, y, 1);
  };

  public float distance(float xa, float ya, float xb, float yb) { return sqrt(pow(xb - xa, 2) + pow(yb - ya, 2)); };
  public float distance(float x, float y) { return distance(this.x, this.y, x, y); };
  public float distance(Charge part) { return distance(this.x, this.y, part.x, part.y); };

  public boolean detectCollision(float xa, float ya, float rada, float xb, float yb, float radb) { return distance(xa, ya, xb, yb) <= rada + radb; };
  public boolean detectCollision(float x, float y, float rad) { return detectCollision(this.x, this.y, this.rad, x, y, rad); };
  public boolean detectCollision(Charge part) { return detectCollision(this.x, this.y, this.rad, part.x, part.y, part.rad); };
  public boolean detectCollision(float xborder, float yborder) { return (x - rad < -xborder) || (x + rad > xborder) || (y - rad < -yborder) || (y + rad > yborder); };

  public ArrayList explode(Charge part) {
    if(!detectCollision(part)) return null;

    ArrayList<Charge> charges = new ArrayList<Charge>();

    if(glows > 0)
      for(int i = 0; i < exp; i++)
      {
        Charge particle = new Charge(this.x, this.y, this.mass / exp);
        particle.exp = this.exp;
        particle.glows = this.glows - 1;
        particle.force = this.force;
        particle.setColor(random(0, 255), random(0, 255), random(0, 255));
        particle.setVector(random(force / 2, force * 2) * cos(random(0, TWO_PI)), random(force / 2, force * 2) * sin(random(0, TWO_PI)));
        charges.add(particle);
      }

    return charges;
  };

  public ArrayList explode(float xborder, float yborder) {
    if(!detectCollision(xborder, yborder)) return null;

    ArrayList<Charge> charges = new ArrayList<Charge>();

    if(glows > 0)
      for(int i = 0; i < exp; i++)
      {
        Charge particle = new Charge(this.x, this.y, this.mass / exp);
        particle.exp = this.exp;
        particle.glows = this.glows - 1;
        particle.force = this.force;
        particle.setColor(random(0, 255), random(0, 255), random(0, 255));

        float a;
        if(x - rad < -xborder)
        {
          x = -xborder + rad;
          a = random(3 * HALF_PI, HALF_PI);
        }
        else if(x + rad > xborder)
        {
          x = xborder - rad;
          a = random(HALF_PI, 3 * HALF_PI);
        }
        else if(y - rad < -yborder)
        {
          y = -yborder + rad;
          a = random(PI, TWO_PI);
        }
        else
        {
          y = yborder - rad;
          a = random(0, PI);
        }

        float speed = random(force / 2, force * 2);

        particle.setVector(speed * cos(a), speed * sin(a));
        charges.add(particle);
      }

    return charges;
  };

  public void go() {
    x += vectx;
    y += vecty;
  };

  public void show() {
    stroke(r, g, b);
    fill(r, g, b);
    ellipse(x, y, rad * 2, rad * 2);
    noFill();
  };

  public void setX(float x) { this.x = x; };
  public void setY(float y) { this.y = y; };
  public void setPos(float x, float y) { this.x = x; this.y = y; };
  public void setMass(float mass) { this.mass = mass; this.rad = (float)Math.cbrt(3F / 4F / PI * this.mass); };
  public void setVector(float x, float y) { this.vectx = x; this.vecty = y; };
  public void addVector(float x, float y) { this.vectx += x; this.vecty += y; };
  public void setGlows(float glows) { this.glows = glows; };
  public void setExp(float exp) { this.exp = exp; };
  public void setForce(float force) { this.force = force; };
  public void setColor(float r, float g, float b) { this.r = r; this.g = g; this.b = b; };

  public float getX() { return x; };
  public float getY() { return y; };
  public float getMass() { return mass; };
  public float getRad() { return rad; };
  public float getVectX() { return vectx; };
  public float getVectY() { return vecty; };
  public float getGlows() { return glows; };
  public float getExp() { return exp; };
  public float getForce() { return force; };
};

void setup() {
  fullScreen();
  noCursor();
  frameRate(60);

  background(0);
  last = get();

  charges = new ArrayList<Charge>();
};

void draw() {
  tint(200);
  image(last, 0, 0);
  translate(width / 2, height / 2);

  ArrayList<Charge> toRemove = new ArrayList<Charge>();
  ArrayList<Charge> toAdd = new ArrayList<Charge>();

  for(Iterator<Charge> a = charges.iterator(); a.hasNext();)
  {
    toRemove.clear();
    toAdd.clear();
    boolean exit = false;
    ArrayList<Charge> retval = null;

    Charge particle = a.next();
    Charge part;

    for(Iterator<Charge> b = charges.iterator(); b.hasNext();)
    {
      part = b.next();
      if(part != particle)
        retval = particle.explode(part);
      if(retval != null)
      {
        exit = true;
        toRemove.add(part);
        for(Charge charge : retval)
        {
          charge.go();
          toAdd.add(charge);
        }
      }
    }
    retval = particle.explode(width / 2, height / 2);
    if(retval != null)
    {
      exit = true;
      for(Charge charge : retval)
        {
          charge.go();
          toAdd.add(charge);
        }
    }

    if(exit)
      toRemove.add(particle);
    else
    {
      particle.addVector(0, g);
      particle.go();
      particle.show();
    }
  };

  for(Charge charge : toRemove)
    for(Iterator<Charge> iter = charges.iterator(); iter.hasNext();)
      if(iter.next() == charge)
      {
        iter.remove();
        break;
      }
  for(Charge charge : toAdd)
    charges.add(charge);

  last = get();

  stroke(255);
  point(mouseX - width / 2, mouseY - height / 2);
};

void mousePressed() {
  userX = mouseX - width / 2;
  userY = mouseY - height / 2;
};

void mouseReleased() {
  Charge charge = new Charge(userX, userY, 10000);
  charge.setGlows(1);
  charge.setExp(25);
  charge.setColor(random(0, 255), random(0, 255), random(0, 255));
  float x = (mouseX - width / 2 - userX) / 50;
  float y = (mouseY - height / 2 - userY) / 50;
  charge.setVector(x, y);
  charges.add(charge);
};

void mouseDragged() {
  stroke(0, 255, 128);
  line(userX, userY, mouseX - width / 2, mouseY - height / 2);
};
