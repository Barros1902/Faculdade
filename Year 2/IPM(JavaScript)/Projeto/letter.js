class Letter{
    constructor(x, y, l, id, PPCM) {
        this.x = x;
        this.y = y;
        this.letter = l;
        this.id = id;
        this.PPCM = PPCM;
      }

    drawLetter(){
        //Draw label
        textAlign(CENTER);
        textFont('Chalkboard SE');
        textSize(55);
        textStyle(BOLD);

        if(this.id == 2){
            textSize(120);
            fill(color(174,32,18));
            text(this.letter, this.x, this.y-.9*PPCM);
        }
        if(this.id == 3){ 
            fill(color(204,88,3));
            text(this.letter, this.x, this.y-.17*PPCM);
        }
        if(this.id == 4){ 
            fill(color(248,150,30));
            text(this.letter, this.x, this.y-.17*PPCM);
        }
        if(this.id == 5){
            fill(color(0,127,95));
            text(this.letter, this.x, this.y-.17*PPCM);
        }
        if(this.id == 6){
            fill(color(1,79,134));
            text(this.letter, this.x, this.y-.17*PPCM);
        }
        if(this.id == 7){
            fill(color(106,76,147));
            text(this.letter, this.x, this.y-.17*PPCM);
        }
        if(this.id == 8){
            fill(color(87,204,153));
            text(this.letter, this.x, this.y-.17*PPCM);
        }
        if(this.id == 10){
            textSize(90);
            fill(color(255,93,143));
            text(this.letter, this.x, this.y-.5*PPCM);
        }
        if(this.id == 11){
            fill(color(165,56,96));
            text(this.letter, this.x, this.y-.17*PPCM);
        }
        if(this.id == 12){
            fill(color(156,102,68));
            text(this.letter, this.x, this.y-.17*PPCM);
        }
    }

}
