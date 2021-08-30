float a, speed, l1, l2, w3, d, h;

void setup() {
    fullScreen();
    
    a = 0;
    speed = 1E-2;
    l1 = 50;
    l2 = 150;
    w3 = 100;
    d = 5;
    h = 10;
}

void draw() {
    background(0);
    translate(width / 2, height / 2 + l2 / 2);
    
    float x1 = l1 * cos(a * 180 / PI), y1 = l1 * sin(a * 180 / PI);
    float y2 = y1 - sqrt(l2 * l2 - x1 * x1);
    float xl = -w3 / 2, xr = w3 / 2, yb = -(l2 - l1), yt = -(l2 + l1 + h);
    
    strokeWeight(d);
    stroke(255);
    line(0, 0, x1, y1); //lever 1
    line(x1, y1, 0, y2); //lever 2
    line(xl, y2, xr, y2); //bottom
    line(xl, yt, xr, yt); //top
    line(xl, yb, xl, yt); //left
    line(xr, yb, xr, yt); //right
    
    float red, blue;
    if(x1 < 0)
        red = map(y2, yt + h * 4, yt + h * 2, 0, 255);
    else
        red = map(y2, yb - h * 4, yb, 255, 0);
    blue = 255 - red;
    
    strokeWeight(1);
    stroke(red, 0, blue);
    fill(red, 0, blue);
    rectMode(CORNERS);
    if(yt + d / 2 <= y2 - d / 2)
        rect(xl + d / 2, yt + d / 2, xr - d / 2, y2 - d / 2);
    noFill();
    
    a = (a + map(mouseX, 0, width, 0, speed)) % 360;
}
