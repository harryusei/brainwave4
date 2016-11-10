import ddf.minim.*; 
 
Minim minim; 
AudioPlayer player;
int waveH = 100; 
 
void setup()
{
  size(512, 200);
 
  minim = new Minim(this);
 

  player = minim.loadFile("groove.mp3", 512);
  player.play();
}
 
void draw()
{
  background(0);
  stroke(255);
  

  for(int i = 0; i < player.left.size()-1; i++)
  {
    point(i, 50 + player.left.get(i)*waveH); 
    point(i, 150 + player.right.get(i)*waveH); 
  }
}
 
void stop()
{
  player.close();
  minim.stop();
 
  super.stop();
}