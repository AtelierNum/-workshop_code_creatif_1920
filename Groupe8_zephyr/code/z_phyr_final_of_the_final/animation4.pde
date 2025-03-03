// ANIMATION POULPE QUI NAGE 

final int NB_CILIUM = 12;
final float CELL_RAD = 13;
Cilium[] tabCilium = new Cilium[NB_CILIUM];
float R, G, B, Rspeed, Gspeed, Bspeed, mouseSpeed;
ArrayList<Part> freeParts = new ArrayList<Part>();

// fonction setup - lancement animation 4
void init_animation4() {
  generateColors();

  for (int i = 0; i < NB_CILIUM; i++) {
    tabCilium[i] = new Cilium(i * TWO_PI / NB_CILIUM);
  }
}

// fonction draw - définition de couleur du fond de la page, 
// couleur du poulpe qui change toute seule
void loop_animation4() {
    background(0);

  mouseSpeed = dist(handX, handY, pHandX, pHandY); 

  Rspeed = ((R += Rspeed) > 255 || (R < 0)) ? -Rspeed : Rspeed;
  Gspeed = ((G += Gspeed) > 255 || (G < 0)) ? -Gspeed : Gspeed;
  Bspeed = ((B += Bspeed) > 255 || (B < 0)) ? -Bspeed : Bspeed;

  for (int i = freeParts.size () - 1; i > -1; i--) {
    Boolean dead = freeParts.get(i).update();
    if (dead) {
      freeParts.remove(i);
    }
  }

  for (int i = 0; i < NB_CILIUM; i++) {
    tabCilium[i].process();
  }

  for (int i = tabCilium[0].NB_POINTS-1; i >= 0; i--) {//draw the tips first
    for (int j = 0; j < NB_CILIUM; j++) {
      tabCilium[j].render(i);
    }
  }
}

//  Changement des couleurs de façon aléatoire (poulpe)
void generateColors() {
  R = random(255);
  G = random(255);
  B = random(255);
  Rspeed = (random(1) > .5 ? 1 : -1) * random(.8, 1.5);
  Gspeed = (random(1) > .5 ? 1 : -1) * random(.8, 1.5);
  Bspeed = (random(1) > .5 ? 1 : -1) * random(.8, 1.5);
}

void mousePressed() {
  generateColors();
}

class Cilium
{
  final int NB_POINTS = 38;
  final float POINTS_DIST = 4.2;//distance between each point
  final float AMPLITUDE = random(1.5, 2);
  final float MIN_SPEED = .12, MAX_SPEED = .4;//max 'elastic speed' of each segment
  final float STEP = random(.02, .12);//speed of the wave
  final float PERIODS = random(2, 2);//number of 'complete waves' per cilium
  final float s = TWO_PI * PERIODS / NB_POINTS;
  float sinTheta, cosTheta;//ciliums' angle
  float time = random(123456);//used to cycle the oscillation
  float colorAdjust = random(0, 20);//in order for each cilium to have a slightly different color
  float [] diams = new float[NB_POINTS];//precalculated points' diameters
  PVector[] pos = new PVector[NB_POINTS];
  PVector D;//default delta when at rest
  PVector lastMove = new PVector(0, 0);//particle's initial speed
  color[] colors = new color[NB_POINTS];
  Part[] parts = new Part[NB_POINTS];

  Cilium(float p_angle)
  {
    sinTheta = sin(p_angle);
    cosTheta = cos(p_angle);
    for (int i = 0; i < NB_POINTS; i++){
      pos[i] = new PVector(0, 0);     
      colors[i] = 0;
      diams[i] = sqrt(25*(NB_POINTS-i));
    }
  }
  //Le poulpe suit le mouvement de la main
  void process(){
    D = new PVector(POINTS_DIST*cosTheta, POINTS_DIST*sinTheta);
    time += STEP;
    pos[0] = new PVector(handX + CELL_RAD * cosTheta, handY + CELL_RAD * sinTheta);
    PVector delta;
    float coeff, tmpX, tmpY;
    for (int i = 1; i < NB_POINTS; i++)
    {
      delta = new PVector(pos[i].x - pos[i-1].x, pos[i].y - pos[i-1].y);
      coeff = map(i, NB_POINTS, 0, MIN_SPEED, MAX_SPEED);
      delta.x -= coeff * (delta.x - D.x);
      delta.y -= coeff * (delta.y - D.y);

      tmpX = i * PERIODS / NB_POINTS;
      tmpY = AMPLITUDE * sin(i * s + time) * cos(HALF_PI + HALF_PI * i / NB_POINTS);
      delta.x += tmpX * cosTheta - tmpY * sinTheta;//angle rotation of the oscillation
      delta.y += tmpX * sinTheta + tmpY * cosTheta;//angle rotation of the oscillation

      delta.normalize();
      delta.mult(POINTS_DIST);

      pos[i] = pos[i-1].get();
      pos[i].add(delta);
    }

    ////////////////// parts /////////////////////
    lastMove.sub(pos[NB_POINTS-2]);
    lastMove.normalize();
    lastMove.mult(POINTS_DIST);
    for (int i = NB_POINTS-2; i > -1; i --) {
      parts[i+1] = parts[i];
      parts[i] = null;
    }
    if (parts[NB_POINTS-1] != null) {
      parts[NB_POINTS-1].pos = pos[NB_POINTS-1].get();
      parts[NB_POINTS-1].speed = lastMove;
      freeParts.add(parts[NB_POINTS-1]);
      parts[NB_POINTS-1] = null;
    }
    if (random(1) < map(mouseSpeed, 0, width/2, .01, 2.5)) {
      parts[0] = new Part(pos[0]);
    }

    lastMove = pos[NB_POINTS - 1].get();
    ////////////////////////////////////////////////
  }

  void render(int p_rank)
  {
    if (parts[p_rank] == null) {
      noStroke();
    } else {
      int c = colors[p_rank], dc = 42;
      stroke(red(c)-dc, green(c)-dc, blue(c)-dc, map(p_rank, 0, NB_POINTS - 1, 120, 250));
    }
    if (p_rank == 0) {
      colors[p_rank] = color(constrain(R, 0, 255), constrain(G, 0, 255), constrain(B, 0, 255));
    } else if (p_rank == 1) {
      colors[p_rank] = color(colorAdjust+R, colorAdjust+G, colorAdjust+B);
    } else {
      colors[p_rank] = colors[p_rank-1];
    }
    fill(colors[p_rank]);
    ellipse(pos[p_rank].x, pos[p_rank].y, diams[p_rank], diams[p_rank]);
  }
}

class Part {
  PVector pos, speed = new PVector(0, 0);
  int age = 0, lifetime = (int)random(50, 160), downAge;
  float maxY = random(.1, .3);
  Boolean down = false;

  Part(PVector pv) {
    pos = pv;
  } 

  Boolean update() {
    age++;

    float diam1 = map(age, 0, lifetime, 10, 2);      
    if (!down) {
      speed.y -= .02 * diam1;
      speed.y *= .98;
      speed.mult(.985);
      pos.add(speed);


      stroke(20, 80);
      ellipse(pos.x, pos.y, diam1, diam1);
    }
    if (!down && pos.y < maxY*height) {
      down = true;
      downAge = age;
    }

    if (down) {
      pushStyle();
      stroke(200, map(maxY, .1, .3, 30, 5));
      noFill();
      diam1 = map(age, downAge, lifetime, 22, 2);   
      float diam2 = map(age, downAge, lifetime, 5, 0);   
      ellipse(pos.x, pos.y, diam1, diam2);
      popStyle();
    }

    return age > lifetime || pos.x < 0 || pos.x > width || pos.y > height;
  }
}
