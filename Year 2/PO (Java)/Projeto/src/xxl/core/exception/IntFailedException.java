package xxl.core.exception;

import pt.tecnico.uilib.menus.CommandException;
public class IntFailedException extends Exception{
    public IntFailedException() {
        super("Literal is not a number");
    }
}
