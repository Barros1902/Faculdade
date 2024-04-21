package xxl.core;


import xxl.core.exception.ArrayCharException;
import xxl.core.exception.IntFailedException;

import java.util.List;

public class Reference extends Content{
    private Literals _value;
    private Cell _cell;
    public Reference(Cell cell){
        _cell = cell;
        Observing();
    }


    @Override
    public void update() {
        if (get_cell() != null)
            get_cell().notifyObservers();
    }
    @Override
    public void Observing(){
        _cell.addObserver(this);
    }

    /**
     * Coords toString
     * */
    @Override
    public String toString() {
        if (!getValue().contains(";"))
            return getValue()+"="+_cell.getPoint();
        else {
            return getValue().split("\\=")[0]+"="+_cell.getPoint();
        }
    }

    @Override
    public String CoordsString() {
        return _cell.getPoint();
    }
    /**
     * return the value of the cell if it gets a Null value return #VALUE
     * */
    private String getValue(){
        try{
            if (_cell.getContent().evalInt()==0 && _cell.getContent().evalString()==null)
                return "#VALUE";
        } catch (Exception e){
            return _cell.getContent().toString();
        }
        return _cell.getContent().toString();
    }
    public Content getContent(){
        return this;
    }

    protected String valueString() {
        return _cell.getContent().toString();
    }

    @Override
    protected Literals value() {
        return (Literals) _cell.getContent();
    }
    /**
     * return the value of Num of the cell
     * */
    @Override
    public int evalInt() throws ArrayCharException {
        return _cell.evalInt();
    };
    /**
     * return the value of CharArray of the cell
     * */
    @Override
    public String evalString() throws IntFailedException {
        return _cell.evalString();
    };

	@Override
	public void accept(ContentVisitor contentvisitor){

		contentvisitor.visitReference(this);
		
	}


	@Override
	public String getName() {
		// TODO Auto-generated method stub
		throw new UnsupportedOperationException("Unimplemented method 'getName'");
	}
}