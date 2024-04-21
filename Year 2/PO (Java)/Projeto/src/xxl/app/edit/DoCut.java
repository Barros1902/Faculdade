package xxl.app.edit;

import pt.tecnico.uilib.menus.Command;
import pt.tecnico.uilib.menus.CommandException;
import xxl.core.Spreadsheet;
import xxl.core.exception.OutOfBoundsException;
import xxl.app.exception.InvalidCellRangeException;
import xxl.core.CutBuffer;
// FIXME import classes
import xxl.core.Gama;

/**
 * Cut command.
 */
class DoCut extends Command<Spreadsheet> {

  DoCut(Spreadsheet receiver) {
    super(Label.CUT, receiver);
	addStringField("range", Message.address());
    // FIXME add fields
  }
  
  @Override
  protected final void execute() throws CommandException {
    // FIXME implement command
	String range = stringField("range");
	try {
      Gama gama = _receiver.createRange(range);
	  CutBuffer cutbuffer = CutBuffer.cut(gama);
    } catch (OutOfBoundsException e) {
      throw new InvalidCellRangeException(range);
	
    }
  }
}
