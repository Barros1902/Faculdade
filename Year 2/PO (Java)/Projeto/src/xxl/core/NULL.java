package xxl.core;

public class NULL extends Literals{

    @Override
    public String evalString(){
        return null;
    }
    @Override
    public Content getContent(){
        return new NULL();
    }
    @Override
    protected Literals value() {
        return null;
    }

    @Override
    public int evalInt() {
        return 0;
    }

    @Override
    public String display(){
        return "#VALUE";
    }
    @Override
    public String toString(){
        return "";
    }

	@Override
	public void accept(ContentVisitor contentvisitor){

		contentvisitor.visitNull(this);
		
	}
	@Override
	public String getName() {
		// TODO Auto-generated method stub
		throw new UnsupportedOperationException("Unimplemented method 'getName'");
	}
}
