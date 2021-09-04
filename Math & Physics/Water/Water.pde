static int sizeX = 128, sizeZ = 128;
static int fps = 60;

static float difference = 2 * PI / fps;
static int colours[][];


float amplitudeX, amplitudeZ, frequencyX, frequencyZ, offsetX, offsetZ, offsetSpeedX, offsetSpeedZ;
float angleX, angleY;
int colour;
int light, filling;


void setup() {
    fullScreen(P3D);
    frameRate(fps);

    colours = new int[][]{
        {255, 255, 255,},
        {255, 0, 0},
        {255, 127, 0},
        {127, 127, 0},
        {127, 255, 0},
        {0, 255, 0},
        {0, 255, 127},
        {0, 127, 127},
        {0, 127, 255},
        {0, 0, 255},
        {255, 255, 0},
        {0, 255, 255},
        {255, 0, 255},
    };

    amplitudeX = 0;
    amplitudeZ = 0;
    frequencyX = 0;
    frequencyZ = 0;
    offsetX = 0;
    offsetZ = 0;
    offsetSpeedX = 0;
    offsetSpeedZ = 0;

    angleX = -PI / 6;
    angleY = 0;

    colour = 0;

    light = 0;
    filling = 0;
}

void draw() {
    background(0);
    translate(width / 2, height / 2);
    rotateX(angleX);
    rotateY(angleY);

    stroke(colours[colour / fps][0], colours[colour / fps][1], colours[colour / fps][2]);
    strokeWeight(1);
    if(light == 1)
        lights();
    if(filling == 0)
        noFill();
    else
        fill(colours[colour / fps][0], colours[colour / fps][1], colours[colour / fps][2]);
    for(int z = 0; z < sizeZ - 1; z++) {
        beginShape(TRIANGLE_STRIP);
        for(int x = 0; x < sizeX; x++) {
            vertex((x - sizeX / 2) * 10, amplitudeX * sin(frequencyX * x + offsetX) + amplitudeZ * sin(frequencyZ * z + offsetZ), (z - sizeZ / 2) * 10);
            vertex((x - sizeX / 2) * 10, amplitudeX * sin(frequencyX * x + offsetX) + amplitudeZ * sin(frequencyZ * (z + 1) + offsetZ), (z - sizeZ / 2 + 1) * 10);
        }
        endShape();
    }

    showValues();
    changeValues();

    offsetX += offsetSpeedX;
    if(offsetX > PI * 2)
        offsetX = -PI * 2;
    else if(offsetX < -PI * 2)
        offsetX = PI * 2;
    offsetZ += offsetSpeedZ;
    if(offsetZ > PI * 2)
        offsetZ = -PI * 2;
    else if(offsetZ < -PI * 2)
        offsetZ = PI * 2;
}


void showValues() {
    float w = width / 6;
    float h = height / 12;
    float values[] = new float[6];
    values[0] = map(amplitudeX, -PI, PI, -h, h);
    values[1] = map(frequencyX, -PI, PI, -h, h);
    values[2] = map(offsetSpeedX, -PI, PI, -h, h);
    values[3] = map(amplitudeZ, -PI, PI, -h, h);
    values[4] = map(frequencyZ, -PI, PI, -h, h);
    values[5] = map(offsetSpeedZ, -PI, PI, -h, h);

    rotateY(-angleY);
    rotateX(-angleX);
    translate(-width / 2, -height / 2 - h * 2, -256);

    stroke(255);
    strokeWeight(1);
    for(int i = 0; i < 6; i++) {
        rectMode(CORNERS);
        noFill();
        rect(w * i, 0, w * (i + 1), h * 2);
        fill(255);
        rect(w * i, h, w * (i + 1), h - values[i]);
    }
}

void changeValues() {
    if(keyPressed) {
        if(key == 'q' || key == 'Q' || key == 'й' || key == 'Й') {
            amplitudeX += difference;
            if(amplitudeX > PI)
                amplitudeX = PI;
        }
        if(key == 'a' || key == 'A' || key == 'ф' || key == 'Ф') {
            amplitudeX -= difference;
            if(amplitudeX < -PI)
                amplitudeX = -PI;
        }
        if(key == 'z' || key == 'Z' || key == 'я' || key == 'Я') {
            amplitudeX = 0;
        }
        if(key == 'w' || key == 'W' || key == 'ц' || key == 'Ц') {
            frequencyX += difference;
            if(frequencyX > PI)
                frequencyX = PI;
        }
        if(key == 's' || key == 'S' || key == 'і' || key == 'І') {
            frequencyX -= difference;
            if(frequencyX < -PI)
                frequencyX = -PI;
        }
        if(key == 'x' || key == 'X' || key == 'ч' || key == 'Ч') {
            frequencyX = 0;
        }
        if(key == 'e' || key == 'E' || key == 'у' || key == 'У') {
            offsetSpeedX += difference;
            if(offsetSpeedX > PI)
                offsetSpeedX = PI;
        }
        if(key == 'd' || key == 'D' || key == 'в' || key == 'В') {
            offsetSpeedX -= difference;
            if(offsetSpeedX < -PI)
                offsetSpeedX = -PI;
        }
        if(key == 'c' || key == 'C' || key == 'с' || key == 'С') {
            offsetSpeedX = 0;
        }
        if(key == 'r' || key == 'R' || key == 'к' || key == 'К') {
            amplitudeZ += difference;
            if(amplitudeZ > PI)
                amplitudeZ = PI;
        }
        if(key == 'f' || key == 'F' || key == 'а' || key == 'А') {
            amplitudeZ -= difference;
            if(amplitudeZ < -PI)
                amplitudeZ = -PI;
        }
        if(key == 'v' || key == 'V' || key == 'м' || key == 'М') {
            amplitudeZ = 0;
        }
        if(key == 't' || key == 'T' || key == 'е' || key == 'Е') {
            frequencyZ += difference;
            if(frequencyZ > PI)
                frequencyZ = PI;
        }
        if(key == 'g' || key == 'G' || key == 'п' || key == 'П') {
            frequencyZ -= difference;
            if(frequencyZ < -PI)
                frequencyZ = -PI;
        }
        if(key == 'b' || key == 'B' || key == 'и' || key == 'И') {
            frequencyZ = 0;
        }
        if(key == 'y' || key == 'Y' || key == 'н' || key == 'Н') {
            offsetSpeedZ += difference;
            if(offsetSpeedZ > PI)
                offsetSpeedZ = PI;
        }
        if(key == 'h' || key == 'H' || key == 'р' || key == 'Р') {
            offsetSpeedZ -= difference;
            if(offsetSpeedZ < -PI)
                offsetSpeedZ = -PI;
        }
        if(key == 'n' || key == 'N' || key == 'т' || key == 'Т') {
            offsetSpeedZ = 0;
        }
        if(key == 'u' || key == 'U' || key == 'г' || key == 'Г') {
            angleX -= difference;
            if(angleX < PI)
                angleX += PI;
        }
        if(key == 'j' || key == 'J' || key == 'о' || key == 'О') {
            angleX += difference;
            if(angleX > PI)
                angleX -= PI;
        }
        if(key == 'm' || key == 'M' || key == 'ь' || key == 'Ь') {
            angleX = 0;
        }
        if(key == 'i' || key == 'I' || key == 'ш' || key == 'Ш') {
            angleY += difference;
            if(angleY < PI)
                angleY += PI;
        }
        if(key == 'k' || key == 'K' || key == 'л' || key == 'Л') {
            angleY -= difference;
            if(angleY > PI)
                angleY -= PI;
        }
        if(key == ',' || key == '<' || key == 'б' || key == 'Б') {
            angleY = 0;
        }
        if(key == 'o' || key == 'O' || key == 'щ' || key == 'Щ') {
            colour = (colour + 3) % (13 * fps);
        }
        if(key == 'l' || key == 'L' || key == 'д' || key == 'Д') {
            colour = (colour - 3 + 13 * fps) % (13 * fps);
        }
        if(key == '.' || key == '>' || key == 'ю' || key == 'Ю') {
            colour = 0;
        }
        if(key == 'p' || key == 'P' || key == 'з' || key == 'З') {
            light = 0;
        }
        if(key == ';' || key == ':' || key == 'ж' || key == 'Ж') {
            light = 1;
        }
        if(key == '/' || key == '?' || key == '.' || key == ',') {
            light = 0;
        }
        if(key == '[' || key == '{' || key == 'х' || key == 'Х') {
            filling = 0;
        }
        if(key == '\'' || key == '\"' || key == 'є' || key == 'Є') {
            filling = 1;
        }
        if(key == ']' || key == '}' || key == 'ї' || key == 'Ї') {
            filling = 0;
        }
    }
}
