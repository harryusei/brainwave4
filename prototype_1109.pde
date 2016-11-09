import oscP5.*;
import netP5.*;
import ddf.minim.*;
import ddf.minim.signals.*;

Minim minim;
AudioOutput out;
SineWave sine;


final int N_CHANNELS = 4;
final int FRAME_RATE = 30;
final int BUFFER_SIZE = 100;
final float MAX_MICROVOLTS = 1682.815;
final float DISPLAY_SCALE = 200.0;
final color BG_COLOR = color(0, 0, 0);

final int PORT = 5000;
OscP5 oscP5 = new OscP5(this, PORT);


final float max_hz = 1760;
final float min_hz = 220;


float[][] buffer = new float[N_CHANNELS][BUFFER_SIZE];
int pointer = 0;

float[] freq = new float[N_CHANNELS];
float[] sumBuffer = new float[BUFFER_SIZE];

void setup(){
  size(1000, 600);
  frameRate(30);
  //smooth();

  minim = new Minim(this);
  out = minim.getLineOut(Minim.STEREO);
  sine = new SineWave(261.6, 0.5, out.sampleRate());
  sine.portamento(200);
  out.addSignal(sine);
  
}


void draw(){

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
      sumBuffer[pointer] = sumBuffer[pointer] / N_CHANNELS;        // 4チャンネルの波の単純合計

      // ここに平滑化処理
      if (pointer >= 4 && count == 0) {
        sumBuffer[pointer-2] = (sumBuffer[pointer-4] + sumBuffer[pointer-3] 
          + sumBuffer[pointer-2] + sumBuffer[pointer-1] + sumBuffer[pointer])/5;
        sine1.setFreq(sumBuffer[pointer-2]);
        count++;
      }
      else if (pointer >= 4 && count!=0) {
        sumBuffer[pointer-2] = (sumBuffer[pointer-4] + sumBuffer[pointer-3] 
          + sumBuffer[pointer-2] + sumBuffer[pointer-1] + sumBuffer[pointer])/5;
        sine1.setFreq(sumBuffer[pointer-2]);
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
        sine1.setFreq(sumBuffer[r]);
      }

    pointer = (pointer + 1) % BUFFER_SIZE;

  }
}


void stop() {
    out.close();
    minim.stop();
    super.stop();
}