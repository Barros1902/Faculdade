package xxl.app.edit;

import pt.tecnico.uilib.menus.Command;
import pt.tecnico.uilib.menus.CommandException;
import xxl.app.exception.InvalidCellRangeException;
import xxl.core.CutBuffer;
import xxl.core.Gama;
import xxl.core.Spreadsheet;
// FIXME import classes
import xxl.core.exception.OutOfBoundsException;

/**
 * Paste command.
 */
class DoPaste extends Command<Spreadsheet> {

  DoPaste(Spreadsheet receiver) {
    super(Label.PASTE, receiver);
    addStringField("range", Message.address());
  }
  
  @Override
  protected final void execute() throws CommandException {
    String range = stringField("range");
	try {
      Gama gama = _receiver.createRange(range);
	  CutBuffer.paste(gama);
    } catch (OutOfBoundsException e) {
      throw new InvalidCellRangeException(range);
	
    }
  }

}

