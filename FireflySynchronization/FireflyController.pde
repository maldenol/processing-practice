import java.lang.Math;
import java.util.Iterator;


static float COUPLING_CONSTANT = 1.0, DISTANCE_CONSTANT = 2;
static float FIREFLY_BODY_DIAMETER = 15, FIREFLY_WING_LENGTH = 15, FIREFLY_WING_ANGLE = PI / 16;


class FireflyController {
    private ArrayList<Firefly> fireflies;
    private boolean enableSynchronization;


    FireflyController(int countOfFireflies) {
        this.fireflies = new ArrayList<Firefly>();

        for (int i = 0; i < countOfFireflies; i++) {
            float px = map((float)Math.random(), 0, 1, 0, width);
            float py = map((float)Math.random(), 0, 1, 0, height);
            float vx = map((float)Math.random(), 0, 1, -(width-1) / 20, width / 20);
            float vy = map((float)Math.random(), 0, 1, -(height-1) / 20, height / 20);
            float ff = map((float)Math.random(), 0, 1, TWO_PI * 2, TWO_PI / 2);
            float ftp = map((float)Math.random(), 0, 1, 0.5, 0.9);
            this.fireflies.add(new Firefly(px, py, vx, vy, ff, ftp));
        }

        this.enableSynchronization = false;
    }

    public void tick() {
        Iterator<Firefly> iterator = this.fireflies.iterator();

        while(iterator.hasNext()) {
            Firefly firefly = iterator.next();

            float timeHasPassed = 1 / frameRate;


            float randomVelocityVectorRotationAngle = map((float)Math.random(), 0, 1, -PI / 12, PI / 12);
            firefly.velocity.rotate(randomVelocityVectorRotationAngle);
            PVector fireflyVelocityVector = new PVector(firefly.velocity.x, firefly.velocity.y);
            fireflyVelocityVector.mult(timeHasPassed);
            firefly.position.add(fireflyVelocityVector);
            if (firefly.position.x <= 0) {
                firefly.position.x += width;
            } else if (firefly.position.x >= width - 1) {
                firefly.position.x -= width;
            }
            if (firefly.position.y <= 0) {
                firefly.position.y += height;
            } else if (firefly.position.y >= height - 1) {
                firefly.position.y -= height;
            }


            firefly.flashPhase += firefly.flashFrequency * timeHasPassed;

            if (this.enableSynchronization) {
                // It is used Kuramoto model here for synchronization.
                float deltaPhase = 0;
                Iterator<Firefly> nestedIterator = this.fireflies.iterator();
                while (nestedIterator.hasNext()) {
                    Firefly nestedFirefly = nestedIterator.next();
                    float distanceCoefficient = pow(map(nestedFirefly.position.dist(firefly.position), width / 8, 0, 0, 1), DISTANCE_CONSTANT);
                    deltaPhase += COUPLING_CONSTANT / this.fireflies.size() * sin(nestedFirefly.flashPhase - firefly.flashPhase) * distanceCoefficient * timeHasPassed;
                }
                firefly.flashPhase += deltaPhase;
            }

            if (firefly.flashPhase >= TWO_PI) {
                firefly.flashPhase -= TWO_PI * floor(firefly.flashPhase / TWO_PI);
                firefly.flashTimeLeft = firefly.flashTimePart * (1 / firefly.flashFrequency);
            }
            if (firefly.flashTimeLeft > 0) {
                firefly.flashTimeLeft -= timeHasPassed;

                if (firefly.flashTimeLeft <= 0) {
                    firefly.flashTimeLeft = 0;
                }
            }
        }
    }

    public void render() {
        Iterator<Firefly> iterator = this.fireflies.iterator();

        while(iterator.hasNext()) {
            Firefly firefly = iterator.next();

            PVector wingRotationVector = new PVector(firefly.velocity.x, firefly.velocity.y);
            wingRotationVector.normalize();
            wingRotationVector.rotate(PI / 2);
            line(firefly.position.x - FIREFLY_WING_LENGTH * wingRotationVector.x, firefly.position.y - FIREFLY_WING_LENGTH * wingRotationVector.y, firefly.position.x + FIREFLY_WING_LENGTH * wingRotationVector.x, firefly.position.y + FIREFLY_WING_LENGTH * wingRotationVector.y);
            wingRotationVector.rotate(FIREFLY_WING_ANGLE);
            line(firefly.position.x - FIREFLY_WING_LENGTH * wingRotationVector.x, firefly.position.y - FIREFLY_WING_LENGTH * wingRotationVector.y, firefly.position.x + FIREFLY_WING_LENGTH * wingRotationVector.x, firefly.position.y + FIREFLY_WING_LENGTH * wingRotationVector.y);
            wingRotationVector.rotate(-FIREFLY_WING_ANGLE * 2);
            line(firefly.position.x - FIREFLY_WING_LENGTH * wingRotationVector.x, firefly.position.y - FIREFLY_WING_LENGTH * wingRotationVector.y, firefly.position.x + FIREFLY_WING_LENGTH * wingRotationVector.x, firefly.position.y + FIREFLY_WING_LENGTH * wingRotationVector.y);

            stroke(85, 170, 0);
            if (firefly.flashTimeLeft > 0) {
              fill(85, 170, 0);
            } else {
              fill(0);
            }
            circle(firefly.position.x, firefly.position.y, FIREFLY_BODY_DIAMETER);
            noFill();
        }
    }

    public void toggleSynchronization() {
        this.enableSynchronization = !this.enableSynchronization;
    }
}
