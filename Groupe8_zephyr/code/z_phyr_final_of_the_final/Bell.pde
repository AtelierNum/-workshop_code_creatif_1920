
//définition de Bell - 5 RONDS 

class Bell {
  
  int id;
  float x;
  float y;
  float r;
  color c;


// Définition de la position, de la couleur et de la musique de fonction Bell
 Bell(int _id, float a_, float r_, color _c,String s_) {
   // id = _id;
    //x=x_;
    //y=y_;
    
    // Position en coordonnés polaire des ronds
    x = width/2 + random(250, 400) * cos(radians(a_));
    y = height/2 + random(250, 400) * sin(radians(a_));
    r=r_;
    c = _c;
  }

// Mouvement des ronds
  void jiggle() {
    x+= random(-1, 1);
    y+=random(-1, 1);
    r=constrain(r+random(-2, 2), 50, 150);
  }
  
  
  // Replacer les ronds en tapant sur la touche "r"
  void replace(int _id, float a_, float r_, color _c,String s_) {
    x = width/2 + random(250, 400) * cos(radians(a_));
    y = height/2 + random(250, 400) * sin(radians(a_));
    r=r_;
    c = _c;
  }

// Mouvement
  boolean contains(float mx, float my) {
    if (dist(mx, my, x, y)<r/2) {
      return true;
    } else {
      return false;
    }
  }


// Afficher les ronds 
  void display() {
    noStroke();
    fill(red(c), green(c), blue(c), 30);
    for (int i = 0; i < 8; i++) {
      ellipse(x, y, r+i*9, r+i*9);
    }
    fill(0);
    //text(id, x, y);
  }
  
  
}
