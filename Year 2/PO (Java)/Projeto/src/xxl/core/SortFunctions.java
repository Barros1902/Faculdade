package xxl.core;
import java.util.Comparator;

public class SortFunctions implements Comparator<Cell>{

	public int compare(Cell cell1, Cell cell2){
		
		if (cell1.getContent().getName().equals(cell2.getContent().getName())){
			if (cell1.getRow() == cell2.getRow())
				return cell1.getColumn() - cell2.getColumn();
			return cell1.getRow() - cell2.getRow();
		}
		return cell1.getContent().getName().compareTo(cell2.getContent().getName());
	}

	
}
