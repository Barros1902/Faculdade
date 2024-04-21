package xxl.core;

import xxl.core.exception.ArrayCharException;
import xxl.core.exception.IntFailedException;

import java.util.List;

public abstract class RangeFunction extends Function{
    Literals _value;

    private Gama _gama;
    RangeFunction(Gama gama){
        _gama = gama;
        Observing();
        update();
    }
    public Gama getGama(){
        return _gama;
    }

    public Literals getValue(){
        return _value;
    }
    @Override
    public void Observing() {
        try {
            List<Cell> cells = _gama.getCellsNoCopy();
            for(Cell cell : cells){
                cell.addObserver(this);
            }
        } catch (Exception e) {
            //Do nothing
        }
    }

    @Override
    public void update() {
        _value = value();
    }


    @Override
    public int evalInt() throws ArrayCharException {
        throw new ArrayCharException();
    }

    @Override
    public String evalString() throws IntFailedException {
        throw new IntFailedException();
    }

    @Override
    public String toString() {
        return null;
    }

    protected List<Cell> getCells(){
        try{
            return _gama.getCells();
        } catch (Exception e){
            return null;
        }
    }
    public boolean verifyInputBasic(){
        if(getCells()==null){
            return true;
        }
        return getCells().isEmpty();
    }
    public boolean verifyInputInt() {
        if (verifyInputBasic()) {
            return true;
        }
        for (Cell cell : getCells()) {
            try {
                cell.evalInt();
            } catch (ArrayCharException e) {
                return true;
            }
        }
        return false;
    }
    public boolean verifyInputString(){
        if(verifyInputBasic()){
            return false;
        }
        for (Cell cell : getCells()) {
            try {
                cell.evalString();
            } catch (IntFailedException e) {
                return false;
            }
        }
        return true;
    }
    public boolean verifyIsNull(Cell cell){
        boolean result = false;
        try {
            cell.getContent().evalString();
            cell.getContent().evalInt();
            result = true;
        } catch (Exception e) {
            //Do nothing
        }

        return result;
	}
	
		public void accept(ContentVisitor contentvisitor){

			contentvisitor.visitRangeFunction(this);
		}
    
}
