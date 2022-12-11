class Object2D {
  public Object2D(PVector InPos, PVector InSize, float InDir) {
    Pos = InPos;
    Size = InSize;
    Dir = InDir;
  }

  public void Draw(PVector PosOffset, float DirOffset, PVector Color) {
    PVector PosRotated = Pos.copy().rotate(DirOffset).add(PosOffset);

    pushMatrix();
    translate(PosRotated.x, PosRotated.y);
    rotate(Dir + DirOffset);
    stroke(Color.x, Color.y, Color.z);
    fill(Color.x, Color.y, Color.z);
    rectMode(CENTER);
    rect(0, 0, Size.x, Size.y);
    popMatrix();
  }

  protected PVector Pos;
  protected PVector Size;
  protected float Dir;
};
