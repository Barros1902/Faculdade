package xxl.core;
import xxl.core.exception.IntFailedException;

public class Max extends RangeFunction {

	String _name = "MAX";

    Max(Gama gama) {
        super(gama);
    }
    @Override
    public String evalString() throws IntFailedException{
        int max = -190204; /*Numero usado por falta de tempo para fazer a verificação se existem literais inteiros*/

			        
        for (Cell cell : getCells()) {
            try{
                int numero = Integer.parseInt(cell.getContent().toString());
				if (numero > max){

					max = numero;
				}
            } catch (Exception e){
                continue;
            }
		if (max == -190204){
			return "#VALUE";
		}
        }
        return String.valueOf(max);
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
            return getValue().toString() + "=MAX(" + getGama().toString() + ")";
        } catch (Exception e) {
            return "#VALUE" + "=MAX(" + getGama().toString() + ")";
        }
    }
	
	@Override
	public void accept(ContentVisitor contentvisitor){

		contentvisitor.visitMax(this);
		
	}

	@Override
	public String getName(){

		return _name;
	}
}
