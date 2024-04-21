package xxl.app.main;

import pt.tecnico.uilib.forms.Form;
import pt.tecnico.uilib.menus.Command;
import pt.tecnico.uilib.menus.CommandException;
import xxl.app.exception.FileOpenFailedException;
import xxl.core.Calculator;
import xxl.core.CutBuffer;
import xxl.core.exception.MissingFileAssociationException;
import xxl.core.exception.UnavailableFileException;

import java.io.File;
import java.io.FileNotFoundException;
import java.io.IOException;
// FIXME import classes

/**
 * Open existing file.
 */
class DoOpen extends Command<Calculator> {

  DoOpen(Calculator receiver) {
    super(Label.OPEN, receiver);
	

    
  }
  
  @Override
  protected final void execute() throws CommandException, FileOpenFailedException {
	/*Verifies if theres is a spreadsheet if it was changed and if you want to keep the changes */
	CutBuffer.delete();
	if (_receiver.getSpreadsheet() != null && _receiver.getSpreadsheet().getChanged() && Form.confirm(Message.saveBeforeExit())){

		new DoSave(_receiver).performCommand(); /* Saves it to save it */
	}
    try {
	  addStringField("filename", Message.openFile()); /* Ask the name of the file you want to open  */
      String nameSaveAs= stringField("filename");
      _receiver.load(nameSaveAs); /* Load the file */
    }
    catch (IOException | MissingFileAssociationException | UnavailableFileException e){
        
        throw new FileOpenFailedException(e);
    }
  }
}
