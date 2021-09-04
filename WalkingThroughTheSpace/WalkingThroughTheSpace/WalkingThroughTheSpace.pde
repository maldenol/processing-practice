int fps = 60;
float zoom = 0.05;
float seconds = 0.35;

boolean marked = false, orbit = false, pause = true, inter = true;

int timePress = 0;

float viewX = 0, viewY = 0;
float userX = 0, userY = 0;

Space world;

boolean first = true;

int dbindex = 0;

void setup()
{
  fullScreen(JAVA2D);
  frameRate(fps);
  noCursor();
  
  world = new Space("planets");
  world.generate();
  
  background(0);
};

void draw()
{
  background(0);
  
  translate(width / 2 - viewX, height / 2 - viewY);
  scale(zoom);
  
  if(!pause)
    world.tick();
  if(!marked)
    world.show();
  else
    world.mark(zoom);
  if(orbit)
    world.orbit(zoom);
  
  graphicface();
  keyboard();
};

void keyboard()
{
  if(!keyPressed) return;
  
  if(key == 'z')
  {
    zoom *= 1.05;
    viewX *= 1.05;
    viewY *= 1.05;
  }
  if(key == 'x')
  {
    zoom *= 0.95;
    viewX *= 0.95;
    viewY *= 0.95;
  }
  if(key == 'c')
  {
    viewX = 0;
    viewY = 0;
  }
  if((key == 'm' || key == 'M') && frameCount - timePress >= fps * seconds)
  {
    marked = !marked;
    timePress = frameCount;
  }
  if((key == 'p' || key == 'P') && frameCount - timePress >= fps * seconds)
  {
    pause = !pause;
    timePress = frameCount;
  }
  if((key == 'o' || key == 'O') && frameCount - timePress >= fps * seconds)
  {
    orbit = !orbit;
    timePress = frameCount;
  }
  if((key == 'i' || key == 'I') && frameCount - timePress >= fps * seconds)
  {
    inter = !inter;
    timePress = frameCount;
  }
  if(key == 'w')
    viewY -= width / 100;
  if(key == 'a')
    viewX -= width / 100;
  if(key == 's')
    viewY += width / 100;
  if(key == 'd')
    viewX += width / 100;
  if(key == '+' && frameCount - timePress >= fps * seconds)
  {
    dbindex = (dbindex + 1) % world.getPlanetDatabase().size();
    timePress = frameCount;
  }
  if(key == '-' && frameCount - timePress >= fps * seconds)
  {
    dbindex = (dbindex + world.getPlanetDatabase().size() - 1) % world.getPlanetDatabase().size();
    timePress = frameCount;
  }
};

void graphicface() {
  scale(1 / zoom);
  translate(- width / 2, - height / 2);
  
  if(inter)
  {
    float size = width / 50;
    textSize(size);
    int fpsdisp = (int)frameRate;
    int x = (int)viewX;
    int y = (int)viewY;
    String viewMode;
    int planetsCount = world.getPlanets().size();
    
    if(fpsdisp >= 55)
      fill(0, 255, 0);
    else if(fpsdisp >= 40)
      fill(0, 0, 255);
    else if(fpsdisp >= 30)
      fill(255, 255, 0);
    else
      fill(255, 0, 0);
    if(marked)
      viewMode = "marked";
    else
      viewMode = "textured";
    
    text(fpsdisp, width - textWidth(String.valueOf(fpsdisp)) + viewX, size + viewY);
    fill(255);
    
    text(x, width - textWidth(String.valueOf(x)) + viewX, size * 2 + viewY);
    text(y, width - textWidth(String.valueOf(y)) + viewX, size * 3 + viewY);
    text(String.valueOf(zoom), width - textWidth(String.valueOf(zoom)) + viewX, size * 4 + viewY);
    text(viewMode, width - textWidth(viewMode) + viewX, size * 5 + viewY);
    if(pause) text("PAUSED", width - textWidth("PAUSED") + viewX, size * 6 + viewY);
    text(String.valueOf(planetsCount), width - textWidth(String.valueOf(planetsCount)) + viewX, size * 7 + viewY);
    
    Planet plan = new Planet(world.getPlanetDatabase().get(dbindex));
    text(plan.getName(), viewX, size + viewY);
    text(String.valueOf(dbindex + 1), viewX, size * 2 + viewY);
    text(String.valueOf(plan.getMass()), viewX, size * 3 + viewY);
    text(String.valueOf(plan.getRad()), viewX, size * 4 + viewY);
    text(String.valueOf(plan.getAphelion()), viewX, size * 5 + viewY);
    text(String.valueOf(plan.getPerihelion()), viewX, size * 6 + viewY);
    text(String.valueOf(plan.getMaster()), viewX, size * 7 + viewY);
    if(!marked) image(plan.getTexture(), viewX, size * 8 + viewY, 50, 50);
  }
  
  if(mousePressed)
  {
    stroke(0, 0, 255);
    fill(0, 0, 255);
    ellipse(userX, userY, 4, 4);
    stroke(0, 255, 0);
    line(userX, userY, mouseX + viewX, mouseY + viewY);
    stroke(255);
    fill(255);
    ellipse(mouseX + viewX, mouseY + viewY, 4, 4);
  }
  else
  {
    stroke(255);
    fill(255);
    ellipse(mouseX + viewX, mouseY + viewY, 2, 8);
    ellipse(mouseX + viewX, mouseY + viewY, 8, 2);
  }
};

void mousePressed()
{
  userX = mouseX + viewX;
  userY = mouseY + viewY;
};

void mouseReleased()
{
  if(first) { first = false; return; };
  
  if(mouseButton == RIGHT)
  {
    for(Planet planet : world.getPlanets())
      if(planet.distance((userX - width / 2) / zoom, (userY - height / 2) / zoom) <= planet.getRad()) { planet.delete(); break; }
  }
  else if(mouseButton == LEFT)
  {
    PVector vect = new PVector(mouseX + viewX - userX, mouseY + viewY - userY);
    Planet plan = new Planet(world.getPlanetDatabase().get(dbindex));
    plan.setPos((userX - width / 2) / zoom, (userY - height / 2) / zoom);
    plan.setVector(vect);
    
    Planet master = null;
    for(Planet mast : world.getPlanets())
      if(plan.getMaster().equals(mast.getName())) { master = mast; break; }
    if(master != null)
    {
      plan.setAphelion(plan.distance(master));
      plan.setPerihelion(plan.distance(master));
    }
    
    world.addPlanet(plan);
  }
};
