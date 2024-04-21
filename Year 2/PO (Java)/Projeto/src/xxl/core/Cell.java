package xxl.core;

import xxl.core.exception.ArrayCharException;
import xxl.core.exception.IntFailedException;


import java.io.Serializable;
import java.util.ArrayList;
import java.util.List;

public class Cell implements Serializable {
	private static final long serialVersionUID = 202310121845L;
    private Point _point;
    private Content _content;
    private List<Observer> _observers = new ArrayList<Observer>();

    public Cell(int row, int column, Content content){
        _point = new Point(row,column);
        _content = content;
        setmyCell();
    }
    public Cell(Cell cell){
        _point = cell._point.getPoint();
        _content = cell.getContent();
    }
    public void setmyCell(){
        _content.setCell(this);
    }
    public Cell getCell(){
        return new Cell(this);
    }

    public void setContent(Content content){
        _content = content;
        notifyObservers();
    }
    public void addObserver(Observer observer){
        _observers.add(observer);
    }
     void notifyObservers(){
        for(Observer observer : _observers){
            observer.update();
        }
    }
    public Content getContent(){
        return _content.getContent();
    }
    public String getPoint(){
        return _point.toString();
    }
    public int evalInt() throws ArrayCharException {
        return _content.evalInt();
    };
    public String evalString() throws IntFailedException {
        return _content.evalString();
    };
    public String toString(){
        if (_content==null){
            this.setContent(new NULL());
        }
        return String.valueOf(_point.getRow())+";"+String.valueOf(_point.getColumn())+"|"+_content.toString();
    }
    public int getRow(){
        return _point.getRow();
    }
    public int getColumn(){
        return _point.getColumn();
    }
    public void write(){

    }
}
