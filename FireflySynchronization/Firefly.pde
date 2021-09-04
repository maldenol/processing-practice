class Firefly {
    public PVector position;
    public PVector velocity;
    public float flashFrequency, flashPhase;
    public float flashTimePart, flashTimeLeft;


    Firefly(float px, float py, float vx, float vy, float ff, float ftp) {
        this.position = new PVector(px, py);
        this.velocity = new PVector(vx, vy);
        this.flashFrequency = ff;
        this.flashPhase = 0;
        this.flashTimePart = ftp;
        this.flashTimeLeft = 0;
    }
}
