package xxl.core;



import xxl.core.exception.ArrayCharException;

public class ADD extends BinaryFunction {

	String _name = "ADD";

    public ADD(Content arg1, Content arg2){
        super(arg1,arg2);
    }

    @Override
    public int evalInt() throws ArrayCharException {
        boolean isNULL = false;
        try{
            getValueArg1().evalString();
            isNULL = true;
        } catch (Exception e){
            isNULL= false;
        }

        try{
            if (!isNULL)
            {
                getValueArg2().evalString();
                isNULL = true;
            }
        }catch (Exception e){
            isNULL= false;
        }

        try {
            int val1 = getValueArg1().evalInt();
            int val2 = getValueArg2().evalInt();
            if (!isNULL){
                return val1+val2;
            }
            else
                throw new ArrayCharException();
        } catch(Exception e){
            throw new ArrayCharException();
        }
    }


    @Override
    protected Literals value(){
        return _value;
    }
    @Override
    public Content getContent() {
        return new ADD(getValueArg1(),getValueArg2());
    }


    @Override
    public String toString() {
        String Coords1 = null;
        String Coords2 = null;

        try {
            Coords1 = getValueArg1().CoordsString();
        } catch (Exception e) {
            try {
                Coords1 = String.valueOf(getValueArg1().evalInt());
            } catch (ArrayCharException ex) {
                throw new RuntimeException(ex);
            }
        }

        try {
            Coords2 = getValueArg2().CoordsString();
        } catch (Exception e) {
            try {
                Coords2 = String.valueOf(getValueArg2().evalInt());
            } catch (ArrayCharException ex) {
                throw new RuntimeException(ex);
            }
        }

        try {
            return String.valueOf(evalInt())+"=ADD("+Coords1+","+Coords2+")";
        } catch (Exception e) {
            return "#VALUE"+"=ADD("+Coords1+","+Coords2+")";
        }
    }

	@Override
	public void accept(ContentVisitor contentvisitor){

		contentvisitor.visitADD(this);

	}

	@Override
	public String getName(){

		return _name;
	}
}