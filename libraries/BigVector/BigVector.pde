import java.math.BigDecimal;
import java.math.RoundingMode;

class BigVector
{
  private BigDecimal x, y, z;
  private int scale = 16;

  public BigVector(double x)
  {
    this(x, 0, 0);
  };

  public BigVector(double x, double y)
  {
    this(x, y, 0);
  };

  public BigVector(double x, double y, double z)
  {
    this.x = new BigDecimal(x);
    this.x.setScale(scale, RoundingMode.HALF_UP);
    this.y = new BigDecimal(y);
    this.y.setScale(scale, RoundingMode.HALF_UP);
    this.z = new BigDecimal(z);
    this.z.setScale(scale, RoundingMode.HALF_UP);
  };

  public BigVector(BigDecimal x)
  {
    this(x, BigDecimal.valueOf(0), BigDecimal.valueOf(0));
  };

  public BigVector(BigDecimal x, BigDecimal y)
  {
    this(x, y, BigDecimal.valueOf(0));
  };

  public BigVector(BigDecimal x, BigDecimal y, BigDecimal z)
  {
    this.x = x;
    this.x.setScale(scale, RoundingMode.HALF_UP);
    this.y = y;
    this.y.setScale(scale, RoundingMode.HALF_UP);
    this.z = z;
    this.z.setScale(scale, RoundingMode.HALF_UP);
  };

  public void setScale(int scale)
  {
    this.scale = scale;
    x.setScale(scale, RoundingMode.HALF_UP);
    y.setScale(scale, RoundingMode.HALF_UP);
    z.setScale(scale, RoundingMode.HALF_UP);
  };

  public void normalize()
  {
    BigDecimal reverselen = length();
    if(reverselen.floatValue() == 0) return;
    this.div(reverselen);
  };

  public void add(double x) { add(x, 0, 0); };
  public void add(double x, double y) { add(x, y, 0); };
  public void add(double x, double y, double z)
  {
    this.x = this.x.add(BigDecimal.valueOf(x));
    this.y = this.y.add(BigDecimal.valueOf(y));
    this.z = this.z.add(BigDecimal.valueOf(z));
  };
  public void add(BigDecimal x) { add(x, BigDecimal.valueOf(0), BigDecimal.valueOf(0)); };
  public void add(BigDecimal x, BigDecimal y) { add(x, y, BigDecimal.valueOf(0)); };
  public void add(BigDecimal x, BigDecimal y, BigDecimal z)
  {
    this.x = this.x.add(x);
    this.y = this.y.add(y);
    this.z = this.z.add(z);
  };
  public void add(BigVector vector)
  {
    x = x.add(vector.getX());
    y = y.add(vector.getY());
    z = z.add(vector.getZ());
  };

  public void sub(double x) { sub(x, 0, 0); };
  public void sub(double x, double y) { sub(x, y, 0); };
  public void sub(double x, double y, double z)
  {
    this.x = this.x.subtract(BigDecimal.valueOf(x));
    this.y = this.y.subtract(BigDecimal.valueOf(y));
    this.z = this.z.subtract(BigDecimal.valueOf(z));
  };
  public void sub(BigDecimal x) { sub(x, BigDecimal.valueOf(0), BigDecimal.valueOf(0)); };
  public void sub(BigDecimal x, BigDecimal y) { sub(x, y, BigDecimal.valueOf(0)); };
  public void sub(BigDecimal x, BigDecimal y, BigDecimal z)
  {
    this.x = this.x.subtract(x);
    this.y = this.y.subtract(y);
    this.z = this.z.subtract(z);
  };
  public void sub(BigVector vector)
  {
    x = x.subtract(vector.getX());
    y = y.subtract(vector.getY());
    z = z.subtract(vector.getZ());
  };

  public void mult(double m)
  {
    x = x.multiply(BigDecimal.valueOf(m));
    y = y.multiply(BigDecimal.valueOf(m));
    z = z.multiply(BigDecimal.valueOf(m));
  };
  public void mult(BigDecimal m)
  {
    x = x.multiply(m);
    y = y.multiply(m);
    z = z.multiply(m);
  };

  public void div(double d)
  {
    x = x.divide(BigDecimal.valueOf(d), scale, RoundingMode.HALF_UP);
    y = y.divide(BigDecimal.valueOf(d), scale, RoundingMode.HALF_UP);
    z = z.divide(BigDecimal.valueOf(d), scale, RoundingMode.HALF_UP);
  };
  public void div(BigDecimal d)
  {
    x = x.divide(d, scale, RoundingMode.HALF_UP);
    y = y.divide(d, scale, RoundingMode.HALF_UP);
    z = z.divide(d, scale, RoundingMode.HALF_UP);
  };


  public BigDecimal scalarProduct(BigVector vector) { return scalarProduct(this, vector); };
  public BigDecimal scalarProduct(BigVector a, BigVector b)
  {
    BigDecimal product = a.getX().multiply(b.getX());
    product.add(a.getY().multiply(b.getY()));
    product.add(a.getZ().multiply(b.getZ()));
    return product;
  };

  public BigDecimal angleCos(BigVector vector) { return angleCos(this, vector); };
  public BigDecimal angleCos(BigVector a, BigVector b)
  {
    BigDecimal lena = a.length(), lenb = b.length();
    if(lena.floatValue() == 0 || lenb.floatValue() == 0) return BigDecimal.valueOf(-2);
    BigDecimal product = scalarProduct(a, b);
    product.divide(lena.multiply(lenb), scale, RoundingMode.HALF_UP);
    return product;
  };

  public BigDecimal length() { return length(this); };
  public BigDecimal length(BigVector vector)
  {
    BigDecimal sum = vector.getX().pow(2);
    sum = sum.add(vector.getY().pow(2));
    sum = sum.add(vector.getZ().pow(2));
    return BigDecimal.valueOf(Math.sqrt(sum.doubleValue()));
  };

  public double doubleX() { return x.doubleValue(); };
  public double doubleY() { return y.doubleValue(); };
  public double doubleZ() { return z.doubleValue(); };

  public float floatX() { return x.floatValue(); };
  public float floatY() { return y.floatValue(); };
  public float floatZ() { return z.floatValue(); };

  public int getScale() { return scale; };

  private BigDecimal getX() { return x; };
  private BigDecimal getY() { return y; };
  private BigDecimal getZ() { return z; };
};
