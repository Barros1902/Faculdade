package xxl.core;

import java.io.Serializable;

public abstract class Representation implements Serializable{
	private static final long serialVersionUID = 202310121901L;
    private final int _width;
    private final int _height;

    public Representation(int width, int height){
        _width = width;
        _height = height;
    }
    /**
     * @return the width of the representation
     */
    public int getWidth(){
        return _width;
    }
    /**
     * @return the height of the representation
     */
    public int getHeight(){
        return _height;
    }
    /**
     * @return if the row/column is out of bounds
     */
    public Boolean outOfBounds(int row, int column){
        return row > _width || column > _height || row <= 0 || column <= 0;
    }
    public abstract void insertContent(int row, int column, Content content);
    public abstract void setCell(int row, int column, Content content);
    public abstract void removeContent(int row, int column);


    public abstract Cell getCell(int row, int column);
}
