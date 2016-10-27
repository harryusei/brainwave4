import oscP5.*;
import netP5.*;
import ddf.minim.*;
import ddf.minim.signals.*;

Minim minim;
AudioOutput out;
SineWave sine0;
SineWave sine1;
SineWave sine2;
SineWave sine3;


final int N_CHANNELS = 4;
final int BUFFER_SIZE = 220;
final float MAX_MICROVOLTS = 1682.815;
final float DISPLAY_SCALE = 200.0;
final color BG_COLOR = color(0, 0, 0);

final int PORT = 5000;
OscP5 oscP5 = new OscP5(this, PORT);


final float max_hz = 1760;
final float min_hz = 220;


float[][] buffer = new float[N_CHANNELS][BUFFER_SIZE];
int pointer = 0;

// ここから暫定画像用パラメータ
float h;  // 色パラメータ
float ellipseSize;  // 円の大きさ
//

void setup(){
  size(1000, 600);
  frameRate(30);
  smooth();
  }



  minim = new Minim(this);
  out = minim.getLineOut(Minim.STEREO);
  sine0 = new SineWave(261.6, 0.5, out.sampleRate());
  sine1 = new SineWave(329.6, 0.5, out.sampleRate());
  sine2 = new SineWave(392, 0.5, out.sampleRate());
  sine3 = new SineWave(493.9, 0.5, out.sampleRate());
  sine0.portamento(200);
  sine1.portamento(200);
  sine2.portamento(200);
  sine3.portamento(200);
  out.addSignal(sine0);
  out.addSignal(sine1);
  out.addSignal(sine2);
  out.addSignal(sine3);
  

}

void draw(){

    fill(h, 80, 80, 7);
    ellipse(width/2, height/2, ellipseSize, ellipseSize);
 
}


void oscEvent(OscMessage msg){
    float data;
    if(msg.checkAddrPattern("/muse/elements_alpha_relative")){
        float[] freq = new float[N_CHANNELS];
        for(int ch = 0; ch < N_CHANNELS; ch++){
            data = msg.get(ch).floatValue();
            data = (data - (MAX_MICROVOLTS / 2)) / (MAX_MICROVOLTS / 2); // -1.0 1.0
            buffer[ch][pointer] = data;

            freq[ch] = map(buffer[ch][pointer], -1, 1, min_hz, max_hz);
            switch (ch) {
                case 0:
                sine0.setFreq(freq[ch]);
                break;
            case 1:
                sine1.setFreq(freq[ch]);
                break;
            case 2:
                sine2.setFreq(freq[ch]);
                break;
            case 3:
                sine3.setFreq(freq[ch]);
                break;
            }
        }
        float maxFreq = 0;
        for (int ch = 0; ch < N_CHANNELS; ch++) {
            if (maxFreq < freq[ch]){
                maxFreq = freq[ch];
            }
        }
        h = map(maxFreq, min_hz, max_hz, 0, 180);
        ellipseSize = map(maxFreq, min_hz, max_hz, 0, width);

        pointer = (pointer + 1) % BUFFER_SIZE;
    }
}


void stop() {
    out.close();
    minim.stop();

    super.stop();
  }