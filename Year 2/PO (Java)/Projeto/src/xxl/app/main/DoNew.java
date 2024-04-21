package xxl.app.main;

import java.io.Serializable;

import pt.tecnico.uilib.forms.Form;
import pt.tecnico.uilib.menus.Command;
import pt.tecnico.uilib.menus.CommandException;
import xxl.core.Calculator;
import xxl.core.CutBuffer;
import xxl.core.exception.OutOfBoundsException;


/**
 * Open a new file.
 */
class DoNew extends Command<Calculator> {

  DoNew(Calculator receiver) {
    super(Label.NEW, receiver);
  }
  
  @Override
  protected final void execute() throws CommandException{
	/*Verifies if theres is a spreadsheet if it was changed and if you want to keep the changes */
	CutBuffer.delete();
	if (_receiver.getSpreadsheet() != null && _receiver.getSpreadsheet().getChanged() && Form.confirm(Message.saveBeforeExit())){

		new DoSave(_receiver).performCommand(); /* Saves it to save it */
	}

	int height = Form.requestInteger(Message.lines());
	int width = Form.requestInteger(Message.columns());
    _receiver.createSpreadSheet(width, height); /* Creates the spreadsheet with specified measures */


  }
}
