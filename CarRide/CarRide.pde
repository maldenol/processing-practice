final float Scale = 0.025;
final float CarWidth = 1764 * Scale;
final float CarLength = 3838 * Scale;
final float CarDir = 0;
final float CarTurningCircle = 10950 * Scale;
final float CarMaxSpeed = 10 * Scale;
final float CarAcceleration = 0.01 * Scale;
final float CarSteerSpeed = 0.003;
final float CarWheelWidth = 700 * Scale;
final float CarWheelLength = 300 * Scale;
final float CarWheelBase = 2568 * Scale;
final float CarFrontTrack = 1556 * Scale;
final float CarRearTrack = 1551 * Scale;

int PrevTime = 0;

int AccelerateDir = 0;
int SteerDir = 0;
boolean Debug = true;

Car Car4x2;

PImage BackgroundImage;

void setup()
{
   fullScreen();
   frameRate(60);

   noCursor();

   stroke(0);

   Car4x2 = new Car(
     new PVector(width, height),
     new PVector(CarWidth, CarLength),
     CarDir,
     CarTurningCircle,
     CarMaxSpeed,
     CarAcceleration,
     CarSteerSpeed,
     new PVector(CarWheelLength, CarWheelWidth),
     CarWheelBase,
     CarFrontTrack,
     CarRearTrack
   );

   BackgroundImage = loadImage("parking.png");
   BackgroundImage.resize(width, height);
}

void draw()
{
   image(BackgroundImage, 0, 0);

   translate(-width / 2, -height / 2);

   int CurrTime = millis();
   int DeltaTime = CurrTime - PrevTime;
   PrevTime = CurrTime;

   Car4x2.Accelerate(DeltaTime, AccelerateDir);
   Car4x2.Steer(DeltaTime, SteerDir);

   Car4x2.Move(DeltaTime);

   if (Debug) {
     Car4x2.DrawDebug();
   } else {
     Car4x2.Draw();
   }
}

void keyPressed()
{
  switch (key) {
    case 'w':
      AccelerateDir = 1;
      break;
    case 's':
      AccelerateDir = -1;
      break;
    case 'a':
      SteerDir = -1;
      break;
    case 'd':
      SteerDir = 1;
      break;
    case 'q':
      Debug = !Debug;
      break;
    default:
      break;
  }
}

void keyReleased() {
  switch (key) {
    case 'w':
    case 's':
      AccelerateDir = 0;
      break;
    case 'a':
    case 'd':
      SteerDir = 0;
      break;
    default:
      break;
  }
}
