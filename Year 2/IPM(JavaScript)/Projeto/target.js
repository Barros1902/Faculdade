// Target class
class Target {
  constructor(x, y, w, h, l, id, i, extraSpace, PPCM) {
    this.x = x;
    this.y = y;
    this.height = h;
    this.width = w;
    this.label = l;
    this.id = id;
    this.i = i;
    this.extraSpace = extraSpace;
    this.PPCM = PPCM;
  }

  //Called when mouse is pressed
  //Returns true if mouse is within the button area
  clicked(mouse_x, mouse_y) {
    if (disableClicks)
      return false;
    return this.mouseIsOverMe(mouse_x, mouse_y);
  }

  mouseIsOverMe(mouse_x, mouse_y) {
    if (mouse_x < this.x || mouse_y < this.y)
      return false;
    if (mouse_x > this.x + this.width || mouse_y > this.y + this.height)
      return false;
    return true;
  }

  //Draws the target (rectangle)
  //and its label
  draw() {
    //Set background color
    if (this.mouseIsOverMe(mouseX, mouseY)) { fill(90); }
    else { 
      if(this.i < 27){
        fill(color(174,32,18))
      }
      if(this.i < 38 && this.i >= 27){
        fill(color(204,88,3));
      }
      if(this.i < 41 && this.i >= 38){
        fill(color(248,150,30));
      }
      if(this.i < 50 && this.i >= 41){
        fill(color(0,127,95));
      }
      if(this.i < 51 && this.i >= 50){
        fill(color(1,79,134));
      }
      if(this.i < 52 && this.i >= 51){
        fill(color(106,76,147));
      }
      if(this.i < 56 && this.i >= 52){
        fill(color(87,204,153));
      }
      if(this.i < 69 && this.i >= 56){
        fill(color(255,93,143));
      }
      if(this.i < 79 && this.i >= 69){
        fill(color(165,56,96));
      }
      if(this.i < 80 && this.i >= 79){
        fill(color(156,102,68));
      }
    }

    //Draw target box
    rect(this.x, this.y, this.width, this.height);

    //Draw label
    textAlign(CENTER);
    textFont('Courier New', 16);
    textStyle(BOLD);
    fill(255);

    //Checks if extra space is needed because its the first word with that third letter
    if(this.extraSpace){ 
      textFont('Chalkboard SE', 22);
      textStyle(NORMAL);
      fill(color(255, 207, 0));
      text(this.label[2], this.x-PPCM*0.20, this.y + this.height / 2);
      fill(255);
      textFont('Courier New', 16);
      textStyle(BOLD);
    }

    //Checks if the word is composed of the separate words if so prints them in diffent lines
    let isTwoWorded = this.label.split(" ");
    if (isTwoWorded.length == 2){
      text(isTwoWorded[0], this.x + this.width / 2, this.y + this.height / 3);  //Printing first word
      text(isTwoWorded[1], this.x + this.width / 2, this.y + this.height/ (3/2)); //Printing second word
    }
    else{
      text(this.label, this.x + this.width / 2, this.y + this.height / 2);  //If theres only one word prints here
    }

  }
}
