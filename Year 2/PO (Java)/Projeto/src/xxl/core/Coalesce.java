package xxl.core;

import xxl.core.exception.IntFailedException;

import java.util.Objects;

public class Coalesce extends RangeFunction {

	String _name = "COALESCE";
    Coalesce(Gama gama) {
        super(gama);
    }
    public String evalString() throws IntFailedException {
        String result = "";
        for (Cell cell : getCells()) {
            try{
                if (verifyIsNull(cell)){
                    continue;
                }
                result= cell.evalString();
                break;
            } catch (Exception e){
                //Do nothing
            }

        }
        return result;
    }
    @Override
    public Content getContent() {
        return new Coalesce(getGama().copy());
    }
    public String toString(){
        if (Objects.equals(getValue().toString(), "")){
            return "'" + "=COALESCE(" + getGama().toString() + ")";
        }
        try {
            return getValue().toString() + "=COALESCE(" + getGama().toString() + ")";
        } catch (Exception e) {
            return "#VALUE" + "=COALESCE(" + getGama().toString() + ")";
        }
    }

    public Literals value(){
        try {
            return new CharArray(evalString());
        } catch (Exception e) {
            return null;
        }
    }

	@Override
	public void accept(ContentVisitor contentvisitor){

		contentvisitor.visitCoalesce(this);
		
	}

	@Override
	public String getName(){

		return _name;
	}

}

