import static java.lang.Math.*;

final double gravConst = 6.6740831 * Math.pow(10, -25);
final float maxTemperature = 60000;

class Planet {
  private String name = "";
  
  private float x, y;
  private float mass;
  private float rad;
  private float r = 255, g = 255, b = 255;
  
  private float friction = 0.0001;
  private float density;
  
  private float temperature = 0;
  private float specificHeatCapacity = 1;
  private float producedHeat;
  
  private float aphelion, perihelion;
  private String master = "";
  
  private PVector vect = new PVector(0, 0);
  
  private boolean delete = false;
  
  private PImage texture;
  
  public Planet (float x, float y, float mass, float rad) {
    this.x = x;
    this.y = y;
    this.mass = mass;
    this.rad = rad;
    this.density = 3F / 4F / PI * mass / pow(rad, 3);
  };
  
  public Planet (Planet planet)
  {
    this.name = planet.name;
    this.x = planet.x;
    this.y = planet.y;
    this.mass = planet.mass;
    this.rad = planet.rad;
    this.r = planet.r;
    this.g = planet.g;
    this.b = planet.b;
    this.friction = planet.friction;
    this.density = planet.density;
    this.temperature = planet.temperature;
    this.specificHeatCapacity = planet.specificHeatCapacity;
    this.producedHeat = planet.producedHeat;
    this.aphelion = planet.aphelion;
    this.perihelion = planet.perihelion;
    this.master = planet.master;
    this.vect = planet.vect;
    this.delete = planet.delete;
    this.texture = planet.texture;
  };
  
  public float distance(float x, float y) {
    return sqrt(pow(x - this.x, 2) + pow(y - this.y, 2));
  };
  
  public float distance(float xa, float ya, float xb, float yb) {
    return sqrt(pow(xa - xb, 2) + pow(ya - yb, 2));
  };
  
  public float distance(Planet plan) {
    return distance(plan.getX(), plan.getY());
  };
  
  public float distance(Planet a, Planet b) {
    return distance(a.getX(), a.getY(), b.getX(), b.getY());
  };
  
  public boolean detectCollision(Planet a, Planet b) {
    return distance(a, b) <= a.getRad() + b.getRad() && a != b;
  };
  
  public boolean detectCollision(Planet plan) {
    return detectCollision(this, plan);
  };
  
  public void absorb(Planet plan) {
    PVector result = new PVector(vect.x, vect.y);
    result.sub(plan.getVector());
    float energy = plan.getMass() * (result.x * result.x + result.y * result.y) / 2;
    
    addTemperature(energy * (1 - friction) / (mass * specificHeatCapacity));
    this.addMass(plan.getMass());
    
    PVector vect = new PVector(this.x - plan.getX(), this.y - plan.getY());
    
    PVector planVect = plan.getVector();
    planVect.normalize();
    planVect.div(rad);
    if(distance(this, plan) < distance(x, y, plan.getX() + planVect.x, plan.getY() + planVect.y))
      vect.mult(-1);
    
    vect.normalize();
    vect.mult(energy * friction / mass);
    this.addVector(vect);
    
    plan.delete();
  };
  
  public void collide(Planet a, Planet b) {
    if(detectCollision(a, b))
    {
      if(a.mass > b.mass)
        a.absorb(b);
      else
        b.absorb(a);
    }
  };
  
  public void collide(Planet plan) {
    collide(this, plan);
  };
  
  public float gravityForce(Planet a, Planet b) {
    float dist = distance(a, b);
    if((int)dist == 0) return 0;
    dist *= dist;
    return (float)gravConst * a.mass * b.mass / dist;
  };
  
  public float gravityForce(Planet plan) {
    return gravityForce(this, plan);
  };
  
  public void gravity(Planet plan) {
    float dist = this.distance(plan);
    if((int)dist == 0) return;
    dist *= dist;
    
    PVector vect = new PVector(plan.x - this.x, plan.y - this.y);
    vect.normalize();
    vect.mult((float)gravConst * plan.mass / dist);
    this.addVector(vect);
  };
  
  public void addVector(PVector vect) {
    this.vect.add(vect);
  };
  
  public void addMass(float mass) {
    this.mass += mass;
    this.rad = (float)Math.cbrt(3F / 4F / PI * this.mass / density);
  };
  
  public void addTemperature(float temper) {
    temperature += temper;
    if(temperature >= 2000)
    {
      if(temperature >= 60000) { r = 127; g = 170; b = 255; }
      else
      {
        if(temperature <= 3500) { r = 255; g = 0; b = 0; }
        else if(temperature <= 5000) { r = 255; g = 128; b = 0; }
        else if(temperature <= 6000) { r = 255; g = 255; b = 0; }
        else if(temperature <= 7500) { r = 255; g = 245; b = 230; }
        else if(temperature <= 10000) { r = 255; g = 255; b = 255; }
        else if(temperature <= 30000) { r = 200; g = 215; b = 255; }
        else if(temperature <= 60000) { r = 150; g = 170; b = 255; }
      }
    }
    else { r = 255; g = 255; b = 255; }
  };
  
  public void move() {
    x += vect.x;
    y += vect.y;
  };
  
  public void show() {
    tint(r, g, b);
    image(texture, x - rad, y - rad, rad * 2, rad * 2);
  };
  
  public void mark(float zoom) {
    stroke(r, g, b);
    fill(r, g, b);
    ellipse(x, y, 5 / zoom, 5 / zoom);
  };
  
  public float getSpeed() {
    return sqrt(vect.x * vect.x + vect.y * vect.y);
  };
  
  public void setName(String name) { this.name = name; };
  public void setX(float x) { this.x = x; };
  public void setY(float y) { this.y = y; };
  public void setPos(float x, float y) { this.setX(x); this.setY(y); };
  public void setMass(float mass) { this.mass = 0; addMass(mass); };
  public void setRad(float rad) { this.rad = rad; this.density = 3F / 4F / PI * mass / pow(rad, 3); };
  public void setFriction(float friction) { this.friction = friction; };
  public void setDensity(float density) { this.density = density; this.rad = (float)Math.cbrt(3F / 4F / PI * this.mass / density); };
  public void setAphelion(float aphelion) { this.aphelion = aphelion; };
  public void setPerihelion(float perihelion) { this.perihelion = perihelion; };
  public void setVector(float x, float y) { this.vect = new PVector(x, y); };
  public void setVector(PVector vect) { this.vect = vect; };
  public void setTemperature(float temperature) { this.temperature = 0; addTemperature(temperature); };
  public void setSpecificHeatCapacity(float specificHeatCapacity) { this.specificHeatCapacity = specificHeatCapacity; };
  public void setTexture(PImage texture) { this.texture = texture.copy(); };
  public void setMaster(String master) { this.master = master; };
  
  public String getName() { return this.name; };
  public float getX() { return this.x; };
  public float getY() { return this.y; };
  public float getMass() { return this.mass; };
  public float getRad() { return this.rad; };
  public float getFriction() { return this.friction; };
  public float getDensity() { return this.density; };
  public float getAphelion() { return this.aphelion; };
  public float getPerihelion() { return this.perihelion; };
  public PVector getVector() { return this.vect; };
  public float getTemperature() { return this.temperature; };
  public float getSpecificHeatCapacity() { return this.specificHeatCapacity; };
  public PImage getTexture() { return this.texture; };
  public String getMaster() { return this.master; };
  
  public void delete() { this.delete = true; };
  public boolean isDelete() { return this.delete; };
};
