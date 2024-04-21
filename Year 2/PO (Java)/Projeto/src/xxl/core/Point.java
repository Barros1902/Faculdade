package xxl.core;

import java.io.Serializable;

public class Point implements Serializable {
	private static final long serialVersionUID = 202310131023L;
    private int _row;
    private int _column;

    public Point(int row, int column){
        _row = row;
        _column = column;
    }

    public Point getPoint(){
        return new Point(_row,_column);
    }
    public String toString(){
        return String.valueOf(_row)+";"+String.valueOf(_column);
    }
    public int getRow(){
        return _row;
    }
    public int getColumn(){
        return _column;
    }
}
