static int FPS = 60;


FireflyController fc;


void setup() {
    fullScreen();
    frameRate(FPS);
    noCursor();

    fc = new FireflyController(100);
}

void draw() {
    background(0);

    fc.tick();
    fc.render();
}


void keyPressed() {
    if(key != CODED && key == ' ') {
        fc.toggleSynchronization();
    }
}
