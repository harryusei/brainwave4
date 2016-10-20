
import oscP5.*;
import netP5.*;
import ddf.minim.*;
import ddf.minim.signals.*;

Minim minim;
AudioOutput out;
SineWave sine;


final int N_CHANNELS = 4;
final int BUFFER_SIZE = 220;
final float MAX_MICROVOLTS = 1682.815;
final float DISPLAY_SCALE = 200.0;
final String[] LABELS = new String[] {
  "TP9", "FP1", "FP2", "TP10"
};

final color BG_COLOR = color(0, 0, 0);
final color AXIS_COLOR = color(255, 0, 0);
final color GRAPH_COLOR = color(0, 0, 255);
final color LABEL_COLOR = color(255, 255, 0);
final int LABEL_SIZE = 21;

final int PORT = 5000;
OscP5 oscP5 = new OscP5(this, PORT);


final float max_hz = 1760;
final float min_hz = 220;


float[][] buffer = new float[N_CHANNELS][BUFFER_SIZE];
int pointer = 0;
float[] offsetX = new float[N_CHANNELS];
float[] offsetY = new float[N_CHANNELS];


void setup(){
  size(1000, 600);
  frameRate(30);
  smooth();
  for(int ch = 0; ch < N_CHANNELS; ch++){
    offsetX[ch] = (width / N_CHANNELS) * ch + 15;
    offsetY[ch] = height / 2;
  }



  minim = new Minim(this);
  out = minim.getLineOut(Minim.STEREO);
  sine = new SineWave(440, 0.5, out.sampleRate());
  sine.portamento(200);
  out.addSignal(sine);

}

void draw(){

  //この中に，画像の処理を書く
  
}

void oscEvent(OscMessage msg){
  float data;
  if(msg.checkAddrPattern("/muse/eeg")){
    for(int ch = 0; ch < N_CHANNELS; ch++){
      data = msg.get(ch).floatValue();
      data = (data - (MAX_MICROVOLTS / 2)) / (MAX_MICROVOLTS / 2); // -1.0 1.0
      buffer[ch][pointer] = data;


      float freq = map(mouseY, -1, 1, min_hz, max_hz);
      sine.setFreq(freq);
    }
    pointer = (pointer + 1) % BUFFER_SIZE;
  }

}


void stop() {
    out.close();
    minim.stop();

    super.stop();
  }