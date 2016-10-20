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

  //Write image process code here
  
}


void oscEvent(OscMessage msg){
  float data;
  if(msg.checkAddrPattern("/muse/eeg")){
    for(int ch = 0; ch < N_CHANNELS; ch++){
      data = msg.get(ch).floatValue();
      data = (data - (MAX_MICROVOLTS / 2)) / (MAX_MICROVOLTS / 2); // -1.0 1.0
      buffer[ch][pointer] = data;


      float freq = map(buffer[ch][pointer], -1, 1, min_hz, max_hz);
      switch (ch) {
        case 0:
          sine0.setFreq(freq);
          break;
        case 1:
          sine1.setFreq(freq);
          break;
        case 2:
          sine2.setFreq(freq);
          break;
        case 3:
          sine3.setFreq(freq);
          break;
      }
    }
    pointer = (pointer + 1) % BUFFER_SIZE;
  }

}


void stop() {
    out.close();
    minim.stop();

    super.stop();
  }