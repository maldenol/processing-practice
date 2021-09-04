import java.awt.Robot;
import java.awt.AWTException;


final int FPS = 60;
final float HALF_WIDTH = width / 2, HALF_HEIGHT = height / 2;
final float angleSpeed = TWO_PI / FPS * 3E-1;
final float mult = 100;

float forwardX, forwardY, forwardZ, upX, upY, upZ, rightX, rightY, rightZ;


void setup() {
    fullScreen(P3D);
    noCursor();
    frameRate(FPS);

    forwardX = forwardY = 0;
    forwardZ = 1;
    upX = upZ = 0;
    upY = 1;
    rightX = 1;
    rightY = rightZ = 0;

    try {
        Robot mouse = new Robot();
        mouse.mouseMove((int)HALF_WIDTH, (int)HALF_HEIGHT);
    } catch(AWTException e) {}
}

void draw() {
    background(0);
    camera();
    translate(width / 2, height / 2);

    strokeWeight(2);
    stroke(255, 0, 0);
    line(0, 0, 2 * mult, forwardX * mult, forwardY * mult, forwardZ * mult);
    stroke(0, 255, 0);
    line(0, 0, 2 * mult, rightX * mult, rightY * mult, rightZ * mult);
    stroke(0, 0, 255);
    line(0, 0, 2 * mult, upX * mult, upY * mult, upZ * mult);

    float[] quaternion;
    PVector vector;
    float angleSpeed = TWO_PI / 60 * 3E-1;

    if(mouseX != pmouseX || mouseY != pmouseY) {
        if(mouseX != pmouseX) { // rotate left or right
            quaternion = rotateOnQuaternion(forwardX, forwardY, forwardZ, upX, upY, upZ, map(mouseX - HALF_WIDTH, -HALF_WIDTH, HALF_WIDTH, angleSpeed, -angleSpeed) * 10);
            vector = new PVector(quaternion[0], quaternion[1], quaternion[2]);
            vector.normalize();
            forwardX = vector.x;
            forwardY = vector.y;
            forwardZ = vector.z;

            quaternion = this.vectorProduct(this.upX, this.upY, this.upZ, this.forwardX, this.forwardY, this.forwardZ);
            vector = new PVector(quaternion[0], quaternion[1], quaternion[2]);
            vector.normalize();
            this.rightX = vector.x;
            this.rightY = vector.y;
            this.rightZ = vector.z;

            quaternion = this.vectorProduct(this.rightX, this.rightY, this.rightZ, this.upX, this.upY, this.upZ);
            vector = new PVector(quaternion[0], quaternion[1], quaternion[2]);
            vector.normalize();
            this.forwardX = vector.x;
            this.forwardY = vector.y;
            this.forwardZ = vector.z;
        }

        if(mouseY != pmouseY) { // rotate up or down
            quaternion = rotateOnQuaternion(forwardX, forwardY, forwardZ, rightX, rightY, rightZ, map(mouseY - HALF_HEIGHT, -HALF_HEIGHT, HALF_HEIGHT, angleSpeed, -angleSpeed) * 10);
            vector = new PVector(quaternion[0], quaternion[1], quaternion[2]);
            vector.normalize();
            forwardX = vector.x;
            forwardY = vector.y;
            forwardZ = vector.z;

            quaternion = this.vectorProduct(this.forwardX, this.forwardY, this.forwardZ, this.rightX, this.rightY, this.rightZ);
            vector = new PVector(quaternion[0], quaternion[1], quaternion[2]);
            vector.normalize();
            this.upX = vector.x;
            this.upY = vector.y;
            this.upZ = vector.z;

            quaternion = this.vectorProduct(this.rightX, this.rightY, this.rightZ, this.upX, this.upY, this.upZ);
            vector = new PVector(quaternion[0], quaternion[1], quaternion[2]);
            vector.normalize();
            this.forwardX = vector.x;
            this.forwardY = vector.y;
            this.forwardZ = vector.z;
        }

        try {
            Robot mouse = new Robot();
            mouse.mouseMove((int)HALF_WIDTH, (int)HALF_HEIGHT);
        } catch(AWTException e) {}
    }

    if(keyPressed) {
        if(key == 'a') {
            quaternion = rotateOnQuaternion(forwardX, forwardY, forwardZ, upX, upY, upZ, angleSpeed);
            vector = new PVector(quaternion[0], quaternion[1], quaternion[2]);
            vector.normalize();
            forwardX = vector.x;
            forwardY = vector.y;
            forwardZ = vector.z;

            quaternion = this.vectorProduct(this.upX, this.upY, this.upZ, this.forwardX, this.forwardY, this.forwardZ);
            vector = new PVector(quaternion[0], quaternion[1], quaternion[2]);
            vector.normalize();
            this.rightX = vector.x;
            this.rightY = vector.y;
            this.rightZ = vector.z;

            quaternion = this.vectorProduct(this.rightX, this.rightY, this.rightZ, this.upX, this.upY, this.upZ);
            vector = new PVector(quaternion[0], quaternion[1], quaternion[2]);
            vector.normalize();
            this.forwardX = vector.x;
            this.forwardY = vector.y;
            this.forwardZ = vector.z;
        }
        if(key == 'd') {
            quaternion = rotateOnQuaternion(forwardX, forwardY, forwardZ, upX, upY, upZ, -angleSpeed);
            vector = new PVector(quaternion[0], quaternion[1], quaternion[2]);
            vector.normalize();
            forwardX = vector.x;
            forwardY = vector.y;
            forwardZ = vector.z;

            quaternion = this.vectorProduct(this.upX, this.upY, this.upZ, this.forwardX, this.forwardY, this.forwardZ);
            vector = new PVector(quaternion[0], quaternion[1], quaternion[2]);
            vector.normalize();
            this.rightX = vector.x;
            this.rightY = vector.y;
            this.rightZ = vector.z;

            quaternion = this.vectorProduct(this.rightX, this.rightY, this.rightZ, this.upX, this.upY, this.upZ);
            vector = new PVector(quaternion[0], quaternion[1], quaternion[2]);
            vector.normalize();
            this.forwardX = vector.x;
            this.forwardY = vector.y;
            this.forwardZ = vector.z;
        }
        if(key == 'w') {
            quaternion = rotateOnQuaternion(forwardX, forwardY, forwardZ, rightX, rightY, rightZ, angleSpeed);
            vector = new PVector(quaternion[0], quaternion[1], quaternion[2]);
            vector.normalize();
            forwardX = vector.x;
            forwardY = vector.y;
            forwardZ = vector.z;

            quaternion = this.vectorProduct(this.forwardX, this.forwardY, this.forwardZ, this.rightX, this.rightY, this.rightZ);
            vector = new PVector(quaternion[0], quaternion[1], quaternion[2]);
            vector.normalize();
            this.upX = vector.x;
            this.upY = vector.y;
            this.upZ = vector.z;

            quaternion = this.vectorProduct(this.rightX, this.rightY, this.rightZ, this.upX, this.upY, this.upZ);
            vector = new PVector(quaternion[0], quaternion[1], quaternion[2]);
            vector.normalize();
            this.forwardX = vector.x;
            this.forwardY = vector.y;
            this.forwardZ = vector.z;
        }
        if(key == 's') {
            quaternion = rotateOnQuaternion(forwardX, forwardY, forwardZ, rightX, rightY, rightZ, -angleSpeed);
            vector = new PVector(quaternion[0], quaternion[1], quaternion[2]);
            vector.normalize();
            forwardX = vector.x;
            forwardY = vector.y;
            forwardZ = vector.z;

            quaternion = this.vectorProduct(this.forwardX, this.forwardY, this.forwardZ, this.rightX, this.rightY, this.rightZ);
            vector = new PVector(quaternion[0], quaternion[1], quaternion[2]);
            vector.normalize();
            this.upX = vector.x;
            this.upY = vector.y;
            this.upZ = vector.z;

            quaternion = this.vectorProduct(this.rightX, this.rightY, this.rightZ, this.upX, this.upY, this.upZ);
            vector = new PVector(quaternion[0], quaternion[1], quaternion[2]);
            vector.normalize();
            this.forwardX = vector.x;
            this.forwardY = vector.y;
            this.forwardZ = vector.z;
        }
        if(key == 'q') { // spin left
            quaternion = rotateOnQuaternion(upX, upY, upZ, forwardX, forwardY, forwardZ, angleSpeed);
            vector = new PVector(quaternion[0], quaternion[1], quaternion[2]);
            vector.normalize();
            upX = vector.x;
            upY = vector.y;
            upZ = vector.z;

            quaternion = this.vectorProduct(this.upX, this.upY, this.upZ, this.forwardX, this.forwardY, this.forwardZ);
            vector = new PVector(quaternion[0], quaternion[1], quaternion[2]);
            vector.normalize();
            this.rightX = vector.x;
            this.rightY = vector.y;
            this.rightZ = vector.z;

            quaternion = this.vectorProduct(this.forwardX, this.forwardY, this.forwardZ, this.rightX, this.rightY, this.rightZ);
            vector = new PVector(quaternion[0], quaternion[1], quaternion[2]);
            vector.normalize();
            this.upX = vector.x;
            this.upY = vector.y;
            this.upZ = vector.z;
        }
        if(key == 'e') { // spin right
            quaternion = rotateOnQuaternion(upX, upY, upZ, forwardX, forwardY, forwardZ, -angleSpeed);
            vector = new PVector(quaternion[0], quaternion[1], quaternion[2]);
            vector.normalize();
            upX = vector.x;
            upY = vector.y;
            upZ = vector.z;

            quaternion = this.vectorProduct(this.upX, this.upY, this.upZ, this.forwardX, this.forwardY, this.forwardZ);
            vector = new PVector(quaternion[0], quaternion[1], quaternion[2]);
            vector.normalize();
            this.rightX = vector.x;
            this.rightY = vector.y;
            this.rightZ = vector.z;

            quaternion = this.vectorProduct(this.forwardX, this.forwardY, this.forwardZ, this.rightX, this.rightY, this.rightZ);
            vector = new PVector(quaternion[0], quaternion[1], quaternion[2]);
            vector.normalize();
            this.upX = vector.x;
            this.upY = vector.y;
            this.upZ = vector.z;
        }
        if(key == 'r') {
            forwardX = forwardY = 0;
            forwardZ = 1;
            upX = upZ = 0;
            upY = 1;
            rightX = 1;
            rightY = rightZ = 0;
        }
    }
}


float[] rotateOnQuaternion(float px, float py, float pz, float ax, float ay, float az, float angle) {
    float[] p = new float[]{0, px, py, pz};
    float[] a = new float[]{cos(angle), sin(angle) * ax, sin(angle) * ay, sin(angle) * az};

    p[0] = 0 - (a[1]) * (p[1]) - (a[2]) * (p[2]) - (a[3]) * (p[3]);
    p[1] = (a[0]) * (p[1]) + 0 + (a[2]) * (p[3]) - (a[3]) * (p[2]);
    p[2] = (a[0]) * (p[2]) - (a[1]) * (p[3]) + 0 + (a[3]) * (p[1]);
    p[3] = (a[0]) * (p[3]) + (a[1]) * (p[2]) - (a[2]) * (p[1]) + 0;

    p[0] = + (p[0]) * (a[0]) + (p[1]) * (a[1]) + (p[2]) * (a[2]) + (p[3]) * (a[3]);
    p[1] = - (p[0]) * (a[1]) + (p[1]) * (a[0]) - (p[2]) * (a[3]) + (p[3]) * (a[2]);
    p[2] = - (p[0]) * (a[2]) + (p[1]) * (a[3]) + (p[2]) * (a[0]) - (p[3]) * (a[1]);
    p[3] = - (p[0]) * (a[3]) - (p[1]) * (a[2]) + (p[2]) * (a[1]) + (p[3]) * (a[0]);

    return new float[]{p[1], p[2], p[3]};
}

float[] vectorProduct(float x1, float y1, float z1, float x2, float y2, float z2) {
    return new float[]{y1 * z2 - y2 * z1, x2 * z1 - x1 * z2, x1 * y2 - x2 * y1};
}
