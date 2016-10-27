
import ddf.minim.analysis.*;
import ddf.minim.*;

int FFTSIZE = 8192;
int BUFSIZE = 512;
Minim minim;

float[] posX = new float[FFTSIZE]; 
float[] posY = new float[FFTSIZE]; 
float[] speedX = new float[FFTSIZE]; 
float[] speedY = new float[FFTSIZE]; 
float[] angle = new float[FFTSIZE]; 
float stiffness = 0.4; 
float damping = 0.9;
float mass = 100.0; 

void setup(){
 
  size(600, 600, P3D);
  frameRate(60);
  colorMode(HSB, 360, 100, 100, 100); 
  noStroke();
  background(0);

  minim = new Minim(this);

  for (int i = 0; i < FFTSIZE; i++) {
        posX[i] = 0;
        posY[i] = 0;
        speedX[i] = 0;
        speedY[i] = 0;
        angle[i] = radians(random(0, 360));
  } 
}

void draw(){
  backgroundFade(); 
  blendMode(ADD);

  translate(width/2, height/2);

  float specSize = random(10); 
  //nouha ironikannkei?
  float getBand;
  
  for (int i = 0; i < specSize; i++){
    getBand = random(300);
    //nouha hannkeinikannkei?

    float addFroce = getBand* i * width/float(FFTSIZE)/2.0;
    float direction = radians(random(0, 360));

    float addX = cos(direction) * addFroce;
    float addY = sin(direction) * addFroce;

    float forceX = stiffness * -posX[i] + addX;
    float accelerationX = forceX / mass;
    speedX[i] = damping * (speedX[i] + accelerationX); 
    
    float forceY = stiffness * -posY[i] + addY;
    float accelerationY = forceY / mass;
    speedY[i] = damping * (speedY[i] + accelerationY); posX[i] += speedX[i];
    posY[i] += speedY[i];

    fill(255, 20);
    float h = map(i, 0, specSize, 0, 360);  //color kikakuka
    float r = getBand * i / 16.0 + 30.0;  //hannkei kikakuka
    
    fill(h, 100, 100, 10);
    ellipse(posX[i], posY[i], r, r);
  } 
}

void backgroundFade() {
  blendMode(BLEND);
  noStroke();
  fill(0, 0, 0, 5);
  rect(0, 0, width, height);
}