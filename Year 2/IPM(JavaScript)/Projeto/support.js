// Support variables & functions (DO NOT CHANGE!)

let student_ID_form, display_size_form, start_button;                  // Initial input variables
let student_ID, display_size, i_have_read_everything, trial_button;    // User input parameters
let exit_trial_button;

// Prints the initial UI that prompts that ask for student ID and screen size
function drawUserIDScreen()
{ 
  background(color(0,0,0));                                          // sets background to black
  i_have_read_everything = false;                                    // sets variable that checks if user read everything to false
  
  // Text prompt
  main_text = createDiv("Insert your student number and display size");
  main_text.id('main_text');
  main_text.position(10, 10);
  
  // Text Rules - Sorry foi a martelada, também vos adoro ;-; <333333
  sentence0 = createDiv("________________________________________________________________________________-");
  sentence0.id('main_text');
  sentence0.position(10, 115); 
  sentence1 = createDiv("Hi, we just want to let you know: ");
  sentence1.id('main_text');
  sentence1.position(10, 140);
  sentence2 = createDiv("-> When you start the Game, the TIMER WILL ONLY START when you click in");
  sentence2.id('main_text');
  sentence2.position(10, 180);
  sentence3 = createDiv("the first city, so please take your time to get familiar with the game :)");
  sentence3.id('main_text');
  sentence3.position(10, 203);
  sentence4 = createDiv("-> Words like 'Buenos Aires' will have the format:");
  sentence4.id('main_text');
  sentence4.position(10, 240);
  sentence5 = createDiv("Buenos");
  sentence5.id('main_text');
  sentence5.position(10, 265);
  sentence6 = createDiv("Aires");
  sentence6.id('main_text');
  sentence6.position(15, 285);
  sentence7 = createDiv("Dica ====>  manter especial atencao a terceira letra da palavra");
  sentence7.id('main_text');
  sentence7.position(15, 305);
  sentence8 = createDiv("Testing is advised   ====> ---------------------------------- Spend as much time as you wish :D ");
  sentence8.id('main_text');
  sentence8.position(77, 350);
  sentence8.style('color', 'red');

  // Input forms:
  // 1. Student ID
  let student_ID_pos_y_offset = main_text.size().height + 40;         // y offset from previous item
  
  student_ID_form = createInput('');                                 // create input field
  student_ID_form.position(200, student_ID_pos_y_offset);
  
  student_ID_label = createDiv("Student number (int)");              // create label
  student_ID_label.id('input');
  student_ID_label.position(10, student_ID_pos_y_offset);
  
  // 2. Display size
  let display_size_pos_y_offset = student_ID_pos_y_offset + student_ID_form.size().height + 20;
  
  display_size_form = createInput('');                              // create input field
  display_size_form.position(200, display_size_pos_y_offset);
  
  display_size_label = createDiv("Display size in inches");         // create label
  display_size_label.id('input');
  display_size_label.position(10, display_size_pos_y_offset);
  
  // 3. Read Everything buttom
  read_everything_button = createButton('I HAVE READ EVERYTHING');
  read_everything_button.mouseReleased(i_read_everything);
  read_everything_button.position(width/2 - read_everything_button.size().width/2, height/1.5 - read_everything_button.size().height/2);

  // 4. Test Run buttom
  trial_button = createButton('[=== TEST ONLY RUN ===]');
  trial_button.mouseReleased(testRun);
  trial_button.position(width/2 - trial_button.size().width/2, height/1.4 - trial_button.size().height/2);

  // 4. Start button
  start_button = createButton('START');
  start_button.mouseReleased(startTest);
  start_button.position(width/2 - start_button.size().width/2, height/1.2 - start_button.size().height/2);
}


// Verifies if the student ID is a number, and within an acceptable range
function validID()
{
  if(parseInt(student_ID_form.value()) < 200000 && parseInt(student_ID_form.value()) > 1000) return true
  else 
  {
    alert("Please insert a valid student number (integer between 1000 and 200000)");
	return false;
  }
}

// Verifies if the display size is a number, and within an acceptable range (>13")
function validSize()
{
  if (parseInt(display_size_form.value()) < 50 && parseInt(display_size_form.value()) >= 13) return true
  else
  {
    alert("Please insert a valid display size (between 13 and 50)");
    return false;
  }
}

function read_everything_check(){
    if (i_have_read_everything == true) return true
    else
    {
      alert("Please read everything, and good luck :)");
      return false;
    }
}

function i_read_everything(){
  i_have_read_everything = true;
}

function testRun(){
  training=true;
  if (!read_everything_check()) return;
  startTest();
  exit_trial_button = createButton('Start ACTUAL test');
  exit_trial_button.mouseReleased(exitTraining);
  exit_trial_button.position(0, 1*exit_trial_button.size().height);
  exit_trial_button.style('background-color', '#ff0000');
  exit_trial_button.style('font-size', '20px');
  exit_trial_button.style('font-weight', 'bold');
  exit_trial_button.style('color', '#000000');
  exit_trial_button.size(4*exit_trial_button.size().width, 1.5*exit_trial_button.size().height);

}

// Starts the test (i.e., target selection task)
function startTest()
{
  if (validID() && validSize() && read_everything_check())
  {
    // Saves student and display information
    student_ID = parseInt(student_ID_form.value());
    display_size = parseInt(display_size_form.value());

    // Deletes UI elements
    main_text.remove();
    sentence0.remove();
    sentence1.remove();
    sentence2.remove();
    sentence3.remove();
    sentence4.remove();
    sentence5.remove();
    sentence6.remove();
    sentence7.remove();
    sentence8.remove();
    student_ID_form.remove();
    student_ID_label.remove();
    display_size_form.remove();
    display_size_label.remove();
    start_button.remove();  
    read_everything_button.remove();
    trial_button.remove();

    // Goes fullscreen and starts test
    fullscreen(!fullscreen());
  }
}

// Randomize the order in the targets to be selected
function randomizeTrials()
{
  trials = [];      // Empties the array
    
  // Creates an array with random items from the "legendas" CSV
  for (var i = 0; i < NUM_OF_TRIALS; i++) trials.push(floor(random(legendas.getRowCount())));

  print("trial order: " + trials);   // prints trial order - for debug purposes
}
