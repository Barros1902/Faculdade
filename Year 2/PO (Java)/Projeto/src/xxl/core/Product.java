package xxl.core;

import xxl.core.exception.ArrayCharException;

public class Product extends RangeFunction {

	String _name = "PRODUCT";
    Product(Gama gama) {
        super(gama);
    }
    private Literals value;
    @Override
    public int evalInt() throws ArrayCharException {
        if (verifyInputInt()) {
            throw new ArrayCharException();
        }

        int prod = 1;
        for (Cell cell : getCells()) {
            if (verifyIsNull(cell)){
                throw new ArrayCharException();
            }
            prod *= cell.evalInt();
        }
        return prod;
    }
    @Override
    public Content getContent() {
        return new Product(getGama().copy());
    }

    public Literals value(){
        try {
            return new Num(evalInt());
        } catch (Exception e) {
            return null;
        }
    }

    @Override
    public String toString() {
        try {
            return getValue().toString() + "=PRODUCT(" + getGama().toString() + ")";
        } catch (Exception e) {
            return "#VALUE" + "=PRODUCT(" + getGama().toString() + ")";
        }
    }

	@Override
	public void accept(ContentVisitor contentvisitor){

		contentvisitor.visitProduct(this);
		
	}

	@Override
	public String getName(){

		return _name;
	}
}

