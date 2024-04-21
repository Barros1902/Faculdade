package xxl.app.edit;

import pt.tecnico.uilib.menus.Command;
import pt.tecnico.uilib.menus.CommandException;
import xxl.app.exception.InvalidCellRangeException;
import xxl.core.Cell;
import xxl.core.Spreadsheet;
import xxl.core.exception.OutOfBoundsException;
import xxl.core.Gama;

import java.util.ArrayList;
// FIXME import classes

/**
 * Class for searching functions.
 */
class DoShow extends Command<Spreadsheet> {

  DoShow(Spreadsheet receiver) {
    super(Label.SHOW, receiver);
    addStringField("range", Message.address());
    // FIXME add fields
  }
  
  @Override
  protected final void execute() throws CommandException, InvalidCellRangeException {
    String range = stringField("range");
    try {
      Gama gama = _receiver.createRange(range);

      ArrayList<Cell> listCells = (ArrayList<Cell>) gama.getCellsNoCopy();
        for (Cell cell : listCells) {
            _display.addLine(cell.toString());
			
        }
		
        _display.display();

    } catch (OutOfBoundsException e) {
      throw new InvalidCellRangeException(range);
    }
  }
}
