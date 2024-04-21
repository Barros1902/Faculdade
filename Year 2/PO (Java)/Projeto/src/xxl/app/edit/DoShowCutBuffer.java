package xxl.app.edit;

import pt.tecnico.uilib.menus.Command;
import xxl.core.Spreadsheet;
import xxl.core.CutBuffer;
// FIXME import classes

/**
 * Show cut buffer command.
 */
class DoShowCutBuffer extends Command<Spreadsheet> {

  DoShowCutBuffer(Spreadsheet receiver) {
    super(Label.SHOW_CUT_BUFFER, receiver);
  }
  
  @Override
  protected final void execute() {
	for (String text : CutBuffer.showCutBuffer()) {
		_display.addNewLine(text, false);
		_display.display();	
	}
  }
}
