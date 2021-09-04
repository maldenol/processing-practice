float x, y, r;
float angle;

void setup() {
    fullScreen();
    frameRate(60);

    x = -width / 4;
    y = 0;
    r = width / 8;
    angle = 0;
}

void draw() {
    background(0);

    translate(width / 2, height / 2);

    stroke(255);
    noFill();
    strokeWeight(2);
    circle(x, y, 2 * r);
    line(x - r, y, x + r, y);
    line(x, y - r, x, y + r);
    line(x + r, y, x + 5 * r, y);
    line(x + r, y - r, x + r, y + r);

    float cosinus = cos(angle / 180 * PI), sinus = sin(angle / 180 * PI);
    stroke(0, 0, 255);
    line(x, y, x + r * cosinus, y + r * sinus);
    stroke(255, 0, 0);
    line(x + r * cosinus, y, x + r * cosinus, y + r * sinus);
    line(x + r * cosinus, y, x, y);
    stroke(0, 255, 0);
    line(x, y + r * sinus, x + r * cosinus, y + r * sinus);
    line(x, y + r * sinus, x, y);
    stroke(127, 0, 255);
    for(float i = 0; i <= x + 6 * r; i++) {
        circle(x + r + i, r * sin((angle - i) / 180 * PI), 2);
    }
    stroke(255, 255, 0);
    line(x + r * cosinus, y + r * sinus, x + r + 1, y + r * sinus);

    angle++;
    if(angle == 360)
        angle = 0;
}
