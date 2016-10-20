import ddf.minim.*;
import ddf.minim.signals.*;

Minim minim;
AudioOutput out;
SineWave sine;

void setup() {
  minim = new Minim(this);
  out = minim.getLineOut(Minim.STEREO);
  sine = new SineWave(440, 0.5, out.sampleRate());
  sine.portamento(200);
  out.addSignal(sine);
}

void draw() {
}

void mouseMoved() {
  float freq = map(mouseY, 0, height, 1500, 60);
  sine.setFreq(freq);
  float pan = map(mouseX, 0, width, -1, 1);
  sine.setPan(pan);
}

void stop() {
  out.close();
  minim.stop();

  super.stop();
}