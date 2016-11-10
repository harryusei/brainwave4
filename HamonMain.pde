int SIZE = 20;
Ripple[] ripples = new Ripple[SIZE];

void setup() {
// size(screen.width, screen.height);

  colorMode(HSB,100);
  background(0);
  smooth();
  frameRate(30);
  
  for(int i=0;i<SIZE;i++) {
    ripples[i] = new Ripple();
  }
}

void draw() {
  background(0);
  
  for(int i=0;i<SIZE;i++) {
    if(ripples[i].getFlag()) {
      ripples[i].move();
      ripples[i].rippleDraw();
    }
  }
}

// mouse ver.
void mousePressed() {
  for(int i=SIZE-1;i>0;i--) {
    ripples[i] = new Ripple(ripples[i-1]);
  }
  ripples[0].init(mouseX,mouseY,random(5,15),int(random(10,80)));
}

// keyboard ver.
void keyPressed() {
  for(int i=SIZE-1;i>0;i--) {
    ripples[i] = new Ripple(ripples[i-1]);
  }
  ripples[0].init(int(random(0,width)),int(random(0,height)),random(5,15),int(random(10,80)));
}