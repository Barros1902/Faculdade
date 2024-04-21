#pragma GCC diagnostic ignored "-Wunused-result"
#include <iostream>
#include <vector>
#include <cstring>  // For memset
using namespace std;

int rows, columns, num_pieces;
vector<vector<int>> matrix;

int recursiveFindValues(int currentRows, int currentColumns) {
    if (currentRows <= 0 || currentColumns <= 0) {
        return 0;
    }

    if (matrix[currentRows][currentColumns] != -1) {
        return matrix[currentRows][currentColumns];
    }

    int max_val = matrix[currentRows][currentColumns];

    for (int i = 1; i <= currentRows; ++i) {
        max_val = max(max_val, recursiveFindValues(i, currentColumns) + recursiveFindValues(currentRows - i, currentColumns));
    }

    for (int j = 1; j <= currentColumns; ++j) {
        max_val = max(max_val, recursiveFindValues(currentRows, j) + recursiveFindValues(currentRows, currentColumns - j));
    }

    matrix[currentRows][currentColumns] = max_val;

    return max_val;
}

int main() {
    scanf("%d%d%d", &rows, &columns, &num_pieces);
    matrix.resize(rows + 1, vector<int>(columns + 1, -1));

    for (int i = 0; i < num_pieces; i++) {
        int piece_rows, piece_columns, piece_price;
        scanf("%d%d%d", &piece_rows, &piece_columns, &piece_price);
        matrix[piece_rows][piece_columns] = piece_price;

        if (piece_rows <= columns && piece_columns <= rows) {
            matrix[piece_columns][piece_rows] = piece_price;
        }
    }

    int result = recursiveFindValues(rows, columns);
    printf("%d\n", result);

    return 0;
}