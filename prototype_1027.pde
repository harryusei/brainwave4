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
  smooth();

  minim = new Minim(this);
  out = minim.getLineOut(Minim.STEREO);
  sine = new SineWave(261.6, 0.5, out.sampleRate());
  sine.portamento(200);
  out.addSignal(sine);
  
}

int counter = 0;  // 3回のループ用

// この中擬似脳波(マウスの位置による初期設定、本番は消す
sumBuffer[0] = min_hz;
sumBuffer[1] = min_hz;
pointer = 1;
// ここまで

void draw(){

  // この中擬似脳波(マウスの位置による)用プログラム、本番は消す
  // ウィンドウの上端がmax_hz, 下端がmin_hzに対応
  if(counter = 2){
    float freq = map(mouseY, 600, 0, min_hz, max_hz);
    sumBuffer[pointer + 1] = freq;
    pointer = (pointer + 1) % BUFFER_SIZE;
  }
  // ここまで

  float setFreq = ((3 - counter) * sumBuffer[pointer - 1] + counter * sumBuffer[pointer]) / 3;
  sine.setFreq(setFreq);
  counter = (counter + 1) % 3;
}

/* museが使えないため一旦コメントアウト
void oscEvent(OscMessage msg){
  float data;
  float sumFreq = 0;
  if(msg.checkAddrPattern("/muse/elements/alpha_relative")){
      for(int ch = 0; ch < N_CHANNELS; ch++){
        data = msg.get(ch).floatValue();
          buffer[ch][pointer] = data;
          freq[ch] = map(buffer[ch][pointer], 0, 1, min_hz, max_hz);
          sumFreq = sumFreq + freq[ch];
      }
      sumBuffer[pointer] = sumFreq;        // 4チャンネルの波の単純合計

      // ここに平滑化処理

    pointer = (pointer + 1) % BUFFER_SIZE;
  }
}
*/

void stop() {
    out.close();
    minim.stop();
    super.stop();
  }