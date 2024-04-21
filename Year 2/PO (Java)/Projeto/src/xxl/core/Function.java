package xxl.core;

public abstract class Function extends Content{

    @Override
    public abstract void Observing();
    public abstract void accept(ContentVisitor contentVisitor);
    public abstract String getName();
}
