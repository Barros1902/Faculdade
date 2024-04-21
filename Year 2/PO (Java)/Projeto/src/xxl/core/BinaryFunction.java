package xxl.core;


import xxl.core.exception.ArrayCharException;
import xxl.core.exception.IntFailedException;

import javax.swing.text.AbstractDocument;

public abstract class BinaryFunction extends Function {

    Literals _value;
    private Content _arg1;
    private Content _arg2;
    public BinaryFunction(Content arg1, Content arg2) {
        _arg1 = arg1;
        _arg2 = arg2;
    }
	public void accept(ContentVisitor contentvisitor){

		contentvisitor.visitBinaryFunction(this);
	}

    @Override
    public void Observing() {}

    public Content getValueArg1(){
        return _arg1;
    }
    public Content getValueArg2(){
        return _arg2;
    }
    @Override
    public String evalString() throws IntFailedException {
        throw new IntFailedException();
    }
}
