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

  minim = new Minim(this);
  out = minim.getLineOut(Minim.STEREO);
  sine0 = new SineWave(261.6, 0.5, out.sampleRate());
  sine1 = new SineWave(0, 0.5, out.sampleRate());
  sine2 = new SineWave(0, 0.5, out.sampleRate());
  sine3 = new SineWave(0, 0.5, out.sampleRate());
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
  if(msg.checkAddrPattern("/muse/elements/alpha_relative")){
    for(int ch = 0; ch < N_CHANNELS; ch++){
      data = msg.get(ch).floatValue();
      buffer[ch][pointer] = data;
      float freq = map(buffer[ch][pointer], 0, 1, min_hz, max_hz);
      print(ch + "-" + freq + "  ");
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
  
  
  
  
  
/*
//idea of filtering in "oscEvent"


void oscEvent(OscMessage msg){
  float data;
  if(msg.checkAddrPattern("/muse/elements/alpha_relative")){
    for(int ch = 0; ch < N_CHANNELS; ch++){
      data = msg.get(ch).floatValue();
      buffer[ch][pointer] = data;
      float freq = map(buffer[ch][pointer], 0, 1, min_hz, max_hz);
      print(ch + "-" + freq + "  ");

          sine0.setFreq(freq); //should write below?
    }

    if (p >= 4) {
      y[p-2] = (y[p-4] + ... + y[p])/5;
      sine1.setFreq(y[p-2]);
    }
    else {
      y[p] = y[p];
    } 

    pointer = (pointer + 1) % BUFFER_SIZE;
    p++;
  }

}

*/