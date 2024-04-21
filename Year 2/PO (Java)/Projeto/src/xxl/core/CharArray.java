package xxl.core;

import xxl.core.exception.ArrayCharException;
import xxl.core.exception.IntFailedException;

public class CharArray extends Literals{
    private final String _value;
    public CharArray(String value){
        _value = value;
    }

    @Override
    public Content getContent() {
        return new CharArray(_value);
    }

    @Override
    public String display(){
        return _value;
    }
    @Override
    public String toString(){
        return _value;
    }

    @Override
    protected Literals value() {
        return null;
    }


    @Override
    public String evalString(){
        return _value;
    }

	@Override
	public void accept(ContentVisitor contentvisitor){

		contentvisitor.visitCharArray(this);
		
	}

	@Override
	public String getName() {
		// TODO Auto-generated method stub
		throw new UnsupportedOperationException("Unimplemented method 'getName'");
	}
}