package xxl.core;

import xxl.app.exception.InvalidCellRangeException;
import xxl.core.exception.OutOfBoundsException;

import java.io.Serializable;
import java.util.ArrayList;
import java.util.List;
import java.util.concurrent.RecursiveTask;

public class CutBuffer implements Serializable { // Singleton
	private static final long serialVersionUID = 202310291023L;
    private static CutBuffer _instance;
    private List<Content> _content;
    private boolean _isRow;

    private CutBuffer(List<Content> content) {
        _content = content;
    }

    public static CutBuffer copy(Gama gama) throws OutOfBoundsException, InvalidCellRangeException {
        if (_instance == null)
            _instance = new CutBuffer(gama.getContents());
        else {
            _instance._content = gama.getContents();
        }
        _instance._isRow = gama.isRow();
        gama.getSpreadsheet().setGamaCutBuffer(gama);
        return _instance;
    }
    public static void delete(){
        if (_instance == null || _instance._content == null)
            _instance = new CutBuffer(null);
        else {
            _instance._content.clear();
        }
    }

    public static CutBuffer cut(Gama gama) throws OutOfBoundsException, InvalidCellRangeException {
        copy(gama);
        gama.clear();
        return _instance;
    }

    //
    private static void SingleCell(Gama gama) throws OutOfBoundsException, InvalidCellRangeException {
        try{
            if(_instance._isRow){
                for (int i = 0; i < _instance._content.size(); i++) {
                    gama.getSpreadsheet().getCell(gama.getBeginRow(),gama.getBeginColumn()+i).setContent(_instance._content.get(i));
                    if (gama.getSpreadsheet().getRepresentation().getWidth()+1 == gama.getBeginColumn()+i)
                        return;
                }
            } else {

                for (int i = 0; i < _instance._content.size(); i++) {
                    gama.getSpreadsheet().getCell(gama.getBeginRow()+i,gama.getBeginColumn()).setContent(_instance._content.get(i));
                    if (gama.getSpreadsheet().getRepresentation().getHeight()+1 == gama.getBeginRow()+i)
                        return;
                }
            }
        } catch (Exception e){
            return;
        }

    }
    private static void MultipleCell(Gama gama) throws OutOfBoundsException, InvalidCellRangeException {
        if (gama.getCells().size() !=_instance._content.size()) {
            return;
        }
        List<Cell> cells = gama.getCellsNoCopy();
        for (int i = 0; i < cells.size(); i++) {
            cells.get(i).setContent(_instance._content.get(i).getContent());
        }
    }

    //

    public static void paste(Gama gama) throws OutOfBoundsException, InvalidCellRangeException {
        if(_instance == null)
            return;
        else if (gama.getCells().size()==1){
            SingleCell(gama);
        }
        else{
            MultipleCell(gama);
        }
    }

    public static List<String> showCutBuffer() {
        List<String> showList = new ArrayList<>();
        StringBuilder temp = new StringBuilder();
        int i = 1;
        if (_instance._isRow) {
            for (Content content : _instance._content) {
                temp.append("1;").append(String.valueOf(i)).append("|");
                temp.append(content.toString());
                showList.add(String.valueOf(temp));
                i++;
                temp = new StringBuilder();
            }
        } else {
            for (Content content : _instance._content) {
                temp.append(String.valueOf(i)).append(";1").append("|");
                temp.append(content.toString());
                showList.add(String.valueOf(temp));
                i++;
                temp = new StringBuilder();
            }
        }
        return showList;
    }

}
