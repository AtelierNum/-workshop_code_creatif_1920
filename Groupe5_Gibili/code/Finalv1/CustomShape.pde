import java.util.List;
import java.util.Arrays;

//Création d'une classe pour le smiley
class CustomShape {

  BodyDef bd; 
  Body body;

//Créer les formes du smiley car ce sont des SVG fait sur Illustrator
  PShape jaune;
  PShape vert;
  PShape orange;
  PShape rouge;
  PShape colere;
  PShape meuf;
  float rad= 70; 
  
  //première initialisation du vecteur de la position du smiley afin de pouvoir y accéder dans le sketch
  Vec2 posScreen = new Vec2(100, 100);

//Le constructeur de la classe
  CustomShape() {

    jaune = loadShape("Jaune.svg");
    vert = loadShape("Vert.svg");
    orange = loadShape("Orange.svg");
    rouge = loadShape("Rouge.svg");
    colere = loadShape("Colere.svg");
    meuf = loadShape("Meuf.svg");

    bd = new BodyDef();

    //Position de base du smiley et son comportement physique
    bd.position.set(box2d.coordPixelsToWorld(new Vec2(width*0.165, height*0.185)));
    bd.type = BodyType.DYNAMIC;

    //Le smiley aura une hitbox en cercle
    CircleShape ps =  new CircleShape();

    //Donne la taille de la hitbox du smiley
    float box2Dr = box2d.scalarPixelsToWorld(rad);
    //ps.m_radius = rad;
    ps.setRadius(box2Dr);
  
    //Création du lien pour lier la forme de la hitbox au comportement physique définit plus haut
    FixtureDef fd = new FixtureDef();
    fd.shape = ps;

    //D'autre caractéristiques phyisiques
    fd.friction = 0.3;
    fd.restitution = 0.1; //Rebondissements
    fd.density = 0.1;
    body = box2d.createBody(bd);
    body.createFixture(fd);
  }

  //Affichage du smiley
  void display() {
    
    Vec2 pos = box2d.getBodyPixelCoord(body);
    
    pushMatrix();

    translate(pos.x, pos.y);
    noFill();
    noStroke();
    ellipse(0, 0, rad*2, rad*2);
    shapeMode(CENTER);
    if (smiley == 1) {
      shape(jaune, 0, 0, 100, 100 / 1.73);
    }
    if (smiley == 2) {
      shape(vert, 0, 0, 100, 100 / 1.46);
    }
    if (smiley == 3) {
      shape(orange, 0, 0, 100, 100 / 1.18);
    }
    if (smiley == 4) {
      shape(rouge, 0, 0, 100, 100 / 1.74);
    }
    if (smiley == 5) {
      shape(colere, 0, 0, 100, 100 / 1.18);
    }
    if (smiley == 6) {
      shape(meuf, 0, 0, 100, 100 / 1.17);
    }

    popMatrix();
  }


  //
  void update() {
    // Prend la à position du smiley de l'écran
    posScreen = box2d.getBodyPixelCoord(body);

    // Transforme la position du smiley en vecteur toxiclibs
    Vec2D toxiScreen = new Vec2D(posScreen.x, posScreen.y);
    
    // Regarde si le smiley est dqns le blob d' une personne
    boolean inBody = poly.containsPoint(toxiScreen);

    // Si le smiley est dans une personne
    if (inBody) {
      // find the closest point on the polygon to the current position
      Vec2D closestPoint = toxiScreen;
      float closestDistance = 9999999;
      for (Vec2D v : poly.vertices) 
      {
        float distance = v.distanceTo(toxiScreen);
        if (distance  < closestDistance ) 
        {
          closestDistance = distance;
          closestPoint = v;
        }
      }
      Vec2 contourPos = new Vec2(closestPoint.x, closestPoint.y);
      Vec2 posWorld = box2d.coordPixelsToWorld(contourPos);
      float angle = body.getAngle();
      body.setTransform(posWorld, angle);
    }
  }
  // Attire le smiley au centre de l'écran
  void attract(float x, float y) {
    // Converti les coordonnées en pixel dans la librairie box2D
    Vec2 worldTarget = box2d.coordPixelsToWorld(x, y);   
    Vec2 bodyVec = body.getWorldCenter();
    // Localise le vecteur du smiley
    worldTarget.subLocal(bodyVec);
    // Applique des forces
    worldTarget.normalize();
    worldTarget.mulLocal((float) 100);
    // Applique aussi sur le centre du monde
    body.applyForce(worldTarget, bodyVec);
  }
}
