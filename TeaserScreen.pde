WarmingGeometry wg;
NoiseLines nls;
PastelStripes ps;
Template template;

PFont f;

void settings(){
  fullScreen(P2D);
  //size(720, 480, P2D);
}

void setup()
{
  // comment out for full screen
  surface.setSize(1280,720); // without window decoration for ZOOM screen sharing use.
   
  frameRate(30); // slower as possible
  wg = new WarmingGeometry(10, 40, 280);
  nls = new NoiseLines(12, 5);
  ps = new PastelStripes(25);
  template = new Template(40);

  //size(1280, 720, P2D);

  //fullScreen(P2D,1); // number of display

  int font_size = height/10;
  PFont f = createFont("Jaldi-Bold.ttf", font_size);  
  textFont(f); // 読み込んだフォント f を表示用テキストフォントに変更
  textLeading(font_size);
}
int size_of_effect = 4;


String title = "";
boolean flg_begin_workshop = false;
int kind_of_effect = (int)random((int)size_of_effect);


void draw()
{ 

  switch( kind_of_effect )
  {
  case -1: // Thumnail viewer
    background(0);
    drawThumbnails(3); // number of row 
    return;

  case 0:
    wg.draw();
    fill(100);
    break;
  case 1:
    nls.draw();
    fill(100);
    break;
  case 2:
    ps.draw();
    fill(100);
    break;
  case 3:
    template.draw();
    fill(100);
    break;
  }


  if ( !flg_begin_workshop ) {
    drawClock(width/2, height/4);
    // Draw Typed Message
    if ( title.length() > 0 ) {
      text(title, width/2, height/2);
    }
  } else {
    noStroke();
    fill(0, 0, 0, 150);
    rect(0, 0, width, height);
    fill(255);
    text("It's about to start...", width/2, height/2);
  }
}

void keyPressed()
{

  //println((int)keyCode);
  if (key == CODED) {  // UP, DOWN, LEFT, and RIGHT) as well as ALT, CONTROL, and SHIFT.

    if (keyCode == UP || keyCode == RIGHT) {
      kind_of_effect++;
      if ( kind_of_effect >= size_of_effect ) kind_of_effect = 0;
    } else if (keyCode == DOWN || keyCode == LEFT) {
      kind_of_effect--;
      if ( kind_of_effect < 0 )kind_of_effect = size_of_effect-1;
    }
  } else { // BACKSPACE, TAB, ENTER, RETURN, ESC, and DELETE and other keys
    if ( key == BACKSPACE ) {
      if ( title.length() > 0 ) {
        title = title.substring(0, title.length()-1);
      }
    } else if (keyCode == 97) { // F1
      flg_begin_workshop = !flg_begin_workshop;
    } else if ( keyCode == 106) { //F10: go to thumbnail mode
      kind_of_effect = -1;
    } else {
      title = title + str(key);
    }
  }
}

void drawThumbnails(int _number_of_div) {
  int number_of_div = _number_of_div;
  int margin_x = 20;
  int margin_y = 20;
  int grid_w = (width-(number_of_div+1)*margin_x)/number_of_div;
  int grid_h = (int)(grid_w*(9.0/16.0));
  
  //////////////////
  PGraphics canvas[] = {wg.canvas, nls.canvas, ps.canvas, template.canvas};
  
  wg.update();
  nls.update();
  ps.update();
  template.update();
  //////////////////
  
  // margin , margin+grid_w+margin, margin+grid_w+margin+grid_w+margin
  for ( int i = 0; i < canvas.length; i++ ) {
    Rectangle r = new Rectangle(margin_x+(i%number_of_div)*(grid_w+margin_x), 
      margin_y+(grid_h+margin_y)*(i/number_of_div), 
      grid_w, grid_h);

    image(canvas[i], 
      margin_x+(i%number_of_div)*(grid_w+margin_x), 
      margin_y+(grid_h+margin_y)*(i/number_of_div), 
      grid_w, grid_h);

    if ( r.inside(mouseX, mouseY) ) {
      fill(200, 150);
      rect(-5+margin_x+(i%number_of_div)*(grid_w+margin_x), 
        -5+margin_y+(grid_h+margin_y)*(i/number_of_div), 
        grid_w+10, grid_h+10);
      if ( mousePressed ) {          
        kind_of_effect = i;
      }
    }
  }
}

class Rectangle {
  Rectangle(int _x, int _y, int _w, int _h) {
    x = _x;
    y = _y;
    w = _w;
    h = _h;
  }
  boolean inside(int _x, int _y) {
    if ( _x > x && _x < x+w && _y > y && _y < y+h ) {
      return true;
    } else {
      return false;
    }
  }
  int x;
  int y;
  int w;
  int h;
}
