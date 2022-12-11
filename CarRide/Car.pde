class Car extends Object2D {
  public Car(
      PVector InPos,
      PVector InSize,
      float InDir,
      float InTurningCircle,
      float InMaxSpeed,
      float InAcceleration,
      float InSteerSpeed,
      PVector WheelSize,
      float WheelBase,
      float FrontTrack,
      float RearTrack
  ) {
    super(InPos, InSize, InDir);
    TurningCircle = InTurningCircle;
    MaxSpeed = InMaxSpeed;
    Acceleration = InAcceleration;
    SteerSpeed = InSteerSpeed;

    Wheels = new Object2D[4];
    Wheels[0] = new Object2D(new PVector(-FrontTrack / 2, -WheelBase / 2), WheelSize, 0);
    Wheels[1] = new Object2D(new PVector(FrontTrack / 2, -WheelBase / 2), WheelSize, 0);
    Wheels[2] = new Object2D(new PVector(-RearTrack / 2, WheelBase / 2), WheelSize, 0);
    Wheels[3] = new Object2D(new PVector(RearTrack / 2, WheelBase / 2), WheelSize, 0);
  }

  public void Accelerate(float DeltaTime, float Amount) {
    if (Amount == 0) {
      if (abs(Speed) < Acceleration) {
        Speed = 0;
        return;
      }

      float DeltaSpeed = Acceleration * 0.2 * DeltaTime;
      if (Speed > 0) {
        Speed -= DeltaSpeed;
      } else {
        Speed += DeltaSpeed;
      }
      return;
    }

    Speed += Amount * Acceleration * DeltaTime;

    if (Speed < -MaxSpeed / 2) {
      Speed = -MaxSpeed / 2;
    } else if (Speed > MaxSpeed) {
      Speed = MaxSpeed;
    }
  }

  public void Steer(float DeltaTime, float Amount) {
    if (Amount == 0) {
      return;
    }

    Steer += Amount * SteerSpeed * DeltaTime;

    if (abs(Steer) < SteerSpeed) {
      Steer = 0;
    } else if (Steer < -1) {
      Steer = -1;
    } else if (Steer > 1) {
      Steer = 1;
    }

    UpdateFrontWheelDir();
  }

  public void Move(float DeltaTime) {
    float Distance = Speed * DeltaTime;

    if (Steer == 0)
    {
      Pos.add(new PVector(0, -1).rotate(Dir).mult(Distance));
      return;
    }

    PVector TurningCenter = GetTurningCenter();
    PVector TurningCenterToPosVec = Pos.copy().sub(TurningCenter);
    float CircleDiameter = TurningCircle - Size.x / 2;

    float RotateAngle = 2 * asin(Distance * Steer / CircleDiameter);

    TurningCenterToPosVec.rotate(RotateAngle);

    Pos = TurningCenter.add(TurningCenterToPosVec);
    Dir += RotateAngle;

    UpdateFrontWheelDir();
  }

  public void UpdateFrontWheelDir() {
    if (Steer == 0) {
      Wheels[0].Dir = 0;
      Wheels[1].Dir = 0;
      return;
    }

    PVector TurningCenter = GetTurningCenter();

    Wheels[0].Dir = PVector.angleBetween(new PVector(0, 1).rotate(Dir), GetWheelPos(0).sub(TurningCenter));
    Wheels[1].Dir = PVector.angleBetween(new PVector(0, 1).rotate(Dir), GetWheelPos(1).sub(TurningCenter));

    if (Steer > 0) {
      Wheels[0].Dir = PI / 2 + Wheels[0].Dir;
      Wheels[1].Dir = PI / 2 + Wheels[1].Dir;
    } else {
      Wheels[0].Dir = PI / 2 - Wheels[0].Dir;
      Wheels[1].Dir = PI / 2 - Wheels[1].Dir;
    }
  }

  public void Draw() {
    Draw(new PVector(), 0, new PVector(153, 170, 188));
    for (int i = 0; i < 4; ++i) {
      Wheels[i].Draw(Pos, Dir, new PVector(35, 36, 40));
    }
  }

  public void DrawDebug() {
    Draw();

    PVector TurningCenter = GetTurningCenter();
    for (int i = 0; i < 4; ++i) {
      PVector WheelPos = GetWheelPos(i);
      float WheelRadius = TurningCenter.copy().sub(WheelPos).mag();

      stroke(245, 245, 220);
      noFill();

      line(TurningCenter.x, TurningCenter.y, WheelPos.x, WheelPos.y);
      circle(TurningCenter.x, TurningCenter.y, 2 * WheelRadius);

      stroke(0, 0, 0);
    }
  }

  private PVector GetWheelPos(int Index) {
    return Pos.copy().add(Wheels[Index].Pos.copy().rotate(Dir));
  }

  private PVector GetTurningCenter() {
    PVector RightDir = new PVector(1, 0).rotate(Dir);
    PVector LeftRearWheelPos = GetWheelPos(2);
    PVector RearAxisCenter = LeftRearWheelPos.copy().add(RightDir.copy().mult(Size.x / 2 - Wheels[0].Size.x / 2));

    float TurningRadius = (TurningCircle - (Size.x - Wheels[0].Size.x) / 2) / Steer;

    PVector TurningCenter = RearAxisCenter.copy().add(RightDir.copy().mult(TurningRadius));

    return TurningCenter;
  }

  private float TurningCircle;
  private float MaxSpeed;
  private float Acceleration;
  private float SteerSpeed;

  private float Speed;
  private float Steer;
  private Object2D[] Wheels;
};
