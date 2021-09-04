float x0, y0, x1, y1, x2, y2;
float vx0, vy0, vx1, vy1, vx2, vy2;


void setup() {
    fullScreen();
    frameRate(60);
    noCursor();


    x0 = width / 2;
    y0 = height / 4 * 2;
    x1 = width / 2;
    y1 = height / 4 * 3;
    x2 = width / 2;
    y2 = height / 4 * 1;
    vx0 = 0;
    vy0 = 0;
    vx1 = 0;
    vy1 = 0;
    vx2 = -10;
    vy2 = 0;
}

void draw() {
    vx1 = mouseX - pmouseX;
    vy1 = mouseY - pmouseY;

    x0 += vx0;
    y0 += vy0;
    x1 = mouseX;
    y1 = mouseY;
    x2 += vx2;
    y2 += vy2;


    if(x0 < 25) {
        x0 = 25;
        vx0 = -vx0;
    } else if(x0 > width - 26) {
        x0 = width - 26;
        vx0 = -vx0;
    }
    if(y0 < 25) {
        y0 = 25;
        vy0 = -vy0;
    } else if(y0 > height - 26) {
        y0 = height - 26;
        vy0 = -vy0;
    }
    if(x1 < 25) {
        x1 = 25;
    } else if(x1 > width - 26) {
        x1 = width - 26;
    }
    if(y1 < 25) {
        y1 = 25;
    } else if(y1 > height - 26) {
        y1 = height - 26;
    }
    if(x2 < 25) {
        x2 = 25;
        vx2 = -vx2;
    } else if(x2 > width - 26) {
        x2 = width - 26;
        vx2 = -vx2;
    }
    if(y2 < 25) {
        y2 = 25;
        vy2 = -vy0;
    } else if(y2 > height - 26) {
        y2 = height - 26;
        vy2 = -vy0;
    }

    if(abs(x1 - x0) < 50 && abs(y1 - y0) < 50) {
        float speed = sqrt(vx0 * vx0 + vy0 * vy0);
        vx0 = x0 - x1;
        vy0 = y0 - y1;
        float normal = sqrt(vx0 * vx0 + vy0 * vy0);
        vx0 = vx0 / normal * speed;
        vy0 = vy0 / normal * speed;
        vx0 += vx1;
        vy0 += vy1;
    }
    if(abs(x2 - x0) < 50 && abs(y2 - y0) < 50) {
        float speed = sqrt(vx0 * vx0 + vy0 * vy0);
        vx0 = x0 - x2;
        vy0 = y0 - y2;
        float normal = sqrt(vx0 * vx0 + vy0 * vy0);
        vx0 = vx0 / normal * speed;
        vy0 = vy0 / normal * speed;
        vx0 += vx2;
        vy0 += vy2;
    }


    background(0);

    stroke(255);
    strokeWeight(5);
    fill(0);
    circle(x0, y0, 50);
    noFill();
    fill(255, 0, 0);
    circle(x1, y1, 50);
    noFill();
    fill(0, 0, 255);
    circle(x2, y2, 50);
    noFill();

    strokeWeight(1);
    rectMode(CORNERS);
    stroke(255, 0, 0);
    fill(255, 0, 0);
    rect(width / 4, 0, width / 4 * 3, 10);
    noFill();
    stroke(0, 0, 255);
    fill(0, 0, 255);
    rect(width / 4, height - 11, width / 4 * 3, height - 1);
    noFill();
}
