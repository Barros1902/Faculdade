package xxl.core;

import java.util.ArrayList;

import java.util.List;
import java.io.Serial;
import java.io.Serializable;

import xxl.core.exception.OutOfBoundsException;
import xxl.core.exception.UnrecognizedEntryException;

/**
 * Class representing a spreadsheet.
 */
public class Spreadsheet implements Serializable {
  @Serial
  private static final long serialVersionUID = 202308312359L;
  private String _name;
  private User _user;
  private Boolean _changed = false;
  private Gama gamaCutBuffer;
  private final Representation _representation;

  public Spreadsheet(int width, int height){
    _representation = new HashMap(width, height);
    if (gamaCutBuffer != null) {
      try{
        CutBuffer.copy(gamaCutBuffer);
      } catch (Exception e){

      }
    }
  }
  public void setActiveUser(User user){
    _user=user;
  }
  public void setGamaCutBuffer(Gama gama){
    gamaCutBuffer=gama;
  }
  public void SetName(String name){
    _name=name;
  }

  /**
   * Method to verify if the row and column are outside the bounds of specified spreadsheet.
   * if it isn't returns a exception
   * @param row the row of the cell to verify
   * @param column the column of the cell to verify
   *
   * */
  private void outOfBounds(int row, int column) throws OutOfBoundsException {
      if (_representation.outOfBounds(row, column)) {
            throw new OutOfBoundsException();
        }
    }
  /**
   * Method to get the content of a cell if the cells doesn't exist it will be created
   * @param row the row of the cell to get Content
   * @param column the column of the cell to get Content
   * @return Cell
   * @throws OutOfBoundsException if the row or column is out of bounds
   */
  public Cell getCell(int row, int column) throws OutOfBoundsException{
    outOfBounds(row, column);
    try {
      return _representation.getCell(row, column);
    } catch (Exception e) {
      _representation.setCell(row, column, new NULL());
      return _representation.getCell(row, column);
    }
  }

  /**
   * Method to get the Name of the spreadsheet
   * @return the name that the file will be saved
   * */
  public String getFileName(){
    return _name;
  }

  /**
   * Method to remove the content from the cell
   * @param row the row of the cell to remove Content
   * @param column the column of the cell to remove Content
   * @throws OutOfBoundsException if the row or column is out of bounds
   */
  public void removeContent(int row, int column) throws OutOfBoundsException{
    outOfBounds(row, column);
    _representation.removeContent(row, column);
  }

  /**
   * Insert specified content in specified Cell.
   *
   * @param row the row of the cell to insert Content
   * @param column the column of the cell to insert Content
   * @param content the content to insert
   *        in the specified cell.
   */
  public void insertContent(int row, int column, Content content) throws UnrecognizedEntryException /* FIXME maybe add exceptions */ {
    _representation.insertContent(row, column, content);
  }

  /**
   * Create a Gama with the input of user
   *
   * @param range a string with the start cell and end cell of the range
   *
   *
   */
  public Gama createRange(String range) throws OutOfBoundsException {
    String[] rangeCoordinates;
    int firstRow, firstColumn, lastRow, lastColumn;
	
    if (range.indexOf(':') != -1) {
      rangeCoordinates = range.split("[:;]");
      firstRow = Integer.parseInt(rangeCoordinates[0]);
      firstColumn = Integer.parseInt(rangeCoordinates[1]);
      lastRow = Integer.parseInt(rangeCoordinates[2]);
      lastColumn = Integer.parseInt(rangeCoordinates[3]);
    } else {
      rangeCoordinates = range.split(";");
      firstRow = lastRow = Integer.parseInt(rangeCoordinates[0]);
      firstColumn = lastColumn = Integer.parseInt(rangeCoordinates[1]);

    }

    return new Gama(firstRow, firstColumn, lastRow, lastColumn, this);
  }

  /**
   * Method to know if the spreadsheet was changed
   */
  public Boolean getChanged(){
	return _changed;
  }

    /**
     * Method to change the state of the spreadsheet
     */
  public void setChanged(Boolean state){
	_changed = state;
  }
  public boolean enoughSpace(Cell cell,int distance){
    int row = cell.getRow();
    int column = cell.getColumn();
    int width = _representation.getWidth();
    int height = _representation.getHeight();
    return row + distance < width || column + distance < height;

  }

  public Representation getRepresentation(){
	return _representation;
  }
}
