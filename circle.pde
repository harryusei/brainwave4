import ddf.minim.analysis.*;
import ddf.minim.*;
int BUFSIZE = 512;
Minim minim;
AudioInput in; 
FFT fft; 
void setup() {
    size(1024, 400);

minim = new Minim(this);

in = minim.getLineIn(Minim.STEREO, BUFSIZE); 
fft = new FFT(in.bufferSize(), in.sampleRate()); 
fft.window(FFT.HAMMING);
    colorMode(HSB, 360, 100, 100, 100);
    noStroke();
}

void draw() {
    background(0);
    fft.forward(in.left);
    for (int i = 0; i < fft.specSize(); i++) {
        float h = map(i, 0, fft.specSize(), 0, 180);
        float ellipseSize = map(fft.getBand(i), 0, BUFSIZE/16, 0, width);
        float x = map(i, 0, fft.specSize(), width/2, 0);
        float w = width / float(fft.specSize()) / 2;
        fill(h, 80, 80, 7);
        ellipse(x, height/2, ellipseSize, ellipseSize);
}
    fft.forward(in.right);
    for (int i = 0; i < fft.specSize(); i++) {
        float h = map(i, 0, fft.specSize(), 0, 180);
        float ellipseSize = map(fft.getBand(i), 0, BUFSIZE/16, 0, width);
        float x = map(i, 0, fft.specSize(), width/2, width);
        float w = width / float(fft.specSize()) / 2;
        fill(h, 80, 80, 7);
        ellipse(x, height/2, ellipseSize, ellipseSize);
} }
void stop() {
    minim.stop();
    super.stop();
}