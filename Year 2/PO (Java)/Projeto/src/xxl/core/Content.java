package xxl.core;

import xxl.core.exception.ArrayCharException;
import xxl.core.exception.CoordsException;
import xxl.core.exception.IntFailedException;

import java.io.Serializable;

public abstract class Content implements Serializable,Observer{
    private Cell _cell;

	private static final long serialVersionUID = 202310121846L;
	public abstract String getName();
    public Cell get_cell() {
        return _cell;
    }

    @Override
    public void update() {

    }
    public void setCell(Cell cell){
        _cell=cell;
    }


    @Override
    public void detach() {

    }


    protected abstract Literals value();
    public abstract int evalInt() throws ArrayCharException;
    public abstract String evalString() throws IntFailedException;
    public abstract String toString();

    public abstract Content getContent();

    public String CoordsString() throws CoordsException {
        throw new CoordsException();
    }
    public abstract void Observing();

	public abstract void accept(ContentVisitor contentvisitor); 
}