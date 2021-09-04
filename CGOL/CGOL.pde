boolean arr[][], buf[][];
boolean pause, grid;
final int step = 16;
int sx, sy;


boolean cellState(int x, int y) {  
    int n = 0;

    if(buf[(x + 1) % sx][y])
        n++;
    if(buf[(x + 1) % sx][(y + 1) % sy])
        n++;
    if(buf[x][(y + 1) % sy])
        n++;
    if(buf[(sx + x - 1) % sx][(y + 1) % sy])
        n++;
    if(buf[(sx + x - 1) % sx][y])
        n++;
    if(buf[(sx + x - 1) % sx][(sy + y - 1) % sy])
        n++;
    if(buf[x][(sy + y - 1) % sy])
        n++;
    if(buf[(x + 1) % sx][(sy + y - 1) % sy])
        n++;

    if(!buf[x][y] && n == 3)
        return true;
    if(buf[x][y] && (n == 2 || n == 3))
        return true;
    return false;
}

void tick() {
    stroke(grid ? 255 : 0);

    for(int i = 0; i < sy; i++)
        for(int j = 0; j < sx; j++) {
            if(!pause)
                arr[j][i] = cellState(j, i);

            if(arr[j][i])
                fill(255);
            else
                fill(0);
            rect(j * step, i * step, step, step);
        }

    for(int i = 0; i < sy; i++)
        for(int j = 0; j < sx; j++)
            buf[j][i] = arr[j][i];

    stroke(255);
    point(mouseX, mouseY);
}

void generate() {
    pause = true;
    grid = false;
    sx = width / step;
    sy = height / step;
    arr = new boolean[sx][sy];
    buf = new boolean[sx][sy];
}


void setup() {
    fullScreen();
    frameRate(30);
    noCursor();

    stroke(0);

    generate();
}

void draw() {
    background(0);

    tick();
}


void keyPressed() {
    if(keyCode == ENTER)
        pause = !pause;
    else if(keyCode == SHIFT)
        grid = !grid;
    else if(keyCode == CONTROL) {
        pause = false;
        tick();
        pause = true;
    }
    else if(keyCode == TAB) {
        generate();
    }
}

void mousePressed() {
    if(mouseButton == RIGHT)
        tick();
    else if(pause) {
        int x = floor(mouseX / step), y = floor(mouseY / step);
        buf[x][y] = arr[x][y] = !arr[x][y];
    }
}
