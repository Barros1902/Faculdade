package xxl.core;

import java.util.ArrayList;
import java.util.List;

import xxl.core.exception.IntFailedException;

import java.util.Collection;

public class HashMap extends Representation {
	
    private java.util.HashMap<List<Integer>,Cell> _map;
    public HashMap(int width, int height){
        super(width, height);
        _map = new java.util.HashMap<List<Integer>,Cell>();
    }
    /**
     * Sets the cell at the given position to the given content.
     * @param row row of the cell
     * @param column column of the cell
     * @param content content to be set
     * @throws IllegalArgumentException if row or column are out of bounds
     */
    public void setCell(int row, int column, Content content){
        if (row > getWidth() || column > getHeight() || row <= 0 || column <= 0) {
            throw new IllegalArgumentException("Out of bounds");
        }
        List<Integer> key = List.of(row,column);
        Cell cell = new Cell(row,column,content);
        _map.put(key,cell);
    }
    /**
     * Changes the content of the given cell to the given content.
     * @param cell cell to be changed
     * @param content content to be set
     */
    private void changeContentCell(Cell cell, Content content){
        cell.setContent(content);
    }
    /**
     * Returns the cell at the given position.
     * @param row row of the cell
     * @param column column of the cell
     * @return cell at the given position
     * @throws IllegalArgumentException if row or column are out of bounds
     */
    public Cell getCell(int row, int column){
        if (row > getWidth() || column > getHeight()) {
            throw new IllegalArgumentException("Out of bounds");
        }
        if (_map.get(List.of(row, column)) == null) {
            _map.put(List.of(row, column), new Cell(row, column, new NULL()));
        }
        return _map.get(List.of(row, column));
    }
    /**
     * Insert the content at the given cell.
     * @param row row of the cell
     * @param column column of the cell
     */
    @Override
    public void insertContent(int row, int column, Content content){
        if (getCell(row,column) != null) {
            changeContentCell(getCell(row,column),content);
        }else{
            setCell(row,column,content);
        }
    }
    /**
     * Remove the content at the given cell.
     * @param row row of the cell
     * @param column column of the cell
     */
    @Override
    public void removeContent(int row, int column){
        if (getCell(row,column) != null) {
            changeContentCell(getCell(row,column),new NULL());
        }
    }

	public List<Cell> ShowValues(String compareTo){
		List<Cell> cells = new ArrayList<Cell>();
		for(Cell cell : _map.values()){
			String[] conteudo = cell.getContent().toString().split("=");
			if(compareTo.equals(conteudo[0])){
				cells.add(cell);
			}

		}
		return cells;

		
	}
	public List<Cell> ShowFunctions(String compareTo){
		List<Cell> cells = new ArrayList<Cell>();
		FunctionSearcher searcher = new FunctionSearcher(compareTo); 
			for(Cell cell : _map.values()){
				
				cell.getContent().accept(searcher);
				if(searcher.getMatch()){
					cells.add(cell);
					searcher.setMacth(false);
				}
			}
		return cells;
	}
}
