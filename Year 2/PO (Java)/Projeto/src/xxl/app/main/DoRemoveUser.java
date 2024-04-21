package xxl.app.main;

import java.util.ArrayList;

import pt.tecnico.uilib.forms.Form;
import pt.tecnico.uilib.menus.Command;
import pt.tecnico.uilib.menus.CommandException;
import xxl.core.Calculator;
import xxl.core.User;



/**
 * Open menu.
 */
class DoRemoveUser extends Command<Calculator> {
  DoRemoveUser(Calculator receiver) {
    super(Label.REMOVE_USER, receiver);
	addStringField("User", Message.removeuser());

  }
  
  @Override
  protected final void execute() throws CommandException {
    ArrayList<User> Notremovedusers = new ArrayList<User>();
	String UserString = stringField("User");
		for (User user : _receiver.getUsers()){
			if(user.getName().contains(UserString))
				continue;
			
			Notremovedusers.add(user);

		}
	_receiver.newUsers(Notremovedusers);
	
  }
}