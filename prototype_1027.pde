import oscP5.*;
import netP5.*;
import ddf.minim.*;
import ddf.minim.signals.*;

Minim minim;
AudioOutput out;
SineWave sine;

AudioPlayer bgm;
float vol;

final int N_CHANNELS = 4;
final int FRAME_RATE = 30;
final int BUFFER_SIZE = 100;
final float MAX_MICROVOLTS = 1682.815;
final float DISPLAY_SCALE = 200.0;
final color BG_COLOR = color(0, 0, 0);

FFT fft;
float[] rot = new float[BUFFER_SIZE]; //角度を保存 
float[] rotSpeed = new float[BUFFER_SIZE]; //角速度

// rotbはBGM用の回転角、角速度をためるバッファ
// この配列のサイズがfft.specSizeに足りていなかったため
// fft.forwardの次のfor文でoutOfBoundsExceptionのエラーを吐いたと思われる
// 参考プログラムを見る限りfft.specSize = BUFSIZE(513)なのでこれによりバッファサイズ確保
final int BUFSIZE = 513;
float[] rotb = new float[BUFSIZE];
float[] rotSpeedb = new float[BUFSIZE]; //角速度

final int PORT = 5000;
OscP5 oscP5 = new OscP5(this, PORT);


final float max_hz = 1000;
final float min_hz = 220;


float[][] buffer = new float[N_CHANNELS][BUFFER_SIZE];
int pointer = 0;
int p = 0;

float[] freq = new float[N_CHANNELS];
float[] sumBuffer = new float[BUFFER_SIZE];

void setup(){
  size(800, 800);
  frameRate(30);
  smooth();
  colorMode(HSB, 360, 100, 100, 100);

  minim = new Minim(this);
  out = minim.getLineOut(Minim.STEREO);
  sine = new SineWave(261.6, 0.1, out.sampleRate());
  sine.portamento(200);
  out.addSignal(sine);

  for (int i = 0; i < BUFFER_SIZE; i++) {
    rot[i] = 0;
    rotSpeed[i] = 0;
  }

  bgm = minim.loadFile("brainWaveBgm.mp3");
  fft = new FFT(bgm.bufferSize(), bgm.sampleRate());
  bgm.play();
  vol = -30;
  bgm.setGain(vol);

}


void draw(){
  backgroundFade();
  blendMode(ADD);
  translate(width/2, height/2);

  for (int i = pointer; i > pointer - 10; i--) {
    int j = (i + BUFFER_SIZE) % BUFFER_SIZE;
    float h = map(sumBuffer[j], min_hz, max_hz, 0, 360);
    float x = map(sumBuffer[j] + pointer, min_hz, max_hz, 0, 800); //width
    float size = map(sumBuffer[j], 0, 10.0, 0, 0.2);
    rotSpeed[j] = size;
    rot[j] += rotSpeed[j];
    pushMatrix();
    rotate(radians(rot[j]));
    fill(h, 80, 100, 100);
    ellipse(x, 0, size, size);
    popMatrix();
  }

  int specSize = fft.specSize();
  fft.forward(bgm.left);
  for (int i = 0; i < fft.specSize(); i++) {
        float h = map(i, 0, fft.specSize(), 0, 10000);
        float x = map(i, 0, fft.specSize(), 0, width*10);
        float size = map(fft.getBand(i), 0, 1.0, 0, 0.2);
        rotSpeedb[i] = size/2;
        rotb[i] += rotSpeedb[i];
        pushMatrix();
        rotate(radians(rotb[i]));
        fill(h, 80, 100, 100);
        ellipse(x, 0, size, size);
        popMatrix();
    
  }
}

int count = 0;
void oscEvent(OscMessage msg){

  float data;
  float sumFreq = 0;
  if(msg.checkAddrPattern("/muse/elements/alpha_relative")){
      for(int ch = 0; ch < N_CHANNELS; ch++){
        data = msg.get(ch).floatValue();
          buffer[ch][pointer] = data;
          freq[ch] = map(buffer[ch][pointer], 0, 1, min_hz, max_hz);
          sumBuffer[pointer] += freq[ch];
      }
      sumBuffer[pointer] = sumBuffer[pointer] / 4;        // 4チャンネルの波の単純合計
      println(sumBuffer[pointer]);
      // ここに平滑化処理
      if (pointer >= 4 && count == 0) {
        sumBuffer[pointer-2] = (sumBuffer[pointer-4] + sumBuffer[pointer-3] 
          + sumBuffer[pointer-2] + sumBuffer[pointer-1] + sumBuffer[pointer])/5;
        count++;
        p = pointer - 2;
      }
      else if (pointer >= 4 && count!=0) {
        sumBuffer[pointer-2] = (sumBuffer[pointer-4] + sumBuffer[pointer-3] 
          + sumBuffer[pointer-2] + sumBuffer[pointer-1] + sumBuffer[pointer])/5;
        p = pointer - 2;
      }
      else if (pointer < 4 && count!=0){
        int r = (pointer+BUFFER_SIZE-2)%BUFFER_SIZE;
        sumBuffer[r] = (sumBuffer[(r+BUFFER_SIZE-2)%BUFFER_SIZE] + sumBuffer[(r+BUFFER_SIZE-1)%BUFFER_SIZE] + 
          sumBuffer[r] + sumBuffer[(r+BUFFER_SIZE+1)%BUFFER_SIZE] + sumBuffer[(r+BUFFER_SIZE+2)%BUFFER_SIZE])/5;
        /*
        pointer   pointerの2つ前の配列インデックス
        0         98
        1         99
        2         0
        3         1
        */
        p = r;
      }

      sine.setFreq(sumBuffer[p]);
      vol = map(sumBuffer[p], min_hz, max_hz, -50, 0);
      bgm.setGain(vol);
      /*
      float h = map(sumBuffer[p], min_hz, max_hz, 0, 100);
      float x = map(sumBuffer[p], min_hz, max_hz, 0, 800); //width
      float size = map(sumBuffer[p], 0, 10.0, 0, 0.2);
      rotSpeed[p] = size;
      rot[p] += rotSpeed[p];
      pushMatrix();
      rotate(radians(rot[p]));
      fill(h, 80, 100, 100);
      ellipse(x, 0, size, size);
      popMatrix();
      */
    pointer = (pointer + 1) % BUFFER_SIZE;

  }
}

void backgroundFade() {
  blendMode(BLEND);
  noStroke();
  fill(0, 0, 0, 5);
  rect(0, 0, width, height);
}


void stop() {
    out.close();
    bgm.close();
    minim.stop();
    super.stop();
}