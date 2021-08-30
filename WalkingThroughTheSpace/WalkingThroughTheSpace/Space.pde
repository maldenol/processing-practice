import java.util.Iterator;

class Space {
  private ArrayList<Planet> planets = new ArrayList<Planet>();
  private ArrayList<Planet> planetDB = new ArrayList<Planet>();
  
  public Space(String datafile) {
    XML database;
    database = loadXML(datafile + ".xml");
    XML[] children = database.getChildren("planet");
    int len = children.length;
    for (int i = 0; i < len; i++)
    {
      String name = children[i].getContent();
      float mass = children[i].getFloat("mass");
      float rad = children[i].getFloat("rad") / (float)Math.pow(10, 6);
      float temperature = children[i].getFloat("tempature");
      float aphelion = children[i].getFloat("aphelion") / (float)Math.pow(10, 7);
      float perihelion = children[i].getFloat("perihelion") / (float)Math.pow(10, 7);
      String master = children[i].getString("master");
      PImage texture = loadImage("textures/" + name.toLowerCase() + ".png");
      Planet planet = new Planet(0, 0, mass, rad);
      planet.setName(name);
      planet.setTemperature(temperature);
      planet.setAphelion(aphelion);
      planet.setPerihelion(perihelion);
      planet.setTexture(texture);
      planet.setMaster(master);
      planetDB.add(planet);
    }
  };
  
  public void generate() {
    int len = planetDB.size();
    planets.add(new Planet(planetDB.get(len - 1)));
    for(int i = 0; i < len - 1; i++)
    {
      Planet plan = new Planet(planetDB.get(i));
      
      Planet master = new Planet(0, 0, 1, 1);
      for(Planet p : planets)
        if(p.getName().equals(plan.getMaster()))
          master = new Planet(p);
      
      float angle = random(0, TWO_PI);
      float r = plan.getAphelion();
      float x = master.getX() + r * cos(angle), y = master.getY() + r * sin(angle);
      plan.setPos(x, y);
      
      PVector go;
      go = new PVector(-1, (master.getX() - x) / (master.getY() - y));
      go.normalize();
      double startSpeed = Math.sqrt(gravConst * master.getMass() / r * (1 + plan.getPerihelion() / r));
      go.mult((float)startSpeed);
      plan.setVector(go);
      plan.addVector(master.getVector());
      
      planets.add(plan);
    }
  };
  
  void tick() {
    Iterator<Planet> iter = planets.iterator();
    while(iter.hasNext() == true)
    {
      Planet a = iter.next();
      a.move();
      if(a.isDelete())
        iter.remove();
      else
      {
        String master = null;
        float minHelion = 0, helion = 0;
        
        for(Planet b : planets)
        {
          a.collide(b);
          a.gravity(b);
          b.gravity(a);
          
          helion = a.distance(b);
          if(helion < minHelion && !a.getMaster().equals("null"))
          {
            minHelion = helion;
            master = b.getName();
          }
        }
        
        if(master != null && !master.equals(a.getMaster()))
        {
          a.setMaster(master);
          a.setPerihelion(minHelion);
          a.setAphelion(minHelion);
        }
      }
    }
  };
  
  void show() {
    for(Planet planet : planets)
      planet.show();
  };
  
  void mark(float zoom) {
    for(Planet planet : planets)
      planet.mark(zoom);
  };
  
  void orbit(float zoom) {
    strokeWeight(1 / zoom);
    noFill();
    for(Planet planet : planets)
    {
      Planet master = null;
      for(Planet mast : planets)
        if(mast.getName().equals(planet.getMaster()))
          master = mast;
      if(master == null) continue;
      
      float dist = planet.distance(master);
      float ah = planet.getAphelion(), ph = planet.getPerihelion();
      float speed = planet.getSpeed(), maXspeed = 100;
      float r = map(dist, ph, ah, 255, 0);
      float g = map(dist, ph, ah, 0, 255);
      float b = map((speed > maXspeed) ? maXspeed : speed, 0, maXspeed, 0, 255);
      
      stroke(r, g, b);
      if(planet.distance(planet.getX(), planet.getY(), master.getX(), master.getY()) >= 1 / zoom)
      {
        line(planet.getX(), planet.getY(), master.getX(), master.getY());
        ellipse(master.getX(), master.getY(), dist * 2, dist * 2);
      }
    }
    strokeWeight(1);
  };
  
  void addPlanet(Planet plan) { planets.add(plan); };
  
  public ArrayList<Planet> getPlanets() { return this.planets; };
  public ArrayList<Planet> getPlanetDatabase() { return this.planetDB; };
};
