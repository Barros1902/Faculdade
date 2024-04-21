/*function createTargets_old(legendas, target_size, horizontal_gap, vertical_gap) {
  legendas_sorted = legendas.getColumn('city');

  //HACK: #MARTELADA (Resolve o problema com o e com acento)
  legendas_sorted[62] = "Bechar";
  legendas_sorted = legendas_sorted.sort();
  legendas_sorted[27] = "Béchar";

  ids = sortIds(legendas, legendas_sorted);

  // Define the margins between targets by dividing the white space
  // for the number of targets minus one
  h_margin = horizontal_gap / (GRID_COLUMNS - 1);
  v_margin = vertical_gap / (GRID_ROWS - 1);

  // Set targets in a 8 x 10 grid
  for (var r = 0; r < GRID_ROWS; r++) {
    for (var c = 0; c < GRID_COLUMNS; c++) {
      let target_x = 40 + (h_margin + target_size) * c +
          target_size / 2;  // give it some margin from the left border
      let target_y = (v_margin + target_size) * r + target_size / 2;

      // Find the appropriate label and ID for this target
      let legendas_index = c + GRID_COLUMNS * r;
      let target_label = legendas_sorted[legendas_index];

      let target =
          new Target(target_x, target_y + 40, target_size, target_label, ids[legendas_index]);
      targets.push(target);
    }
  }
}*/


let training = false;
let disableClicks = true;

function myOnDraw()
{
  if (!training)
    return;

  exit_trial_button.position(width/2 - exit_trial_button.size().width/2, height/1.15);
}

function myOnClickPre()
{
  disableClicks = training;
}

function myOnClickPost()
{
  if (!training)
    return;

  disableClicks = false;

  for (var i = 0; i < legendas.getRowCount(); i++)
  {
    // Check if the user clicked over one of the targets
    if (targets[i].clicked(mouseX, mouseY)) 
    {
      current_trial++;              // Move on to the next trial/target
      if (current_trial >= 12)
      {
        current_trial = 0;
        randomizeTrials();
      }
      break;
    }
  }
}

function exitTraining()
{
  training = false;
  exit_trial_button.remove();
  current_trial = 0;
  randomizeTrials();
}

//Creates targets to be displayed on screen
//legendas - Table with all country data
//PPCM - Pixels Per CentiMeter
//screenWidth_px - Screen width in pixels
//screenHeight_px - Screen heght in pixels
function createTargets(legendas, PPCM, screenWidth_px, screenHeight_px) {
  //13 in 16:9 display = 16.18cm x 28.77cm
  //tgtWidth = 16.18cm / 13 = 1.244cm
  let target_amount = 13.0; //Number of target lines. DO NOT CHANGE
  let bottomBoxHeight_px = 40.0; //Size of requested target text. DO NOT CHANGE
  let realScreenHeight_cm = 16.18; //Actual physical screen height in cm, considering a 13 inch 16:9 display. DO NOT CHANGE
  let targetHeight_px = (PPCM * realScreenHeight_cm - bottomBoxHeight_px) / target_amount; //Total usable height divided by amount of targets

  let names = legendas.getColumn('city');

  //HACK: #MARTELADA //Resolve o problema com o 'e' com acento
  names[62] = "Bechar";
  names = names.sort();
  names[27] = "Béchar";

  ids = sortIds(legendas, names);
  
  let letras = ["", "", "A", "E",  "H", "I", "L", "N", "O", "", "R", "U", "Y"]; //
  let spaceLetter = 1.7 * PPCM;

  let splits = [9, 16, 27, 38, 41, 50, 51, 52, 56, 64, 69, 79]; //Targets per row (cumulative)
  let leftMargin = 3.0 * PPCM;  //Margin for left identifying letters
  let buttonTextMargin = 0.4 * PPCM;  //Margin to the text from the box
  let firstTimeThirdLetter = 1; //Teels If its the first word with equal second letter and different third letter
  
  for (let i = 0, line = 0, x = leftMargin; i < 80; i++)
  {
    if(i > 0 && names[i-1][2] != names[i][2]){ //If its the first word with equal second letter and different third letter adds a space
      x += PPCM * 0.5; //Adds the third letter separation
      firstTimeThirdLetter = 1;
    }
    if (i == splits[line])  //Finds a split increments line && resets x 
    {
      line++;
      x = leftMargin;
    }
    
    textFont('Courier New', 16);
    textStyle(NORMAL);
    
    let textWidth_px = textWidth(names[i]); //Calculate width of drawn text
    let targetWidth_px = 1.2 * buttonTextMargin + textWidth_px;  //Text + left and right margins
    let target = new Target(x, line * targetHeight_px, targetWidth_px, targetHeight_px, names[i], ids[i], i, firstTimeThirdLetter, PPCM);
    
    targets.push(target); //Add target to the target array
    x += targetWidth_px;  //Add the Width of the target to set the x for the next one
    firstTimeThirdLetter = 0; //Sets it to 0 to say the first word with equal second letter and different third letter is resolvec
  }

  for(let j = 0; j <= 12; j++){
    let letter = new Letter(spaceLetter, (j + 1) * targetHeight_px, letras[j], j, PPCM);
    letters.push(letter);
  }
}

//Sorts ids to match the sorted cities
//legendas - Table with all country data
//cities_sorted - Array with cities from legendas sorted by name alfabetical order
function sortIds(legendas, cities_sorted) {
	cities = legendas.getColumn('city') ;//unsorted cities for reference
	ids = Array(80) ;//array to hold sorted ids

  //Iterate through each sorted city
  for (var i = 0; i < 80; i++)
  {
    //Find unsorted city index
    for (var j = 0; j < 80; j++)
    {
      //If city name matches
      if (cities[j] == cities_sorted[i])
      {
        //Set corresponding index (+1 because id's start from 1)
        ids[i] = j + 1;
        break;
      }
    }
  }

  return ids;
}
