package xxl.app.search;

import pt.tecnico.uilib.menus.Command;
import xxl.core.Spreadsheet;
import xxl.core.HashMap;
import xxl.core.Cell;
import java.util.List;
import xxl.core.SortCells;


// FIXME import classes

/**
 * Command for searching content values.
 */
class DoShowValues extends Command<Spreadsheet> {

  DoShowValues(Spreadsheet receiver) {
    super(Label.SEARCH_VALUES, receiver);
	addStringField("Tocompare", Message.searchValue());
  }
  
  @Override
  protected final void execute() {
	String Tocompare = stringField("Tocompare");
    List<Cell> cells = ((HashMap)_receiver.getRepresentation()).ShowValues(Tocompare);
	cells.sort(new SortCells());

	for (Cell celula : cells){
		_display.addLine(celula);		
	}
	_display.display();
  }
}
