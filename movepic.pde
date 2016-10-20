ArrayList<Kedama> list = new ArrayList<Kedama>();

void setup() {
 size(640, 320);

 for (int i=0; i<30; i++) {
 float r = random(40, 60);
 PVector p = new PVector(random(r, width-r), random(r, height-r));
 color c = color(random(255), random(255), random(255));
 list.add(new Kedama(p, r, c));
 }
}

void draw() {
 background(250);
 for (Kedama k : list) {
 k.update();
 k.draw();
 }
}

PVector gravity = new PVector(0, 1);

class Kedama {
 PVector pt;
 PVector dir;

 color clr;
 float rad;
 Kedama(PVector p, float r, color c) {
 pt = p;
 dir = new PVector(random(-3, 3), random(-2, 2));
 clr = c;
 rad = r;
 }
 void update() {
 if (pt.x-rad < 0 || pt.x+rad > width || pt.y-rad < 0 || pt.y+rad > height) {
 dir.mult(-1);
 } else {
 dir.add(gravity);
 }
 pt.add(dir);
 }

 void draw() {
 //body
 noStroke();
 fill(clr, 250);
 beginShape();
 PVector p = pt.get();
 for (float ang=0; ang<TWO_PI; ang += PI/360.0) {
 float r = rad + random(rad/10);
 p.x = pt.x + r * sin(ang);
 p.y = pt.y + r * cos(ang);

 vertex(p.x, p.y);
 }
 endShape();

 //eye
 fill(250);
 ellipse(pt.x-10, pt.y-20, 10, 10);
 ellipse(pt.x+10, pt.y-20, 10, 10);
 fill(50);
 ellipse(pt.x-10, pt.y-20, 3, 3);
 ellipse(pt.x+10, pt.y-20, 3, 3);
 }
}