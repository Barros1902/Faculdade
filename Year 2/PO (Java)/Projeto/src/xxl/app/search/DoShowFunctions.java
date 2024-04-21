package xxl.app.search;

import java.util.List;

import pt.tecnico.uilib.menus.Command;
import xxl.core.Cell;
import xxl.core.HashMap;
import xxl.core.SortCells;
import xxl.core.SortFunctions;
import xxl.core.Spreadsheet;
// FIXME import classes

/**
 * Command for searching function names.
 */
class DoShowFunctions extends Command<Spreadsheet> {

  DoShowFunctions(Spreadsheet receiver) {
    super(Label.SEARCH_FUNCTIONS, receiver);
	addStringField("Tocompare", Message.searchFunction());


}

  @Override
  protected final void execute() {

	String Tocompare = stringField("Tocompare");
	List<Cell> cells = ((HashMap)_receiver.getRepresentation()).ShowFunctions(Tocompare);
	cells.sort(new SortFunctions());
	for (Cell celula : cells){
		_display.addLine(celula.toString());		
	}
	_display.display();


  }
}
