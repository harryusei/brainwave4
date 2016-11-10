import ddf.minim.analysis.*;
import ddf.minim.*;
int BUFSIZE = 513;

//１．音楽ファイル再生関係
Minim minim;
AudioPlayer player;


FFT fft;
float[] rot = new float[BUFSIZE]; //角度を保存 
float[] rotSpeed = new float[BUFSIZE];


void setup() {
 
  size(800, 800, P3D);
  frameRate(60);
  colorMode(HSB, 360, 100, 100, 100);
  noStroke();
  smooth(); 

//１．音楽ファイル再生関係
  minim = new Minim(this);
  player = minim.loadFile("brainWaveBgm.mp3");
  //player = minim.loadFile("music.mp3", 512);

//２．FFT関係
  fft = new FFT(player.bufferSize(), player.sampleRate());

//ここで音楽再生
  player.play();
  
  for (int i = 0; i < BUFSIZE; i++) {
    rot[i] = 0;
    rotSpeed[i] = 0;
  }
    
  background(0);
}

void draw() {
 // background(#FFFFFF);
  backgroundFade();
  blendMode(ADD);

  translate(width/2, height/2);


  int offset1 = 8;
  int offset2 = 150;
  int specSize = fft.specSize();

//３．左チャンネルに応じてグラデーションの円を描画
  fft.forward(player.left);
  for (int i = 0; i < fft.specSize(); i++) {
        float h = map(i, 0, fft.specSize(), 0, 10000);
        float x = map(i, 0, fft.specSize(), 0, width*10);
        float size = map(fft.getBand(i), 0, 1.0, 0, 0.2);
        rotSpeed[i] = size/2;
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