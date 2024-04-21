package xxl.app.edit;

import java.util.ArrayList;

import pt.tecnico.uilib.menus.Command;
import pt.tecnico.uilib.menus.CommandException;
import xxl.app.exception.InvalidCellRangeException;
import xxl.app.exception.UnknownFunctionException;
import xxl.core.Cell;
import xxl.core.Content;
import xxl.core.Gama;
import xxl.core.Spreadsheet;
import xxl.core.Parser;
import xxl.core.exception.OutOfBoundsException;
import xxl.core.exception.UnrecognizedEntryException;

/**
 * Class for inserting data.
 */
class DoInsert extends Command<Spreadsheet> {

  DoInsert(Spreadsheet receiver) {
    super(Label.INSERT, receiver);
	addStringField("range", Message.address());
	addStringField("content", Message.contents());
    // FIXME add fields
  }
  
  @Override
  protected final void execute() throws CommandException {
	_receiver.setChanged(true);
	Parser _parser = new Parser(_receiver);
	String range = stringField("range");
	String content = stringField("content");
	Content conteudo = null;
	try {
		conteudo = _parser.parseContent(content);
	} catch (OutOfBoundsException  | UnrecognizedEntryException e) {
		// TODO Auto-generated catch block
		e.printStackTrace();
	}

	try {
      Gama gama = _receiver.createRange(range);

      ArrayList<Cell> listCells = (ArrayList<Cell>) gama.getCellsNoCopy();
        for (Cell cell : listCells) {
            cell.setContent(conteudo);
			
        }

    } catch (OutOfBoundsException e) {
      throw new InvalidCellRangeException(range);
    }
    // FIXME implement command
  }
}
