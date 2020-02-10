class Ball
{
  float rad=5;
  float x, y, dx, dy;
  float friction = 1;
  
  Ball(float x, float y, float dx, float dy)
  { 

    this.x = x;
    this.y = y;
    this.dx=dx;
    this.dy=dy;
    BallMoved();
  }
  void BallMoved()
  {
    x+=dx * friction;
    y+=dy * friction;
    if (x>width || x<0) dx=-dx;
    if (y>height || y<0) dy =-dy;
    fill (255, 255, 255);
    ellipse(x, y, rad, rad);
  }
}
