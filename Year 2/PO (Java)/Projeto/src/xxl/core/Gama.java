package xxl.core;

import xxl.app.exception.InvalidCellRangeException;
import xxl.core.exception.OutOfBoundsException;

import java.io.Serializable;
import java.util.ArrayList;
import java.util.List;

public class Gama implements Serializable{
	private static final long serialVersionUID = 202310131019L;

    private int BeginRow;
    private int BeginColumn;
    private int EndRow;
    private int EndColumn;
    private Spreadsheet _spreadsheet;
    public Gama(int beginRow, int beginColumn, int endRow, int endColumn, Spreadsheet spreadsheet){
        BeginRow = beginRow;
        BeginColumn = beginColumn;
        EndRow = endRow;
        EndColumn = endColumn;
        _spreadsheet = spreadsheet;
    }

    public boolean isRow(){
        return BeginRow==EndRow;
    }
    public int getBeginRow() {
        return BeginRow;
    }
    public int getBeginColumn() {
        return BeginColumn;
    }
    public String toString(){
        return BeginRow+";"+BeginColumn+":"+EndRow+";"+EndColumn;
    }
    public List<Cell> getCells() throws OutOfBoundsException, InvalidCellRangeException {
        // thing to do: check if the gama is a row or a column
        if(BeginRow!=EndRow && BeginColumn!=EndColumn){
            throw new InvalidCellRangeException(this.toString());
        }
        List<Cell> cells = new ArrayList<Cell>();
        for (int i = BeginRow; i <= EndRow; i++) {
            for (int j = BeginColumn; j <= EndColumn; j++) {
                cells.add(_spreadsheet.getCell(i,j).getCell());
            }
        }
        return cells;

    }
    public List<Cell> getCellsNoCopy() throws OutOfBoundsException, InvalidCellRangeException {
        // thing to do: check if the gama is a row or a column
        if(BeginRow!=EndRow && BeginColumn!=EndColumn){
            throw new InvalidCellRangeException(this.toString());
        }
        List<Cell> cells = new ArrayList<Cell>();
        for (int i = BeginRow; i <= EndRow; i++) {
            for (int j = BeginColumn; j <= EndColumn; j++) {
                cells.add(_spreadsheet.getCell(i,j));
            }
        }
        return cells;

    }

    public Gama copy(){
        return new Gama(BeginRow,BeginColumn,EndRow,EndColumn,_spreadsheet);
    }
    public List<Content> getContents() throws OutOfBoundsException, InvalidCellRangeException {
        List<Cell> cells;
        try {
            cells = getCells();
        } catch (InvalidCellRangeException e) {
            throw new InvalidCellRangeException(this.toString());
        }

        List<Content> contents = new ArrayList<>();
        for (Cell cell : cells) {
            contents.add(cell.getContent());
        }
        return contents;
    }

    public void clear() throws OutOfBoundsException, InvalidCellRangeException {
        List<Cell> cells;
        try {
            cells = getCellsNoCopy();
        } catch (InvalidCellRangeException e) {
            throw new InvalidCellRangeException(this.toString());
        }
        for (Cell cell : cells) {
            cell.setContent(new NULL());
        }
    }
    public Spreadsheet getSpreadsheet(){
        return _spreadsheet;
    }
}
