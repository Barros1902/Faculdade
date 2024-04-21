package xxl.core;


import xxl.core.exception.IntFailedException;
import xxl.core.exception.ArrayCharException;
import java.util.List;
import java.util.ArrayList;

public abstract class Literals extends Content {



    public abstract String display();
    public abstract String toString();
    public String evalString() throws IntFailedException{
        throw new IntFailedException();
    }
    @Override
    public void Observing(){

    }
    public int evalInt() throws  ArrayCharException{
        throw new ArrayCharException();
    }

}
