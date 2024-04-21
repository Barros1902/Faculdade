#pragma GCC diagnostic ignored "-Wunused-result"
#include <stdio.h> // printf, scanf
#include <iostream> // cin cout
#include <list>
#include <vector>
using namespace std;
int rows, columns, num_pieces;
vector<vector<int>> matrix;
void findvalues(){
		for (int i = 1; i <= rows; ++i) {
			printf("%d %%", (i*100/rows));
			for (int j = 1; j <= columns; ++j) {
				int max_val = matrix[i][j];
				for (int k = 0; k < i/2 + 1; ++k) 
					max_val = max(max_val, matrix[k][j] + matrix[i - k][j]);
				for (int k = 0; k < j/2 + 1; ++k) 
					max_val = max(max_val, matrix[i][k] + matrix[i][j - k]);
				matrix[i][j] = max_val;
			}
		}
	}
int main(){
	scanf("%d%d%d", &rows, &columns, &num_pieces);
	matrix.resize(rows + 1, vector<int>(columns + 1, 0));
	for(int i = 0; i < num_pieces; i++){
		int piece_rows, piece_columns, piece_price;
		scanf("%d%d%d", &piece_rows, &piece_columns, &piece_price);
		if ( piece_rows <= rows && piece_columns <= columns)
			matrix[piece_rows][piece_columns] = piece_price;
		if ( piece_rows <= columns && piece_columns <= rows)
			matrix[piece_columns][piece_rows] = piece_price;
	}
	findvalues();
	printf("%d\n", matrix[rows][columns]);
	return 0;
}