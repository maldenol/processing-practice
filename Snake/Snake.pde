float x, y;
PImage tail;


void setup() {
    fullScreen();
    noCursor();
    frameRate(60);

    x = width / 2;
    y = height / 2;

    background(0);
    tail = get();
}

void draw() {
    x += (mouseX - x) / 100;
    y += (mouseY - y) / 100;


    background(0);

    tint(255, 240);
    image(tail, 0, 0);
    noTint();

    stroke(255);
    strokeWeight(1);
    fill(255);
    circle(x, y, 10);
    noFill();

    stroke(255);
    strokeWeight(10);
    noFill();
    rect(0, 0, width, height);

    tail = get();
}
