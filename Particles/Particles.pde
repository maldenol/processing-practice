final String author = "MalDenOl21112003";

import java.util.Iterator;
import static java.lang.Math.cbrt;

final int fps = 60;
final float grav = 1;
final float viscocity = 0.9999980665;
int userx, usery;
ArrayList<Particle> particles;
boolean gravity;

float antidensity;
float minMass, maxMass;
float minRad, maxRad;
float spell;
float buttonTime = 0;

class Particle {
  
  private float x, y;
  private float mass;
  private float rad;
  private float friction = 0.999999;
  private PVector vect;
  
  public Particle (float x, float y, float mass, float rad) {
    this.x = x;
    this.y = y;
    this.mass = mass;
    this.rad = rad;
  };
  
  public Particle (float x, float y, float mass) {
    this(x, y, mass, (float)cbrt(mass * antidensity * 3/4 / PI)); 
  };
  
  public float distance(float x, float y) {
    return sqrt(pow(x - this.x, 2) + pow(y - this.y, 2));
  };
  
  public float distance(float xa, float ya, float xb, float yb) {
    return sqrt(pow(xa - xb, 2) + pow(ya - yb, 2));
  };
  
  public float distance(Particle part) {
    return distance(part.getX(), part.getY());
  };
  
  public float distance(Particle a, Particle b) {
    return distance(a.getX(), a.getY(), b.getX(), b.getY());
  };
  
  public boolean detectCollision(Particle a, Particle b) {
    return distance(a, b) <= a.getRad() + b.getRad() && a != b;
  };
  
  public boolean detectCollision(Particle part) {
    return detectCollision(this, part);
  };
   
  public void raw_collide(Particle a, Particle b)
  {
    float massA = a.getMass();
    float massB = b.getMass();
    float energy = massA * sqrt(pow(a.getVector().x, 2) + pow(a.getVector().y, 2)) + massB * sqrt(pow(b.getVector().x, 2) + pow(b.getVector().y, 2));
    energy *= a.getFriction() * b.getFriction();
    if(energy <= 0)
      energy = map(distance(a, b), 0, a.getRad() + b.getRad(), 0, 1);
    float speedA = sqrt(energy * massB / pow(massA, 2));
    float speedB = sqrt(energy * massA / pow(massB, 2));
    
    PVector vectA = new PVector(a.getX() - b.getX(), a.getY() - b.getY());
    PVector vectB = new PVector(b.getX() - a.getX(), b.getY() - a.getY());
    
    /*
    PVector bVect = b.getVector();
    bVect.normalize();
    bVect.div(a.getRad());
    if(distance(a, b) < distance(a.getX(), a.getY(), b.getX() + bVect.x, b.getY() + bVect.y))
      vectA.mult(-1);
    PVector aVect = a.getVector();
    aVect.normalize();
    aVect.div(b.getRad());
    if(distance(a, b) < distance(b.getX(), b.getY(), a.getX() + aVect.x, a.getY() + aVect.y))
      vectB.mult(-1);
    */
    
    vectA.normalize();
    vectB.normalize();
    vectA.mult(speedA);
    vectB.mult(speedB);
    a.addVector(vectA);
    b.addVector(vectB);
  };
  
  public void collide(Particle a, Particle b) {
    if(detectCollision(a, b)) raw_collide(a, b);
  };
  
  public void collide(Particle part) {
    collide(this, part);
  };
  
  public void addVector(PVector vect) {
    this.vect.add(vect);
  };
  
  public void rub(float viscocity) {
    vect.mult(viscocity * friction);
  };
  
  public void go() {
    x += vect.x;
    y += vect.y;
  };
  
  public void go(float viscocity) {
    rub(viscocity);
    x += vect.x;
    y += vect.y;
  };
  
  public void show() {
    stroke(255);
    ellipse(x, y, rad * 2, rad * 2);
  };
  
  public void setX(float x) { this.x = x; };
  public void setY(float y) { this.y = y; };
  public void setPos(float x, float y) { this.setX(x); this.setY(y); };
  public void setMass(float mass) { this.mass = mass; };
  public void setVector(float x, float y) { this.vect = new PVector(x, y); };
  public void setFriction(float friction) { this.friction = friction; };
  public void setVector(PVector vect) { this.vect = vect; };
  
  public float getX() { return this.x; };
  public float getY() { return this.y; };
  public float getMass() { return this.mass; };
  public float getRad() { return this.rad; };
  public float getFriction() { return this.friction; };
  public PVector getVector() { return this.vect; };
};

void setup() {
  fullScreen();
  frameRate(fps);
  noCursor();
  
  particles = new ArrayList<Particle>();
  
  spell = width / 5;
  minMass = 10;
  maxMass = 350;
  antidensity = min(width, height) / 50;
};

void draw() {
  background(0);
  
  keyboard();
  
  int count = particles.size();
  for(int i = 0; i < count; i++)
    for(int j = i; j < count; j++)
      particles.get(i).collide(particles.get(j));
  
  for(Particle part : particles)
  {
    wall(part);
    if(gravity == true && part.getY() + part.getRad() + grav < height - 1)
      part.addVector(new PVector(0, grav));
    part.go(viscocity);
    part.show();
  }
  
  stroke(255);
  ellipse(mouseX, mouseY, 5, 5);
};

void wall(Particle part)
{
  float x = part.getX();
  float y = part.getY();
  float rad = part.getRad();
  if(x - rad <= 0 || x + rad > width)
  {
    part.setVector(-part.getVector().x * 0.7, part.getVector().y * 0.5);
    part.setX((x - rad <= 0) ? rad : width - 1 - rad);
  }
  if(!gravity && y - rad <= 0 || y + rad > height - 1)
  {
    part.setVector(part.getVector().x * 0.5, -part.getVector().y * 0.7);
    part.setY((y - rad <= 0) ? rad : height - 1 - rad);
    if(y + rad > height - 1 && abs(part.getVector().y) < grav)
      part.setVector(part.getVector().x, 0);
  }
};

void mousePressed() {
  userx = mouseX;
  usery = mouseY;
};

void mouseReleased() {
  switch(mouseButton)
  {
    case LEFT:
      float mass = random(minMass, maxMass);
      Particle newpart = new Particle(userx, usery, mass);
      PVector vect = new PVector(mouseX - userx, mouseY - usery);
      //vect.mult(0.1);
      newpart.setVector(vect);
      particles.add(newpart);
      break;
    case RIGHT:
      if(keyPressed && key == 'A')
        particles.clear();
      else
      {
        Iterator<Particle> iter = particles.iterator();
        while(iter.hasNext())
        {
          Particle delpart = iter.next();
          if(delpart.distance(mouseX, mouseY) <= delpart.getRad())
            iter.remove();
        }
      }
      break;
  }
};

void mouseDragged() {
  stroke(0, 255, 125);
  ellipse(userx, usery, 5, 5);
  line(userx, usery, mouseX, mouseY);
};

void keyboard() {
  if(keyPressed && frameCount - buttonTime >= 15)
  {
    switch(key)
    {
      case 'g':
      case 'G':
        buttonTime = frameCount;
        gravity = !gravity;
        break;
      case 'r':
      case 'R':
        for(Particle part : particles)
          if(gravity)
          {
            float x = mouseX;
            float dist = abs(part.getX() - x);
            dist = (dist >= spell) ? spell : dist;
            part.addVector(new PVector(0, -1000 / part.getMass() * map(dist, 0, spell, map(mouseY, height - 1, 0, 0, sqrt(maxMass / 250)), 0)));
          }
        break;
      case 'f':
      case 'F':
        for(Particle part : particles)
          if(gravity)
          {
            float x = mouseX;
            float dist = abs(part.getX() - x);
            dist = (dist >= spell) ? spell : dist;
            part.addVector(new PVector(0, +1000 / part.getMass() * map(dist, 0, spell, map(mouseY, 0, height - 1, 0, sqrt(maxMass / 250)), 0)));
          }
        break;
    }
  }
};
