package xxl.app.edit;

import java.util.ArrayList;

import pt.tecnico.uilib.menus.Command;
import pt.tecnico.uilib.menus.CommandException;
import xxl.app.exception.InvalidCellRangeException;
import xxl.core.Cell;
import xxl.core.CutBuffer;
import xxl.core.Gama;
import xxl.core.Spreadsheet;
// FIXME import classes
import xxl.core.exception.OutOfBoundsException;

/**
 * Copy command.
 */
class DoCopy extends Command<Spreadsheet> {

  DoCopy(Spreadsheet receiver) {
    super(Label.COPY, receiver);
	addStringField("range", Message.address());

  }
  
  @Override
  protected final void execute() throws CommandException {
	String range = stringField("range");
	try {
      Gama gama = _receiver.createRange(range);
	  CutBuffer cutbuffer = CutBuffer.copy(gama);
    } catch (OutOfBoundsException e) {
      throw new InvalidCellRangeException(range);

  }
 }
}