import ddf.minim.analysis.*;
import ddf.minim.*;
int BUFSIZE = 512;

Minim minim; // Minimのインスタンス 

float[] rot = new float[BUFSIZE]; //角度を保存 
float[] rotSpeed = new float[BUFSIZE]; //角速度
void setup() {

  size(800, 800, P3D);
  frameRate(60);
  colorMode(HSB, 360, 100, 100, 100);

  minim = new Minim(this);
 
  for (int i = 0; i < BUFSIZE; i++) {
    rot[i] = 0;
    rotSpeed[i] = 0;
  }
    
  background(0);
}

void draw() {
  backgroundFade();
  blendMode(ADD);

  translate(width/2, height/2);
  float specSize = random(100); 
  //tennnoiti nouhadainyuu
  float getBand = random(30);  
  //sokudo nouhadainyuu

  for (int i = 0; i < specSize; i++) {
        float h = map(i, 0, specSize, 0, 100);
        float x = map(i, 0, specSize, 0, width);
        float size = map(getBand, 0, 1.0, 0, 0.2);
        rotSpeed[i] = size;
        rot[i] += rotSpeed[i];
        pushMatrix();
        rotate(radians(rot[i]));
        fill(h, 80, 100, 100);
        ellipse(x, 0, size, size);
        popMatrix();
  } 
}

void backgroundFade() {
    blendMode(BLEND);
    noStroke();
    fill(0, 0, 0, 5);
    rect(0, 0, width, height);
}