// It is used Bernstern Polynomial Form here, the extension of De Casteljau's Algorithm.

PVector point1, point2, point3, point4;


void setup() {
    fullScreen();
}

void draw() {
    background(0);

    drawPoints();

    drawCurve();
}


void mouseClicked() {
    makePoint();
}


void makePoint() {
    if (point1 == null) {
        point1 = new PVector(mouseX, mouseY);
    } else if (point2 == null) {
        point2 = new PVector(mouseX, mouseY);
    } else if (point3 == null) {
        point3 = new PVector(mouseX, mouseY);
    } else if (point4 == null) {
        point4 = new PVector(mouseX, mouseY);
    }
}

void drawPoints() {
    if (point1 != null) {
        stroke(255, 0, 0);
        fill(255, 0, 0);
        circle(point1.x, point1.y, 15);
        noFill();
    }

    if (point2 != null) {
        stroke(0, 0, 255);
        fill(0, 0, 255);
        circle(point2.x, point2.y, 15);
        noFill();
    }

    if (point3 != null) {
        stroke(255, 255, 0);
        fill(255, 255, 0);
        circle(point3.x, point3.y, 15);
        noFill();
    }

    if (point4 != null) {
        stroke(0, 255, 0);
        fill(0, 255, 0);
        circle(point4.x, point4.y, 15);
        noFill();
    }
}

void drawCurvePoint(float time) {
    PVector curvePoint = new PVector(0, 0);
    PVector curvePoint1 = new PVector(point1.x, point1.y);
    PVector curvePoint2 = new PVector(point2.x, point2.y);
    PVector curvePoint3 = new PVector(point3.x, point3.y);
    PVector curvePoint4 = new PVector(point4.x, point4.y);

    curvePoint1.mult(-time*time*time + 3*time*time - 3*time + 1);
    curvePoint.add(curvePoint1);
    curvePoint2.mult(3*time*time*time - 6*time*time + 3*time);
    curvePoint.add(curvePoint2);
    curvePoint3.mult(-3*time*time*time + 3*time*time);
    curvePoint.add(curvePoint3);
    curvePoint4.mult(time*time*time);
    curvePoint.add(curvePoint4);

    stroke(255);
    fill(255);
    circle(curvePoint.x, curvePoint.y, 3);
    noFill();
}

void drawCurve() {
    if (point1 != null && point2 != null && point3 != null && point4 != null) {
        for (float t = 0; t < 1; t += 0.001) {
            drawCurvePoint(t);
        }
    }
}
