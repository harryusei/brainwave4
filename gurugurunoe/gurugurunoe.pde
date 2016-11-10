import ddf.minim.analysis.*;
import ddf.minim.*;
int BUFSIZE = 512;
Minim minim; // Minimのインスタンス 
AudioInput in;  // オーディオプレイヤー 
FFT fft; // FFT解析のインスタンス
float[] rot = new float[BUFSIZE]; //角度を保存 
float[] rotSpeed = new float[BUFSIZE]; //角速度
void setup() {
// 画面の初期設定
size(800, 800, P3D);
frameRate(60);
colorMode(HSB, 360, 100, 100, 100);
// Minimの初期化
minim = new Minim(this);
// サウンドファイル再生
in = minim.getLineIn(Minim.STEREO, BUFSIZE); 
// FFT初期設定
fft = new FFT(in.bufferSize(), in.sampleRate());  // 角度と角速度を初期化
for (int i = 0; i < BUFSIZE; i++) {
rot[i] = 0;
        rotSpeed[i] = 0;
    }
    background(0);
}
void draw() {
// 画面をフェードさせる
backgroundFade();
// 色を加算合成に
blendMode(ADD);
// 画面の中心を基準点に
translate(width/2, height/2);
// FFT解析実行
fft.forward(in.left);
// グラフで描画
for (int i = 0; i < fft.specSize(); i++) {
        float h = map(i, 0, fft.specSize(), 0, 100);
        float x = map(i, 0, fft.specSize(), 0, width);
        float size = map(fft.getBand(i), 0, 1.0, 0, 0.2);
        rotSpeed[i] = size;
        rot[i] += rotSpeed[i];
        pushMatrix();
        rotate(radians(rot[i]));
        fill(h, 80, 100, 100);
        ellipse(x, 0, size, size);
        popMatrix();
} }
// 画面をフェードさせる関数 
void backgroundFade() {
    blendMode(BLEND);
    noStroke();
    fill(0, 0, 0, 5);
    rect(0, 0, width, height);
}