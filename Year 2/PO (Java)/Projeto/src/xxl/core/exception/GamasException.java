package xxl.core.exception;

public class GamasException extends Exception{
    public GamasException(String coords){
        super(String.format("Operação inválida: A gama '%s' é inválida.", coords));}
}
