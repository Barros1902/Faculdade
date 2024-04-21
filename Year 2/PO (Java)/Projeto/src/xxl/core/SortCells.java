package xxl.core;
import java.util.Comparator;

public class SortCells implements Comparator<Cell>{

	public int compare(Cell cell1, Cell cell2){
		if (cell1.getRow() == cell2.getRow())
			return cell1.getColumn() - cell2.getColumn();
		return cell1.getRow() - cell2.getRow();

	}

	
}
