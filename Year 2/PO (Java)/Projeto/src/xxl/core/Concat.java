package xxl.core;

import xxl.core.exception.IntFailedException;

import java.util.Objects;

public class Concat extends RangeFunction {

	String _name = "CONCAT";

    Concat(Gama gama) {
        super(gama);
    }
    @Override
    public String evalString() throws IntFailedException{
        //TODO: implement this
        StringBuilder concat = new StringBuilder();
        concat.append("'");
        for (Cell cell : getCells()) {
            try{
                concat.append(cell.evalString().substring(1));
            } catch (Exception e){
                continue;
            }

        }
        return concat.toString();
    }
    public Literals value(){
        try {
            return new CharArray(evalString());
        } catch (Exception e) {
            return null;
        }
    }
    @Override
    public Content getContent() {
        return new Concat(getGama().copy());
    }
    public String toString(){

        try {
            return getValue().toString() + "=CONCAT(" + getGama().toString() + ")";
        } catch (Exception e) {
            return "#VALUE" + "=CONCAT(" + getGama().toString() + ")";
        }
    }

	@Override
	public void accept(ContentVisitor contentvisitor){

		contentvisitor.visitConcat(this);
		
	}

	@Override
	public String getName(){

		return _name;
	}
}

